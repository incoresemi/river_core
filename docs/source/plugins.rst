.. See LICENSE.incore for details

Plugins
#######

Types of plugins:

Generator Plugins
*****************

.. _aapg:

AAPG
====
`Automated Assembly Program Generator [AAPG] <https://gitlab.com/shaktiproject/tools/aapg>`_ plugin is based on the tool developed by Team Shakti to generate random RISC-V programs to test RISC-V cores.

Ensure you have AAPG installed in your path.

Installation
------------
1. Install `AAPG`

    The easiest way to  install `aapg` is to use `pip`.

    .. code-block:: bash
        
        pip install aapg

    To stay up-to date with the latest developments and fixes you can use the development version.

    .. code-block:: bash
        
        git clone https://gitlab.com/shaktiproject/tools/aapg
        cd aapg
        python3 setup.py install

    This will install aapg on your path.

2. Clone the `aapg_plugin` from `river_core_plugins`

   The `aapg_plugin` can be found in the Generator plugins repo in the `river_core_plugins` repository.


    .. code-block:: bash
        
        git clone https://gitlab.com/incoresemi/river-framework/core-verification/river_core_plugins 
        git checkout dev
        cd generator_plugins/aapg_plugin/

Config.yaml options
-------------------
A YAML file is placed in the aapg plugin folder with the name `aapg_gen_config.yaml`.

- **global_config_path** ->  Path to the plugin directory, TBD
- **global_command** -> Command to generate files. i.e. `aapg gen`

- **templates** -> Ideally the test yamls for AAPG can be stored in a folder which can be then filtered via the filter option in the `config.ini` file.

.. code-block:: yaml

   # Preferred name scheme is given as an example
   templates:
      rv64imafdc:
         path: templates/chromite

Output
------

This plugin will generate a `test-list` containing all necessary information for the framework to compile and test code. 

This can be useful to share test cases across machines. In order to share the tests, one only needs to share the original finals and test-list which contains all necessary infomation about the tests run.


.. _microtesk:

MicroTESK Random Generator
===========================

MicroTESK generator has the RISC-V model developed in nML language and it is used for generation of RISC-V tests from the templates.

.. code-block:: bash

  # generator setup
  $ wget https://forge.ispras.ru/attachments/download/7191/microtesk-riscv-0.1.0-beta-191227.tar.gz
  $ tar -xvzf microtesk-riscv-0.1.0-beta-191227.tar.gz
  $ cd microtesk-riscv-0.1.0-beta-191227
  $ export MICROTESK_HOME=$PWD
  $ sudo apt-get install -y openjdk-11-jdk-headless

  # compiling the model
  $ bash $PWD/bin/compile.sh $PWD/arch/riscv/model/riscv.nml $PWD/arch/riscv/model/mmu/riscv.mmu \
  --extension-dir $PWD/arch/riscv/extensions/ --rev-id RV64FULL

  the rev-id can be configured to use the different ISA present in $PWD/arch/riscv/revisions.xml
  <revision name="RV64FULL">
  <includes name="RV64I"/>
  <includes name="RV64M"/>
  <includes name="RV64A"/>
  <includes name="RV64F"/>
  <includes name="RV32D"/>
  <includes name="RV64D"/>
  <includes name="RV64C"/>
  <includes name="RV32DC"/>
  <includes name="RV32V"/>
  <includes name="RV64"/>
  <excludes name="MEM_SV32"/>

Opensource generator
--------------------

It has a configurable model, generator code, some standard example templates.

Config.yaml options
-------------------

**WIP**

A YAML file is placed in the microtesk plugin file with the name `microtesk_gen_config.yaml`.

- **global_home** -> Path to the microtesk folder
- **global_config_path** -> Path to the template folders in the plugins
- **global_command** -> The command to generate the required assembly files. (Usually `generate.sh riscv`)
- **global_args** -> Args to pass to the microtesk generator (Usually `--solver z3 --generate`)

Output
------

This plugin will generate a `test-list` containing all necessary information for the framework to compile and test code.

This can be useful to share test cases across machines. In order to share the tests, one only needs to share the original finals and test-list which contains all necessary infomation about the tests run.

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



DuT Plugins
***********

.. _chromite:

Chromite
========

`Chromite Core Generator <https://chromite.readthedocs.io/en/latest/>`_ plugin is based on the Chromite core generator developed by Incore Semiconductors.

