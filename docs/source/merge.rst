.. See LICENSE.incore for details

##########
Merge Flow
##########

The following diagram captures RiVer Core Framework's `merge` subcommand. 
The idea behind the subcommand was to assimilate  the artifacts of various tests 
(test-lists, coverage database, ranks, etc.) into a single directory.

.. image:: _static/Merge.png
    :align: center
    :alt: merge-flow


What does it internally do?
===========================

1. Create a new output directory, remove the existing one after confirming.
2. Parse the `test_list.yaml` from each `directory` that was received as input to the `merge` subcommand.
3. Copy the `asm` directories from original work directories into the `merged` output directory.
4. Create a new dictionary for a merged `YAML`, based on new paths.
5. Check for coverage files and if they are found, call the selected plugin in the `config.ini` and call the `merge` API.
6. After that is completed, the user is given the option to remove the original directories.


=============
Usage Example
=============

You can use the following command to merge directory databases:

In the following example we assume that you have different `workdir` (work directories) containing, coverage databases from different runs.

.. note:: The current version of merge command only supports merging databases from the same generator, DuT and reference plugins.

.. code-block:: console

    $ ls -la
    drwxr-xr-x 1 vagrant vagrant 4.0K May 27 11:02 .
    drwxr-xr-x 1 vagrant vagrant 4.0K May 25 10:15 ..
    drwxr-xr-x 1 vagrant vagrant 4.0K May 27 10:47 day1-aapg-hazards
    drwxr-xr-x 1 vagrant vagrant 4.0K May 27 10:53 day2-aapg-illegal
    -rw-r--r-- 1 vagrant vagrant 1.5K May 27 10:57 river_core.ini

.. code-block:: console

   $ river_core merge --help
    Usage: river_core merge [OPTIONS] OUTPUT [DB_FILES]...

    subcommand to merge coverage databases.

    Options:
    -v, --verbosity TEXT  set the verbosity level for the framework
    -c, --config FILE     Read option defaults from the INI file
                            Auto detects
                            river_core.ini in current directory or in the ~
                            directory
    --version             Show the version and exit.
    --help                Show this message and exit.

Taking a look at the one of the generated test-lists.

.. code-block:: yaml

    aapg_rv64imafdc_hazards_s_008709_27052021112313223631_00001:
        asm_file: /Code/Incore/tmp/merge_test/day1-aapg-hazards/aapg/asm/aapg_rv64imafdc_hazards_s_0
        08709_27052021112313223631_00001/aapg_rv64imafdc_hazards_s_008709_27052021112313223631_00001.S
        cc: riscv64-unknown-elf-gcc
        cc_args: ' -mcmodel=medany -static -std=gnu99 -O2 -fno-common -fno-builtin-printf
            -fvisibility=hidden '
        compile_macros: []
        extra_compile:
        - /Code/Incore/tmp/merge_test/day1-aapg-hazards/aapg/common/crt.S
        generator: aapg
        include: []
        isa: rv64imafd
        linker_args: -static -nostdlib -nostartfiles -lm -lgcc -T
        linker_file: /Code/Incore/tmp/merge_test/day1-aapg-hazards/aapg/asm/aapg_rv64imafdc_hazards_s_008709_27052021112313223631_00001/aapg_rv64imafdc_hazards_s_008709_27052021112313223631_00001.ld
        mabi: lp64
        march: rv64imafdc
        result: Unavailable
        work_dir: /Code/Incore/tmp/merge_test/day1-aapg-hazards/aapg/asm/aapg_rv64imafdc_hazards_s_008709_27052021112313223631_00001

.. code-block:: yaml

    aapg_rv64imafdc_illegal_s_000401_27052021131823302233_00001:
        asm_file: /Code/Incore/tmp/merge_test/day2-aapg-illegal/aapg/asm/aapg_rv64imafdc_illegal_s_000401_27052021131823302233_00001/aapg_rv64imafdc_illegal_s_000401_27052021131823302233_00001.S
        cc: riscv64-unknown-elf-gcc
        cc_args: ' -mcmodel=medany -static -std=gnu99 -O2 -fno-common -fno-builtin-printf
            -fvisibility=hidden '
        compile_macros: []
        extra_compile:
        - /Code/Incore/tmp/merge_test/day2-aapg-illegal/aapg/common/crt.S
        generator: aapg
        include: []
        isa: rv64imafd
        linker_args: -static -nostdlib -nostartfiles -lm -lgcc -T
        linker_file: /Code/Incore/tmp/merge_test/day2-aapg-illegal/aapg/asm/aapg_rv64imafdc_illegal_s_000401_27052021131823302233_00001/aapg_rv64imafdc_illegal_s_000401_27052021131823302233_00001.ld
        mabi: lp64
        march: rv64imafdc
        result: Unavailable
        work_dir: /Code/Incore/tmp/merge_test/day2-aapg-illegal/aapg/asm/aapg_rv64imafdc_illegal_s_000401_27052021131823302233_00001

