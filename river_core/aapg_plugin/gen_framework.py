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


def gen_cmd_list(gen_config):

    logger.debug('gen plugin')
    pwd = os.getcwd()
    with open(gen_config) as fh:
        gen_list = yaml.safe_load(fh)
    print(gen_list)
#    ## schema validator should be here
#    jobs = 1
#    count = 1
#    out = ''
#    seed = 0
#    command = ''
#    config_path = ''
#    args = ''
    setup_dir = ''
    run_command = []
    for key, value in gen_list.items():
        if key == 'global_config_path':
            config_path = gen_list[key]
        if key == 'global_command':
            command = 'bash {0}/bin/{1}'.format(gen_list['global_home'],gen_list[key])
        if key == 'global_args':
            args =  gen_list[key]
        if key == 'global_output':
            dirname = gen_list[key]
            if(os.path.isdir(dirname)):
                shutil.rmtree(dirname, ignore_errors=True)
            os.makedirs(dirname)
            sys_command('aapg setup --setup_dir {0}'.format(dirname))
            setup_dir = dirname
        if key == 'global_seed':
            if gen_list[key] != 'random':
                seed = gen_list[key]
            else:
                seed = 'random'
        if key == 'global_jobs':
            jobs = gen_list[key]
        if key == 'global_count':
            count = gen_list[key]

        if not re.search('^global_', key):
            config_file_path = config_path +  '/' + gen_list[key]['path']
            logger.debug(key)
            config_file = config_file_path + '/' + key + '.yaml'

            logger.debug(config_file)
            template_name = os.path.basename(config_file)
            
            for i in range(count):
                if seed == 'random':
                    gen_seed = random.randint(0, 10000)
                else:
                    gen_seed = seed
            
                now = datetime.datetime.now()
                gen_prefix = '{0:04}_{1}'.format(gen_seed, now.strftime('%d%m%Y%H%M%S%f'))
                test_prefix = 'aapg_{0}_{1}_{2}'.format(template_name.replace('.yaml', ''), gen_prefix, i)
                testdir = '{0}/{1}'.format(dirname,test_prefix)
                #run_command.append('aapg gen --setup_dir  --config_file {0} --output_dir {1}'.format(config_file, testdir))
                run_command.append('aapg gen \
                                    --config_file {0} \
                                    --setup_dir {1} \
                                    --output_dir {2} \
                                    --asm_name {3} \
                                    --seed {4}\
                                    '.format(config_file, setup_dir, testdir, test_prefix, gen_seed))

    return run_command

#tlist = gen_cmd_list('/scratch/river_development/microtesk_templates/microtesk_gen_config.yaml')
#print(tlist)

def idfnc(val):
  template_match = re.search('--config_file (.*).yaml', '{0}'.format(val))
  logger.debug('0'.format(val))
  return 'Generating {0}'.format(template_match.group(1))

def pytest_generate_tests(metafunc):
    if 'test_input' in metafunc.fixturenames:
        test_list = gen_cmd_list(metafunc.config.getoption("configlist"))
        metafunc.parametrize('test_input', test_list,
                ids=idfnc,
                indirect=True)

@pytest.fixture
def test_input(request, autouse=True):
    # compile tests
    program = request.param
    template_match = re.search('--config_file (.*).yaml', program)
    #sys_command(program)
    #return 0
    if os.path.isfile('{0}.yaml'.format(template_match.group(1))):
        sys_command(program)
        return 0
    else:
        logger.error('File not found {0}'.format(template_match.group(1)))
        return 1

def test_eval(test_input):
    assert test_input == 0


