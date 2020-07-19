TESTS = arithmetic\
        atomic\
        block\
        group\
        iterate\
        nitems\
        sequence

all: $(TESTS)

$(TESTS):
	sh ../../run.sh $@
	sh ../../run-toolchain.sh $@
