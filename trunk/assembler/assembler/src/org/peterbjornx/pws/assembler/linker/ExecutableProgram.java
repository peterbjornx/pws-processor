package org.peterbjornx.pws.assembler.linker;

import org.peterbjornx.pws.assembler.util.CodeSegment;
import org.peterbjornx.pws.assembler.util.SymbolReference;

import java.util.HashMap;
import java.util.LinkedList;

/**
 * Part of Peter Bosch's final assignment
 *
 * @author peterbjornx
 */
public class ExecutableProgram {
    private String file;
    private LinkedList<CodeSegment> codeSegments = new LinkedList<CodeSegment>();
    private HashMap<Long, SymbolReference> symbolReferences = new HashMap<Long, SymbolReference>();
    private HashMap<String, Long> symbolExports = new HashMap<String, Long>();

    public ExecutableProgram(String file) {
        this.file = file;
    }

    public void addSegment(CodeSegment codeSegment) {
        codeSegments.addLast(codeSegment);
    }

    public LinkedList<CodeSegment> getCodeSegments() {
        return codeSegments;
    }
}
