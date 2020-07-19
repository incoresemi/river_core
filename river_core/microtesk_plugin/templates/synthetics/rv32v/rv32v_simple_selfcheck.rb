#
# Copyright 2019 ISP RAS (http://www.ispras.ru)
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

require_relative '../../riscv_base'

#
# Description:
#
# This small tests for RV32V instructions.
#
class InstructionRV32VGEN1 < RiscVBaseTemplate
  def initialize
    super
    # Enables marking all explicitly specified registers as used
    set_option_value 'reserve-explicit', false
  end

  def TEST_DATA
    data {
      label :data
      word rand(-2147483648, 2147483647), rand(-2147483648, 2147483647)
      word rand(-2147483648, 2147483647), rand(-2147483648, 2147483647)
      word rand(-2147483648, 2147483647), rand(-2147483648, 2147483647)
      word rand(-2147483648, 2147483647), rand(-2147483648, 2147483647)
      word rand(-2147483648, 2147483647), rand(-2147483648, 2147483647)
      word rand(-2147483648, 2147483647), rand(-2147483648, 2147483647)
      word rand(-2147483648, 2147483647), rand(-2147483648, 2147483647)
      word rand(-2147483648, 2147483647), rand(-2147483648, 2147483647)
      word rand(-2147483648, 2147483647), rand(-2147483648, 2147483647)
      word rand(-2147483648, 2147483647), rand(-2147483648, 2147483647)
      word rand(-2147483648, 2147483647), rand(-2147483648, 2147483647)
      word rand(-2147483648, 2147483647), rand(-2147483648, 2147483647)
      word rand(-2147483648, 2147483647), rand(-2147483648, 2147483647)
      word rand(-2147483648, 2147483647), rand(-2147483648, 2147483647)
      word rand(-2147483648, 2147483647), rand(-2147483648, 2147483647)
      word rand(-2147483648, 2147483647), rand(-2147483648, 2147483647)
      label :end
      space 1
    }
  end

  def run
    trace "RV32V instructions:"
    # sz
    e32 = 0b010 # standard element width = 32
    m4 = 0b10 # the number of vector registers in a group = 4

    if is_rev('RV32V') then
      trace "Init CSR registers:"
      addi a0, zero, 0b100000
      vsetvli t0, a0, e32, m4

      #vadd vr(_), vr(_), vr(_)

      trace "Test gen1:"
      # 'vadd', 'vmul', 'vsub', 'vmulh', 'vdiv'
      xxx_dist = dist(range(:value => ['vadd', 'vmul', 'vsub', 'vdiv', 'vmulh'], :bias => 100))
      define_op_group('xxx', xxx_dist)

      cycle_for_times = 0
      10.times {
        atomic {
          la t1, :data
          for i in 0..7
            vlw vr(i*4), t1
            j = i*4;
            for j1 in 0..3
              trace "v%x = %x", j + j1, VREG(j + j1)
            end
            addi t1, t1, 4*4
          end

          # Placeholder to return from an exception
          epilogue { nop }
          trace "10 vector instructions block: %d cycle", cycle_for_times
          # Selects an instruction according to the 'xxx_dist' distribution
          10.times {
            xxx vr(_), vr(_), vr(_)
          }

          la t1, :end
          for i in 0..7
            vsw vr(i*4), t1
            j = i*4;
            for j1 in 0..3
              trace "v%x = %x", j + j1, VREG(j + j1)
            end
            addi t1, t1, 4*4
          end
          cycle_for_times = cycle_for_times + 1
        }.run

        for j in 0..3
        atomic {
          la t1, :end
          addi t1, t1, j*32
          for i in 10..17
            lw x(i), t1, 4*(i-10)
          end
        }.run
        end
      }
    end
  end

end
