package org.peterbjornx.pws.assembler.targets;

/**
 * Part of Peter Bosch's final assignment
 *
 * @author peterbjornx
 */
public class P2InstructionSet {
    public static final long LOAD_STORE_INSTR = 0;
    public static final long LOGIC_INSTR = 1;
    public static final long ARITHMETHIC_INSTR = 2;
    public static final long BRANCH_INSTR = 3;

    public static final long REGISTER_MASK = 0x0F;
    public static final long REG_A_START = 7;
    public static final long REG_B_START = 11;
    public static final long REG_C_START = 15;
    public static final long IMMW_MASK = 0x1FFFFL;
    public static final long IMMW_START = 15;
    public static final long IMMS_MASK = 0x1FFFL;
    public static final long IMMS_START = 19;

    /** Addressing mode bits **/
    public static final long PCREL_BIT = 1 << 3;
    public static final long IDX_BIT = 1 << 4;

    /** Load/Store bits **/
    public static final long WRITE_BIT = 1 << 2;
    public static final long SR_BIT = 1 << 5;
    public static final long WB_BIT = 1 << 6;

    /** Branch bits **/
    public static final long CONDITION_UNCONDITIONAL = 7 << 7;

    public static final long CALL_BIT = 1 << 2;
    public static final long RETURN_BIT = 1 << 5;

    /** Arithmetical bits **/
    /*public static final long ALU_OP_OR_ADD = 0;
    public static final long ALU_OP_AND_SUB = 1 << 4;
    public static final long ALU_OP_XOR_MUL = 2 << 4;
    public static final long ALU_OP_NAND_CMP = 3 << 4;
    public static final long CARRY_BIT = 1 << 3;*/
}
