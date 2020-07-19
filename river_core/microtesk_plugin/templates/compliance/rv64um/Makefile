TESTS = div\
        divu\
        divuw\
        divw\
        mulh\
        mulhsu\
        mulhu\
        mul\
        mulw\
        rem\
        remu\
        remuw\
        remw

all: $(TESTS)

$(TESTS):
	sh ../../run.sh $@
	sh ../../run-toolchain.sh $@
