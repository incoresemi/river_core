# See LICENSE for details

import spike_intf
import random
import sys
import os
import shutil
import cocotb
import logging as log
from cocotb.decorators import coroutine
from cocotb.triggers import Timer, RisingEdge
from cocotb.monitors import BusMonitor
from cocotb.drivers import BusDriver
from cocotb.binary import BinaryValue
from cocotb.regression import TestFactory
from cocotb.scoreboard import Scoreboard
from cocotb.result import TestFailure
from cocotb.clock import Clock
import subprocess
import glob 

def touch(fname):
    open(fname, 'a').close()
    os.utime(fname, None)

def sys_command_file(command, filename):
    cmd = command.split(' ')
    cmd = [x.strip(' ') for x in cmd]
    cmd = [i for i in cmd if i] 
    print('{0} > {1}'.format(' '.join(cmd), filename))
    fp = open(filename, 'w')
    out = subprocess.Popen(cmd, stdout=fp, stderr=fp)
    stdout, stderr = out.communicate()
    fp.close()

class StatePacket(object):
    """Class for defining and maintaining the StatePacket"""
    def __init__(self):
        # super(StatePacket, self).__init__()
        self.reg_num = 32
        self.pc = 0
        #self.csr = CsrFile(csr)
        self.inst = 0
        self.priv = 0
        self.index = 0
        self.data = 0
        self.rtype = 0
        self.gpr = []
        self.fpr = []
        self.csr = dict()
        self.csr['mstatus'] = 0
        self.csr['fcsr'] = 0
        for x in range(self.reg_num):
            self.gpr.append(0)
            self.fpr.append(0)
   

    def print_state(self):
        print('PC {0}'.format(hex(self.pc)))
        #print('{0} x{1} -> {2}'.format(hex(self.pc), self.index, hex(self.data)))
        message = ''
        for x in range(self.reg_num):
            message = message + '[x{0:<2}] {1:<11}'.format(x, hex(self.gpr[x]))
        print(message)
        message = '\n'
        for x in range(self.reg_num):
            message = message + '[f{0:<2}] {1:<11}'.format(x, hex(self.fpr[x]))
        print(message)


def get_inst_mnemonic(instr):
    """ Utility function to get the inst in mnemonic form"""
    cmd = 'echo "DASM('+'0x'+instr[2:]+')" | spike-dasm'
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True)

    (output, err) = p.communicate()
    # inst_mnemo = output.split("b\'")[1].split("\n")[0]

    return output.decode("utf-8").split("\n")[0]

def get_value(val):
    """ Utility function for converting bin to int """
    return int(''.join(map(str, val[::-1])), 2)

@cocotb.coroutine
def clock_gen(signal):
    while True:
        signal <= 0
        yield Timer(1) # ps
        signal <= 1
        yield Timer(1) # ps

