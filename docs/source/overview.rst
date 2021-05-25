.. See LICENSE.incore for details

##################
Framework Overview
##################

.. figure:: _static/River.png
    :align: center
    
    RIVER CORE Overview Flow

RIVER CORE splits the verification flow into the following stages:

1. **Test Generation**: This phase uses multiple user configured generators of 
   different kind to generate tests and create a combined test-list. This now 
   becomes a sort of a regression suite that needs to be run on the target and
   the reference.
2. **Target Run**: The generated tests from the previous stage are compiled and
   loaded into the target's custom test-bench and simulated. The execution logs for 
   each test are saved. All of the above steps are encapsulated inside a python
   plugin and thus any core with any environment can easily be integrated into
   RIVER CORE as a target.
3. **Reference Run**: The same tests are compiled and run on the reference model of
   choice and the execution logs are saved.
4. **Compare Logs**: The execution logs for each test from the target and the
   reference model are compared and a Fail result is captured is the logs are
   different. 
5. **Report Generation**: Generate an html report capturing the results of all
   of the above steps.

RIVER CORE uses the `Pluggy <https://pluggy.readthedocs.io/en/latest/>`_ python package to manage plugins.


The Input Config File
=====================

The entire configuration and flow of the framework is controlled via the input
``config.ini`` file. This file is used to capture some of the following
parameters:

- The work directory where all artifacts of generation and simulation are
  kept.
- The overvall ISA string supported by the target
- The list of generators to be used and their configurations to generate
  tests.
- Configuration parameters of the Target. This is particularly useful when working with core generators 
- Configuration parameters of the reference model.
- Whether coverage shuold be enabled by the target and if so, what metrics ?

A sample template of the config.ini file is shown below. More details of syntax
can be found here :ref:`Config Spec<config_ini>`.

.. code-block:: ini

  work_dir = test 

  target = chromite_verilator
  reference = spike 
  generator = testfloat, aapg
  isa = rv64imafdc
  
  # Set paths for each plugin
  path_to_target = ~/river_core_plugins/dut_plugins
  path_to_ref = ~/river_core_plugins/reference_plugins
  path_to_suite = ~/river_core_plugins/generator_plugins
  
  open_browser = True
  space_saver = True
  
  [coverage]
  code = False
  functional = False
  
  [testfloat]
  jobs=8
  seed = random
  count = 1
  filter = 
  config_yaml = ~/river_core_plugins/generator_plugins/testfloat_plugin/testfloat_gen_config.yaml
  
  [aapg]
  jobs = 8
  filter = rv64imafdc_hazards_s
  seed = random
  count = 2
  config_yaml = ~/river_core_plugins/generator_plugins/aapg_plugin/aapg_gen_config.yaml
  
  [chromite_verilator]
  jobs = 8
  filter = 
  count = 1
  src_dir = ~/chromite/build/hw/verilog/,~/bsc/inst/lib/Verilog,~/chromite/bsvwrappers/common_lib
  top_module = mkTbSoc
  
  [spike]
  jobs = 1
  filter =
  count = 1


  
Generator Plugin
================

.. figure:: _static/generator_plugin.png
    :align: center
    :height: 300
    
    Generator Plugin

This plugin is used encapsulate various test-generators. These generators can be
either random program generators like `AAPG <https://gitlab.com/shaktiproject/tools/aapg>`_, `RISC-V Torture <https://github.com/ucb-bar/riscv-torture>`_ , 
`CSmith <https://embed.cs.utah.edu/csmith/>`_ , `MicroTesk <http://www.microtesk.org/>`_ , `Test Float <http://www.jhauser.us/arithmetic/TestFloat.html>`_ etc. OR may include a directed
test-generators like `CTG <https://riscv-ctg.readthedocs.io/en/latest/>`_ OR a static test suite like the ones hosted 
at the `RISC-V TESTS <https://github.com/riscv/riscv-tests>`_ .

Each test generator is a python plugin which supports 3 hooks, called in the
following sequence:

1. **Pre-gen**: This stage is used to configure the generator, check and install
   dependencies, download artifacts, create necessary directories, parse and capture the plugin 
   specific parameters present in the ``config.ini``  etc. 

