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

module SeqVector

  def seq_vector

    pick_random {
      ops = []

      ops += ['VADD', 'VSUB', 'VMUL', 'VMULH', 'VDIV']

      ops.each { |op|
        seq_vector_vd_vs2_vs1(op)
      }
    }
  end

  private

  def instr(op, *args)
    self.send :"#{op}", args
  end

  def seq_vector_vd_vs2_vs1(op)
    vs1 = reg_read_any(:vregs)
    vs2 = reg_read_any(:vregs)
    dest = reg_write(:vregs, vs1)

    atomic {
      la t1, :test_memory
      vlw vs1, t1
      addi t1, t1, 4*4
      vlw vs2, t1

      instr op, dest, vs2, vs1
    }
  end

end
