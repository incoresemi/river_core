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
# https://github.com/riscv/riscv-tests/blob/master/isa/rv64ui/sltu.S
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

class SltuTemplate < RiscVBaseTemplate

  def pre_rvtest
    RVTEST_RV64U()
    RVTEST_CODE_BEGIN()
  end

  def run
    #-------------------------------------------------------------
    # Arithmetic tests
    #-------------------------------------------------------------

    TEST_RR_OP( 2,  'sltu', 0, 0x00000000, 0x00000000 )
    TEST_RR_OP( 3,  'sltu', 0, 0x00000001, 0x00000001 )
    TEST_RR_OP( 4,  'sltu', 1, 0x00000003, 0x00000007 )
    TEST_RR_OP( 5,  'sltu', 0, 0x00000007, 0x00000003 )

    TEST_RR_OP( 6,  'sltu', 1, 0x00000000, 0xffff8000 )
    TEST_RR_OP( 7,  'sltu', 0, 0x80000000, 0x00000000 )
    TEST_RR_OP( 8,  'sltu', 1, 0x80000000, 0xffff8000 )

    TEST_RR_OP( 9,  'sltu', 1, 0x00000000, 0x00007fff )
    TEST_RR_OP( 10, 'sltu', 0, 0x7fffffff, 0x00000000 )
    TEST_RR_OP( 11, 'sltu', 0, 0x7fffffff, 0x00007fff )

    TEST_RR_OP( 12, 'sltu', 0, 0x80000000, 0x00007fff )
    TEST_RR_OP( 13, 'sltu', 1, 0x7fffffff, 0xffff8000 )

    TEST_RR_OP( 14, 'sltu', 1, 0x00000000, 0xffffffff )
    TEST_RR_OP( 15, 'sltu', 0, 0xffffffff, 0x00000001 )
    TEST_RR_OP( 16, 'sltu', 0, 0xffffffff, 0xffffffff )

    #-------------------------------------------------------------
    # Source/Destination tests
    #-------------------------------------------------------------

    TEST_RR_SRC1_EQ_DEST( 17, 'sltu', 0, 14, 13 )
    TEST_RR_SRC2_EQ_DEST( 18, 'sltu', 1, 11, 13 )
    TEST_RR_SRC12_EQ_DEST( 19, 'sltu', 0, 13 )

    #-------------------------------------------------------------
    # Bypassing tests
    #-------------------------------------------------------------

    TEST_RR_DEST_BYPASS( 20, 0, 'sltu', 1, 11, 13 )
    TEST_RR_DEST_BYPASS( 21, 1, 'sltu', 0, 14, 13 )
    TEST_RR_DEST_BYPASS( 22, 2, 'sltu', 1, 12, 13 )

    TEST_RR_SRC12_BYPASS( 23, 0, 0, 'sltu', 0, 14, 13 )
    TEST_RR_SRC12_BYPASS( 24, 0, 1, 'sltu', 1, 11, 13 )
    TEST_RR_SRC12_BYPASS( 25, 0, 2, 'sltu', 0, 15, 13 )
    TEST_RR_SRC12_BYPASS( 26, 1, 0, 'sltu', 1, 10, 13 )
    TEST_RR_SRC12_BYPASS( 27, 1, 1, 'sltu', 0, 16, 13 )
    TEST_RR_SRC12_BYPASS( 28, 2, 0, 'sltu', 1,  9, 13 )

    TEST_RR_SRC21_BYPASS( 29, 0, 0, 'sltu', 0, 17, 13 )
    TEST_RR_SRC21_BYPASS( 30, 0, 1, 'sltu', 1,  8, 13 )
    TEST_RR_SRC21_BYPASS( 31, 0, 2, 'sltu', 0, 18, 13 )
    TEST_RR_SRC21_BYPASS( 32, 1, 0, 'sltu', 1,  7, 13 )
    TEST_RR_SRC21_BYPASS( 33, 1, 1, 'sltu', 0, 19, 13 )
    TEST_RR_SRC21_BYPASS( 34, 2, 0, 'sltu', 1,  6, 13 )

    TEST_RR_ZEROSRC1( 35, 'sltu', 1, -1 )
    TEST_RR_ZEROSRC2( 36, 'sltu', 0, -1 )
    TEST_RR_ZEROSRC12( 37, 'sltu', 0 )
    TEST_RR_ZERODEST( 38, 'sltu', 16, 30 )
  end

  def post
    TEST_PASSFAIL()
    RVTEST_CODE_END()
  end

end
