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
# This test checks JALR (jump and link register) instruction.
#
class InstructionJalrTemplate < RiscVBaseTemplate

  def run
    addi s1, zero, 1

    auipc s0, 0
    addi s0, s0, 8

    jalr t0, s0, 16

    addi s1, s1, 1
    addi s1, s1, 3
    addi s1, s1, 5

label :jalr_target
    addi s1, s1, 1
    addi s1, s1, 1

    addi s2, zero, 3
    bne s1, s2, :fail
    nop

    addi s0, s0, 4
    bne t0, s0, :fail
    nop
  end

end
