package org.peterbjornx.pws.assembler.parser;

import java.util.HashMap;
import java.util.LinkedList;
import java.util.Set;

/**
 * Part of Peter Bosch's final assignment
 *
 * @author peterbjornx
 */
public class AssemblyProgram {
    private LinkedList<AssemblyEntity> listing;
    private HashMap<String, Long> labels;

    public AssemblyProgram() {
        listing = new LinkedList<AssemblyEntity>();
        labels = new HashMap<String, Long>();
    }

    public Long getLabelAddress(String key) {
        return labels.get(key);
    }

    public Long addLabel(String key, Long value) {
        return labels.put(key, value);
    }

    public LinkedList<AssemblyEntity> getListing() {
        return listing;
    }

    public void add(AssemblyEntity assemblyEntity) {
        listing.addLast(assemblyEntity);
    }

    public int size() {
        return listing.size();
    }

    public HashMap<String, Long> getLabels() {
        return labels;
    }



}
