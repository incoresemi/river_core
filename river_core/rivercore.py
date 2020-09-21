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

def rivercore(verbose, dir, jobs, generate, compile, clean, filter, norun):

    logger.level(verbose)
    logger.info('****** RiVer Core {0} *******'.format(__version__ ))
    logger.info('Copyright (c) 2020, InCore Semiconductors Pvt. Ltd.')
    logger.info('All Rights Reserved.')
    cwd = os.getcwd()

    if clean:
        sys_command('rm -rf workdir/*')

    if generate == 'microtesk':

        # MicroTESK Generator plugin manager
        generatorpm = pluggy.PluginManager("generator")
        generatorpm.add_hookspecs(RandomGeneratorSpec)

        generatorpm_name = 'river_core.microtesk_plugin.microtesk_plugin'
        generatorpm_module = importlib.import_module(generatorpm_name,'.')
        generatorpm.register(generatorpm_module.MicroTESKPlugin())
        generatorpm.hook.pre_gen(gendir='{0}'.format(os.environ['OUTPUT_DIR']))
        generatorpm.hook.gen(gen_config='{0}/microtesk_plugin/microtesk_gen_config.yaml'.format(root), jobs=jobs, filter=filter, norun=norun)
        generatorpm.hook.post_gen(gendir='{0}'.format(os.environ['OUTPUT_DIR']),regressfile='{0}/regresslist.yaml'.format(os.environ['OUTPUT_DIR']))

    if generate == 'dv':
        # RISCV-DV Generator plugin manager
        generatorpm = pluggy.PluginManager("generator")
        generatorpm.add_hookspecs(RandomGeneratorSpec)

        generatorpm_name = 'river_core.riscv_dv_plugin.riscv_dv_plugin'
        generatorpm_module = importlib.import_module(generatorpm_name,'.')
        generatorpm.register(generatorpm_module.RiscvDvPlugin())
        #generatorpm.hook.pre_gen(gendir='{0}/workdir/'.format(cwd))
        #generatorpm.hook.gen(gen_config='{0}/river_core/riscv_dv_plugin/riscv_dv_gen_config.yaml'.format(cwd), jobs=jobs, filter=filter, norun=norun)
        generatorpm.hook.post_gen(gendir='{0}/workdir'.format(cwd),regressfile='{0}/workdir/regresslist.yaml'.format(cwd))

    if generate == 'aapg':
        # AAPG Generator plugin manager
        generatorpm = pluggy.PluginManager("generator")
        generatorpm.add_hookspecs(RandomGeneratorSpec)

        generatorpm_name = 'river_core.aapg_plugin.aapg_plugin'
        generatorpm_module = importlib.import_module(generatorpm_name,'.')
        generatorpm.register(generatorpm_module.AapgPlugin())
        generatorpm.hook.pre_gen(gendir='{0}/workdir/'.format(cwd))
        generatorpm.hook.gen(gen_config='{0}/river_core/aapg_plugin/aapg_gen_config.yaml'.format(cwd), jobs=jobs, filter=filter, norun=norun)
        generatorpm.hook.post_gen(gendir='{0}/workdir'.format(cwd),regressfile='{0}/workdir/regresslist.yaml'.format(cwd))

    if compile != '':

        # Compile plugin manager
        #compilepm = pluggy.PluginManager('compile')
        #compilepm.add_hookspecs(CompileSpec)

        #compilepm_name = 'river_core.cclass_plugin.compile_plugin'
        #compilepm_module = importlib.import_module(compilepm_name, '.')
        #compilepm.register(compilepm_module.CompilePlugin())
        #compilepm.hook.pre_compile(compile_config='{0}/river_core/cclass_plugin/compile_config.yaml'.format(cwd))
        #compilepm.hook.compile(regress_list='{0}/workdir/regresslist.yaml'.format(cwd), command_line_args='', jobs=jobs, filter=filter)
        #compilepm.hook.post_compile()

        compilepm = pluggy.PluginManager('compile')
        compilepm.add_hookspecs(CompileSpec)

        compilepm_name = 'river_core.compile_plugin.compile_plugin'
        compilepm_module = importlib.import_module(compilepm_name, '.')
        compilepm.register(compilepm_module.CompilePlugin())
        compilepm.hook.pre_compile(compile_config='{0}/river_core/compile_plugin/compile_config.yaml'.format(cwd))
        compilepm.hook.compile(regress_list='{0}/workdir/regresslist.yaml'.format(cwd), compile_config='{0}'.format(compile), command_line_args='', jobs=jobs, norun=norun, filter=filter)
        compilepm.hook.post_compile()

        ## Chromite Compile plugin manager
        #compilepm = pluggy.PluginManager('compile')
        #compilepm.add_hookspecs(CompileSpec)

        ##compilepm_name = 'river_core.compile_plugin.compile_plugin'
        #compilepm_name = 'river_core.chromite_simlog_plugin.chromite_simlog_plugin'
        #compilepm_module = importlib.import_module(compilepm_name, '.')
        #compilepm.register(compilepm_module.ChromiteSimLogPlugin())
        #compilepm.hook.pre_compile(compile_config='{0}/river_core/chromite_simlog_plugin/chromite_config.yaml'.format(cwd))
        #compilepm.hook.compile(regress_list='{0}/workdir/regresslist.yaml'.format(cwd), command_line_args='', jobs=jobs, filter=filter)
        #compilepm.hook.post_compile()


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

