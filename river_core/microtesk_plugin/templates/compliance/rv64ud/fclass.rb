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
# https://github.com/riscv/riscv-tests/blob/master/isa/rv64ud/fclass.S
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
# Test fclass.d instruction.
#
class FclassTemplate < RiscVBaseTemplate

  def pre_rvtest
    RVTEST_RV64UF()
    RVTEST_CODE_BEGIN()
  end

  def TEST_FCLASS_D( testnum, correct, input )
    if __riscv_xlen == 32 then
      # Replace the function with the 32-bit variant defined in riscv_test_macros.
      TEST_FCLASS_D32( testnum, correct, input )
    else
      super( testnum, correct, input )
    end
  end

  def run
    #-------------------------------------------------------------
    # Arithmetic tests
    #-------------------------------------------------------------

    TEST_FCLASS_D( 2, 1 << 0, 0xfff0000000000000 )
    TEST_FCLASS_D( 3, 1 << 1, 0xbff0000000000000 )
    TEST_FCLASS_D( 4, 1 << 2, 0x800fffffffffffff )
    TEST_FCLASS_D( 5, 1 << 3, 0x8000000000000000 )
    TEST_FCLASS_D( 6, 1 << 4, 0x0000000000000000 )
    TEST_FCLASS_D( 7, 1 << 5, 0x000fffffffffffff )
    TEST_FCLASS_D( 8, 1 << 6, 0x3ff0000000000000 )
    TEST_FCLASS_D( 9, 1 << 7, 0x7ff0000000000000 )
    TEST_FCLASS_D(10, 1 << 8, 0x7ff0000000000001 )
    TEST_FCLASS_D(11, 1 << 9, 0x7ff8000000000000 )
  end

  def post
    TEST_PASSFAIL()
    RVTEST_CODE_END()
  end

end
