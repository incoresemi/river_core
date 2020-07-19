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
# https://github.com/riscv/riscv-tests/blob/master/isa/rv64ui/sd.S
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

class SdTemplate < RiscVBaseTemplate

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
      dword 0xdeadbeefdeadbeef
label :tdat2
      dword 0xdeadbeefdeadbeef
label :tdat3
      dword 0xdeadbeefdeadbeef
label :tdat4
      dword 0xdeadbeefdeadbeef
label :tdat5
      dword 0xdeadbeefdeadbeef
label :tdat6
      dword 0xdeadbeefdeadbeef
label :tdat7
      dword 0xdeadbeefdeadbeef
label :tdat8
      dword 0xdeadbeefdeadbeef
label :tdat9
      dword 0xdeadbeefdeadbeef
label :tdat10
      dword 0xdeadbeefdeadbeef
    }

    RVTEST_DATA_END()
  end

  def run
    #-------------------------------------------------------------
    # Basic tests
    #-------------------------------------------------------------

    TEST_ST_OP( 2, 'ld', 'sd', 0x00aa00aa00aa00aa, 0,  :tdat )
    TEST_ST_OP( 3, 'ld', 'sd', 0xaa00aa00aa00aa00, 8,  :tdat )
    TEST_ST_OP( 4, 'ld', 'sd', 0x0aa00aa00aa00aa0, 16,  :tdat )
    TEST_ST_OP( 5, 'ld', 'sd', 0xa00aa00aa00aa00a, 24, :tdat )

    # Test with negative offset

    TEST_ST_OP( 6, 'ld', 'sd', 0x00aa00aa00aa00aa, -24, :tdat8 )
    TEST_ST_OP( 7, 'ld', 'sd', 0xaa00aa00aa00aa00, -16, :tdat8 )
    TEST_ST_OP( 8, 'ld', 'sd', 0x0aa00aa00aa00aa0, -8,  :tdat8 )
    TEST_ST_OP( 9, 'ld', 'sd', 0xa00aa00aa00aa00a, 0,   :tdat8 )

    # Test with a negative base

    TEST_CASE( 10, x5, 0x1234567812345678 ) do 
      la  x1, :tdat9 
      li  x2, 0x1234567812345678 
      addi x4, x1, -32 
      sd x2, x4, 32 
      ld x5, x1, 0 
    end

    # Test with unaligned base

    TEST_CASE( 11, x5, 0x5821309858213098 ) do 
      la  x1, :tdat9 
      li  x2, 0x5821309858213098 
      addi x1, x1, -3 
      sd x2, x1, 11 
      la  x4, :tdat10 
      ld x5, x4, 0 
    end

    #-------------------------------------------------------------
    # Bypassing tests
    #-------------------------------------------------------------

    TEST_ST_SRC12_BYPASS( 12, 0, 0, 'ld', 'sd', 0xabbccdd, 0,  :tdat )
    TEST_ST_SRC12_BYPASS( 13, 0, 1, 'ld', 'sd', 0xaabbccd, 8,  :tdat )
    TEST_ST_SRC12_BYPASS( 14, 0, 2, 'ld', 'sd', 0xdaabbcc, 16, :tdat )
    TEST_ST_SRC12_BYPASS( 15, 1, 0, 'ld', 'sd', 0xddaabbc, 24, :tdat )
    TEST_ST_SRC12_BYPASS( 16, 1, 1, 'ld', 'sd', 0xcddaabb, 32, :tdat )
    TEST_ST_SRC12_BYPASS( 17, 2, 0, 'ld', 'sd', 0xccddaab, 40, :tdat )

    TEST_ST_SRC21_BYPASS( 18, 0, 0, 'ld', 'sd', 0x00112233, 0,  :tdat )
    TEST_ST_SRC21_BYPASS( 19, 0, 1, 'ld', 'sd', 0x30011223, 8,  :tdat )
    TEST_ST_SRC21_BYPASS( 20, 0, 2, 'ld', 'sd', 0x33001122, 16, :tdat )
    TEST_ST_SRC21_BYPASS( 21, 1, 0, 'ld', 'sd', 0x23300112, 24, :tdat )
    TEST_ST_SRC21_BYPASS( 22, 1, 1, 'ld', 'sd', 0x22330011, 32, :tdat )
    TEST_ST_SRC21_BYPASS( 23, 2, 0, 'ld', 'sd', 0x12233001, 40, :tdat )
  end

  def post
    TEST_PASSFAIL()
    RVTEST_CODE_END()
  end

end
