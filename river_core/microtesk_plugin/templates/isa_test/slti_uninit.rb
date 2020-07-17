# See LICENSE for details

require_relative '../riscv_base'
require_relative '../riscv_rand'

def rand_range(low, high); rand(low, high) end
def rand_imm;    rand_range(-2048, 2047) end

class RandomTemplate < RiscVBaseTemplate

  def run
    int_dist = dist(range(:value => 0,                                      :bias => 5), # Zero
                    range(:value => -1,                                     :bias => 5), # Small
                    range(:value => 0x20..0xffffffffffffffff,               :bias => 10), # Small
                    range(:value => 0x0000000000000000..0x20, :bias => 80)) # Large

      #slt(x(_ FREE), x(_ (_ do testdata('boundary') end)) do situation('random_biased',
      #  :dist => dist(range(:value=> int_dist,                :bias => 80),  # Simple
      #                range(:value=> [0xDEADBEEF, 0xBADF00D], :bias => 20))),
      #end  
      #      rand_imm())
      slti(x(_ FREE), x(_), rand_imm())
      # NOP instruction is used as a location to return from en exception
      nop
  end

end
