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
# This test template demonstrates how to use instruction groups in test templates.
#
class GroupTemplate < RiscVBaseTemplate

  def run
    # Using groups defined in the specification

    10.times {
      sequence {
        # Placeholder to return from an exception
        epilogue { nop }

        # Selects from {add, sub, and, ...}
        rv32i_arithmetic_rrr t0, t1, t2

        # Selects from {lui, auipc}
        rv32i_load_upper_imm t3, rand(0, 0xFFFFF)

        # Selects from {addi, subi, andi}
        rv32i_arithmetic_rri s1, s2, rand(0, 0x7FF)
      }.run
    }

    # Using user-defined groups

    # Probability distribution for instruction names (NOTE: group names are not allowed here)
    xxx_dist = dist(range(:value => 'add',                :bias => 40),
                    range(:value => 'sub',                :bias => 30),
                    range(:value => ['and', 'or', 'xor'], :bias => 30))

    define_op_group('xxx', xxx_dist)
    10.times {
      atomic {
        # Placeholder to return from an exception
        epilogue { nop }

        # Selects an instruction according to the 'xxx_dist' distribution
        xxx t0, t1, t2
        xxx t3, t4, t5
        xxx s0, s1, s2
      }.run
    }
  end

end
