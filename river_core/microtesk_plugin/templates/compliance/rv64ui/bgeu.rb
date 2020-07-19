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
# https://github.com/riscv/riscv-tests/blob/master/isa/rv64ui/bgeu.S
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

class BgeuTemplate < RiscVBaseTemplate

  def pre_rvtest
    RVTEST_RV64U()
    RVTEST_CODE_BEGIN()
  end

  def run
    #-------------------------------------------------------------
    # Branch tests
    #-------------------------------------------------------------

    # Each test checks both forward and backward branches

    TEST_BR2_OP_TAKEN( 2, 'bgeu', 0x00000000, 0x00000000 )
    TEST_BR2_OP_TAKEN( 3, 'bgeu', 0x00000001, 0x00000001 )
    TEST_BR2_OP_TAKEN( 4, 'bgeu', 0xffffffff, 0xffffffff )
    TEST_BR2_OP_TAKEN( 5, 'bgeu', 0x00000001, 0x00000000 )
    TEST_BR2_OP_TAKEN( 6, 'bgeu', 0xffffffff, 0xfffffffe )
    TEST_BR2_OP_TAKEN( 7, 'bgeu', 0xffffffff, 0x00000000 )

    TEST_BR2_OP_NOTTAKEN(  8, 'bgeu', 0x00000000, 0x00000001 )
    TEST_BR2_OP_NOTTAKEN(  9, 'bgeu', 0xfffffffe, 0xffffffff )
    TEST_BR2_OP_NOTTAKEN( 10, 'bgeu', 0x00000000, 0xffffffff )
    TEST_BR2_OP_NOTTAKEN( 11, 'bgeu', 0x7fffffff, 0x80000000 )

    #-------------------------------------------------------------
    # Bypassing tests
    #-------------------------------------------------------------

    TEST_BR2_SRC12_BYPASS( 12, 0, 0, 'bgeu', 0xefffffff, 0xf0000000 )
    TEST_BR2_SRC12_BYPASS( 13, 0, 1, 'bgeu', 0xefffffff, 0xf0000000 )
    TEST_BR2_SRC12_BYPASS( 14, 0, 2, 'bgeu', 0xefffffff, 0xf0000000 )
    TEST_BR2_SRC12_BYPASS( 15, 1, 0, 'bgeu', 0xefffffff, 0xf0000000 )
    TEST_BR2_SRC12_BYPASS( 16, 1, 1, 'bgeu', 0xefffffff, 0xf0000000 )
    TEST_BR2_SRC12_BYPASS( 17, 2, 0, 'bgeu', 0xefffffff, 0xf0000000 )

    TEST_BR2_SRC12_BYPASS( 18, 0, 0, 'bgeu', 0xefffffff, 0xf0000000 )
    TEST_BR2_SRC12_BYPASS( 19, 0, 1, 'bgeu', 0xefffffff, 0xf0000000 )
    TEST_BR2_SRC12_BYPASS( 20, 0, 2, 'bgeu', 0xefffffff, 0xf0000000 )
    TEST_BR2_SRC12_BYPASS( 21, 1, 0, 'bgeu', 0xefffffff, 0xf0000000 )
    TEST_BR2_SRC12_BYPASS( 22, 1, 1, 'bgeu', 0xefffffff, 0xf0000000 )
    TEST_BR2_SRC12_BYPASS( 23, 2, 0, 'bgeu', 0xefffffff, 0xf0000000 )

    #-------------------------------------------------------------
    # Test delay slot instructions not executed nor bypassed
    #-------------------------------------------------------------

    TEST_CASE( 24, x1, 3 ) do
      li  x1, 1
      bgeu x1, x0, label_f(1)
      addi x1, x1, 1
      addi x1, x1, 1
      addi x1, x1, 1
      addi x1, x1, 1
label 1
      addi x1, x1, 1
      addi x1, x1, 1
    end
  end

  def post
    TEST_PASSFAIL()
    RVTEST_CODE_END()
  end

end
