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
# This test template demonstrates how to generate randomized test cases
# by using biased values, intervals, arrays and distributions.
#
class RandomTemplate < RiscVBaseTemplate

  def run
    # Predefined probability distribution.
    int_dist = dist(range(:value => 0,                                      :bias => 25), # Zero
                    range(:value => 1..2,                                   :bias => 25), # Small
                    range(:value => 0x00000000ffffFFFE..0x00000000ffffFFFF, :bias => 50)) # Large

    sequence {
      # ADD instruction with random operands and biased operand values.
      add(x(_ FREE), x(_ FREE), x(_ FREE)) do situation('random_biased',
        :dist => dist(range(:value=> int_dist,                :bias => 80),  # Simple
                      range(:value=> [0xDEADBEEF, 0xBADF00D], :bias => 20))) # Magic
      end
      # NOP instruction is used as a location to return from en exception
      nop
    }.run 1000
  end

end
