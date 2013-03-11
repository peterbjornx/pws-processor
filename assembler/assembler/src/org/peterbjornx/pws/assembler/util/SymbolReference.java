package org.peterbjornx.pws.assembler.util;

/**
 * Part of Peter Bosch's final assignment
 *
 * @author peterbjornx
 */
public class SymbolReference {
    private final String name;
    private final int bitOffset;
    private final long mask;
    private boolean relative;

    public SymbolReference(String name, int bitOffset, long mask, boolean relative) {
        this.name = name;
        this.bitOffset = bitOffset;
        this.mask = mask;
        this.relative = relative;
    }

    public String getName() {
        return name;
    }

    public int getBitOffset() {
        return bitOffset;
    }

    public long getMask() {
        return mask;
    }

    public boolean isRelative() {
        return relative;
    }
}
