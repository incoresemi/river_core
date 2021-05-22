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

     The sources for RIVER_CORE can be downloaded from the `Gitlab repo`_.
     
     You can clone the repository:
     
     .. code-block:: console
     
         $ git clone https://gitlab.com/incoresemi/river-framework/core-verification/river_core.git
     
     
     Once you have a copy of the source, you can install it with:
     
     .. code-block:: console
         
         $ cd river_core
         $ pip3 install --editable .
     
     .. _Gitlab repo: https://gitlab.com/incoresemi/river-framework/core-verification/river_core

Testing Installation
--------------------

Output for ``river_core --help``:

.. program-output:: river_core --help

Output for ``river_core clean --help``:

.. program-output:: river_core clean --help

Output for ``river_core generate --help``:

.. program-output:: river_core generate --help

Output for ``river_core compile --help``:

.. program-output:: river_core compile --help

Output for ``river_core merge --help``:

.. program-output:: river_core merge --help

Install RIVER_CORE Plugins
==========================

You can install the plugins, by cloning the plugin code from the `Gitlab Repo <https://gitlab.com/incoresemi/river-framework/core-verification/river_core_plugins.git>`_

.. code-block:: console

    $ git clone https://gitlab.com/incoresemi/river-framework/core-verification/river_core_plugins.git


Install RISCV-GNU Toolchain
===========================

This guide will use the 32-bit riscv-gnu tool chain to compile the architectural suite.
If you already have the 32-bit gnu-toolchain available, you can skip to the next section.

.. note:: The git clone and installation will take significant time. Please be patient. If you face
   issues with any of the following steps please refer to
   https://github.com/riscv/riscv-gnu-toolchain for further help in installation.

.. tabs::
   .. tab:: Ubuntu (32/64bit)

     .. code-block:: bash
       
       $ sudo apt-get install autoconf automake autotools-dev curl python3 libmpc-dev \
             libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo gperf libtool \
             patchutils bc zlib1g-dev libexpat-dev
       $ git clone --recursive https://github.com/riscv/riscv-gnu-toolchain
       $ git clone --recursive https://github.com/riscv/riscv-opcodes.git
       $ cd riscv-gnu-toolchain
       $ ./configure --prefix=/path/to/install --enable-multilib # for both 32 and 64bit
       $ [sudo] make # sudo is required depending on the path chosen in the previous setup
     
   .. tab:: CentosOS/RHEL (32/64bit)
     
     .. code-block:: bash
     
       $ sudo yum install autoconf automake python3 libmpc-devel mpfr-devel gmp-devel \
             gawk  bison flex texinfo patchutils gcc gcc-c++ zlib-devel expat-devel
       $ git clone --recursive https://github.com/riscv/riscv-gnu-toolchain
       $ git clone --recursive https://github.com/riscv/riscv-opcodes.git
       $ cd riscv-gnu-toolchain
       $ ./configure --prefix=/path/to/install --enable-multilib # for both 32 and 64bit
toolchain
       $ [sudo] make # sudo is required depending on the path chosen in the previous setup


Make sure to add the path ``/path/to/install`` to your `$PATH` in the .bashrc/cshrc
With this you should now have all the following available as command line arguments::

  riscv64-unknown-elf-addr2line      riscv64-unknown-elf-elfedit
  riscv64-unknown-elf-ar             riscv64-unknown-elf-g++
  riscv64-unknown-elf-as             riscv64-unknown-elf-gcc
  riscv64-unknown-elf-c++            riscv64-unknown-elf-gcc-8.3.0
  riscv64-unknown-elf-c++filt        riscv64-unknown-elf-gcc-ar
  riscv64-unknown-elf-cpp            riscv64-unknown-elf-gcc-nm
  riscv64-unknown-elf-gcc-ranlib     riscv64-unknown-elf-gprof
  riscv64-unknown-elf-gcov           riscv64-unknown-elf-ld
  riscv64-unknown-elf-gcov-dump      riscv64-unknown-elf-ld.bfd
  riscv64-unknown-elf-gcov-tool      riscv64-unknown-elf-nm
  riscv64-unknown-elf-gdb            riscv64-unknown-elf-objcopy
  riscv64-unknown-elf-gdb-add-index  riscv64-unknown-elf-objdump
  riscv64-unknown-elf-ranlib         riscv64-unknown-elf-readelf
  riscv64-unknown-elf-run            riscv64-unknown-elf-size
  riscv64-unknown-elf-strings        riscv64-unknown-elf-strip


.. note:: Each of the generators have their own unique config.yamls to configure their plugin specific details, ensure you have changed them as required.



Create a river_core.ini file
============================

.. _config-file: https://gitlab.com/incoresemi/river-framework/core-verification/river_core/-/blob/dev/examples/sample-config.ini

`RiVer Core` can be easily configured with `river_core.ini` to control various aspects of tests run on the framework.
A sample `config-file`_ present in the **examples** directory is captured below for reference:

.. program-output:: cat ../../examples/sample-config.ini

Details and further specification of the config file syntax is available at :ref:`Config Spec<config_ini>`.

Setup the Plugins
=================

Plugins are divided into 3 categories in `RiVer Core` framework:

1. Generator Plugins

2. DuT Plugins

3. Reference Plugins

Each of the plugins `YAML` file associated to configure options specific to the plugin.

    .. Note:: To get `RiVer Core` up and running, you are required to have atleast 1 of each type of plugins.

All the plugins are configured with basic settings.

More information about setting up and installing the plugins on :ref:`Plugins <plugins>`

Running RIVER_CORE
==================

For taking RIVER_CORE for a test run,


1. To generate test programs use:

    .. code-block:: bash

        river_core generate -c <path to config> -v <level>
        river_core --help // For more info

    The only parameter required for this step is a valid `config.ini`, for more info check :ref:`Config Spec <config_ini>`

    You can pass a `-v` flag to get more verbose results, optional flag.

    .. Note:: This generates a test list which can then be used for compliations

2. To compile and compare programs use:

    .. code-block:: bash

        river_core compile -c <path to config> -t <path to test_list> -v <level> 

    You can pass a `-v` flag to get more verbose results, optional flag.

    This step will generate an HTML report showing the status and linking other reports, and short summary of the log comparison 

3. To clean your existing directory:

    .. code-block:: bash

        river_core clean -c <path to config>

    This step will remove everything inside your `work_dir`. 

    Will ask for confirmation once before removing anything.
