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

module SeqBranch

  TAKEN = true
  NOTTAKEN = false

  def seq_branch
    # These tests have the same labels if the operand order is reversed
    reversible_tests = [
      ['BEQ',  method(:helper_two_srcs_sameval_samereg_any),          TAKEN],
      ['BEQ',  method(:helper_two_srcs_sameval_samereg_zero),         TAKEN],
      ['BEQ',  method(:helper_two_srcs_sameval_diffreg_any),          TAKEN],
      ['BEQ',  method(:helper_two_srcs_sameval_diffreg_zero),         TAKEN],
      ['BEQ',  method(:helper_two_srcs_diffval_diffreg_bothpos),      NOTTAKEN],
      ['BEQ',  method(:helper_two_srcs_diffval_diffreg_bothneg),      NOTTAKEN],
      ['BEQ',  method(:helper_two_srcs_sameval_diffreg_oppositesign), NOTTAKEN],
      ['BEQ',  method(:helper_two_srcs_diffval_diffreg_oppositesign), NOTTAKEN],
      ['BNE',  method(:helper_two_srcs_sameval_samereg_any),          NOTTAKEN],
      ['BNE',  method(:helper_two_srcs_sameval_samereg_zero),         NOTTAKEN],
      ['BNE',  method(:helper_two_srcs_sameval_diffreg_any),          NOTTAKEN],
      ['BNE',  method(:helper_two_srcs_sameval_diffreg_zero),         NOTTAKEN],
      ['BNE',  method(:helper_two_srcs_diffval_diffreg_bothpos),      TAKEN],
      ['BNE',  method(:helper_two_srcs_diffval_diffreg_bothneg),      TAKEN],
      ['BNE',  method(:helper_two_srcs_sameval_diffreg_oppositesign), TAKEN],
      ['BNE',  method(:helper_two_srcs_diffval_diffreg_oppositesign), TAKEN],
      ['BLT',  method(:helper_two_srcs_sameval_samereg_any),          NOTTAKEN],
      ['BLT',  method(:helper_two_srcs_sameval_samereg_zero),         NOTTAKEN],
      ['BLT',  method(:helper_two_srcs_sameval_diffreg_any),          NOTTAKEN],
      ['BLT',  method(:helper_two_srcs_sameval_diffreg_zero),         NOTTAKEN],
      ['BLTU', method(:helper_two_srcs_sameval_samereg_any),          NOTTAKEN],
      ['BLTU', method(:helper_two_srcs_sameval_samereg_zero),         NOTTAKEN],
      ['BLTU', method(:helper_two_srcs_sameval_diffreg_any),          NOTTAKEN],
      ['BLTU', method(:helper_two_srcs_sameval_diffreg_zero),         NOTTAKEN],
      ['BGE',  method(:helper_two_srcs_sameval_samereg_any),          TAKEN],
      ['BGE',  method(:helper_two_srcs_sameval_samereg_zero),         TAKEN],
      ['BGE',  method(:helper_two_srcs_sameval_diffreg_any),          TAKEN],
      ['BGE',  method(:helper_two_srcs_sameval_diffreg_zero),         TAKEN],
      ['BGEU', method(:helper_two_srcs_sameval_samereg_any),          TAKEN],
      ['BGEU', method(:helper_two_srcs_sameval_samereg_zero),         TAKEN],
      ['BGEU', method(:helper_two_srcs_sameval_diffreg_any),          TAKEN],
      ['BGEU', method(:helper_two_srcs_sameval_diffreg_zero),         TAKEN]
    ]

    # These tests need opposite labels if the operand order is reversed
    chiral_tests = [
      ['BLT',  method(:helper_two_srcs_diffval_diffreg_bothpos),      TAKEN],
      ['BLT',  method(:helper_two_srcs_diffval_diffreg_bothneg),      NOTTAKEN],
      ['BLT',  method(:helper_two_srcs_sameval_diffreg_oppositesign), NOTTAKEN],
      ['BLT',  method(:helper_two_srcs_diffval_diffreg_oppositesign), NOTTAKEN],
      ['BLTU', method(:helper_two_srcs_diffval_diffreg_bothpos),      TAKEN],
      ['BLTU', method(:helper_two_srcs_diffval_diffreg_bothneg),      NOTTAKEN],
      ['BLTU', method(:helper_two_srcs_sameval_diffreg_oppositesign), TAKEN],
      ['BLTU', method(:helper_two_srcs_diffval_diffreg_oppositesign), TAKEN],
      ['BGE',  method(:helper_two_srcs_diffval_diffreg_bothpos),      NOTTAKEN],
      ['BGE',  method(:helper_two_srcs_diffval_diffreg_bothneg),      TAKEN],
      ['BGE',  method(:helper_two_srcs_sameval_diffreg_oppositesign), TAKEN],
      ['BGE',  method(:helper_two_srcs_diffval_diffreg_oppositesign), TAKEN],
      ['BGEU', method(:helper_two_srcs_diffval_diffreg_bothpos),      NOTTAKEN],
      ['BGEU', method(:helper_two_srcs_diffval_diffreg_bothneg),      TAKEN],
      ['BGEU', method(:helper_two_srcs_sameval_diffreg_oppositesign), NOTTAKEN],
      ['BGEU', method(:helper_two_srcs_diffval_diffreg_oppositesign), NOTTAKEN]
    ]

    pick_random {
      seq_taken_j()
      seq_taken_jal()
      seq_taken_jalr()

      reversible_tests.each { |t|
        get_two_regs_and_branch_with_label t[0], t[1], t[2], false
      }

      chiral_tests.each { |t|
        get_two_regs_and_branch_with_label t[0], t[1], t[2], false
      }

      chiral_tests.each { |t|
        get_two_regs_and_branch_with_label t[0], t[1], !t[2], true
      }
    }
  end

  private

  def instr(op, *args)
    self.send :"#{op}", args
  end

  def CRASH_LABEL()
    dist(range(:bias => 50, :value => :crash_forward),
         range(:bias => 50, :value => :crash_backward)).next_value
  end

  def ILLEGAL
    # TODO: Instruction that must not be executed.
    # Jump is not a good idea since we check whether a jumop fails.
    # Ideally, it must be a random work. Need the possibility to embed data into text.
    j CRASH_LABEL()
