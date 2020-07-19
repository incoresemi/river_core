TESTS = debug_jalr\
        debug_la\
        debug_ld_sd\
        debug_ld_sd_sv39\
        debug_ld_sd_sv48\
        debug_li\
        debug_lw_sw\
        debug_lw_sw_sv32\
        debug_rv32a\
        debug_rv32d\
        debug_rv32f\
        debug_rv32f2\
        debug_rv32i\
        debug_rv32m\
        debug_rv32v\
        debug_rv64a\
        debug_rv64d\
        debug_rv64f\
        debug_rv64i\
        debug_rv64m\
        debug_rvc

all: $(TESTS)

$(TESTS):
	sh ../run.sh $@
	sh ../run-toolchain.sh $@
