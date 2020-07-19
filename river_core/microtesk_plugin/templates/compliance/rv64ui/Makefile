TESTS = addi\
        addw\
        auipc\
        bgeu\
        bne\
        jalr\
        ld\
        lui\
        ori\
        sd\
        slli\
        sllw\
        slt\
        sraiw\
        srli\
        srlw\
        sw\
        addiw\
        andi\
        beq\
        blt\
        fence_i\
        lb\
        lh\
        lw\
        or\
        sh\
        slliw\
        slti\
        sltu\
        sra\
        srliw\
        sub\
        xori\
        add\
        and\
        bge\
        bltu\
        jal\
        lbu\
        lhu\
        lwu\
        sb\
        simple\
        sll\
        sltiu\
        srai\
        sraw\
        srl\
        subw\
        xor

all: $(TESTS)

$(TESTS):
	sh ../../run.sh $@
	sh ../../run-toolchain.sh $@
