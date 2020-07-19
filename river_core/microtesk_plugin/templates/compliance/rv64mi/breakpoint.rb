# Copyright 2018 ISP RAS (http://www.ispras.ru)
#
# Licensed under the Apache License, Version 2.0 (the "License")
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
# THIS FILE IS BASED ON THE FOLLOWING RISC-V TEST SUITE SOURCE FILE:
# https://github.com/riscv/riscv-tests/blob/master/isa/rv64mi/breakpoint.S
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

require_relative '../../riscv_base'

class BreakpointTemplate < RiscVBaseTemplate

  def pre_rvtest
    RVTEST_RV64U()
    RVTEST_CODE_BEGIN()
  end

  def pre_testdata
    RVTEST_DATA_BEGIN()
    TEST_DATA()

    data {
label :data1
       word 0
label :data2
       word 0
    }

    RVTEST_DATA_END()
  end

  def run
    # Set up breakpoint to trap on M-mode fetches.
    li TESTNUM(), 2

    # Skip tselect if hard-wired.
    csrw tselect, x0 
    csrr a1, tselect
    bne x0, a1, :pass

    # Make sure there's a breakpoint there.
    csrr a0, tdata1
    srli a0, a0, __riscv_xlen - 4
    li a1, 2
    bne a0, a1, :pass

    la a2, label_f(1)
    csrw tdata2, a2
    li a0, MCONTROL_M | MCONTROL_EXECUTE
    csrw tdata1, a0
    # Skip if breakpoint type is unsupported.
    csrr a1, tdata1
    andi a1, a1, 0x7ff
    bne a0, a1, label_f(2)
    align 2
label 1
    # Trap handler should skip this instruction.
    beqz x0, :fail

    # Make sure reads don't trap.
    li TESTNUM(), 3
    lw a0, (a2), 0

label 2
    # Set up breakpoint to trap on M-mode reads.
    li TESTNUM(), 4
    li a0, MCONTROL_M | MCONTROL_LOAD
    csrw tdata1, a0

    # Skip if breakpoint type is unsupported.
    csrr a1, tdata1
    andi a1, a1, 0x7ff
    bne a0, a1, label_f(2)
    la a2, :data1
    csrw tdata2, a2

    # Trap handler should skip this instruction.
    lw a2, (a2), 0
    beqz a2, :fail

    # Make sure writes don't trap.
    li TESTNUM(), 5
    sw x0, (a2), 0

label 2
    # Set up breakpoint to trap on M-mode stores.
    li TESTNUM(), 6
    li a0, MCONTROL_M | MCONTROL_STORE
    csrw tdata1, a0
    # Skip if breakpoint type is unsupported.
    csrr a1, tdata1
    andi a1, a1, 0x7ff
    bne a0, a1, label_f(2)

    # Trap handler should skip this instruction.
    sw a2, (a2), 0

    # Make sure store didn't succeed.
    li TESTNUM(), 7
    lw a2, (a2), 0
    bnez a2, :fail

    # Try to set up a second breakpoint.
    li a0, 1
    csrw tselect, a0
    csrr a1, tselect
    bne a0, a1, :pass

    # Make sure there's a breakpoint there.
    csrr a0, tdata1
    srli a0, a0, __riscv_xlen - 4
    li a1, 2
    bne a0, a1, :pass

    li a0, MCONTROL_M | MCONTROL_LOAD
    csrw tdata1, a0
    la a3, :data2
    csrw tdata2, a3

    # Make sure the second breakpoint triggers.
    li TESTNUM(), 8
    lw a3, (a3), 0
    beqz a3, :fail

    # Make sure the first breakpoint still triggers.
    li TESTNUM(), 10
    la a2, :data1
    sw a2, (a2), 0
    li TESTNUM(), 11
    lw a2, (a2), 0
    bnez a2, :fail

label 2
    TEST_PASSFAIL()

    align 2
    global_label :mtvec_handler

    # Only even-numbered tests should trap.
    andi t0, TESTNUM(), 1
    bnez t0, :fail

    li t0, CAUSE_BREAKPOINT
    csrr t1, mcause
    bne t0, t1, :fail

    csrr t0, mepc
    addi t0, t0, 4
    csrw mepc, t0
    mret

    RVTEST_CODE_END()
  end

  def post
    # Empty
  end

end

