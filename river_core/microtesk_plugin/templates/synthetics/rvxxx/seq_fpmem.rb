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

module SeqFpmem

  def seq_fpmem(memsize)
    pick_random {
      seq_fpmem_load_addrfn('FLW',  rand_addr_w(memsize), :fregs_s)
      seq_fpmem_store_addrfn('FSW', rand_addr_w(memsize), :fregs_s)
      seq_fpmem_load_addrfn('FLD',  rand_addr_d(memsize), :fregs_d)
      seq_fpmem_store_addrfn('FSD', rand_addr_d(memsize), :fregs_d)
    }
  end

  private

  def instr(op, *args)
    self.send :"#{op}", args
  end

  def seq_fpmem_load_addrfn(op, addr, fregpool)
    reg_addr = reg_write_hidden(:xregs)
    reg_dest = reg_write_visible(fregpool)
    imm = rand_imm

    sequence {
      lla reg_addr, :test_memory, _SUB(addr, imm)
      instr op, reg_dest, reg_addr, imm
    }
  end

  def seq_fpmem_store_addrfn(op, addr, fregpool)
    reg_addr = reg_write_hidden(:xregs)
    reg_src = reg_read_visible(fregpool)
    imm = rand_imm

    sequence {
      lla reg_addr, :test_memory, _SUB(addr, imm)
      instr op, reg_src, reg_addr, imm
    }
  end

end
