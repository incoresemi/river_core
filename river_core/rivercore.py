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
import riscv_config.checker as riscv_config
from riscv_config.errors import ValidationError
from envyaml import EnvYAML

def rivercore(verbose, dir, env, jobs, suite, generate, compile, clean, filter, seed, count, norun):

    logger.level(verbose)
    logger.info('****** RiVer Core {0} *******'.format(__version__ ))
    logger.info('Copyright (c) 2020, InCore Semiconductors Pvt. Ltd.')
    logger.info('All Rights Reserved.')
    logger.info('*****************************'.format(__version__ ))
    
    cwd = os.getcwd()
    output_dir = os.environ['OUTPUT_DIR']

    #logger.info('Validating DUT Spec using RISCV_CONFIG')
    #env_yaml = EnvYAML(env)
    #with open(env) as fh:
    #    env_list = yaml.safe_load(fh)
    #try:
    #    isa_file, platform_file = riscv_config.check_specs(
    #        env_yaml['isa'], env_yaml['platform'], output_dir, True)
    #    logger.info('Checking DUT Spec Successful!')
    #except ValidationError as msg:
    #    print(msg)
    #    return 1

    if clean:
        sys_command('rm -rf {0}/{1}/*'.format(output_dir, suite))

    if generate:
        generatorpm = pluggy.PluginManager("generator")
        generatorpm.add_hookspecs(RandomGeneratorSpec)

        generatorpm_name = 'river_core.{0}_plugin.{0}_plugin'.format(suite)
        generatorpm_module = importlib.import_module(generatorpm_name,'{0}'.format(root))
        
        if suite == 'microtesk':
            generatorpm.register(generatorpm_module.MicroTESKPlugin())
        if suite == 'aapg':
            generatorpm.register(generatorpm_module.AapgPlugin())
        if suite == 'dv':
            generatorpm.register(generatorpm_module.RiscvDvPlugin())
            
        generatorpm.hook.pre_gen(gendir='{0}/{1}'.format(output_dir, suite))
        generatorpm.hook.gen(gen_config='{0}/{1}_plugin/{1}_gen_config.yaml'.format(root, suite), jobs=jobs, filter=filter, seed=seed, count=count, norun=norun)
        generatorpm.hook.post_gen(gendir='{0}/{1}'.format(output_dir, suite),regressfile='{0}/{1}/regresslist.yaml'.format(output_dir, suite))

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
        compilepm_module = importlib.import_module(compilepm_name, '{0}'.format(root))
        compilepm.register(compilepm_module.CompilePlugin())
        compilepm.hook.pre_compile(compile_config='{0}/compile_plugin/compile_config.yaml'.format(root))
        compilepm.hook.compile(suite=suite, regress_list='{0}/{1}/regresslist.yaml'.format(output_dir, suite), compile_config='{0}'.format(compile), command_line_args='', jobs=jobs, norun=norun, filter=filter)
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



