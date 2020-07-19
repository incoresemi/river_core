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
# This test template demonstrates how MicroTESK creates self-checking test programs.
#
class SelfCheckTemplate < RiscVBaseTemplate

  def initialize
    super
    set_option_value 'self-checks', true
  end

  def run
    sequence {
      temp_value_0 = rand(0x0000000, 0x7FFFffff)
      temp_value_1 = rand(0x0000000, 0x7FFFffff)

      prepare t1, temp_value_0
      prepare t2, temp_value_1

      add t3, t1, t2
      trace "\n$t3($28) = $t1($6) + $t2($7) -> %d = %d + %d",
            XREG(28), XREG(6), XREG(7)
    }.run
  end

end
