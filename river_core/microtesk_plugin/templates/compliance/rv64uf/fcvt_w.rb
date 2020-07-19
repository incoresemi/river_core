#
# Copyright 2018 ISP RAS (http://www.ispras.ru)
#
# Licensed under the Apache License, Version 2.0 (the "License")
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
# THIS FILE IS BASED ON THE FOLLOWING RISC-V TEST SUITE SOURCE FILE:
# https://github.com/riscv/riscv-tests/blob/master/isa/rv64uf/fcvt_w.S
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

require_relative '../../riscv_base'

#
# Test fcvt{wu|w|lu|l}.s instructions.
#
class FcvtwTemplate < RiscVBaseTemplate

  def pre_rvtest
    RVTEST_RV64UF()
    RVTEST_CODE_BEGIN()
  end

  def pre_testdata
    RVTEST_DATA_BEGIN()
    TEST_DATA()

    data {
      # -NaN, NaN, -inf, +inf
label :tdat
      word 0xffffffff
      word 0x7fffffff
      word 0xff800000
      word 0x7f800000

label :tdat_d
      dword 0xffffffffffffffff
      dword 0x7fffffffffffffff
      dword 0xfff0000000000000
      dword 0x7ff0000000000000
    }

    RVTEST_DATA_END()
  end

  def run
    #-------------------------------------------------------------
    # Arithmetic tests
    #-------------------------------------------------------------

    TEST_FP_INT_OP_S( 2,  'fcvt_w_s', 0x01,         -1, -1.1, RTZ )
    TEST_FP_INT_OP_S( 3,  'fcvt_w_s', 0x00,         -1, -1.0, RTZ )
    TEST_FP_INT_OP_S( 4,  'fcvt_w_s', 0x01,          0, -0.9, RTZ )
    TEST_FP_INT_OP_S( 5,  'fcvt_w_s', 0x01,          0,  0.9, RTZ )
    TEST_FP_INT_OP_S( 6,  'fcvt_w_s', 0x00,          1,  1.0, RTZ )
    TEST_FP_INT_OP_S( 7,  'fcvt_w_s', 0x01,          1,  1.1, RTZ )
    TEST_FP_INT_OP_S( 8,  'fcvt_w_s', 0x10,     -1<<31, -3e9, RTZ )
    TEST_FP_INT_OP_S( 9,  'fcvt_w_s', 0x10,  (1<<31)-1,  3e9, RTZ )

    TEST_FP_INT_OP_S(12, 'fcvt_wu_s', 0x10,          0, -3.0, RTZ )
    TEST_FP_INT_OP_S(13, 'fcvt_wu_s', 0x10,          0, -1.0, RTZ )
    TEST_FP_INT_OP_S(14, 'fcvt_wu_s', 0x01,          0, -0.9, RTZ )
    TEST_FP_INT_OP_S(15, 'fcvt_wu_s', 0x01,          0,  0.9, RTZ )
    TEST_FP_INT_OP_S(16, 'fcvt_wu_s', 0x00,          1,  1.0, RTZ )
    TEST_FP_INT_OP_S(17, 'fcvt_wu_s', 0x01,          1,  1.1, RTZ )
    TEST_FP_INT_OP_S(18, 'fcvt_wu_s', 0x10,          0, -3e9, RTZ )
    TEST_FP_INT_OP_S(19, 'fcvt_wu_s', 0x00, 3000000000,  3e9, RTZ )

    if __riscv_xlen >= 64 then
    TEST_FP_INT_OP_S(22,  'fcvt_l_s', 0x01,         -1, -1.1, RTZ )
    TEST_FP_INT_OP_S(23,  'fcvt_l_s', 0x00,         -1, -1.0, RTZ )
    TEST_FP_INT_OP_S(24,  'fcvt_l_s', 0x01,          0, -0.9, RTZ )
    TEST_FP_INT_OP_S(25,  'fcvt_l_s', 0x01,          0,  0.9, RTZ )
    TEST_FP_INT_OP_S(26,  'fcvt_l_s', 0x00,          1,  1.0, RTZ )
    TEST_FP_INT_OP_S(27,  'fcvt_l_s', 0x01,          1,  1.1, RTZ )

    TEST_FP_INT_OP_S(32, 'fcvt_lu_s', 0x10,          0, -3.0, RTZ )
    TEST_FP_INT_OP_S(33, 'fcvt_lu_s', 0x10,          0, -1.0, RTZ )
    TEST_FP_INT_OP_S(34, 'fcvt_lu_s', 0x01,          0, -0.9, RTZ )
    TEST_FP_INT_OP_S(35, 'fcvt_lu_s', 0x01,          0,  0.9, RTZ )
    TEST_FP_INT_OP_S(36, 'fcvt_lu_s', 0x00,          1,  1.0, RTZ )
    TEST_FP_INT_OP_S(37, 'fcvt_lu_s', 0x01,          1,  1.1, RTZ )
    TEST_FP_INT_OP_S(38, 'fcvt_lu_s', 0x10,          0, -3e9, RTZ )
    end

    # test negative NaN, negative infinity conversion
    TEST_CASE( 42, x1, 0x000000007fffffff ) do
      la x1, :tdat
      flw f1, x1, 0
      fcvt_w_s2 x1, f1
    end
  
    TEST_CASE( 44, x1, 0xffffffff80000000 ) do
      la x1, :tdat
      flw f1, x1, 8
      fcvt_w_s2 x1, f1
    end

    if __riscv_xlen >= 64 then
    TEST_CASE( 43, x1, 0x7fffffffffffffff ) do
      la x1, :tdat
      flw f1, x1, 0
      fcvt_l_s2 x1, f1
    end

    TEST_CASE( 45, x1, 0x8000000000000000 ) do
      la x1, :tdat
      flw f1, x1, 8
      fcvt_l_s2 x1, f1
    end
    end

    # test positive NaN, positive infinity conversion
    TEST_CASE( 52, x1, 0x000000007fffffff ) do
      la x1, :tdat
      flw f1, x1, 4
      fcvt_w_s2 x1, f1
    end

    TEST_CASE( 54, x1, 0x000000007fffffff ) do
      la x1, :tdat
      flw f1, x1, 12
      fcvt_w_s2 x1, f1
    end

    if __riscv_xlen >= 64 then
    TEST_CASE( 53, x1, 0x7fffffffffffffff ) do
      la x1, :tdat
      flw f1, x1, 4
      fcvt_l_s2 x1, f1
    end

    TEST_CASE( 55, x1, 0x7fffffffffffffff ) do
      la x1, :tdat
      flw f1, x1, 12
      fcvt_l_s2 x1, f1
    end
    end

    # test NaN, infinity conversions to unsigned integer
    TEST_CASE( 62, x1, 0xffffffffffffffff ) do
      la x1, :tdat
      flw f1, x1, 0
      fcvt_wu_s2 x1, f1
    end

    TEST_CASE( 63, x1, 0xffffffffffffffff ) do
      la x1, :tdat
      flw f1, x1, 4
      fcvt_wu_s2 x1, f1
    end

    TEST_CASE( 64, x1, 0 ) do
      la x1, :tdat
      flw f1, x1, 8
      fcvt_wu_s2 x1, f1
    end

    TEST_CASE( 65, x1, 0xffffffffffffffff ) do
      la x1, :tdat
      flw f1, x1, 12
      fcvt_wu_s2 x1, f1
    end

    if __riscv_xlen >= 64 then
    TEST_CASE( 66, x1, 0xffffffffffffffff ) do
      la x1, :tdat
      flw f1, x1, 0
      fcvt_lu_s2 x1, f1
    end

    TEST_CASE( 67, x1, 0xffffffffffffffff ) do
      la x1, :tdat
      flw f1, x1, 4
      fcvt_lu_s2 x1, f1
    end

    TEST_CASE( 68, x1, 0 ) do
      la x1, :tdat
      flw f1, x1, 8
      fcvt_lu_s2 x1, f1
    end

    TEST_CASE( 69, x1, 0xffffffffffffffff ) do
       la x1, :tdat
       flw f1, x1, 12
       fcvt_lu_s2 x1, f1
    end
    end
  end

  def post
    TEST_PASSFAIL()
    RVTEST_CODE_END()
  end

end
