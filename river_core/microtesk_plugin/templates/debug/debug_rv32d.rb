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
# This small tests for RV32D instructions.
#
class InstructionRV32D < RiscVBaseTemplate

  def run
    trace "Run RV32D instruction:"
    nop

    if is_rev('RV32D') then
      auipc s0, 0x80
      srli s0, s0, 12
      slli s0, s0, 12

      fsd ft0, s0, 0x0
      fld ft0, s0, 0x0

      fadd_d ft0, ft1, ft2
      fsub_d ft0, ft1, ft2
      fmul_d ft0, ft1, ft2
      fdiv_d ft0, ft1, ft2

      fmin_d ft0, ft1, ft2
      fmax_d ft0, ft1, ft2
      fsqrt_d ft0, ft1

      fsgnj_d ft0, ft1, ft2
      fsgnjn_d ft0, ft1, ft2
      fsgnjx_d ft0, ft1, ft2

      fmadd_d ft0, ft1, ft2, ft3
      fmsub_d ft0, ft1, ft2, ft3
      fnmadd_d ft0, ft1, ft2, ft3
      fnmsub_d ft0, ft1, ft2, ft3

      fcvt_w_d2 t0, ft0
      fcvt_wu_d2 t0, ft0
      fcvt_d_w ft0, t0
      fcvt_d_wu ft0, t0

      fcvt_s_d ft0, ft1
      fcvt_d_s ft0, ft1

      feq_d t0, ft0, ft1
      flt_d t0, ft0, ft1
      fle_d t0, ft0, ft1

      fclass_d t0, ft0

      fmv_d ft0, ft1
      fabs_d ft0, ft1
      fneg_d ft0, ft1

      trace "Special:"
      addi t0, zero, 5
      addi t1, zero, 4
      fcvt_d_w ft0, t0
      fcvt_d_w ft1, t1
      fadd_d ft2, ft1, ft0
      trace "t2: x7 = %x", XREG(7)
      fcvt_w_d2 t2, ft2
      trace "ft2 = %x", fpr(2)
      trace "t2: x7 = %x", XREG(7)

      #fsw_global
      #flw_global
    else
      trace "Error: RV32D"
    end

    nop
    nop
  end

end
