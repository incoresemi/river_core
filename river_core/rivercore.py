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


def rivercore_clean(config_file, output_dir, verbosity):
    '''
        Alpha
        Work in Progress

    '''

    config = configparser.ConfigParser()
    config.read(config_file)
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


def rivercore_generate(config_file, output_dir, verbosity):
    '''
        Function to generate the assembly programs using the plugin as configured in the config.ini.

        :param config_file: Config.ini file for generation

        :param output_dir: Output directory for programs generated

        :param verbosity: Verbosity level for the framework

        :type config_file: click.Path

        :type output_dir: click.Path

        :type verbosity: str
    '''

    logger.level(verbosity)
    config = configparser.ConfigParser()
    config.read(config_file)
    logger.debug('Read file from {0}'.format(config_file))

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
        plugin_suite = suite + '_plugin'
        logger.info('Now loading {0} Suite'.format(suite))
        # Using spec and exec_module as it allows usage of full path
        # https://docs.python.org/3/library/importlib.html#importing-a-source-file-directly
        abs_location_module = path_to_module + '/' + plugin_suite + '/' + plugin_suite + '.py'
        logger.debug("Loading module from {0}".format(abs_location_module))
        # generatorpm_name = 'river_core.{0}_plugin.{0}_plugin'.format(suite)
        try:
            generatorpm_spec = importlib.util.spec_from_file_location(
                plugin_suite, abs_location_module)
            generatorpm_module = importlib.util.module_from_spec(
                generatorpm_spec)
            generatorpm_spec.loader.exec_module(generatorpm_module)

        except FileNotFoundError as txt:
            logger.error(suite + " not found at : " + path_to_module + ".\n" +
                         str(txt))
            raise SystemExit

        if suite == 'microtesk':
            generatorpm.register(generatorpm_module.MicroTESKPlugin())
        if suite == 'aapg':
            generatorpm.register(generatorpm_module.AapgPlugin())
        if suite == 'dv':
            generatorpm.register(generatorpm_module.RiscvDvPlugin())

        generatorpm.hook.pre_gen(spec_config=config[suite],
                                 output_dir='{0}/{1}'.format(output_dir, suite))
        generatorpm.hook.gen(
            gen_config='{0}/{1}_plugin/{1}_gen_config.yaml'.format(
                path_to_module, suite),
            module_dir=path_to_module,
            output_dir=output_dir)
        generatorpm.hook.post_gen(
            output_dir='{0}/{1}'.format(output_dir, suite),
            regressfile='{0}/{1}/regresslist.yaml'.format(output_dir, suite))


def rivercore_compile(config_file, output_dir, asm_dir, verbosity):
    '''
        Work in Progress

        Function to compile generated assembly programs using the plugin as configured in the config.ini.

        :param config_file: Config.ini file for generation

        :param output_dir: Output directory for programs generated

        :param verbosity: Verbosity level for the framework

        :type config_file: click.Path

        :type output_dir: click.Path

        :type verbosity: str
    '''

    logger.level(verbosity)
    config = configparser.ConfigParser()
    config.read(config_file)
    logger.debug('Read file from {0}'.format(config_file))

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

    # TODO Test multiple plugin cases
    # Current implementation is using for loop, which might be a bad idea for parallel processing.
    asm_gen = config['default']['generator']
    target_list = config['default']['target'].split(',')
    for target in target_list:

        # compilepm = pluggy.PluginManager('compile')
        dutpm = pluggy.PluginManager('dut')
        # compilepm.add_hookspecs(CompileSpec)
        dutpm.add_hookspecs(DuTSpec)

        path_to_module = config['default']['path_to_target']
        plugin_target = target + '_plugin'
        logger.info('Now loading {0}-target'.format(target))

        abs_location_module = path_to_module + '/' + plugin_target + '/' + plugin_target + '.py'
        logger.debug("Loading module from {0}".format(abs_location_module))

        dutpm_spec = importlib.util.spec_from_file_location(
            plugin_target, abs_location_module)
        dutpm_module = importlib.util.module_from_spec(dutpm_spec)
        dutpm_spec.loader.exec_module(dutpm_module)

        if target == 'chromite':
            dutpm.register(dutpm_module.ChromitePlugin())
            # Add more plugins here :)
        else:
            logger.error("Sorry, requested plugin is not really supported ATM")
            raise SystemExit

        dutpm.hook.init(ini_config=config[target],
                        yaml_config=path_to_module + '/' + plugin_target + '/' +
                        'config.yaml',
                        output_dir=output_dir)
        # NOTE (Add to documentation)
        # The config files should be saved as config.yaml in the plugin repo
        dutpm.hook.build(asm_dir=asm_dir, asm_gen=asm_gen)
        # regress_list='{0}/{1}/regresslist.yaml'.format(
        # output_dir, suite),
        # command_line_args='',
        # jobs=jobs,
        # norun=norun,
        # filter=filter)
        dutpm.hook.run(module_dir=path_to_module, asm_dir=asm_dir)
        dutpm.hook.post_run()

        # except FileNotFoundError as txt:
        #     logger.error(target + " not found at : " + path_to_module + ".\n" +
        #                  str(txt))
        #     raise SystemExit

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
