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
# This test template demonstrates how to use the 'sequence' construct that which describes
# trivial instruction sequences.
#
class SequenceTemplate < RiscVBaseTemplate

  def run
    # The 'sequence' block describes a trivial (plain) instruction sequence.
    # In the example below, the instructions use random registers and random values.
    sequence {
      add  x(_), x(_), x(_)
      sub  x(_), x(_), x(_)
      And  x(_), x(_), x(_)
      Or   x(_), x(_), x(_)
      Xor  x(_), x(_), x(_)
      addi x(_), x(_), _
      xori x(_), x(_), _
      ori  x(_), x(_), _
      andi x(_), x(_), _
    }.run

    # It is possible to generate multiple sequences from the same description.
    # This can be done by passing the number of sequences to the 'run' method.
    # In this case, registers and input values will be selected individually for each sequence.
    sequence {
      add  x(_), x(_), x(_)
      sub  x(_), x(_), x(_)
      And  x(_), x(_), x(_)
      Or   x(_), x(_), x(_)
      Xor  x(_), x(_), x(_)
      addi x(_), x(_), _
      xori x(_), x(_), _
      ori  x(_), x(_), _
      andi x(_), x(_), _
    }.run 3 # Gives 3 similar sequences.

    # A sequence can be shuffled to make instruction appear in a random order.
    # This can be done by using a component called 'obfuscator'.
    # To apply it, a corresponding attribute needs to be specified.
    # When multiple sequences are generated, randomization is applied individually
    # to each of the sequences.
    sequence(:obfuscator => 'random') {
      add  x(_), x(_), x(_)
      sub  x(_), x(_), x(_)
      And  x(_), x(_), x(_)
      Or   x(_), x(_), x(_)
      Xor  x(_), x(_), x(_)
      addi x(_), x(_), _
      xori x(_), x(_), _
      ori  x(_), x(_), _
      andi x(_), x(_), _
    }.run 3
  end

end
