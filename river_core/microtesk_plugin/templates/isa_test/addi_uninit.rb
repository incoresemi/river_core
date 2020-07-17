# See LICENSE for details

require_relative '../riscv_base'
require_relative '../riscv_base'

def rand_range(low, high); rand(low, high) end
def rand_imm;    rand_range(-2048, 2047) end

class RandomTemplate < RiscVBaseTemplate

  def run
      addi(x(_ FREE), x(_ FREE), rand_imm() )
      # NOP instruction is used as a location to return from en exception
      nop
  end

end
