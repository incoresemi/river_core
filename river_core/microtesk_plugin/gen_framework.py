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

  ## schema validator should be here
  jobs = 1
  count = 1
  out = ''
  seed = 0
  command = ''
  config_path = ''
  args = ''
  run_command = []
  for key, value in gen_list.items():
    if key == 'global_home':
      os.environ['MICROTESK_HOME'] = gen_list[key]
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
    if key == 'global_seed':
      if gen_list[key] != 'random':
        seed = gen_list[key]
    if key == 'global_jobs':
      jobs = gen_list[key]
    if key == 'global_count':
      count = gen_list[key]
    
    if not re.search('^global_', key):
      config_file_path = config_path +  '/' + gen_list[key]['path']
      logger.debug(key)
      for i in range(count):
        if gen_list['global_seed'] == 'random':
          gen_seed = random.randint(0, 10000)
        else:
          gen_seed = gen_list['global_seed']
        
        now = datetime.datetime.now()
        gen_prefix = '{0}_{1:04}_{2}'.format(key, gen_seed, now.strftime('%d%m%Y%H%M%S%f'))
        logger.debug(run_command)
        run_command.append('{0} {1}/{2}.rb --output-dir {3}/{5} --random-seed {4} --code-file-prefix {5} --code-file-extension S'.format(command, config_file_path, key, dirname, gen_seed, gen_prefix ))
  return run_command

#tlist = gen_cmd_list('/scratch/river_development/microtesk_templates/microtesk_gen_config.yaml')
#print(tlist)

def idfnc(val):
  template_match = re.search('riscv (.*).rb', '{0}'.format(val))
  logger.debug('0'.format(val))
  return 'Generating {1}'.format(val, template_match.group(1))

def pytest_generate_tests(metafunc):
    if 'test_input' in metafunc.fixturenames:
        riscv_test_list = gen_cmd_list('./river_core/microtesk_plugin/microtesk_gen_config.yaml')
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

