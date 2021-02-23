===============
Config.ini Spec
===============

.. _config-file: https://gitlab.com/incoresemi/river-framework/core-verification/river_core/-/blob/dev/examples/sample-config.ini
This chapter will discuss the syntax and structure of the config.ini file used by river_core.
A sample `config-file`_ is present in the **examples** directory of the Git Repository.

**Still work in progress**

.. note:: The standard delimiter for options having mutliple values is **,** (comma) .

Configuration options for river_core
####################################

- **river_core** contains generic information that's specific to river_core. Ideally for a test, this should remain same.

  - **target** -> Device under Test(DuT), the target to run tests.
  - **reference** -> The Golden Standard used for comparing with the target results.
  - **generator** -> The program generator used to generate sample programs
  - **path_to_suite** -> Absolute path to the generator module
  - **path_to_target** -> Absolute path to the target module
  - **path_to_ref** -> Absolute path to the reference module
  - **isa** -> ISA for the arch

Configuration options for plugins
####################################

Some of the necessary configuration options

- **plugin** specific options

  - **jobs** -> Number of jobs to use while generating the tests
  - **filter** -> This option is to select tests to use, ideally stored as a yaml file, (just need to mention the filename to filter, i.e. do not add .yaml in the end)
  - **seed** -> A seed for generating the programs (Can be *random*)
  - **isa** -> Required for the generator and compilation plugins
