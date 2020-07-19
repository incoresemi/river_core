TESTS = rv32v_simple_selfcheck

all: $(TESTS)

$(TESTS):
	sh ../../run-selfcheck.sh $@
	sh ../../run-toolchain.sh $@
