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
# https://github.com/riscv/riscv-tests/blob/master/isa/rv64ud/fadd.S
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
# Test f{add|sub|mul}.d instructions.
#
class FaddTemplate < RiscVBaseTemplate

  def pre_rvtest
    RVTEST_RV64UF()
    RVTEST_CODE_BEGIN()
  end

  def TEST_FP_OP2_D( testnum, inst, flags, result, val1, val2 )
    if __riscv_xlen == 32 then
      # Replace the function with the 32-bit variant defined in riscv_test_macros.
      TEST_FP_OP2_D32( testnum, inst, flags, result, val1, val2 )
    else
      super( testnum, inst, flags, result, val1, val2 )
    end
  end

  def run
    #-------------------------------------------------------------
    # Arithmetic tests
    #-------------------------------------------------------------

    TEST_FP_OP2_D( 2,  'fadd_d', 0,                3.5,        2.5,        1.0 )
    TEST_FP_OP2_D( 3,  'fadd_d', 1,            -1234.0,    -1235.1,        1.1 )
    TEST_FP_OP2_D( 4,  'fadd_d', 1,         3.14159266, 3.14159265, 0.00000001 )

    TEST_FP_OP2_D( 5,  'fsub_d', 0,                1.5,        2.5,        1.0 )
    TEST_FP_OP2_D( 6,  'fsub_d', 1,            -1234.0,    -1235.1,       -1.1 )
    TEST_FP_OP2_D( 7,  'fsub_d', 1, 3.1415926400000001, 3.14159265, 0.00000001 )

    TEST_FP_OP2_D( 8,  'fmul_d', 0,                2.5,        2.5,        1.0 )
    TEST_FP_OP2_D( 9,  'fmul_d', 1,            1358.61,    -1235.1,       -1.1 )
    TEST_FP_OP2_D(10,  'fmul_d', 1,      3.14159265e-8, 3.14159265, 0.00000001 )

    # Is the canonical NaN generated for Inf - Inf?
    TEST_FP_OP2_D(11, 'fsub_d', 0x10, QNAN, INF, INF )
  end

  def post
    TEST_PASSFAIL()
    RVTEST_CODE_END()
  end

end
