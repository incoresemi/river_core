TESTS = amoadd_d\
        amoand_d\
        amomax_d\
        amomaxu_w\
        amomin_d\
        amominu_w\
        amoor_d\
        amoswap_d\
        amoxor_d\
        lrsc\
        amoadd_w\
        amoand_w\
        amomaxu_d\
        amomax_w\
        amominu_d\
        amomin_w\
        amoor_w\
        amoswap_w\
        amoxor_w

all: $(TESTS)

$(TESTS):
	sh ../../run.sh $@
	sh ../../run-toolchain.sh $@
