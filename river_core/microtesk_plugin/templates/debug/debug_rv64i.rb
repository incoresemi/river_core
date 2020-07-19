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
# This small tests for RV64I instructions.
#
class InstructionRV64I < RiscVBaseTemplate

  def TEST_DATA
    data {
      label :data
      word rand(1, 9), rand(1, 9), rand(1, 9), rand(1, 9)
      label :end_data
      space 1
    }
  end

  def run
    trace "Run RV64I instruction:"
    nop

    if is_rev('RV64I') then
      la t1, :data

      lwu t0, t1, 0x0
      trace "t0 = %x", XREG(5)

      auipc s0, 0x80
      trace "s0 = %x", XREG(8)
      srli s0, s0, 12
      slli s0, s0, 12
      srai t0, s0, 12

      ld t2, s0, 0x0
      sd t4, s0, 0x0

      addiw a0, a1, 0x11
      slliw t0, a1, 0x11
      srliw t1, a1, 0x11
      sraiw t2, a1, 0x11

      addw t1, t2, t3
      subw t2, t3, t4

      sllw t0, t1, t2
      srlw t0, t1, t2
      sraw t0, t1, t2
    else
      trace "Error: RV64I"
    end

    nop
  end

end
