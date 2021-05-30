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
import river_core.utils as utils
from river_core.constants import *

gen_hookimpl = pluggy.HookimplMarker("generator")


class sample_plugin(object):
    # NOTE: Do not change the above naming scheme unless you are really sure about what you are doing
    """ Generator hook implementation """

    # creates gendir and any setup related things
    @gen_hookimpl
    def pre_gen(self, spec_config, output_dir):
        '''

         Pre-Gen Stage.

         Check if the output_dir exists

         Add load plugin specific config

        '''

        # Check if the path exists or not
        logger.debug('sample Pre Gen Stage')
        output_dir = os.path.abspath(output_dir)
        self.name = 'sample'

        if (os.path.isdir(output_dir)):
            logger.debug('exists')
            shutil.rmtree(output_dir, ignore_errors=True)
        os.makedirs(output_dir)

        logger.debug('Extracting info from list')

        # Extract plugin specific info
        self.jobs = spec_config['jobs']
        self.seed = spec_config['seed']
        self.filter = spec_config['filter']
        self.isa = spec_config['isa']

        # Load the plugin YAML
        self.gen_config = spec_config['config_yaml']

        self.json_dir = output_dir + '/../.json/'
        logger.debug(self.json_dir)

        # Check if dir exists
        if (os.path.isdir(self.json_dir)):
            logger.debug(self.json_dir + ' Directory exists')
        else:
            os.makedirs(self.json_dir)

    # gets the yaml file with list of configs; test count; parallel
    @gen_hookimpl
    def gen(self, module_dir, output_dir):

        logger.debug('sample Plugin gen phase')
        logger.debug(module_dir)
        pytest_file = module_dir + '/sample_plugin/gen_framework.py'
        logger.debug(pytest_file)

        output_dir = os.path.abspath(output_dir)

        report_file_name = '{0}/{1}_{2}'.format(
            self.json_dir, self.name,
            datetime.datetime.now().strftime("%Y%m%d-%H%M"))

        # TODO Change according to your generator requirements
        pytest.main([
            pytest_file, '-n={0}'.format(self.jobs),
            '-k={0}'.format(self.filter), '-v', '--seed={0}'.format(self.seed),
            '--html={0}/reports/sample.html'.format(output_dir),
            '--report-log={0}.json'.format(report_file_name),
            '--self-contained-html', '--output_dir={0}'.format(output_dir),
            '--module_dir={0}'.format(module_dir)
        ])

        # Generate Test List
        # Get the sample dir from output
        asm_dir = output_dir + '/sample/asm/'
        test_list = {}
        asm_templates = glob.glob(asm_dir + '/**/*.S')
        for test in asm_templates:
            with open(test, 'r') as file:
                test_asm = file.read()
            isa = set()
            isa.add('i')
            xlen = 64
            dist_list = re.findall(r'^#\s*(rel_.*?)$', test_asm, re.M | re.S)
            for dist in dist_list:
                ext = dist.split(':')[0][4:].split('.')[0]
                ext_count = int(dist.split(':')[1])

                if ext_count != 0:
                    if 'rv64' in ext:
                        xlen = 64
                    if 'm' in ext:
                        isa.add('m')
                    if 'a' in ext:
                        isa.add('a')
                    if 'f' in ext:
                        isa.add('f')
                    if 'd' in ext:
                        isa.add('d')
                    if 'c' in ext:
                        isa.add('c')
            canonical_order = {'i': 0, 'm': 1, 'a': 2, 'f': 3, 'd': 4, 'c': 5}
            canonical_isa = sorted(list(isa), key=lambda d: canonical_order[d])

            march_str = 'rv' + str(xlen) + "".join(canonical_order)
            if xlen == 64:
                mabi_str = 'lp64'
            elif 'd' not in march_str:
                mabi_str = 'ilp32d'

            # Create the base key for the test i.e. the main file under which everything is stored
            # NOTE: Here we expect the developers to probably have the proper GCC and the args, objdump as well
            # TODO: Add and modify as required
            base_key = os.path.basename(test)[:-2]
            test_list[base_key] = {}
            test_list[base_key]['generator'] = self.name
            test_list[base_key][
                'work_dir'] = output_dir + '/sample/asm/' + base_key
            test_list[base_key]['isa'] = self.isa
            test_list[base_key]['march'] = march_str
            test_list[base_key]['mabi'] = mabi_str
            # test_list[base_key]['gcc_cmd'] = gcc_compile_bin + " " + "-march=" + arch + " " + "-mabi=" + abi + " " + gcc_compile_args + " -I " + asm_dir + include_dir + " -o $@ $< $(CRT_FILE) " + linker_args + " $(<D)/$*.ld"
            test_list[base_key]['cc'] = 'riscv64-unknown-elf-gcc'
            test_list[base_key][
                'cc_args'] = ' -mcmodel=medany -static -std=gnu99 -O2 -fno-common -fno-builtin-printf -fvisibility=hidden '
            test_list[base_key][
                'linker_args'] = '-static -nostdlib -nostartfiles -lm -lgcc -T'
            test_list[base_key][
                'linker_file'] = output_dir + '/sample/asm/' + base_key + '/' + base_key + '.ld'
            test_list[base_key][
                'asm_file'] = output_dir + '/sample/asm/' + base_key + '/' + base_key + '.S'
            test_list[base_key]['include'] = []
            test_list[base_key]['compile_macros'] = []
            test_list[base_key]['extra_compile'] = [
                output_dir + '/sample/common/crt.S'
            ]
            test_list[base_key]['result'] = 'Unavailable'

        return test_list

    @gen_hookimpl
    def post_gen(self, output_dir):
        # TODO: Any operations that need to be run after the generation needs to be mentioned here
        pass
