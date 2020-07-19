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
# This test template demonstrates how to generate test cases with branch instructions.
#
class BranchGeneration3Template < RiscVBaseTemplate

  def TEST_DATA
    data {
      org 0x0
      align 8
      # Space to store test data for branch instructions.
      label :branch_data # start label
      space (8 * 1024)   # size in bytes
    }
  end

  def pre
    super

    stream_preparator(:data_source => 'X', :index_source => 'X') {
      init {
        la index_source, start_label
      }

      read {
        if is_rev('RV64I') then
          ld data_source, index_source, 0x0
        else
          lw data_source, index_source, 0x0
        end
        addi index_source, index_source, 8
      }

      write {
        if is_rev('RV64I') then
          sd data_source, index_source, 0x0
        else
          sw data_source, index_source, 0x0
        end
        addi index_source, index_source, 8
      }
    }
  end

  def run
    # Stream  Label        Data  Addr  Size
    stream   :branch_data, s0,   s1,   1024

    # Parameter 'branch_exec_limit' bounds the number of executions of a single branch:
    #   the default value is 1.
    # Parameter 'block_exec_limit' bounds the number of executions of a single basic block:
    #   the default value is 1.
    # Parameter 'trace_count_limit' bounds the number of execution traces to be created:
    #   the default value is -1 (no limitation).
    sequence(
      :engines => {
        :branch => {
          :branch_percentage => 20,
          :branch_exec_limit => 3,
          :block_exec_limit  => 1,
          :trace_count_limit => 1 }}) {
      # Branches to be used in tests.
      branches {
        bgez s0, _label do situation('bgez-if-then', :engine => :branch, :stream => 'branch_data') end
        bgtz s0, _label do situation('bgtz-if-then', :engine => :branch, :stream => 'branch_data') end
        blez s0, _label do situation('blez-if-then', :engine => :branch, :stream => 'branch_data') end
        bltz s0, _label do situation('bltz-if-then', :engine => :branch, :stream => 'branch_data') end
        j        _label do situation('j-goto',       :engine => :branch) end
      }

      # Executed code
      executed {
        # The code does not modify the registers s0 and s1.
        andi s2, s2, 2
        andi s3, s3, 3
        andi s4, s4, 4
        andi s5, s5, 5
        andi s6, s6, 6
        andi s7, s7, 7
        andi s8, s8, 8
        andi s9, s9, 9
      }

      # Non-taken code
      nonexecuted {
        ori s2, s2, 2
        ori s3, s3, 3
        ori s4, s4, 4
        ori s5, s5, 5
        ori s6, s6, 6
        ori s7, s7, 7
        ori s8, s8, 8
        ori s9, s9, 9
      }
    }.run 20 # Try several random test cases
  end

end
