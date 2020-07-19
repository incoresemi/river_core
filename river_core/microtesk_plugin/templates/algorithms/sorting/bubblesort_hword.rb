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
# design under test. The described test program is a simple implemention of
# the bubble sort algorithm. The algorithm in pseudocode (from Wikipedia):
#
# procedure bubbleSort( A : list of sortable items )
#   n = length(A)
#   repeat
#     swapped = false
#     for i = 1 to n-1 inclusive do
#       /* if this pair is out of order */
#       if A[i-1] > A[i] then
#         /* swap them and remember something changed */
#         swap( A[i-1], A[i] )
#         swapped = true
#       end if
#     end for
#   until not swapped
# end procedure
#
class BubbleSortHWordTemplate < RiscVBaseTemplate

  def TEST_DATA
    data {
      label :data
      half rand(1, 9), rand(1, 9), rand(1, 9), rand(1, 9)
      half rand(1, 9), rand(1, 9), rand(1, 9), rand(1, 9)
      half rand(1, 9), rand(1, 9), rand(1, 9), rand(1, 9)
      label :end
      space 1
    }
  end

  def run
    trace_data :data, :end

    la s0, :data
    trace "s0 = %x", XREG(8)

    la s1, :end
    trace "s0 = %x", XREG(9)

    addi a0, zero, 2

    ########################### Outer loop starts ##############################
    label :repeat
    Or t0, zero, zero

    addi t1, s0, 2
    ########################### Inner loop starts ##############################
    label :for
    beq t1, s1, :exit_for
    sub t2, t1, a0 # a0 = 2;

    lh t4, t1, 0
    lh t5, t2, 0

    slt t6, t4, t5
    beq t6, zero, :next

    addi t0, zero, 0xf # t0 != 0

    sh t4, t2, 0
    sh t5, t1, 0

    label :next
    addi t1, t1, 2
    j :for
    ############################ Inner loop ends ###############################
    label :exit_for

    bne t0, zero, :repeat
    ############################ Outer loop ends ###############################

    trace_data :data, :end
  end

end
