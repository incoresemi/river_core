#
# Copyright 2018 ISP RAS (http://www.ispras.ru)
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
# THIS FILE IS BASED ON THE FOLLOWING RISC-V TEST SUITE HEADER:
# https://github.com/riscv/riscv-tests/blob/master/isa/macros/scalar/test_macros.h
# WHICH IS DISTRIBUTED UNDER THE FOLLOWING LICENSE:
#
# Copyright (c) 2012-2015, The Regents of the University of California (Regents).
# All Rights Reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
# 3. Neither the name of the Regents nor the
#    names of its contributors may be used to endorse or promote products
#    derived from this software without specific prior written permission.
#
# IN NO EVENT SHALL REGENTS BE LIABLE TO ANY PARTY FOR DIRECT, INDIRECT,
# SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES, INCLUDING LOST PROFITS, ARISING
# OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF REGENTS HAS
# BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# REGENTS SPECIFICALLY DISCLAIMS ANY WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
# THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE. THE SOFTWARE AND ACCOMPANYING DOCUMENTATION, IF ANY, PROVIDED
# HEREUNDER IS PROVIDED "AS IS". REGENTS HAS NO OBLIGATION TO PROVIDE
# MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
#

module RiscvTestMacros

  ##################################################################################################
  # Helper macros
  ##################################################################################################

  def __riscv_xlen
    if is_rev('RV64I') then 64 else 32 end
  end

  def MASK_XLEN(x)
    ((x) & ((1 << (__riscv_xlen - 1) << 1) - 1))
  end

  def TEST_CASE( testnum, testreg, correctval, &code)
label :"test_#{testnum}"
    self.instance_eval &code
    li x29, MASK_XLEN(correctval)
    li TESTNUM(), testnum
    trace("Check: testreg(0x%016x) == x29(0x%016x)", testreg, x29)
    bne testreg, x29, :fail
  end

  # We use a macro hack to simplify code generation for various numbers
  # of bubble cycles.

  def TEST_INSERT_NOPS(n)
    n.times do
      nop
    end
  end

  ##################################################################################################
  # RV64UI MACROS
  ##################################################################################################

  ##################################################################################################
  # Tests for instructions with immediate operand
  ##################################################################################################

  def SEXT_IMM(x)
    ((x) | (-(((x) >> 11) & 1) << 11))
  end

  def TEST_IMM_OP(testnum, inst, result, val1, imm)
    TEST_CASE(testnum, x30, result) do
      li x1, MASK_XLEN(val1)
      self.send :"#{inst}", x30, x1, SEXT_IMM(imm)
    end
  end

  def TEST_IMM_SRC1_EQ_DEST(testnum, inst, result, val1, imm)
    TEST_CASE(testnum, x1, result) do
      li x1, MASK_XLEN(val1)
      self.send :"#{inst}", x1, x1, SEXT_IMM(imm)
    end
  end

  def TEST_IMM_DEST_BYPASS(testnum, nop_cycles, inst, result, val1, imm)
    TEST_CASE(testnum, x6, result) do
      li x4, 0
label 1
      li x1, MASK_XLEN(val1)
      self.send :"#{inst}", x30, x1, SEXT_IMM(imm)
      TEST_INSERT_NOPS(nop_cycles)
      addi x6, x30, 0
      addi x4, x4, 1
      li x5, 2
      bne x4, x5, label_b(1)
    end
  end

  def TEST_IMM_SRC1_BYPASS(testnum, nop_cycles, inst, result, val1, imm)
    TEST_CASE(testnum, x30, result) do
      li x4, 0
label 1
      li x1, MASK_XLEN(val1)
      TEST_INSERT_NOPS(nop_cycles)
      self.send :"#{inst}", x30, x1, SEXT_IMM(imm)
      addi x4, x4, 1
      li x5, 2
      bne x4, x5, label_b(1)
    end
  end

  def TEST_IMM_ZEROSRC1(testnum, inst, result, imm)
    TEST_CASE(testnum, x1, result) do
      self.send :"#{inst}", x1, x0, SEXT_IMM(imm)
    end
  end

  def TEST_IMM_ZERODEST(testnum, inst, val1, imm)
    TEST_CASE(testnum, x0, 0) do
      li x1, MASK_XLEN(val1)
      self.send :"#{inst}", x0, x1, SEXT_IMM(imm)
    end
  end

  ##################################################################################################
  # Tests for an instruction with register operands
  ##################################################################################################

  def TEST_R_OP(testnum, inst, result, val1)
    TEST_CASE(testnum, x30, result) do
      li x1, val1
      self.send :"#{inst}", x30, x1
     end
  end

  def TEST_R_SRC1_EQ_DEST(testnum, inst, result, val1)
    TEST_CASE(testnum, x1, result) do
      li x1, val1
      self.send :"#{inst}", x1, x1
    end
  end

  def TEST_R_DEST_BYPASS(testnum, nop_cycles, inst, result, val1)
    TEST_CASE(testnum, x6, result) do
      li x4, 0
