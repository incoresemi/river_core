.. _config_ini:

===============
Config.ini Spec
===============

.. _config-file: https://gitlab.com/incoresemi/river-framework/core-verification/river_core/-/blob/dev/examples/sample-config.ini

This chapter will discuss the syntax and structure of the config.ini file used by river_core.
A sample `config-file`_ is present in the **examples** directory of the Git Repository.

.. note:: The standard delimiter for options having mutliple values is **,** (comma) .

Configuration options for river_core
#####################################

- **river_core** contains generic information that's specific to river_core. Ideally for a test, this should remain same.

  - **workdir** -> The workdir where all of the files, reports and logs are generated.
  - **target** -> Device under Test(DuT), the target to run tests. 
  - **reference** -> The Golden Standard used for comparing with the target results.
  - **generator** -> The program generator used to generate sample programs
  - **path_to_suite** -> Absolute path to the generator module
  - **path_to_target** -> Absolute path to the target module
  - **path_to_ref** -> Absolute path to the reference module
  - **isa** -> ISA for the arch, all of the plugins will use the same ISA.
  - **open_browser** -> Opens the final report automatically in your default browser [Boolean]
  - **space_saver** -> ISA for the arch, all of the plugins will use the same ISA. [Boolean]
  - **Coverage** -> Enable Coverage mode. More info in :ref:`Coverage<coverage>`

Configuration options for plugins
####################################

Some of the necessary configuration options

- **plugin** specific options

  - **jobs** -> Number of jobs to use while generating the tests
  - **filter** -> This option is to select tests. More info `here <https://docs.pytest.org/en/latest/example/markers.html#using-k-expr-to-select-tests-based-on-their-name>`_ 
  - **seed** -> A seed for generating the programs (Can be *random*)
  - **count** -> The number of times the test needs to be run
