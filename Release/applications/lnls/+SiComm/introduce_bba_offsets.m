function ring_out = introduce_bba_offsets(ring_in, bba_data, mach_ind)
    fam = sirius_si_family_data(ring_in);
    offset = getcellstruct(ring_in, 'Offsets', fam.BPM.ATIndex);
    offset = cell2mat(offset);
    
    off_bba = bba_data.off_bba1f;
    off_bba = off_bba{mach_ind};
    
    new_offset = offset + off_bba;
    new_offset_cell = mat2cell(new_offset, ones(1,length(new_offset)), 2);
    ring_out = setcellstruct(ring_in, 'Offsets', fam.BPM.ATIndex, new_offset_cell);
    
    % new_offset2 = getcellstruct(ring_out, 'Offsets', fam.BPM.ATIndex);
    % new_offset2 = cell2mat(new_offset2);
    
end