label 1
      li x1, val1
      self.send :"#{inst}", x30, x1
      TEST_INSERT_NOPS(nop_cycles)
      addi x6, x30, 0
      addi x4, x4, 1
      li x5, 2
      bne x4, x5, label_b(1)
    end
  end

  ##################################################################################################
  # Tests for an instruction with register-register operands
  ##################################################################################################

  def TEST_RR_OP(testnum, inst, result, val1, val2)
    TEST_CASE( testnum, x30, result) do
      li x1, MASK_XLEN(val1)
      li x2, MASK_XLEN(val2)
      self.send :"#{inst}", x30, x1, x2
    end
  end

  def TEST_RR_SRC1_EQ_DEST(testnum, inst, result, val1, val2)
    TEST_CASE(testnum, x1, result) do
      li x1, MASK_XLEN(val1)
      li x2, MASK_XLEN(val2)
      self.send :"#{inst}", x1, x1, x2
    end
  end

  def TEST_RR_SRC2_EQ_DEST(testnum, inst, result, val1, val2)
    TEST_CASE(testnum, x2, result) do
      li x1, MASK_XLEN(val1)
      li x2, MASK_XLEN(val2)
      self.send :"#{inst}", x2, x1, x2
    end
  end

  def TEST_RR_SRC12_EQ_DEST(testnum, inst, result, val1)
    TEST_CASE(testnum, x1, result) do
      li x1, MASK_XLEN(val1)
      self.send :"#{inst}", x1, x1, x1
    end
  end

  def TEST_RR_DEST_BYPASS(testnum, nop_cycles, inst, result, val1, val2)
    TEST_CASE(testnum, x6, result) do
      li x4, 0
label 1
      li x1, MASK_XLEN(val1)
      li x2, MASK_XLEN(val2)
      self.send :"#{inst}", x30, x1, x2
      TEST_INSERT_NOPS(nop_cycles)
      addi x6, x30, 0
      addi x4, x4, 1
      li x5, 2
      bne x4, x5, label_b(1)
    end
  end

  def TEST_RR_SRC12_BYPASS(testnum, src1_nops, src2_nops, inst, result, val1, val2)
    TEST_CASE(testnum, x30, result) do
      li x4, 0
label 1
      li x1, MASK_XLEN(val1)
      TEST_INSERT_NOPS(src1_nops)
      li x2, MASK_XLEN(val2)
      TEST_INSERT_NOPS(src2_nops)
      self.send :"#{inst}", x30, x1, x2
      addi x4, x4, 1
      li x5, 2
      bne x4, x5, label_b(1)
    end
  end

  def TEST_RR_SRC21_BYPASS(testnum, src1_nops, src2_nops, inst, result, val1, val2)
    TEST_CASE(testnum, x30, result) do
      li x4, 0
