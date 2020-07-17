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
# THIS FILE IS BASED ON THE FOLLOWING RISC-V TEST SUITE HEADER:
# https://github.com/riscv/riscv-test-env/blob/master/encoding.h
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

module RiscvEncoding

  MSTATUS_UIE  = 0x00000001
  MSTATUS_SIE  = 0x00000002
  MSTATUS_HIE  = 0x00000004
  MSTATUS_MIE  = 0x00000008
  MSTATUS_UPIE = 0x00000010
  MSTATUS_SPIE = 0x00000020
  MSTATUS_HPIE = 0x00000040
  MSTATUS_MPIE = 0x00000080
  MSTATUS_SPP  = 0x00000100
  MSTATUS_HPP  = 0x00000600
  MSTATUS_MPP  = 0x00001800
  MSTATUS_FS   = 0x00006000
  MSTATUS_XS   = 0x00018000
  MSTATUS_MPRV = 0x00020000
  MSTATUS_SUM  = 0x00040000
  MSTATUS_MXR  = 0x00080000
  MSTATUS_TVM  = 0x00100000
  MSTATUS_TW   = 0x00200000
  MSTATUS_TSR  = 0x00400000
  MSTATUS32_SD = 0x80000000
  MSTATUS_UXL  = 0x0000000300000000
  MSTATUS_SXL  = 0x0000000C00000000
  MSTATUS64_SD = 0x8000000000000000

  SSTATUS_UIE  = 0x00000001
  SSTATUS_SIE  = 0x00000002
  SSTATUS_UPIE = 0x00000010
  SSTATUS_SPIE = 0x00000020
  SSTATUS_SPP  = 0x00000100
  SSTATUS_FS   = 0x00006000
  SSTATUS_XS   = 0x00018000
  SSTATUS_SUM  = 0x00040000
  SSTATUS_MXR  = 0x00080000
  SSTATUS32_SD = 0x80000000
  SSTATUS_UXL  = 0x0000000300000000
  SSTATUS64_SD = 0x8000000000000000

  DCSR_XDEBUGVER = (3 << 30)
  DCSR_NDRESET   = (1 << 29)
  DCSR_FULLRESET = (1 << 28)
  DCSR_EBREAKM   = (1 << 15)
  DCSR_EBREAKH   = (1 << 14)
  DCSR_EBREAKS   = (1 << 13)
  DCSR_EBREAKU   = (1 << 12)
  DCSR_STOPCYCLE = (1 << 10)
  DCSR_STOPTIME  = (1 << 9)
  DCSR_CAUSE     = (7 << 6)
  DCSR_DEBUGINT  = (1 << 5)
  DCSR_HALT      = (1 << 3)
  DCSR_STEP      = (1 << 2)
  DCSR_PRV       = (3 << 0)

  DCSR_CAUSE_NONE     = 0
  DCSR_CAUSE_SWBP     = 1
  DCSR_CAUSE_HWBP     = 2
  DCSR_CAUSE_DEBUGINT = 3
  DCSR_CAUSE_STEP     = 4
  DCSR_CAUSE_HALT     = 5

  def MCONTROL_TYPE(xlen)
    (0xf<<((xlen)-4))
  end

  def MCONTROL_DMODE(xlen)
    (1<<((xlen)-5))
  end

  def MCONTROL_MASKMAX(xlen)
    (0x3f<<((xlen)-11))
  end

  MCONTROL_SELECT  = (1 << 19)
  MCONTROL_TIMING  = (1 << 18)
  MCONTROL_ACTION  = (0x3f << 12)
  MCONTROL_CHAIN   = (1 << 11)
  MCONTROL_MATCH   = (0xf << 7)
  MCONTROL_M       = (1 << 6)
  MCONTROL_H       = (1 << 5)
  MCONTROL_S       = (1 << 4)
  MCONTROL_U       = (1 << 3)
  MCONTROL_EXECUTE = (1 << 2)
  MCONTROL_STORE   = (1 << 1)
  MCONTROL_LOAD    = (1 << 0)

  MCONTROL_TYPE_NONE  = 0
  MCONTROL_TYPE_MATCH = 2

  MCONTROL_ACTION_DEBUG_EXCEPTION = 0
  MCONTROL_ACTION_DEBUG_MODE      = 1
  MCONTROL_ACTION_TRACE_START     = 2
  MCONTROL_ACTION_TRACE_STOP      = 3
  MCONTROL_ACTION_TRACE_EMIT      = 4

  MCONTROL_MATCH_EQUAL     = 0
  MCONTROL_MATCH_NAPOT     = 1
  MCONTROL_MATCH_GE        = 2
  MCONTROL_MATCH_LT        = 3
  MCONTROL_MATCH_MASK_LOW  = 4
  MCONTROL_MATCH_MASK_HIGH = 5

  IRQ_S_SOFT  = 1
  IRQ_H_SOFT  = 2
  IRQ_M_SOFT  = 3
  IRQ_S_TIMER = 5
  IRQ_H_TIMER = 6
  IRQ_M_TIMER = 7
  IRQ_S_EXT   = 9
  IRQ_H_EXT   = 10
  IRQ_M_EXT   = 11
  IRQ_COP     = 12
  IRQ_HOST    = 13

  MIP_SSIP = (1 << IRQ_S_SOFT)
  MIP_HSIP = (1 << IRQ_H_SOFT)
  MIP_MSIP = (1 << IRQ_M_SOFT)
  MIP_STIP = (1 << IRQ_S_TIMER)
  MIP_HTIP = (1 << IRQ_H_TIMER)
  MIP_MTIP = (1 << IRQ_M_TIMER)
  MIP_SEIP = (1 << IRQ_S_EXT)
  MIP_HEIP = (1 << IRQ_H_EXT)
  MIP_MEIP = (1 << IRQ_M_EXT)

  SIP_SSIP = MIP_SSIP
  SIP_STIP = MIP_STIP

  PRV_U = 0
  PRV_S = 1
  PRV_H = 2
  PRV_M = 3

  SATP32_MODE = 0x80000000
  SATP32_ASID = 0x7FC00000
  SATP32_PPN  = 0x003FFFFF
  SATP64_MODE = 0xF000000000000000
  SATP64_ASID = 0x0FFFF00000000000
  SATP64_PPN  = 0x00000FFFFFFFFFFF

  SATP_MODE_OFF  = 0
  SATP_MODE_SV32 = 1
  SATP_MODE_SV39 = 8
  SATP_MODE_SV48 = 9
  SATP_MODE_SV57 = 10
  SATP_MODE_SV64 = 11

  PMP_R     = 0x01
  PMP_W     = 0x02
  PMP_X     = 0x04
  PMP_A     = 0x18
  PMP_L     = 0x80
  PMP_SHIFT = 2

  PMP_TOR   = 0x08
  PMP_NA4   = 0x10
  PMP_NAPOT = 0x18

  DEFAULT_RSTVEC = 0x00001000
  CLINT_BASE     = 0x02000000
  CLINT_SIZE     = 0x000c0000
  EXT_IO_BASE    = 0x40000000
  DRAM_BASE      = 0x80000000

  # page table entry (PTE) fields
  PTE_V    = 0x001 # Valid
  PTE_R    = 0x002 # Read
  PTE_W    = 0x004 # Write
  PTE_X    = 0x008 # Execute
  PTE_U    = 0x010 # User
  PTE_G    = 0x020 # Global
  PTE_A    = 0x040 # Accessed
  PTE_D    = 0x080 # Dirty
  PTE_SOFT = 0x300 # Reserved for Software

  PTE_PPN_SHIFT = 10

  def PTE_TABLE(pte)
    (((pte) & (PTE_V | PTE_R | PTE_W | PTE_X)) == PTE_V)
  end

  def MSTATUS_SD
    if is_rev('RV64I') then MSTATUS64_SD else MSTATUS32_SD end
  end

  def SSTATUS_SD
    if is_rev('RV64I') then SSTATUS64_SD else SSTATUS32_SD end
  end

  def RISCV_PGLEVEL_BITS
    if is_rev('RV64I') then 9 else 10 end
  end

  def SATP_MODE
    if is_rev('RV64I') then SATP64_MODE else SATP32_MODE end
  end

  RISCV_PGSHIFT = 12
  RISCV_PGSIZE  = (1 << RISCV_PGSHIFT)

  CAUSE_MISALIGNED_FETCH    = 0x0
  CAUSE_FETCH_ACCESS        = 0x1
  CAUSE_ILLEGAL_INSTRUCTION = 0x2
  CAUSE_BREAKPOINT          = 0x3
  CAUSE_MISALIGNED_LOAD     = 0x4
  CAUSE_LOAD_ACCESS         = 0x5
  CAUSE_MISALIGNED_STORE    = 0x6
  CAUSE_STORE_ACCESS        = 0x7
  CAUSE_USER_ECALL          = 0x8
  CAUSE_SUPERVISOR_ECALL    = 0x9
  CAUSE_HYPERVISOR_ECALL    = 0xa
  CAUSE_MACHINE_ECALL       = 0xb
  CAUSE_FETCH_PAGE_FAULT    = 0xc
  CAUSE_LOAD_PAGE_FAULT     = 0xd
  CAUSE_STORE_PAGE_FAULT    = 0xf
end
