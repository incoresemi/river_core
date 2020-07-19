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
# https://github.com/riscv/riscv-tests/blob/master/isa/rv64uf/fcmp.S
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
# Test f{eq|lt|le}.s instructions.
#
class FcmpTemplate < RiscVBaseTemplate

  def pre_rvtest
    RVTEST_RV64UF()
    RVTEST_CODE_BEGIN()
  end

  def run
    #-------------------------------------------------------------
    # Arithmetic tests
    #-------------------------------------------------------------

    TEST_FP_CMP_OP_S( 2, 'feq_s', 0x00, 1, -1.36, -1.36 )
    TEST_FP_CMP_OP_S( 3, 'fle_s', 0x00, 1, -1.36, -1.36 )
    TEST_FP_CMP_OP_S( 4, 'flt_s', 0x00, 0, -1.36, -1.36 )

    TEST_FP_CMP_OP_S( 5, 'feq_s', 0x00, 0, -1.37, -1.36 )
    TEST_FP_CMP_OP_S( 6, 'fle_s', 0x00, 1, -1.37, -1.36 )
    TEST_FP_CMP_OP_S( 7, 'flt_s', 0x00, 1, -1.37, -1.36 )

    # Only sNaN should signal invalid for feq.
    TEST_FP_CMP_OP_S( 8, 'feq_s', 0x00, 0, NANF,  0.0 )
    TEST_FP_CMP_OP_S( 9, 'feq_s', 0x00, 0, NANF, NANF )
    TEST_FP_CMP_OP_S(10, 'feq_s', 0x10, 0, SNANF, 0.0 )

    # qNaN should signal invalid for fle/flt.
    TEST_FP_CMP_OP_S(11, 'flt_s', 0x10, 0, NANF,  0.0 )
    TEST_FP_CMP_OP_S(12, 'flt_s', 0x10, 0, NANF, NANF )
    TEST_FP_CMP_OP_S(13, 'flt_s', 0x10, 0, SNANF, 0.0 )
    TEST_FP_CMP_OP_S(14, 'fle_s', 0x10, 0, NANF,  0.0 )
    TEST_FP_CMP_OP_S(15, 'fle_s', 0x10, 0, NANF, NANF )
    TEST_FP_CMP_OP_S(16, 'fle_s', 0x10, 0, SNANF, 0.0 )
  end

  def post
    TEST_PASSFAIL()
    RVTEST_CODE_END()
  end

end