label 1
      li x2, MASK_XLEN(val2)
      TEST_INSERT_NOPS(src1_nops)
      li x1, MASK_XLEN(val1)
      TEST_INSERT_NOPS(src2_nops)
      self.send :"#{inst}", x30, x1, x2
      addi x4, x4, 1
      li x5, 2
      bne x4, x5, label_b(1)
    end
  end

  def TEST_RR_ZEROSRC1(testnum, inst, result, val)
    TEST_CASE(testnum, x2, result) do
      li x1, MASK_XLEN(val)
      self.send :"#{inst}", x2, x0, x1
    end
  end

  def TEST_RR_ZEROSRC2(testnum, inst, result, val)
    TEST_CASE( testnum, x2, result) do
      li x1, MASK_XLEN(val)
      self.send :"#{inst}", x2, x1, x0
    end
  end

  def TEST_RR_ZEROSRC12(testnum, inst, result)
    TEST_CASE(testnum, x1, result) do
      self.send :"#{inst}", x1, x0, x0
    end
  end

  def TEST_RR_ZERODEST(testnum, inst, val1, val2)
    TEST_CASE(testnum, x0, 0) do
      li x1, MASK_XLEN(val1)
      li x2, MASK_XLEN(val2)
      self.send :"#{inst}", x0, x1, x2
    end
  end

  ##################################################################################################
  # Test memory instructions
  ##################################################################################################

  def TEST_LD_OP(testnum, inst, result, offset, base)
    TEST_CASE(testnum, x30, result) do
      la  x1, base
      self.send :"#{inst}", x30, x1, offset
    end
  end

  def TEST_ST_OP(testnum, load_inst, store_inst, result, offset, base)
    TEST_CASE( testnum, x30, result) do
      la x1, base
      li x2, result
      self.send :"#{store_inst}", x2, x1, offset
      self.send :"#{load_inst}", x30, x1, offset
    end
  end

  def TEST_LD_DEST_BYPASS(testnum, nop_cycles, inst, result, offset, base)
label :"test_#{testnum}"
    li TESTNUM(), testnum
    li x4, 0
label 1
    la x1, base
    self.send :"#{inst}", x30, x1, offset
    TEST_INSERT_NOPS(nop_cycles)
    addi x6, x30, 0
    li x29, result
    trace("Check: x6(0x%016x) == x29(0x%016x)", x6, x29)
    bne x6, x29, :fail
    addi x4, x4, 1
    li x5, 2
    bne x4, x5, label_b(1)
  end

  def TEST_LD_SRC1_BYPASS( testnum, nop_cycles, inst, result, offset, base)
label :"test_#{testnum}"
    li TESTNUM(), testnum
    li x4, 0
label 1
    la x1, base
    TEST_INSERT_NOPS(nop_cycles)
    self.send :"#{inst}", x30, x1, offset
    li x29, result
    trace("Check: x30(0x%016x) == x29(0x%016x)", x30, x29)
    bne x30, x29, :fail
    addi x4, x4, 1
    li x5, 2
    bne x4, x5, label_b(1)
  end

  def TEST_ST_SRC12_BYPASS(
    testnum,
    src1_nops,
    src2_nops,
    load_inst,
    store_inst,
    result,
    offset,
    base
    )
label :"test_#{testnum}"
    li TESTNUM(), testnum
    li x4, 0
label 1
    li x1, result
    TEST_INSERT_NOPS(src1_nops)
    la x2, base
    TEST_INSERT_NOPS(src2_nops)
    self.send :"#{store_inst}", x1, x2, offset
    self.send :"#{load_inst}", x30, x2, offset
    li x29, result
    trace("Check: x30(0x%016x) == x29(0x%016x)", x30, x29)
    bne x30, x29, :fail
    addi x4, x4, 1
    li x5, 2
    bne x4, x5, label_b(1)
  end

  def TEST_ST_SRC21_BYPASS(
    testnum,
    src1_nops,
    src2_nops,
    load_inst,
    store_inst,
    result,
    offset,
    base
    )
label :"test_#{testnum}"
    li TESTNUM(), testnum
    li x4, 0
label 1
    la x2, base
    TEST_INSERT_NOPS(src1_nops)
    li x1, result
    TEST_INSERT_NOPS(src2_nops)
    self.send :"#{store_inst}", x1, x2, offset
    self.send :"#{load_inst}", x30, x2, offset
    li x29, result
    trace("Check: x30(0x%016x) == x29(0x%016x)", x30, x29)
    bne x30, x29, :fail
    addi x4, x4, 1
    li x5, 2
    bne x4, x5, label_b(1)
  end

  def TEST_BR2_OP_TAKEN(testnum, inst, val1, val2)
label :"test_#{testnum}"
    li TESTNUM(), testnum
    li x1, val1
    li x2, val2
    self.send :"#{inst}", x1, x2, label_f(2)
    trace("Check: x0(0x%016x) == TESTNUM(0x%016x)", x0, TESTNUM())
    bne x0, TESTNUM(), :fail
label 1
    bne x0, TESTNUM(), label_f(3)
