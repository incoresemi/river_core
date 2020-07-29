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

module SeqFpmemRvc

  def seq_fpmem_rvc(memsize)
    pick_random {
      # seq_fpmem_load_addrfn_sp_rvc(
      #    'C_FLWSP', :fregs_s,   rand_addr_w(memsize), _SLL(rand_range(0, 63), 2))

      seq_fpmem_load_addrfn_sp_rvc(
          'C_FLDSP', :fregs_d,   rand_addr_d(memsize), _SLL(rand_range(0, 63), 3))

      # seq_fpmem_store_addrfn_sp_rvc(
      #    'C_FSWSP', :fregs_s,   rand_addr_w(memsize), _SLL(rand_range(0, 63), 2))

      seq_fpmem_store_addrfn_sp_rvc(
          'C_FSDSP', :fregs_d,   rand_addr_d(memsize), _SLL(rand_range(0, 63), 3))

      # seq_fpmem_load_addrfn_rvc_c(
      #    'C_FLW',   :fregs_s_c, rand_addr_w(memsize), _SLL(rand_range(0, 31), 2))

      seq_fpmem_load_addrfn_rvc_c(
          'C_FLD',   :fregs_d_c, rand_addr_d(memsize), _SLL(rand_range(0, 31), 3))

      # seq_fpmem_store_addrfn_rvc_c(
      #    'C_FSW',   :fregs_s_c, rand_addr_w(memsize), _SLL(rand_range(0, 31), 2))

      seq_fpmem_store_addrfn_rvc_c(
          'C_FSD',   :fregs_d_c, rand_addr_d(memsize), _SLL(rand_range(0, 31), 3))
    }
  end

  private

  def instr(op, *args)
    self.send :"#{op}", args
  end

  def seq_fpmem_load_addrfn_sp_rvc(op, fregpool, addr, imm)
    reg_dest = reg_write_visible(fregpool)
    atomic {
      lla sp, :test_memory, _SUB(addr, imm)
      instr op, reg_dest, imm
      c_nop # FIXME: C_NOP is for 32-bit alignment
    }
  end

  def seq_fpmem_store_addrfn_sp_rvc(op, fregpool, addr, imm)
    reg_src = reg_write_visible(fregpool)
    atomic {
      lla sp, :test_memory, _SUB(addr, imm)
      instr op, reg_src, imm
      c_nop # FIXME: C_NOP is for 32-bit alignment
    }
  end

  def seq_fpmem_load_addrfn_rvc(op, addr, imm)
    reg_addr = reg_write_hidden(:xregs_c)
    reg_dest = reg_write_visible(fregpool)

    atomic {
      lla reg_addr, :test_memory, _SUB(addr, imm)
      instr op, reg_dest, to_cx(reg_addr), imm
      c_nop # FIXME: C_NOP is for 32-bit alignment
    }
  end

  def seq_fpmem_load_addrfn_rvc_c(op, fregpool_c, addr, imm)
    reg_addr = reg_write_hidden(:xregs_c)
    reg_dest = reg_write_visible(fregpool_c)

    atomic {
      lla reg_addr, :test_memory, _SUB(addr, imm)
      instr op, to_cf(reg_dest), to_cx(reg_addr), imm
      c_nop # FIXME: C_NOP is for 32-bit alignment
    }
  end

  def seq_fpmem_store_addrfn_rvc(op, fregpool, addr, imm)
    reg_addr = reg_write_hidden(:xregs_c)
    reg_src = reg_read_visible(fregpool)

    atomic {
      lla reg_addr, :test_memory, _SUB(addr, imm)
      instr op, reg_src, to_cx(reg_addr), imm
      c_nop # FIXME: C_NOP is for 32-bit alignment
    }
  end

  def seq_fpmem_store_addrfn_rvc_c(op, fregpool_c, addr, imm)
    reg_addr = reg_write_hidden(:xregs_c)
    reg_src = reg_read_visible(fregpool_c)

    atomic {
      lla reg_addr, :test_memory, _SUB(addr, imm)
      instr op, to_cf(reg_src), to_cx(reg_addr), imm
      c_nop # FIXME: C_NOP is for 32-bit alignment
    }
  end

end
