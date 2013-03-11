package org.peterbjornx.pws.assembler.parser;

/**
 * Part of Peter Bosch's final assignment
 *
 * @author peterbjornx
 */
public class AssemblyInstruction implements AssemblyEntity{
    private long   address;
    private String mnemonic;
    private int    rA = -1;
    private int    rB = -1;
    private int    rC = -1;
    private Object imm;
    private int    line;
    private String file;

    public AssemblyInstruction(int line, String file){
        this.line = line;
        this.file = file;
    }

    public AssemblyInstruction(long address, String mnemonic, int rA, int rB, int rC, Object imm, int line, String file) {
        this.address = address;
        this.mnemonic = mnemonic;
        this.rA = rA;
        this.rB = rB;
        this.rC = rC;
        this.imm = imm;
        this.line = line;
        this.file = file;
    }

    public AssemblyInstruction(long address, int line, String file) {
        this.address = address;
        this.line = line;
        this.file = file;
    }

    public void setAddress(long address) {
        this.address = address;
    }

    public void setMnemonic(String mnemonic) {
        this.mnemonic = mnemonic;
    }

    public void setrA(int rA) {
        this.rA = rA;
    }

    public void setrB(int rB) {
        this.rB = rB;
    }

    public void setrC(int rC) {
        this.rC = rC;
    }

    public void setImm(Object imm) {
        this.imm = imm;
    }

    public long getAddress() {
        return address;
    }

    public String getMnemonic() {
        return mnemonic;
    }

    public int getrA() {
        return rA;
    }

    public int getrB() {
        return rB;
    }

    public int getrC() {
        return rC;
    }

    public Object getImm() {
        return imm;
    }

    public int getLine() {
        return line;
    }

    public String getFile() {
        return file;
    }
}