label 2
    self.send :"#{inst}", x1, x2, label_b(1)
    trace("Check: x0(0x%016x) == TESTNUM(0x%016x)", x0, TESTNUM())
    bne x0, TESTNUM(), :fail
label 3
  end

  def TEST_BR2_OP_NOTTAKEN(testnum, inst, val1, val2)
label :"test_#{testnum}"
    li TESTNUM(), testnum
    li x1, val1
    li x2, val2
    self.send :"#{inst}", x1, x2, label_f(1)
    bne x0, TESTNUM(), label_f(2)
label 1
    trace("Check: x0(0x%016x) == TESTNUM(0x%016x)", x0, TESTNUM())
    bne x0, TESTNUM(), :fail
label 2
    self.send :"#{inst}", x1, x2, label_b(1)
label 3
  end

  def TEST_BR2_SRC12_BYPASS(testnum, src1_nops, src2_nops, inst, val1, val2)
label :"test_#{testnum}"
    li TESTNUM(), testnum
    li x4, 0
label 1
    li x1, val1
    TEST_INSERT_NOPS(src1_nops)
    li x2, val2
    TEST_INSERT_NOPS(src2_nops)
    trace("Check: x1(0x%016x) vs. x2(0x%016x)", x1, x2)
    self.send :"#{inst}", x1, x2, :fail
    addi x4, x4, 1
    li x5, 2
    bne x4, x5, label_b(1)
  end

  def TEST_BR2_SRC21_BYPASS(testnum, src1_nops, src2_nops, inst, val1, val2)
label :"test_#{testnum}"
    li TESTNUM(), testnum
    li x4, 0
label 1
    li x2, val2
    TEST_INSERT_NOPS(src1_nops)
    li x1, val1
    TEST_INSERT_NOPS(src2_nops)
    trace("Check: x1(0x%016x) vs. x2(0x%016x)", x1, x2)
    self.send :"#{inst}", x1, x2, :fail
    addi x4, x4, 1
    li x5, 2
    bne x4, x5, label_b(1)
  end

  ##################################################################################################
  # Test jump instructions
  ##################################################################################################

  def TEST_JR_SRC1_BYPASS(testnum, nop_cycles, inst)
label :"test_#{testnum}"
    li TESTNUM(), testnum
    li x4, 0
label 1
    la x6, label_f(2)
    TEST_INSERT_NOPS(nop_cycles)
    self.send :"#{inst}", x6
    trace("Check: x0(0x%016x) == TESTNUM(0x%016x)", x0, TESTNUM())
    bne x0, TESTNUM(), :fail
label 2
    addi x4, x4, 1
    li x5, 2
    bne x4, x5, label_b(1)
  end

  def TEST_JALR_SRC1_BYPASS(testnum, nop_cycles, inst)
label :"test_#{testnum}"
    li TESTNUM(), testnum
    li x4, 0
label 1
    la x6, label_f(2)
    TEST_INSERT_NOPS(nop_cycles)
    self.send :"#{inst}", x19, x6, 0
    trace("Check: x0(0x%016x) == TESTNUM(0x%016x)", x0, TESTNUM())
    bne x0, TESTNUM(), :fail
label 2
    addi x4, x4, 1
    li x5, 2
    bne x4, x5, label_b(1)
  end

  ##################################################################################################
  # RV64UF MACROS
  ##################################################################################################

  ##################################################################################################
  # Tests floating-point instructions
  ##################################################################################################

  def TEST_FP_OP_S_INTERNAL( testnum, flags, result, val1, val2, val3, &code )
label :"test_#{testnum}"
    li TESTNUM(), testnum
    la a0, :"test_#{testnum}_data"

    flw f0, a0, 0
    flw f1, a0, 4
    flw f2, a0, 8
    lw  a3, a0, 12

    self.instance_eval &code

    fsflags a1, x0
    li a2, flags

    trace("Check: a0(0x%016x) == a3(0x%016x)", a0, a3)
    bne a0, a3, :fail
    trace("Check: a1(0x%016x) == a2(0x%016x)", a1, a2)
    bne a1, a2, :fail

    data {
     align 2
label :"test_#{testnum}_data"
      float val1
      float val2
      float val3
      self.instance_eval &result
    }
  end

  def TEST_FP_OP_D_INTERNAL( testnum, flags, result, val1, val2, val3, &code )
