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

class InstructionLdSdSv32Template < RiscVBaseTemplate

  def TEST_DATA
    section(:name => 'page_table_sv32_step1', :prefix => '.section',
            :pa   => 0x00000000BED22000,
            :va   => 0x00000000BED22000) {
      data {
        # Page Table Level: 1
        label :data1
        word 0x33B488e1, 0xdeadbeef, 0xdeadbeef, 0xdeadbeef
        label :end1
        space 1
      }
    }

    section(:name => 'page_table_sv32_step0', :prefix => '.section',
            :pa   => 0x00000000CED22040,
            :va   => 0x00000000CED22040) {
      data {
        # Page Table Level: 0
        label :data0
        word 0x37B488e3, 0xdeadbeef, 0xdeadbeef, 0xdeadbeef
        label :end0
        space 1
      }
    }

    section(:name => 'data_for_sv32', :prefix => '.section',
            :pa   => 0x00000000DED22000,
            :va   => 0x00000000DED22000) {
      data {
        # Data
        label :data
        word 0xc001beef, 0xc001beef, 0xc001beef, 0xc001beef
        label :end
        space 1
      }
    }
  end

  def run
    if is_rev('MEM_SV32') then
      # Only for Sv32, (RV32)
      # csrwi satp, 0x80000002 # MODE = 1, PPN = 0x2
      trace "CSR satp = 0x%x", satp
      li t0, 0x800bed22
      trace "Register t0 = 0x%x", t0
      csrw satp, t0
      trace "CSR satp = 0x%x", satp

      li s0, 0x00010000 # Address
      prepare t0, 0xFFFFFFFFDEADBEEF # Value being loaded/stored

      trace "Register s0 = 0x%x", s0
      lw t1, s0, 0x0
      trace "Register t1 = 0x%x", t1
      sw t0, s0, 0x0
      trace "Register t0 = 0x%x", t0
      lw t1, s0, 0x0
      trace "Register t1 = 0x%x", t1
      nop
    end
  end

end
