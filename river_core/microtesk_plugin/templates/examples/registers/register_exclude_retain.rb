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

require_relative '../../riscv_base'

#
# Description:
#
# This test template demonstrates how registers can be automatically selected from
# the specified ranges.
#
class RegistersExcludeRetainTemplate < RiscVBaseTemplate

  def run
    # Uses randomly selected free registers excluding:
    # zero, ra, sp, gp, tp, t4, t5, and t6.
    sequence {
      regs = [zero, ra, sp, gp, tp, t4, t5, t6]
      comment 'Excluded registers: [zero, ra, sp, gp, tp, t4, t5, t6]'

      add x(_ FREE, :exclude => regs), x(_ FREE, :exclude => regs), x(_ FREE, :exclude => regs)
      sub x(_ FREE, :exclude => regs), x(_ FREE, :exclude => regs), x(_ FREE, :exclude => regs)
      slt x(_ FREE, :exclude => regs), x(_ FREE, :exclude => regs), x(_ FREE, :exclude => regs)
    }.run 3

    # Uses randomly selected registers from the following set:
    # s0, s1, a0, a1, a2, a3, a4, and a5.
    sequence {
      regs = [s0, s1, a0, a1, a2, a3, a4, a5]
      comment 'Retained registers: [s0, s1, a0, a1, a2, a3, a4, a5]'

      add x(_ RANDOM, :retain => regs), x(_ RANDOM, :retain => regs), x(_ RANDOM, :retain => regs)
      sub x(_ RANDOM, :retain => regs), x(_ RANDOM, :retain => regs), x(_ RANDOM, :retain => regs)
      slt x(_ RANDOM, :retain => regs), x(_ RANDOM, :retain => regs), x(_ RANDOM, :retain => regs)
    }.run 3
  end

end
