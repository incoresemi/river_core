TESTS = numeric_label\
        numeric_label_random\
        weak_symbol

all: $(TESTS)

$(TESTS):
	sh ../../run.sh $@
	sh ../../run-toolchain.sh $@