label :"test_#{testnum}"
    li TESTNUM(), testnum
    la a0, :"test_#{testnum}_data"

    fld f0, a0, 0
    fld f1, a0, 8
    fld f2, a0, 16
    ld  a3, a0, 24

    self.instance_eval &code

    fsflags a1, x0
    li a2, flags

    trace("Check: a0(0x%016x) == a3(0x%016x)", a0, a3)
    bne a0, a3, :fail
    trace("Check: a1(0x%016x) == a2(0x%016x)", a1, a2)
    bne a1, a2, :fail

    data {
      align 3
label :"test_#{testnum}_data"
      double val1
      double val2
      double val3
      self.instance_eval &result
    }
  end

  # // TODO: assign a separate mem location for the comparison address?
  def TEST_FP_OP_D32_INTERNAL( testnum, flags, result, val1, val2, val3, &code )
label :"test_#{testnum}"
    li TESTNUM(), testnum
    la a0, :"test_#{testnum}_data"

    fld f0, a0, 0
    fld f1, a0, 8
    fld f2, a0, 16
    lw  a3, a0, 24
    lw  t1, a0, 28

    self.instance_eval &code

    fsflags a1, x0
    li a2, flags

    trace("Check: a0(0x%016x) == a3(0x%016x)", a0, a3)
    bne a0, a3, :fail
    trace("Check: t1(0x%016x) == t2(0x%016x)", t1, t2)
    bne t1, t2, :fail
    trace("Check: a1(0x%016x) == a2(0x%016x)", a1, a2)
    bne a1, a2, :fail

    data {
      align 3
label :"test_#{testnum}_data"
      double val1
      double val2
      double val3
      self.instance_eval &result
    }
  end

  def TEST_FCVT_S_D32( testnum, result, val1 )
    TEST_FP_OP_D32_INTERNAL( testnum, 0, Proc.new { double result }, val1, 0.0, 0.0 ) do
      fcvt_s_d f3, f0
      fcvt_d_s f3, f3
      fsd f3, a0, 0
      lw t2, a0, 4
      lw a0, a0, 0
    end
  end

  def TEST_FCVT_S_D( testnum, result, val1 )
    TEST_FP_OP_D_INTERNAL( testnum, 0, Proc.new { double result }, val1, 0.0, 0.0 ) do
      fcvt_s_d f3, f0
      fcvt_d_s f3, f3
      fmv_x_d a0, f3
    end
  end

  def TEST_FCVT_D_S( testnum, result, val1 )
    TEST_FP_OP_S_INTERNAL( testnum, 0, Proc.new { float result }, val1, 0.0, 0.0 ) do
      fcvt_d_s f3, f0
      fcvt_s_d f3, f3
      fmv_x_w a0, f3
    end
  end

  def TEST_FP_OP1_S( testnum, inst, flags, result, val1 )
    TEST_FP_OP_S_INTERNAL( testnum, flags, Proc.new { float result }, val1, 0.0, 0.0 ) do
      self.send :"#{inst}", f3, f0
      fmv_x_w a0, f3
    end
  end

  def TEST_FP_OP1_D32( testnum, inst, flags, result, val1 )
    TEST_FP_OP_D32_INTERNAL( testnum, flags, Proc.new { double result }, val1, 0.0, 0.0 ) do
      self.send :"#{inst}", f3, f0
      fsd f3, a0, 0
      lw t2, a0, 4
      lw a0, a0, 0
    end
    # // ^: store computation result in address from a0, load high-word into t2
  end

  def TEST_FP_OP1_D( testnum, inst, flags, result, val1 )
    TEST_FP_OP_D_INTERNAL( testnum, flags, Proc.new { double result }, val1, 0.0, 0.0 ) do
      self.send :"#{inst}", f3, f0
      fmv_x_d a0, f3
    end
  end

  def TEST_FP_OP1_S_DWORD_RESULT( testnum, inst, flags, result, val1 )
    TEST_FP_OP_S_INTERNAL( testnum, flags, Proc.new { dword result }, val1, 0.0, 0.0 ) do
      self.send :"#{inst}", f3, f0
      fmv_x_w a0, f3
    end
  end

  def TEST_FP_OP1_D32_DWORD_RESULT( testnum, inst, flags, result, val1 )
    TEST_FP_OP_D32_INTERNAL( testnum, flags, Proc.new { dword result }, val1, 0.0, 0.0 ) do
      self.send :"#{inst}", f3, f0
      fsd f3, a0, 0
      lw t2, a0, 4
      lw a0, a0, 0
    end
    # // ^: store computation result in address from a0, load high-word into t2
  end

  def TEST_FP_OP1_D_DWORD_RESULT( testnum, inst, flags, result, val1 )
    TEST_FP_OP_D_INTERNAL( testnum, flags, Proc.new { dword result }, val1, 0.0, 0.0 ) do
      self.send :"#{inst}", f3, f0
      fmv_x_d a0, f3
    end
  end

  def TEST_FP_OP2_S( testnum, inst, flags, result, val1, val2 )
    TEST_FP_OP_S_INTERNAL( testnum, flags, Proc.new { float result }, val1, val2, 0.0 ) do
      self.send :"#{inst}", f3, f0, f1
      fmv_x_w a0, f3
    end
  end

  def TEST_FP_OP2_D32( testnum, inst, flags, result, val1, val2 )
    TEST_FP_OP_D32_INTERNAL( testnum, flags, Proc.new { double result }, val1, val2, 0.0 ) do
      self.send :"#{inst}", f3, f0, f1
      fsd f3, a0, 0
      lw t2, a0, 4
      lw a0, a0, 0
    end
    # // ^: store computation result in address from a0, load high-word into t2
  end

  def TEST_FP_OP2_D( testnum, inst, flags, result, val1, val2 )
    TEST_FP_OP_D_INTERNAL( testnum, flags, Proc.new { double result }, val1, val2, 0.0 ) do
      self.send :"#{inst}", f3, f0, f1
      fmv_x_d a0, f3
    end
  end

  def TEST_FP_OP3_S( testnum, inst, flags, result, val1, val2, val3 )
    TEST_FP_OP_S_INTERNAL( testnum, flags, Proc.new { float result }, val1, val2, val3 ) do
      self.send :"#{inst}", f3, f0, f1, f2
      fmv_x_w a0, f3
    end
  end

  def TEST_FP_OP3_D32( testnum, inst, flags, result, val1, val2, val3 )
    TEST_FP_OP_D32_INTERNAL( testnum, flags, Proc.new { double result }, val1, val2, val3 ) do
      self.send :"#{inst}", f3, f0, f1, f2
      fsd f3, a0, 0
      lw t2, a0, 4
      lw a0, a0, 0
    end
    # // ^: store computation result in address from a0, load high-word into t2
  end

  def TEST_FP_OP3_D( testnum, inst, flags, result, val1, val2, val3 )
    TEST_FP_OP_D_INTERNAL( testnum, flags, Proc.new { double result }, val1, val2, val3 ) do
      self.send :"#{inst}", f3, f0, f1, f2
      fmv_x_d a0, f3
    end
  end

  def TEST_FP_INT_OP_S( testnum, inst, flags, result, val1, rm )
    TEST_FP_OP_S_INTERNAL( testnum, flags, Proc.new { word result }, val1, 0.0, 0.0 ) do
      self.send :"#{inst}", a0, f0, rm
    end
  end

  def TEST_FP_INT_OP_D32( testnum, inst, flags, result, val1, rm )
    TEST_FP_OP_D32_INTERNAL( testnum, flags, Proc.new { dword result }, val1, 0.0, 0.0 ) do
      self.send :"#{inst}", a0, f0, f1
      li t2, 0
    end
  end

  def TEST_FP_INT_OP_D( testnum, inst, flags, result, val1, rm )
    TEST_FP_OP_D_INTERNAL( testnum, flags, Proc.new { dword result }, val1, 0.0, 0.0 ) do
      self.send :"#{inst}", a0, f0, rm
    end
  end

  def TEST_FP_CMP_OP_S( testnum, inst, flags, result, val1, val2 )
    TEST_FP_OP_S_INTERNAL( testnum, flags, Proc.new { word result }, val1, val2, 0.0 ) do
      self.send :"#{inst}", a0, f0, f1
    end
  end

  def TEST_FP_CMP_OP_D32( testnum, inst, flags, result, val1, val2 )
    TEST_FP_OP_D32_INTERNAL( testnum, flags, Proc.new { dword result }, val1, val2, 0.0 ) do
      self.send :"#{inst}", a0, f0, f1
      li t2, 0
    end
  end

  def TEST_FP_CMP_OP_D( testnum, inst, flags, result, val1, val2 )
    TEST_FP_OP_D_INTERNAL( testnum, flags, Proc.new { dword result }, val1, val2, 0.0 ) do
      self.send :"#{inst}", a0, f0, f1
    end
  end

  def TEST_FCLASS_S( testnum, correct, input )
    TEST_CASE( testnum, a0, correct ) do
      li a0, input
      fmv_w_x fa0, a0
      fclass_s a0, fa0
    end
  end

  def TEST_FCLASS_D32( testnum, correct, input )
    TEST_CASE( testnum, a0, correct ) do
      la a0, :"test_#{testnum}_data"
      fld fa0, a0, 0
      fclass_d a0, fa0
    end

    data {
      align 3
label :"test_#{testnum}_data"
      dword input
    }
  end

  def TEST_FCLASS_D(testnum, correct, input)
    TEST_CASE( testnum, a0, correct ) do
      li a0, input
      fmv_d_x fa0, a0
      fclass_d a0, fa0
    end
  end

  def TEST_INT_FP_OP_S( testnum, inst, result, val1 )
