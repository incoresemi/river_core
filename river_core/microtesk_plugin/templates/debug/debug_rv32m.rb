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
# This small tests for RV32M instructions.
#
class InstructionRV32M < RiscVBaseTemplate

  def run
    trace "Run RV32M instruction:"
    nop

    if is_rev('RV32M') then
      mul t0, t1, t2
      mulh t0, t1, t2
      mulhsu t0, t1, t2
      mulhu t0, t1, t2
      div t0, t1, t2
      divu t0, t1, t2
      rem t0, t1, t2
      remu t0, t1, t2
    else
      trace "Error: RV32M"
    end

    nop
    nop
  end

end
