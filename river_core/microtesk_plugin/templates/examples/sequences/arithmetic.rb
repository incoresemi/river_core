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
# This test template demonstrates how to generate instruction sequences
# by using combinators and compositors.
#
class ArithmeticTemplate < RiscVBaseTemplate

  def run
    # :combinator => 'product': all possible combinations of the inner blocks' instructions.
    # :compositor => 'random' : random composition (merging) of the combined instructions.
    block(:combinator => 'product', :compositor => 'random') {
      iterate {
        xor x(_), x(_), x(_)
        ori x(_), x(_), _
      }

      iterate {
        AND   x(_), x(_), x(_)
        OR    x(_), x(_), x(_)
      }

      iterate {
        auipc   x(_), _
      }
    }.run
  end

end
