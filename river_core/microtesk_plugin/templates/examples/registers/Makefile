TESTS = register\
        register_allocation\
        register_exclude_retain\
        register_reservation_auto\
        register_reservation_manual

all: $(TESTS)

$(TESTS):
	sh ../../run.sh $@
	sh ../../run-toolchain.sh $@
