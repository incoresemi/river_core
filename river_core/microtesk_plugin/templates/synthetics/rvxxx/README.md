Torture-like Test Templates
===========================

### About

This folder contains test templates that demonstrate how to generate random
torture tests. These templates provide facilities that are similar to the ones of
RISC-V Torture Test Generator (https://github.com/ucb-bar/riscv-torture).

The main idea: a test program is composed of small instruction sequences
that are selected at random according to the specified distribution.
Registers used by the instructions and their input values are also selected
at random according to the specified rules.

The torture test covers the following instruction groups:
- ALU instructions: arithmetic, bitwise, multiplication, division (see the `seq_alu.rb` file);
- Compressed ALU instructions: arithmetic, bitwise (see the `seq_alu_rvc.rb` file);
- Branch instructions (see the `seq_branch.rb` file);
- Compressed branch instructions (see the `seq_branch_rvc.rb` file);
- Memory instructions (see the `seq_mem.rb` file);
- Compressed memory instructions (see the `seq_mem_rvc.rb` file);
- Floating-point arithmetic instructions (see the `seq_fpu.rb` file);
- Floating-point division and square root instructions (see the `seq_fdiv.rb` file);
- Floating-point conversion and move instructions (see the `seq_fax.rb` file);
- Floating-point memory instructions (see the `seq_fpmem.rb` file);
- Compressed floating-point memory instructions (see the `seq_fpmem_rvc.rb` file).

The number of randomly selected sequences and their weights are specified
in the `torture.rb` file. Sequence weights are specified in the `next_random_sequence`
method. The number of sequences is specified by the `NSEQS` constant.

Another important parameter is `NMERGE` that specified the number of sequences
to be shuffled (this means that their instructions are randomly interleaved).
An important note is that all `NSEQS` sequences often cannot be shuffled because
of register dependencies. This means that some of their instructions may use
registers that must preserve their values until they are read by some specific
instructions (e.g. `ld`/`sd` read address after `la` saves it in a register).
When the number of shuffled instruction sequences is too large, all registers
may become reserved and it will be impossible to select output registers for
some instructions. For this reason, the number of shuffled sequences is limited.
So, the generation scheme is the following: `NMERGE` are shuffled and concatenated
with the next shuffled `NMERGE` sequences and so on.

### Running Test Generation

To generate test programs for all test templates, run the following command:

```
$ make
```
