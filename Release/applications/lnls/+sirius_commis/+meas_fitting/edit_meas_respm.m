function respm_out = edit_meas_respm(no_noise, no_coupling, no_rf)

    sirius('BO')
    switch2online
    ring = sirius_bo_lattice();
    ring = shift_ring(ring, 'InjSept');
    fam = sirius_bo_family_data(ring);
    bpm = fam.BPM.ATIndex; n_bpm = length(bpm);
    ch = fam.CH.ATIndex; n_ch = length(ch);
    cv = fam.CV.ATIndex; n_cv = length(cv);
    n_corrs = n_ch + n_cv + 1;

    % dir1 = '/home/sirius/iocs/bo-ap-sofb/data/';
    % dir2 = '/home/facs/repos/MatlabMiddleLayer/Release/applications/lnls/+sirius_commis/+meas_fitting/';
    % file = [dir1, 'respmat_modelo.txt'];
    % file_txt = [dir2, 'respmat.txt'];
    % copyfile(file, file_txt, 'f')
    % fileID = fopen(file_txt, 'r');
    % respm_in = fscanf(fileID, '%f');
    % respm_in = readtable(file_txt);
    % respm_in = table2array(respm_in);
    
    v_prefix = getenv('VACA_PREFIX');
    ioc_prefix = [v_prefix, 'BO-Glob:AP-SOFB:'];
    respm_pv = [ioc_prefix, 'RespMat-RB'];
    ring_size_pv =[ioc_prefix, 'RingSize-RB'];
    respm_in = getpv(respm_pv);
    ring_size = getpv(ring_size_pv);
    respm_in_ringsize = respm_in(1:(ring_size * 2 * n_bpm * n_corrs));
    respm_in = reshape(respm_in_ringsize, n_corrs, ring_size * 2 * n_bpm)';
    respm_out = respm_in;
    
    if no_noise
        for i = 1:length(ch)
            ind_bpms_ch = bpm < ch(i);
            first = find(ind_bpms_ch);
            if ~isempty(first)
                respm_out(1:first(end), i) = 0;
                ind1 = ring_size * n_bpm + 1;
                ind2 = ring_size * n_bpm + first(end);
                respm_out(ind1:ind2, i) = 0;
            end
        end

        for j = 1:length(cv)
            ind_bpms_cv = bpm < cv(j);
            first = find(ind_bpms_cv);
            if ~isempty(first)
                respm_out(1:first(end), j + n_ch) = 0;
                ind1 = ring_size * n_bpm + 1;
                ind2 = ring_size * n_bpm + first(end);
                respm_out(ind1:ind2, j + n_ch) = 0;
            end
        end
    end

    if no_rf
      respm_out(:, end) = 0;
    end

    if no_coupling
        respm_out(1:(ring_size*length(bpm)), n_ch+1:end) = 0;
        respm_out((ring_size*length(bpm)+1):end, 1:n_ch) = 0;
    end
    
    hdf5write('respm_edit.h5', '/Points', respm_out);
    
    % After that do the following:
    % 1) Go to /home/murilo/bo_respm_sofb folder
    % 2) Open ipython terminal
    % 3) import insert_respm_servconf as ins
    % 4) Include config with ins.Config_Insert('bo_orbcorr_respm', 'folder_respm_file', 'respm_name');
end
