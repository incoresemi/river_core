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
# https://github.com/riscv/riscv-tests/blob/master/isa/rv64ud/fcvt.S
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
# Test fcvt.d.{wu|w|lu|l}, fcvt.s.d, and fcvt.d.s instructions.
#
class FcvtTemplate < RiscVBaseTemplate

  def pre_rvtest
    RVTEST_RV64UF()
    RVTEST_CODE_BEGIN()
  end

  def pre_testdata
    RVTEST_DATA_BEGIN()
    TEST_DATA()

    data {
label :test_data_22
      dword 0x7ffcffffffff8004
    }

    RVTEST_DATA_END()
  end

  def TEST_INT_FP_OP_D( testnum, inst, result, val1 )
    if __riscv_xlen == 32 then
      # Replace the function with the 32-bit variant defined in riscv_test_macros.
      TEST_INT_FP_OP_D32( testnum, inst, result, val1 )
    else
      super( testnum, inst, result, val1 )
    end
  end

  def TEST_FCVT_S_D( testnum, result, val1 )
    if __riscv_xlen == 32 then
      # Replace the function with the 32-bit variant defined in riscv_test_macros.
      TEST_FCVT_S_D32( testnum, result, val1 )
    else
      super( testnum, result, val1 )
    end
  end

  def run
    #-------------------------------------------------------------
    # Arithmetic tests
    #-------------------------------------------------------------

    TEST_INT_FP_OP_D(2,   'fcvt_d_w',                    2.0,  2)
    TEST_INT_FP_OP_D(3,   'fcvt_d_w',                   -2.0, -2)

    TEST_INT_FP_OP_D(4,  'fcvt_d_wu',                    2.0,  2)
    TEST_INT_FP_OP_D(5,  'fcvt_d_wu',           4294967294.0, -2)

    if __riscv_xlen >= 64 then
      TEST_INT_FP_OP_D(6, 'fcvt_d_l',                    2.0,  2)
      TEST_INT_FP_OP_D(7, 'fcvt_d_l',                   -2.0, -2)

      TEST_INT_FP_OP_D(8, 'fcvt_d_lu',                   2.0,  2)
      TEST_INT_FP_OP_D(9, 'fcvt_d_lu', 1.8446744073709552e19, -2)
    end

    TEST_FCVT_S_D(10, -1.5, -1.5)
    TEST_FCVT_D_S(11, -1.5, -1.5)

    if __riscv_xlen >= 64 then
      TEST_CASE(12, a0, 0x7ff8000000000000) do
        la a1, :test_data_22
        ld a2, a1, 0
        fmv_d_x f2, a2
        fcvt_s_d f2, f2
        fcvt_d_s f2, f2
        fmv_x_d a0, f2
      end
    else
      TEST_CASE_D32(12, a0, a1, 0x7ff8000000000000) do
        la a1, :test_data_22
        fld f2, a1, 0
        fcvt_s_d f2, f2
        fcvt_d_s f2, f2
        fsd f2, a1, 0
        lw a0, a1, 0
        lw a1, a1, 4
      end
    end
  end

  def post
    TEST_PASSFAIL()
    RVTEST_CODE_END()
  end

end