Chromite is an open-source core generator, based on the SHAKTI C Class core developed at PS CDISHA at the Indian Institute of Technology Madras . The core generator emits synthesizable, production quality RTL of processors based on the open RISC-V ISA.

This guide will explain the steps to install all dependencies to run this plugin.

Design
------

The plugin creates a Makefile in your `workdir` based on the parameters set in `config.yaml`, this is then called by the pytest framework which creates a JSON file containing the file report and runs the makefile in the order.
The framework returns a JSON which is then parsed to create a final HTML report.
Currently it also returns a `rtldump` which is used to compare the working of the design.

Install Chromite Core
^^^^^^^^^^^^^^^^^^^^^
To build a core and to simulate it on a test-soc, you will need the following tools:

1. `Bluespec Compiler <https://github.com/B-Lang-org/bsc>`_: This is required to compile the BSV
   based soc, core, and other devices to Verilog.
2. Python3.7: Python 3.7 is required to configure compilation macros and clone dependencies.
3. `Verilator 4.08+ <https://www.veripool.org/projects/verilator/wiki/Installing>`_: Verilator is
   required for simulation purposes.
4. `RISC-V Toolchain 9.2.0+ <https://github.com/riscv/riscv-gnu-toolchain>`_: You will need to install
   the RISC-V GNU toolchain to be able to compile programs that can run on ChromiteM.
5. `Modified RISC-V ISA Sim <https://gitlab.com/shaktiproject/tools/mod-spike/-/tree/bump-to-latest>`_: This is required for verification and the *elf2hex* utility.
6. `RISC-V OpenOCD <https://github.com/riscv/riscv-openocd>`_ :This is required if you would like to
   simulate through GDB uding remote-bitbang for JTAG communication.

.. note:: The user is advised to install the above tools from their respective repositories/sources.

You will need the following as well, the installation of which is presented below:

1. Python 3.6.0+: see python_
2. DTC version 1.4.7+: see dtc_

Install Dependencies
---------------------

.. _python:

Python
^^^^^^

.. tabs::

   .. tab:: Ubuntu


      Ubuntu 17.10 and 18.04 by default come with python-3.6.9 which is sufficient for using riscv-config.

      If you are are Ubuntu 16.10 and 17.04 you can directly install python3.6 using the Universe
      repository

      .. code-block:: shell-session

        $ sudo apt-get install python3.6
        $ pip3 install --upgrade pip

      If you are using Ubuntu 14.04 or 16.04 you need to get python3.6 from a Personal Package Archive
      (PPA)

      .. code-block:: shell-session

        $ sudo add-apt-repository ppa:deadsnakes/ppa
        $ sudo apt-get update
        $ sudo apt-get install python3.6 -y
        $ pip3 install --upgrade pip

      You should now have 2 binaries: ``python3`` and ``pip3`` available in your $PATH.
      You can check the versions as below

      .. code-block:: shell-session

        $ python3 --version
        Python 3.6.9
        $ pip3 --version
        pip 20.1 from <user-path>.local/lib/python3.6/site-packages/pip (python 3.6)

   .. tab:: CentOS7

      The CentOS 7 Linux distribution includes Python 2 by default. However, as of CentOS 7.7, Python 3
      is available in the base package repository which can be installed using the following commands

      .. code-block:: shell-session

        $ sudo yum update -y
        $ sudo yum install -y python3
        $ pip3 install --upgrade pip

      For versions prior to 7.7 you can install python3.6 using third-party repositories, such as the
      IUS repository

      .. code-block:: shell-session

        $ sudo yum update -y
        $ sudo yum install yum-utils
        $ sudo yum install https://centos7.iuscommunity.org/ius-release.rpm
        $ sudo yum install python36u
        $ pip3 install --upgrade pip

      You can check the versions

      .. code-block:: shell-session

        $ python3 --version
        Python 3.6.8
        $ pip --version
        pip 20.1 from <user-path>.local/lib/python3.6/site-packages/pip (python 3.6)


.. _dtc:

Install DTC (device tree compiler)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

We use the DTC 1.4.7 to generate the device tree string in the boot-files.
To install DTC follow the below commands:

.. code-block:: shell-session

  sudo wget https://git.kernel.org/pub/scm/utils/dtc/dtc.git/snapshot/dtc-1.4.7.tar.gz
  sudo tar -xvzf dtc-1.4.7.tar.gz
  cd dtc-1.4.7/
  sudo make NO_PYTHON=1 PREFIX=/usr/
  sudo make install NO_PYTHON=1 PREFIX=/usr/

.. _build:

