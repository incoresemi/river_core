.. _testfloat:

Testfloat
=========
Testfloat plugin is based on the on the `Berkeley TestFloat <http://www.jhauser.us/arithmetic/TestFloat.html>`_ program, which checks whether an implementation of binary floating-point conforms to the IEEE Standard for Floating-Point Arithmetic.

You'll have to install the above Testfloat (Release 3e) and the `Berkeley TestFloat <http://www.jhauser.us/arithmetic/SoftFloat.html>`_ into a common directory.

Installation
------------

1. Install `Berkeley Testfloat`

   Download the Testfloat and Softfloat ZIP files.

   .. code-block:: console

      $ wget 'http://www.jhauser.us/arithmetic/TestFloat-3e.zip'
      $ wget 'http://www.jhauser.us/arithmetic/SoftFloat-3e.zip'

2. Unzip both the ZIP files

   .. code-block:: console

      $ unzip TestFloat-3e.zip
      $ unzip SoftFloat-3e.zip

3. Build the Testfloat and Softfloat utilities.

   .. code-block:: console

      #Assuming that your system is a x86-64 system with GCC
      $ cd SoftFloat-3e/build/Linux-x86_64-GCC/
      #Other alternatives are available in build, please check your system configuration before running make
      $ make

      #Assuming that your system is a x86-64 system with GCC
      $ cd TestFloat-3e/build/Linux-x86_64-GCC/
      #Other alternatives are available in build, please check your system configuration before running make
      $ make



Config.yaml options
-------------------
A YAML file is placed in the testfloat plugin folder with the name `testfloat_gen_config.yaml`.

- **gen_binary_path** -> Path to the testfloat_gen command

As for the instructions to be generated using the plugin, one has to follow the below convention to generate files.

.. code-block:: yaml

   # path to where the testfloat_gen path. The following is enough if it exists in your $PATH
   gen_binary_path: testfloat_gen
   
   # Essential to start set_* for naming, that's how the plugin detects the name
   set_1:
       # Instruction to generate using the plugin
       inst: [fadd.s, fsub.s, fmul.s, fdiv.s]
       # Range of possible values for the destination register
       dest: 0,31
       # Range of possible values for the source register 1
       reg1: 0,31
       # Range of possible values for the source register 2
       reg2: 0,31
       # Rounding mode for the floating point operation. Legal values are: RNE, RTZ, RDN, RUP, RMM
       rounding-mode: [RNE]
       # Needs to be above 46464. this is a testfloat limitation.
       tests_per_instruction: 46464
       # Number of tests generated per instruction per rounding mode combination
       num_tests: 4

   # you can define a new set with new combinations in the same file. Generator will parse through all sets
   set_5:
        inst: [fmadd.s]
        dest: 0,9
        reg1: 0,12
        reg2: 0,10
        reg3: 0,10
        rounding-mode: [RUP]
        tests_per_instruction: 6133248 # needs to above minimum definition required by testfloat
        num_tests: 8 


Instance in Config.ini
----------------------

To use TestFloat in the config.ini the following template can be followed:

.. code-block:: ini

   path_to_suite = ~/river_core_plugins/generator_plugins
   generator = testfloat

   [testfloat]
   # number of parallel jobs
   jobs=8
   # seed to use for testfloat_gen command
   seed = random
   # path to the yaml conforming to the above spec.
   config_yaml = /scratch/git-repo/incoresemi/river-framework/core-verification/river_core_plugins/generator_plugins/testfloat_plugin/testfloat_gen_config.yaml

.. note:: one can maintain multiple \*_gen_config.yaml files and simple point to them in the main
   config.ini to change configurations. 

