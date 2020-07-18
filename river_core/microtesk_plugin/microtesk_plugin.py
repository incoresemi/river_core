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
from glob import glob
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
    def gen(self, gen_config, jobs):
        logger.debug('plugin again')
        pwd = os.getcwd()
        pytest_file = pwd + '/river_core/microtesk_plugin/gen_framework.py'
        print(pytest_file)
        pytest.main([pytest_file, '-n={0}'.format(jobs), '-v', '--html=microtesk_gen.html', '--self-contained-html'])

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
            gendir_list = []
            for dir,_,_ in os.walk(gendir):
                gendir_list.extend(glob(os.path.join(dir, 'microtesk_*/*.S')))
            logger.debug('Generated S files:{0}'.format(gendir_list))
            testdir=''
            if len(gendir_list) == 0:
                testdir = gendir
            else:
                for gentest in gendir_list:
                    testdir = os.path.dirname(gentest)
                    testname = os.path.basename(gentest).replace('.S','')
                    ldname = os.path.basename(testdir)
                    test_gen_dir = '{0}/../{1}'.format(testdir, testname)
                    os.makedirs(test_gen_dir)
                    logger.debug('created {0}'.format(test_gen_dir))
                    sys_command('cp {0}/{1}.ld {2}'.format(testdir, ldname, test_gen_dir))
                    sys_command('mv {0}/{1}.log {2}'.format(testdir, testname, test_gen_dir))
                    sys_command('mv {0}/{1}.S {2}'.format(testdir, testname, test_gen_dir))
                    logger.debug('Removing directory: {0}'.format(testdir))
                    shutil.rmtree(testdir)

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

