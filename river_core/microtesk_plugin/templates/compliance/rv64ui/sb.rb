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
# https://github.com/riscv/riscv-tests/blob/master/isa/rv64ui/sb.S
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

class SbTemplate < RiscVBaseTemplate

  def pre_rvtest
    RVTEST_RV64U()
    RVTEST_CODE_BEGIN()
  end

  def pre_testdata
    RVTEST_DATA_BEGIN()
    TEST_DATA()

    data {
label :tdat
label :tdat1
      byte 0xef
label :tdat2
      byte 0xef
label :tdat3
      byte 0xef
label :tdat4
      byte 0xef
label :tdat5
      byte 0xef
label :tdat6
      byte 0xef
label :tdat7
      byte 0xef
label :tdat8
      byte 0xef
label :tdat9
      byte 0xef
label :tdat10
      byte 0xef
    }

    RVTEST_DATA_END()
  end

  def run
    #-------------------------------------------------------------
    # Basic tests
    #-------------------------------------------------------------    

    TEST_ST_OP( 2, 'lb', 'sb', 0xffffffffffffffaa, 0, :tdat )
    TEST_ST_OP( 3, 'lb', 'sb', 0x0000000000000000, 1, :tdat )
    TEST_ST_OP( 4, 'lh', 'sb', 0xffffffffffffefa0, 2, :tdat )
    TEST_ST_OP( 5, 'lb', 'sb', 0x000000000000000a, 3, :tdat )

    # Test with negative offset

    TEST_ST_OP( 6, 'lb', 'sb', 0xffffffffffffffaa, -3, :tdat8 )
    TEST_ST_OP( 7, 'lb', 'sb', 0x0000000000000000, -2, :tdat8 )
    TEST_ST_OP( 8, 'lb', 'sb', 0xffffffffffffffa0, -1, :tdat8 )
    TEST_ST_OP( 9, 'lb', 'sb', 0x000000000000000a, 0,  :tdat8 )

    # Test with a negative base

    TEST_CASE( 10, x5, 0x78 ) do 
      la  x1, :tdat9 
      li  x2, 0x12345678 
      addi x4, x1, -32 
      sb x2, x4, 32 
      lb x5, x1, 0 
    end

    # Test with unaligned base

    TEST_CASE( 11, x5, 0xffffffffffffff98 ) do 
      la  x1, :tdat9 
      li  x2, 0x00003098 
      addi x1, x1, -6 
      sb x2, x1, 7 
      la  x4, :tdat10 
      lb x5, x4, 0 
    end

    #-------------------------------------------------------------
    # Bypassing tests
    #-------------------------------------------------------------

    TEST_ST_SRC12_BYPASS( 12, 0, 0, 'lb', 'sb', 0xffffffffffffffdd, 0, :tdat )
    TEST_ST_SRC12_BYPASS( 13, 0, 1, 'lb', 'sb', 0xffffffffffffffcd, 1, :tdat )
    TEST_ST_SRC12_BYPASS( 14, 0, 2, 'lb', 'sb', 0xffffffffffffffcc, 2, :tdat )
    TEST_ST_SRC12_BYPASS( 15, 1, 0, 'lb', 'sb', 0xffffffffffffffbc, 3, :tdat )
    TEST_ST_SRC12_BYPASS( 16, 1, 1, 'lb', 'sb', 0xffffffffffffffbb, 4, :tdat )
    TEST_ST_SRC12_BYPASS( 17, 2, 0, 'lb', 'sb', 0xffffffffffffffab, 5, :tdat )

    TEST_ST_SRC21_BYPASS( 18, 0, 0, 'lb', 'sb', 0x33, 0, :tdat )
    TEST_ST_SRC21_BYPASS( 19, 0, 1, 'lb', 'sb', 0x23, 1, :tdat )
    TEST_ST_SRC21_BYPASS( 20, 0, 2, 'lb', 'sb', 0x22, 2, :tdat )
    TEST_ST_SRC21_BYPASS( 21, 1, 0, 'lb', 'sb', 0x12, 3, :tdat )
    TEST_ST_SRC21_BYPASS( 22, 1, 1, 'lb', 'sb', 0x11, 4, :tdat )
    TEST_ST_SRC21_BYPASS( 23, 2, 0, 'lb', 'sb', 0x01, 5, :tdat )

    li a0, 0xef
    la a1, :tdat
    sb a0, a1, 3
  end

  def post
    TEST_PASSFAIL()
    RVTEST_CODE_END()
  end

end


