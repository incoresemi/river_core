Chromite
========

.. _Chromite: https://chromite.readthedocs.io/en/latest/

`Chromite`_ plugin is based on the Chromite core generator developed by Incore Semiconductors.

Chromite is an open-source core generator, based on the SHAKTI C Class core developed at PS CDISHA at the Indian Institute of Technology Madras . The core generator emits synthesizable, production quality RTL of processors based on the open RISC-V ISA.

Ensure you have Chromite installed in your path.

Design
=======

The plugin creates a Makefile in your `workdir` based on the parameters set in `config.yaml`, this is then called by the pytest framework which creates a JSON file containing the file report and runs the makefile in the order.
The framework returns a JSON which is then parsed to create a final HTML report.
Currently it also returns a `rtldump` which is used to compare the working of the design.

Config.yaml options
===================
A YAML file is placed in the Chromite plugin folder with the name `config.yaml`.

- **abi** -> The ABI (This goes in as an option for the compiler)

- **arch** -> The Arch for tests

- **gcc** -> The main option to configure parameters for GCC

   - **command** -> The main command for the calling the RISC-V GCC
    Usually `riscv64-unknown-elf-gcc`
   - **args** -> The set of arguments to pass for GCC
    Usually  `-static -mcmodel=medany -fvisibility=hidden -nostdlib -nostartfiles -std=gnu99 -O2 -DPREALLOCATE=1`
   - **include** -> Directory to include common linker scripts etc.
   - **asm_dir** -> Directory where the ASM is stored in the work directory.

- **linker** -> The option to configure parameters for Linker

   -  **ld** -> The main command for Linker
      Usually `ld`
   -  **args** -> The set of arguments for Linker
      Usually `-static -nostdlib -nostartfiles -lm -lgcc -T`
   - **crt** -> Path to CRT assmebly file

- **objdump** -> The option to configure parameters for objdump

   -  **command** -> The place to configure the command for objdump
      Usually `riscv64-unknown-elf-objdump`
   - **args** -> Args to pass to the command

- **elf2hex** -> The option to configure parameters for elf2hex

   - **command** -> The command to run elf2hex
   Usually `elf2hex` (if installed on Path)

   - **args** -> Args to pass <width> <depth> <base>
   For a standard simple file of 64-bit `[8, 4194304, 2147483648]`

   - **out_file** -> Output file Fixed as  `code.mem`

- **sim** -> Options to configure simulator being used in the plugin

   -  **command** -> The command to run
      Usually `chromite_core`
   -  **args** -> Parameters to pass the simulation binary.
      Usually `-c -l`
   -  **path** -> Path to the chromite binary
