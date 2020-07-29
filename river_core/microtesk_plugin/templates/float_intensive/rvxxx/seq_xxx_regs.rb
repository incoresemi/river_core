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

require_relative '../../riscv_rand'

module SeqXxxRegs
  include RiscvRand

  # returns register x0
  def reg_read_zero(regtype)
    if :xregs == regtype
      zero
    else
      raise "Unsupported register type: #{regtype}"
    end
  end

  # returns any type of register (hidden or visible)
  def reg_read_any(regtype, attrs = {})
    if :xregs == regtype
      x(_ attrs) do situation('random_biased', :dist => rand_biased_dist) end
    elsif :xregs_c == regtype
      x(_ __XREGS_C(attrs)) do situation('random_biased', :dist => rand_biased_dist) end
    elsif :fregs_d == regtype
      f(_ attrs) do situation('random_biased', :dist => rand_biased_dist) end
    elsif :fregs_d_c == regtype
      f(_ __FREGS_C(attrs)) do situation('random_biased', :dist => rand_biased_dist) end
    elsif :fregs_s == regtype
      f(_ attrs) do situation('random_biased', :dist => rand_biased_dist, :size => 32) end
    elsif :fregs_s_c == regtype
      f(_ __FREGS_C(attrs)) do situation('random_biased', :dist => rand_biased_dist, :size => 32) end
    elsif :vregs == regtype
      vr(_ attrs) do situation('random_biased', :dist => rand_biased_dist) end
    else
      raise "Unsupported register type: #{regtype}"
    end
  end

  # returns a visible register
  def reg_read_visible(regtype, attrs = {})
    # Currently, visibility is not tracked. Therefore, 'reg_read_any' is called.
    reg_read_any(regtype, attrs)
  end

  # returns register ra for write
  def reg_write_ra(regtype)
    if :xregs == regtype
      ra
    else
      raise "Unsupported register type: #{regtype}"
    end
  end

  # returns a visible register for write
  def reg_write_visible(regtype, attrs = {})
    if :xregs == regtype
      x(_ attrs)
    elsif :xregs_c == regtype
      x(_ __XREGS_C(attrs))
    elsif :fregs_d == regtype
      f(_ attrs)
    elsif :fregs_d_c == regtype
      f(_ __FREGS_C(attrs))
    elsif :fregs_s == regtype
      f(_ attrs)
    elsif :fregs_s_c == regtype
      f(_ __FREGS_C(attrs))
    elsif :vregs == regtype
      vr(_ __VRREGS(attrs))
    else
      raise "Unsupported register type: #{regtype}"
    end
  end

  # returns a hidden register for write
  def reg_write_hidden(regtype, attrs = {})
    # Currently, visibility is not tracked. Therefore, 'reg_write_visible' is called.
    reg_write_visible(regtype, attrs)
  end

  # returns a register that matches the type of regs
  # (if any reg in regs are hidden, the output type is hidden)
  def reg_write(regtype, attrs = {}, *regs)
    # Currently, visibility is not tracked.
    # Therefore, 'reg_write_visible' is called and 'regs' is ignored.
    if attrs.is_a? Hash then
      reg_write_visible(regtype, attrs)
    else
      reg_write_visible(regtype)
    end
  end

  # FIXME: Begin
  def reg_num(reg)
    reg.getArguments.get('i').getValue
  end

  def to_cx(reg_x)
    cx(_SUB(reg_num(reg_x), 8))
  end

  def to_cf(reg_f)
    cf(_SUB(reg_num(reg_f), 8))
  end
  # FIXME: End

  private

  def __XREGS_C(attrs)
    xregs_c = [x8, x9, x10, x11, x12, x13, x14, x15]

    if attrs.has_key? :retain then
      attrs[:retain] + xregs_c
    else
      attrs[:retain] = xregs_c
    end

    attrs
  end

  def __FREGS_C(attrs)
    fregs_c = [f8, f9, f10, f11, f12, f13, f14, f15]

    if attrs.has_key? :retain then
      attrs[:retain] + fregs_c
    else
      attrs[:retain] = fregs_c
    end

    attrs
  end

  def __VRREGS(attrs)
    vregs = [v0, v4, v8, v12, v16, v20, v24, v28]

    if attrs.has_key? :retain then
      attrs[:retain] + vregs
    else
      attrs[:retain] = vregs
    end

    attrs
  end

end