Building the Core
-----------------

The code is hosted on Gitlab and can be checked out using the following
command:

.. code-block:: shell-session

  $ git clone https://gitlab.com/incoresemi/core-generators/chromite.git

If you are cloning the chromite repo for the first time it would be best to install the dependencies
first:

.. code-block:: shell-session

  $ cd chromite/
  $ pyenv activate venv # ignore this is you are not using pyenv
  $ pip install -U -r chromite/requirements.txt

The Chromite core generator takes a specific `YAML<configure_core_label>` format as input. It makes specific checks to
validate if the user has entered valid data and none of the parameters conflict with each other.
For e.g., mentioning the 'D' extension without the 'F' will get captured by the generator as an
invalid spec. More information on the exact parameters and constraints on each field are discussed
here.

Once the input YAML has been validated, the generator then clones all the dependent repositories
which enable building a test-soc, simulating it and performing verification of the core.
This is an alternative to maintaining the repositories as submodules, which
typically pollutes the commit history with bump commits.

At the end, the generator outputs a single ``makefile.inc`` in the same folder that it was run,
which contains definitions of paths where relevant bluespec files are present, bsc command with
macro definitions, verilator simulation commands, etc.

A sample yaml input YAML (`default.yaml`) is available in the ``sample_config`` directory of the
repository.

To build the core with a sample test-soc using the default config do the following:

.. code-block:: shell-session

  $ python -m configure.main -ispec sample_config/default.yaml

