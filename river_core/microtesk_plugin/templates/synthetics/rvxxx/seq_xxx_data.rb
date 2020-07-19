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

require_relative '../../riscv_rand'

module SeqXxxData
  include RiscvRand

  def XXX_DATA(memsize)
    # data { label :hidden_data }
    # REGISTER_DATA(:xreg_init_data, 'reg_x%d_init') { dword rand_biased }
    # REGISTER_DATA(:freg_init_data, 'reg_f%d_init') { dword rand_biased }

    RVTEST_DATA_BEGIN()

    REGISTER_DATA(:xreg_output_data, 'reg_x%d_output') { dword rand_dword }
    REGISTER_DATA(:freg_output_data, 'reg_f%d_output') { dword rand_dword }
    MEMORY_DATA(memsize)

    RVTEST_DATA_END()
  end

  def LOAD_XREGS
    pseudo ''
label :xreg_init
    la x31, :xreg_init_data
    (0..31).each { |index|
      ld x(index), x31, index * 8
    }
    newline
  end

  def SAVE_XREGS
    pseudo ''
label :xreg_save
    la sp, :xreg_output_data
    (0..31).each { |index|
      sd x(index), sp, index * 8 unless index == 2 # Not sp
    }
  end

  def SAVE_FREGS
    pseudo ''
label :freg_save
    la x31, :freg_output_data
    (0..31).each { |index|
      fsd f(index), x31, index * 8
    }
  end

  private

  def REGISTER_DATA(head_label, item_label_frmt, &data_item)
    data {
      align 8
label head_label
      (0..31).each { |i|
label :"#{item_label_frmt % i}"
      self.instance_eval &data_item
      }
    }
  end

  def MEMORY_DATA(size)
    data {
      comment 'Memory Blocks'
      align 8
label :test_memory
      if size % 16 == 0 then
        (size/8/2).times { dword rand_dword, rand_dword }
      elsif size % 8 == 0 then
        (size/8).times { dword rand_dword }
      else
        (size/4).times { word rand_word }
      end
    }
  end

end
