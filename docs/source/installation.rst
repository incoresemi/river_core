.. See LICENSE.incore for details

.. _quickstart:

.. highlight:: shell

==========
Quickstart
==========

This section is meant to serve as a quick-guide to setup RIVER CORE and perform a sample run of
various phases of the tool. We shall use the AAPG tool as the generator, the
Chromite core as the DUT and Spike as a reference model.

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


Install RIVER CORE
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

   .. tab:: For Dev

     The sources for RIVER_CORE can be downloaded from the `Gitlab Repo <https://gitlab.com/incoresemi/river-framework/core-verification/river_core>`_.
     
     You can clone the repository:
     
     .. code-block:: console
     
         $ git clone https://gitlab.com/incoresemi/river-framework/core-verification/river_core.git
     
     
     Once you have a copy of the source, you can install it with:
     
     .. code-block:: console
         
         $ cd river_core
         $ pip3 install --editable .

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
       $ ./configure --prefix=/path/to/install --enable-multilib # for both 32 and 64bit toolchain
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

Install Generator
=================

AAPG can be easily installed using the following command:

.. code-block:: console

   $ pip install aapg

To test the installation try the ``aapg --help`` command which should print the
following:

.. program-output:: aapg --help

Setup the Plugins
=================

To continue further we shall first create a working directory, say ``myquickstart``

.. code-block:: console

   $ mkdir ~/myquickstart


You can install some of the pre-built plugins from the `Gitlab Repo <https://gitlab.com/incoresemi/river-framework/core-verification/river_core_plugins.git>`_

.. code-block:: console

    $ cd ~/myquickstart
    $ git clone https://gitlab.com/incoresemi/river-framework/core-verification/river_core_plugins.git

We will next create a ``config.ini`` under the ``myquickstart`` directory. You
can use the setup to create this file:

.. code-block:: console

   $ cd ~/myquickstart
   $ river_core setup

The above should create a ``config.ini`` file with the following contents.
Details and further specification of the config file syntax is available at :ref:`Config Spec<config_ini>`.

You will need to change ``user`` to your username in the below file:

.. warning:: Make sure to adjust jobs parameters everywhere accordingly. This
   guide assumes 8 jobs are available for parallel processing.

.. code-block:: ini
   :linenos:

   [river_core]
   # Main directory for all files generated by river_core
   work_dir = mywork 
   
   # Name of the target DuT plugin
   target = chromite_verilator
   
   # Name of the reference model plugin
   reference = spike 
   
   # Name of the generator(s) to be used. Comma separated
   generator = aapg
   
   # ISA for the tests
   isa = rv64imafdc
   
   # Set paths for each plugin
   # TODO Change the following paths
   path_to_target = /home/user/myquickstart/river_core_plugins/dut_plugins
   path_to_ref = /home/user/myquickstart/river_core_plugins/reference_plugins
   path_to_suite = /home/user/myquickstart/river_core_plugins/generator_plugins
   
   # To open the report automatically in the browser
   open_browser = True
   
   # Enable Space Saver
   space_saver = True
   
   # Coverage Options
   # Enable via True/False
   [coverage]
   code = False
   functional = False
   
   [aapg]
   # Number of jobs to use to generate the tests
   jobs = 8
   filter = rv64imafdc_hazards_s
   seed = random
   count = 2
   config_yaml = /home/user/myquickstart/river_core_plugins/generator_plugins/aapg_plugin/aapg_gen_config.yaml
   
   [chromite_verilator]
   jobs = 8
   filter = 
   count = 1
   # src dir: Verilog Dir, BSC Path, Wrapper path
   src_dir = /home/user/myquickstart/chromite/build/hw/verilog/,/tools/bsc/inst/lib/Verilog,/home/user/myquickstart/chromite/bsvwrappers/common_lib
   top_module = mkTbSoc
   
   [spike]
   jobs = 1
   filter =
   count = 1




Setting up the Generator Plugin
-------------------------------

As part of the quickstart we will go with the default settings available in the
config.ini above. One can however modify the parameters under the ``[aapg]``
directive betwee lines 36-41 above

Setting up the DUT Plugin
-------------------------

We will using the chromite core to as a DUT for testing in this quickstart
guide. We shall use the verilator simulator to run tests on the DUT.

