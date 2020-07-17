#
# Copyright 2017-2018 ISP RAS (http://www.ispras.ru)
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

require ENV['TEMPLATE']

# RISC-V macros used to organize tests
require_relative 'riscv_test'
require_relative 'riscv_test_macros'

class RiscVBaseTemplate < Template
  include RiscvTest
  include RiscvTestMacros

  ##################################################################################################
  # Settings
  ##################################################################################################

  def initialize
    super
    # Initialize settings here

    # Sets the indentation token used in test programs
    set_option_value 'indent-token', "\t"

    # Sets the single-line comment text used in test programs
    set_option_value 'comment-token', "#"

    # Sets the token used in separator lines printed into test programs
    set_option_value 'separator-token', "="

    # Changes the name of the .text section to .text.init
    set_option_value 'text-section-keyword', '.text.init'

    # Defines alias methods for X registers
    (0..31).each do |i|
      define_method "x#{i}" do |&contents| X(i, &contents) end
    end

    # Defines alias methods for F registers
    (0..31).each do |i|
      define_method "f#{i}" do |&contents| F(i, &contents) end
    end

    # Defines alias methods for VR registers
    (0..31).each do |i|
      define_method "v#{i}" do |&contents| VR(i, &contents) end
    end
  end

  ##################################################################################################
  # Prologue
  ##################################################################################################

  def pre
    ################################################################################################

    #
    # Information on data types to be used in data sections.
    #
    data_config(:target => 'MEM') {
      define_type   :id => :byte,    :text => '.byte',   :type => type('card', 8)
      define_type   :id => :half,    :text => '.half',   :type => type('card', 16)
      define_type   :id => :word,    :text => '.word',   :type => type('card', 32)
      define_type   :id => :dword,   :text => '.dword',  :type => type('card', 64)
      define_type   :id => :byte2,   :text => '.2byte',  :type => type('card', 16),      :align => false
      define_type   :id => :byte4,   :text => '.4byte',  :type => type('card', 32),      :align => false
      define_type   :id => :byte8,   :text => '.8byte',  :type => type('card', 64),      :align => false
      define_type   :id => :float,   :text => '.float',  :type => type('float', 23, 8),  :format => '%s'
      define_type   :id => :double,  :text => '.double', :type => type('float', 52, 11), :format => '%s'
      define_type   :id => :floatx,  :text => '.float',  :type => type('float', 23, 8),  :format => '0f:%08X'
      define_type   :id => :doublex, :text => '.double', :type => type('float', 52, 11), :format => '0d:%016X'
      define_space  :id => :space,   :text => '.space',  :fill_with => 0
      define_space  :id => :zero,    :text => '.zero',   :fill_with => 0
      define_space  :id => :skip,    :text => '.skip',   :fill_with => 0
      define_string :id => :ascii,   :text => '.ascii',  :zero_term => false
      define_string :id => :asciz,   :text => '.asciz',  :zero_term => true
      define_string :id => :asciiz,  :text => '.asciiz', :zero_term => true
      define_string :id => :string,  :text => '.string', :zero_term => true
    }

    #
    # Defines .text.init section.
    #
    # pa: base physical address (used for memory allocation).
    # va: base virtual address (used for encoding instructions that refer to labels).
    #
    section_text(:prefix => '.section', :pa => 0x8000_0000, :va => 0x8000_0000) {}

    #
    # Defines .tohost section.
    #
    # pa: base physical address (used for memory allocation).
    # va: base virtual address (used for encoding instructions that refer to labels).
    #
    section(:name => '.tohost', :prefix => '.section',
            :pa => 0x8002_0000, :va => 0x8002_0000, :args =>'"aw",@progbits') {}

    #
    # Defines .text section.
    #
    # pa: base physical address (used for memory allocation).
    # va: base virtual address (used for encoding instructions that refer to labels).
    #
    section(:name => '.text', :pa => 0x8002_1000, :va => 0x8002_1000, :args => '') {}

    #
    # Defines .data section.
    #
    # pa: base physical address (used for memory allocation).
    # va: base virtual address (used for encoding instructions that refer to labels).
    #
    section_data(:pa => 0x8002_8000, :va => 0x8002_8000) {}

    ################################################################################################

    #
    # The code below specifies instruction sequences that write values
    # to the specified register (target) via the X addressing mode.
    #
    # Default preparator: used when no special case (provided below) is applicable.
    #
    preparator(:target => 'X') {
      li target, value
    }

    preparator(:target => 'X', :arguments => {:i => 0}) {
      # Empty
    }

    preparator(:target => 'X', :mask => ["0000_0000", "0000_0000_0000_0000"]) {
      Or target, zero, zero
    }

    preparator(:target => 'X', :mask => ["FFFF_FFFF", "FFFF_FFFF_FFFF_FFFF"]) {
      Not target, zero
    }

    preparator(:target => 'X', :mask => [
      "'b00000000_00000000_00000XXX_XXXXXXXX",
      "'b00000000_00000000_00000000_00000000_00000000_00000000_00000XXX_XXXXXXXX"]) {
      ori target, zero, value(0, 10)
    }

    ################################################################################################

    #
    # The code below specifies instruction sequences that write values
    # to the specified register (target) via the F addressing mode.
    #

    #
    # Preparator for double precision values.
    #
    if is_rev('RV32F') then
    preparator(:target => 'F', :mask => 'XXXX_XXXX_XXXX_XXXX') {
      if is_rev('RV64D') then
        prepare sp, value(0, 63)
        fmv_d_x target, sp
      else
        prepare sp, value(0, 31)
        fmv_w_x target, sp
      end
    }

    #
    # Preparator for single precision values.
    #
    preparator(:target => 'F', :mask => 'XXXX_XXXX') {
      prepare sp, value(0, 31)
      fmv_w_x target, sp
    }
    end

    ################################################################################################

    #
    # The code below specifies instruction sequences that write values
    # to the specified register (target) via the VR addressing mode.
    #

    if is_rev('RV32V') then
    preparator(:target => 'VR') {
    }
    end

    ################################################################################################

    #
    # Empty preparators for system registers. Required to avoid errors when input data
    # for all registers is generated by default.
    #

    preparator(:target => 'USTATUS') {}

    ################################################################################################

    # The code below specifies a comparator sequence to be used in self-checking tests
    # to test values in the specified register (target) accessed via the X addressing mode.
    #
    # Comparators are described using the same syntax as in preparators and can be
    # overridden in the same way.
    #
    # Default comparator: It is used when no special case is applicable.
    #
    comparator(:target => 'X') {
      prepare sp, value
      bne sp, target, :fail
    }

    #
    # Special case: Target is $zero register. Since it is read only and
    # always equal zero, it makes no sense to test it.
    #
    comparator(:target => 'X', :arguments => {:i => 0}) {
      # Empty
    }

    #
    # Special case: Value equals 0x00000000. In this case, it is
    # more convenient to test the target against the zero register.
    #
    comparator(:target => 'X', :mask => ["0000_0000", "0000_0000_0000_0000"]) {
      bne zero, target, :fail
    }

    ################################################################################################

    # The code below specifies a comparator sequence to be used in self-checking tests
    # to test values in the specified register (target) accessed via the F addressing mode.

    if is_rev('RV32F') then
    comparator(:target => 'F') {
      prepare sp, value

      if is_rev('RV64D') then
        fmv_x_d x31, target
      else
        fmv_x_w x31, target
      end

      bne sp, x31, :fail
    }
    end

    ################################################################################################

    # The code below specifies a comparator sequence to be used in self-checking tests
    # to test values in the specified register (target) accessed via the VR addressing mode.

    if is_rev('RV32V') then
    comparator(:target => 'VR') {
      # Empty
    }
    end

    ################################################################################################

    # Test data block.
    pre_testdata

    # RISC-V prologue.
    pre_rvtest
  end

  # Test data can be overridden in user templates.
  def pre_testdata
    RVTEST_DATA_BEGIN()
    TEST_DATA()
    RVTEST_DATA_END()
  end

  # Prologue can be overridden in user templates.
  def pre_rvtest
    RVTEST_RV64U()
    RVTEST_CODE_BEGIN()
  end

  ##################################################################################################
  # Epilogue
  ##################################################################################################

  # Epilogue can be overridden in user templates.
  def post
    j :pass
