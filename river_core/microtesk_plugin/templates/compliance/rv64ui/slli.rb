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
# https://github.com/riscv/riscv-tests/blob/master/isa/rv64ui/slli.S
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

class SlliTemplate < RiscVBaseTemplate

  def pre_rvtest
    RVTEST_RV64U()
    RVTEST_CODE_BEGIN()
  end

  def run
    #-------------------------------------------------------------
    # Arithmetic tests
    #-------------------------------------------------------------
  
    TEST_IMM_OP( 2,  'slli', 0x0000000000000001, 0x0000000000000001, 0  )
    TEST_IMM_OP( 3,  'slli', 0x0000000000000002, 0x0000000000000001, 1  )
    TEST_IMM_OP( 4,  'slli', 0x0000000000000080, 0x0000000000000001, 7  )
    TEST_IMM_OP( 5,  'slli', 0x0000000000004000, 0x0000000000000001, 14 )
    TEST_IMM_OP( 6,  'slli', 0x0000000080000000, 0x0000000000000001, 31 )
  
    TEST_IMM_OP( 7,  'slli', 0xffffffffffffffff, 0xffffffffffffffff, 0  )
    TEST_IMM_OP( 8,  'slli', 0xfffffffffffffffe, 0xffffffffffffffff, 1  )
    TEST_IMM_OP( 9,  'slli', 0xffffffffffffff80, 0xffffffffffffffff, 7  )
    TEST_IMM_OP( 10, 'slli', 0xffffffffffffc000, 0xffffffffffffffff, 14 )
    TEST_IMM_OP( 11, 'slli', 0xffffffff80000000, 0xffffffffffffffff, 31 )
  
    TEST_IMM_OP( 12, 'slli', 0x0000000021212121, 0x0000000021212121, 0  )
    TEST_IMM_OP( 13, 'slli', 0x0000000042424242, 0x0000000021212121, 1  )
    TEST_IMM_OP( 14, 'slli', 0x0000001090909080, 0x0000000021212121, 7  )
    TEST_IMM_OP( 15, 'slli', 0x0000084848484000, 0x0000000021212121, 14 )
    TEST_IMM_OP( 16, 'slli', 0x1090909080000000, 0x0000000021212121, 31 )

  if __riscv_xlen == 64
    TEST_IMM_OP( 50, 'slli', 0x8000000000000000, 0x0000000000000001, 63 )
    TEST_IMM_OP( 51, 'slli', 0xffffff8000000000, 0xffffffffffffffff, 39 )
    TEST_IMM_OP( 52, 'slli', 0x0909080000000000, 0x0000000021212121, 43 )
  end

    #-------------------------------------------------------------
    # Source/Destination tests
    #-------------------------------------------------------------
  
    TEST_IMM_SRC1_EQ_DEST( 17, 'slli', 0x00000080, 0x00000001, 7 )
  
    #-------------------------------------------------------------
    # Bypassing tests
    #-------------------------------------------------------------
  
    TEST_IMM_DEST_BYPASS( 18, 0, 'slli', 0x0000000000000080, 0x0000000000000001, 7  )
    TEST_IMM_DEST_BYPASS( 19, 1, 'slli', 0x0000000000004000, 0x0000000000000001, 14 )
    TEST_IMM_DEST_BYPASS( 20, 2, 'slli', 0x0000000080000000, 0x0000000000000001, 31 )
  
    TEST_IMM_SRC1_BYPASS( 21, 0, 'slli', 0x0000000000000080, 0x0000000000000001, 7  )
    TEST_IMM_SRC1_BYPASS( 22, 1, 'slli', 0x0000000000004000, 0x0000000000000001, 14 )
    TEST_IMM_SRC1_BYPASS( 23, 2, 'slli', 0x0000000080000000, 0x0000000000000001, 31 )
  
    TEST_IMM_ZEROSRC1( 24, 'slli', 0, 31 )
    TEST_IMM_ZERODEST( 25, 'slli', 33, 20 )
  end

  def post
    TEST_PASSFAIL()
    RVTEST_CODE_END()
  end

end