The chromite core can be built using the guide available `here
<https://chromite.readthedocs.io/en/latest/getting_started.html>`_. If you
already have the `bsc <https://github.com/B-Lang-org/bsc>`_ compiler and other
dependencies installed you can do the following steps to generate the verilated
executable:

.. code-block:: console

   $ cd ~/myquickstart
   $ git clone https://gitlab.com/incoresemi/core-generators/chromite.git
   $ cd chromite
   $ pip install -r requirements.txt
   $ python -m configure.main
   $ make -j<jobs> generate_verilog

The above steps shall generate a directory: ``build/hw/verilog`` which includes
all the generated verilog files. 

We will next modify the ``config.ini`` to update paths of the directories in
line 48 above. Here we need to provide three paths (in comma separated fashion):

  - path to ``build/hw/verilog``
  - path to Verilog directory present in the bsc installation directory
  - path to ``chromite/bsvwrappers/common_lib``

if you have cloned the ``river_core_plugins`` repo in a different place then you
will need to update the parameter ``path_to_target`` in line 19 above.

Setting up the Reference Plugin
-------------------------------

For this quickstart we will be using a modified version of spike. Do the
following to setup spike:

.. code-block:: console

   $ git clone https://gitlab.com/shaktiproject/tools/mod-spike.git
   $ cd mod-spike
   $ git checkout bump-to-latest
   $ git clone https://github.com/riscv/riscv-isa-sim.git
   $ cd riscv-isa-sim
   $ git checkout 6d15c93fd75db322981fe58ea1db13035e0f7add
   $ git apply ../shakti.patch
   $ export RISCV=<path you to install spike>
   $ mkdir build
   $ cd build
   $ ../configure --prefix=$RISCV # export RISCV to where you would like to install
   $ make
   $ [sudo] make install

As long as spike is available in the your ``$PATH`` no other changes are
required.

Running RIVER CORE
==================

Generating Tests
----------------

.. code-block:: console

   $ cd ~/myquickstart
   $ river_core generate -v debug -c config.ini

You should see the following log on the console:

