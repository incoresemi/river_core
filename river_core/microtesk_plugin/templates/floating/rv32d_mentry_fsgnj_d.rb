# See LICENSE for details

require_relative '../riscv_base'


class RandomTemplate < RiscVBaseTemplate

  def pre_rvtest
RVTEST_RV64MF()
    RVTEST_CODE_BEGIN()
  end
  def pre
    super
    data {
      text '.align 8'
      align 4
      label :data
      word rand(1, 9), rand(1, 9), rand(1, 9), rand(1, 9)
      label :end_data
      space 1
    }
  end

  def run
    int_dist = dist(range(:value => 0,                                      :bias => 5), 
                    range(:value => -1,                                     :bias => 5), 
                    range(:value => 1,                                     :bias => 5), 
                    range(:value => 0x0000000000000000..0xffffffffffffFFFF, :bias => 85))

    sequence {
      li r=x(_ FREE), rand(0,4)
      slli r, r, 5
      fscsr x1, r
fsgnj_d(f(_ FREE), f(_ FREE), f(_  do testdata('boundary') end)) do situation('random_biased',
			:dist => dist(range(:value=> int_dist, :bias => 80),
			 range(:value=> [0xDEADBEEF, 0xBADF00D], :bias => 20)))
      end

      frcsr x(_ FREE)
    }.run 1000

  end
end

