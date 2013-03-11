package org.peterbjornx.pws.assembler.targets;

/**
 * Part of Peter Bosch's final assignment
 *
 * @author peterbjornx
 */
public class PwsInstructionSet {
    public static final long LOAD_STORE_INSTR = 0;
    public static final long LOGIC_INSTR = 1;
    public static final long ARITHMETHIC_INSTR = 2;
    public static final long BRANCH_INSTR = 3;

    public static final long REGISTER_MASK = 0x1F;
    public static final long REG_A_START = 5;
    public static final long REG_B_START = 10;
    public static final long REG_C_START = 15;
    public static final long IMM_BIT = 1 << 2;
    public static final long IMM_MASK = 0xFFFFL;
    public static final long IMM_START = 16;

    public static final long CONDITION_LESS_THAN = 0;
    public static final long CONDITION_EQUALS = 1 << 4;
    public static final long CONDITION_GREATER_THAN = 2 << 4;
    public static final long CONDITION_UNCONDITIONAL = 3 << 4;

    public static final long JUMP_LR_BIT = 1 << 3;
    public static final long STORE_LR_BIT = 1 << 6;

    public static final long WRITE_BIT = 1 << 3;

    public static final long ALU_OP_OR_ADD = 0;
    public static final long ALU_OP_AND_SUB = 1 << 4;
    public static final long ALU_OP_XOR_MUL = 2 << 4;
    public static final long ALU_OP_NAND_CMP = 3 << 4;
    public static final long CARRY_BIT = 1 << 3;
}
