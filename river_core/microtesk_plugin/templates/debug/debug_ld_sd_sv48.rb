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
# This test checks LD and SD instructions for Sv48 virtual address translation process.
#
class InstructionLdSdSv48Template < RiscVBaseTemplate

  def TEST_DATA
    section(:name => 'page_table_sv48_step3', :prefix => '.section',
            :pa   => 0x00000000AED22000,
            :va   => 0x00000000AED22000) {
      data {
        # Page Table Level: 3
        label :data3
        dword 0x0000000031B488e1, 0xdeadbeefdeadbeef
        label :end3
        space 1
      }
    }

    section(:name => 'page_table_sv48_step1_2', :prefix => '.section',
            :pa   => 0x00000000C6D22000,
            :va   => 0x00000000C6D22000) {
      data {
        # Page Table Level: 1
        label :data1
        dword 0x0000000035B488e1, 0xdeadbeefdeadbeef
        label :end1
        space 1
      }
    }

    section(:name => 'page_table_sv48_step0', :prefix => '.section',
            :pa   => 0x00000000C6D22080,
            :va   => 0x00000000C6D22080) {
      data {
        # Page Table Level: 0
        label :data0
        dword 0x0000000038B488e3, 0xdeadbeefdeadbeef
        label :end0
        space 1
      }
    }

    section(:name => 'data_for_sv48', :prefix => '.section',
            :pa   => 0x00000000E2D22000,
            :va   => 0x00000000E2D22000) {
      data {
        # Data
        label :data
        dword 0xdeadbeefc001beef, 0xc001beefdeadbeef
        label :end
        space 1
      }
    }
  end

  def run
    if is_rev('MEM_V64') then
      # Only for Sv48, (RV64)
      trace "CSR satp = 0x%x", satp
      # sv48 MODE = 9
      li t0, 0x90000000000aed22
      trace "Register t0 = 0x%x", t0
      csrw satp, t0
      trace "CSR satp = 0x%x", satp

      li s0, 0x00010000 # Address
      prepare t0, 0xDEADBEEFDEADBEEF # Value being loaded/stored

      trace "Register s0 = 0x%x", s0
      ld t1, s0, 0x0
      trace "Register t1 = 0x%x", t1
      sd t0, s0, 0x0
      trace "Register t0 = 0x%x", t0
      ld t1, s0, 0x0
      trace "Register t1 = 0x%x", t1
      nop
    end
  end

end
