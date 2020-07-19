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
# This test template demonstrates how to define weak symbols.
#
class WeakSymbolTemplate < RiscVBaseTemplate

  def run
    # Undefined symbol (address resolved as 0x0)
    weak :symbolA

    # Defined later in the template
    weak :symbolB

    la t1, :symbolA
    beqz t1, label_f(1)
    jr t1
    newline

label 1
    la t2, :symbolB
    beqz t2, label_f(2)
    jr t2
    newline

label 2
    trace 'Error: Must not reach here!'
    nop
    nop
    newline

label :symbolB
    nop
    nop
  end

end
