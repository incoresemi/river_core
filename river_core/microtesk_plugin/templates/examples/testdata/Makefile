TESTS = boundary_data\
        random\
        situation\
        testdata

all: $(TESTS)

$(TESTS):
	sh ../../run.sh $@
	sh ../../run-toolchain.sh $@