.. code-block:: console

             info  | ------------RIVER CORE Verification Framework------------
             info  | Version: 0.1.0
             info  | Copyright (c) 2021 InCore Semiconductors Pvt. Ltd.
            debug  | Read file from config.ini
             info  | ****** RiVer Core 0.1.0 *******
             info  | Copyright (c) 2021, InCore Semiconductors Pvt. Ltd.
             info  | All Rights Reserved.
             info  | ****** Generation Mode ****** 
             info  | The river_core is currently configured to run with following parameters
             info  | The Output Directory (work_dir) : mywork
             info  | ISA : rv64imafdc
             info  | Plugin Jobs : 8
             info  | Plugin Seed : random
             info  | Plugin Count (Times to run the test) : 2
             info  | Now loading aapg Suite
            debug  | Loading module from /home/user/myquickstart/river_core_plugins/generator_plugins/aapg_plugin/aapg_plugin.py
            debug  | AAPG Pre Gen Stage
            debug  | exists
            debug  | Extracting info from list
            debug  | /home/user/myquickstart/mywork/aapg/../.json/
            debug  | /home/user/myquickstart/mywork/aapg/../.json/ Directory exists
            debug  | AAPG Plugin gen phase
            debug  | /home/user/myquickstart/river_core_plugins/generator_plugins
            debug  | /home/user/myquickstart/river_core_plugins/generator_plugins/aapg_plugin/gen_framework.py
   ============================================================================================ test session starts ============================================================================================
   platform linux -- Python 3.7.0, pytest-6.1.2, py-1.9.0, pluggy-0.13.1 -- /home/user/.pyenv/versions/3.7.0/envs/venv/bin/python3.7
   cachedir: .pytest_cache
   metadata: {'Python': '3.7.0', 'Platform': 'Linux-5.4.0-31-generic-x86_64-with-debian-bullseye-sid', 'Packages': {'pytest': '6.1.2', 'py': '1.9.0', 'pluggy': '0.13.1'}, 'Plugins': {'metadata': '1.11.0', 'forked': '1.3.0', 'reportlog': '0.1.2', 'html': '3.1.0', 'xdist': '2.1.0'}}
   rootdir: /home/user/myquickstart
   plugins: metadata-1.11.0, forked-1.3.0, reportlog-0.1.2, html-3.1.0, xdist-2.1.0
   [gw0] linux Python 3.7.0 cwd: /home/user/myquickstart        
   [gw1] linux Python 3.7.0 cwd: /home/user/myquickstart        
   [gw2] linux Python 3.7.0 cwd: /home/user/myquickstart        
   [gw3] linux Python 3.7.0 cwd: /home/user/myquickstart        
   [gw4] linux Python 3.7.0 cwd: /home/user/myquickstart        
   [gw5] linux Python 3.7.0 cwd: /home/user/myquickstart        
   [gw6] linux Python 3.7.0 cwd: /home/user/myquickstart        
   [gw7] linux Python 3.7.0 cwd: /home/user/myquickstart        
   [gw0] Python 3.7.0 (default, May 26 2020, 14:51:08)  -- [GCC 9.3.0]
   [gw3] Python 3.7.0 (default, May 26 2020, 14:51:08)  -- [GCC 9.3.0]
   [gw1] Python 3.7.0 (default, May 26 2020, 14:51:08)  -- [GCC 9.3.0]
   [gw2] Python 3.7.0 (default, May 26 2020, 14:51:08)  -- [GCC 9.3.0]
   [gw4] Python 3.7.0 (default, May 26 2020, 14:51:08)  -- [GCC 9.3.0]
   [gw5] Python 3.7.0 (default, May 26 2020, 14:51:08)  -- [GCC 9.3.0]
   [gw6] Python 3.7.0 (default, May 26 2020, 14:51:08)  -- [GCC 9.3.0]
   [gw7] Python 3.7.0 (default, May 26 2020, 14:51:08)  -- [GCC 9.3.0] 
   gw0 [2] / gw1 [2] / gw2 [2] / gw3 [2] / gw4 [2] / gw5 [2] / gw6 [2] / gw7 [2]
   scheduling tests via LoadScheduling
   
   river_core_plugins/generator_plugins/aapg_plugin/gen_framework.py::test_eval[Generating /home/user/myquickstart/river_core_plugins/generator_plugins/aapg_plugin/templates/chromite/rv64imafdc_hazards_s0] 
   river_core_plugins/generator_plugins/aapg_plugin/gen_framework.py::test_eval[Generating /home/user/myquickstart/river_core_plugins/generator_plugins/aapg_plugin/templates/chromite/rv64imafdc_hazards_s1] 
   [gw0] [ 50%] PASSED river_core_plugins/generator_plugins/aapg_plugin/gen_framework.py::test_eval[Generating /home/user/myquickstart/river_core_plugins/generator_plugins/aapg_plugin/templates/chromite/rv64imafdc_hazards_s0] 
   [gw3] [100%] PASSED river_core_plugins/generator_plugins/aapg_plugin/gen_framework.py::test_eval[Generating /home/user/myquickstart/river_core_plugins/generator_plugins/aapg_plugin/templates/chromite/rv64imafdc_hazards_s1] 
   
   ------------------------------------------------------ generated report log file: /home/user/myquickstart/mywork/aapg/../.json/aapg_20210522-1903.json ------------------------------------------------------
   --------------------------------------------------------------- generated html file: file:///home/user/myquickstart/mywork/reports/aapg.html ----------------------------------------------------------------
   ============================================================================================ 2 passed in 12.00s =============================================================================================
             info  | Dumping generated Test-List at: mywork/test_list.yaml
             info  | Validating Generated Test-List
             info  | Test List Validated successfully
  
The above log indicates that you have successfully generated 2 tests using aapg.
The above command would have created a mywork directory with the following
contents:

.. note:: the filenames may differ as aapg uses current time stamps to name
   them.

.. code-block:: bash

  mywork/
  ├── aapg
  │   ├── asm
  │   │   ├── aapg_rv64imafdc_hazards_s_000273_22052021190655560606_00000
  │   │   │   ├── aapg_rv64imafdc_hazards_s_000273_22052021190655560606_00000.ld
  │   │   │   ├── aapg_rv64imafdc_hazards_s_000273_22052021190655560606_00000.S
  │   │   │   ├── aapg_rv64imafdc_hazards_s_000273_22052021190655560606_00000_template.S
  │   │   │   └── rv64imafdc_hazards_s.ini
  │   │   └── aapg_rv64imafdc_hazards_s_003304_22052021190655586548_00001
  │   │       ├── aapg_rv64imafdc_hazards_s_003304_22052021190655586548_00001.ld
  │   │       ├── aapg_rv64imafdc_hazards_s_003304_22052021190655586548_00001.S
  │   │       ├── aapg_rv64imafdc_hazards_s_003304_22052021190655586548_00001_template.S
  │   │       └── rv64imafdc_hazards_s.ini
  │   ├── bin
  │   ├── common
  │   │   ├── crt.S
  │   │   ├── encoding.h
  │   │   ├── illegal_insts.txt
  │   │   └── illegal.pl
  │   ├── config.yaml
  │   ├── log
  │   ├── Makefile
  │   └── objdump
  ├── reports
  │   └── aapg.html
  └── test_list.yaml