label :"test_#{testnum}"
    li TESTNUM(), testnum
    la a0, :"test_#{testnum}_data"

    lw a3, a0, 0
    li a0, val1
    self.send :"#{inst}", f0, a0

    fsflags2 x0
    fmv_x_w a0, f0
    trace("Check: a0(0x%016x) == a3(0x%016x)", a0, a3)
    bne a0, a3, :fail

    data {
      align 2
label :"test_#{testnum}_data"
      float result
    }
  end

  def TEST_INT_FP_OP_D32( testnum, inst, result, val1 )
label :"test_#{testnum}"
    li TESTNUM(), testnum
    la a0, :"test_#{testnum}_data"

    lw a3, a0, 0
    lw a4, a0, 4
    li a1, val1
    self.send :"#{inst}", f0, a1

    fsd f0, a0, 0
    lw a1, a0, 4
    lw a0, a0, 0

    fsflags2 x0
    trace("Check: a0(0x%016x) == a3(0x%016x)", a0, a3)
    bne a0, a3, :fail
    trace("Check: a1(0x%016x) == a4(0x%016x)", a1, a4)
    bne a1, a4, :fail

    data {
      align 3
label :"test_#{testnum}_data"
      double result
    }
  end

  def TEST_INT_FP_OP_D( testnum, inst, result, val1 )
