package org.peterbjornx.pws.assembler;

import org.peterbjornx.pws.assembler.binfmt.VHDLSelectBinaryFormat;
import org.peterbjornx.pws.assembler.codegen.impl.PwsCodeGenerator;
import org.peterbjornx.pws.assembler.linker.ExecutableProgram;
import org.peterbjornx.pws.assembler.linker.SimpleLinker;
import org.peterbjornx.pws.assembler.util.AssemblerException;
import org.peterbjornx.pws.assembler.parser.impl.SimpleParser;

import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.PrintStream;

/**
 *
 * Part of Peter Bosch's final assignment
 * @author peterbjornx
 */
public class AssemblerMain {
    public static void main(String[] args) {
        try {
            if (args.length != 2)
                usage();
            SimpleParser parser = new SimpleParser();
            System.out.println("Assembling "+args[0]);
            parser.parseFile(args[0]);
            PwsCodeGenerator codegen = new PwsCodeGenerator(args[0], parser.getProgram());
            codegen.generate();
            System.out.println("Linking "+args[0]);
            ExecutableProgram ex = SimpleLinker.linkSingleObject(codegen.getObjectProgram(), args[0]);
            System.out.println("Generating VHDL ROM...");
            PrintStream ps = null;
            try {
                ps = new PrintStream(new FileOutputStream(args[1]));
            } catch (FileNotFoundException e) {
                throw new AssemblerException(-1, "fatal error: could not create file", args[1]);
            }
            VHDLSelectBinaryFormat.generateVHDL(ps, ex);
            ps.flush();
            ps.close();
        } catch (AssemblerException e) {
            System.err.println(e.getFile()+":"+e.getLineNumber()+" "+e.getMessage());
        }
    }

    private static void usage() {
        System.err.println("Usage: pwsasm <input>.s <output>.vhd");
        System.exit(-1);
    }
}