label 1
  end

  def seq_taken_j
    atomic {
      j label_f(1)
      ILLEGAL()
    }
  end

  def seq_taken_jal
    reg_x1 = reg_write_ra(:xregs)
    atomic {
      jal reg_x1, label_f(1)
      ILLEGAL()
    }
  end

  def seq_taken_jalr
    reg_x1 = reg_write_ra(:xregs)
    reg_dst1 = reg_write_hidden(:xregs)

    block(:combinator => 'diagonal', :compositor => 'catenation') {
      atomic {
        la reg_dst1, label_f(1)
        jalr reg_x1, reg_dst1, 0
        ILLEGAL()
      }
    }
  end

  def helper_two_srcs_sameval_samereg_any
    reg_src = reg_read_any(:xregs)
    [reg_src, reg_src]
  end

  def helper_two_srcs_sameval_samereg_zero()
    reg_src = reg_read_zero(:xregs)
    [reg_src, reg_src]
  end

  def helper_two_srcs_sameval_diffreg_any
    reg_src = reg_read_any(:xregs)
    reg_dst1 = reg_write(:xregs, reg_src)
    reg_dst2 = reg_write(:xregs, reg_dst1)

    addi reg_dst1, reg_src, 0
    addi reg_dst2, reg_dst1, 0

    [reg_dst1, reg_dst2]
  end

  def helper_two_srcs_sameval_diffreg_zero
    reg_dst1 = reg_write_visible(:xregs)
    reg_dst2 = reg_write(:xregs)

    addi reg_dst1, reg_read_zero(:xregs), 0
    addi reg_dst2, reg_read_zero(:xregs), 0

    [reg_dst1, reg_dst2]
  end

  def helper_two_srcs_diffval_diffreg_bothpos
    reg_dst1 = reg_write_visible(:xregs)
    reg_dst2 = reg_write(:xregs, reg_dst1)

    addi reg_dst1, reg_read_zero(:xregs), rand_range(1, 2047)
    addi reg_dst2, reg_dst1, rand_range(1, 2047)

    # signed (+, ++), unsigned (+, ++)
    [reg_dst1, reg_dst2]
  end

  def helper_two_srcs_diffval_diffreg_bothneg
    reg_dst1 = reg_write_visible(:xregs)
    reg_dst2 = reg_write(:xregs, reg_dst1)

    addi reg_dst1, reg_read_zero(:xregs), rand_range(-2048, -1)
    addi reg_dst2, reg_dst1, rand_range(-2048, -1)

    # signed (-, --), unsigned (++++, +++)
    [reg_dst1, reg_dst2]
  end

  def helper_two_srcs_sameval_diffreg_oppositesign
    reg_src = reg_read_any(:xregs)
    reg_dst1 = reg_write(:xregs, reg_src)
    reg_dst2 = reg_write(:xregs, reg_src)
    reg_one = reg_write_visible(:xregs)
    reg_mask = reg_write_visible(:xregs)

    addi reg_one, reg_read_zero(:xregs), 1
    slli reg_one, reg_one, 63
    addi reg_mask, reg_read_zero(:xregs), -1
    xor reg_mask, reg_mask, reg_one
    And reg_dst1, reg_src, reg_mask
    Or reg_dst2, reg_dst1, reg_one

    # reg_dest1 sign bit 0, reg_dest2 sign bit 1
    [reg_dst1, reg_dst2]
  end

  def helper_two_srcs_diffval_diffreg_oppositesign
    reg_src1 = reg_read_any(:xregs)
    reg_src2 = reg_read_any(:xregs)
    reg_dst1 = reg_write(:xregs, reg_src1)
    reg_dst2 = reg_write(:xregs, reg_src2)
    reg_one = reg_write_visible(:xregs)
    reg_mask = reg_write_visible(:xregs)

    addi reg_one, reg_read_zero(:xregs), 1
    slli reg_one, reg_one, 63
    addi reg_mask, reg_read_zero(:xregs), -1
    xor reg_mask, reg_mask, reg_one
    And reg_dst1, reg_src1, reg_mask
    Or reg_dst2, reg_src2, reg_one

    # reg_dest1 sign bit 0, reg_dest2 sign bit 1
    [reg_dst1, reg_dst2]
  end

  def get_two_regs_and_branch_with_label(op, helper, taken, flip_ops)
    block(:combinator => 'diagonal', :compositor => 'catenation') {
      regs = helper.call()
      regs = regs.reverse if flip_ops

      if taken then
        atomic {
          instr op, regs[0], regs[1], label_f(1)
          ILLEGAL()
        }
      else
        instr op, regs[0], regs[1], CRASH_LABEL()
      end
    }
  end

end
