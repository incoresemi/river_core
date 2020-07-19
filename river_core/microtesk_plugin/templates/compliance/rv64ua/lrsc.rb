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
# https://github.com/riscv/riscv-tests/blob/master/isa/rv64ua/lrsc.S
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

class LrscTemplate < RiscVBaseTemplate

  LOG_ITERATIONS = 10

  def initialize
    super

    # Sets branch execution limit to 1025 (1<<LOG_ITERATIONS + 1)
    set_option_value 'branch-exec-limit', 1025
  end

  def pre_rvtest
    RVTEST_RV64U()
    RVTEST_CODE_BEGIN()
  end

  def pre_testdata
    RVTEST_DATA_BEGIN()
    TEST_DATA()

    data {
label :coreid
      word 0
label :barrier
      word 0
label :foo
      word 0
      skip 1024
label :fooTest3
      word 0
    }

    RVTEST_DATA_END()
  end

  def run
    # get a unique core id
    la a0, :coreid
    li a1, 1
    amoadd_w a2, a1, (a0)

    # for now, only run this on core 0
label 1
    li a3, 1
    bgeu a2, a3, label_b(1)

label 1
    lw a1, (a0), 0 # Originally lw a1, (a0)
    bltu a1, a3, label_b(1)

    # make sure that sc without a reservation fails.
    TEST_CASE( 2, a4, 1 ) do
      la a0, :foo
      sc_w a4, x0, (a0)
    end

    # make sure that sc with the wrong reservation fails.
    # TODO is this actually mandatory behavior?
    TEST_CASE( 3, a4, 1) do
      la a0, :foo
      la a1, :fooTest3
      lr_w a1, (a1)
      sc_w a4, a1, (a0)
    end

    # have each core add its coreid+1 to foo 1024 times
    la a0, :foo
    li a1, 1<<LOG_ITERATIONS
    addi a2, a2, 1
label 1
    lr_w a4, (a0)
    add a4, a4, a2
    sc_w a4, a4, (a0)
    bnez a4, label_b(1)
    addi a1, a1, -1
    bnez a1, label_b(1)

    # wait for all cores to finish
    la a0, :barrier
    li a1, 1
    amoadd_w x0, a1, (a0)
label 1
    lw a1, (a0), 0 # Originally lw a1, (a0)
    blt a1, a3, label_b(1)
    fence

    # expected result is 512*ncores*(ncores+1)
    TEST_CASE( 4, a0, 0 ) do
      lw_global a0, :foo # Originally lw a0, foo
      slli a1, a3, LOG_ITERATIONS-1
label 1
      sub a0, a0, a1
      addi a3, a3, -1
      bgez a3, label_b(1)
    end
  end

  def post
    TEST_PASSFAIL()
    RVTEST_CODE_END()
  end

end
