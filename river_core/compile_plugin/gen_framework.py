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
import glob

run_cmd_list = dict()
pwd = os.getcwd() 

def gen_cmd_list(regress_list, compile_config):
    
    clist = dict()
    with open(compile_config, 'r') as cfile:
        clist = yaml.safe_load(cfile)
    
    logger.debug('gen plugin')
    with open(regress_list, 'r') as rfile:
        rlist = yaml.safe_load(rfile)
    run_command = []
    testpath = rlist['microtesk']['microtesk_global_testpath']
    
    for test in rlist['microtesk']:
        test_match = re.match('microtesk_global_testpath', test)
        if not test_match:

            run_cmd_list[test] = []
            testdir = testpath + '/' + test
            ld = testdir + '/' + rlist['microtesk'][test]['ld']
            testfile = testdir + '/' + rlist['microtesk'][test]['testname']
            elf = testdir + '/' + test + '.elf'
            disass = testdir + '/' + test + '.disass'
            trace = testdir + '/' + test + '.trace'
            cmd = ''
            remove_list = []
            remove_list = remove_list + glob.glob('{0}/*.elf'.format(testdir))
            remove_list = remove_list + glob.glob('{0}/*.disass'.format(testdir))
            remove_list = remove_list + glob.glob('{0}/*.dump'.format(testdir))
            remove_list = remove_list + glob.glob('{0}/code.mem'.format(testdir))
            remove_list = remove_list + glob.glob('{0}/STATUS_*'.format(testdir))

            for file in remove_list:
                run_cmd_list[test].append('sys_command(\'rm -rf {0}\')'.format(file))

            for order in clist['order']:
                if order == 'gcc':
                    cmd = '{0} -march={1} -mabi={2} {3} -T{4} {5} -o {6}'.format(clist['gcc']['command'], clist['isa'], 
                            clist['abi'], clist['gcc']['args'], ld, testfile, elf)
                    run_cmd_list[test].append('sys_command(\'{0}\')'.format(cmd))
                elif order == 'spike':
                    cmd = '{0} --isa={1} {2}'.format(clist['spike']['command'], clist['isa'], elf)
                    run_cmd_list[test].append('sys_command(\'{0}\')'.format(cmd))
                elif order == 'disass':
                    cmd = '{0} {1}'.format(clist['disass']['command'], elf)
                    run_cmd_list[test].append('sys_command_file(\'{0}\', \'{1}\')'.format(cmd, disass))
                elif order == 'elf2hex':
                    cmd = '{0} {1} {2} {3} {4}'.format(clist['elf2hex']['command'], 
                                                            clist['elf2hex']['args'][0], 
                                                            clist['elf2hex']['args'][1], 
                                                            elf,
                                                            clist['elf2hex']['args'][2], 
                                                            )
                    run_cmd_list[test].append('sys_command_file(\'{0}\', \'code.mem\')'.format(cmd))
                else:
                    if 'out_file' in clist[order]:
                        cmd = clist[order]['command']
                        run_cmd_list[test].append('sys_command_file(\'{0}\', \'{1}\')'.format(cmd, clist[order]['out_file']))
                    else:
                        cmd = clist[order]['command']
                        run_cmd_list[test].append('sys_command(\'{0}\')'.format(cmd))
               
                logger.debug('Running {0}'.format(cmd))
            
            run_command.append(test)
    return run_command

def idfnc(val):
  return val

def pytest_generate_tests(metafunc):

    if 'test_input' in metafunc.fixturenames:
        test_list = gen_cmd_list(
                                        metafunc.config.getoption("regresslist"),
                                        metafunc.config.getoption("compileconfig")
                                    )
        metafunc.parametrize('test_input', test_list,
                ids=idfnc,
                indirect=True)

def  run_list(cmd_list):
    result = 0
    for i in range(len(cmd_list)):
        result, out, err = eval(cmd_list[i])
        if result:
            cmd = cmd_list[i]
            if re.search('-gcc', cmd):
                sys_command('touch STATUS_FAIL_COMPILE')
            elif re.search('spike ', cmd):
                sys_command('touch STATUS_FAIL_MODEL')
            else:
                sys_command('touch STATUS_FAIL_STEPS')
            return 1
    return result

@pytest.fixture
def test_input(request):
    # compile tests
    os.chdir(pwd)
    program = request.param
    os.chdir('{0}/workdir/{1}'.format(os.getcwd(), program))
    if not run_list(run_cmd_list[program]):
        if filecmp.cmp('rtl.dump', 'spike.dump'):
            logger.debug('PASSED')
            sys_command('touch STATUS_PASSED')
            return 0
        else:
            logger.debug('FAILED')
            sys_command('touch STATUS_FAILED')
            return 1
    else:
        return 1

def test_eval(test_input):
    assert test_input == 0


