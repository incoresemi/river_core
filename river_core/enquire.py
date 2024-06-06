import river_core.utils as utils
import pytest
import os
import lief
from river_core.main import enquire

testyaml_dict = utils.load_yaml(enquire.test_list)
hart_id = str(enquire.hart_id)
@pytest.mark.parametrize('testname', testyaml_dict.keys())
def test_enquire(testname):
    '''
    Utility function that gives the status of each test 
    '''
    node = testyaml_dict[testname]
    # check if compilation of the test is over
    elffile = node['work_dir'] + '/'+testname + '.elf'
    if not os.path.exists(elffile):
        assert False, testname + ' has not compiled.\n'
    else:
        dumpfile = node['work_dir'] + '/dut.dump'
        if os.path.exists(dumpfile):
            # check if dtl.dump is created
            # check if dut.dump is complete
            binary = lief.parse(elffile)
            tohost_addr = str.format('0x{:08X}', int(hex(binary.get_symbol('tohost').value), 16))
            with open(dumpfile) as rtlfptr:
                dump_lines = rtlfptr.readlines()
                last_line = dump_lines[-1]
                if tohost_addr.lower() not in last_line:
                    assert False, testname + ' tohost is not written to yet'
                else:
                    # check if spike simulation is over
                    spikedumpfile = node['work_dir'] + '/ref.dump'
                    # check if tohost is written to in spike dump
                    with open(spikedumpfile) as spikefptr:
                        spike_dump_lines = spikefptr.readlines()
                        last_line = spike_dump_lines[-1]
                        if tohost_addr.lower() not in last_line:
                            assert False, testname + ' spike simulation has some errors'
        else:
            dumpfile = node['work_dir'] + '/rtl_'+ hart_id +'.dump'
            if not os.path.exists(dumpfile):
                assert False, testname + ' rtl dump not created'
            # check if rtl<coreid>.dump is complete
            else:
                binary = lief.parse(elffile)
                tohost_addr = str.format('0x{:08X}', int(hex(binary.get_symbol('tohost').value), 16))
                with open(dumpfile) as rtlfptr:
                    dump_lines = rtlfptr.readlines()
                    last_line = dump_lines[-1]
                    if tohost_addr not in last_line:
                        assert False, testname + ' tohost is not written to yet'