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
# https://github.com/riscv/riscv-tests/blob/master/isa/rv64ui/fence_i.S
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

class Fence_iTemplate < RiscVBaseTemplate

  def pre_rvtest
    RVTEST_RV64U()
    RVTEST_CODE_BEGIN()
  end

  def pre_testdata
    RVTEST_DATA_BEGIN()
    TEST_DATA()

    data {
label :insn
      # Originally: addi a3, a3, 333
      # TODO: Need to support instructions in data sections.
      word 0x0de68693
    }

    RVTEST_DATA_END()
  end

  def run
    li a3, 111
    lh_global a0, :insn
    lh_global2 a1, :insn, +2

    # test I$ hit
    align 6
    sh_global a0, label_f(1), t0
    sh_global2 a1, label_f(1), +2, t0
    fence_i

label 1
    addi a3, a3, 222
    TEST_CASE( 2, a3, 444 ) do nop end

    # test prefetcher hit
    li a4, 100
label 1
    addi a4, a4, -1
    bnez a4, label_b(1)

    sh_global a0, label_f(1), t0
    sh_global2 a1, label_f(1), +2, t0
    fence_i

    align 6
label 1
    addi a3, a3, 555
    TEST_CASE( 3, a3, 777 ) do nop end

    TEST_PASSFAIL()
    RVTEST_CODE_END()
  end

end
