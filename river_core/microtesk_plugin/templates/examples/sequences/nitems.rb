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
# This test template demonstrates how to construct instruction sequences
# by repeating and mixing smaller sequences.
#
class NitemsTemplate < RiscVBaseTemplate

  def run
    # Sequence construction scheme:
    # 1. The sequences produced by the nested block are expanded into a single sequence.
    # 2. The instructions in the resulting sequence are randomly shuffled.
    # 3. Steps 1 and 2 are repeated 10 times to produce 10 sequences.
    block(:rearranger => 'expand', :obfuscator => 'random', :nitems => 10) {
      # The sequence described by the block is repeated 5 times.
      sequence(:nitems => 5) {
        add  r1=x(_), x(_), x(_)
        sub  x(_), r1, x(_)
        OR   x(_), x(_), r1
        XOR  x(_), x(_), r1
        ori  x(_), r1, _
        xori r1, x(_), _
      }
    }.run
  end

end
