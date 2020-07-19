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
# https://github.com/riscv/riscv-tests/blob/master/isa/rv64ui/sltiu.S
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

class SltiuTemplate < RiscVBaseTemplate

  def pre_rvtest
    RVTEST_RV64U()
    RVTEST_CODE_BEGIN()
  end

  def run
    #-------------------------------------------------------------
    # Arithmetic tests
    #-------------------------------------------------------------

    TEST_IMM_OP( 2,  'sltiu', 0, 0x0000000000000000, 0x000 )
    TEST_IMM_OP( 3,  'sltiu', 0, 0x0000000000000001, 0x001 )
    TEST_IMM_OP( 4,  'sltiu', 1, 0x0000000000000003, 0x007 )
    TEST_IMM_OP( 5,  'sltiu', 0, 0x0000000000000007, 0x003 )

    TEST_IMM_OP( 6,  'sltiu', 1, 0x0000000000000000, 0x800 )
    TEST_IMM_OP( 7,  'sltiu', 0, 0xffffffff80000000, 0x000 )
    TEST_IMM_OP( 8,  'sltiu', 1, 0xffffffff80000000, 0x800 )

    TEST_IMM_OP( 9,  'sltiu', 1, 0x0000000000000000, 0x7ff )
    TEST_IMM_OP( 10, 'sltiu', 0, 0x000000007fffffff, 0x000 )
    TEST_IMM_OP( 11, 'sltiu', 0, 0x000000007fffffff, 0x7ff )

    TEST_IMM_OP( 12, 'sltiu', 0, 0xffffffff80000000, 0x7ff )
    TEST_IMM_OP( 13, 'sltiu', 1, 0x000000007fffffff, 0x800 )

    TEST_IMM_OP( 14, 'sltiu', 1, 0x0000000000000000, 0xfff )
    TEST_IMM_OP( 15, 'sltiu', 0, 0xffffffffffffffff, 0x001 )
    TEST_IMM_OP( 16, 'sltiu', 0, 0xffffffffffffffff, 0xfff )

    #-------------------------------------------------------------
    # Source/Destination tests
    #-------------------------------------------------------------

    TEST_IMM_SRC1_EQ_DEST( 17, 'sltiu', 1, 11, 13 )

    #-------------------------------------------------------------
    # Bypassing tests
    #-------------------------------------------------------------

    TEST_IMM_DEST_BYPASS( 18, 0, 'sltiu', 0, 15, 10 )
    TEST_IMM_DEST_BYPASS( 19, 1, 'sltiu', 1, 10, 16 )
    TEST_IMM_DEST_BYPASS( 20, 2, 'sltiu', 0, 16,  9 )

    TEST_IMM_SRC1_BYPASS( 21, 0, 'sltiu', 1, 11, 15 )
    TEST_IMM_SRC1_BYPASS( 22, 1, 'sltiu', 0, 17,  8 )
    TEST_IMM_SRC1_BYPASS( 23, 2, 'sltiu', 1, 12, 14 )

    TEST_IMM_ZEROSRC1( 24, 'sltiu', 1, 0xfff )
    TEST_IMM_ZERODEST( 25, 'sltiu', 0x00ff00ff, 0xfff )
  end

  def post
    TEST_PASSFAIL()
    RVTEST_CODE_END()
  end

end
