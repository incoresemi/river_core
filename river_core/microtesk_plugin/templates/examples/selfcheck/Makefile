TESTS = selfcheck\

all: $(TESTS)

$(TESTS):
	sh ../../run-selfcheck.sh $@
	sh ../../run-toolchain.sh $@
