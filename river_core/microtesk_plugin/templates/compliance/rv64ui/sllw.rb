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
# https://github.com/riscv/riscv-tests/blob/master/isa/rv64ui/sllw.S
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

class SllwTemplate < RiscVBaseTemplate

  def pre_rvtest
    RVTEST_RV64U()
    RVTEST_CODE_BEGIN()
  end

  def run
    #-------------------------------------------------------------
    # Arithmetic tests
    #-------------------------------------------------------------

    TEST_RR_OP( 2,  'sllw', 0x0000000000000001, 0x0000000000000001, 0  )
    TEST_RR_OP( 3,  'sllw', 0x0000000000000002, 0x0000000000000001, 1  )
    TEST_RR_OP( 4,  'sllw', 0x0000000000000080, 0x0000000000000001, 7  )
    TEST_RR_OP( 5,  'sllw', 0x0000000000004000, 0x0000000000000001, 14 )
    TEST_RR_OP( 6,  'sllw', 0xffffffff80000000, 0x0000000000000001, 31 )

    TEST_RR_OP( 7,  'sllw', 0xffffffffffffffff, 0xffffffffffffffff, 0  )
    TEST_RR_OP( 8,  'sllw', 0xfffffffffffffffe, 0xffffffffffffffff, 1  )
    TEST_RR_OP( 9,  'sllw', 0xffffffffffffff80, 0xffffffffffffffff, 7  )
    TEST_RR_OP( 10, 'sllw', 0xffffffffffffc000, 0xffffffffffffffff, 14 )
    TEST_RR_OP( 11, 'sllw', 0xffffffff80000000, 0xffffffffffffffff, 31 )

    TEST_RR_OP( 12, 'sllw', 0x0000000021212121, 0x0000000021212121, 0  )
    TEST_RR_OP( 13, 'sllw', 0x0000000042424242, 0x0000000021212121, 1  )
    TEST_RR_OP( 14, 'sllw', 0xffffffff90909080, 0x0000000021212121, 7  )
    TEST_RR_OP( 15, 'sllw', 0x0000000048484000, 0x0000000021212121, 14 )
    TEST_RR_OP( 16, 'sllw', 0xffffffff80000000, 0x0000000021212121, 31 )

    # Verify that shifts only use bottom five bits

    TEST_RR_OP( 17, 'sllw', 0x0000000021212121, 0x0000000021212121, 0xffffffffffffffe0 )
    TEST_RR_OP( 18, 'sllw', 0x0000000042424242, 0x0000000021212121, 0xffffffffffffffe1 )
    TEST_RR_OP( 19, 'sllw', 0xffffffff90909080, 0x0000000021212121, 0xffffffffffffffe7 )
    TEST_RR_OP( 20, 'sllw', 0x0000000048484000, 0x0000000021212121, 0xffffffffffffffee )
    TEST_RR_OP( 21, 'sllw', 0xffffffff80000000, 0x0000000021212121, 0xffffffffffffffff )

    #-------------------------------------------------------------
    # Source/Destination tests
    #-------------------------------------------------------------

    TEST_RR_SRC1_EQ_DEST( 22, 'sllw', 0x00000080, 0x00000001, 7  )
    TEST_RR_SRC2_EQ_DEST( 23, 'sllw', 0x00004000, 0x00000001, 14 )
    TEST_RR_SRC12_EQ_DEST( 24, 'sllw', 24, 3 )

    #-------------------------------------------------------------
    # Bypassing tests
    #-------------------------------------------------------------

    TEST_RR_DEST_BYPASS( 25, 0, 'sllw', 0x0000000000000080, 0x0000000000000001, 7  )
    TEST_RR_DEST_BYPASS( 26, 1, 'sllw', 0x0000000000004000, 0x0000000000000001, 14 )
    TEST_RR_DEST_BYPASS( 27, 2, 'sllw', 0xffffffff80000000, 0x0000000000000001, 31 )

    TEST_RR_SRC12_BYPASS( 28, 0, 0, 'sllw', 0x0000000000000080, 0x0000000000000001, 7  )
    TEST_RR_SRC12_BYPASS( 29, 0, 1, 'sllw', 0x0000000000004000, 0x0000000000000001, 14 )
    TEST_RR_SRC12_BYPASS( 30, 0, 2, 'sllw', 0xffffffff80000000, 0x0000000000000001, 31 )
    TEST_RR_SRC12_BYPASS( 31, 1, 0, 'sllw', 0x0000000000000080, 0x0000000000000001, 7  )
    TEST_RR_SRC12_BYPASS( 32, 1, 1, 'sllw', 0x0000000000004000, 0x0000000000000001, 14 )
    TEST_RR_SRC12_BYPASS( 33, 2, 0, 'sllw', 0xffffffff80000000, 0x0000000000000001, 31 )

    TEST_RR_SRC21_BYPASS( 34, 0, 0, 'sllw', 0x0000000000000080, 0x0000000000000001, 7  )
    TEST_RR_SRC21_BYPASS( 35, 0, 1, 'sllw', 0x0000000000004000, 0x0000000000000001, 14 )
    TEST_RR_SRC21_BYPASS( 36, 0, 2, 'sllw', 0xffffffff80000000, 0x0000000000000001, 31 )
    TEST_RR_SRC21_BYPASS( 37, 1, 0, 'sllw', 0x0000000000000080, 0x0000000000000001, 7  )
    TEST_RR_SRC21_BYPASS( 38, 1, 1, 'sllw', 0x0000000000004000, 0x0000000000000001, 14 )
    TEST_RR_SRC21_BYPASS( 39, 2, 0, 'sllw', 0xffffffff80000000, 0x0000000000000001, 31 )

    TEST_RR_ZEROSRC1( 40, 'sllw', 0, 15 )
    TEST_RR_ZEROSRC2( 41, 'sllw', 32, 32 )
    TEST_RR_ZEROSRC12( 42, 'sllw', 0 )
    TEST_RR_ZERODEST( 43, 'sllw', 1024, 2048 )
  end

  def post
    TEST_PASSFAIL()
    RVTEST_CODE_END()
  end

end