label :"test_#{testnum}"
    li TESTNUM(), testnum
    la a0, :"test_#{testnum}_data"

    ld a3, a0, 0
    li a0, val1
    self.send :"#{inst}", f0, a0
    fsflags2 x0
    fmv_x_d a0, f0
    trace("Check: a0(0x%016x) == a3(0x%016x)", a0, a3)
    bne a0, a3, :fail

    data {
      align 3
label :"test_#{testnum}_data"
      double result
    }
  end

  # // We need some special handling here to allow 64-bit comparison in 32-bit arch
  # // TODO: find a better name and clean up when intended for general usage?
  def TEST_CASE_D32( testnum, testreg1, testreg2, correctval, &code )
label :"test_#{testnum}"
    self.instance_eval &code

    la x31, :"test_#{testnum}_data"
    lw x29, x31, 0
    lw x31, x31, 4

    li TESTNUM(), testnum
    trace("Check: testreg1(0x%016x) == x29(0x%016x)", testreg1, x29)
    bne testreg1, x29, :fail
    trace("Check: testreg2(0x%016x) == x31(0x%016x)", testreg2, x31)
    bne testreg2, x31, :fail

    data {
      align 3
label :"test_#{testnum}_data"
      dword correctval
    }
  end
  # // ^ x30 is used in some other macros, to avoid issues we use x31 for upper word

  ##################################################################################################
  # Pass and fail code (assumes test num is in TESTNUM)
  ##################################################################################################

  def TEST_PASSFAIL
    trace("Check: x0(0x%016x) != TESTNUM(0x%016x)", x0, TESTNUM())
    bne x0, TESTNUM(), :pass
label :fail
    RVTEST_FAIL()
label :pass
    RVTEST_PASS()
  end

  ##################################################################################################
  # Test data section
  ##################################################################################################

  def TEST_DATA
  end

end
