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
# This test template demonstrates how to randomly allocate registers so
# that they do not conflict with other registers used in the test case.
#
class RegisterAllocationTemplate < RiscVBaseTemplate

  def run
    # Destination of all instructions is a random register that
    # is not used in this sequence.
    sequence {
      # Randomly selects destination registers from free registers
      add reg1=x(_ FREE), t0, t1
      sub reg2=x(_ FREE), t2, t3
      slt reg3=x(_ FREE), t4, t5
      newline

      # Frees the previously allocated registers
      set_free reg1, true
      set_free reg2, true
      set_free reg3, true

      # Randomly selects destination registers from free registers including
      # those that were previously freed
      And x(_ FREE), s0, s1
      Or  x(_ FREE), s2, s3
      Xor x(_ FREE), s4, s5
      newline
    }.run 5
  end

end
