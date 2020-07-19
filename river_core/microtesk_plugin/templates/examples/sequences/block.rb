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
# This test template demonstrates how to use instruction blocks.
#
class BlockTemplate < RiscVBaseTemplate

  def run
    # Adds nop to all test cases as a placeholder to return from an exception
    epilogue { nop }

    # Produces a single test case that consists of three instructions
    sequence {
      Add t0, t1, t2
      Sub t3, t4, t5
      And x(_), x(_), x(_)
    }.run

    # Atomic sequence. Works as sequence in this context.
    atomic {
      Add t0, t1, t2
      Sub t3, t4, t5
      And x(_), x(_), x(_)
    }.run

    # Produces three test cases each consisting of one instruction
    iterate {
      Add t0, t1, t2
      Sub t3, t4, t5
      And x(_), x(_), x(_)
    }.run

    # Produces four test cases consisting of two instructions
    # (Cartesian product composed in a random order)
    block(:combinator => 'product', :compositor => 'random') {
      iterate {
        Add t0, t1, t2
        Sub t3, t4, t5
      }

      iterate {
        And x(_), x(_), x(_)
        nop
      }
    }.run

    # Merges two sequences in random fashion. Atomic sequences are unmodifiable.
    block(:combinator => 'diagonal', :compositor => 'random', :obfuscator => 'random') {
      sequence {
        Add t0, t1, t2
        Sub t3, t4, t5
        Or  s3, s4, s5
      }

      atomic {
        prologue { comment 'Atomic starts' }
        epilogue { comment 'Atomic ends' }

        And x(_), x(_), x(_)
        nop
      }
    }.run
  end

end
