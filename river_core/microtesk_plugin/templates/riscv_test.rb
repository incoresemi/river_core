#
# Copyright 2018 ISP RAS (http://www.ispras.ru)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# THIS FILE IS BASED ON THE FOLLOWING RISC-V TEST SUITE HEADER:
# https://github.com/riscv/riscv-test-env/blob/master/p/riscv_test.h
# WHICH IS DISTRIBUTED UNDER THE FOLLOWING LICENSE:
#
# Copyright (c) 2012-2015, The Regents of the University of California (Regents).
# All Rights Reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
# 3. Neither the name of the Regents nor the
#    names of its contributors may be used to endorse or promote products
#    derived from this software without specific prior written permission.
#
# IN NO EVENT SHALL REGENTS BE LIABLE TO ANY PARTY FOR DIRECT, INDIRECT,
# SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES, INCLUDING LOST PROFITS, ARISING
# OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF REGENTS HAS
# BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# REGENTS SPECIFICALLY DISCLAIMS ANY WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
# THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE. THE SOFTWARE AND ACCOMPANYING DOCUMENTATION, IF ANY, PROVIDED
# HEREUNDER IS PROVIDED "AS IS". REGENTS HAS NO OBLIGATION TO PROVIDE
# MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
#

require_relative 'riscv_encoding'

module RiscvTest
  include RiscvEncoding

  ##################################################################################################
  # Begin Macro
  ##################################################################################################

  # Assembler macro 'init' is replaced with dynamic method
  # 'RVTEST_INIT' that performs code inlining.
  #
  # def RVTEST_INIT
  #  text "init"
  # end

  def RVTEST_RV64U
    # text '.macro init'
    # text '.endm'

    proc = Proc.new {}
    RiscvTest.send(:define_method, :"RVTEST_INIT", proc)
  end

  def RVTEST_RV64UF
    # text '.macro init'
    # RVTEST_FP_ENABLE()
    # text '.endm'

    proc = Proc.new { RVTEST_FP_ENABLE() }
    RiscvTest.send(:define_method, :"RVTEST_INIT", proc)
  end

  def RVTEST_RV64UFN
    # text '.macro init'
    # RVTEST_ENABLE_USER_TRAP()
    # text '.endm'

    proc = Proc.new { RVTEST_ENABLE_USER_TRAP() }
    RiscvTest.send(:define_method, :"RVTEST_INIT", proc)
  end

  def RVTEST_RV32U
    # text '.macro init'
    # text '.endm'

    proc = Proc.new {}
    RiscvTest.send(:define_method, :"RVTEST_INIT", proc)
  end

  def RVTEST_RV32UF
    # text '.macro init'
    # RVTEST_FP_ENABLE()
    # text '.endm'

    proc = Proc.new { RVTEST_FP_ENABLE() }
    RiscvTest.send(:define_method, :"RVTEST_INIT", proc)
   end

  def RVTEST_RV64M
    # text '.macro init'
    # RVTEST_ENABLE_MACHINE()
    # text '.endm'

    proc = Proc.new { RVTEST_ENABLE_MACHINE() }
    RiscvTest.send(:define_method, :"RVTEST_INIT", proc)
  end

  def RVTEST_RV64S
    # text '.macro init'
    # RVTEST_ENABLE_SUPERVISOR()
    # text '.endm'

    proc = Proc.new { RVTEST_ENABLE_SUPERVISOR() }
    RiscvTest.send(:define_method, :"RVTEST_INIT", proc)
  end

  def RVTEST_RV32M
    # text '.macro init'
    # RVTEST_ENABLE_MACHINE()
    # text '.endm'

    proc = Proc.new { RVTEST_ENABLE_MACHINE() }
    RiscvTest.send(:define_method, :"RVTEST_INIT", proc)
  end

  def RVTEST_RV32S
    # text '.macro init'
    # RVTEST_ENABLE_SUPERVISOR()
    # text '.endm'

    proc = Proc.new { RVTEST_ENABLE_SUPERVISOR() }
    RiscvTest.send(:define_method, :"RVTEST_INIT", proc)
  end

  def CHECK_XLEN
    li a0, 1
    slli a0, a0, 31
    if is_rev('RV64I') then bgez a0, label_f(1)
                       else bltz a0, label_f(1) end
    RVTEST_PASS()
