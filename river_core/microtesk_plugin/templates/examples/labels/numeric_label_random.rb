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
# This test template demonstrates how to use numeric labels that appear in a random order.
# The idea is the following: Sequences containing numeric labels appear in random order.
# Whatever the order is the sequences are first executed from top to bottom and
# then from bottom to top.
#
class NumericLabelRandomTemplate < RiscVBaseTemplate

  def run
    block(:permutator => 'random', :presimulation => false) {
      prologue {
label :start
        prepare t0, 0x0
        prepare t1, 0x0
        prepare t2, 0x0
label 1
        beqz t0, label_f(1)
        beqz t1, label_f(1)
        beqz t2, label_f(1)

        check_numeric_labels()
        j :finish
        newline
      }

      sequence {
label 2
        check_numeric_labels()
        j label_b(1)
label 1
        bnez t0, label_b(2)
        addi t0, t0, 1
        j label_f(1)
        nop
        addi t0, t0, -1
        newline
      }

      sequence {
label 2
        check_numeric_labels()
        j label_b(1)
label 1
        bnez t1, label_b(2)
        addi t1, t1, 1
        j label_f(1)
        nop
        addi t1, t1, -1
        newline
      }

      sequence {
label 2
        check_numeric_labels()
        j label_b(1)
label 1
        bnez t2, label_b(2)
        addi t2, t2, 1
        j label_f(1)
        nop
        addi t2, t2, -1
        newline
      }

      epilogue {
label 2
        check_numeric_labels()
        j label_b(1)
label 1
        bnez t0, label_b(2)
        bnez t1, label_b(2)
        bnez t2, label_b(2)
label :error
        trace("Error: Numeric labels are assigned incorrect addresses.")
        nop
label :finish
        nop
        newline
      }
    }.run 5
  end

  def check_numeric_labels()
    la s0, label_f(1)
    la s1, label_b(1)
    blt s0, s1, :error
  end

end
