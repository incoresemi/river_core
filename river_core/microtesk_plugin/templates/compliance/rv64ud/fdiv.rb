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
# https://github.com/riscv/riscv-tests/blob/master/isa/rv64ud/fdiv.S
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
# Test f{div|sqrt}.d instructions.
#
class FdivTemplate < RiscVBaseTemplate

  def pre_rvtest
    RVTEST_RV64UF()
    RVTEST_CODE_BEGIN()
  end

  def TEST_FP_OP2_D( testnum, inst, flags, result, val1, val2 )
    if __riscv_xlen == 32 then
      # Replace the functions with the 32-bit variants defined in riscv_test_macros.
      TEST_FP_OP2_D32( testnum, inst, flags, result, val1, val2 )
    else
      super( testnum, inst, flags, result, val1, val2 )
    end
  end

  def TEST_FP_OP1_D( testnum, inst, flags, result, val1 )
    if __riscv_xlen == 32 then
      # Replace the functions with the 32-bit variants defined in riscv_test_macros.
      TEST_FP_OP1_D32( testnum, inst, flags, result, val1 )
    else
      super( testnum, inst, flags, result, val1 )
    end
  end

  def TEST_FP_OP1_D_DWORD_RESULT( testnum, inst, flags, result, val1 )
    if __riscv_xlen == 32 then
      # Replace the functions with the 32-bit variants defined in riscv_test_macros.
      TEST_FP_OP1_D32_DWORD_RESULT( testnum, inst, flags, result, val1 )
    else
      super( testnum, inst, flags, result, val1 )
    end
  end

  def run
    #-------------------------------------------------------------
    # Arithmetic tests
    #-------------------------------------------------------------

    TEST_FP_OP2_D( 2,  'fdiv_d',  1,  1.1557273520668288,  3.14159265, 2.71828182 )
    TEST_FP_OP2_D( 3,  'fdiv_d',  1, -0.9991093838555584,     -1234.0,     1235.1 )
    TEST_FP_OP2_D( 4,  'fdiv_d',  0,          3.14159265,  3.14159265,        1.0 )

    TEST_FP_OP1_D( 5,  'fsqrt_d', 1, 1.7724538498928541, 3.14159265 )
    TEST_FP_OP1_D( 6,  'fsqrt_d', 0,                100,      10000 )

    TEST_FP_OP1_D_DWORD_RESULT(16, 'fsqrt_d', 0x10, 0x7FF8000000000000, -1.0 )

    TEST_FP_OP1_D( 7, 'fsqrt_d', 1,  13.076696830622021,                 171.0 )
    TEST_FP_OP1_D( 8, 'fsqrt_d', 1,  0.00040099251863345283320230749702, 1.60795e-7 )
  end

  def post
    TEST_PASSFAIL()
    RVTEST_CODE_END()
  end

end
