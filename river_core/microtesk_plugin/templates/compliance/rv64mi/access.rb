#
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
# https://github.com/riscv/riscv-tests/blob/master/isa/rv64mi/access.S
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

class AccessTemplate < RiscVBaseTemplate

  def pre_rvtest
    RVTEST_RV64M()
    RVTEST_CODE_BEGIN()
  end

  def run
    align 2

    # Flipping just the MSB should result in an illegal address for RV64.

    la t2, :fail
    li t0, (__riscv_xlen - 1) >> 1
    xor t0, t0, t2

    # jalr to an illegal address should commit (hence should write rd).
    # after the pc is set to rs1, an access exception should be raised.

    li TESTNUM(), 2
    li t1, CAUSE_FETCH_ACCESS
    la t3, label_f(1)
    li t2, 0
    jalr t2, t0, 0  # Had two arguments in original test.
label 1

    # A load to an illegal address should not commit.
    li TESTNUM(), 3
    li t1, CAUSE_LOAD_ACCESS
    la t3, label_f(1)
    mv t2, t3
    lb t2, (t0), 0 # Had two arguments in original test.
    j :fail
label 1

    j :pass

    TEST_PASSFAIL()

    align 2
    global_label :mtvec_handler
    li a0, 2
    beq TESTNUM(), a0, label_f(2)
    li a0, 3
    beq TESTNUM(), a0, label_f(2)
    j :fail

label 2
    bne t2, t3, :fail

    csrr t2, mcause
    bne t2, t1, :fail

    csrw mepc, t3
    mret

    RVTEST_CODE_END()
  end

  def post
    # Empty
  end

end

