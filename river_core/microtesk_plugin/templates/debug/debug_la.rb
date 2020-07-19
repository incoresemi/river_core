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

require_relative '../riscv_base'

#
# Description:
#
# This test checks LA (load address) pseudo instruction.
# The test makes sure that the loaded address is independent of the program counter and
# is always the same for the same label.
#
class InstructionLaTemplate < RiscVBaseTemplate
  COUNT = 20

  def TEST_DATA
    data {
      org 0x00010000
      label :data
      word 0x0, 0x0, 0x0, 0x0,
           0x0, 0x0, 0x0, 0x0
      label :end
      space 1
    }
  end

  def run
    address = get_address_of(:data)
    prepare s0, address

    trace "get_address_of(:data) = 0x#{address.to_s(16)}"
    trace "s0 = 0x%x", XREG(8)

    j :"label_#{1}"
    nop

    (1..COUNT).each { |index|
      org :delta => 0x180

      label :"label_#{index}"
      nop
      nop
      nop

      la s1, :data
      trace "s1 = 0x%x", XREG(9)

      beq s0, s1, :"label_#{index+1}"
      nop

      j :report_error
      nop
    }

    label :"label_#{COUNT+1}"
    j :finish

    label :report_error
    trace "Error: s0(0x%x) != s1(0x%x)", XREG(8), XREG(9)
    nop

    label :finish
    nop
  end

end
