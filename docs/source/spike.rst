.. _spike:

Spike
=====

`Spike [Mod] <https://gitlab.com/shaktiproject/tools/mod-spike>`_ plugin is based on the mod-spike developed by Team Shakti.

`mod-spike` is a modified version of the RISC-V ISA Simulator written by Andrew Waterman and Yunsup Lee.
`mod-spike` has different custom extensions to spike, which is helpful for getting better insight into the RISC-V simulation at the ISA level.

Ensure you have `mod-spike` installed in your path.

Design
------

The plugin creates a Makefile in your `workdir` based on the parameters set in `config.ini`, this is then called by the pytest framework which creates a JSON file containing the file report and runs the makefile in the order.
The framework returns a JSON which is then parsed to create a final HTML report.
Currently it also returns a `dut.dump` which is used to compare the working of the design.

