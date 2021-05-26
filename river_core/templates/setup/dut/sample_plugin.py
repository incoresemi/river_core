import os
import sys
import pluggy
import shutil
import random
import re
import datetime
import pytest
import glob

from river_core.log import logger
from river_core.utils import *

dut_hookimpl = pluggy.HookimplMarker('dut')


class sample_plugin(object):
    # NOTE: Do not change the above naming scheme unless you are really sure about what you are doing
    '''
        Plugin to set chromite as the target
    '''

    @dut_hookimpl
    def init(self, ini_config, test_list, work_dir, coverage_config,
             plugin_path):
        self.name = 'sample'
        logger.info('Pre Compile Stage')

        self.src_dir = ini_config['src_dir'].split(',')

        self.top_module = ini_config['top_module']

        self.plugin_path = plugin_path + '/'

        if coverage_config:
            self.coverage = True
        else:
            self.coverage = False

        # Get plugin specific configs from ini
        self.jobs = ini_config['jobs']

        self.filter = ini_config['filter']

        self.riscv_isa = ini_config['isa']

        if '64' in self.riscv_isa:
            self.xlen = 64
        else:
            self.xlen = 32

        self.elf = 'dut.elf'

        if coverage_config:
            logger.warn('Hope RTL binary has coverage enabled')

        self.objdump_cmd = 'riscv{0}-unknown-elf-objdump -D dut.elf > dut.disass && '.format(
            self.xlen)
        self.sim_cmd = './sample_sim'
        self.sim_args = '+rtldump > /dev/null'

        self.work_dir = os.path.abspath(work_dir) + '/'

        self.sim_path = self.work_dir + self.name
        os.makedirs(self.sim_path, exist_ok=True)

        self.test_list = load_yaml(test_list)

        self.json_dir = self.work_dir + '/.json/'

        # Check if dir exists
        if (os.path.isdir(self.json_dir)):
            logger.debug(self.json_dir + ' Directory exists')
        else:
            os.makedirs(self.json_dir)

        if not os.path.exists(self.sim_path):
            logger.error('Sim binary Path ' + self.sim_path + ' does not exist')
            raise SystemExit

        for path in self.src_dir:
            if not os.path.exists(path):
                logger.error('Source code ' + path + ' does not exist')
                raise SystemExit

        # TODO: Assuming that bsc and riscv-gcc are used
        if shutil.which('bsc') is None:
            logger.error('bsc toolchain not found in $PATH')
            raise SystemExit

        if shutil.which('riscv64-unknown-elf-gcc') is None and \
                shutil.which('riscv32-unknown-elf-gcc') is None:
            logger.error('riscv-* toolchain not found in $PATH')
            raise SystemExit

        if coverage_config:
            # TODO: Edit the build command for creating the simulator with or without coverage
            logger.info(
                "Coverage is enabled, compiling the sample with coverage")
        else:
            logger.info(
                "Coverage is disabled, compiling the sample with usual options")

        # TODO: Create the simlation binary here
        sys_command(command, 500)

    @dut_hookimpl
    def build(self):
        logger.info('Build Hook')
        # TODO: Uses the Makefile approach, edit here if you want.
        make = makeUtil(makefilePath=os.path.join(self.work_dir,"Makefile." +\
            self.name))
        make.makeCommand = 'make -j1'
        self.make_file = os.path.join(self.work_dir, 'Makefile.' + self.name)
        self.test_names = []

        # TODO: Reads the entire test_list yaml and then generates commands to run
        for test, attr in self.test_list.items():
            logger.debug('Creating Make Target for ' + str(test))
            abi = attr['mabi']
            arch = attr['march']
            isa = attr['isa']
            work_dir = attr['work_dir']
            link_args = attr['linker_args']
            link_file = attr['linker_file']
            cc = attr['cc']
            cc_args = attr['cc_args']
            asm_file = attr['asm_file']

            ch_cmd = 'cd {0} && '.format(work_dir)
            compile_cmd = '{0} {1} -march={2} -mabi={3} {4} {5} {6}'.format(\
                    cc, cc_args, arch, abi, link_args, link_file, asm_file)
            for x in attr['extra_compile']:
                compile_cmd += ' ' + x
            for x in attr['include']:
                compile_cmd += ' -I ' + str(x)
            compile_cmd += ' '.join(map(' -D{0}'.format,
                                        attr['compile_macros']))
            compile_cmd += ' -o dut.elf && '
            sim_setup = 'ln -f -s ' + self.sim_path + '/sample_sim . && '
            sim_setup += 'ln -f -s ' + self.sim_path + '/boot.mem . && '
            post_process_cmd = 'head -n -4 rtl.dump > dut.dump && rm -f rtl.dump'

            # TODO: This creates the final command. This should be passed on to the next stage in any format, depending upon the format, developer is comfortable in.
            target_cmd = ch_cmd + compile_cmd + self.objdump_cmd +\
                    self.elf2hex_cmd + sim_setup + self.sim_cmd + ' ' + \
                    self.sim_args +' && '+ post_process_cmd
            make.add_target(target_cmd, test)
            self.test_names.append(test)

    @dut_hookimpl
    def run(self, module_dir):
        logger.info('Run Hook')
        logger.debug('Module dir: {0}'.format(module_dir))
        pytest_file = module_dir + '/sample_plugin/gen_framework.py'
        logger.debug('Pytest file: {0}'.format(pytest_file))

        report_file_name = '{0}/{1}_{2}'.format(
            self.json_dir, self.name,
            datetime.datetime.now().strftime("%Y%m%d-%H%M"))

        pytest_state = pytest.main([
            pytest_file,
            '-x',  # Stop on first failure 
            '-n={0}'.format(self.jobs),
            '-k={0}'.format(self.filter),
            '--html={0}.html'.format(self.work_dir + '/reports/' + self.name),
            '--report-log={0}.json'.format(report_file_name),
            '--work_dir={0}'.format(self.work_dir),
            '--make_file={0}'.format(self.make_file),
            '--key_list={0}'.format(self.test_names),
            '--log-cli-level=DEBUG',
            '-o log_cli=true',
        ])
        if pytest_state == (pytest.ExitCode.INTERRUPTED or
                            pytest.ExitCode.TESTS_FAILED):
            logger.error(
                'DuT Plugin failed to compile tests, exiting river_core')
            raise SystemExit

        if self.coverage:
            # TODO: Run commands like writing coverage databases or logging the paths to report etc
            pass
        # TODO: Need to return the json file generated
        return report_file_name

    @dut_hookimpl
    def post_run(self, test_dict, config):
        # TODO: This section checks if the the results have passed and then removes common files that won't make sense to store
        if str_2_bool(config['river_core']['space_saver']):
            logger.debug("Removing artifacts for sample")
            for test in test_dict:
                if test_dict[test]['result'] == 'Passed':
                    logger.debug("Removing extra files for Test: " + str(test))
                    work_dir = test_dict[test]['work_dir']
                    try:
                        os.remove(work_dir + '/code.mem')
                        os.remove(work_dir + '/dut.disass')
                        os.remove(work_dir + '/dut.dump')
                        os.remove(work_dir + '/signature')
                    except:
                        logger.info(
                            "Something went wrong trying to remove the files")

    @dut_hookimpl
    def merge_db(self, db_files, output_db, config):

        # Add commands to run here :)
        # TODO: If you plan to support on merging different coverage DBs, you can add the commands in this function
        logger.info('Initiating Merging of coverage files')
        # Merge
        # Create reports etc

        orig_path = os.getcwd()
        os.chdir(output_db + '/final_coverage')

        # HTML Web pages
        # TODO: The final report linking works only if you conform to this naming scheme
        # So please ensure you return this values in a similar format
        final_html = output_db + '/final_html/index.html'
        final_rank_html = output_db + '/final_html_rank/rank_sub_dir/rank.html'
        os.chdir(orig_path)

        return final_html, final_rank_html
