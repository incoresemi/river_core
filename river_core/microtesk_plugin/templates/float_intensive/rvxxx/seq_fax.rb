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

module SeqFax

  def seq_fax
    pick_random {
     
      # Intra-FPU Instructions
      seq_fax_src1('FCVT_S_D', :fregs_s, :fregs_d)
      seq_fax_src1('FCVT_D_S', :fregs_d, :fregs_s)

      ['FSGNJ_S', 'FSGNJN_S', 'FSGNJX_S'].each { |op|
        seq_fax_src2(op, :fregs_s, :fregs_s)
      }

      ['FSGNJ_D', 'FSGNJN_D', 'FSGNJX_D'].each { |op|
        seq_fax_src2(op, :fregs_d, :fregs_d)
      }

      # X<->F Instructions
      ['FCVT_S_L', 'FCVT_S_LU', 'FCVT_S_W', 'FCVT_S_WU', 'FMV_W_X'].each { |op|
        seq_fax_src1(op, :fregs_s, :xregs)
      }

      ['FCVT_D_L', 'FCVT_D_LU', 'FCVT_D_W', 'FCVT_D_WU', 'FMV_D_X'].each { |op|
        seq_fax_src1(op, :fregs_d, :xregs)
      }

      ['FCVT_L_S2', 'FCVT_LU_S2', 'FCVT_W_S2', 'FCVT_WU_S2', 'FMV_X_W'].each { |op|
        seq_fax_src1(op, :xregs, :fregs_s)
      }

      ['FCVT_L_D2', 'FCVT_LU_D2', 'FCVT_W_D2', 'FCVT_WU_D2', 'FMV_X_D'].each { |op|
        seq_fax_src1(op, :xregs, :fregs_d)
      }

      ['FEQ_S', 'FLT_S', 'FLE_S'].each { |op|
        seq_fax_src2(op, :xregs, :fregs_s)
      }

      ['FEQ_D', 'FLT_D', 'FLE_D'].each { |op|
        seq_fax_src2(op, :xregs, :fregs_d)
      }
    }
  end

  private

  def seq_set_rounding_mode()
    li r=x(_), rand(0,4)
    fsrm x(_), r
  end

  def seq_read_fcsr()
    frcsr x(_)
  end

  def instr(op, *args)
    self.send :"#{op}", args
  end

  def seq_fax_src1(op, dst_pool, src_pool)
    src1 = reg_read_any(src_pool)
    dest = reg_write(dst_pool, src1)
    instr op, dest, src1
  end

  def seq_fax_src2(op, dst_pool, src_pool)
    src1 = reg_read_any(src_pool)
    src2 = reg_read_any(src_pool)
    dest = reg_write(dst_pool, src1, src2)
    instr op, dest, src1, src2
  end

end
