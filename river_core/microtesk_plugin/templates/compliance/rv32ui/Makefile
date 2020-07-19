TESTS = addi\
        andi\
        auipc\
        bge\
        blt\
        bne\
        jal\
        lb\
        lh\
        lui\
        ori\
        sb\
        simple\
        sll\
        sltiu\
        sltu\
        sra\
        srl\
        sw\
        xor\
        add\
        and\
        beq\
        bgeu\
        bltu\
        fence_i\
        jalr\
        lbu\
        lhu\
        lw\
        or\
        sh\
        slli\
        slti\
        slt\
        srai\
        srli\
        sub\
        xori

all: $(TESTS)

$(TESTS):
	sh ../../run.sh $@
	sh ../../run-toolchain.sh $@
