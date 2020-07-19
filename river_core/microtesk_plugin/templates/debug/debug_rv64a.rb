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
# This small tests for RV64A instructions.
#
class InstructionRV64A < RiscVBaseTemplate

  def run
    trace "Run RV64A instruction:"
    nop

    if is_rev('RV64A') then
      auipc s0, 0x80
      srli s0, s0, 12
      slli s0, s0, 12

      lr_d t0, s0
      sc_d t0, t1, s0

      amoswap_d t0, t1, s0
      amoadd_d t0, t1, s0
      amoand_d t0, t1, s0
      amoor_d t0, t1, s0
      amoxor_d t0, t1, s0
      amomin_d t0, t1, s0
      amomax_d t0, t1, s0
      amominu_d t0, t1, s0
      amomaxu_d t0, t1, s0
    else
      trace "Error: RV64A"
    end

    nop
  end

end
