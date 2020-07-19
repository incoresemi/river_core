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

require_relative '../../riscv_base'

#
# Description:
#
#
class PreparatorTest < RiscVBaseTemplate

  def run
    trace "Run preparators:"
    nop

    prepare t1, -1
    trace "prepare -1 in t1 = %x", XREG(6)
    nop

    prepare t1, -2
    trace "prepare -2 in t1 = %x", XREG(6)

    prepare t2, 0xFF120000
    trace "prepare in t2 = %x", XREG(7)

    add t1, t0, t0
    trace "(add): t1 = %x", XREG(6)
  end

end
