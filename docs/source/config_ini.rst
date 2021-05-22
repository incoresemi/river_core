.. _config_ini:

===============
Config.ini Spec
===============

.. _config-file: https://gitlab.com/incoresemi/river-framework/core-verification/river_core/-/blob/dev/examples/sample-config.ini

This chapter will discuss the syntax and structure of the ``config.ini`` file used by river_core.
A sample `config-file`_ is present in the ``examples`` directory of the Git Repository.

.. note:: `RIVER CORE` can automatically detect the configuration file present in the current directory.


General Configuration Options
#############################

.. tabularcolumns:: |l|L|

.. table:: General Configuration Options

  =================== =========================================================
  Parameter           Description
  =================== =========================================================
  workdir             The workdir where all of the files, reports and logs are generated.
  target              Name of Target or the Device under Test(DuT) that is to be verified. 
  reference           Name of the the golden reference model to be used for verification.
  generator           The test program generator to be used to generate tests.
  path_to_suite       Absolute path to the generator plugin.
  path_to_target      Absolute path to the target/DUT plugin.
  path_to_ref         Absolute path to the reference plugin.
  isa                 ISA string supported by the target. This is supplied to all plugins forany due processing/configuration that is required.
  open_browser        [Boolean] Opens the final report automatically in your default browser
  space_saver         [Boolean] This feature can be used by DUT and Ref plugins to remove unwanted artifacts (like dumps, disassembly files, etc) after the tests have been run
  coverage            Enable Coverage mode. There are two boolean options available under this: Code and Functional
  =================== =========================================================

.. note:: The standard delimiter for options having mutliple values is **,** (comma) .

Plugin Specific Options
#######################

Apart from the above general parameters, the user can also specify some of the
plugin specific parameters in the same ``config.ini`` file. A typical syntax to
do this would be:

.. code-block:: ini

   [<plugin-name>]
   config-1: value
   config-2: value-2

   [<plugin-name2]
   param-1: val1
   param-2: val2


The interpretation and side-effects of these plugin specific parameters is completely left to the
plugin. RIVER CORE simply forwards them to the respective plugin via the hooks.

.. note:: A plugins paramters cannot be sent to another plugin. However each
   plugin will recieve its parameters and also the general configuration
   parameters

Some of the recommended configuration options for generators would be:

.. tabularcolumns:: |l|L|

.. table:: Recommended Configuration options

  ========== ====================================================================
  Parameters Description
  ========== ====================================================================
  jobs       Number of jobs to use while generating the tests
  filter     This option is to select tests.
  seed       A seed for generating the programs (Can be *random*)
  count      The number of times the test needs to be run
  ========== ====================================================================

Sample Config INI
#################

.. program-output:: cat ../../examples/sample-config.ini
