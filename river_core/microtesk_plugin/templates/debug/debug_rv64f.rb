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
# This small tests for RV64F instructions.
#
class InstructionRV64F < RiscVBaseTemplate

  def run
    trace "Run RV64F instruction:"
    nop

    if is_rev('RV64F') then
      fcvt_l_s t0, ft0, 0
      fcvt_lu_s t0, ft0, 0
      fcvt_s_l ft0, t0
      fcvt_s_lu ft0, t0
    else
      trace "Error: RV64F"
    end

    nop
  end

end
