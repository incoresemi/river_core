# See LICENSE for details

require_relative '../riscv_base'

class RandomTemplate < RiscVBaseTemplate

  def run
    int_dist = dist(range(:value => 0,                                      :bias => 5), # Zero
                    range(:value => -1,                                     :bias => 5), # Small
                    range(:value => 0x20..0xffffffffffffffff,               :bias => 10), # Small
                    range(:value => 0x0000000000000000..0x20, :bias => 80)) # Large

    sequence {
      sll(x(_ FREE), x(_ FREE),
           (_ do testdata('boundary') end)) do situation('random_biased',
        :dist => dist(range(:value=> int_dist,                :bias => 80),  # Simple
                      range(:value=> [0xDEADBEEF, 0xBADF00D], :bias => 20))) # Magic
      end
      # NOP instruction is used as a location to return from en exception
      nop
    }.run 10000

    if is_rev('RV64I') then
      sequence {
        sllw(x(_ FREE), x(_ FREE),
             (_ do testdata('boundary') end)) do situation('random_biased',
          :dist => dist(range(:value=> int_dist,                :bias => 80),  # Simple
                        range(:value=> [0xDEADBEEF, 0xBADF00D], :bias => 20))) # Magic
        end
        # NOP instruction is used as a location to return from en exception
        nop
      }.run 10000
    end
  end

end
