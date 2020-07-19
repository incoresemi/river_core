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

require_relative '../../riscv_base'
require_relative '../../riscv_rand'

require_relative 'seq_alu'
require_relative 'seq_alu_rvc'
require_relative 'seq_branch'
require_relative 'seq_branch_rvc'
require_relative 'seq_fax'
require_relative 'seq_fdiv'
require_relative 'seq_fpmem'
require_relative 'seq_fpmem_rvc'
require_relative 'seq_fpu'
require_relative 'seq_mem'
require_relative 'seq_mem_rvc'
#require_relative 'seq_vector'

require_relative 'seq_xxx_data'
require_relative 'seq_xxx_regs'

#
# Description:
#
# This test template demonstrates how to generate random tests.
# It provides facilities that are similar to the ones of
# RISC-V Torture Test Generator (https://github.com/ucb-bar/riscv-torture).
#
class SeqXxxTemplate < RiscVBaseTemplate
  include RiscvRand

  include SeqAlu
  include SeqAluRvc
  include SeqBranch
  include SeqBranchRvc
  include SeqFax
  include SeqFdiv
  include SeqFpmem
  include SeqFpmemRvc
  include SeqFpu
  include SeqMem
  include SeqMemRvc
  #include SeqVector

  include SeqXxxData
  include SeqXxxRegs

  # Configuration settings
  SEQ_NUMBER = 1024
  SEQ_LENGTH = 256

  MEMSIZE = 4096

  USE_AMO = false
  USE_MUL = true
  USE_DIV = true

  def initialize
    super

    set_option_value 'reserve-dependencies', true
    set_option_value 'reserve-explicit', false
    set_option_value 'default-test-data', false
    set_option_value 'self-checks', false
  end

  def pre_rvtest
    RVTEST_RV64MF()
    RVTEST_CODE_BEGIN()
  end

  def pre_testdata
    XXX_DATA(MEMSIZE)
  end

  def run
    # Registers must be selected at random (taking into account existing reservations)
    set_default_allocator RANDOM

    block {
      prologue {
        # This register must be excluded as it is used as temp by initializers and finalizers.
        set_reserved sp, true

        #if is_rev('RV32V') then
        #  e32 = 0b010 # standard element width = 32
        #  m4 = 0b10 # the number of vector registers in a group = 4
        #  vsetvli t0, a0, e32, m4
        #end

        j :test_start
label :crash_backward
        j :test_end # FIXME: :fail
label :test_start
      }

      SEQ_LENGTH.times do
        next_random_sequence
      end

      epilogue {
        SAVE_XREGS()
        SAVE_FREGS()

        newline
        j :test_end
label :crash_forward
        j :test_end # FIXME: :fail
label :test_end
      }
    }.run SEQ_NUMBER
  end

  # Selects a random instruction sequence using the specified distribution.
  def next_random_sequence
    if not (defined? @sequence_distribution) then
      if is_rev('RV64M') then
        dist_seq_alu = range(:bias => 20, :value => lambda do seq_alu(USE_MUL, USE_DIV) end)
      end

      if is_rev('RV64C') then
        dist_seq_alu_rvc = range(:bias => 10, :value => lambda do seq_alu_rvc end)
      end

      if is_rev('RV32I') then
        dist_seq_branch = range(:bias => 15, :value => lambda do seq_branch end)
      end

      if is_rev('RV32C') then
        dist_seq_branch_rvc = range(:bias =>  5, :value => lambda do seq_branch_rvc end)
      end

      if is_rev('RV64D') && is_rev('RV64F') then
        dist_seq_fax = range(:bias =>  5, :value => lambda do seq_fax end)
      end

      if is_rev('RV64D') && is_rev('RV64F') then
        dist_seq_fdiv = range(:bias =>  5, :value => lambda do seq_fdiv end)
      end

      if is_rev('RV32D') && is_rev('RV32F') then
        dist_seq_fpmem = range(:bias =>  5, :value => lambda do seq_fpmem(MEMSIZE) end)
      end

      if is_rev('RV32FC') && is_rev('RV32DC') then
        dist_seq_fpmem_rvc = range(:bias =>  5, :value => lambda do seq_fpmem_rvc(MEMSIZE) end)
      end

      if is_rev('RV32F') then
        dist_seq_fpu = range(:bias => 10, :value => lambda do seq_fpu end)
      end

      if is_rev('RV64A') then
        dist_seq_mem = range(:bias => 15, :value => lambda do seq_mem(MEMSIZE, USE_AMO) end)
      end

      if is_rev('RV64C') then
        dist_seq_mem_rvc = range(:bias =>  5, :value => lambda do seq_mem_rvc(MEMSIZE) end)
      end

      #if is_rev('RV32V') then
      #  dist_seq_vector = range(:bias => 5, :value => lambda do seq_vector end)
      #end

      @sequence_distribution = dist(
          dist_seq_alu,
          dist_seq_alu_rvc,
          dist_seq_branch,
          dist_seq_branch_rvc,
          dist_seq_fax,
          dist_seq_fdiv,
          dist_seq_fpmem,
          dist_seq_fpmem_rvc,
          dist_seq_fpu,
          dist_seq_mem,
          dist_seq_mem_rvc
      #    dist_seq_vector
      )
    end
    @sequence_distribution.next_value.call
  end

end
