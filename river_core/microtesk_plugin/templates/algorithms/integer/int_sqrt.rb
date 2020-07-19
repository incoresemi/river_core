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
# This test template demonstrates how MicroTESK can simulate the execution
# of a test program to predict the resulting state of a microprocessor
# design under test. The described program calculates the integer square root
# a positive integer.
#
class IntSqrtTemplate < RiscVBaseTemplate

  def run
    addi s0, zero, rand(0, 1023)
    trace "\nInput parameter value: x8(s0) = %d\n", XREG(8)

    add  t0, zero, s0
    addi t1, zero, 1

    add  t2, zero, zero
    addi t3, zero, 1

    label :cycle
    trace "\nCurrent register values: x5(t0) = %d, x6(t1) = %d, x7(t2) = %d\n",
      XREG(5), XREG(6), XREG(7)

    slt t4, zero, t0
    beq t4, zero, :done

    sub  t0, t0, t1
    addi t1, t1, 2

    slt t4, t0, zero
    sub t5, t3, t4
    add t2, t2, t5

    j :cycle

    label :done
    trace "\nInteger square root of %d: %d", XREG(8), XREG(7)
  end

end
