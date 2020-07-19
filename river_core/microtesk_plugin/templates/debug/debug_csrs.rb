#
# Copyright 2019 ISP RAS (http://www.ispras.ru)
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
# This test checks CSRs.
#
class DebugCsrsTemplate < RiscVBaseTemplate
  def pre
    super

    preparator(:target => 'USTATUS') {}
    preparator(:target => 'UIE') {}
    preparator(:target => 'UTVEC') {}
    preparator(:target => 'USCRATCH') {}
    preparator(:target => 'UEPC') {}
    preparator(:target => 'UCAUSE') {}
    preparator(:target => 'UTVAL') {}
    preparator(:target => 'UIP') {}
    preparator(:target => 'FFLAGS') {}
    preparator(:target => 'FRM') {}
    preparator(:target => 'FCSR') {}
    preparator(:target => 'CYCLE') {}
    preparator(:target => 'TIME') {}
    preparator(:target => 'INSTRET') {}
    preparator(:target => 'HPMCOUNTER3') {}
    preparator(:target => 'HPMCOUNTER4') {}
    preparator(:target => 'HPMCOUNTER5') {}
    preparator(:target => 'HPMCOUNTER6') {}
    preparator(:target => 'HPMCOUNTER7') {}
    preparator(:target => 'HPMCOUNTER8') {}
    preparator(:target => 'HPMCOUNTER9') {}
    preparator(:target => 'HPMCOUNTER10') {}
    preparator(:target => 'HPMCOUNTER11') {}
    preparator(:target => 'HPMCOUNTER12') {}
    preparator(:target => 'HPMCOUNTER13') {}
    preparator(:target => 'HPMCOUNTER14') {}
    preparator(:target => 'HPMCOUNTER15') {}
    preparator(:target => 'HPMCOUNTER16') {}
    preparator(:target => 'HPMCOUNTER17') {}
    preparator(:target => 'HPMCOUNTER18') {}
    preparator(:target => 'HPMCOUNTER19') {}
    preparator(:target => 'HPMCOUNTER20') {}
    preparator(:target => 'HPMCOUNTER21') {}
    preparator(:target => 'HPMCOUNTER22') {}
    preparator(:target => 'HPMCOUNTER23') {}
    preparator(:target => 'HPMCOUNTER24') {}
    preparator(:target => 'HPMCOUNTER25') {}
    preparator(:target => 'HPMCOUNTER26') {}
    preparator(:target => 'HPMCOUNTER27') {}
    preparator(:target => 'HPMCOUNTER28') {}
    preparator(:target => 'HPMCOUNTER29') {}
    preparator(:target => 'HPMCOUNTER30') {}
    preparator(:target => 'HPMCOUNTER31') {}
    preparator(:target => 'SSTATUS') {}
    preparator(:target => 'SEDELEG') {}
    preparator(:target => 'SIDELEG') {}
    preparator(:target => 'SIE') {}
    preparator(:target => 'STVEC') {}
    preparator(:target => 'SCOUNTEREN') {}
    preparator(:target => 'SSCRATCH') {}
    preparator(:target => 'SEPC') {}
    preparator(:target => 'SCAUSE') {}
    preparator(:target => 'STVAL') {}
    preparator(:target => 'SIP') {}
    preparator(:target => 'SATP') {}
    preparator(:target => 'MVENDORID') {}
    preparator(:target => 'MARCHID') {}
    preparator(:target => 'MIMPID') {}
    preparator(:target => 'MHARTID') {}
    preparator(:target => 'MSTATUS') {}
    preparator(:target => 'MISA') {}
    preparator(:target => 'MEDELEG') {}
    preparator(:target => 'MIDELEG') {}
    preparator(:target => 'MIE') {}
    preparator(:target => 'MTVEC') {}
    preparator(:target => 'MCOUNTEREN') {}
    preparator(:target => 'MSCRATCH') {}
    preparator(:target => 'MEPC') {}
    preparator(:target => 'MCAUSE') {}
    preparator(:target => 'MTVAL') {}
    preparator(:target => 'MIP') {}
    preparator(:target => 'PMPCFG0') {}
    preparator(:target => 'PMPCFG1') {}
    preparator(:target => 'PMPCFG2') {}
    preparator(:target => 'PMPCFG3') {}
    preparator(:target => 'PMPADDR0') {}
    preparator(:target => 'PMPADDR1') {}
    preparator(:target => 'PMPADDR2') {}
    preparator(:target => 'PMPADDR3') {}
    preparator(:target => 'PMPADDR4') {}
    preparator(:target => 'PMPADDR5') {}
    preparator(:target => 'PMPADDR6') {}
    preparator(:target => 'PMPADDR7') {}
    preparator(:target => 'PMPADDR8') {}
    preparator(:target => 'PMPADDR9') {}
    preparator(:target => 'PMPADDR10') {}
    preparator(:target => 'PMPADDR11') {}
    preparator(:target => 'PMPADDR12') {}
    preparator(:target => 'PMPADDR13') {}
    preparator(:target => 'PMPADDR14') {}
    preparator(:target => 'PMPADDR15') {}
    preparator(:target => 'MCYCLE') {}
    preparator(:target => 'MINSTRET') {}
    preparator(:target => 'MHPMCOUNTER3') {}
    preparator(:target => 'MHPMCOUNTER4') {}
    preparator(:target => 'MHPMCOUNTER5') {}
    preparator(:target => 'MHPMCOUNTER6') {}
    preparator(:target => 'MHPMCOUNTER7') {}
    preparator(:target => 'MHPMCOUNTER8') {}
    preparator(:target => 'MHPMCOUNTER9') {}
    preparator(:target => 'MHPMCOUNTER10') {}
    preparator(:target => 'MHPMCOUNTER11') {}
    preparator(:target => 'MHPMCOUNTER12') {}
    preparator(:target => 'MHPMCOUNTER13') {}
    preparator(:target => 'MHPMCOUNTER14') {}
    preparator(:target => 'MHPMCOUNTER15') {}
    preparator(:target => 'MHPMCOUNTER16') {}
    preparator(:target => 'MHPMCOUNTER17') {}
    preparator(:target => 'MHPMCOUNTER18') {}
    preparator(:target => 'MHPMCOUNTER19') {}
    preparator(:target => 'MHPMCOUNTER20') {}
    preparator(:target => 'MHPMCOUNTER21') {}
    preparator(:target => 'MHPMCOUNTER22') {}
    preparator(:target => 'MHPMCOUNTER23') {}
    preparator(:target => 'MHPMCOUNTER24') {}
    preparator(:target => 'MHPMCOUNTER25') {}
    preparator(:target => 'MHPMCOUNTER26') {}
    preparator(:target => 'MHPMCOUNTER27') {}
    preparator(:target => 'MHPMCOUNTER28') {}
    preparator(:target => 'MHPMCOUNTER29') {}
    preparator(:target => 'MHPMCOUNTER30') {}
    preparator(:target => 'MHPMCOUNTER31') {}
    preparator(:target => 'MHPMEVENT3') {}
    preparator(:target => 'MHPMEVENT4') {}
    preparator(:target => 'MHPMEVENT5') {}
    preparator(:target => 'MHPMEVENT6') {}
    preparator(:target => 'MHPMEVENT7') {}
    preparator(:target => 'MHPMEVENT8') {}
    preparator(:target => 'MHPMEVENT9') {}
    preparator(:target => 'MHPMEVENT10') {}
    preparator(:target => 'MHPMEVENT11') {}
    preparator(:target => 'MHPMEVENT12') {}
    preparator(:target => 'MHPMEVENT13') {}
    preparator(:target => 'MHPMEVENT14') {}
    preparator(:target => 'MHPMEVENT15') {}
    preparator(:target => 'MHPMEVENT16') {}
    preparator(:target => 'MHPMEVENT17') {}
    preparator(:target => 'MHPMEVENT18') {}
    preparator(:target => 'MHPMEVENT19') {}
    preparator(:target => 'MHPMEVENT20') {}
    preparator(:target => 'MHPMEVENT21') {}
    preparator(:target => 'MHPMEVENT22') {}
    preparator(:target => 'MHPMEVENT23') {}
    preparator(:target => 'MHPMEVENT24') {}
    preparator(:target => 'MHPMEVENT25') {}
    preparator(:target => 'MHPMEVENT26') {}
    preparator(:target => 'MHPMEVENT27') {}
    preparator(:target => 'MHPMEVENT28') {}
    preparator(:target => 'MHPMEVENT29') {}
    preparator(:target => 'MHPMEVENT30') {}
    preparator(:target => 'MHPMEVENT31') {}
    preparator(:target => 'TSELECT') {}
    preparator(:target => 'TDATA1') {}
    preparator(:target => 'TDATA2') {}
    preparator(:target => 'TDATA3') {}
    preparator(:target => 'DCSR') {}
    preparator(:target => 'DPC') {}
    preparator(:target => 'DSCRATCH') {}
  end

  def run
    csrs_user = [ustatus, uie, utvec, uscratch, uepc, ucause, utval, uip, fflags, frm, fcsr, cycle,
                 time, instret, hpmcounter3, hpmcounter4, hpmcounter5, hpmcounter6, hpmcounter7,
                 hpmcounter8, hpmcounter9, hpmcounter10, hpmcounter11, hpmcounter12, hpmcounter13,
                 hpmcounter14, hpmcounter15, hpmcounter16, hpmcounter17, hpmcounter18, hpmcounter19,
                 hpmcounter20, hpmcounter21, hpmcounter22, hpmcounter23, hpmcounter24, hpmcounter25,
                 hpmcounter26, hpmcounter27, hpmcounter28, hpmcounter29, hpmcounter30, hpmcounter31]

    csrs_list = [ustatus, uie, utvec, uscratch, uepc, ucause, utval, uip, fflags, frm, fcsr, cycle,
                 time, instret, hpmcounter3, hpmcounter4, hpmcounter5, hpmcounter6, hpmcounter7,
                 hpmcounter8, hpmcounter9, hpmcounter10, hpmcounter11, hpmcounter12, hpmcounter13,
                 hpmcounter14, hpmcounter15, hpmcounter16, hpmcounter17, hpmcounter18, hpmcounter19,
                 hpmcounter20, hpmcounter21, hpmcounter22, hpmcounter23, hpmcounter24, hpmcounter25,
                 hpmcounter26, hpmcounter27, hpmcounter28, hpmcounter29, hpmcounter30, hpmcounter31,
                 sstatus, sedeleg, sideleg, sie, stvec, scounteren, sscratch, sepc, scause, stval,
                 sip, satp, mvendorid, marchid, mimpid, mhartid, mstatus, misa, medeleg, mideleg,
                 mie, mtvec, mcounteren, mscratch, mepc, mcause, mtval, mip, pmpcfg0, pmpcfg1,
                 pmpcfg2, pmpcfg3, pmpaddr0, pmpaddr1, pmpaddr2, pmpaddr3, pmpaddr4, pmpaddr5,
                 pmpaddr6, pmpaddr7, pmpaddr8, pmpaddr9, pmpaddr10, pmpaddr11, pmpaddr12, pmpaddr13,
                 pmpaddr14, pmpaddr15, mcycle, minstret, mhpmcounter3, mhpmcounter4, mhpmcounter5,
                 mhpmcounter6, mhpmcounter7, mhpmcounter8, mhpmcounter9, mhpmcounter10,
                 mhpmcounter11, mhpmcounter12, mhpmcounter13, mhpmcounter14, mhpmcounter15,
                 mhpmcounter16, mhpmcounter17, mhpmcounter18, mhpmcounter19, mhpmcounter20,
                 mhpmcounter21, mhpmcounter22, mhpmcounter23, mhpmcounter24, mhpmcounter25,
                 mhpmcounter26, mhpmcounter27, mhpmcounter28, mhpmcounter29, mhpmcounter30,
                 mhpmcounter31, mhpmevent3, mhpmevent4, mhpmevent5, mhpmevent6, mhpmevent7,
                 mhpmevent8, mhpmevent9, mhpmevent10, mhpmevent11, mhpmevent12, mhpmevent13,
                 mhpmevent14, mhpmevent15, mhpmevent16, mhpmevent17, mhpmevent18, mhpmevent19,
                 mhpmevent20, mhpmevent21, mhpmevent22, mhpmevent23, mhpmevent24, mhpmevent25,
                 mhpmevent26, mhpmevent27, mhpmevent28, mhpmevent29, mhpmevent30, mhpmevent31,
                 tselect, tdata1, tdata2, tdata3, dcsr, dpc, dscratch]

    csrs_user.each { |i|
      atomic {
        csrrs t0, i, zero
        csrrw t1, i, t0
      }.run
    }

    if 1!=1 then
      csrs_list.each { |i|
        atomic {
          csrrs t0, i, zero
          csrrw t1, i, t0
        }.run
      }
    end
  end

end
