# See LICENSE for details

#import riscv_config.checker as riscv_config
#from riscv_config.errors import ValidationError
import os
import sys
import pluggy
import shutil
import yaml
import random
import re
import datetime
import pytest

from river_core.log import logger
from river_core.utils import *

gen_hookimpl = pluggy.HookimplMarker("generator")


class MicroTESKPlugin(object):
    """ Generator hook implementation """

    isa = 'rv64imafdc'

    #@gen_hookimpl
    #def load_config(self, isa, platform):
    #    pwd = os.getcwd()

    #    try:
    #        isa_file, platform_file = riscv_config.check_specs(
    #                                    isa, platform, pwd, True)
    #    except ValidationError as msg:
    #        #logger.error(msg)
    #        print('error')
    #        sys.exit(1)

    # creates gendir and any setup related things
    @gen_hookimpl
    def pre_gen(self, gendir):
        if(os.path.isdir(gendir)):
            logger.debug('exists')
            shutil.rmtree(gendir, ignore_errors=True)
        os.makedirs(gendir)

    # gets the yaml file with list of configs; test count; parallel
    # isa is obtained from riscv_config
    @gen_hookimpl
    def gen(self, gen_config):
        logger.debug('plugin again')
        pwd = os.getcwd()
        pytest_file = pwd + '/river_core/microtesk_plugin/gen_framework.py'
        print(pytest_file)
        pytest.main(['-x', pytest_file, '-v', '--html=microtesk_gen.html', '--self-contained-html'])

    # generates the regress list from the generation
    @gen_hookimpl
    def post_gen(self, gendir, regressfile):
      test_dict = dict()
      test_files = []
      test_file = ''
      ld_file = ''
      test_dict['microtesk'] = {}
      """
      Overwrites the microtesk entries in the regressfile with the latest present in the gendir
      """
      if os.path.isdir(gendir):
        testdirs = os.listdir(gendir)
        test_dict['microtesk']['microtesk_global_testpath'] = gendir
        for testdir in testdirs:
          test_dict['microtesk'][testdir] = {'testname': '', 'ld': ''}
          testpath = gendir + '/' + testdir
          tests = os.listdir(testpath)
          for file in tests:
            name  = testpath + '/' + file
            if name.endswith('.S'):
              test_dict['microtesk'][testdir]['testname'] = file
            elif name.endswith('.ld'):
              test_dict['microtesk'][testdir]['ld'] = file

        if os.path.isfile(regressfile):
          with open(regressfile, 'r') as rgfile:
            testlist = yaml.safe_load(rgfile)
            testlist['microtesk'].update(test_dict)
          rgfile.close()

        rgfile = open(regressfile, 'w')

        print(test_dict)
        yaml.safe_dump(test_dict, rgfile, default_flow_style=False)

