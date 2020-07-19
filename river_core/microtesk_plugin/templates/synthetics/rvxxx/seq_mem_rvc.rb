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

module SeqMemRvc

  def seq_mem_rvc(memsize)
    pick_random {
      seq_mem_load_addrfn_sp_rvc('C_LWSP', rand_addr_w(memsize), _SLL(rand_range(0, 63), 2))
      seq_mem_load_addrfn_sp_rvc('C_LDSP', rand_addr_d(memsize), _SLL(rand_range(0, 63), 3))

      seq_mem_store_addrfn_sp_rvc('C_SWSP', rand_addr_w(memsize), _SLL(rand_range(0, 63), 2))
      seq_mem_store_addrfn_sp_rvc('C_SDSP', rand_addr_d(memsize), _SLL(rand_range(0, 63), 3))

      seq_mem_load_addrfn_rvc('C_LW', rand_addr_w(memsize), _SLL(rand_range(0, 31), 2))
      seq_mem_load_addrfn_rvc('C_LD', rand_addr_d(memsize), _SLL(rand_range(0, 31), 3))

      seq_mem_store_addrfn_rvc('C_SW', rand_addr_w(memsize), _SLL(rand_range(0, 31), 2))
      seq_mem_store_addrfn_rvc('C_SD', rand_addr_d(memsize), _SLL(rand_range(0, 31), 3))
    }
  end

  private

  def instr(op, *args)
    self.send :"#{op}", args
  end

  def seq_mem_load_addrfn_sp_rvc(op, addr, imm)
    reg_dest = reg_write_visible(:xregs, :exclude => [zero])
    atomic {
      lla sp, :test_memory, _SUB(addr, imm)
      instr op, reg_dest, imm
      c_nop # FIXME: C_NOP is for 32-bit alignment
    }
  end

  def seq_mem_store_addrfn_sp_rvc(op, addr, imm)
    reg_src = reg_write_visible(:xregs, :exclude => [zero])
    atomic {
      lla sp, :test_memory, _SUB(addr, imm)
      instr op, reg_src, imm
      c_nop # FIXME: C_NOP is for 32-bit alignment
    }
  end

  def seq_mem_load_addrfn_rvc(op, addr, imm)
    reg_addr = reg_write_hidden(:xregs_c)
    reg_dest = reg_write_visible(:xregs_c)

    atomic {
      lla reg_addr, :test_memory, _SUB(addr, imm)
      instr op, to_cx(reg_dest), to_cx(reg_addr), imm
      c_nop # FIXME: C_NOP is for 32-bit alignment
    }
  end

  def seq_mem_store_addrfn_rvc(op, addr, imm)
    reg_addr = reg_write_hidden(:xregs_c)
    reg_src = reg_read_visible(:xregs_c)

    atomic {
      lla reg_addr, :test_memory, _SUB(addr, imm)
      instr op, to_cx(reg_src), to_cx(reg_addr), imm
      c_nop # FIXME: C_NOP is for 32-bit alignment
    }
  end

end
