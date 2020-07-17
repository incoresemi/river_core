#
# Copyright 2018 ISP RAS (http://www.ispras.ru)
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
# THIS FILE IS BASED ON THE RISC TORTURE MODULE:
# https://github.com/ucb-bar/riscv-torture/blob/master/generator/src/main/scala/Rand.scala
#

#
# Description:
#
# This module contains methods that are commonly used to generate random values.
#
module RiscvRand

  private

  def self.bit_set_values
    array = []
    (0..63).each { |n| array << (1 << n) }
    array
  end

  def self.bit_clear_values
    array = []
    (0..63).each { |n| array << ~(1 << n) }
    array
  end

  BIT_SET_VALUES = bit_set_values()
  BIT_CLEAR_VALUES = bit_clear_values()

  public

  def rand_word;             rand(0x0, 0xFFFF_FFFF) end
  def rand_dword;            rand(0x0, 0xFFFF_FFFF_FFFF_FFFF) end
  def rand_range(low, high); rand(low, high) end

  def rand_shamt;  rand_range(0, 63) end
  def rand_shamtw; rand_range(0, 31) end
  def rand_seglen; rand_range(0, 7) end
  def rand_imm;    rand_range(-2048, 2047) end
  def rand_bigimm; rand_range(0, 1048575) end

  def rand_addr_b(memsize);      rand_range(0, memsize-1) end
  def rand_addr_h(memsize); _AND(rand_range(0, memsize-1), ~1) end
  def rand_addr_w(memsize); _AND(rand_range(0, memsize-1), ~3) end
  def rand_addr_d(memsize); _AND(rand_range(0, memsize-1), ~7) end

  def rand_biased_dist
    dist(
      # 0-1: return a value with a single bit set
      range(:value => BIT_SET_VALUES, :bias => 1110),

      # 2-3: return a value with a single bit clear
      range(:value => BIT_CLEAR_VALUES, :bias => 1110),

      # 4: return a small integer around zero
      range(:value => 0..9, :bias => 556),

      # 5: return a very large/very small 8b signed number
      range(:value => 0xFFFF_FFFF_FFFF_FF80..0xFFFF_FFFF_FFFF_FF89, :bias => 556),

      # 6: return a very large/very small 16b signed number
      range(:value => 0xFFFF_FFFF_FFFF_8000..0xFFFF_FFFF_FFFF_8009, :bias => 556),

      # 7: return a very large/very small 32b signed number
      range(:value => 0xFFFF_FFFF_8000_0000..0xFFFF_FFFF_8000_0009, :bias => 556),

      # 8: return a very large/very small 64b signed number
      range(:value => 0x8000_0000_0000_0000..0x8000_0000_0000_0009, :bias => 556),

      # 9-17: return a random dword value
      range(:value => 0x0..0xFFFF_FFFF_FFFF_FFFF, :bias => 5000)
    )
  end

  def rand_biased; rand(rand_biased_dist) end

  # Picks a random instruction or instruction sequence from the provided instruction block.
  def pick_random(&contents)
    block(:combinator => 'random') {
      iterate {
        self.instance_eval &contents
      }
    }
  end

end
