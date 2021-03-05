.. See LICENSE.incore for details

.. _quickstart:

.. highlight:: shell

==========
Quickstart
==========

This section is meant to serve as a quick-guide to setup RIVER_CORE and perform a sample run of
various phases of the tool.

Install Python
==============

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

Using Virtualenv for Python 
---------------------------

Many a times users face issues in installing and managing multiple python versions. This is actually 
a major issue as many gui elements in Linux use the default python versions, in which case installing
python3.6 using the above methods might break other software. We thus advise the use of **pyenv** to
install python3.6.

For Ubuntu and CentosOS, please follow the steps here: https://github.com/pyenv/pyenv#basic-github-checkout

RHEL users can find more detailed guides for virtual-env here: https://developers.redhat.com/blog/2018/08/13/install-python3-rhel/#create-env

Once you have pyenv installed do the following to install python 3.6.0::

  $ pyenv install 3.6.0
  $ pip3 install --upgrade pip
  $ pyenv shell 3.6.0
  
You can check the version in the **same shell**::

  $ python --version
  Python 3.6.0
  $ pip --version
  pip 20.1 from <user-path>.local/lib/python3.6/site-packages/pip (python 3.6)


Install RIVER_CORE
==================

.. tabs:: 

   .. tab:: via Git

     To install RIVER_CORE, run this command in your terminal:
     
     .. code-block:: console
     
         $ pip3 install git+https://gitlab.com/incoresemi/river-framework/core-verification/river_core.git
     
     This is the preferred method to install RIVER_CORE, as it will always install the most recent stable release.
     
     If you don't have `pip`_ installed, this `Python installation guide`_ can guide
     you through the process.
     
     .. _pip: https://pip.pypa.io
     .. _Python installation guide: http://docs.python-guide.org/en/latest/starting/installation/

   .. tab:: via Pip

     .. note:: If you are using `pyenv` as mentioned above, make sure to enable that environment before
      performing the following steps.
     
     .. code-block:: bash
     
       $ pip3 install river_core
     
     To update an already installed version of RIVER_CORE to the latest version:
     
     .. code-block:: bash
     
       $ pip3 install -U river_core
     
     To checkout a specific version of RIVER_CORE:
     
     .. code-block:: bash
     
       $ pip3 install river_core==1.x.x

   .. tab:: for Dev

     The sources for RIVER_CORE can be downloaded from the `GitLab repo`_.
     
     You can clone the repository:
     
     .. code-block:: console
     
         $ git clone https://gitlab.com/incoresemi/river-framework/core-verification/river_core.git
     
     
     Once you have a copy of the source, you can install it with:
     
     .. code-block:: console
         
         $ cd river_core
         $ pip3 install --editable .
     
     .. _Gitlab repo: https://gitlab.com/incoresemi/river-framework/core-verification/river_core

Test RIVER_CORE
===============

Once you have installed RIVER_CORE you can execute ``river_core --help`` to print the help routine:

.. code-block:: bash

  Usage: river_core [OPTIONS] COMMAND [ARGS]...
  
    RiVer Core verification framework 
  
    See LICENSE for details 
  
    Is your config.ini ready? Configure RiVer Core there!
  
  Options:
    --help  Show this message and exit.
  
  Commands:
    clean     subcommand to clean generated programs.
    compile   subcommand to compile generated programs.
    generate  subcommand to generate programs.

Install RISCV-GNU Toolchain
===========================

This guide will use the 32-bit riscv-gnu tool chain to compile the architectural suite.
If you already have the 32-bit gnu-toolchain available, you can skip to the next section.

.. note:: The git clone and installation will take significant time. Please be patient. If you face
   issues with any of the following steps please refer to
   https://github.com/riscv/riscv-gnu-toolchain for further help in installation.

