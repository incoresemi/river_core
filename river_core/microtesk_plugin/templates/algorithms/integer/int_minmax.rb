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

require_relative '../../riscv_base'

#
# Description:
#
# This test template demonstrates how to work with data declaration constucts.
# The generated program finds minimum and maximum in a 5-element array
# storing random numbers from 0 to 31.
#
class IntMinMaxTemplate < RiscVBaseTemplate

  def TEST_DATA
    data {
      org 0x0
      align 8
      label :data
      word rand(0, 127), rand(0, 127), rand(0, 127), rand(0, 127), rand(0, 127), rand(0, 127)
      word rand(0, 127), rand(0, 127), rand(0, 127), rand(0, 127), rand(0, 127), rand(0, 127)
      word rand(0, 127), rand(0, 127), rand(0, 127), rand(0, 127)
      label :end
      space 1
    }
  end

  def run
    la t0, :data
    la t1, :end

    lw t2, t0, 0
    Or s0, zero, t2
    Or s1, zero, t2

    label :cycle
    addi t0, t0, 4

    beq t0, t1, :done
    lw t2, t0, 0

    slt t3, t2, s0
    beq t3, zero, :test_max
    Or s0, zero, t2

    label :test_max
    slt t4, s1, t2
    beq t4, zero, :cycle
    Or s1, zero, t2

    j :cycle

    label :done
    trace "\nmin(r16)=0x%x, max(r17)=0x%x", XREG(8), XREG(9)
  end

end
