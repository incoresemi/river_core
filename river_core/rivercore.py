# See LICENSE file for details
import sys
import os
import shutil
import yaml
import importlib

from river_core.log import *
from river_core.utils import *
from river_core.constants import *
from river_core.__init__ import __version__
from river_core.sim_hookspecs import *

def rivercore(verbose, dir, clean, simenv):

    logger.level(verbose)
    logger.info('****** RiVer Core {0} *******'.format(__version__ ))
    logger.info('Copyright (c) 2020, InCore Semiconductors Pvt. Ltd.')
    logger.info('All Rights Reserved.')

    # Generator plugin manager
    generatorpm = pluggy.PluginManager("generator")
    generatorpm.add_hookspecs(RandomGeneratorSpec)

    cwd = os.getcwd()
    generatorpm_name = 'river_core.microtesk_plugin.microtesk_plugin'
    generatorpm_module = importlib.import_module(generatorpm_name,'.')
    generatorpm.register(generatorpm_module.MicroTESKPlugin())
    generatorpm.hook.pre_gen(gendir='{0}/workdir/microtesk'.format(cwd))
    generatorpm.hook.gen(gen_config='mirotesk_plugin/microtesk_gen_config.yaml') 
    generatorpm.hook.post_gen(gendir='{0}/workdir'.format(cwd),regressfile='{0}/workdir/regresslist.yaml'.format(cwd))


    # Compile plugin manager
    compilepm = pluggy.PluginManager('compile')
    compilepm.add_hookspecs(CompileSpec)

    compilepm_name = 'river_core.compile_plugin.compile_plugin'
    compilepm_module = importlib.import_module(compilepm_name, '.')
    compilepm.register(compilepm_module.CompilePlugin())
    compilepm.hook.pre_compile(compile_config='{0}/river_core/compile_plugin/compile_config.yaml'.format(cwd))
    compilepm.hook.compile(regress_list='{0}/workdir/regresslist.yaml'.format(cwd), command_line_args='')
    compilepm.hook.post_compile()


    ## Model plugin manager
    #modelpm = pluggy.PluginManager("model")
    #modelpm.add_hookspecs(ModelSpec)
    #
    #plugin_name = 'spike_plugin'
    #plugin_module = importlib.import_module(plugin_name,'.')
    #modelpm.register(plugin_module.SpikePlugin())
    ##modelpm.hook.load_config(isa='',platform='')
    #modelpm.hook.load_elf(test_elf='/scratch/lavanya/gitlab/shakti/verification_environment/cclass-verif/sim/output/test_0000.elf')
    #modelpm.hook.get_state()
    #modelpm.hook.step(count=10)
    #modelpm.hook.get_state()

