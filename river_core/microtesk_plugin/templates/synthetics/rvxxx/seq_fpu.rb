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

module SeqFpu

  def seq_fpu
    pick_random {
      ['FADD_S', 'FSUB_S', 'FMUL_S', 'FMIN_S', 'FMAX_S'].each { |op|
        seq_fpu_src2_s(op)
      }

      ['FADD_D', 'FSUB_D', 'FMUL_D', 'FMIN_D', 'FMAX_D'].each { |op|
        seq_fpu_src2_d(op)
      }

      ['FMADD_S', 'FNMADD_S', 'FMSUB_S', 'FNMSUB_S'].each { |op|
        seq_fpu_src3_s(op)
      }

      ['FMADD_D', 'FNMADD_D', 'FMSUB_D', 'FNMSUB_D'].each { |op|
        seq_fpu_src3_d(op)
      }
    }
  end

  private

  def instr(op, *args)
    self.send :"#{op}", args
  end

  def seq_fpu_src1_s(op)
    src1 = reg_read_any(:fregs_s)
    dest = reg_write(:fregs_s, src1)

    instr op, dest, src1
  end

  def seq_fpu_src2_s(op)
    src1 = reg_read_any(:fregs_s)
    src2 = reg_read_any(:fregs_s)
    dest = reg_write(:fregs_s, src1, src2)

    instr op, dest, src1, src2
  end

  def seq_fpu_src3_s(op)
    src1 = reg_read_any(:fregs_s)
    src2 = reg_read_any(:fregs_s)
    src3 = reg_read_any(:fregs_s)
    dest = reg_write(:fregs_s, src1, src2, src3)

    instr op, dest, src1, src2, src3
  end

  def seq_fpu_src1_d(op)
    src1 = reg_read_any(:fregs_d)
    dest = reg_write(:fregs_d, src1)

    instr op, dest, src1
  end

  def seq_fpu_src2_d(op)
    src1 = reg_read_any(:fregs_d)
    src2 = reg_read_any(:fregs_d)
    dest = reg_write(:fregs_d, src1, src2)

    instr op, dest, src1, src2
  end

  def seq_fpu_src3_d(op)
    src1 = reg_read_any(:fregs_d)
    src2 = reg_read_any(:fregs_d)
    src3 = reg_read_any(:fregs_d)
    dest = reg_write(:fregs_d, src1, src2, src3)

    instr op, dest, src1, src2, src3
  end

end
