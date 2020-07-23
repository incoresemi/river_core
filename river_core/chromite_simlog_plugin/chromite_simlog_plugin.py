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


class ChromiteSimLogPlugin(object):
    """ Test Compiling hook implementation """

    isa = 'rv64imafdc'
    abi = 'lp64'
    compile_command = ''
    compile_args = ''
    def pytest_addoption(parser):
        parser.addoption("--test_input", action="append", default=[],
            help="list of cmds to pass to pytest")


    def idfnc(val):
      return val

    def pytest_generate_tests(metafunc):
        if 'test_input' in metafunc.fixturenames:
            metafunc.parametrize('test_input', cmdlist,
                    ids=idfnc,
                    indirect=True)

    @pytest.fixture
    def test_input(request):
        # compile tests
        program = request.param
        return utils.sys_command(program)

    def test_eval(test_input):
        assert test_input != 0

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
            #self.compile_command = cconfig['global_command']
            #self.compile_args = cconfig['global_args']

    @compile_hookimpl
    def compile(self, regress_list, command_line_args, jobs, filter):
        logger.debug('compile')
        pwd = os.getcwd()
        pytest_file = pwd + '/river_core/chromite_simlog_plugin/gen_framework.py'
        print(pytest_file)

        #pytest.main([pytest_file, '-n={0}'.format(jobs), '--addopts=--filter={0}'.format(filter), '-v', '--html=microtesk_compile.html', '--self-contained-html'])
        pytest.main([pytest_file, '-n={0}'.format(jobs), '-v', '--html=microtesk_compile.html', '--self-contained-html'])



    @compile_hookimpl
    def post_compile(self):
        logger.debug('post compile')



