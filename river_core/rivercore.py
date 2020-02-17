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
    
    plugin_name = 'river_core.microtesk_plugin.microtesk_plugin'
    plugin_module = importlib.import_module(plugin_name,'.')
    generatorpm.register(plugin_module.MicroTESKPlugin())
    #generatorpm.hook.load_config(isa='',platform='')
    # TODO: path should be gendir/plugin_type/plugin_name
    generatorpm.hook.pre_gen(gendir='./workdir/microtesk')
    generatorpm.hook.gen(gen_config='mirotesk_plugin/microtesk_gen_config.yaml')
    generatorpm.hook.post_gen(gendir='./workdir/microtesk',regressfile='workdir/regresslist.yaml')
    
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

