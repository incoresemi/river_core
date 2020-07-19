TESTS = simple_auto\
        boundary_auto\
        group_auto

all: $(TESTS)

$(TESTS):
	sh ../run.sh $@
	sh ../run-toolchain.sh $@
