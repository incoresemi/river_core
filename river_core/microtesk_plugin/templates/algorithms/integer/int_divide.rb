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
# design under test. The described program calculates the quotient and
# the remainder of division of two random numbers by using
# the simple algorithm of repeated subtraction.
#
class IntDivideTemplate < RiscVBaseTemplate

  def run
    dividend = rand(0, 1023)
    divisor  = rand(1, 63) #zero is excluded

    addi s0, zero, dividend
    addi s1, zero, divisor

    trace "\nInput parameter values: dividend x8(s0) = %d, divisor x9(s1) = %d\n",
      XREG(8), XREG(9)

    add t0, zero, zero
    add t1, zero, s0

    label :cycle
    trace "\nCurrent register values: x5(t0) = %d, x6(t1) = %d, x7(t2) = %d\n",
      XREG(5), XREG(6), XREG(7)

    sub t2, t1, s1
    slt t3, t2, zero

    bne t3, zero, :done

    add t1, zero, t2
    addi t0, t0, 1

    j :cycle

    label :done
    trace "\nResult: quotient x5(t0) = %d, remainder x6(t1) = %d\n",
      XREG(5), XREG(6)
  end

end