2. **Gen**: This stage is where the actual tests are generated. RIVER CORE uses
   the inherent pytest framework to run parallelized commands. Using pytest,
   enables using default report templates which are quite verbose and helpful in
   debugging as well. 

   The major output of this stage is a test-list YAML which
   follows the syntax/schema mentioned in :ref:`Test List Format<testlist>`.
   this test list capture all the information about the test and necessary
   collaterals required to compile each test. By adopting a standard test-list 
   format, we inherently allow any source of tests to be integrated into RIVER 
   CORE as a generator plugin as long as a valid test list is created.

3. **Post-Gen**: This stage is called after all the tests are generated and can
   be used to post-process the tests, validate the tests, profile the tests, remove
   unwanted artifacts, etc.

At the end of the 3 phases RIVER CORE also generates an HTML reports which
captures the log of each test generation and any errors that were caught,
thereby providing a complete database of information on the test-generation
aspect. 

The generated tests are available in the directory mentioned in the ``work_dir``
parameter of the ``config.ini`` file passed to the ``generate`` command.

.. warning:: It is not advised to modify the tests or directory structures in
   the the work_dir manually. 

The plugin hooks usage and arguments are presented below:

.. automodule:: river_core.sim_hookspecs
   :members: RandomGeneratorSpec


DUT/Target Plugin
=================

.. figure:: _static/dut_plugin.png
    :align: center
    :height: 300
    
    DUT/Target Plugin

This plugin encapsulates the DUT's/Target's compile and test environment. The plugin allows a user
complete control over:

- choice of toolchain to be used for compiling the tests: GCC, LLVM, Custom, etc
- choice of testbench environment : SVUVM, Cocotb, etc.
- choice of simulator : Questa, Cadence, Verilator, etc
- choice of coverage metrics to enable: functional, structural, etc

The DUT Plugin supports the following hooks:

1. **Init**: This stage is used to capture configurations from the input ``config.ini`` and build
   and set up the environment. If a core generator is the target, then this stage can be used to
   configure it and generate and instance, build the relevant toolchain, setup simulator args like
   coverage, verbosity, etc. The test list is also available at this stage. Which must be captured and
   stored by the plugin for future use.

2. **Build**: This stage is used to create a Makefile or script to actually compile each test,
   simulate it on the target. A typical use case is to create a makefile-target for each test
   that needs to be run on the target. 

   .. note:: The target must run all the tests in the test-list provided and should not perform any
      filtering and skip any tests and should niether modify the tests 

3. **Run**: This stage is used to run the tests on the DUT. It is recommended to run the tests in
   parallel. RIVER CORE uses the inherent pytest framework to run terminal commands in parallel
   fashion. This stage will generate all the artifacts of the simulation like : signature file, 
   execution logs, test-binary, target executable binary, coverage database, simulation logs, etc. 

4. **Post-Run**: This stage is run after the pass-fail results have been captured. This stage can be
   used to clean up unwanted artifacts like : elfs, hexfiles, objdumps, logs, etc which are no
   longer of consequence. One can further choose to only delete artifacts of passed tests and retain
   it for tests that failed (the pass/fail result is captured in the test-list itself). 

   This stage can also further also be used to merge coverage databases of all the test runs, rank
   the tests and generate appropriate reports. This is completely optional and upto the user to
   define what happens as a "clean-up" process in this stage.
   

The plugin hooks usage and arguments are presented below:

.. automodule:: river_core.sim_hookspecs
   :members: DuTSpec

The Reference Plugins
=====================

The reference plugins use the same hooks and class as the DUT/Target plugins. Similar operations as
mentioned above are performed for the reference plugin. However, in terms of coverage, certain
reference models may have capabilities to generate certain functional coverage metrics. This can be
exploited in these plugins as well.

Compare Outputs
===============

In order to declare the tests have passed, the execution logs from the DUT/Target and the reference
models are compared. A difference in the logs indicates the test has failed, else it has passed. The
result of the tests is updated in the test-list itself. 

.. note:: RIVER CORE currently only supports compare a single execution log for a test. There is a need
  however to compare multiple artifacts (like signature contents as well) of a test execution. Future
  versions of RIVER CORE may include these features.

Test Report Generation
======================

Once the test results are obtained and updated in the test-list, an HTML report containing
informatino of each of the above steps is generated for the user. The automatic browser pop-up can
be disabled by setting the ``open_browser`` parameter to false in the input ``config.ini`` file.

Each plugin run (generator, dut or reference) also creates a json report of the run which can
easiliy be populated into html files for better visualization.

