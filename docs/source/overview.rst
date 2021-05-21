.. See LICENSE.incore for details

########
Overview
########

.. image:: _static/River.png
    :align: center
    :alt: riscof-flow

RIVER CORE

1. Test Generation: This phase uses multiple generators of different kind to
   generate tests and maintain them as a test-list. This now becomes a sort of a
   regression suite that needs to be run on the target.
2. Target Run: The generated tests from the previous stage are compiled and
   loaded into the target's custom test-bench and simulated. The execution logs for 
   each test are saved.
3. Reference Run: The same tests are compiled and run on the reference model of
  choice and the execution logs are saved.




RIVER CORE is a python based tool aimed at provide a neutral framework which can
enable verification and testing of a RISC-V target (hard or soft implementations) against a reference model


The following diagram captures the overall flow of RiVer Core and its components. The XYZ bounding box
denotes the RiVer Core framework. Components outside the box either denote user inputs or external tools
that RiVer Core can work with. The inputs and components of RiVer Core are discussed in detail in the
following sections.

.. image:: _static/River.png
    :align: center
    :alt: riscof-flow

Inputs to the framework
=======================

As can seen in the image above, the framework takes multiple inputs from the user:

1. A RiVer Core config.ini which contains details use to configure the framework. The options and other configurations can be found at :ref:`Config Spec<config_ini>`.

2. A Python plugin which can be used by the framework to generate tests, compile and simulate them, and compare the results. Plugins also offer additional features like merging various tests. More info about the plugins can be found in <TODO> :ref:`plugins` section.

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
