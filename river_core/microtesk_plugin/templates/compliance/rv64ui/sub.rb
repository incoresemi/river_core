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
# https://github.com/riscv/riscv-tests/blob/master/isa/rv64ui/sub.S
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

class SubTemplate < RiscVBaseTemplate

  def pre_rvtest
    RVTEST_RV64U()
    RVTEST_CODE_BEGIN()
  end

  def run
    #-------------------------------------------------------------
    # Arithmetic tests
    #-------------------------------------------------------------

    TEST_RR_OP( 2,  'sub', 0x0000000000000000, 0x0000000000000000, 0x0000000000000000 )
    TEST_RR_OP( 3,  'sub', 0x0000000000000000, 0x0000000000000001, 0x0000000000000001 )
    TEST_RR_OP( 4,  'sub', 0xfffffffffffffffc, 0x0000000000000003, 0x0000000000000007 )

    TEST_RR_OP( 5,  'sub', 0x0000000000008000, 0x0000000000000000, 0xffffffffffff8000 )
    TEST_RR_OP( 6,  'sub', 0xffffffff80000000, 0xffffffff80000000, 0x0000000000000000 )
    TEST_RR_OP( 7,  'sub', 0xffffffff80008000, 0xffffffff80000000, 0xffffffffffff8000 )

    TEST_RR_OP( 8,  'sub', 0xffffffffffff8001, 0x0000000000000000, 0x0000000000007fff )
    TEST_RR_OP( 9,  'sub', 0x000000007fffffff, 0x000000007fffffff, 0x0000000000000000 )
    TEST_RR_OP( 10, 'sub', 0x000000007fff8000, 0x000000007fffffff, 0x0000000000007fff )

    TEST_RR_OP( 11, 'sub', 0xffffffff7fff8001, 0xffffffff80000000, 0x0000000000007fff )
    TEST_RR_OP( 12, 'sub', 0x0000000080007fff, 0x000000007fffffff, 0xffffffffffff8000 )

    TEST_RR_OP( 13, 'sub', 0x0000000000000001, 0x0000000000000000, 0xffffffffffffffff )
    TEST_RR_OP( 14, 'sub', 0xfffffffffffffffe, 0xffffffffffffffff, 0x0000000000000001 )
    TEST_RR_OP( 15, 'sub', 0x0000000000000000, 0xffffffffffffffff, 0xffffffffffffffff )

    #-------------------------------------------------------------
    # Source/Destination tests
    #-------------------------------------------------------------

    TEST_RR_SRC1_EQ_DEST( 16, 'sub', 2, 13, 11 )
    TEST_RR_SRC2_EQ_DEST( 17, 'sub', 3, 14, 11 )
    TEST_RR_SRC12_EQ_DEST( 18, 'sub', 0, 13 )

    #-------------------------------------------------------------
    # Bypassing tests
    #-------------------------------------------------------------

    TEST_RR_DEST_BYPASS( 19, 0, 'sub', 2, 13, 11 )
    TEST_RR_DEST_BYPASS( 20, 1, 'sub', 3, 14, 11 )
    TEST_RR_DEST_BYPASS( 21, 2, 'sub', 4, 15, 11 )

    TEST_RR_SRC12_BYPASS( 22, 0, 0, 'sub', 2, 13, 11 )
    TEST_RR_SRC12_BYPASS( 23, 0, 1, 'sub', 3, 14, 11 )
    TEST_RR_SRC12_BYPASS( 24, 0, 2, 'sub', 4, 15, 11 )
    TEST_RR_SRC12_BYPASS( 25, 1, 0, 'sub', 2, 13, 11 )
    TEST_RR_SRC12_BYPASS( 26, 1, 1, 'sub', 3, 14, 11 )
    TEST_RR_SRC12_BYPASS( 27, 2, 0, 'sub', 4, 15, 11 )

    TEST_RR_SRC21_BYPASS( 28, 0, 0, 'sub', 2, 13, 11 )
    TEST_RR_SRC21_BYPASS( 29, 0, 1, 'sub', 3, 14, 11 )
    TEST_RR_SRC21_BYPASS( 30, 0, 2, 'sub', 4, 15, 11 )
    TEST_RR_SRC21_BYPASS( 31, 1, 0, 'sub', 2, 13, 11 )
    TEST_RR_SRC21_BYPASS( 32, 1, 1, 'sub', 3, 14, 11 )
    TEST_RR_SRC21_BYPASS( 33, 2, 0, 'sub', 4, 15, 11 )

    TEST_RR_ZEROSRC1( 34, 'sub', 15, -15 )
    TEST_RR_ZEROSRC2( 35, 'sub', 32, 32 )
    TEST_RR_ZEROSRC12( 36, 'sub', 0 )
    TEST_RR_ZERODEST( 37, 'sub', 16, 30 )
  end

  def post
    TEST_PASSFAIL()
    RVTEST_CODE_END()
  end

end
