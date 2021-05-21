.. _testfloat:

Testfloat
=========
Testfloat plugin is based on the on the `Berkeley TestFloat <http://www.jhauser.us/arithmetic/TestFloat.html>`_ program, which checks whether an implementation of binary floating-point conforms to the IEEE Standard for Floating-Point Arithmetic.

You'll have to install the above Testfloat (Release 3e) and the `Berkeley TestFloat <http://www.jhauser.us/arithmetic/SoftFloat.html>`_ into a common directory.

Installation
------------
1. Install `Berkeley Testfloat`

    Download the Testfloat and Softfloat ZIP files.

    .. code-block:: bash

        wget 'http://www.jhauser.us/arithmetic/TestFloat-3e.zip'
        wget 'http://www.jhauser.us/arithmetic/SoftFloat-3e.zip'

2. Unzip both the ZIP files

    .. code-block:: bash

       unzip TestFloat-3e.zip
       unzip SoftFloat-3e.zip

3. Build the Testfloat and Softfloat utilities.

    .. code-block:: bash

       # Assuming that your system is a x86-64 system with GCC
       cd SoftFloat-3e/build/Linux-x86_64-GCC/
       # Other alternatives are available in build, please check your system configuration before running make
       make

       # Assuming that your system is a x86-64 system with GCC
       cd TestFloat-3e/build/Linux-x86_64-GCC/
       # Other alternatives are available in build, please check your system configuration before running make
       make



Config.yaml options
-------------------
A YAML file is placed in the testfloat plugin folder with the name `testfloat_gen_config.yaml`.

- **gen_binary_path** -> Path to the testfloat_gen command

As for the instructions to be generated using the plugin, one has to follow the below convention to generate files.

.. code-block:: yaml

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
        # Rounding mode for the floating point operation
        rounding-mode: [RNE]
        # Needs to be above 46464
        tests_per_instruction: 46464
        # Number of tests generated
        num_tests: 4


Output
------

This plugin will generate a `test-list` containing all necessary information for the framework to compile and test code.

This can be useful to share test cases across machines. In order to share the tests, one only needs to share the original finals and test-list which contains all necessary infomation about the tests run.