@cocotb.test()
def run_test(dut):

    pwd = os.getcwd()
    fdir = os.getcwd()
    
    print(fdir)
    test_file = None
    test_list = glob.glob('{0}/*.elf'.format(fdir))
    print(test_list)
    if len(test_list) == 1: 
        test_file = test_list[0]
    else:
        message = 'More than one elf in the path'
        touch('STATUS_FAILED')
        dut._log.error(message)
        exit(1)   

    fbase = os.path.basename(test_file)
    fname = os.path.splitext(fbase)[0]
    print(fbase)
    print(fname)
    sim_result = 1

    cocotb.fork(clock_gen(dut.CLK))
    dut.RST_N <= 0
    for i in range(5):
        yield RisingEdge(dut.CLK)
    dut.RST_N <= 1
    ifc = spike_intf.spike_intf(test_file)
    ifc.initialise('rv64imafdc')
    trace = 1
    if trace:
        f = open('{0}_trace.log'.format(fname), 'w')
    prev_model_packet = StatePacket()
    instr_count = 1
    sim_result = 0
    message = ''
    for i in range(30000):
        yield RisingEdge(dut.CLK)
        commit = dut.soc.ccore.riscv.stage5.WILL_FIRE_dump_get.value.integer

        ## priv : 2 bits
        ## pc : xlen bits
        ## instr : 32
        ## index: 5 bits
        ## data : XLEN bits
        ## type : 1 bit

        dump = dut.soc.ccore.riscv.stage5.dump_get.value
        priv_str = 'M'
        if commit == 1:
            dump_r = [c for c in str(dump)][::-1]
            DATA_LSB = 1
            DATA_MSB = 64
            INDEX_LSB = 65
            INDEX_MSB = 69
            INST_LSB = 70
            INST_MSB = 101
            PC_LSB = 102
            PC_MSB = 165
            PRIV_LSB = 166
            PRIV_MSB = 167
            MAX_LEN = 168

            dut_packet = StatePacket()
            dut_packet.priv = get_value(dump_r[PRIV_LSB:PRIV_MSB+1])
            dut_packet.pc = get_value(dump_r[PC_LSB:PC_MSB+1])
            dut_packet.inst = get_value(dump_r[INST_LSB:INST_MSB+1])
            dut_packet.index = get_value(dump_r[INDEX_LSB:INDEX_MSB+1])
            dut_packet.data = get_value(dump_r[DATA_LSB:DATA_MSB+1])
            dut_packet.rtype = int(str(dump_r[0]),2)
            for i in range(32):
                dut_packet.gpr[i] = dut.soc.ccore.riscv.stage2.registerfile.integer_rf.arr[i].value.integer
            
            for i in range(32):
                dut_packet.fpr[i] = dut.soc.ccore.riscv.stage2.registerfile.floating_rf.arr[i].value.integer

            if dut_packet.inst == int(0x73):
                print('ECALL encountered: End of Simulation\n')
                break
            if trace:
                if dut_packet.priv == 3:
                    priv_str = 'M'
                elif dut_packet.priv == 0:
                    priv_str = 'U'
                elif dut_packet.priv == 1:
                    priv_str == 'S'
                if dut_packet.rtype == 1:
                    rtype_str = 'f'
                else:
                    rtype_str = 'x'
                f.write('{0} {1:016x} {2:<25} | {3}{4:02} -> {5:016x}\n'.format(priv_str, dut_packet.pc, get_inst_mnemonic(hex(dut_packet.inst)), rtype_str, dut_packet.index, dut_packet.data))
            #print('DUT')
            #dut_packet.csr['mstatus'] = dut.soc.ccore.riscv.stage5.csr.csrfile.mk_grp1.mv_csr_mstatus.value.integer

            model_packet = StatePacket()
            PC = 0x1020
            XPR = 0x1000
            FPR = 0x1021
            PRIV = 0x1041
            model_packet.pc = ifc.get_variable(PC)
            #print(hex(ifc.get_variable(model_packet.pc)))
            model_packet.priv = ifc.get_variable(PRIV)
            ifc.single_step()
            for i in range(32):
                xpr_index = XPR + i
                model_packet.gpr[i] = ifc.get_variable(xpr_index)

            for i in range(32):
                fpr_index = FPR + i
                model_packet.fpr[i] = ifc.get_variable(fpr_index)
          
            model_packet.csr['mstatus'] = ifc.get_variable(0x300)
            #print('MODEL')
            #model_packet.print_state()
            #print('DUT')
            #dut_packet.print_state()
            #if dut_packet.csr['mstatus'] != model_packet.csr['mstatus']:
            #    message = 'ERROR: MSTATUS mismatch dut_csr_mstatus: {0} model_csr_mstatus {1} @PC {2}'.format(hex(dut_packet.csr['mstatus']), hex(model_packet.csr['mstatus']), hex(model_packet.pc))
            #    sim_result = 5

            if dut_packet.pc != model_packet.pc:
                message = 'ERROR: PC mismatch dut_pc: {0} model_pc {1}'.format(hex(dut_packet.pc), hex(model_packet.pc))
                sim_result = 1
            if dut_packet.priv != model_packet.priv:
                message = 'ERROR: PRIV mismatch dut_priv: {0} model_priv {1}'.format(hex(dut_packet.priv), hex(model_packet.priv))
                sim_result = 2
            
            for i in range(32):
                if model_packet.gpr[i] != dut_packet.gpr[i]:
                    message = 'ERROR : Model: x{0} -> {1} DUT: x{0} -> {2} at PC {3}'.format(i, hex(model_packet.gpr[i]), hex(dut_packet.gpr[i]), hex(model_packet.pc))
                    sim_result = 3

            for i in range(32):
                if model_packet.fpr[i] != dut_packet.fpr[i]:
                    message = 'ERROR : Model: f{0} -> {1} DUT: f{0} -> {2} at PC {3}'.format(i, hex(model_packet.fpr[i]), hex(dut_packet.fpr[i]), hex(model_packet.pc))
                    sim_result = 4
#                if model_packet.gpr[i] != prev_model_packet.gpr[i]:
#                    if dut_packet.index != i:
#                        message = 'ERROR: Model index x{0} {1} -> {2} DUT: x{3} -> {4} at PC {4}'.format(i, hex(prev_model_packet.gpr[i]), hex(model_packet.gpr[i]), dut_packet.index, hex(dut_packet.data), hex(dut_packet.pc))
#                        sim_result = 3
#                    else:
#                        if dut_packet.data != model_packet.gpr[i]:
#                            message = 'Model: x{0} {1} -> {2} DUT: x{3} -> {4} at PC {5}'.format(i, hex(prev_model_packet.gpr[i]), hex(model_packet.gpr[i]), dut_packet.index, hex(dut_packet.data), hex(dut_packet.pc))
#                            sim_result = 4

            if sim_result !=0:
                touch('STATUS_FAILED')
                dut._log.error(message)
                exit(1)
            prev_model_packet = model_packet

            instr_count = instr_count + 1
    
    if sim_result == 0:
        print('----------------------------')
        print('{0} | PASSED'.format(fname))
        print('----------------------------')
        touch('PASSED')
    f.close()
