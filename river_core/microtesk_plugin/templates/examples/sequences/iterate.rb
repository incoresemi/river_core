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
# This test template demonstrates how to use the 'iterate' construct that produces instruction
# sequences by iterating over elements it contains.
#
class IterateTemplate < RiscVBaseTemplate

  def run
    # The 'iterate' block produces a series of sequences by iterating over nested elements.
    # In the example below, the block produces sequences arch containing of a single instructions.
    iterate {
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

    # Iterated elements can be represented by instruction sequences. For example:
    iterate {
      sequence {
        add  x(_), x(_), x(_)
        sub  x(_), x(_), x(_)
        And  x(_), x(_), x(_)
      }
      sequence {
        Or   x(_), x(_), x(_)
        Xor  x(_), x(_), x(_)
        addi x(_), x(_), _
      }
      sequence {
        xori x(_), x(_), _
        ori  x(_), x(_), _
        andi x(_), x(_), _
      }
    }.run

    # It is possible to shuffle the returned instruction sequences.
    # This can be done to apply the 'obfuscator' component:
    iterate(:obfuscator => 'random') {
      sequence {
        add  x(_), x(_), x(_)
        sub  x(_), x(_), x(_)
        And  x(_), x(_), x(_)
      }
      sequence {
        Or   x(_), x(_), x(_)
        Xor  x(_), x(_), x(_)
        addi x(_), x(_), _
      }
      sequence {
        xori x(_), x(_), _
        ori  x(_), x(_), _
        andi x(_), x(_), _
      }
    }.run

    # Blocks 'iterate' can be nested. In such cases, the external block iterated over
    # sequences returned by nested blocks. When a nested block is exhausted, the next
    # nested block is picked up.
    iterate {
      iterate {
        add  x(_), x(_), x(_)
        sub  x(_), x(_), x(_)
        And  x(_), x(_), x(_)
      }
      iterate {
        Or   x(_), x(_), x(_)
        Xor  x(_), x(_), x(_)
        addi x(_), x(_), _
      }
      iterate {
        xori x(_), x(_), _
        ori  x(_), x(_), _
        andi x(_), x(_), _
      }
    }.run
  end

end
