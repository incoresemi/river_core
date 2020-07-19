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
# This small tests for RV64M instructions.
#
class InstructionRV64M < RiscVBaseTemplate

  def run
    trace "Run 64M instruction:"
    nop

    if is_rev('RV64M') then
      mulw t0, t1, t2
      divw t0, t1, t2
      divuw t0, t1, t2
      remw t0, t1, t2
      remuw t0, t1, t2
    else
      trace "Error: RV64M"
    end

    nop
    nop
  end

end
