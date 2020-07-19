#
# Copyright 2018-2019 ISP RAS (http://www.ispras.ru)
#
# Licensed under the Apache License, Version 2.0 (the "License");
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

require_relative '../riscv_base'

#
# Description:
#
# This test checks LI (load immediate) pseudo instruction.
#
class InstructionLiTemplate < RiscVBaseTemplate

  def initialize
    super
    @testnum = 1
  end

  def LI_TEST_CASE( value, &code )
    newline
label :"test_#{@testnum}"
    li TESTNUM(), @testnum
    li t0, value

    if code != nil
      self.instance_eval &code
    else
      PREPARE_REGISTER( t1, value )
    end

    bne t0, t1, :fail
    @testnum = @testnum + 1
  end

  def PREPARE_REGISTER( reg, val )
    shift = 56
    started = false

    while shift >= 0
      byte_val = (val >> shift) & 0xFF

      if started
        ori reg, reg, byte_val if byte_val != 0
      elsif byte_val != 0
        ori reg, zero, byte_val
        started = true
      end

      if started && shift > 0
        slli reg, reg, 8
      end

      shift = shift - 8
    end
  end

  def run
    ################################################################################################
    # 12-bit values
    ################################################################################################

    LI_TEST_CASE( 0 ) do
      mv t1, zero
    end

    LI_TEST_CASE( 1 ) do
      ori t1, zero, 1
    end

    LI_TEST_CASE( -1 ) do
      Not t1, zero
    end

    LI_TEST_CASE( 0x700 ) do
      ori t1, zero, 7
      slli t1, t1, 8
    end

    LI_TEST_CASE( 0x800 ) do
      ori t1, zero, 1
      slli t1, t1, 11
    end

    ################################################################################################
    # 32-bit values
    ################################################################################################

    [
      0x0000_0000_FFFF_FFFF,
      0x0000_0000_7FFF_FFFF,
      0x0000_0000_8FFF_FFFF,
      0x0000_0000_7FFF_F7FF,
      0x0000_0000_7FFF_F8FF,
      0x0000_0000_8FFF_F8FF,
      0x0000_0000_8FFF_F7FF,
      0x0000_0000_DEAD_BEEF
    ].each {
      |val| LI_TEST_CASE( val )
    }

    ################################################################################################
    # 64-bit values
    ################################################################################################

    LI_TEST_CASE( 0xFFFF_FFFF_FFFF_FFFF ) do
      Not t1, zero
    end

    [
      0x7FFF_FFFF_7FFF_FFFF,
      0x7FFF_FFFF_8FFF_FFFF,
      0x7FFF_FFFF_7FFF_F7FF,
      0x7FFF_FFFF_8FFF_F8FF,

      0x8FFF_FFFF_7FFF_FFFF,
      0x8FFF_FFFF_8FFF_FFFF,
      0x8FFF_FFFF_7FFF_F7FF,
      0x8FFF_FFFF_8FFF_F8FF,

      0x7FFF_F7FF_7FFF_FFFF,
      0x7FFF_F7FF_8FFF_FFFF,
      0x7FFF_F7FF_7FFF_F7FF,
      0x7FFF_F7FF_8FFF_F8FF,

      0x8FFF_F8FF_7FFF_FFFF,
      0x8FFF_F8FF_8FFF_FFFF,
      0x8FFF_F8FF_7FFF_F7FF,
      0x8FFF_F8FF_8FFF_F7FF,

      0xDEAD_BEEF_BABE_CAFE
     ].each {
       |val| LI_TEST_CASE( val )
     }
  end

  def post
    TEST_PASSFAIL()
    RVTEST_CODE_END()
  end

end
