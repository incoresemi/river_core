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
# https://github.com/riscv/riscv-tests/blob/master/isa/rv64uf/move.S
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
# This test verifies that the fmv.s.x, fmv.x.s, and fsgnj[x|n].d instructions
# and the fcsr work properly.
#
class MoveTemplate < RiscVBaseTemplate

  def pre_rvtest
    RVTEST_RV64UF()
    RVTEST_CODE_BEGIN()
  end

  def TEST_FSGNJS(n, insn, new_sign, rs1_sign, rs2_sign)
    TEST_CASE(n, a0, 0x12345678 | (-(new_sign) << 31)) do
      li a1, ((rs1_sign) << 31) | 0x12345678
      li a2, -(rs2_sign)
      fmv_w_x f1, a1
      fmv_w_x f2, a2
      self.send :"#{insn}", f0, f1, f2
      fmv_x_w a0, f0
    end
  end

  def run
    TEST_CASE(2, a1, 1) do
      csrwi fcsr, 1
      li a0, 0x1234
      fscsr a1, a0 # Originally fssr
    end

    TEST_CASE(3, a0, 0x34) do
      frcsr a0 # Originally frsr
    end

    TEST_CASE(4, a0, 0x14) do
      frflags a0
    end

    TEST_CASE(5, a0, 0x01) do
      csrrwi a0, frm, 2
    end

    TEST_CASE(6, a0, 0x54) do
      frcsr a0 # Originally frsr
    end

    TEST_CASE(7, a0, 0x14) do
      csrrci a0, fflags, 4
    end

    TEST_CASE(8, a0, 0x50) do
      frcsr a0 # Originally frsr
    end

    TEST_FSGNJS(10, 'fsgnj_s', 0, 0, 0)
    TEST_FSGNJS(11, 'fsgnj_s', 1, 0, 1)
    TEST_FSGNJS(12, 'fsgnj_s', 0, 1, 0)
    TEST_FSGNJS(13, 'fsgnj_s', 1, 1, 1)

    TEST_FSGNJS(20, 'fsgnjn_s', 1, 0, 0)
    TEST_FSGNJS(21, 'fsgnjn_s', 0, 0, 1)
    TEST_FSGNJS(22, 'fsgnjn_s', 1, 1, 0)
    TEST_FSGNJS(23, 'fsgnjn_s', 0, 1, 1)

    TEST_FSGNJS(30, 'fsgnjx_s', 0, 0, 0)
    TEST_FSGNJS(31, 'fsgnjx_s', 1, 0, 1)
    TEST_FSGNJS(32, 'fsgnjx_s', 1, 1, 0)
    TEST_FSGNJS(33, 'fsgnjx_s', 0, 1, 1)
  end

  def post
    TEST_PASSFAIL()
    RVTEST_CODE_END()
  end

end
