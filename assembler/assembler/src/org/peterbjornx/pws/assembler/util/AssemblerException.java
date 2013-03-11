package org.peterbjornx.pws.assembler.util;

/**
 * Part of Peter Bosch's final assignment
 *
 * @author peterbjornx
 */
public class AssemblerException extends Exception {
    private String file;
    private int lineNumber;

    /**
     * Constructs a new exception with {@code null} as its detail message.
     * The cause is not initialized, and may subsequently be initialized by a
     * call to {@link #initCause}.
     */
    public AssemblerException(int lineNumber, String message, String file) {
        super(message);
        this.lineNumber = lineNumber;
        this.file = file;
    }

    public int getLineNumber() {
        return lineNumber;
    }

    public String getFile() {
        return file;
    }
}
