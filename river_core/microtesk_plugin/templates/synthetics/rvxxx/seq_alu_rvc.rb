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

module SeqAluRvc

  def seq_alu_rvc

    pick_random {
      seq_alu_rvc_li()
      seq_alu_rvc_lui()

      seq_alu_rvc_addi4spn()
      seq_alu_rvc_addi16sp()

      seq_alu_rvc_immfn('C_ADDI',  rand_range(0, 63))
      seq_alu_rvc_immfn('C_ADDIW', rand_range(0, 63))
      seq_alu_rvc_immfn('C_SLLI',  rand_shift_imm)

      seq_alu_rvc_immfn_c('C_SRLI', rand_shift_imm)
      seq_alu_rvc_immfn_c('C_SRAI', rand_shift_imm)
      seq_alu_rvc_immfn_c('C_ANDI', rand_range(0, 63))

      ['C_MV', 'C_ADD'].each { |op|
        seq_alu_rvc_src(op)
        seq_alu_rvc_src_zero(op)
      }

      ['C_AND', 'C_OR', 'C_XOR', 'C_SUB', 'C_ADDW', 'C_SUBW'].each { |op|
        seq_alu_rvc_src_c(op)
        seq_alu_rvc_src_zero_c(op)
      }
    }
  end

  private

  def rand_shift_imm
    is_rev('RV64C') ? rand_range(1, 63) : rand_range(1, 31)
  end

  def instr(op, *args)
    self.send :"#{op}", args
  end

  def seq_alu_rvc_li
    atomic {
      c_li reg_write_visible(:xregs, :exclude => [zero]), rand_range(0, 63)
      c_nop # FIXME: C_NOP is for 32-bit alignment
    }
  end

  def seq_alu_rvc_lui
    atomic {
      # Positive immediate
      c_lui reg_write_visible(:xregs, :exclude => [zero, sp]), rand_range(1, 31)
      # Negative immediate
      c_lui reg_write_visible(:xregs, :exclude => [zero, sp]), _OR(0xFFFE0, rand_range(0, 31))
    }
  end

  def seq_alu_rvc_addi4spn
    atomic {
      c_addi4spn to_cx(reg_write_hidden(:xregs_c)), _SLL(rand_range(1, 255), 2)
      c_nop # FIXME: C_NOP is for 32-bit alignment
    }
  end

  def seq_alu_rvc_addi16sp()
    atomic {
      c_addi16sp _SLL(rand_range(1, 63), 4)
      c_nop # FIXME: C_NOP is for 32-bit alignment
    }
  end

  def seq_alu_rvc_immfn(op, imm)
    src = reg_read_any(:xregs)
    dest = reg_write(:xregs, {:exclude => [zero]}, src)

    atomic {
      instr op, dest, imm
      c_nop # FIXME: C_NOP is for 32-bit alignment
    }
  end

  def seq_alu_rvc_immfn_c(op, imm)
    src = reg_read_any(:xregs_c)
    dest = reg_write(:xregs_c, src)

    atomic {
      instr op, to_cx(dest), imm
      c_nop # FIXME: C_NOP is for 32-bit alignment
    }
  end

  def seq_alu_rvc_src(op)
    src = reg_read_any(:xregs)
    dest = reg_write(:xregs, {:exclude => [zero]}, src)

    atomic {
      instr op, dest, src
      c_nop # FIXME: C_NOP is for 32-bit alignment
    }
  end

  def seq_alu_rvc_src_zero(op)
    src = reg_read_any(:xregs)
    dest = reg_write(:xregs, {:exclude => [zero]}, src)
    tmp = reg_write_visible(:xregs)

    atomic {
      addi tmp, reg_read_zero(:xregs), rand_imm
      instr op, dest, tmp
      c_nop # FIXME: C_NOP is for 32-bit alignment
    }
  end

  def seq_alu_rvc_src_c(op)
    src = reg_read_any(:xregs_c)
    dest = reg_write(:xregs_c, src)

    atomic {
      instr op, to_cx(dest), to_cx(src)
      c_nop # FIXME: C_NOP is for 32-bit alignment
    }
  end

  def seq_alu_rvc_src_zero_c(op)
    src = reg_read_any(:xregs_c)
    dest = reg_write(:xregs_c, src)
    tmp = reg_write_visible(:xregs_c)

    atomic {
      addi tmp, reg_read_zero(:xregs), rand_imm
      instr op, to_cx(dest), to_cx(tmp)
      c_nop # FIXME: C_NOP is for 32-bit alignment
    }
  end

end
