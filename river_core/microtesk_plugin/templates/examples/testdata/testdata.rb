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
# This test template demonstrates how to use test data generators that are
# independent of the context and produce multiple sets of test data.
#
# The test templates produces test cases based on a Cartesian product of
# test data generated for individual registers.
#
class TestDataTemplate < RiscVBaseTemplate

  def run
    # Test data for individual registers.
    sequence(:data_combinator => 'product') {
      add x8,  (x9  do testdata('range', :min => 1, :max => 3) end),
               (x10 do testdata('range', :min => 1, :max => 3) end)

      sub x11, (x12 do testdata('range', :min => 1, :max => 3) end),
               (x13 do testdata('range', :min => 1, :max => 3) end)
    }.run

    # Test data for entire instructions.
    sequence(:data_combinator => 'product') {
      add x8,  x9,  x10 do testdata('range', :min => 1, :max => 3) end
      sub x11, x12, x13 do testdata('range', :min => 1, :max => 3) end
    }.run
  end

end
