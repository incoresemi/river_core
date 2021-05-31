import os
import sys
import pluggy
import shutil
from river_core.log import logger
import river_core.utils as utils
from river_core.constants import *
import random
import re
import datetime
import pytest
from envyaml import EnvYAML


def gen_cmd_list(seed, output_dir, module_dir):
    # TODO: This portion is responsible to generate the ommands the plugin needs to run

    logger.debug('Now generating commands for gen plugin')

    if seed == 'random':
        gen_seed = random.randint(0, 10000)
    else:
        gen_seed = int(seed)

    now = datetime.datetime.now()
    gen_prefix = '{0:06}_{1}'.format(gen_seed, now.strftime('%d%m%Y%H%M%S%f'))
    # TODO: Modify as required.
    run_command.append('sample generate \
                        --output_dir {0} \
                        --asm_name {1} \
                        --seed {2}\
                        '.format(output_dir, gen_prefix, gen_seed))

    return run_command


def idfnc(val):
    # TODO: Unique identifier for the tests generated, can be determined by the underlying plugin
    modified_val = val
    return 'Generating {0}'.format(modified_val)


def pytest_generate_tests(metafunc):
    if 'test_input' in metafunc.fixturenames:
        # TODO: Modify as required. You need to configure the CLI options required by the generator here
        test_list = gen_cmd_list(metafunc.config.getoption("seed"),
                                 metafunc.config.getoption("output_dir"),
                                 metafunc.config.getoption("module_dir"))
        metafunc.parametrize('test_input', test_list, ids=idfnc, indirect=True)


@pytest.fixture
def test_input(request, autouse=True):
    # Run the generated commands
    # TODO: Modify as required. This encapsulates the entire test you want to run
    program = request.param
    (ret, out, err) = utils.sys_command(program)


def test_eval(test_input):
    # TODO: Check if the test was successful or not. Assuming that the program exits with 0 return code
    assert test_input == 0
