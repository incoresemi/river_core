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
# https://github.com/riscv/riscv-tests/blob/master/isa/rv64ud/structural.S
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

#
# This test verifies that the FPU correctly obviates structural hazards on its
# writeback port (e.g. fadd followed by fsgnj)
#
class StructuralTemplate < RiscVBaseTemplate

  def pre_rvtest
    RVTEST_RV64UF()
    RVTEST_CODE_BEGIN()
  end

  def TEST(errcode, &nops)
    fmv_d_x f4, x0
    fmv_w_x f3, x0
    fmv_d_x f2, x2
    fmv_w_x f1, x1
    j label_f(1)
    align 5
label 1
    fmul_d f4, f2, f2
    self.instance_eval &nops
    fsgnj_s f3, f1, f1
    fmv_x_d x4, f4
    fmv_x_w x5, f3
    beq x1, x5, label_f(2)
    RVTEST_FAIL()
label 2
    beq x2, x4, label_f(2)
    RVTEST_FAIL()
label 2
    fmv_d_x f2, zero
    fmv_w_x f1, zero
  end

  def run
    TEST(2)  do end
    TEST(4)  do nop end
    TEST(6)  do nop;nop end
    TEST(8)  do nop;nop;nop end
    TEST(10) do nop;nop;nop;nop end
    TEST(12) do nop;nop;nop;nop;nop end
    TEST(14) do nop;nop;nop;nop;nop;nop end
  end

  def post
    TEST_PASSFAIL()
    RVTEST_CODE_END()
  end

end
