package org.peterbjornx.pws.assembler.codegen.impl;

import org.peterbjornx.pws.assembler.parser.AssemblyConstant;
import org.peterbjornx.pws.assembler.parser.AssemblyEntity;
import org.peterbjornx.pws.assembler.parser.AssemblyInstruction;
import org.peterbjornx.pws.assembler.parser.AssemblyProgram;
import org.peterbjornx.pws.assembler.targets.P2InstructionSet;
import org.peterbjornx.pws.assembler.targets.PwsInstructionSet;
import org.peterbjornx.pws.assembler.util.AssemblerException;
import org.peterbjornx.pws.assembler.util.CodeSegment;
import org.peterbjornx.pws.assembler.util.ObjectProgram;
import org.peterbjornx.pws.assembler.util.SymbolReference;

import java.util.LinkedList;

/**
 * Part of Peter Bosch's final assignment
 *
 * @author peterbjornx
 */
public class P2CodeGenerator {

    private ObjectProgram objectProgram;
    private AssemblyProgram inputProgram;


    public P2CodeGenerator(String filename, AssemblyProgram input) {
        inputProgram = input;
        objectProgram = new ObjectProgram(filename);
    }

    public void generate() throws AssemblerException {
        long lastIC = -3;
        LinkedList<AssemblyEntity> listing = inputProgram.getListing();
        LinkedList<Long> currentSeg = new LinkedList<Long>();
        CodeSegment segment = null;
        for (AssemblyEntity entity : listing) {
            long iC = entity.getAddress();
            if ((iC - lastIC) != 1){
                if (segment != null && currentSeg.size() != 0){
                    segment.setInstructions(currentSeg.toArray(new Long[currentSeg.size()]));
                    objectProgram.addSegment(segment);
                    currentSeg.clear();
                }
                segment = new CodeSegment();
                segment.setStartAddress(iC);
            }
            if (entity instanceof AssemblyConstant) {
                AssemblyConstant _const = (AssemblyConstant) entity;
                long[] data = _const.getData();
                if (data != null) {
                    for (long aData : data) currentSeg.addLast(aData);
                    lastIC = iC + data.length - 1;
                } else {
                    objectProgram.addSymbolReference(iC, new SymbolReference(_const.getLabelData(), 0, 0xFFFFFFFF, false));
                    currentSeg.addLast(0L);
                    lastIC = iC;
                }
            } else if (entity instanceof AssemblyInstruction) {
                AssemblyInstruction instr = (AssemblyInstruction) entity;
                long iw = 0;
                boolean noA = false;
                boolean noB = false;
                boolean noC = false;
                String mnemonic = instr.getMnemonic();
                boolean br = mnemonic.startsWith("b") || mnemonic.startsWith("r") || (mnemonic.startsWith("c") && !mnemonic.equals("cmp"));
                //Process operands
                Object imm = instr.getImm();
                if (instr.getrA() != -1)
                    iw |= (instr.getrA() & PwsInstructionSet.REGISTER_MASK) << PwsInstructionSet.REG_A_START;
                else
                    noA = true;
                if (instr.getrB() != -1)
                    iw |= (instr.getrB() & PwsInstructionSet.REGISTER_MASK) << PwsInstructionSet.REG_B_START;
                else
                    noB = true;
                if (imm != null) {
                    iw |= PwsInstructionSet.IMM_BIT;
                    if (imm instanceof String)
                        objectProgram.addSymbolReference(iC, new SymbolReference((String) imm, (int) PwsInstructionSet.IMM_START, PwsInstructionSet.IMM_MASK, br));
                    else
                        iw |= (((Long) imm) & PwsInstructionSet.IMM_MASK) << PwsInstructionSet.IMM_START;
                } else if (instr.getrC() != -1)
                    iw |= (instr.getrC() & PwsInstructionSet.REGISTER_MASK) << PwsInstructionSet.REG_C_START;
                else
                    noC = true;
                //Generate opcode
                if (br) {//Branch instrs
                    iw |= PwsInstructionSet.BRANCH_INSTR;
                    if (mnemonic.length() == 1){
                        iw |= PwsInstructionSet.CONDITION_UNCONDITIONAL;
                    } else if (mnemonic.length() == 3) {
                        String cond = mnemonic.substring(1, 3);
                        if (cond.equals("lt"))
                           iw |= PwsInstructionSet.CONDITION_LESS_THAN;
                        else if (cond.equals("eq"))
                            iw |= PwsInstructionSet.CONDITION_EQUALS;
                        else if (cond.equals("gt"))
                            iw |= PwsInstructionSet.CONDITION_GREATER_THAN;
                        else
                            throw new AssemblerException(instr.getLine(),"syntax error: unknown mnemonic:" + mnemonic, instr.getFile());
                    } else
                        throw new AssemblerException(instr.getLine(),"syntax error: unknown mnemonic:" + mnemonic, instr.getFile());
                    if (mnemonic.startsWith("r"))
                        iw |= PwsInstructionSet.JUMP_LR_BIT;
                    else if (mnemonic.startsWith("c"))
                        iw |= PwsInstructionSet.STORE_LR_BIT;
                   if (noC && !mnemonic.startsWith("r"))
                       throw new AssemblerException(instr.getLine(),"syntax error: branch without target", instr.getFile());
                   if (!(noA && noB))
                       throw new AssemblerException(instr.getLine(),"syntax error: too many registers specified", instr.getFile());
                } else if (mnemonic.startsWith("l") || mnemonic.startsWith("s")) {//Load/Store instrs
                    iw |= PwsInstructionSet.LOAD_STORE_INSTR;
                    if (mnemonic.startsWith("s"))
                        iw |= PwsInstructionSet.WRITE_BIT;
                    if (noA)
                        throw new AssemblerException(instr.getLine(),"syntax error: load/store without destination/source register", instr.getFile());
                    if (mnemonic.endsWith("lr")) {
                        iw |= PwsInstructionSet.MOV_LR_BIT;
                        if ((!noB) || (!noC))
                            throw new AssemblerException(instr.getLine(), "syntax error: load/store of link register with destination", instr.getFile());
                    } else {
                        if (imm == null && noB)
                            throw new AssemblerException(instr.getLine(), "syntax error: load/store without address base register", instr.getFile());
                        if (noC)
                            iw |= PwsInstructionSet.IMM_BIT;
                    }
                } else if (mnemonic.equals("and") || mnemonic.equals("or") || mnemonic.equals("nand") || mnemonic.equals("xor")) {
                    iw |= PwsInstructionSet.LOGIC_INSTR;
                    if (noC || noB)
                        throw new AssemblerException(instr.getLine(),"syntax error: too few operands", instr.getFile());
                    else if (mnemonic.equals("and"))
                        iw |= PwsInstructionSet.ALU_OP_AND_SUB;
                    else if (mnemonic.equals("or"))
                        iw |= PwsInstructionSet.ALU_OP_OR_ADD;
                    else if (mnemonic.equals("xor"))
                        iw |= PwsInstructionSet.ALU_OP_XOR_MUL;
                    else if (mnemonic.equals("nand"))
                        iw |= PwsInstructionSet.ALU_OP_NAND_CMP;
                } else if (mnemonic.startsWith("sub") || mnemonic.startsWith("add") || mnemonic.equals("mul") || mnemonic.equals("cmp")) {
                    iw |= PwsInstructionSet.ARITHMETHIC_INSTR;
                    if (noC || noB)
                        throw new AssemblerException(instr.getLine(),"syntax error: too few operands", instr.getFile());
                    else if (mnemonic.startsWith("sub"))
                        iw |= PwsInstructionSet.ALU_OP_AND_SUB;
                    else if (mnemonic.startsWith("add"))
                        iw |= PwsInstructionSet.ALU_OP_OR_ADD;
                    else if (mnemonic.equals("mul"))
                        iw |= PwsInstructionSet.ALU_OP_XOR_MUL;
                    else if (mnemonic.equals("cmp")){
                        iw |= PwsInstructionSet.ALU_OP_NAND_CMP;
                    } if (mnemonic.endsWith("."))
                        iw |= PwsInstructionSet.CARRY_BIT;
                } else
                    throw new AssemblerException(instr.getLine(),"syntax error: unknown mnemonic:" + mnemonic, instr.getFile());
                currentSeg.addLast(iw);
                lastIC = iC;
            }
        }
        if (segment != null && currentSeg.size() != 0){
            segment.setInstructions(currentSeg.toArray(new Long[currentSeg.size()]));
            objectProgram.addSegment(segment);
            currentSeg.clear();
        }
        objectProgram.setSymbolExports(inputProgram.getLabels());//TODO: Make it append
    }
    public ObjectProgram getObjectProgram() {
        return objectProgram;
    }

