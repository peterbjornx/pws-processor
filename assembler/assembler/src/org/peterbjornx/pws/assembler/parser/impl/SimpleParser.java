package org.peterbjornx.pws.assembler.parser.impl;

import org.peterbjornx.pws.assembler.util.AssemblerException;
import org.peterbjornx.pws.assembler.parser.AssemblyConstant;
import org.peterbjornx.pws.assembler.parser.AssemblyInstruction;
import org.peterbjornx.pws.assembler.parser.AssemblyProgram;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;

/**
 * Part of Peter Bosch's final assignment
 *
 * @author peterbjornx
 */
public class SimpleParser {
    private int lineNumber = -1;
    private BufferedReader reader;
    private String file;
    private AssemblyProgram program = new AssemblyProgram();
    private long programCounter;

    private String getNextLine() throws AssemblerException {
        try {
            lineNumber++;
            return reader.readLine();
        } catch (IOException e) {
            throw new AssemblerException(lineNumber, "error reading input file", file);
        }
    }

    public void parseFile(String file) throws AssemblerException {
        this.file = file;
        try {
            lineNumber = -1;
            reader = new BufferedReader(new FileReader(file));
            for (;;){
                String line = getNextLine();
                if (line == null)
                    return;
                else
                    parseLine(line);
            }
        } catch (FileNotFoundException e) {
            throw new AssemblerException(-1, "error opening input file", file);
        }
    }

    private void parseLine(String line) throws AssemblerException {
        //First trim all whitespace sequences down to single whitespaces and strip indentation
        line = line.replaceAll("\t"," ");
        while (line.contains("  "))
            line = line.replaceAll("  "," ");
        line = line.trim();
        line = line.replaceAll(" ,",",");
        line = line.replaceAll(", ",",");
        line = line.replaceAll(" =","=");
        line = line.replaceAll("= ", "=");
        //Now split statement into space separated blocks
        String[] tokens = line.contains(";") ? line.split(";")[0].split(" ") : line.split(" ");
        for (String token : tokens) {
            if (token.length() == 0) {
            }
            else if (token.endsWith(":")) {
                String labelName = token.replaceAll(":","");
                if (labelName.length() == 0)
                    throw new AssemblerException(lineNumber, "syntax error: nameless label", file);
                if (program.getLabelAddress(labelName) != null)
                    throw new AssemblerException(lineNumber, "redefinition of label "+labelName, file);
                program.addLabel(labelName, programCounter);
            } else if (token.contains("=")){
                String[] subTokens = token.split("=");
                long labelAddress;
                if (subTokens.length != 2)
                    throw new AssemblerException(lineNumber, "syntax error: invalid label definition", file);
                if (subTokens[0].length() == 0)
                    throw new AssemblerException(lineNumber, "syntax error: nameless label", file);
                labelAddress = parse32BitLiteral(subTokens[1],"syntax error: address expected:");
                if (subTokens[0].equalsIgnoreCase("org")){
                    programCounter = labelAddress;
                } else {
                    if (program.getLabelAddress(subTokens[0]) != null)
                        throw new AssemblerException(lineNumber, "redefinition of label "+subTokens[0], file);
                    program.addLabel(subTokens[0], labelAddress);
                }
            } else if (token.startsWith(".")){
                parsePseudoOp(tokens);
                break;
            } else {
                parseInstruction(tokens);
                break;
            }
        }
    }

    private long parse32BitLiteral(String literal,String error) throws AssemblerException {
        if (literal.startsWith("0x"))
            try {
                return Long.parseLong(literal.substring(2, literal.length()), 16) & 0xFFFFFFFFL;
            } catch (NumberFormatException nF) {
                throw new AssemblerException(lineNumber, "syntax error: invalid hex literal:"+literal, file);
            }
        else if (literal.startsWith("0b"))
            try {
                return Long.parseLong(literal.substring(2, literal.length()), 2) & 0xFFFFFFFFL;
            } catch (NumberFormatException nF) {
                throw new AssemblerException(lineNumber, "syntax error: invalid binary literal:"+literal, file);
            }
        else if (literal.startsWith("0") && literal.length() != 1)
            try {
                return Long.parseLong(literal.substring(1, literal.length()), 2) & 0xFFFFFFFFL;
            } catch (NumberFormatException nF) {
                throw new AssemblerException(lineNumber, "syntax error: invalid octal literal:"+literal, file);
            }
        else if (literal.length() != 0)
            try {
                return Long.parseLong(literal, 10) & 0xFFFFFFFFL;
            } catch (NumberFormatException nF) {
                throw new AssemblerException(lineNumber, "syntax error: invalid decimal literal:"+literal, file);
            }
        else
            throw new AssemblerException(lineNumber, error + literal, file);
    }

