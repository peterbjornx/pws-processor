package org.peterbjornx.pws.assembler.util;

import java.util.LinkedList;

/**
 * Part of Peter Bosch's final assignment
 *
 * @author peterbjornx
 */
public class CodeSegment {
    private long startAddress;
    private long[] instructions;

    public long getStartAddress() {
        return startAddress;
    }

    public void setStartAddress(long startAddress) {
        this.startAddress = startAddress;
    }

    public long[] getInstructions() {
        return instructions;
    }

    public void setInstructions(long[] instructions) {
        this.instructions = instructions;
    }

    public void setInstructions(Long[] instructions) {
        this.instructions = new long[instructions.length];
        for (int i = 0; i < instructions.length; i++)
            this.instructions[i] = instructions[i];
    }
}
