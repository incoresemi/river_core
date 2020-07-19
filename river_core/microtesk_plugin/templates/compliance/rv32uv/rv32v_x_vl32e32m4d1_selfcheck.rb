#
# Copyright 2019 ISP RAS (http://www.ispras.ru)
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
# This tests for X instruction.
# This tests use 32bit boundary values.
#
class InstructionX < RiscVBaseTemplate
  #def pre
  #  section_data(:pa => 0x8002_8000, :va => 0x8002_8000) {}
  #  super()
  #end

  def TEST_DATA
    data {
      label :data
      word 0x0, 0x80, 0xff80, 0xff00, 0x8000, 0x1, 0xff01, 0x2
      word 0x3, 0x7, 0x8, 0xe, 0xf, 0xfff0, 0xfff1, 0xfff7
      word 0xfff8, 0xfffc, 0xfffd, 0xfffe, 0xfe, 0xffff, 0x7f, 0xff
      word 0xff7f, 0x7fff
      word rand(-2147483648, 2147483647), rand(-2147483648, 2147483647)
      word rand(-2147483648, 2147483647), rand(-2147483648, 2147483647)
      word rand(-2147483648, 2147483647), rand(-2147483648, 2147483647)
      label :end
      space 1
    }
  end

  def generate_simple_tests(x_instruction)
    trace "The tests for RV32V instruction %s", x_instruction

    e32 = 0b010 # standard element width = 32
    m4 = 0b10 # the number of vector registers in a group = 4

    # VLEN = 32
    addi a0, zero, 0b100000
    vsetvli t0, a0, e32, m4

    xxx_dist = dist(range(:value => [x_instruction], :bias => 100))
    define_op_group('xxx', xxx_dist)

    for i in 0..31
      for j in 0..7
        atomic {

        # Load test data
        la t0, :data
        lw t2, t0, 4*i
        la t1, :end
        for i1 in 0..3
          sw t2, t1, i1*4
        end
        vlw v28, t1

        # Load test data
        la t1, :data
        addi t1, t1, 16*j
        vlw v8, t1
        vlw v12, t1

        # Test sequence of instructions: 4
        xxx v0, v8, v28
        xxx v4, v28, v12
        xxx v8, v0, v4
        xxx v12, v8, v28

        # Save results to label_end: [0 .. 64] (16 registers: [v0 .. v15])
        la t1, :end
        for i2 in 0..3
          vsw vr(4*i2), t1
          addi t1, t1, 16
        end

        # For self-check:
        la t1, :end
        for i3 in 10..25
          lw x(i3), t1, 4*(i3-10)
        end

       }.run
      end
    end

    trace "End Boundary tests for instruction '%s'.", x_instruction
  end

  def run
    generate_simple_tests('vsub')
  end
end
