# See LICENSE for details

# import riscv_config.checker as riscv_config
# from riscv_config.errors import ValidationError
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

compile_hookimpl = pluggy.HookimplMarker('compile')


class CompilePlugin(object):
    """ Test Compiling hook implementation """

    isa = 'rv64imafdc'
    abi = 'lp64'
    compile_command = ''
    compile_args = ''

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
    @compile_hookimpl
    def pre_compile(self, compile_config):
        logger.debug('pre compile')
        with open(compile_config, 'r') as cfile:
            cconfig = yaml.safe_load(cfile)
            self.compile_command = cconfig['global_command']
            self.compile_args = cconfig['global_args']

    @compile_hookimpl
    def compile(self, regress_list, compile_config, command_line_args, jobs, filter, norun):
        logger.debug('compile')
        pwd = os.getcwd()
        pytest_file = pwd + '/river_core/compile_plugin/gen_framework.py'
        logger.debug(pytest_file)
        if norun:
            # to display test items
            pytest.main([pytest_file, '--collect-only', '-n={0}'.format(jobs), '-k={0}'.format(filter), '--regresslist={0}'.format(regress_list), '-v', '--compileconfig={0}'.format(compile_config), '--html=compile.html', '--self-contained-html'])
        else:
            pytest.main([pytest_file, '-n={0}'.format(jobs), '-k={0}'.format(filter), '--regresslist={0}'.format(regress_list), '-v', '--compileconfig={0}'.format(compile_config), '--html=compile.html', '--self-contained-html'])
        

    @compile_hookimpl
    def post_compile(self):
        logger.debug('post compile')