.. tabs::
   .. tab:: Ubuntu

     .. code-block:: bash
       
       $ sudo apt-get install autoconf automake autotools-dev curl python3 libmpc-dev \
             libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo gperf libtool \
             patchutils bc zlib1g-dev libexpat-dev
       $ git clone --recursive https://github.com/riscv/riscv-gnu-toolchain
       $ git clone --recursive https://github.com/riscv/riscv-opcodes.git
       $ cd riscv-gnu-toolchain
       $ ./configure --prefix=/path/to/install --with-arch=rv32gc --with-abi=ilp32d # for 32-bit toolchain
       $ [sudo] make # sudo is required depending on the path chosen in the previous setup
     
   .. tab:: CentosOS/RHEL
     
     .. code-block:: bash
     
       $ sudo yum install autoconf automake python3 libmpc-devel mpfr-devel gmp-devel \
             gawk  bison flex texinfo patchutils gcc gcc-c++ zlib-devel expat-devel
       $ git clone --recursive https://github.com/riscv/riscv-gnu-toolchain
       $ git clone --recursive https://github.com/riscv/riscv-opcodes.git
       $ cd riscv-gnu-toolchain
       $ ./configure --prefix=/path/to/install --with-arch=rv32gc --with-abi=ilp32d # for 32-bit toolchain
       $ [sudo] make # sudo is required depending on the path chosen in the previous setup

Make sure to add the path ``/path/to/install`` to your `$PATH` in the .bashrc/cshrc
With this you should now have all the following available as command line arguments::

  riscv32-unknown-elf-addr2line      riscv32-unknown-elf-elfedit
  riscv32-unknown-elf-ar             riscv32-unknown-elf-g++
  riscv32-unknown-elf-as             riscv32-unknown-elf-gcc
  riscv32-unknown-elf-c++            riscv32-unknown-elf-gcc-8.3.0
  riscv32-unknown-elf-c++filt        riscv32-unknown-elf-gcc-ar
  riscv32-unknown-elf-cpp            riscv32-unknown-elf-gcc-nm
  riscv32-unknown-elf-gcc-ranlib     riscv32-unknown-elf-gprof
  riscv32-unknown-elf-gcov           riscv32-unknown-elf-ld
  riscv32-unknown-elf-gcov-dump      riscv32-unknown-elf-ld.bfd
  riscv32-unknown-elf-gcov-tool      riscv32-unknown-elf-nm
  riscv32-unknown-elf-gdb            riscv32-unknown-elf-objcopy
  riscv32-unknown-elf-gdb-add-index  riscv32-unknown-elf-objdump
  riscv32-unknown-elf-ranlib         riscv32-unknown-elf-readelf
  riscv32-unknown-elf-run            riscv32-unknown-elf-size
  riscv32-unknown-elf-strings        riscv32-unknown-elf-strip


.. note:: Each of the generators have their own unique config.yamls to configure their plugin specific details, ensure you have changed them as required.

Install Test Generators
=======================
Some of the existing generator plugins include:

- `Microtesk <microtesk.html>`_

- `AAPG <aapg.html>`_

Install Plugin Models
=====================
Some of the existing plugin models are:

- `Chromite <chromite.html>`_


Install Reference Models
========================
Some of the existing reference models are:

- `Spike <spike.html>`_


Create a config.ini file
========================

.. _config-file: https://gitlab.com/incoresemi/river-framework/core-verification/river_core/-/blob/dev/examples/sample-config.ini
This chapter will discuss the syntax and structure of the config.ini file used by river_core.
A sample `config-file`_ is present in the **examples** directory of the Git Repository.

More info on the `Config Spec <config_ini.html>`_

Running RIVER_CORE
==================

For taking RIVER_CORE for a test run,

1. To generate tests

.. code-block:: bash

    river_core generate -o <output-dir> -c  /path/to/river_core/examples/sample-config.ini

You can pass a `-v` flag to get more verbose results, optional flag.

.. IMPORTANT:: This would only generate AAPG based tests.

2. To compile and test on DuT and Reference Plugins

.. code-block:: bash

    river_core compile -c /path/to/river_core/examples/sample-config.ini -s /path/to/asm/dir/work/


After the tests are complete you will see that a HTML file is created in your output dir, that will contain all necessary info whether your design has matched or failed, the duration and other necessary logs generated.
