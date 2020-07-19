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
# https://github.com/riscv/riscv-tests/blob/master/isa/rv64ud/recoding.S
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
# Test corner cases of John Hauser's microarchitectural recoding scheme.
# There are twice as many recoded values as IEEE-754 values; some of these
# extras are redundant (e.g. Inf) and others are illegal (subnormals with
# too many bits set).
#
class RecodingTemplate < RiscVBaseTemplate

  def pre_rvtest
    RVTEST_RV64UF()
    RVTEST_CODE_BEGIN()
  end

  def pre_testdata
    RVTEST_DATA_BEGIN()
    TEST_DATA()

    data {
label :minf
      double NINF
label :three
      double 3.0
label :big
      float 1221.0
label :small
      float 2.9133121e-37
label :tiny
      double 2.3860049081905093e-40
    }

    RVTEST_DATA_END()
  end

  def run
    # Make sure infinities with different mantissas compare as equal.
    fld_global f0, :minf, a0
    fld_global f1, :three, a0
    fmul_d f1, f1, f0

    TEST_CASE( 2, a0, 1 ) do feq_d a0, f0, f1 end
    TEST_CASE( 3, a0, 1 ) do fle_d a0, f0, f1 end
    TEST_CASE( 4, a0, 0 ) do flt_d a0, f0, f1 end

    # Likewise, but for zeroes.
    fcvt_d_w f0, x0
    li a0, 1
    fcvt_d_w f1, a0
    fmul_d f1, f1, f0
    TEST_CASE( 5, a0, 1 ) do feq_d a0, f0, f1 end
    TEST_CASE( 6, a0, 1 ) do fle_d a0, f0, f1 end
    TEST_CASE( 7, a0, 0 ) do flt_d a0, f0, f1 end

    # When converting small doubles to single-precision subnormals,
    # ensure that the extra precision is discarded.
    flw_global f0, :big, a0
    fld_global f1, :tiny, a0
    fcvt_s_d f1, f1
    fmul_s f0, f0, f1
    fmv_x_w a0, f0
    lw_global a1, :small
    TEST_CASE(10, a0, 0) do sub a0, a0, a1 end

    # Make sure FSD+FLD correctly saves and restores a single-precision value.
    flw_global f0, :three, a0
    fadd_s f1, f0, f0
    fadd_s f0, f0, f0
    fsd_global f0, :tiny, a0
    fld_global f0, :tiny, a0
    TEST_CASE(20, a0, 1 ) do feq_s a0, f0, f1 end
  end

  def post
    TEST_PASSFAIL()
    RVTEST_CODE_END()
  end

end
