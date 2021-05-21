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



