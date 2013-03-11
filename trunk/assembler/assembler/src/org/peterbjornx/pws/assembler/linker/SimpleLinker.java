package org.peterbjornx.pws.assembler.linker;

import org.peterbjornx.pws.assembler.util.CodeSegment;
import org.peterbjornx.pws.assembler.util.ObjectProgram;
import org.peterbjornx.pws.assembler.util.AssemblerException;
import org.peterbjornx.pws.assembler.util.SymbolReference;

import java.util.LinkedList;

/**
 * Part of Peter Bosch's final assignment
 *
 * @author peterbjornx
 */
public class SimpleLinker {

    public static ExecutableProgram linkSingleObject(ObjectProgram obj ,String file) throws AssemblerException {
        ExecutableProgram exec = new ExecutableProgram(file);
        LinkedList<CodeSegment> segs = obj.getCodeSegments();
        for (CodeSegment inSeg : segs)
            exec.addSegment(linkSegment(obj, inSeg));
        return exec;
    }

    private static CodeSegment linkSegment(ObjectProgram obj, CodeSegment segment) throws AssemblerException {
        CodeSegment target = new CodeSegment();
        long base = segment.getStartAddress();
        long[] obj_instr = segment.getInstructions();
        long[] targ_instr = new long[obj_instr.length];
        target.setStartAddress(base);
        for (int addr = 0; addr < targ_instr.length; addr++){
            SymbolReference ref = obj.getSymbolReference(base+addr);
            targ_instr[addr] = obj_instr[addr];
            if (ref != null){
                long wr;
                Long exp = obj.getSymbolExport(ref.getName());
                if (exp == null)
                    throw new AssemblerException(-1, "link error: undefined symbol referenced:"+ref.getName(), obj.getFile());
                if (ref.isRelative())
                    wr = exp - (base + addr);
                else
                    wr = exp;
                targ_instr[addr] |= (wr & ref.getMask()) << ref.getBitOffset();
            }
        }
        target.setInstructions(targ_instr);
        return target;
    }

}
