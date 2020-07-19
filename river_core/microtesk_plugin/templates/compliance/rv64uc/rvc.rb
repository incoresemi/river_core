#
# Copyright 2018 ISP RAS (http://www.ispras.ru)
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
# THIS FILE IS BASED ON THE FOLLOWING RISC-V TEST SUITE SOURCE FILE:
# https://github.com/riscv/riscv-tests/blob/master/isa/rv64uc/rvc.S
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

class RvcTemplate < RiscVBaseTemplate

  def pre_rvtest
    RVTEST_RV64U()
    RVTEST_CODE_BEGIN()
  end

  def RVC_TEST_CASE(n, r, v, &code)
    TEST_CASE( n, r, v ) do
      text '.option push'
      text '.option rvc'
      self.instance_eval &code
      align 2
      text '.option pop'
    end
  end

  def run
    #-------------------------------------------------------------
    # Test RVC corner cases
    #-------------------------------------------------------------

    align 2
    text '.option push'
    text '.option norvc'

    # Make sure fetching a 4-byte instruction across a page boundary works.
    li TESTNUM(), 2
    li a1, 666

    TEST_CASE( 2, a1, 667 ) do
      j label_f(1)
      # TODO: Need a way to allocate data in the middle of a text section.
      data {
        align 3
label :data
        dword 0xfedcba9876543210
        dword 0xfedcba9876543210
        align 12
        skip 4094
      }
label 1
      addi a1, a1, 1
    end

    li sp, 0x1234

    RVC_TEST_CASE( 3, a0, 0x1234 + 1020 ) do
      c_addi4spn a0c, 1020
    end

    RVC_TEST_CASE( 4, sp, 0x1234 + 496 ) do
      c_addi16sp 496
    end

    RVC_TEST_CASE( 5, sp, 0x1234 + 496 - 512 ) do
      c_addi16sp -512
    end

    la a1, :data
    RVC_TEST_CASE( 6, a2, 0xfffffffffedcba99 ) do
      c_lw a0c, a1c, 4
      addi a0, a0, 1
      c_sw a0c, a1c, 4
      c_lw a2c, a1c, 4
    end

  if __riscv_xlen == 64
    RVC_TEST_CASE( 7, a2, 0xfedcba9976543211 ) do
      c_ld a0c, a1c, 0
      addi a0, a0, 1
      c_sd a0c, a1c, 0
      c_ld a2c, a1c, 0
    end
  end

    RVC_TEST_CASE( 8, a0, -15 ) do
      ori a0, x0, 1
      c_addi a0, -16
    end

    RVC_TEST_CASE( 9, a5, -16 ) do
      ori a5, x0, 1
      c_li a5, -16
    end

  if __riscv_xlen == 64
    RVC_TEST_CASE( 10, a0, 0x76543210 ) do
      ld a0, a1, 0 # Originally: ld a0, (a1)
      c_addiw a0, -1
    end
  end

    RVC_TEST_CASE( 11, s0, 0xffffffffffffffe1 ) do
      c_lui s0, 0xfffe1
      c_srai s0c, 12
    end

  if __riscv_xlen == 64
    RVC_TEST_CASE( 12, s0, 0x000fffffffffffe1 ) do
      c_lui s0, 0xfffe1
      c_srli s0c, 12
    end
  else
    RVC_TEST_CASE( 12, s0, 0x000fffe1 ) do
      c_lui s0, 0xfffe1
      c_srli s0c, 12
    end
  end

    RVC_TEST_CASE( 14, s0, ~0x11 ) do
      c_li s0, -2
      c_andi s0c, ~0x10
    end

    RVC_TEST_CASE( 15, s1, 14 ) do
      li s1, 20
      li a0, 6
      c_sub s1c, a0c
    end

    RVC_TEST_CASE( 16, s1, 18 ) do
      li s1, 20
      li a0, 6
      c_xor s1c, a0c
    end

    RVC_TEST_CASE( 17, s1, 22 ) do
      li s1, 20
      li a0, 6
      c_or s1c, a0c
    end

    RVC_TEST_CASE( 18, s1,  4 ) do
      li s1, 20
      li a0, 6
      c_and s1c, a0c
    end

  if __riscv_xlen == 64
    RVC_TEST_CASE( 19, s1, 0xffffffff80000000 ) do
      li s1, 0x7fffffff
      li a0, -1
      c_subw s1c, a0c
    end

    RVC_TEST_CASE( 20, s1, 0xffffffff80000000 ) do
      li s1, 0x7fffffff
      li a0, 1
      c_addw s1c, a0c
    end
  end

    RVC_TEST_CASE( 21, s0, 0x12340 ) do
      li s0, 0x1234
      c_slli s0, 4
    end

    RVC_TEST_CASE( 30, ra, 0 ) do
      li ra, 0
      c_j label_f(1)
      c_j label_f(2)
