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
# This small tests for RV32F instructions.
#
class InstructionRV32F < RiscVBaseTemplate

  def run
    trace "Run RV32F instruction:"
    nop

    if is_rev('RV32F') then
      auipc s0, 0x80
      srli s0, s0, 12
      slli s0, s0, 12

      fsw ft0, s0, 0x0
      flw ft0, s0, 0x0

      fadd_s ft0, ft1, ft2
      fsub_s ft0, ft1, ft2
      fmul_s ft0, ft1, ft2
      fdiv_s ft0, ft1, ft2

      fmin_s ft0, ft1, ft2
      fmax_s ft0, ft1, ft2
      fsqrt_s ft0, ft1

      fsgnj_s ft0, ft1, ft2
      fsgnjn_s ft0, ft1, ft2
      fsgnjx_s ft0, ft1, ft2

      fmadd_s ft0, ft1, ft2, ft3
      fmsub_s ft0, ft1, ft2, ft3
      fnmadd_s ft0, ft1, ft2, ft3
      fnmsub_s ft0, ft1, ft2, ft3

      fcvt_w_s t0, ft0, 0
      fcvt_wu_s t0, ft0, 0
      fcvt_s_w ft0, t0
      fcvt_s_wu ft0, t0

     # fmv_x_w t0, ft0
     # fmv_w_x ft0, t0

      feq_s t0, ft0, ft1
      flt_s t0, ft0, ft1
      fle_s t0, ft0, ft1

      fclass_s t0, ft0

      fmv_s ft0, ft1
      fabs_s ft0, ft1
      fneg_s ft0, ft1

      trace "Special:"
      addi t0, zero, 5
      addi t1, zero, 4
      fcvt_s_w ft0, t0
      fcvt_s_w ft1, t1
      fadd_s ft2, ft1, ft0
      trace "t2: x7 = %x", XREG(7)
      fcvt_w_s t2, ft2, 0
      trace "ft2 = %x", fpr(2)
      trace "t2: x7 = %x", XREG(7)

      #fsw_global
      #flw_global
    else
      trace "Error: RV32F"
    end

    nop
    nop
  end

end