    private int parseRegister(String literal) throws AssemblerException {
        if (literal.length() != 1)
            try {
                int i = Integer.parseInt(literal.substring(1, literal.length()), 10);
                if (i > 31 || i < 0)
                    throw new AssemblerException(lineNumber, "syntax error: nonexistent register referenced:+literal", file);
                return i;
            } catch (NumberFormatException nF) {
                throw new AssemblerException(lineNumber, "syntax error: invalid register reference:"+literal, file);
            }
        else
            throw new AssemblerException(lineNumber, "syntax error: invalid register reference:"+literal, file);
    }

    private void parseInstruction(String[] tokens) throws AssemblerException {
        AssemblyInstruction instr = null;
        boolean isBranch = false;
        for (String token : tokens) {
            if (token.length() == 0) {
            }
            else if (token.endsWith(":") || token.contains("=")){}
            else if (token.startsWith(".")) {
                throw new AssemblerException(lineNumber, "syntax error: orphaned pseudoinstruction", file);
            } else if (instr != null) {
                String subTokens[] = token.split(",");
                int regCtr = 0;
                boolean haveImm = false;
                for (String subToken : subTokens){
                    if (subToken.startsWith("r")){
                        if (regCtr != 0 || !isBranch) {
                            switch (regCtr & 0xF){
                                case 0:
                                    instr.setrA(parseRegister(subToken));
                                    break;
                                case 1:
                                    instr.setrB(parseRegister(subToken));
                                    break;
                                case 2:
                                    if (isBranch)
                                        throw new AssemblerException(lineNumber, "syntax error: too many registers specified", file);
                                    instr.setrC(parseRegister(subToken));
                                    break;
                                default:
                                    throw new AssemblerException(lineNumber, "syntax error: too many registers specified", file);
                            }
                            regCtr++;
                        } else {
                            instr.setrC(parseRegister(subToken));
                            regCtr = 0x10;
                        }
                    } else if (!haveImm) {
                        if (subToken.startsWith("&"))
                            instr.setImm(subToken.substring(1, subToken.length()));
                        else
                            instr.setImm(parse32BitLiteral(subToken, "syntax error: integer literal or label expected:"));
                        haveImm = true;
                    } else
                        throw new AssemblerException(lineNumber, "syntax error: too operands specified", file);
                }
                program.add(instr);
                programCounter++;
                return;
            } else {
                instr = new AssemblyInstruction(programCounter, lineNumber, file);
                instr.setMnemonic(token.toLowerCase());
                isBranch = instr.getMnemonic().startsWith("b")|| instr.getMnemonic().startsWith("r") || (instr.getMnemonic().startsWith("c") && !instr.getMnemonic().equals("cmp")) ;
                if (tokens.length == 1) {
                    program.add(instr);
                    programCounter++;
                    return;
                }
            }
        }
    }

    private void parsePseudoOp(String[] tokens) throws AssemblerException {
        AssemblyConstant constant = null;
        int type = -1;
        for (String token : tokens) {
            if (token.length() == 0) {
            }
            else if (token.endsWith(":") || token.contains("=")){}
            else if (token.startsWith(".")) {
                if (token.equals(".dw")){
                    constant = new AssemblyConstant(programCounter, lineNumber, file);
                    type = 0;
                } else
                    throw new AssemblerException(lineNumber, "syntax error: unknown pseudoinstruction"+token, file);
            } else if (type == 0) {
                if (token.startsWith("&"))
                    constant.setLabelData(token.substring(1, token.length()));
                else
                    constant.setData(new long[]{parse32BitLiteral(token, "syntax error: integer literal or label expected:")});
                program.add(constant);
                programCounter++;
                return;
            } else
                throw new AssemblerException(lineNumber, "syntax error: orphaned token", file);
        }
    }

    public AssemblyProgram getProgram() {
        return program;
    }
}