The above step generates a ``makefile.inc`` file in the same folder and also
clones other dependent repositories to build a test-soc and carry out
verification. This should generate a log something similar to::

  [INFO]    : ************ Chromite Core Generator ************
  [INFO]    : ------ Copyright (c) InCore Semiconductors ------
  [INFO]    : ---------- Available under BSD License----------
  [INFO]    :


  [INFO]    : Checking pre-requisites
  [INFO]    : Cloning "cache_subsystem" from URL "https://gitlab.com/incoresemi/blocks/cache_subsystem"
  [INFO]    : Checking out "1.0.0" for repo "cache_subsystem"
  [INFO]    : Cloning "common_bsv" from URL "https://gitlab.com/incoresemi/blocks/common_bsv"
  [INFO]    : Checking out "master" for repo "common_bsv"
  [INFO]    : Cloning "fabrics" from URL "https://gitlab.com/incoresemi/blocks/fabrics"
  [INFO]    : Checking out "1.1.1" for repo "fabrics"
  [INFO]    : Cloning "bsvwrappers" from URL "https://gitlab.com/incoresemi/blocks/bsvwrappers"
  [INFO]    : Checking out "master" for repo "bsvwrappers"
  [INFO]    : Cloning "devices" from URL "https://gitlab.com/incoresemi/blocks/devices"
  [INFO]    : Checking out "1.0.0" for repo "devices"
  [INFO]    : Cloning "verification" from URL "https://gitlab.com/shaktiproject/verification_environment/verification"
  [INFO]    : Checking out "4.0.0" for repo "verification"
  [INFO]    : Applying Patch "/scratch/git-repo/incoresemi/core-generators/chromite/verification/patches/riscv-tests-shakti-signature.patch" to "/scratch/git-repo/incoresemi/core-generators/chromite/verification/patches/riscv-tests-shakti-signature.patch"
  [INFO]    : Cloning "benchmarks" from URL "https://gitlab.com/incoresemi/core-generators/benchmarks"
  [INFO]    : Checking out "master" for repo "benchmarks"
  [INFO]    : Loading input file: /scratch/git-repo/incoresemi/core-generators/chromite/sample_config/default.yaml
  [INFO]    : Load Schema configure/schema.yaml
  [INFO]    : Initiating Validation
  [INFO]    : No Syntax errors in Input Yaml.
  [INFO]    : Performing Specific Checks
  [INFO]    : Generating BSC compile options
  [INFO]    : makefile.inc generated
  [INFO]    : Creating Dependency graph
  [WARNING] : path: .:%/Libraries:src/:src/predictors:src/m_ext:src/fpu/:src/m_ext/..........
  defines: Addr_space=25 ASSERT rtldump RV64 ibuswidth=64 dbuswidth=64 .......
  builddir: build/hw/intermediate
  topfile: test_soc/TbSoc.bsv
  outputfile: depends.mk
  argv:
  generated make dependency rules for "test_soc/TbSoc.bsv" in: depends.mk
  [INFO]    : Dependency Graph Created
  [INFO]    : Cleaning previously built code
  [WARNING] : rm -rf build/hw/intermediate/* *.log bin/* obj_dir build/hw/verilog/*
  rm -f *.jou rm *.log *.mem log sim_main.h cds.lib hdl.var
  [INFO]    : Run make -j<jobs>



To compile the bluespec source and generate verilog

.. code-block:: shell-session

  $ make -j<jobs> generate_verilog

If you are using the samples/default.yaml config file, this should generate the following folders:

1. build/hw/verilog: contains the generated verilog files.
2. build/hw/intermediate: contains all the intermediate and information files generated by bsc.

To create a verilated executable:

.. code-block:: shell-session

   $ make link_verilator

This will generate a ``bin`` folder containing the verilated ``chromite_core`` executable.

.. note:: The user can also refer to the most up-to-date setup instructions at https://chromite.readthedocs.io/en/latest/getting_started.html.


BootRom Content
^^^^^^^^^^^^^^^

By default, on system-reset the core will always jump to ``0x1000`` which is mapped to the bootrom.
The bootrom is initialized using the file ``boot.mem``. The bootrom after a few instructions
causes a re-direction jump to address ``0x80000000`` where the application program is expected to be.
It is thus required that all programs are linked with text-section begining at ``0x80000000``.
The rest of the boot-rom holds a dummy device-tree-string information.

To ``boot.mem`` file is generated in the ``bin`` folder using the following command:

.. code-block:: shell-session

   $ make generate_boot_files



Chromite [Verilator]
====================
This section will help you setup the `chromite_verilator`` plugin.

Installation
------------
1. Install :ref:`Chromite <chromite>`
2. Configure `chromite_verilator.py`


Configuring river_core.ini
----------------------------

Things to configure
^^^^^^^^^^^^^^^^^^^

- In `river_core.ini`, you will have to configure

  1. `src_dir` = Absolute paths to following directories, seperated by commas

    [0] - Verilog Dir [ending with 'build/hw/verilog/']

    [1] - BSC Path [ending with 'lib/Verilog']

    [2] - Wrapper path [ending with 'chromite/bsvwrappers/common_lib']

    An example:

    .. code-block:: bash

        # src dir
        # Verilog Dir
        # BSC Path
        # Wrapper path
        src_dir = /home/vagrant/core/chromite/build/hw/verilog/,/home/vagrant/tools/bsc/inst/lib/Verilog,/home/vagrant/core/chromite/bsvwrappers/common_lib


  2. `top_module` = The top most module for simulation

    .. code-block:: bash

        # Top Module for simulation
        top_module = mkTbSoc


Reference Plugins
*****************

.. _spike:

Spike
=====

`Spike [Mod] <https://gitlab.com/shaktiproject/tools/mod-spike>`_ plugin is based on the mod-spike developed by Team Shakti.

`mod-spike` is a modified version of the RISC-V ISA Simulator written by Andrew Waterman and Yunsup Lee.
`mod-spike` has different custom extensions to spike, which is helpful for getting better insight into the RISC-V simulation at the ISA level.

Installation
------------
1. Clone the `modified` spike directory

      .. code-block:: shell-session

        $ git clone https://gitlab.com/shaktiproject/tools/mod-spike.git

2. Checkout to the `bump-to-latest` branch

      .. code-block:: shell-session

        $ cd mod-spike
        $ git checkout bump-to-latest

3. Now clone the latest spike repo from Github.

      .. code-block:: shell-session

        $ git clone https://github.com/riscv/riscv-isa-sim.git

4. Apply the `shakti.patch` to the original repo.

      .. code-block:: shell-session

        $ cd riscv-isa-sim
        $ git checkout 6d15c93fd75db322981fe58ea1db13035e0f7add
        $ git apply ../shakti.patch

5. Now export `RISCV` path and create a `build` to store the new compiled executable.

      .. code-block:: shell-session

        $ export RISCV=<path you to install spike>
        $ mkdir build
        $ cd build

6. Configure and build the new spike with the modifications. Optionally you can install with `sudo` permissions.

      .. code-block:: shell-session

         $ ../configure --prefix=$RISCV
         $ make
         $ [sudo] make install




Design
------

The plugin creates a Makefile in your `workdir` based on the parameters set in `config.ini`, this is then called by the pytest framework which creates a JSON file containing the file report and runs the makefile in the order.
The framework returns a JSON which is then parsed to create a final HTML report.
Currently it also returns a `dut.dump` which is used to compare the working of the design.
