# See LICENSE for details

require_relative '../riscv_base'

def max_val
    if is_rev('RV64I') then 0xffffffffffffffff else 0xffffffff end
end


class RandomTemplate < RiscVBaseTemplate

  def run
    int_dist = dist(range(:value => 0,                                      :bias => 5), # Zero
                    range(:value => -1,                                     :bias => 5), 
                    range(:value => 0x0000000000000000 .. max_val, :bias => 90)) 

    int_distw = dist(range(:value => 0,                                      :bias => 5), # Zero
                    range(:value => -1,                                     :bias => 5), 
                    range(:value => 0x0000000000000000..0xffffFFFF,         :bias => 80), 
                    range(:value => 0xffffffff..max_val,                   :bias => 10)) 

    sequence {
      remu(x(_ FREE), x(_ FREE), (_ do testdata('boundary') end)) do situation('random_biased',
        :dist => dist(range(:value=> int_dist,                :bias => 80),  # Simple
                      range(:value=> [0xDEADBEEF, 0xBADF00D], :bias => 20))) # Magic
      end
      # NOP instruction is used as a location to return from en exception
      nop
    }.run 10000

    if is_rev('RV64I') then
      sequence {
        remuw(x(_ FREE), x(_ FREE), (_ do testdata('boundary') end)) do situation('random_biased',
          :dist => dist(range(:value=> int_distw,                :bias => 80),  # Simple
                        range(:value=> [0xDEADBEEF, 0xBADF00D], :bias => 20))) # Magic
        end
        # NOP instruction is used as a location to return from en exception
        nop
      }.run 10000
    end
  end

end
