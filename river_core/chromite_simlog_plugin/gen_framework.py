# See LICENSE for details

import os
import sys
import pluggy
import shutil
import yaml
from river_core.log import logger
from river_core.utils import *
import random
import re
import datetime
import pytest
import filecmp

run_cmd_list = dict()
pwd = os.getcwd() 

def gen_cmd_list(regress_list):

    compile_command = 'riscv64-unknown-elf-gcc'
    compile_args =  '-static -mcmodel=medany -fvisibility=hidden -nostdlib -nostartfiles -DENTROPY=0x9629af2 -std=gnu99 -O2'
    abi = 'lp64'
    isa = 'rv64imafdc'
    logger.debug('gen plugin')
    with open(regress_list, 'r') as rfile:
        rlist = yaml.safe_load(rfile)
    run_command = []
    testpath = rlist['microtesk']['microtesk_global_testpath']
    for test in rlist['microtesk']:
        test_match = re.match('microtesk_global_testpath', test)
        if not test_match:
            run_cmd_list[test] = dict()
            testdir = testpath + '/' + test
            ld = testdir + '/' + rlist['microtesk'][test]['ld']
            testfile = testdir + '/' + rlist['microtesk'][test]['testname']
            elf = testdir + '/' + test + '.elf'
            disass = testdir + '/' + test + '.disass'
            trace = testdir + '/' + test + '.trace'
            cmd = '{0} -march={1} -mabi={2} {3} -T{4} {5} -o {6}'.format(compile_command, isa,
                                                    abi, compile_args, ld,
                                                    testfile, elf)
            logger.debug(cmd)
            run_cmd_list[test]['gcc'] = cmd 
            cmd = 'spike -c --isa={0} {1}'.format(isa, elf, trace)
            run_cmd_list[test]['spike'] = cmd 
            cmd = 'riscv64-unknown-elf-objdump -D {0} > {1}'.format(elf, disass)
            run_cmd_list[test]['disass'] = cmd 
            run_command.append(test)
    return run_command

#tlist = gen_cmd_list('/scratch/river_development/microtesk_templates/microtesk_gen_config.yaml')
#print(tlist)

def idfnc(val):
  return val

def pytest_generate_tests(metafunc):
    if 'test_input' in metafunc.fixturenames:
        riscv_test_list = gen_cmd_list('./workdir/regresslist.yaml')
        metafunc.parametrize('test_input', riscv_test_list,
                ids=idfnc,
                indirect=True)

@pytest.fixture
def test_input(request):
    # compile tests
    os.chdir(pwd)
    program = request.param
    os.chdir('{0}/workdir/{1}'.format(os.getcwd(), program))
    sys_command(run_cmd_list[program]['gcc'])
    sys_command(run_cmd_list[program]['spike'])
    sys_command_file(run_cmd_list[program]['disass'], '{0}.disass'.format(program))
    sys_command_file('elf2hex 8 4194304 {0}.elf 2147483648'.format(program), 'code.mem')
    sys_command('ln -sf {0}/chromite_core .'.format(os.environ['BIN_PATH']))
    sys_command('ln -sf {0}/boot.mem .'.format(os.environ['BIN_PATH']))
    sys_command('./chromite_core +rtldump', 60)
    sys_command_file('head -n -4 rtl.dump','temp.dump')
    sys_command('mv temp.dump rtl.dump')
    if filecmp.cmp('rtl.dump', 'spike.dump'):
        logger.debug('PASSED')
        sys_command('touch PASSED')
        return 0
    else:
        logger.debug('FAILED')
        sys_command('touch FAILED')
        return 1

def test_eval(test_input):
    assert test_input == 0