label 1
      c_j label_f(1)
label 2
      j :fail
label 1
      c_nop # FIXME: Jump to 0x000000008000033a --> No executable code at 0x000000008000033a
   end

    RVC_TEST_CASE( 31, x0, 0 ) do
      li a0, 0
      c_beqz a0c, label_f(1)
      c_j label_f(2)
label 1
      c_j label_f(1)
label 2
      j :fail
label 1
      c_nop # FIXME: Jump to 0x000000008000033a --> No executable code at 0x000000008000033a
    end

    RVC_TEST_CASE( 32, x0, 0 ) do
      li a0, 1
      c_bnez a0c, label_f(1)
      c_j label_f(2)
label 1
      c_j label_f(1)
label 2
      j :fail
label 1
      c_nop # FIXME: Jump to 0x000000008000033a --> No executable code at 0x000000008000033a
    end

    RVC_TEST_CASE( 33, x0, 0 ) do
      li a0, 1
      c_beqz a0c, label_f(1)
      c_j label_f(2)
label 1
      c_j :fail
label 2
      c_nop # FIXME: Jump to 0x000000008000033a --> No executable code at 0x000000008000033a
    end

    RVC_TEST_CASE( 34, x0, 0 ) do
      li a0, 0
      c_bnez a0c, label_f(1)
      c_j label_f(2)
label 1
      c_j :fail
label 2
      c_nop # FIXME: Jump to 0x000000008000033a --> No executable code at 0x000000008000033a
    end

    RVC_TEST_CASE( 35, ra, 0 ) do
      la t0, label_f(1)
      li ra, 0
      c_jr t0
      c_j label_f(2)
label 1
      c_j label_f(1)
label 2
      j :fail
label 1
      c_nop # FIXME: Jump to 0x000000008000033a --> No executable code at 0x000000008000033a
    end

    RVC_TEST_CASE( 36, ra, -2 ) do
      la t0, label_f(1)
      li ra, 0
      c_jalr t0
      c_j label_f(2)
label 1
      c_j label_f(1)
label 2
      j :fail
label 1
      sub ra, ra, t0
    end

  if __riscv_xlen == 32
    RVC_TEST_CASE( 37, ra, -2) do
      la t0, label_f(1)
      li ra, 0
      c_jal label_f(1)
      c_j label_f(2)
label 1
      c_j label_f(1)
label 2
      j :fail
label 1
      sub ra, ra, t0
    end
  end

    la sp, :data
    RVC_TEST_CASE( 40, a2, 0xfffffffffedcba99 ) do
      c_lwsp a0, 12
      addi a0, a0, 1
      c_swsp a0, 12
      c_lwsp a2, 12
    end

  if __riscv_xlen == 64
    RVC_TEST_CASE( 41, a2, 0xfedcba9976543211 ) do
      c_ldsp a0, 8
      addi a0, a0, 1
      c_sdsp a0, 8
      c_ldsp a2, 8
    end
  end

    RVC_TEST_CASE( 42, t0, 0x246 ) do
      li a0, 0x123
      c_mv t0, a0
      c_add t0, a0
    end

    text '.option pop'
  end

  def post
    TEST_PASSFAIL()
    RVTEST_CODE_END()
  end

end
