package org.peterbjornx.pws.assembler.binfmt;

import org.peterbjornx.pws.assembler.linker.ExecutableProgram;
import org.peterbjornx.pws.assembler.util.CodeSegment;

import java.io.PrintStream;
import java.util.LinkedList;

/**
 * Part of Peter Bosch's final assignment
 *
 * @author peterbjornx
 */
public class VHDLSelectBinaryFormat {
    public static void generateVHDL(PrintStream out, ExecutableProgram exec) {
        out.println("with address select");
        out.print("data <= ");
        LinkedList<CodeSegment> segs = exec.getCodeSegments();
        for (CodeSegment inSeg : segs) {
            long[] instrs = inSeg.getInstructions();
            long base = inSeg.getStartAddress();
            for (int addr = 0; addr < instrs.length; addr++)
                out.println("\tx\""+to32Hex(instrs[addr])+"\" when x\""+to32Hex(base + addr)+"\",");
        }
        out.println("\tx\"00000000\" when others;");
    }

    private static String to32Hex(long l) {
        String res= "00000000" + Long.toHexString(l & 0xFFFFFFFFL);
        return res.substring(res.length() - 8,res.length());

    }
}
