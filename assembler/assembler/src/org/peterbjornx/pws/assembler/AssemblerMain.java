package org.peterbjornx.pws.assembler;

import org.peterbjornx.pws.assembler.binfmt.VHDLSelectBinaryFormat;
import org.peterbjornx.pws.assembler.codegen.impl.PwsCodeGenerator;
import org.peterbjornx.pws.assembler.linker.ExecutableProgram;
import org.peterbjornx.pws.assembler.linker.SimpleLinker;
import org.peterbjornx.pws.assembler.util.AssemblerException;
import org.peterbjornx.pws.assembler.parser.impl.SimpleParser;

/**
 *
 * Part of Peter Bosch's final assignment
 * @author peterbjornx
 */
public class AssemblerMain {
    public static void main(String[] args) {
        SimpleParser p = new SimpleParser();
        final PwsCodeGenerator g;
        ExecutableProgram exec;
        try {
            System.out.println("Parsing...");
            p.parseFile("assembler/test.s");
            System.out.println("Generating code...");
            g = new PwsCodeGenerator("assembler/test.o", p.getProgram());
            g.generate();
            System.out.println("Linking...");
            exec = SimpleLinker.linkSingleObject(g.getObjectProgram(),"assembler/test.vhd");
            System.out.println("Generating VHDL...");
            VHDLSelectBinaryFormat.generateVHDL(System.out,exec);
            System.out.println("done.");
        } catch (AssemblerException e) {
            System.err.println(e.getFile()+":"+e.getLineNumber()+" "+e.getMessage());
        }
    }
}