The important file here is the test_list.yaml file which shall contain the
information of the generated tests. This file is what will be used in the next
steps to run tests on DUT and Reference Plugins.

You can also open the html report at : ``mywork/reports/aapg.html`` which shall
contain all the information of the build and logs for each test generation.

Running Tests on DUT and Reference
----------------------------------

We shall now generate a verilated executable of the chromite core, compile the
tests and run them on the DUT. We then compile the same tests and run them on
spike and compare the results. Following command shall initiate the whole flow:

.. code-block:: console

   $ cd ~/myquickstart
   $ river_core compile -v debug -t mywork/test_list.yaml -c config.ini

You should see the following log on the console:

.. code-block:: console

             info  | ------------RIVER CORE Verification Framework------------
             info  | Version: 0.1.0
             info  | Copyright (c) 2021 InCore Semiconductors Pvt. Ltd.
            debug  | Read file from config.ini
             info  | ****** RiVer Core 0.1.0 *******
             info  | Copyright (c) 2021, InCore Semiconductors Pvt. Ltd.
             info  | All Rights Reserved.
             info  | ****** Compilation Mode ******
             info  | The river_core is currently configured to run with following parameters
             info  | The Output Directory (work_dir) : mywork
             info  | ISA : rv64imafdc
             info  | Generator Plugin : aapg
             info  | Target Plugin : ['chromite_verilator']
             info  | Reference Plugin : ['spike']
             info  | DuT Info
             info  | DuT Jobs : 8
             info  | DuT Count (Times to run) : 1
             info  | Now running on the Target Plugins
             info  | Now loading chromite_verilator-target
            debug  | Loading module from /home/user/myquickstart/river_core_plugins/dut_plugins/chromite_verilator_plugin/chromite_verilator_plugin.py
             info  | Pre Compile Stage
            debug  | /home/user/myquickstart/mywork//.json/ Directory exists
             info  | Build verilator
             info  | Coverage is disabled, compiling the chromite with usual options
          command  | $ timeout=500 verilator -O3 -LDFLAGS -static --x-assign fast --x-initial fast --noassert sim_main.cpp --bbox-sys -Wno-STMTDLY -Wno-UNOPTFLAT -Wno-WIDTH -Wno-lint -Wno-COMBDLY -Wno-INITIALDLY --autoflush --threads 1 -DBSV_RESET_FIFO_HEAD -DBSV_RESET_FIFO_ARRAY --output-split 20000 --output-split-ctrace 10000 --cc mkTbSoc.v -y /home/user/myquickstart/chromite/build/hw/verilog/ -y /software/open-bsc/lib/Verilog -y /home/user/myquickstart/chromite/bsvwrappers/common_lib --exe 
             info  | Linking verilator simulation sources
          command  | $ timeout=240 ln -f -s ../sim_main.cpp obj_dir/sim_main.cpp 
          command  | $ timeout=240 ln -f -s ../sim_main.h obj_dir/sim_main.h 
             info  | Making verilator binary
          command  | $ timeout=500 make OPT_SLOW=-O3 OPT_FAST=-O3 VM_PARALLEL_BUILDS=1 -j8 -C obj_dir -f VmkTbSoc.mk 
            debug  | make: Entering directory '/home/user/myquickstart/mywork/chromite_verilator/obj_dir'
            debug  | g++  -I.  -MMD -I/usr/share/verilator/include -I/usr/share/verilator/include/vltstd -DVM_COVERAGE=0 -DVM_SC=0 -DVM_TRACE=0 -faligned-new -fcf-protection=none -Wno-bool-operation -Wno-sign-compare -Wno-uninitialized -Wno-unused-but-set-variable -Wno-unused-parameter -Wno-unused-variable -Wno-shadow      -DVL_THREADED -std=gnu++14 -O3 -c -o sim_main.o sim_main.cpp
            debug  | g++  -I.  -MMD -I/usr/share/verilator/include -I/usr/share/verilator/include/vltstd -DVM_COVERAGE=0 -DVM_SC=0 -DVM_TRACE=0 -faligned-new -fcf-protection=none -Wno-bool-operation -Wno-sign-compare -Wno-uninitialized -Wno-unused-but-set-variable -Wno-unused-parameter -Wno-unused-variable -Wno-shadow      -DVL_THREADED -std=gnu++14 -O3 -c -o verilated.o /usr/share/verilator/include/verilated.cpp
            debug  | g++  -I.  -MMD -I/usr/share/verilator/include -I/usr/share/verilator/include/vltstd -DVM_COVERAGE=0 -DVM_SC=0 -DVM_TRACE=0 -faligned-new -fcf-protection=none -Wno-bool-operation -Wno-sign-compare -Wno-uninitialized -Wno-unused-but-set-variable -Wno-unused-parameter -Wno-unused-variable -Wno-shadow      -DVL_THREADED -std=gnu++14 -O3 -c -o VmkTbSoc.o VmkTbSoc.cpp
            debug  | g++  -I.  -MMD -I/usr/share/verilator/include -I/usr/share/verilator/include/vltstd -DVM_COVERAGE=0 -DVM_SC=0 -DVM_TRACE=0 -faligned-new -fcf-protection=none -Wno-bool-operation -Wno-sign-compare -Wno-uninitialized -Wno-unused-but-set-variable -Wno-unused-parameter -Wno-unused-variable -Wno-shadow      -DVL_THREADED -std=gnu++14 -O3 -c -o VmkTbSoc__1.o VmkTbSoc__1.cpp
            debug  | g++  -I.  -MMD -I/usr/share/verilator/include -I/usr/share/verilator/include/vltstd -DVM_COVERAGE=0 -DVM_SC=0 -DVM_TRACE=0 -faligned-new -fcf-protection=none -Wno-bool-operation -Wno-sign-compare -Wno-uninitialized -Wno-unused-but-set-variable -Wno-unused-parameter -Wno-unused-variable -Wno-shadow      -DVL_THREADED -std=gnu++14 -O3 -c -o VmkTbSoc__2.o VmkTbSoc__2.cpp
            debug  | g++  -I.  -MMD -I/usr/share/verilator/include -I/usr/share/verilator/include/vltstd -DVM_COVERAGE=0 -DVM_SC=0 -DVM_TRACE=0 -faligned-new -fcf-protection=none -Wno-bool-operation -Wno-sign-compare -Wno-uninitialized -Wno-unused-but-set-variable -Wno-unused-parameter -Wno-unused-variable -Wno-shadow      -DVL_THREADED -std=gnu++14 -O3 -c -o VmkTbSoc__3.o VmkTbSoc__3.cpp
            debug  | g++  -I.  -MMD -I/usr/share/verilator/include -I/usr/share/verilator/include/vltstd -DVM_COVERAGE=0 -DVM_SC=0 -DVM_TRACE=0 -faligned-new -fcf-protection=none -Wno-bool-operation -Wno-sign-compare -Wno-uninitialized -Wno-unused-but-set-variable -Wno-unused-parameter -Wno-unused-variable -Wno-shadow      -DVL_THREADED -std=gnu++14 -O3 -c -o VmkTbSoc__Slow.o VmkTbSoc__Slow.cpp
            debug  | g++  -I.  -MMD -I/usr/share/verilator/include -I/usr/share/verilator/include/vltstd -DVM_COVERAGE=0 -DVM_SC=0 -DVM_TRACE=0 -faligned-new -fcf-protection=none -Wno-bool-operation -Wno-sign-compare -Wno-uninitialized -Wno-unused-but-set-variable -Wno-unused-parameter -Wno-unused-variable -Wno-shadow      -DVL_THREADED -std=gnu++14 -O3 -c -o VmkTbSoc__1__Slow.o VmkTbSoc__1__Slow.cpp
            debug  | g++  -I.  -MMD -I/usr/share/verilator/include -I/usr/share/verilator/include/vltstd -DVM_COVERAGE=0 -DVM_SC=0 -DVM_TRACE=0 -faligned-new -fcf-protection=none -Wno-bool-operation -Wno-sign-compare -Wno-uninitialized -Wno-unused-but-set-variable -Wno-unused-parameter -Wno-unused-variable -Wno-shadow      -DVL_THREADED -std=gnu++14 -O3 -c -o VmkTbSoc__Syms.o VmkTbSoc__Syms.cpp
            debug  | ar -cr VmkTbSoc__ALL.a VmkTbSoc.o VmkTbSoc__1.o VmkTbSoc__2.o VmkTbSoc__3.o VmkTbSoc__Slow.o VmkTbSoc__1__Slow.o VmkTbSoc__Syms.o
            debug  | ranlib VmkTbSoc__ALL.a
            debug  | g++    sim_main.o verilated.o VmkTbSoc__ALL.a   -static  -pthread -lpthread -latomic -o VmkTbSoc -lm -lstdc++ 
            debug  | make: Leaving directory '/home/user/myquickstart/mywork/chromite_verilator/obj_dir'
             info  | Renaming verilator Binary
             info  | Creating boot-files
          command  | $ timeout=240 make -C /home/user/myquickstart/river_core_plugins/dut_plugins/chromite_verilator_plugin/boot/ XLEN=64 
            debug  | make: Entering directory '/home/user/myquickstart/river_core_plugins/dut_plugins/chromite_verilator_plugin/boot'
            debug  | make: Leaving directory '/home/user/myquickstart/river_core_plugins/dut_plugins/chromite_verilator_plugin/boot'
             info  | Build Hook
            debug  | Creating Make Target for aapg_rv64imafdc_hazards_s_000273_22052021190655560606_00000
            debug  | Creating Make Target for aapg_rv64imafdc_hazards_s_003304_22052021190655586548_00001
             info  | Run Hook
            debug  | Module dir: /home/user/myquickstart/river_core_plugins/dut_plugins
            debug  | Pytest file: /home/user/myquickstart/river_core_plugins/dut_plugins/chromite_verilator_plugin/gen_framework.py
   ======================================== test session starts ========================================
   platform linux -- Python 3.7.0, pytest-6.1.2, py-1.9.0, pluggy-0.13.1
   rootdir: /home/user/myquickstart
   plugins: metadata-1.11.0, forked-1.3.0, reportlog-0.1.2, html-3.1.0, xdist-2.1.0
   [gw2] Python 3.7.0 (default, May 26 2020, 14:51:08)  -- [GCC 9.3.0]
   [gw0] Python 3.7.0 (default, May 26 2020, 14:51:08)  -- [GCC 9.3.0]
   [gw1] Python 3.7.0 (default, May 26 2020, 14:51:08)  -- [GCC 9.3.0]
   [gw3] Python 3.7.0 (default, May 26 2020, 14:51:08)  -- [GCC 9.3.0]
   [gw4] Python 3.7.0 (default, May 26 2020, 14:51:08)  -- [GCC 9.3.0]  
   [gw5] Python 3.7.0 (default, May 26 2020, 14:51:08)  -- [GCC 9.3.0]   
   [gw6] Python 3.7.0 (default, May 26 2020, 14:51:08)  -- [GCC 9.3.0]      
   [gw7] Python 3.7.0 (default, May 26 2020, 14:51:08)  -- [GCC 9.3.0]       
   gw0 [2] / gw1 [2] / gw2 [2] / gw3 [2] / gw4 [2] / gw5 [2] / gw6 [2] / gw7 [2]
   scheduling tests via LoadScheduling
   
   river_core_plugins/dut_plugins/chromite_verilator_plugin/gen_framework.py::test_eval[make -f /home/user/myquickstart/mywork/Makefile.chromite_verilator aapg_rv64imafdc_hazards_s_003304_22052021190655586548_00001] 
   river_core_plugins/dut_plugins/chromite_verilator_plugin/gen_framework.py::test_eval[make -f /home/user/myquickstart/mywork/Makefile.chromite_verilator aapg_rv64imafdc_hazards_s_000273_22052021190655560606_00000] 
   [gw2] [ 50%] PASSED river_core_plugins/dut_plugins/chromite_verilator_plugin/gen_framework.py::test_eval[make -f /home/user/myquickstart/mywork/Makefile.chromite_verilator aapg_rv64imafdc_hazards_s_000273_22052021190655560606_00000] 
   [gw0] [100%] PASSED river_core_plugins/dut_plugins/chromite_verilator_plugin/gen_framework.py::test_eval[make -f /home/user/myquickstart/mywork/Makefile.chromite_verilator aapg_rv64imafdc_hazards_s_003304_22052021190655586548_00001] 
   
   - generated report log file: /home/user/myquickstart/mywork/.json/chromite_verilator_20210522-1924.json -
   ---- generated html file: file:///home/user/myquickstart/mywork/reports/chromite_verilator.html -----
   ======================================== 2 passed in 52.36s =========================================
             info  | Reference Info
             info  | Reference Jobs : 1
             info  | Reference Count (Times to run the test) : 1
             info  | Now loading spike-target
            debug  | Loading module from /home/user/myquickstart/river_core_plugins/reference_plugins/spike_plugin/spike_plugin.py
            debug  | Pre Compile Stage
            debug  | /home/user/myquickstart/mywork//.json/ Directory exists
            debug  | Build Hook
            debug  | Creating Make Target for aapg_rv64imafdc_hazards_s_000273_22052021190655560606_00000
            debug  | Creating Make Target for aapg_rv64imafdc_hazards_s_003304_22052021190655586548_00001
            debug  | Run Hook
            debug  | Module dir: /home/user/myquickstart/river_core_plugins/reference_plugins
            debug  | Pytest file: /home/user/myquickstart/river_core_plugins/reference_plugins/spike_plugin/gen_framework.py
   ======================================== test session starts ========================================
   platform linux -- Python 3.7.0, pytest-6.1.2, py-1.9.0, pluggy-0.13.1
   rootdir: /home/user/myquickstart
   plugins: metadata-1.11.0, forked-1.3.0, reportlog-0.1.2, html-3.1.0, xdist-2.1.0
   [gw0] Python 3.7.0 (default, May 26 2020, 14:51:08)  -- [GCC 9.3.0]
   gw0 [2]
   scheduling tests via LoadScheduling
   
   river_core_plugins/reference_plugins/spike_plugin/gen_framework.py::test_eval[make -f /home/user/myquickstart/mywork/Makefile.spike aapg_rv64imafdc_hazards_s_000273_22052021190655560606_00000] 
   [gw0] [ 50%] PASSED river_core_plugins/reference_plugins/spike_plugin/gen_framework.py::test_eval[make -f /home/user/myquickstart/mywork/Makefile.spike aapg_rv64imafdc_hazards_s_000273_22052021190655560606_00000] 
   river_core_plugins/reference_plugins/spike_plugin/gen_framework.py::test_eval[make -f /home/user/myquickstart/mywork/Makefile.spike aapg_rv64imafdc_hazards_s_003304_22052021190655586548_00001] 
   [gw0] [100%] PASSED river_core_plugins/reference_plugins/spike_plugin/gen_framework.py::test_eval[make -f /home/user/myquickstart/mywork/Makefile.spike aapg_rv64imafdc_hazards_s_003304_22052021190655586548_00001] 
   
   ----- generated report log file: /home/user/myquickstart/mywork/.json/spike_20210522-1925.json ------
   ----------- generated html file: file:///home/user/myquickstart/mywork/reports/spike.html -----------
   ========================================= 2 passed in 3.88s =========================================
             info  | Dumps for test aapg_rv64imafdc_hazards_s_000273_22052021190655560606_00000 Match. TEST PASSED
             info  | Dumps for test aapg_rv64imafdc_hazards_s_003304_22052021190655586548_00001 Match. TEST PASSED
             info  | Checking for a generator json to create final report
            debug  | Detected generated JSON Files: ['mywork/.json/aapg_20210522-1900.json', 'mywork/.json/aapg_20210522-1906.json', 'mywork/.json/aapg_20210522-1903.json']
            debug  | Removing artifacts for Chromite
            debug  | Removing extra files for Test: aapg_rv64imafdc_hazards_s_000273_22052021190655560606_00000
            debug  | Removing extra files for Test: aapg_rv64imafdc_hazards_s_003304_22052021190655586548_00001
            debug  | Removing artifacts for Spike
            debug  | Removing extra files for Test: aapg_rv64imafdc_hazards_s_000273_22052021190655560606_00000
            debug  | Removing extra files for Test: aapg_rv64imafdc_hazards_s_003304_22052021190655586548_00001
             info  | Now generating some good HTML reports for you
             info  | Final report saved at mywork/reports//report_20210522-1925.html
             info  | Openning test report in web-browser
  
At the end you shall also see a html report open up in your default browser
containing information of all the runs.

Congratulations.. you have successfully completed this guide
