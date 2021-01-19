# See LICENSE file for details
import sys
import os
import shutil
import yaml
import importlib
import configparser

from river_core.log import *
from river_core.utils import *
from river_core.constants import *
from river_core.__init__ import __version__
from river_core.sim_hookspecs import *
import riscv_config.checker as riscv_config
from riscv_config.errors import ValidationError
from envyaml import EnvYAML


def rivercore_clean(config_file, output_dir):

    config = configparser.ConfigParser()
    config.read(config_file)
    verbose = config['default']['verbosity']
    logger.level(verbose)
    logger.info('****** RiVer Core {0} *******'.format(__version__))
    logger.info('****** Cleaning Mode ****** ')
    logger.info('Copyright (c) 2021, InCore Semiconductors Pvt. Ltd.')
    logger.info('All Rights Reserved.')


    # sys_command('rm -rf {0}/{1}/*'.format(output_dir, suite))
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


def rivercore_generate(config_file, output_dir):

    config = configparser.ConfigParser()
    config.read(config_file)
    logger.debug('Read file from {0}'.format(config_file))
    verbose = config['default']['verbosity']

    logger.level(verbose)
    logger.info('****** RiVer Core {0} *******'.format(__version__))
    logger.info('****** Generation Mode ****** ')
    logger.info('Copyright (c) 2021, InCore Semiconductors Pvt. Ltd.')
    logger.info('All Rights Reserved.')

    # TODO Test multiple plugin cases
    # Current implementation is using for loop, which might be a bad idea for parallel processing.

    suite_list = config['default']['suite'].split(',')
    for suite in suite_list:

    # output_dir = os.environ['OUTPUT_DIR']

        generatorpm = pluggy.PluginManager("generator")
        generatorpm.add_hookspecs(RandomGeneratorSpec)

        path_to_module = config['default']['path_to_suite']
        plugin_suite = suite+'_plugin'
        logger.info('Now loading {0} Suite'.format(suite))
        # Using spec and exec_module as it allows usage of full path
        # https://docs.python.org/3/library/importlib.html#importing-a-source-file-directly 
        abs_location_module = path_to_module+'/'+plugin_suite+'/'+plugin_suite+'.py'
        logger.debug("Loading module from {0}".format(abs_location_module))
        # generatorpm_name = 'river_core.{0}_plugin.{0}_plugin'.format(suite)
        try:
            generatorpm_spec=importlib.util.spec_from_file_location(plugin_suite,abs_location_module)
            generatorpm_module = importlib.util.module_from_spec(generatorpm_spec)
            generatorpm_spec.loader.exec_module(generatorpm_module)

        except FileNotFoundError as txt:
            logger.error(suite+" not found at : "+path_to_module+".\n"+str(txt))
            raise SystemExit

        if suite == 'microtesk':
            generatorpm.register(generatorpm_module.MicroTESKPlugin())
        if suite == 'aapg':
            generatorpm.register(generatorpm_module.AapgPlugin())
        if suite == 'dv':
            generatorpm.register(generatorpm_module.RiscvDvPlugin())

        # Plugin specific details
        jobs = config[suite]['jobs']
        seed = config[suite]['seed']
        count = config[suite]['count']
        filter = config[suite]['filter']


        generatorpm.hook.pre_gen(gendir='{0}/{1}'.format(output_dir, suite))
        generatorpm.hook.gen(gen_config='{0}/{1}_plugin/{1}_gen_config.yaml'.format(
            path_to_module, suite),
                            jobs=jobs,
                            filter=filter,
                            seed=seed,
                            count=count,
                            output_dir=output_dir,
                            module_dir=path_to_module)
        generatorpm.hook.post_gen(gendir='{0}/{1}'.format(output_dir, suite),
                                regressfile='{0}/{1}/regresslist.yaml'.format(
                                    output_dir, suite))


def rivercore_compile(config, output_dir):

    logger.level(verbose)
    logger.info('****** RiVer Core {0} *******'.format(__version__))
    logger.info('Copyright (c) 2021, InCore Semiconductors Pvt. Ltd.')
    logger.info('All Rights Reserved.')

    logger.info('****** Compilation Mode ****** ')
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
    compilepm_module = importlib.import_module(compilepm_name,
                                               '{0}'.format(root))
    compilepm.register(compilepm_module.CompilePlugin())
    compilepm.hook.pre_compile(
        compile_config='{0}/compile_plugin/compile_config.yaml'.format(root))
    compilepm.hook.compile(suite=suite,
                           regress_list='{0}/{1}/regresslist.yaml'.format(
                               output_dir, suite),
                           compile_config='{0}'.format(compile),
                           command_line_args='',
                           jobs=jobs,
                           norun=norun,
                           filter=filter)
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
