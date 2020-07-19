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
# This small tests for RV32A instructions.
#
class InstructionRV32A < RiscVBaseTemplate

  def run
    trace "Run RV32A instruction:"
    nop

    if is_rev('RV32A') then
      auipc s0, 0x80
      srli s0, s0, 12
      slli s0, s0, 12

      lr_w t0, s0
      sc_w t0, t1, s0

      amoswap_w t0, t1, s0
      amoadd_w t0, t1, s0
      amoand_w t0, t1, s0
      amoor_w t0, t1, s0
      amoxor_w t0, t1, s0
      amomin_w t0, t1, s0
      amomax_w t0, t1, s0
      amominu_w t0, t1, s0
      amomaxu_w t0, t1, s0
    else
      trace "Error: RV32A"
    end

    nop
    nop
  end

end
