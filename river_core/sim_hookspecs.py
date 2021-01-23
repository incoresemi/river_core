# See LICENSE for details

import importlib
import sys

import pluggy

gen_hookspec = pluggy.HookspecMarker("generator")
compile_hookspec = pluggy.HookspecMarker("compile")
model_hookspec = pluggy.HookspecMarker("model")


class RandomGeneratorSpec(object):
    """ Test generator specification"""

    #    @gen_hookspec
    #    def load_config(self, isa, platform):
    #        """ loads riscv_config"""

    @gen_hookspec
    def pre_gen(self, output_dir):
        """ before random generation"""

    @gen_hookspec
    def gen(self, gen_config, spec_config, module_dir, output_dir):
        """ generation step"""

    @gen_hookspec
    def post_gen(self, output_dir, regressfile):
        """ after generation steps """


### creation of regress list into parameterize of tests: D
### simulate_test fixture in pytest calls compilespec plugin and model plugin and dut plugin


class CompileSpec(object):
    """ Program compilation specification"""

    #@compile_hookspec
    #def load_config(self, isa, platform):
    #    """ loads riscv_config"""

    @compile_hookspec
    def pre_compile(self, compile_config):
        """ gets tool chain config from yaml"""
        # should create test dir
        # should set all gcc etc configs

    @compile_hookspec
    def compile(suite, regress_list, compile_config, command_line_args, jobs,
                filter, norun):
        """ compiles all tests in the regress list"""

    @compile_hookspec
    def post_compile():
        """ post compile step"""


class ModelSpec(object):
    """Model hook specification"""

    @model_hookspec
    def load_config(self, isa, platform):
        """ loads riscv_config"""

    @model_hookspec
    def load_elf(self, test_elf):
        """ loads test elf"""

    @model_hookspec
    def get_state(self):
        """ get processor state"""

    @model_hookspec
    def step(self, count=1):
        """ step count instructions"""
