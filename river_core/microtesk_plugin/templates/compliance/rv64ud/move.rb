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
# https://github.com/riscv/riscv-tests/blob/master/isa/rv64ud/move.S
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
# This test verifies that fmv.d.x, fmv.x.d, and fsgnj[x|n].d work properly.
#
class MoveTemplate < RiscVBaseTemplate

  def pre_rvtest
    RVTEST_RV64UF()
    RVTEST_CODE_BEGIN()
  end

  def __num_concat(a, b)
    (a.to_s + b.to_s).to_i
  end

  #TODO: make 32-bit compatible version
  def TEST_FSGNJD(n, insn, new_sign, rs1_sign, rs2_sign)
    TEST_CASE(n, a0, 0x123456789abcdef0 | (-(new_sign) << 63)) do
      li a1, ((rs1_sign) << 63) | 0x123456789abcdef0
      li a2, -(rs2_sign)
      fmv_d_x f1, a1
      fmv_d_x f2, a2
      self.send :"#{insn}", f0, f1, f2
      fmv_x_d a0, f0
    end
  end

  # Test fsgnj.s in conjunction with double-precision moves
  def TEST_FSGNJS(n, rd, rs1, rs2)
    TEST_CASE(n, a0, (rd) | (-((rd) >> 31) << 32)) do
      li a1, rs1
      li a2, rs2
      fmv_d_x f1, a1
      fmv_d_x f2, a2
      fsgnj_s f0, f1, f2
      fmv_x_w a0, f0
    end

    TEST_CASE(__num_concat(1, n), a0, (rd) | 0xffffffff00000000) do
      li a1, rs1
      li a2, rs2
      fmv_d_x f1, a1
      fmv_d_x f2, a2
      fsgnj_s f0, f1, f2
      fmv_x_d a0, f0
    end
  end

  # Test fsgnj.d in conjunction with single-precision moves
  def TEST_FSGNJD_SP(n, isnan, rd, rs1, rs2)
    TEST_CASE(n, a0, ((rd) & 0xffffffff) | (-(((rd) >> 31) & 1) << 32)) do
      li a1, rs1
      li a2, rs2
      fmv_d_x f1, a1
      fmv_d_x f2, a2
      fsgnj_d f0, f1, f2
      feq_s a0, f0, f0
      addi a0, a0, ~-isnan
      bnez a0, label_f(1)
      fmv_x_w a0, f0
label 1
    end
    TEST_CASE(__num_concat(1, n), a0, rd) do
      li a1, rs1
      li a2, rs2
      fmv_d_x f1, a1
      fmv_d_x f2, a2
      fsgnj_d f0, f1, f2
      fmv_x_d a0, f0
label 1
    end
  end

  def run
    TEST_FSGNJD(10, 'fsgnj_d', 0, 0, 0)
    TEST_FSGNJD(11, 'fsgnj_d', 1, 0, 1)
    TEST_FSGNJD(12, 'fsgnj_d', 0, 1, 0)
    TEST_FSGNJD(13, 'fsgnj_d', 1, 1, 1)

    TEST_FSGNJD(20, 'fsgnjn_d', 1, 0, 0)
    TEST_FSGNJD(21, 'fsgnjn_d', 0, 0, 1)
    TEST_FSGNJD(22, 'fsgnjn_d', 1, 1, 0)
    TEST_FSGNJD(23, 'fsgnjn_d', 0, 1, 1)

    TEST_FSGNJD(30, 'fsgnjx_d', 0, 0, 0)
    TEST_FSGNJD(31, 'fsgnjx_d', 1, 0, 1)
    TEST_FSGNJD(32, 'fsgnjx_d', 1, 1, 0)
    TEST_FSGNJD(33, 'fsgnjx_d', 0, 1, 1)

    TEST_FSGNJS(40, 0x7fc00000, 0x7ffffffe12345678, 0)
    TEST_FSGNJS(41, 0x7fc00000, 0xfffffffe12345678, 0)
    TEST_FSGNJS(42, 0x7fc00000, 0x7fffffff12345678, 0)
    TEST_FSGNJS(43, 0x12345678, 0xffffffff12345678, 0)

    TEST_FSGNJS(50, 0x7fc00000, 0x7ffffffe12345678, 0x80000000)
    TEST_FSGNJS(51, 0x7fc00000, 0xfffffffe12345678, 0x80000000)
    TEST_FSGNJS(52, 0x7fc00000, 0x7fffffff12345678, 0x80000000)
    TEST_FSGNJS(53, 0x12345678, 0xffffffff12345678, 0x80000000)

    TEST_FSGNJS(60, 0xffc00000, 0x7ffffffe12345678, 0xffffffff80000000)
    TEST_FSGNJS(61, 0xffc00000, 0xfffffffe12345678, 0xffffffff80000000)
    TEST_FSGNJS(62, 0x92345678, 0xffffffff12345678, 0xffffffff80000000)
    TEST_FSGNJS(63, 0x12345678, 0xffffffff12345678, 0x7fffffff80000000)

    TEST_FSGNJD_SP(70, 0, 0xffffffff11111111, 0xffffffff11111111, 0xffffffff11111111)
    TEST_FSGNJD_SP(71, 1, 0x7fffffff11111111, 0xffffffff11111111, 0x7fffffff11111111)
    TEST_FSGNJD_SP(72, 0, 0xffffffff11111111, 0xffffffff11111111, 0xffffffff91111111)
    TEST_FSGNJD_SP(73, 0, 0xffffffff11111111, 0xffffffff11111111, 0x8000000000000000)
    TEST_FSGNJD_SP(74, 0, 0xffffffff11111111, 0x7fffffff11111111, 0xffffffff11111111)
    TEST_FSGNJD_SP(75, 1, 0x7fffffff11111111, 0x7fffffff11111111, 0x7fffffff11111111)
    TEST_FSGNJD_SP(76, 0, 0xffffffff11111111, 0x7fffffff11111111, 0xffffffff91111111)
    TEST_FSGNJD_SP(77, 0, 0xffffffff11111111, 0x7fffffff11111111, 0x8000000000000000)
  end

  def post
    TEST_PASSFAIL()
    RVTEST_CODE_END()
  end

end
