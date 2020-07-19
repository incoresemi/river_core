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
# https://github.com/riscv/riscv-tests/blob/master/isa/rv64ui/lhu.S
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

class LhuTemplate < RiscVBaseTemplate

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
      half 0x00ff
label :tdat2
      half 0xff00
label :tdat3
      half 0x0ff0
label :tdat4
      half 0xf00f
    }

    RVTEST_DATA_END()
  end

  def run
    #-------------------------------------------------------------
    # Basic tests
    #-------------------------------------------------------------

    TEST_LD_OP( 2, 'lhu', 0x00000000000000ff, 0,  :tdat )
    TEST_LD_OP( 3, 'lhu', 0x000000000000ff00, 2,  :tdat )
    TEST_LD_OP( 4, 'lhu', 0x0000000000000ff0, 4,  :tdat )
    TEST_LD_OP( 5, 'lhu', 0x000000000000f00f, 6, :tdat )

    # Test with negative offset

    TEST_LD_OP( 6, 'lhu', 0x00000000000000ff, -6,  :tdat4 )
    TEST_LD_OP( 7, 'lhu', 0x000000000000ff00, -4,  :tdat4 )
    TEST_LD_OP( 8, 'lhu', 0x0000000000000ff0, -2,  :tdat4 )
    TEST_LD_OP( 9, 'lhu', 0x000000000000f00f,  0, :tdat4 )

    # Test with a negative base

    TEST_CASE( 10, x5, 0x00000000000000ff ) do 
      la  x1, :tdat 
      addi x1, x1, -32 
      lhu x5, x1, 32 
    end

    # Test with unaligned base

    TEST_CASE( 11, x5, 0x000000000000ff00 ) do 
      la  x1, :tdat 
      addi x1, x1, -5 
      lhu x5, x1, 7 
    end

    #-------------------------------------------------------------
    # Bypassing tests
    #-------------------------------------------------------------

    TEST_LD_DEST_BYPASS( 12, 0, 'lhu', 0x0000000000000ff0, 2, :tdat2 )
    TEST_LD_DEST_BYPASS( 13, 1, 'lhu', 0x000000000000f00f, 2, :tdat3 )
    TEST_LD_DEST_BYPASS( 14, 2, 'lhu', 0x000000000000ff00, 2, :tdat1 )

    TEST_LD_SRC1_BYPASS( 15, 0, 'lhu', 0x0000000000000ff0, 2, :tdat2 )
    TEST_LD_SRC1_BYPASS( 16, 1, 'lhu', 0x000000000000f00f, 2, :tdat3 )
    TEST_LD_SRC1_BYPASS( 17, 2, 'lhu', 0x000000000000ff00, 2, :tdat1 )

    #-------------------------------------------------------------
    # Test write-after-write hazard
    #-------------------------------------------------------------

    TEST_CASE( 18, x2, 2 ) do
      la  x5, :tdat 
      lhu  x2, x5, 0 
      li  x2, 2 
    end

    TEST_CASE( 19, x2, 2 ) do 
      la  x5, :tdat 
      lhu  x2, x5, 0
      nop 
      li  x2, 2 
    end
  end

  def post
    TEST_PASSFAIL()
    RVTEST_CODE_END()
  end

end