label 1
  end

  def INIT_PMP
    la t0, label_f(1)
    csrw mtvec, t0
    # Set up a PMP to permit all accesses
    li t0, -1
    csrw pmpaddr0, t0
    li t0, PMP_NAPOT | PMP_R | PMP_W | PMP_X
    csrw pmpcfg0, t0
    align 2
label 1
  end

  def INIT_SATP
    la t0, label_f(1)
    csrw mtvec, t0
#    csrwi satp, 0
    align 2
label 1
  end

  def DELEGATE_NO_TRAPS
    la t0, label_f(1)
    csrw mtvec, t0
    csrwi medeleg, 0
    csrwi mideleg, 0
    csrwi mie, 0
    align 2
label 1
  end

  def RVTEST_ENABLE_USER_TRAP
    newline
    comment 'RVTEST_ENABLE_USER_TRAP'

    li a0, 0x1 << 20
    csrs misa, a0
    li a0, 0x1 << 13
    csrs misa, a0
   
    newline
    comment 'RVTEST_FP_ENABLE'

    li a0, MSTATUS_FS & (MSTATUS_FS >> 1)
    csrs mstatus, a0
    csrwi fcsr, 0

    newline

    newline
  end


  def RVTEST_ENABLE_SUPERVISOR
    newline
    comment 'RVTEST_ENABLE_SUPERVISOR'

    li a0, MSTATUS_MPP & (MSTATUS_MPP >> 1)
    csrs mstatus, a0
    li a0, SIP_SSIP | SIP_STIP
    csrs mideleg, a0

    newline
  end

  def RVTEST_ENABLE_MACHINE
    newline
    comment 'RVTEST_ENABLE_MACHINE'

    li a0, MSTATUS_MPP
    csrs mstatus, a0

    newline
  end

  def RVTEST_FP_ENABLE
    newline
    comment 'RVTEST_FP_ENABLE'

    li a0, MSTATUS_FS & (MSTATUS_FS >> 1)
    csrs mstatus, a0
    csrwi fcsr, 0

    newline
  end

  def RISCV_MULTICORE_DISABLE
    csrr a0, mhartid
label 1
    bnez a0, label_b(1)
  end

  #define EXTRA_TVEC_USER
  #define EXTRA_TVEC_MACHINE

  def EXTRA_INIT
  end

  def EXTRA_INIT_TIMER
  end

  def INTERRUPT_HANDLER
    # No interrupts should occur
    j :other_exception
  end

def RVTEST_ENABLE_MF

    newline
    comment 'RVTEST_MF'

    li a0, MSTATUS_FS & (MSTATUS_FS >> 1)
    csrs mstatus, a0
    csrwi fcsr, 0

    newline

    newline
    comment 'RVTEST_ENABLE_MACHINE'

    li a0, MSTATUS_MPP
    csrs mstatus, a0

    newline

 end

  def RVTEST_ENABLE_UF

    newline
    comment 'RVTEST_F'

    li a0, MSTATUS_FS & (MSTATUS_FS >> 1)
    csrs mstatus, a0
    csrwi fcsr, 0

    newline

  end


  def RVTEST_RV64MF
    # text '.macro init'
    # RVTEST_ENABLE_MF()
    # text '.endm'

    proc = Proc.new { RVTEST_ENABLE_MF() }
    RiscvTest.send(:define_method, :"RVTEST_INIT", proc)
  end

  def RVTEST_RV64UF
    # text '.macro init'
    # RVTEST_ENABLE_MF()
    # text '.endm'

    proc = Proc.new { RVTEST_ENABLE_UF() }
    RiscvTest.send(:define_method, :"RVTEST_INIT", proc)
  end

  def RVTEST_CODE_BEGIN
    align  6
    weak :stvec_handler
    weak :mtvec_handler

global_label :_start
    # reset vector
    j :reset_vector

    align 2
label :trap_vector
    # test whether the test came from pass/fail
    csrr t5, mcause

    li t6, CAUSE_USER_ECALL
    beq t5, t6, :write_tohost

    li t6, CAUSE_SUPERVISOR_ECALL
    beq t5, t6, :write_tohost

    li t6, CAUSE_MACHINE_ECALL
    beq t5, t6, :write_tohost

    # if an mtvec_handler is defined, jump to it
    la t5, :mtvec_handler
    beqz t5, label_f(1)
    jr t5

    # was it an interrupt or an exception?
