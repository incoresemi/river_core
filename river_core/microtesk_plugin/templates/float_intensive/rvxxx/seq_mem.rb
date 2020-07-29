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

module SeqMem

  def seq_mem(memsize, use_amo)
    pick_random {
      seq_mem_load_addrfn('LB',  rand_addr_b(memsize))
      seq_mem_load_addrfn('LBU', rand_addr_b(memsize))
      seq_mem_load_addrfn('LH',  rand_addr_h(memsize))
      seq_mem_load_addrfn('LHU', rand_addr_h(memsize))
      seq_mem_load_addrfn('LW',  rand_addr_w(memsize))
      seq_mem_load_addrfn('LWU', rand_addr_w(memsize))
      seq_mem_load_addrfn('LD',  rand_addr_d(memsize))

      seq_mem_store_addrfn('SB', rand_addr_b(memsize))
      seq_mem_store_addrfn('SH', rand_addr_h(memsize))
      seq_mem_store_addrfn('SW', rand_addr_w(memsize))
      seq_mem_store_addrfn('SD', rand_addr_d(memsize))

      if use_amo then
        seq_mem_amo_addrfn('AMOADD_W',  rand_addr_w(memsize))
        seq_mem_amo_addrfn('AMOSWAP_W', rand_addr_w(memsize))
        seq_mem_amo_addrfn('AMOAND_W',  rand_addr_w(memsize))
        seq_mem_amo_addrfn('AMOOR_W',   rand_addr_w(memsize))
        seq_mem_amo_addrfn('AMOMIN_W',  rand_addr_w(memsize))
        seq_mem_amo_addrfn('AMOMINU_W', rand_addr_w(memsize))
        seq_mem_amo_addrfn('AMOMAX_W',  rand_addr_w(memsize))
        seq_mem_amo_addrfn('AMOMAXU_W', rand_addr_w(memsize))
        seq_mem_amo_addrfn('AMOADD_D',  rand_addr_d(memsize))
        seq_mem_amo_addrfn('AMOSWAP_D', rand_addr_d(memsize))
        seq_mem_amo_addrfn('AMOAND_D',  rand_addr_d(memsize))
        seq_mem_amo_addrfn('AMOOR_D',   rand_addr_d(memsize))
        seq_mem_amo_addrfn('AMOMIN_D',  rand_addr_d(memsize))
        seq_mem_amo_addrfn('AMOMINU_D', rand_addr_d(memsize))
        seq_mem_amo_addrfn('AMOMAX_D',  rand_addr_d(memsize))
        seq_mem_amo_addrfn('AMOMAXU_D', rand_addr_d(memsize))
      end

      seq_mem_stld_overlap(memsize)
      seq_mem_stld_overlap(memsize)
    }
  end

  private

  def instr(op, *args)
    self.send :"#{op}", args
  end

  def seq_mem_load_addrfn(op, addr)
    reg_addr = reg_write_hidden(:xregs)
    reg_dest = reg_write_visible(:xregs)
    imm = rand_imm()

    sequence {
      lla reg_addr, :test_memory, _SUB(addr, imm)
      instr op, reg_dest, reg_addr, imm
    }
  end

  def seq_mem_store_addrfn(op, addr)
    reg_addr = reg_write_hidden(:xregs)
    reg_src = reg_read_visible(:xregs)
    imm = rand_imm()

    sequence {
      lla reg_addr, :test_memory, _SUB(addr, imm)
      instr op, reg_src, reg_addr, imm
    }
  end

  def seq_mem_amo_addrfn(op, addr)
    reg_addr = reg_write_hidden(:xregs)
    reg_dest = reg_write_visible(:xregs)
    reg_src = reg_read_visible(:xregs)

    sequence {
      lla reg_addr, :test_memory, addr
      instr op, reg_dest, reg_src, reg_addr
    }
  end

  def seq_mem_stld_overlap(memsize)
    l_reg_addr = reg_write_hidden(:xregs)
    s_reg_addr = reg_write_hidden(:xregs)
    s_reg_src  = reg_read_visible(:xregs)
    l_reg_dest = reg_write_visible(:xregs)

    dw_addr = rand_addr_d(memsize)
    s_imm = rand_imm()
    l_imm = rand_imm()

    block(:combinator => 'random', :permutator => 'random', :compositor => 'rotation') {
      iterate {
        sequence {
          lla l_reg_addr, :test_memory, _SUB(_ADD(dw_addr, rand_addr_b(8)), l_imm)
          lb l_reg_dest, l_reg_addr, l_imm
        }
        sequence {
          lla l_reg_addr, :test_memory, _SUB(_ADD(dw_addr, rand_addr_b(8)), l_imm)
          lbu l_reg_dest, l_reg_addr, l_imm
        }
        sequence {
          lla l_reg_addr, :test_memory, _SUB(_ADD(dw_addr, rand_addr_h(8)), l_imm)
          lh l_reg_dest, l_reg_addr, l_imm
        }
        sequence {
          lla l_reg_addr, :test_memory, _SUB(_ADD(dw_addr, rand_addr_h(8)), l_imm)
          lhu l_reg_dest, l_reg_addr, l_imm
        }
        sequence {
          lla l_reg_addr, :test_memory, _SUB(_ADD(dw_addr, rand_addr_w(8)), l_imm)
          lw l_reg_dest, l_reg_addr, l_imm
        }
        sequence {
          lla l_reg_addr, :test_memory, _SUB(_ADD(dw_addr, rand_addr_w(8)), l_imm)
          lwu l_reg_dest, l_reg_addr, l_imm
        }
        sequence {
          lla l_reg_addr, :test_memory, _SUB(dw_addr, l_imm)
          ld l_reg_dest, l_reg_addr, l_imm
        }
      }

      iterate {
        sequence {
          lla s_reg_addr, :test_memory, _SUB(_ADD(dw_addr, rand_addr_b(8)), s_imm)
          sb s_reg_src, s_reg_addr, s_imm
        }
        sequence {
          lla s_reg_addr, :test_memory, _SUB(_ADD(dw_addr, rand_addr_h(8)), s_imm)
          sh s_reg_src, s_reg_addr, s_imm
        }
        sequence {
          lla s_reg_addr, :test_memory, _SUB(_ADD(dw_addr, rand_addr_w(8)), s_imm)
          sw s_reg_src, s_reg_addr, s_imm
        }
        sequence {
          lla s_reg_addr, :test_memory, _SUB(dw_addr, s_imm)
          sd s_reg_src, s_reg_addr, s_imm
        }
      }
    }
  end

end
