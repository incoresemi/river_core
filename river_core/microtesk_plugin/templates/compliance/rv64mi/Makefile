TESTS = access\
        breakpoint\
        mcsr

all: $(TESTS)

$(TESTS):
	sh ../../run.sh $@
	sh ../../run-toolchain.sh $@
