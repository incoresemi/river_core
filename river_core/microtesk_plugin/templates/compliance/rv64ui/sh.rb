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
# https://github.com/riscv/riscv-tests/blob/master/isa/rv64ui/sh.S
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

class ShTemplate < RiscVBaseTemplate

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
      half 0xbeef
label :tdat2
      half 0xbeef
label :tdat3
      half 0xbeef
label :tdat4
      half 0xbeef
label :tdat5
      half 0xbeef
label :tdat6
      half 0xbeef
label :tdat7
      half 0xbeef
label :tdat8
      half 0xbeef
label :tdat9
      half 0xbeef
label :tdat10
      half 0xbeef
    }

    RVTEST_DATA_END()
  end

  def run
    #-------------------------------------------------------------
    # Basic tests
    #-------------------------------------------------------------    

    TEST_ST_OP( 2, 'lh', 'sh', 0x00000000000000aa, 0, :tdat )
    TEST_ST_OP( 3, 'lh', 'sh', 0xffffffffffffaa00, 2, :tdat )
    TEST_ST_OP( 4, 'lw', 'sh', 0xffffffffbeef0aa0, 4, :tdat )
    TEST_ST_OP( 5, 'lh', 'sh', 0xffffffffffffa00a, 6, :tdat )

    # Test with negative offset

    TEST_ST_OP( 6, 'lh', 'sh', 0x00000000000000aa, -6, :tdat8 )
    TEST_ST_OP( 7, 'lh', 'sh', 0xffffffffffffaa00, -4, :tdat8 )
    TEST_ST_OP( 8, 'lh', 'sh', 0x0000000000000aa0, -2, :tdat8 )
    TEST_ST_OP( 9, 'lh', 'sh', 0xffffffffffffa00a, 0,  :tdat8 )

    # Test with a negative base

    TEST_CASE( 10, x5, 0x5678 ) do 
      la  x1, :tdat9 
      li  x2, 0x12345678 
      addi x4, x1, -32 
      sh x2, x4, 32 
      lh x5, x1, 0 
    end

    # Test with unaligned base

    TEST_CASE( 11, x5, 0x3098 ) do 
      la  x1, :tdat9 
      li  x2, 0x00003098 
      addi x1, x1, -5 
      sh x2, x1, 7 
      la  x4, :tdat10 
      lh x5, x4, 0 
    end

    #-------------------------------------------------------------
    # Bypassing tests
    #-------------------------------------------------------------

    TEST_ST_SRC12_BYPASS( 12, 0, 0, 'lh', 'sh', 0xffffffffffffccdd, 0,  :tdat )
    TEST_ST_SRC12_BYPASS( 13, 0, 1, 'lh', 'sh', 0xffffffffffffbccd, 2,  :tdat )
    TEST_ST_SRC12_BYPASS( 14, 0, 2, 'lh', 'sh', 0xffffffffffffbbcc, 4,  :tdat )
    TEST_ST_SRC12_BYPASS( 15, 1, 0, 'lh', 'sh', 0xffffffffffffabbc, 6, :tdat )
    TEST_ST_SRC12_BYPASS( 16, 1, 1, 'lh', 'sh', 0xffffffffffffaabb, 8, :tdat )
    TEST_ST_SRC12_BYPASS( 17, 2, 0, 'lh', 'sh', 0xffffffffffffdaab, 10, :tdat )

    TEST_ST_SRC21_BYPASS( 18, 0, 0, 'lh', 'sh', 0x2233, 0,  :tdat )
    TEST_ST_SRC21_BYPASS( 19, 0, 1, 'lh', 'sh', 0x1223, 2,  :tdat )
    TEST_ST_SRC21_BYPASS( 20, 0, 2, 'lh', 'sh', 0x1122, 4,  :tdat )
    TEST_ST_SRC21_BYPASS( 21, 1, 0, 'lh', 'sh', 0x0112, 6, :tdat )
    TEST_ST_SRC21_BYPASS( 22, 1, 1, 'lh', 'sh', 0x0011, 8, :tdat )
    TEST_ST_SRC21_BYPASS( 23, 2, 0, 'lh', 'sh', 0x3001, 10, :tdat )

    li a0, 0xbeef
    la a1, :tdat
    sh a0, a1, 6
  end

  def post
    TEST_PASSFAIL()
    RVTEST_CODE_END()
  end

end