label 1
    csrr t5, mcause
    bgez t5, :handle_exception

    INTERRUPT_HANDLER()
label :handle_exception
    # we don't know how to handle whatever the exception was
label :other_exception
    # some unhandlable exception occurred

label 1
    ori TESTNUM(), TESTNUM(), 1337

label :write_tohost
# TODO: Temporary commented out because it causes the "HTIF tohost must be 8 bytes" error in QEMU.
#    sw_global TESTNUM(), :tohost, t5
# TODO: remove the nops when the above line is fixed.
    nop
    text "sw gp, tohost, t5" # TODO: Fix me!!11
    nop
#    j :write_tohost
label :shakti_end
    fence_i
    li t6, 0x20000
    la t5, :begin_signature
    sw t5, t6, 0
    la t5, :end_signature
    sw t5, t6, 8
    sw t5, t6, 12

label :reset_vector

    RISCV_MULTICORE_DISABLE()
    INIT_SATP()
#    INIT_PMP()
    DELEGATE_NO_TRAPS()

    li TESTNUM(), 0
    la t0, :trap_vector
    csrw mtvec, t0
    CHECK_XLEN()

    # if an stvec_handler is defined, delegate exceptions to it
    la t0, :stvec_handler
    beqz t0, label_f(1)
    csrw stvec, t0

    li t0, (1 << CAUSE_LOAD_PAGE_FAULT)  |
           (1 << CAUSE_STORE_PAGE_FAULT) |
           (1 << CAUSE_FETCH_PAGE_FAULT) |
           (1 << CAUSE_MISALIGNED_FETCH) |
           (1 << CAUSE_USER_ECALL)       |
           (1 << CAUSE_BREAKPOINT)
    csrw medeleg, t0
    csrr t1, medeleg
    bne t0, t1, :other_exception

label 1
    csrwi mstatus, 0
    RVTEST_INIT()

    EXTRA_INIT()
    EXTRA_INIT_TIMER()

    la t0, label_f(1)
    csrw mepc, t0
    csrr a0, mhartid
    mret
label 1
  end

  ##################################################################################################
  # End Macro
  ##################################################################################################

  def RVTEST_CODE_END
    pseudo 'unimp'
  end

  ##################################################################################################
  # Pass/Fail Macro
  ##################################################################################################

  def RVTEST_PASS
    fence
    li TESTNUM(), 1
    ecall
  end

  def TESTNUM
    gp
  end

  def RVTEST_FAIL
    trace 'Error: Test failed (self check did not pass)!'
    fence
label 1
    beqz TESTNUM(), label_b(1)
    sll TESTNUM(), TESTNUM(), 1
    Or TESTNUM(), TESTNUM(), 1
    ecall
  end

  ##################################################################################################
  # Data Section Macro
  ##################################################################################################

  def EXTRA_DATA
  end

  def RVTEST_DATA_BEGIN
    EXTRA_DATA()

# TODO: Temporary commented out because it causes the "HTIF tohost must be 8 bytes" error in QEMU.
#     # .pushsection .tohost,"aw",@progbits
#     section(:name => '.tohost') {
#       data {
#         align 6
# global_label :tohost
#         dword 0
#
#         align 6
# global_label :fromhost
#         dword 0
#       }
#     }
#     # .popsection


    data {
      text '.align 4'
      # TODO: Fix me!
      text '.pushsection .tohost,"aw",@progbits'
      text '.align 8; .global tohost; tohost: .dword 0;'
      text '.align 8; .global fromhost; fromhost: .dword 0;'
      text '.popsection;'
      # TODO: end Fix me!

      align 4
      global_label :begin_signature
    }
  end

  def RVTEST_DATA_END
    data {
      align 4
      global_label :end_signature

      # TODO: Fix me!
      text '.align 8; .global begin_regstate; begin_regstate:'
      text '.word 128;'
      text '.align 8; .global end_regstate; end_regstate:'
      text '.word 4;'
      # TODO: end Fix me!
    }
  end

end
