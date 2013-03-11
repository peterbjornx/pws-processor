package org.peterbjornx.pws.assembler.util;

import java.util.HashMap;
import java.util.LinkedList;

/**
 * Part of Peter Bosch's final assignment
 *
 * @author peterbjornx
 */
public class ObjectProgram {
    private String file;
    private LinkedList<CodeSegment> codeSegments = new LinkedList<CodeSegment>();
    private HashMap<Long, SymbolReference> symbolReferences = new HashMap<Long, SymbolReference>();
    private HashMap<String, Long> symbolExports = new HashMap<String, Long>();

    public ObjectProgram(String file) {
        this.file = file;
    }

    public void addSegment(CodeSegment codeSegment) {
        codeSegments.addLast(codeSegment);
    }

    public LinkedList<CodeSegment> getCodeSegments() {
        return codeSegments;
    }

    public SymbolReference addSymbolReference(Long key, SymbolReference value) {
        return symbolReferences.put(key, value);
    }

    public SymbolReference getSymbolReference(Long key) {
        return symbolReferences.get(key);
    }

    public Long addSymbolExport(String key, Long value) {
        return symbolExports.put(key, value);
    }

    public Long getSymbolExport(String key) {
        return symbolExports.get(key);
    }

    public String getFile() {
        return file;
    }

    public void setSymbolExports(HashMap<String, Long> symbolExports) {
        this.symbolExports = symbolExports;
    }
}
