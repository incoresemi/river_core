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
# This test template demonstrates how to use the 'atomic' construct that which describes
# atomic instruction sequences.
#
class AtomicTemplate < RiscVBaseTemplate

  def initialize
    super

    # Makes randomization more "interesting".
    set_option_value 'random-seed', 13
  end

  def run
    # The 'atomic' block describes an atomic instruction sequence. It is very similar to
    # the 'sequence' block. The important difference is that order of instructions in an atomic
    # sequence is always preserved when it is mixed with other instruction sequences.
    # That is, its instructions are never interleave with instructions from other sequences.

    # In this example, the 'sequence' block is used causing sequences to be randomly shuffled.
    block(:combinator => 'diagonal', :compositor => 'random', :permutator => 'random') {
      sequence {
        add  x(_), x(_), x(_)
        sub  x(_), x(_), x(_)
        addi x(_), x(_), _
      }

      sequence {
        And  x(_), x(_), x(_)
        Or   x(_), x(_), x(_)
        Xor  x(_), x(_), x(_)
      }

      sequence {
        andi x(_), x(_), _
        ori  x(_), x(_), _
        xori x(_), x(_), _
      }
    }.run

    # The example below uses atomic sequences that do not mix with each other.
    block(:combinator => 'diagonal', :compositor => 'random', :permutator => 'random') {
      atomic {
        add  x(_), x(_), x(_)
        sub  x(_), x(_), x(_)
        addi x(_), x(_), _
      }

      atomic {
        And  x(_), x(_), x(_)
        Or   x(_), x(_), x(_)
        Xor  x(_), x(_), x(_)
      }

      atomic {
        andi x(_), x(_), _
        ori  x(_), x(_), _
        xori x(_), x(_), _
      }
    }.run

    # Instructions in atomic sequences can be shuffled, but they still will not mix with
    # instructions from other sequences.
    block(:combinator => 'diagonal', :compositor => 'random', :permutator => 'random') {
      atomic(:obfuscator => 'random') {
        add  x(_), x(_), x(_)
        sub  x(_), x(_), x(_)
        addi x(_), x(_), _
      }

      atomic(:obfuscator => 'random') {
        And  x(_), x(_), x(_)
        Or   x(_), x(_), x(_)
        Xor  x(_), x(_), x(_)
      }

      atomic(:obfuscator => 'random') {
        andi x(_), x(_), _
        ori  x(_), x(_), _
        xori x(_), x(_), _
      }
    }.run
  end

end