We will now try to merge 2 different workdirs into one.

.. code-block:: console

   $ river_core merge -c river_core.ini week1-merged day1-aapg-hazards/ day2-aapg-illegal/

            info  | ------------RiVer Core Verification Framework------------
            info  | Version: 0.1.0
            info  | Copyright (c) 2021 InCore Semiconductors Pvt. Ltd.
            info  | Loading config from current directory
            info  | ****** Merge Mode ******
            info  | Copied ASM and other necessary files
        command  | No DB files found in /Code/Incore/tmp/merge_test/day1-aapg-hazards
            info  | Copied ASM and other necessary files
        command  | No DB files found in /Code/Incore/tmp/merge_test/day2-aapg-illegal
            info  | Now running on the Target Plugins
            info  | Now loading chromite_verilator-target
            info  | Merged Test list is generated and available at /Code/Incore/tmp/merge_test/week1-merged/test_list.yaml
            info  | The following directories will be removed : ('day1-aapg-hazards/', 'day2-aapg-illegal/')
            info  | Hope you have took everything you want
    Type [Y/N] to continue execution ? N
            info  | Exiting framework.
            info  | Individual folders still exist


The above example created a new folder `week1-merged`, containing a merged `testlist` and the complete `ASM` files.

So, the merge command would also remove the existing directories if the user wishes to remove them.

The merged test-list would now contain an updated test-list yaml. As you can see now the paths to the tests have been updated.

.. code-block:: yaml


    aapg_rv64imafdc_hazards_s_008709_27052021112313223631_00001:
        asm_file: /Code/Incore/tmp/merge_test/week1-merged/asm/aapg_rv64imafdc_hazards_s_008709_27052021112313223631_00001/aapg_rv64imafdc_hazards_s_008709_27052021112313223631_00001.S
        cc: riscv64-unknown-elf-gcc
        cc_args: ' -mcmodel=medany -static -std=gnu99 -O2 -fno-common -fno-builtin-printf
            -fvisibility=hidden '
        extra_compile:
        - /Code/Incore/tmp/merge_test/week1-merged/common/crt.S
        isa: rv64imafd
        linker_args: -static -nostdlib -nostartfiles -lm -lgcc -T
        linker_file: /Code/Incore/tmp/merge_test/week1-merged/asm/aapg_rv64imafdc_hazards_s_008709_27052021112313223631_00001/aapg_rv64imafdc_hazards_s_008709_27052021112313223631_00001.ld
        mabi: lp64
        march: rv64imafdc
        result: Unavailable
        work_dir: /Code/Incore/tmp/merge_test/week1-merged/asm/aapg_rv64imafdc_hazards_s_008709_27052021112313223631_00001


.. code-block:: yaml

    aapg_rv64imafdc_illegal_s_004526_27052021131823302220_00000:
        asm_file: /Code/Incore/tmp/merge_test/week1-merged/asm/aapg_rv64imafdc_illegal_s_004526_27052021131823302220_00000/aapg_rv64imafdc_illegal_s_004526_27052021131823302220_00000.S
        cc: riscv64-unknown-elf-gcc
        cc_args: ' -mcmodel=medany -static -std=gnu99 -O2 -fno-common -fno-builtin-printf
            -fvisibility=hidden '
        extra_compile:
        - /Code/Incore/tmp/merge_test/week1-merged/common/crt.S
        isa: rv64imafd
        linker_args: -static -nostdlib -nostartfiles -lm -lgcc -T
        linker_file: /Code/Incore/tmp/merge_test/week1-merged/asm/aapg_rv64imafdc_illegal_s_004526_27052021131823302220_00000/aapg_rv64imafdc_illegal_s_004526_27052021131823302220_00000.ld
        mabi: lp64
        march: rv64imafdc
        result: Unavailable
        work_dir: /Code/Incore/tmp/merge_test/week1-merged/asm/aapg_rv64imafdc_illegal_s_004526_27052021131823302220_00000

Merge API
=========

.. automodule:: river_core.sim_hookspecs.DuTSpec
.. autofunction:: merge_db
