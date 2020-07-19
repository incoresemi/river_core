#
# Copyright 2017-2019 ISP RAS (http://www.ispras.ru)
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
# This small tests for RV32I instructions.
#
class InstructionRV32I < RiscVBaseTemplate

  def run
    trace "RV32I instructions:"

    la s1, :jal_label
    trace "s1 = %x", XREG(9)

    nop

    lui t3, 8
    trace "t3 = %x", XREG(28)
    auipc t4, :jal_label
    trace "t4 = %x", XREG(29)
    nop
    # jal t5, 4
    nop
    j :j_label
    nop
    nop
    nop
    label :j_label
    nop
    jal t5, :jal_label
    nop
    label :jal_label
    nop
    lui s0, 0x40000
    slli s0, s0, 0x1
    addi s0, s0, :jalr_label

    trace "s0 = %x", XREG(8)
    jalr t0, s0, 0
    nop
    label :jalr_label
    nop
    beq t0, t1, :beq_label
    nop
    label :beq_label
    bne t0, t1, :bne_label
    nop
    label :bne_label
    blt t0, t1, :blt_label
    nop
    label :blt_label
    bge t0, t1, :bge_label
    nop
    label :bge_label
    bltu t0, t1, :bltu_label
    nop
    label :bltu_label
    bgeu t0, t1, :bgeu_label
    nop
    label :bgeu_label
    nop

    auipc s0, 0x80
    srli s0, s0, 12
    slli s0, s0, 12

    lb a0, s0, 0x0
    lh a0, s0, 0x0
    lw a0, s0, 0x0
    lbu a0, s0, 0x0
    lhu a0, s0, 0x0
    sb a0, s0, 0x0
    sh a0, s0, 0x0
    sw a0, s0, 0x0

    addi t0, t1, 0x17
    slti t0, t1, 0x17
    sltiu t0, t1, 0x17
    xori t0, t1, 0x17
    ori t0, t1, 0x11
    andi t0, t1, 0x15
    slli t0, t1, 0x1
    srli t0, t1, 0x3
    srai t0, t1, 0x7
    sll t0, t1, t2
    srl t0, t1, t2
    sra t0, t1, t2
    add t0, t1, t2
    sub t0, t1, t2
    slt t0, t1, t2
    sltu t0, t1, t2
    xor t0, t1, t2
    OR t0, t1, t2
    AND t0, t1, t2

    addi t0, t1, 15
    trace "(addi): x5 = %x", XREG(5)
    addi t1, t2, 7
    trace "(addi): x6 = %x", XREG(6)
    add t2, t1, t0
    trace "(add): x7 = %x", XREG(7)
    sub t2, t1, t0
    trace "(sub): x7 = %x", XREG(7)

    trace "System instructions:"

    # fence
    # fencei
    # ecall
    # ebreak

    csrrw t0, time, t1
    csrrs t0, time, t1
    csrrc t0, time, t1

    csrrwi t0, time, 0x1
    csrrsi t0, time, 0x2
    csrrci t0, time, 0x3

    trace "Pseudo instructions:"
    csrw time, t0
    csrr t0, time
    csrs time, t0
    csrc time, t0
    csrwi time, 0x5
    csrsi time, 0x5
    csrci time, 0x5
    frcsr t0

    #fscsr
    #fscsr2
    #frrm
    #fsrm
    #fsrm2
    #fsrmi
    #fsrmi2
    #frflags
    #fsflags
    #fsflags2
    #fsflagsi
    #fsflagsi2

    #lb_global
    #lh_global
    #lw_global

    #sb_global
    #sh_global
    #sw_global

    # call
    # tail
    # li

    nop
    nop
  end

end
