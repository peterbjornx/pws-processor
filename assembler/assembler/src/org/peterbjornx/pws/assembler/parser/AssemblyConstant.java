package org.peterbjornx.pws.assembler.parser;

/**
 * Part of Peter Bosch's final assignment
 *
 * @author peterbjornx
 */
public class AssemblyConstant implements AssemblyEntity{
    private long   address;//NOTE: These are actually 32bit but as java doesn't know unsigned types this is easier to use
    private long[] data;
    private String labeldata;
    private int    line;
    private String file;

    public AssemblyConstant(long address, long[] data, int line, String file) {
        this.address = address;
        this.data = data;
        this.line = line;
        this.file = file;
    }

    public AssemblyConstant(long address, int line, String file) {
        this.address = address;
        this.line = line;
        this.file = file;
    }

    public long getAddress() {
        return address;
    }

    public long[] getData() {
        return data;
    }

    public void setData(long[] data) {
        this.data = data;
    }

    public String getLabelData() {
        return labeldata;
    }

    public void setLabelData(String labeldata) {
        this.labeldata = labeldata;
    }
}
