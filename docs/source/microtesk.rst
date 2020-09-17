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
=======================

It has a configurable model, generator code, some standard example templates. 