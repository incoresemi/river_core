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

require_relative '../riscv_base'

#
# Description:
#
# This small tests for RV32V instructions.
#
class InstructionRV32V < RiscVBaseTemplate

  def run
    trace "RV32V instructions:"

    if is_rev('RV32V') then
      vadd v0, v4, v8
      trace "v0 = %x", VREG(0)

      vsub v0, v4, v8
      trace "v0 = %x", VREG(0)

      #vsl v0, v1, v2
      #vsr v0, v1, v2
      #vand v0, v1, v2
      #vor v0, v1, v2
      #vxor v0, v1, v2
      #vseq v0, v1, v2
      #vsne v0, v1, v2
      #vslt v0, v1, v2
      #vsge v0, v1, v2
      #vclip v0, v1, t0
      #vcvt v0, v1, t1

      #vmpop t0, v1
      #vmfirst t0, v1
      #vextract t0, v1, t2
      #vinsert v0, t1, t2
      #vmerge v0, v1, v2
      #vselect v0, v1, v2
      #vslide v0, v1, t2

      #vdiv v0, v1, v2
      #vrem v0, v1, v2
      #vmul v0, v1, v2
      #vmulh v0, v1, v2
      #vmin v0, v1, v2
      #vmax v0, v1, v2
      #vsgnj v0, v1, v2
      #vsgnjn v0, v1, v2
      #vsgnjx v0, v1, v2
      #vsqrt v0, v1
      #vclass v0, v1
      #vpopc v0, v1

      #vaddi  v0, v1, 0b00001111
      #vsli   v0, v1, 0b00001110
      #vsri   v0, v1, 0b00001101
      #vandi  v0, v1, 0b00001011
      #vori   v0, v1, 0b00000111
      #vxori  v0, v1, 0b00000011
      #vclipi v0, v1, 0b00001001

      #vmadd v0, v1, v2, v3
      #vmsub v0, v1, v2, v3
      #vnmadd v0, v1, v2, v3
      #vnmsub v0, v1, v2, v3

      #vld v0, t1, 0b11011
      #vlds v0, t1, t2, 0b10011
      #vldx v0, t1, v2, 0b01011
      #vst t0, v1, 0b00011
      #vsts t0, t1, v2, 0b00010
      #vstx t0, v1, v2, 0b00001
      #vamoswap v0, v1, v2
      #vamoadd v0, v1, v2
      #vamoand v0, v1, v2
      #vamoor v0, v1, v2
      #vamoxor v0, v1, v2
      #vamomin v0, v1, v2
      #vamomax v0, v1, v2

    end
  end

end
