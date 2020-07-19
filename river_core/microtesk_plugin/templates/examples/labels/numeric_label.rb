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
# This test template demonstrates how to use numeric labels.
#
class NumericLabelTemplate < RiscVBaseTemplate

  def run
    prepare t0, 0x0
    prepare t1, 0x0

label 1 # First label
    bgtz t0, label_f(1) # Second label
    addi t0, t0, 1
    j label_b(1) # First label

label 1 # Second label
    bgtz t1, label_f(1) # Third label
    addi t1, t1, 1
    j label_b(1) # Second label

label 1 # Third label
    nop
    nop
  end

end
