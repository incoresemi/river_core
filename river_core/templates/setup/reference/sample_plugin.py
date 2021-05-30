import os
import sys
import pluggy
import shutil
import random
import re
import glob
import datetime
import pytest

from river_core.log import logger
from river_core.utils import *

dut_hookimpl = pluggy.HookimplMarker('dut')


class sample_plugin(object):
    # NOTE: Do not change the above naming scheme unless you are really sure about what you are doing
    '''
        Plugin to set Spike as ref
    '''

    @dut_hookimpl
    def init(self, ini_config, test_list, work_dir, plugin_path):
        self.name = 'sample'
        logger.debug('Pre Compile Stage')

        # Get plugin specific configs from ini
        self.jobs = ini_config['jobs']

        self.filter = ini_config['filter']

        self.riscv_isa = ini_config['isa']

        if '64' in self.riscv_isa:
            self.xlen = 64
        else:
            self.xlen = 32

        self.elf = 'ref.elf'

        # TODO: Edit as required
        self.objdump_cmd = 'riscv{0}-unknown-elf-objdump -D ref.elf > ref.disass && '.format(
            self.xlen)
        self.sim_cmd = 'sample_sim'

        self.sim_args = '--log ref.dump --log-commits --isa={0} {1}'

        self.work_dir = os.path.abspath(work_dir) + '/'
        self.test_list = load_yaml(test_list)

        self.json_dir = self.work_dir + '/.json/'
        # Check if dir exists
        if (os.path.isdir(self.json_dir)):
            logger.debug(self.json_dir + ' Directory exists')
        else:
            os.makedirs(self.json_dir)

        # TODO: Check if the binary is available
        if shutil.which('sample') is None:
            logger.error('sample not available in $PATH')
            raise SystemExit

    @dut_hookimpl
    def build(self):
        logger.debug('Build Hook')
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

            spike_isa = 'rv' + str(self.xlen) + 'i'
            spike_isa += 'm' if 'm' in arch else ''
            spike_isa += 'a' if 'a' in arch else ''
            spike_isa += 'f' if 'f' in arch else ''
            spike_isa += 'd' if 'd' in arch else ''
            spike_isa += 'c' if 'c' in arch else ''

            ch_cmd = 'cd {0} && '.format(work_dir)
            compile_cmd = '{0} {1} -march={2} -mabi={3} {4} {5} {6}'.format(\
                    cc, cc_args, arch, abi, link_args, link_file, asm_file)
            for x in attr['extra_compile']:
                compile_cmd += ' ' + x
            for x in attr['include']:
                compile_cmd += ' -I ' + str(x)
            compile_cmd += ' '.join(map(' -D{0}'.format,
                                        attr['compile_macros']))
            compile_cmd += ' -o ref.elf && '
            post_process_cmd = ''

            # TODO: This creates the final command. This should be passed on to the next stage in any format, depending upon the format, developer is comfortable in.
            target_cmd = ch_cmd + compile_cmd + self.objdump_cmd +\
                    self.sim_cmd + ' ' + \
                    self.sim_args.format(spike_isa, self.elf)
            make.add_target(target_cmd, test)
            self.test_names.append(test)

    @dut_hookimpl
    def run(self, module_dir):
        logger.debug('Run Hook')
        logger.debug('Module dir: {0}'.format(module_dir))
        pytest_file = module_dir + '/spike_plugin/gen_framework.py'
        logger.debug('Pytest file: {0}'.format(pytest_file))

        report_file_name = '{0}/{1}_{2}'.format(
            self.json_dir, self.name,
            datetime.datetime.now().strftime("%Y%m%d-%H%M"))

        pytest.main([
            pytest_file, '-n={0}'.format(self.jobs),
            '-k={0}'.format(self.filter),
            '--html={0}.html'.format(self.work_dir + '/reports/' + self.name),
            '--report-log={0}.json'.format(report_file_name),
            '--work_dir={0}'.format(self.work_dir), '--make_file={0}'.format(
                self.make_file), '--key_list={0}'.format(self.test_names),
            '--log-cli-level=DEBUG', '-o log_cli=true'
        ])

        # TODO: Need to return the json file generated
        return report_file_name

    @dut_hookimpl
    def post_run(self, test_dict, config):
        # TODO: This section checks if the the results have passed and then removes common files that won't make sense to store
        if str_2_bool(config['river_core']['space_saver']):
            logger.debug("Removing artifacts for Spike")
            for test in test_dict:
                if test_dict[test]['result'] == 'Passed':
                    logger.debug("Removing extra files for Test: " + str(test))
                    work_dir = test_dict[test]['work_dir']
                    try:
                        os.remove(work_dir + '/ref.disass')
                        os.remove(work_dir + '/ref.dump')
                    except:
                        logger.info(
                            "Something went wrong trying to remove the files")
