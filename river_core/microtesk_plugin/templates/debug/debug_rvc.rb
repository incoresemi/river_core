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
# This small tests for Compressed Instructions.
#
class InstructionRVC < RiscVBaseTemplate

  def TEST_DATA
    data {
      label :data
      word rand(1, 9), rand(1, 9), rand(1, 9), rand(1, 9)
      label :end_data
      space 1
    }
  end

  def run
    trace "Compressed Instructions:"

    c_addi4spn s1c, 4

    la a3, :data
    if is_rev('RV64C') then
      c_fld fa2c, a3c, :data
      c_fsd fa2c, a3c, :data
    else
      c_flw fa2c, a3c, :data
      c_fsw fa2c, a3c, :data
    end

    c_sw a3c, a3c, :data
    if is_rev('RV64C') then
      c_sd a3c, a3c, :data
    end

    c_nop
    c_addi a0, 4
    if is_rev('RV64C') then
      c_addiw a0, 8
    end
    #c_addi16sp 4
    c_li a0, 8
    c_lui a0, 4

    c_srli a0c, 8
    c_srai a0c, 4

    la sp, :data
    c_lwsp a0, 0
    c_swsp a3, 0
    if is_rev('RV64C') then
      c_ldsp a0, 0
      c_sdsp a3, 0
    end

    la a3, :data
    c_lw a0c, a3c, :data
    if is_rev('RV64C') then
      c_ld a0c, a3c, :data
    end

    c_andi a0c, _

    c_add a0, a0

    c_or a0c, a0c
    c_xor a0c, a0c
    c_sub a0c, a0c
    c_and a0c, a0c
    if is_rev('RV64C') then
      c_addw a0c, a0c
      c_subw a0c, a0c
    end

    c_j :c_j_label
    c_nop
    label :c_j_label
    nop
    nop

    #c_jal 2
    c_nop
    label :c_jal_label
    nop
    nop

    c_beqz a0c, :c_beqz_label
    nop
    label :c_beqz_label
    nop

    c_bnez a0c, :c_bnez_label
    nop
    label :c_bnez_label
    nop

    la a5, :c_jr_label
    c_jr a5
    nop
    label :c_jr_label
    nop

    la a5, :c_jalr_label
    c_jalr a5
    nop
    label :c_jalr_label
    nop

    c_slli a0, _

    la sp, :data
    #c_flwsp fa0, 4
    #c_fldsp fa0, 4

    c_mv a0, a0
    c_ebreak

    #c_fswsp fa2, 4
    #c_fsdsp fa2, 4

    nop
    nop
  end

end