label :fail
    RVTEST_FAIL()
label :pass
    RVTEST_PASS()
    RVTEST_CODE_END()
  end

  ##################################################################################################
  # Shortcuts for registers
  ##################################################################################################

  # General-purpose registers
  def zero(&contents) X(0,  &contents) end
  def   ra(&contents) X(1,  &contents) end
  def   sp(&contents) X(2,  &contents) end
  def   gp(&contents) X(3,  &contents) end
  def   tp(&contents) X(4,  &contents) end
  def   t0(&contents) X(5,  &contents) end
  def   t1(&contents) X(6,  &contents) end
  def   t2(&contents) X(7,  &contents) end
  def   s0(&contents) X(8,  &contents) end
  def   s1(&contents) X(9,  &contents) end
  def   a0(&contents) X(10, &contents) end
  def   a1(&contents) X(11, &contents) end
  def   a2(&contents) X(12, &contents) end
  def   a3(&contents) X(13, &contents) end
  def   a4(&contents) X(14, &contents) end
  def   a5(&contents) X(15, &contents) end
  def   a6(&contents) X(16, &contents) end
  def   a7(&contents) X(17, &contents) end
  def   s2(&contents) X(18, &contents) end
  def   s3(&contents) X(19, &contents) end
  def   s4(&contents) X(20, &contents) end
  def   s5(&contents) X(21, &contents) end
  def   s6(&contents) X(22, &contents) end
  def   s7(&contents) X(23, &contents) end
  def   s8(&contents) X(24, &contents) end
  def   s9(&contents) X(25, &contents) end
  def  s10(&contents) X(26, &contents) end
  def  s11(&contents) X(27, &contents) end
  def   t3(&contents) X(28, &contents) end
  def   t4(&contents) X(29, &contents) end
  def   t5(&contents) X(30, &contents) end
  def   t6(&contents) X(31, &contents) end

  # Floating-point registers
  def  ft0(&contents) F(0,  &contents) end
  def  ft1(&contents) F(1,  &contents) end
  def  ft2(&contents) F(2,  &contents) end
  def  ft3(&contents) F(3,  &contents) end
  def  ft4(&contents) F(4,  &contents) end
  def  ft5(&contents) F(5,  &contents) end
  def  ft6(&contents) F(6,  &contents) end
  def  ft7(&contents) F(7,  &contents) end
  def  fs0(&contents) F(8,  &contents) end
  def  fs1(&contents) F(9,  &contents) end
  def  fa0(&contents) F(10, &contents) end
  def  fa1(&contents) F(11, &contents) end
  def  fa2(&contents) F(12, &contents) end
  def  fa3(&contents) F(13, &contents) end
  def  fa4(&contents) F(14, &contents) end
  def  fa5(&contents) F(15, &contents) end
  def  fa6(&contents) F(16, &contents) end
  def  fa7(&contents) F(17, &contents) end
  def  fs2(&contents) F(18, &contents) end
  def  fs3(&contents) F(19, &contents) end
  def  fs4(&contents) F(20, &contents) end
  def  fs5(&contents) F(21, &contents) end
  def  fs6(&contents) F(22, &contents) end
  def  fs7(&contents) F(23, &contents) end
  def  fs8(&contents) F(24, &contents) end
  def  fs9(&contents) F(25, &contents) end
  def fs10(&contents) F(26, &contents) end
  def fs11(&contents) F(27, &contents) end
  def  ft8(&contents) F(28, &contents) end
  def  ft9(&contents) F(29, &contents) end
  def ft10(&contents) F(30, &contents) end
  def ft11(&contents) F(31, &contents) end

  # Registers for Standard Extension for Compressed Instructions
  def   s0c(&contents) CX(0, &contents) end
  def   s1c(&contents) CX(1, &contents) end
  def   a0c(&contents) CX(2, &contents) end
  def   a1c(&contents) CX(3, &contents) end
  def   a2c(&contents) CX(4, &contents) end
  def   a3c(&contents) CX(5, &contents) end
  def   a4c(&contents) CX(6, &contents) end
  def   a5c(&contents) CX(7, &contents) end

  def  fs0c(&contents) CF(0, &contents) end
  def  fs1c(&contents) CF(1, &contents) end
  def  fa0c(&contents) CF(2, &contents) end
  def  fa1c(&contents) CF(3, &contents) end
  def  fa2c(&contents) CF(4, &contents) end
  def  fa3c(&contents) CF(5, &contents) end
  def  fa4c(&contents) CF(6, &contents) end
  def  fa5c(&contents) CF(7, &contents) end

  ##################################################################################################
  # Constants for floating-point special values.
  ##################################################################################################

  NANF  = 0x7FFF_FFFF # Canonical NaN (single)
  QNANF = 0x7fc0_0000 # Quiet NaN (single)
  SNANF = 0x7f80_0001 # Signalling NaN (single)
  INFF  = 0x7F80_0000 # Positive infinity (single)
  NINFF = 0xFF80_0000 # Negative infinity (single)

  QNAN  = 0x7ff8_0000_0000_0000 # Quiet NaN (double)
  SNAN  = 0x7ff0_0000_0000_0001 # Signalling NaN (double)
  NAN   = 0x7FFF_FFFF_FFFF_FFFF # Canonical NaN (double)
  INF   = 0x7FF0_0000_0000_0000 # Positive infinity (double)
  NINF  = 0xFFF0_0000_0000_0000 # Negative infinity (double)

  ##################################################################################################
  # Constants for floating-point rounding modes.
  ##################################################################################################

  RNE = 0 # 0b000
  RTZ = 1 # 0b001
  RDN = 2 # 0b010
  RUP = 3 # 0b011
  RMM = 4 # 0b100

  ##################################################################################################
  # Utility method for printing data stored in memory using labels.
  ##################################################################################################

  def trace_data_addr(begin_addr, end_addr)
    if is_rev('MEM_SV32') then
      mem_shift = 4
    else
      mem_shift = 8
    end

    count = (end_addr - begin_addr) / mem_shift
    additional_count = (end_addr - begin_addr) % mem_shift
    if additional_count > 0
       count = count + 1
    end

    begin_index = begin_addr / mem_shift

    trace "\nData starts: 0x%x", begin_addr
    trace "Data ends:   0x%x", end_addr
    trace "Data count:  %d", count

    index = begin_index
    addr = begin_addr

    trace "\nData values:"
    count.times {
      if is_rev('MEM_SV32') then
        trace "%016x (MEM[0x%x]): 0x%08x", addr, index, MEM(index)
      else
        trace "%016x (MEM[0x%x]): 0x%016x", addr, index, MEM(index)
      end
      index = index + 1
      addr = addr + mem_shift
    }
  end

  def trace_data(begin_label, end_label)
    begin_addr = get_address_of(begin_label)
    end_addr = get_address_of(end_label)

    trace_data_addr(begin_addr, end_addr)
  end

  ##################################################################################################
  # Additional logic to handle floating-point values in data sections differently depending
  # on whether they were specified as integer (typically hexadecimal) or floating-point constants.
  # This provides the "what you see is what you get" behavior for floating-point data values.
  # For example:
  #   "float 3.14" in template => ".float 3.14" is test program
  #   "float 0x7fc00000" in template => ".float 0f:7F800001" is test program
  # So, values specified in integer format are forwarded to the "floatx" and "doublex" methods.
  ##################################################################################################

  class RiscDataManager < DataManager
    def float(value)
      if value.is_a?(Float) then
        super(value)
      else
        floatx(value)
      end
    end

    def double(value)
      if value.is_a?(Float) then
        super(value)
      else
        doublex(value)
      end
    end
  end

  def new_data_manager(template, manager)
    RiscDataManager.new(self, @template.getDataManager)
  end

end # RiscVBaseTemplate
