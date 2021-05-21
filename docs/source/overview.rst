.. See LICENSE.incore for details

##################
Framework Overview
##################

.. image:: _static/River.png
    :align: center
    :alt: river-flow

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

.. image:: _static/generator_plugin.png
    :align: center
    :alt: Generator Plugin

This plugin is used encapsulate various test-generators. These generators can be
either random program generators like `AAPG <>`_, `RISC-V Torture <>`_ , 
`Csmit <>`_ , `MicroTesk <>`_ , `Test Float <>`_ etc. OR may include a directed
test-generators like `CTG <>`_ OR a static test suite like the ones hosted 
at the `RISC-V TESTS <>`_ .

Each test generator is a python plugin which support 3 hooks, called in the
following sequence:

1. **Pre-gen**: This stage is used to configure the generator, check and install
   dependencies, download artifacts, create work directories, parse the plugin 
   specific parameters present in the ``config.ini``  etc. 

2. **Gen**: This stage is where the actual tests are generated. RIVER CORE uses
   the inherent pytest framework to run parallelized commands. Using pytest,
   enables using default report templates which are quite verbose and helpful in
   debugging as well. 

   The major output of this stage is a test-list YAML which
   follows the syntax/schema mentioned in :ref:`Test List Format<testlist>`.
   this test list capture all the information about the test and necessary
   collaterals required to compile each test. By adopting a standard format, we
   inherently allow any source of tests to be integrated into RIVER CORE as a
   generator plugin as long as a valid test list is created.

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

Types of plugins
----------------

On the basis of the functions the plugins perform the plugins are broadly classified into 3 categories:

1. **Generator Plugins**
   The generator plugins help in generating random test cases.These plugins are built on top of the existing programs, that help in generating random test cases.

   When used with the RiVer Core framework, these generator plugins also generate a Test-List YAML file, which contains all necessary info about the generated test cases and the associated options with them.


2. **DuT Plugins**
   DuT Plugins or Device-under-Test plugins help us compile and simulate the generated test cases. This receives the previously generated test-list YAML as an input, and proceeds to compile the files, with required parameters and runs the simulations as well.

3. **Reference Plugins**
   Reference Plugins will compile and simulate the generated test cases, this acts as a golden standard for all DuT plugins to follow.

Subcommands
===========

- **Generate**:
  The command used to generate a list of random test cases for your design to run.
- **Compile**:
  The command used to compile and simulate the list of random test cases for your design, it will run the tests and the compare results between the design model and reference model.
- **Merge**:
  The command used to merge a set of different test cases into a single set of tests.
- **Clean**:
  The command used to clean your workdir.

Execution flow for Users
========================

The primary users of RiVer Core are verification and design engineers who would like to validate their design's features. This subsection will provide an overall working of the RiVer in the context of validating a RISC-V target against a golden reference model.

.. note:: The following explanation is at an abstract level and assumes that the user has RiVer and
   the respective tooling available. For a walk-through guide to install RiVer and setting up the
   required tooling please refer to :ref:`quickstart`

The flow starts with the user generating a set of tests to run on the design, the user can select a generator plugin and configure it to generate the 'n' number of tests. After successfully creating the required files, the generator plugin also provides a test-list YAML, which contains all information about the generated assembly files, and the parameters required to compile the assembly files.

Then this YAML, is given as an input to the DuT and Reference plugins, which compile and simulate the ASM files separately. Once this operation is completed, the RiVer Core proceeds to check and compare results from both the plugins.

At the end of execution, RiVer Core generates an HTML report which provides details of the
implementation and tests that were passed/failed by the implementation.

After running a set of these operations, one can actually combine the various test cases generated with the help of the merge command, which helps in creating a set of tests to run to verify the design.
