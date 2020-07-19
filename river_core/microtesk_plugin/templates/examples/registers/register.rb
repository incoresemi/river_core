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
# This test template demonstrates how to specify registers used by instructions.
#
class RegistersTemplate < RiscVBaseTemplate

  def run
    # Registers can be specified by their names. For example:
    sequence {
      add x7, x5, x6
      sub x9, x7, x8
    }.run

    # Also, they can be accessed by their aliases. For example:
    sequence {
      add t2, t0, t1
      sub s1, t2, s0
    }.run

    # It is possible to specify them by their numbers. This is useful when it is required
    # to parametrise register numbers with specific data. For example:
    sequence {
      add x(7), x(5), x(6)
      sub x(9), x(7), x(8)
    }.run

    # Registers numbers can be specified as random values. In the example below, register
    # shared between the two instructions is specified using the 'r' variable.
    sequence {
      add r=x(rand(0, 31)), x(rand(0, 31)), x(rand(0, 31))
      sub x(rand(0, 31)), r, x(rand(0, 31))
    }.run

    # Registers can be selected automatically using a configurable set of register allocation
    # strategies. In the simplest case like the one below, it is very similar to random selection.
    # However, this feature allows solving more complex tasks which will be shown in
    # corresponding example test templates.
    sequence {
      add r=x(_), x(_), x(_)
      sub x(_), r, x(_)
    }.run
  end

end
