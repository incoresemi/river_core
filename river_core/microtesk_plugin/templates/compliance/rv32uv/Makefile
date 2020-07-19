TESTS = rv32v_vadd_vl32e32m4d1_selfcheck\
        rv32v_vdiv_vl32e32m4d1_selfcheck\
        rv32v_vmul_vl32e32m4d1_selfcheck\
        rv32v_vsub_vl32e32m4d1_selfcheck

all: $(TESTS)

$(TESTS):
	sh ../../run-selfcheck.sh $@
	sh ../../run-toolchain.sh $@
