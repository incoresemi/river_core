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
# https://github.com/riscv/riscv-tests/blob/master/isa/rv64ui/and.S
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

class AndTemplate < RiscVBaseTemplate

  def pre_rvtest
    RVTEST_RV64U()
    RVTEST_CODE_BEGIN()
  end

  def run
    #-------------------------------------------------------------
    # Logical tests
    #-------------------------------------------------------------

    TEST_RR_OP( 2, 'and', 0x0f000f00, 0xff00ff00, 0x0f0f0f0f )
    TEST_RR_OP( 3, 'and', 0x00f000f0, 0x0ff00ff0, 0xf0f0f0f0 )
    TEST_RR_OP( 4, 'and', 0x000f000f, 0x00ff00ff, 0x0f0f0f0f )
    TEST_RR_OP( 5, 'and', 0xf000f000, 0xf00ff00f, 0xf0f0f0f0 )

    #-------------------------------------------------------------
    # Source/Destination tests
    #-------------------------------------------------------------

    TEST_RR_SRC1_EQ_DEST( 6, 'and', 0x0f000f00, 0xff00ff00, 0x0f0f0f0f )
    TEST_RR_SRC2_EQ_DEST( 7, 'and', 0x00f000f0, 0x0ff00ff0, 0xf0f0f0f0 )
    TEST_RR_SRC12_EQ_DEST( 8, 'and', 0xff00ff00, 0xff00ff00 )

    #-------------------------------------------------------------
    # Bypassing tests
    #-------------------------------------------------------------

    TEST_RR_DEST_BYPASS( 9,  0, 'and', 0x0f000f00, 0xff00ff00, 0x0f0f0f0f )
    TEST_RR_DEST_BYPASS( 10, 1, 'and', 0x00f000f0, 0x0ff00ff0, 0xf0f0f0f0 )
    TEST_RR_DEST_BYPASS( 11, 2, 'and', 0x000f000f, 0x00ff00ff, 0x0f0f0f0f )

    TEST_RR_SRC12_BYPASS( 12, 0, 0, 'and', 0x0f000f00, 0xff00ff00, 0x0f0f0f0f )
    TEST_RR_SRC12_BYPASS( 13, 0, 1, 'and', 0x00f000f0, 0x0ff00ff0, 0xf0f0f0f0 )
    TEST_RR_SRC12_BYPASS( 14, 0, 2, 'and', 0x000f000f, 0x00ff00ff, 0x0f0f0f0f )
    TEST_RR_SRC12_BYPASS( 15, 1, 0, 'and', 0x0f000f00, 0xff00ff00, 0x0f0f0f0f )
    TEST_RR_SRC12_BYPASS( 16, 1, 1, 'and', 0x00f000f0, 0x0ff00ff0, 0xf0f0f0f0 )
    TEST_RR_SRC12_BYPASS( 17, 2, 0, 'and', 0x000f000f, 0x00ff00ff, 0x0f0f0f0f )

    TEST_RR_SRC21_BYPASS( 18, 0, 0, 'and', 0x0f000f00, 0xff00ff00, 0x0f0f0f0f )
    TEST_RR_SRC21_BYPASS( 19, 0, 1, 'and', 0x00f000f0, 0x0ff00ff0, 0xf0f0f0f0 )
    TEST_RR_SRC21_BYPASS( 20, 0, 2, 'and', 0x000f000f, 0x00ff00ff, 0x0f0f0f0f )
    TEST_RR_SRC21_BYPASS( 21, 1, 0, 'and', 0x0f000f00, 0xff00ff00, 0x0f0f0f0f )
    TEST_RR_SRC21_BYPASS( 22, 1, 1, 'and', 0x00f000f0, 0x0ff00ff0, 0xf0f0f0f0 )
    TEST_RR_SRC21_BYPASS( 23, 2, 0, 'and', 0x000f000f, 0x00ff00ff, 0x0f0f0f0f )

    TEST_RR_ZEROSRC1( 24, 'and', 0, 0xff00ff00 )
    TEST_RR_ZEROSRC2( 25, 'and', 0, 0x00ff00ff )
    TEST_RR_ZEROSRC12( 26, 'and', 0 )
    TEST_RR_ZERODEST( 27, 'and', 0x11111111, 0x22222222 )
  end

  def post
    TEST_PASSFAIL()
    RVTEST_CODE_END()
  end

end
