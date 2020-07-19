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
# https://github.com/riscv/riscv-tests/blob/master/isa/rv64ui/sw.S
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

class SwTemplate < RiscVBaseTemplate

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
      word 0xdeadbeef
label :tdat2
      word 0xdeadbeef
label :tdat3
      word 0xdeadbeef
label :tdat4
      word 0xdeadbeef
label :tdat5
      word 0xdeadbeef
label :tdat6
      word 0xdeadbeef
label :tdat7
      word 0xdeadbeef
label :tdat8
      word 0xdeadbeef
label :tdat9
      word 0xdeadbeef
label :tdat10
      word 0xdeadbeef
    }

    RVTEST_DATA_END()
  end

  def run
    #-------------------------------------------------------------
    # Basic tests
    #-------------------------------------------------------------    

    TEST_ST_OP( 2, 'lw', 'sw', 0x0000000000aa00aa, 0,  :tdat )
    TEST_ST_OP( 3, 'lw', 'sw', 0xffffffffaa00aa00, 4,  :tdat )
    TEST_ST_OP( 4, 'lw', 'sw', 0x000000000aa00aa0, 8,  :tdat )
    TEST_ST_OP( 5, 'lw', 'sw', 0xffffffffa00aa00a, 12, :tdat )

    # Test with negative offset

    TEST_ST_OP( 6, 'lw', 'sw', 0x0000000000aa00aa, -12, :tdat8 )
    TEST_ST_OP( 7, 'lw', 'sw', 0xffffffffaa00aa00, -8,  :tdat8 )
    TEST_ST_OP( 8, 'lw', 'sw', 0x000000000aa00aa0, -4,  :tdat8 )
    TEST_ST_OP( 9, 'lw', 'sw', 0xffffffffa00aa00a, 0,   :tdat8 )

    # Test with a negative base

    TEST_CASE( 10, x5, 0x12345678 ) do 
      la  x1, :tdat9 
      li  x2, 0x12345678 
      addi x4, x1, -32 
      sw x2, x4, 32 
      lw x5, x1, 0
    end

    # Test with unaligned base

    TEST_CASE( 11, x5, 0x58213098 ) do 
      la  x1, :tdat9 
      li  x2, 0x58213098 
      addi x1, x1, -3 
      sw x2, x1, 7 
      la  x4, :tdat10 
      lw x5, x4, 0 
    end

    #-------------------------------------------------------------
    # Bypassing tests
    #-------------------------------------------------------------

    TEST_ST_SRC12_BYPASS( 12, 0, 0, 'lw', 'sw', 0xffffffffaabbccdd, 0,  :tdat )
    TEST_ST_SRC12_BYPASS( 13, 0, 1, 'lw', 'sw', 0xffffffffdaabbccd, 4,  :tdat )
    TEST_ST_SRC12_BYPASS( 14, 0, 2, 'lw', 'sw', 0xffffffffddaabbcc, 8,  :tdat )
    TEST_ST_SRC12_BYPASS( 15, 1, 0, 'lw', 'sw', 0xffffffffcddaabbc, 12, :tdat )
    TEST_ST_SRC12_BYPASS( 16, 1, 1, 'lw', 'sw', 0xffffffffccddaabb, 16, :tdat )
    TEST_ST_SRC12_BYPASS( 17, 2, 0, 'lw', 'sw', 0xffffffffbccddaab, 20, :tdat )

    TEST_ST_SRC21_BYPASS( 18, 0, 0, 'lw', 'sw', 0x00112233, 0,  :tdat )
    TEST_ST_SRC21_BYPASS( 19, 0, 1, 'lw', 'sw', 0x30011223, 4,  :tdat )
    TEST_ST_SRC21_BYPASS( 20, 0, 2, 'lw', 'sw', 0x33001122, 8,  :tdat )
    TEST_ST_SRC21_BYPASS( 21, 1, 0, 'lw', 'sw', 0x23300112, 12, :tdat )
    TEST_ST_SRC21_BYPASS( 22, 1, 1, 'lw', 'sw', 0x22330011, 16, :tdat )
    TEST_ST_SRC21_BYPASS( 23, 2, 0, 'lw', 'sw', 0x12233001, 20, :tdat )
  end

  def post
    TEST_PASSFAIL()
    RVTEST_CODE_END()
  end

end