    public long encodeRegIndexedAddress(int baseReg, int indexReg, int multiplier)
    {
        long iw = 0;
        iw |= P2InstructionSet.IDX_BIT;
        iw |= (baseReg & P2InstructionSet.REGISTER_MASK) << P2InstructionSet.REG_B_START;
        iw |= (indexReg & P2InstructionSet.REGISTER_MASK) << P2InstructionSet.REG_C_START;
        iw |= (multiplier & P2InstructionSet.IMMS_MASK) << P2InstructionSet.IMMS_START;
        return iw;
    }

    public long encodeRegOffsetAddress(int baseReg, int offset)
    {
        long iw = 0;
        iw |= P2InstructionSet.IDX_BIT;
        iw |= (baseReg & P2InstructionSet.REGISTER_MASK) << P2InstructionSet.REG_B_START;
        iw |= (offset & P2InstructionSet.IMMW_MASK) << P2InstructionSet.IMMW_START;
        return iw;
    }

    public long encodePCIndexedAddress(int indexReg, int multiplier)
    {
        long iw = 0;
        iw |= P2InstructionSet.IDX_BIT;
        iw |= P2InstructionSet.PCREL_BIT;
        iw |= (indexReg & P2InstructionSet.REGISTER_MASK) << P2InstructionSet.REG_C_START;
        iw |= (multiplier & P2InstructionSet.IMMS_MASK) << P2InstructionSet.IMMS_START;
        return iw;
    }

    public long encodePCOffsetAddress(int offset)
    {
        long iw = 0;
        iw |= P2InstructionSet.IDX_BIT;
        iw |= P2InstructionSet.PCREL_BIT;
        iw |= (offset & P2InstructionSet.IMMW_MASK) << P2InstructionSet.IMMW_START;
        return iw;
    }
}
