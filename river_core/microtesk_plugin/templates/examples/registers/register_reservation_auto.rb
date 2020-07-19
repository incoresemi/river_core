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

#
# Description:
#
# This test template demonstrates how to use the mechanism of automated register reservation.
# It helps handle situations when an instruction writes a value to be read by other instructions.
# In such situations, argument values must not be modified between the write and subsequent reads.
# That is corresponding registers must not be selected as output arguments until their values are
# read by all dependent instructions. To solve this task, registers shared between multiple
# instructions are automatically reserved after the first use for write until the last use.
# Reserved registers cannot be selected by the register allocator engine as output registers.
#
class RegisterReservationAutoTemplate < RiscVBaseTemplate

  def initialize
    super

    # Makes shared registers reserved between write and subsequent reads
    set_option_value 'reserve-dependencies', true
  end

  def run
    # Registers must be selected at random (taking into account existing reservations)
    set_default_allocator(RANDOM)

    data {
label :val_label
      dword 5
label :testnum_label
      dword 0
    }

    # Destination of all instructions is a random register that
    # is not used in this sequence.
    sequence {
      # The 'addr1' register is reserved from here.
      la addr1=x(_), :val_label

      if is_rev('RV64I') then
        # The 'testnum' register is reserved from here.
        ld testnum=x(_), addr1, 8
        addi testnum, testnum, 1
        sd testnum, addr1, 8
        # The 'testnum' register is no longer reserved from here.
      else
        lw testnum=x(_), addr1, 4
        addi testnum, testnum, 1
        sw testnum, addr1, 4
      end

      # Some operations with random registers.
      # The value of the 'addr1' register is preserved.
      add  x(_), x(_), x(_)
      sub  x(_), x(_), x(_)
      addi x(_), x(_), _
      slt  x(_), x(_), x(_)

      # The 'val1' register is reserved from here.
      if is_rev('RV64I') then
        ld val1=x(_), addr1, 0
      else
        lw val1=x(_), addr1, 0
      end

      # Some operations with random registers.
      # The value of the 'val1' register is preserved.
      # The value of the 'addr1' register is not preserved.
      And  x(_), x(_), x(_)
      Or   x(_), x(_), x(_)
      Xor  x(_), x(_), x(_)
      andi x(_), x(_), _

      ori val2=x(_), zero, 5
      beq val1, val2, :passed

      # Test fails if execution reaches here.
      if is_rev('RV64I') then
        ld_global TESTNUM(), :testnum_label
      else
        lw_global TESTNUM(), :testnum_label
      end
      RVTEST_FAIL()

label :passed
      nop
    }.run 10
  end

end
