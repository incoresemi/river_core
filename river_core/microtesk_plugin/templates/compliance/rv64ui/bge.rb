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
# https://github.com/riscv/riscv-tests/blob/master/isa/rv64ui/bge.S
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

class BgeTemplate < RiscVBaseTemplate

  def pre_rvtest
    RVTEST_RV64U()
    RVTEST_CODE_BEGIN()
  end

  def run
    #-------------------------------------------------------------
    # Branch tests
    #-------------------------------------------------------------

    # Each test checks both forward and backward branches

    TEST_BR2_OP_TAKEN( 2, 'bge',  0,  0 )
    TEST_BR2_OP_TAKEN( 3, 'bge',  1,  1 )
    TEST_BR2_OP_TAKEN( 4, 'bge', -1, -1 )
    TEST_BR2_OP_TAKEN( 5, 'bge',  1,  0 )
    TEST_BR2_OP_TAKEN( 6, 'bge',  1, -1 )
    TEST_BR2_OP_TAKEN( 7, 'bge', -1, -2 )

    TEST_BR2_OP_NOTTAKEN(  8, 'bge',  0,  1 )
    TEST_BR2_OP_NOTTAKEN(  9, 'bge', -1,  1 )
    TEST_BR2_OP_NOTTAKEN( 10, 'bge', -2, -1 )
    TEST_BR2_OP_NOTTAKEN( 11, 'bge', -2,  1 )

    #-------------------------------------------------------------
    # Bypassing tests
    #-------------------------------------------------------------

    TEST_BR2_SRC12_BYPASS( 12, 0, 0, 'bge', -1, 0 )
    TEST_BR2_SRC12_BYPASS( 13, 0, 1, 'bge', -1, 0 )
    TEST_BR2_SRC12_BYPASS( 14, 0, 2, 'bge', -1, 0 )
    TEST_BR2_SRC12_BYPASS( 15, 1, 0, 'bge', -1, 0 )
    TEST_BR2_SRC12_BYPASS( 16, 1, 1, 'bge', -1, 0 )
    TEST_BR2_SRC12_BYPASS( 17, 2, 0, 'bge', -1, 0 )

    TEST_BR2_SRC12_BYPASS( 18, 0, 0, 'bge', -1, 0 )
    TEST_BR2_SRC12_BYPASS( 19, 0, 1, 'bge', -1, 0 )
    TEST_BR2_SRC12_BYPASS( 20, 0, 2, 'bge', -1, 0 )
    TEST_BR2_SRC12_BYPASS( 21, 1, 0, 'bge', -1, 0 )
    TEST_BR2_SRC12_BYPASS( 22, 1, 1, 'bge', -1, 0 )
    TEST_BR2_SRC12_BYPASS( 23, 2, 0, 'bge', -1, 0 )

    #-------------------------------------------------------------
    # Test delay slot instructions not executed nor bypassed
    #-------------------------------------------------------------

    TEST_CASE( 24, x1, 3 ) do
      li  x1, 1
      bge x1, x0, label_f(1)
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
