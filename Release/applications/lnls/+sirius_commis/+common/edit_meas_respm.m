function respm_out = edit_meas_respm(ring, respm_in, no_coupling)
    fam = sirius_bo_family_data(ring);
    bpm = fam.BPM.ATIndex;
    n_bpm = length(bpm);
    ch = fam.CH.ATIndex;
    n_ch = length(ch);
    cv = fam.CV.ATIndex;
    respm_out = respm_in;
    
    for i = 1:length(ch)
        ind_bpms_ch = bpm < ch(i);
        first = find(ind_bpms_ch);
        if ~isempty(first)
            respm_out(1:first(end), i) = 0;
            ind1 = n_bpm + 1;
            ind2 = n_bpm + first(end);
            respm_out(ind1:ind2, i) = 0;
        end
    end
    
    for j = 1:length(cv)
        ind_bpms_cv = bpm < cv(i);
        first = find(ind_bpms_cv);
        if ~isempty(first)
            respm_out(1:first(end), j + n_ch) = 0;
            ind1 = n_bpm + 1;
            ind2 = n_bpm + first(end);
            respm_out(ind1:ind2, j + n_ch) = 0;
        end
    end
    
    respm_out(:, end) = 0;
    
    if no_coupling
        respm_out(1:length(bpm), length(ch)+1:end) = 0;
        respm_out(length(bpm)+1:end, 1:length(ch)) = 0;
    end
end