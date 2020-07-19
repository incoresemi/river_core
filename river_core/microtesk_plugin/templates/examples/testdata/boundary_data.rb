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
# This test template demonstrates how to generate boundary input values.
#
class BoundaryDataTemplate < RiscVBaseTemplate
  def run
    #set_default_allocator FREE
    sequence {
      add a0, a1, a2 do testdata('boundary') end      
      sub a3, a0, a4 do testdata('boundary') end      
    }.run
  end
end
