#
# Copyright 2017-2019 ISP RAS (http://www.ispras.ru)
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

require_relative '../riscv_base'

#
# Description:
#
# This small tests for RV32F instructions.
#
class InstructionRV32F2 < RiscVBaseTemplate
  def TEST_DATA
    data {
        label :operan1_1
            float 2.5
        label :operan1_2
            float 1.0
        label :result1
            float 3.5

        label :operan2_1
            float -1235.1
        label :operan2_2
            float 1.1
        label :result2
            float -1234.0

        label :operan3_1
            float 3.14159265
        label :operan3_2
            float 0.00000001
        label :result3
            float 3.14159265

        label :operan1_1sub
            float 2.5
        label :operan1_2sub
            float 1.0
        label :result1sub
            float 1.5

        label :operan2_1sub
            float -1235.1
        label :operan2_2sub
            float -1.1
        label :result2sub
            float -1234.0

        label :operan3_1sub
            float 3.14159265
        label :operan3_2sub
            float 0.00000001
        label :result3sub
            float 3.14159265

        label :operan1_1mul
            float 2.5
        label :operan1_2mul
            float 1.0
        label :result1mul
            float 2.5

        label :operan2_1mul
            float -1235.1
        label :operan2_2mul
            float -1.1
        label :result2mul
            float 1358.61

        label :operan3_1mul
            float 3.14159265
        label :operan3_2mul
            float 0.00000001
        label :result3mul
            float 3.14159265e-8

        label :operan1NaN
            float INFF
        label :operan2NaN
            float INFF
        label :resultNaN
            float QNANF
   }
  end

  def run
    trace "Run RV32F instruction:"
    nop

    flw_global ft0, :operan1_1, a0
    trace "ft0: %x", FPR(0)
    trace "a0 = %x", XREG(10)

    flw ft0, a0, -100
    trace "ft0: %x", FPR(0)

    lw_global s0, :operan1_1
    trace "s0 = %x", XREG(8)

    # --- Test 01 for add ---
    flw_global ft0, :operan1_1, a0
    flw_global ft1, :operan1_2, a0
    fadd_s ft2, ft1, ft0
    trace "ft0: %x", FPR(0)
    trace "ft1: %x", FPR(1)
    trace "ft2: %x", FPR(2)
    flw_global ft3, :result1, a0
    trace "ft3: %x", FPR(3)

    feq_s a0, ft2, ft3
    trace "a0 => %x == 1", XREG(10)

    # --- Test 02 for add ---
    flw_global ft0, :operan2_1, a0
    flw_global ft1, :operan2_2, a0
    fadd_s ft2, ft1, ft0
    trace "ft0: %x", FPR(0)
    trace "ft1: %x", FPR(1)
    trace "ft2: %x", FPR(2)
    flw_global ft3, :result2, a0
    trace "ft3: %x", FPR(3)

    feq_s a0, ft2, ft3
    trace "a0 => %x == 1", XREG(10)

    # --- Test 03 for add ---
    flw_global ft0, :operan3_1, a0
    flw_global ft1, :operan3_2, a0
    fadd_s ft2, ft1, ft0
    trace "ft0: %x", FPR(0)
    trace "ft1: %x", FPR(1)
    trace "ft2: %x", FPR(2)
    flw_global ft3, :result3, a0
    trace "ft3: %x", FPR(3)

    feq_s a0, ft2, ft3
    trace "a0 => %x == 1", XREG(10)

    # --- Test 01 for sub ---
    flw_global ft0, :operan1_1sub, a0
    flw_global ft1, :operan1_2sub, a0
    fsub_s ft2, ft0, ft1
    trace "sub ft0: %x", FPR(0)
    trace "sub ft1: %x", FPR(1)
    trace "sub ft2: %x", FPR(2)
    flw_global ft3, :result1sub, a0
    trace "sub ft3: %x", FPR(3)

    feq_s a0, ft2, ft3
    trace "a0 => %x == 1", XREG(10)

    # --- Test 02 for sub ---
    flw_global ft0, :operan2_1sub, a0
    flw_global ft1, :operan2_2sub, a0
    fsub_s ft2, ft0, ft1
    trace "sub ft0: %x", FPR(0)
    trace "sub ft1: %x", FPR(1)
    trace "sub ft2: %x", FPR(2)
    flw_global ft3, :result2sub, a0
    trace "sub ft3: %x", FPR(3)

    feq_s a0, ft2, ft3
    trace "a0 => %x == 1", XREG(10)

    # --- Test 03 for sub ---
    flw_global ft0, :operan3_1sub, a0
    flw_global ft1, :operan3_2sub, a0
    fsub_s ft2, ft0, ft1
    trace "sub ft0: %x", FPR(0)
    trace "sub ft1: %x", FPR(1)
    trace "sub ft2: %x", FPR(2)
    flw_global ft3, :result3sub, a0
    trace "sub ft3: %x", FPR(3)

    feq_s a0, ft2, ft3
    trace "a0 => %x == 1", XREG(10)

    # --- Test 01 for mul ---
    flw_global ft0, :operan1_1mul, a0
    flw_global ft1, :operan1_2mul, a0
    fmul_s ft2, ft0, ft1
    trace "mul ft0: %x", FPR(0)
    trace "mul ft1: %x", FPR(1)
    trace "mul ft2: %x", FPR(2)
    flw_global ft3, :result1mul, a0
    trace "mul ft3: %x", FPR(3)

    feq_s a0, ft2, ft3
    trace "a0 => %x == 1", XREG(10)

    # --- Test 02 for mul ---
    flw_global ft0, :operan2_1mul, a0
    flw_global ft1, :operan2_2mul, a0
    fmul_s ft2, ft0, ft1
    trace "mul ft0: %x", FPR(0)
    trace "mul ft1: %x", FPR(1)
    trace "mul ft2: %x", FPR(2)
    flw_global ft3, :result2mul, a0
    trace "mul ft3: %x", FPR(3)

    feq_s a0, ft2, ft3
    trace "a0 => %x == 1", XREG(10)

    # --- Test 03 for mul ---
    flw_global ft0, :operan3_1mul, a0
    flw_global ft1, :operan3_2mul, a0
    fmul_s ft2, ft0, ft1
    trace "mul ft0: %x", FPR(0)
    trace "mul ft1: %x", FPR(1)
    trace "mul ft2: %x", FPR(2)
    flw_global ft3, :result3mul, a0
    trace "mul ft3: %x", FPR(3)

    feq_s a0, ft2, ft3
    trace "a0 => %x == 1", XREG(10)

    # --- Test for compare instructions ---
    feq_s a0, ft2, ft3
    trace "a0 => %x == 1", XREG(10)
    fle_s a0, ft2, ft3
    trace "a0 => %x == 1", XREG(10)
    flt_s a0, ft2, ft3
    trace "a0 => %x == 1", XREG(10)

    feq_s a0, ft0, ft1
    trace "a0 => %x == 1", XREG(10)
    fle_s a0, ft0, ft1
    trace "a0 => %x == 1", XREG(10)
    flt_s a0, ft0, ft1
    trace "a0 => %x == 1", XREG(10)
    flt_s a0, ft1, ft0
    trace "a0 => %x == 1", XREG(10)

    # --- Test for NaN ---
    flw_global ft0, :operan1NaN, a0
    flw_global ft1, :operan2NaN, a0
    fsub_s ft2, ft0, ft1
    trace "sub ft0: %x", FPR(0)
    trace "sub ft1: %x", FPR(1)
    trace "sub ft2: %x", FPR(2)
    flw_global ft3, :resultNaN, a0
    trace "sub ft3: %x", FPR(3)

    feq_s a0, ft2, ft3
    trace "a0 => %x == 1", XREG(10)

    # --- Test for fadd ---
	li64 gp, 0x2
	la a0, :operan1_1
	flw ft0, a0, 0
	flw ft1, a0, 4
	flw ft2, a0, 8
    trace "ft0: %x", FPR(0)
    trace "ft1: %x", FPR(1)
    trace "ft2: %x", FPR(2)
	lw  a3, a0, 8
    trace "a3 => %x == 1", XREG(13)

	fadd_s ft3, ft0, ft1
	fmv_x_w a0, ft3
    trace "a0 => %x == 1", XREG(10)

	fsflags a1, zero
	li a2, 0x0
	bne a0, a3, :debug_fail
    trace "a1 => %x == 1", XREG(11)
    trace "a2 => %x == 1", XREG(12)
	bne a1, a2, :debug_fail

    label :debug_fail
    nop

    nop
    nop
  end

end
