# See LICENSE for details

import riscv_config.checker as riscv_config
from riscv_config.errors import ValidationError
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
        pytest_file = pwd + '/gen_framework.py'
        pytest.main(['-x', pyest_file, '-v', '--html=microtesk_gen.html', '--self-contained-html'])

    # generates the regress list from the generation
    @gen_hookimpl
    def post_gen(self, regress_list):
       print('post gen plugin')
