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
# https://github.com/riscv/riscv-tests/blob/master/isa/rv64ud/fcmp.S
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
# Test f{eq|lt|le}.d instructions.
#
class FcmpTemplate < RiscVBaseTemplate

  def pre_rvtest
    RVTEST_RV64UF()
    RVTEST_CODE_BEGIN()
  end

  def TEST_FP_CMP_OP_D( testnum, inst, flags, result, val1, val2 )
    if __riscv_xlen == 32 then
      # Replace the function with the 32-bit variant defined in riscv_test_macros
      TEST_FP_CMP_OP_D32( testnum, inst, flags, result, val1, val2 )
    else
      super( testnum, inst, flags, result, val1, val2 )
    end
  end

  def run
    #-------------------------------------------------------------
    # Arithmetic tests
    #-------------------------------------------------------------

    TEST_FP_CMP_OP_D( 2, 'feq_d', 0x00, 1, -1.36, -1.36 )
    TEST_FP_CMP_OP_D( 3, 'fle_d', 0x00, 1, -1.36, -1.36 )
    TEST_FP_CMP_OP_D( 4, 'flt_d', 0x00, 0, -1.36, -1.36 )

    TEST_FP_CMP_OP_D( 5, 'feq_d', 0x00, 0, -1.37, -1.36 )
    TEST_FP_CMP_OP_D( 6, 'fle_d', 0x00, 1, -1.37, -1.36 )
    TEST_FP_CMP_OP_D( 7, 'flt_d', 0x00, 1, -1.37, -1.36 )

    # Only sNaN should signal invalid for feq.
    TEST_FP_CMP_OP_D( 8, 'feq_d', 0x00, 0, NAN, 0   )
    TEST_FP_CMP_OP_D( 9, 'feq_d', 0x00, 0, NAN, NAN )
    TEST_FP_CMP_OP_D(10, 'feq_d', 0x10, 0, SNAN, 0  )

    # qNaN should signal invalid for fle/flt.
    TEST_FP_CMP_OP_D(11, 'flt_d', 0x10, 0, NAN, 0   )
    TEST_FP_CMP_OP_D(12, 'flt_d', 0x10, 0, NAN, NAN )
    TEST_FP_CMP_OP_D(13, 'flt_d', 0x10, 0, SNAN, 0  )
    TEST_FP_CMP_OP_D(14, 'fle_d', 0x10, 0, NAN, 0   )
    TEST_FP_CMP_OP_D(15, 'fle_d', 0x10, 0, NAN, NAN )
    TEST_FP_CMP_OP_D(16, 'fle_d', 0x10, 0, SNAN, 0  )
  end

  def post
    TEST_PASSFAIL()
    RVTEST_CODE_END()
  end

end
