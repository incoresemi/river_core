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


def gen_cmd_list(regress_list):

    compile_command = 'riscv64-unknown-elf-gcc'
    compile_args =  '-static -mcmodel=medany -fvisibility=hidden -nostdlib -nostartfiles -DENTROPY=0x9629af2 -std=gnu99 -O2'
    abi = 'lp64'
    isa = 'rv64imafdc'
    logger.debug('gen plugin')
    pwd = os.getcwd()
    with open(regress_list, 'r') as rfile:
        rlist = yaml.safe_load(rfile)
    run_command = []
    testpath = rlist['microtesk']['microtesk_global_testpath']
    for test in rlist['microtesk']:
        test_match = re.match('microtesk_global_testpath', test)
        if not test_match:
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
            run_command.append(cmd)
            cmd = 'spike -l --isa={0} {1} &> {2}'.format(isa, elf, trace)
            run_command.append(cmd)
            cmd = 'riscv64-unknown-elf-objdump -D {0} > {1}'.format(elf, disass)
            run_command.append(cmd)
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
    program = request.param
    return sys_command(program)

def test_eval(test_input):
    assert test_input != 0


