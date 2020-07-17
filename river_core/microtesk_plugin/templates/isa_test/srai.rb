# See LICENSE for details

require_relative '../riscv_base'
require_relative '../riscv_rand'

def rand_range(low, high); rand(low, high) end
def rand_shift_imm
    is_rev('RV64I') ? rand_range(1, 63) : rand_range(1, 31)
end
class RandomTemplate < RiscVBaseTemplate

  def run
    int_dist = dist(range(:value => 0,                                      :bias => 5),
                    range(:value => -1,                                     :bias => 5),
                    range(:value => 0x0..0xffff,                            :bias => 60),
                    range(:value => 0x10000..0xffffffffffffffff,            :bias => 10))

    sequence {
      srai(x(_ FREE), x(_  do testdata('boundary') end), rand_shift_imm()) do situation('random_biased',
        :dist => dist(range(:value=> int_dist,                :bias => 80),  # Simple
                      range(:value=> [0x1000000000000000, -1, 0, 1], :bias => 20)))
                    end
      # NOP instruction is used as a location to return from en exception
      nop
    }.run 10000

    if is_rev('RV64I') then
      sequence {
        sraiw(x(_ FREE), x(_  do testdata('boundary') end), rand_shift_imm()) do situation('random_biased',
          :dist => dist(range(:value=> int_dist,                :bias => 80),  # Simple
                        range(:value=> [0x1000000000000000, -1, 0, 1], :bias => 20)))
                      end
        # NOP instruction is used as a location to return from en exception
        nop
      }.run 10000
    end
  end

end
