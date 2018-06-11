function r = sirius_coupling_feedback(lattice_version, run_nominal, run_response, run_feedback)
    fol = fullfile(...
        lnls_get_root_folder(), 'MatlabMiddleLayer', 'Release', ...
        'lnls', 'fac_scripts', 'sirius', 'coupling_feeback');
    pathCell = regexp(path, pathsep, 'split');
    onPath = any(strcmp(fol, pathCell));
    if ~onPath
        addpath(fol);
    end
    
    if ~exist('run_nominal', 'var')
        run_nominal = false;
    end
    if ~exist('run_response', 'var')
        run_response = false;
    end
    if ~exist('run_feedback', 'var')
        run_feedback = false;
    end
    if ~exist('lattice_version', 'var')
        lattice_version = 'SI.V18.01';
    end
    
    fname = [lattice_version, '_nominal_info.mat'];
    if exist(fname,'file') && ~run_nominal
        data = load(fname);
        nominal_data = data.nominal_data;
        ring0 = data.ring0;
        indices = data.indices;
    else
        ring0 = load_model(lattice_version);
        fprintf('   . finding lattice indices\n');
        data = sirius_si_family_data(ring0);
        indices = find_indices(ring0, data);
        sim_anneal.target_coupling = 3.0/100;
        sim_anneal.qs_delta = 0.001/2;
        sim_anneal.nr_iterations = 500;
        sim_anneal.scale_tilt = 0.5 * (pi / 180); 
        sim_anneal.scale_sigmay = 0.5 * 1e-6;
        sim_anneal.scale_coup = 0.5 / 100;
        nominal_data = controlled_coupling(ring0, sim_anneal, indices);
        save(fname, 'nominal_data', 'sim_anneal', 'ring0', 'indices', 'lattice_version');
    end

    fname = [lattice_version, '_fb_response.mat'];
    if exist(fname, 'file') && ~run_response
        response = load(fname, 'response');
        response = response.response;
    else
        b2_selection = logical(repmat([1,0,0,0, 1,0,0,0],1,5)); % for 10 B2 beamlines
        ring = add_qs_in_families(ring0, nominal_data.qs_fams, nominal_data.skew_stren);
        response = calc_feedback_respm(ring, indices, b2_selection);
        save(fname, 'response', 'b2_selection');
    end
        
    fname = [lattice_version, '_fb_results.mat'];
    if exist(fname, 'file') && ~run_feedback
        data = load(fname);
        rand_mach = data.rand_mach;
        ids_data = data.ids_data;
        fb_data = data.fb_data;
    else
        fname_rand_mach = [...
            '/home/fac_files/data/sirius/beam_dynamics/',...
            lower(lattice_version),...
            '/official/s05.01/multi.cod.tune.coup/cod_matlab/',...
            'CONFIG_machines_cod_corrected_tune_coup_multi.mat'];
        rand_mach = load_random_machines(fname_rand_mach);
        pol_scale = [29,29,5,29,29,29,5,29,29,29,5,29,29,29,5,29,29,29]/1000;
        ids_data = get_ids_data(ring0, indices, 0.01, length(rand_mach), pol_scale);
%         ids_data = get_ids_data(ring0, indices, 0.01, length(rand_mach));
    end
    
%     show_summary_machines(rand_mach, indices, 'raw random machines');
    rand_mach_coup = apply_nominal_skew_to_random_machines(rand_mach, nominal_data);
    titulo = 'random machines with controlled coupling';
%     show_summary_machines(rand_mach_coup, indices, titulo);
    rand_mach_coup_ids = insert_ids(rand_mach_coup, ids_data);
%     show_summary_machines(rand_mach_coup_ids, indices, 'random machines with IDs on');
    
    if ~exist('fb_data', 'var')
        corr_params.max_nr_iter = 200;
        corr_params.min_res = 0.3;
        fb_data = perform_feedback(...
                rand_mach_coup_ids, rand_mach_coup, indices, response, corr_params);
        save(fname, 'fb_data', 'ids_data', 'fname_rand_mach', 'rand_mach', 'corr_params');
    end
    rand_mach_coup_ids_fb = add_qs_to_random_machines(...
                    rand_mach_coup_ids, fb_data.idx, fb_data.quad_strens);
%     show_summary_machines(rand_mach_coup_ids_fb, indices, 'random machines after FB');
    r.nominal_data = nominal_data;
    r.indices = indices;
    r.ring0 = ring0;
    r.ring = add_qs_in_families(ring0, nominal_data.qs_fams, nominal_data.skew_stren);
    r.ids_data = ids_data;
    r.fb_data = fb_data;
    r.response = response;
    r.rand_mach = rand_mach;
    r.rand_mach_coup = rand_mach_coup;
    r.rand_mach_coup_ids = rand_mach_coup_ids;
    r.rand_mach_coup_ids_fb = rand_mach_coup_ids_fb;
    
    
function ring = load_model(lattice_version)
    % add paths
    fprintf('   . loading lattice model\n');
    lnls_setpath_mml_at;
    siriuspath = fullfile(...
                    lnls_get_root_folder(),'MatlabMiddleLayer',...
                    'Release','machine','SIRIUS',lattice_version);
    addpath(siriuspath);

    % creates model
    ring = sirius_si_lattice();
    [ring, ~, ~, ~, ~, ~, ~] = setradiation('On', ring);
    ring = setcavity('On', ring);


function indices = find_indices(ring, data)

    indices.pos = findspos(ring, 1:length(ring)+1);    
    % --- builds vectors with various indices ---
    indices.mia = findcells(ring, 'FamName', 'mia');
    indices.mib = findcells(ring, 'FamName', 'mib');
    indices.mip = findcells(ring, 'FamName', 'mip');
    indices.mic = findcells(ring, 'FamName', 'mc');
    indices.bl_ids = sort([indices.mia, indices.mib, indices.mip]);
    indices.bl_all = sort([indices.bl_ids, indices.mic]);
    b2_seg_idx = 8;  % corresponds to 13 mrad (correct value : ~16 mrad)
    indices.b2 = data.b2.ATIndex(:, b2_seg_idx);
    indices.qs = data.qs.ATIndex;


function rand_mach = load_random_machines(fname_random_machines)
    fprintf(['-- loading random machines [', datestr(now), ']\n']);
    % loads random machines
    data = load(fname_random_machines);
    rand_mach = data.machine;
    % calcs coupling parameters
    for i=1:length(rand_mach)
        [rand_mach{i}, ~, ~, ~, ~, ~, ~] = setradiation('On', rand_mach{i});
        rand_mach{i} = setcavity('On', rand_mach{i});
    end

    
function data = get_ids_data(ring, indices, emit_ratio, n_rand_mach, pol_scale)

    fprintf(['-- Find Strength of IDs [', datestr(now), ']\n']);

    idx = indices.bl_ids;
    idx([1 3]) = []; % section 01A and 03P have no IDs
    idx = reshape(sort([idx-1, idx+1]), 2, [])';
       
    if ~exist('pol_scale', 'var')
        pol_scale = 3e-3*ones(1, size(idx, 1));

        fprintf('   . desired coupling (ey/ex): ');
        fprintf('%f \n', emit_ratio);
        fprintf('   . listing id configurations\n');
        fprintf('   %2s @ %5s | ', 'id', 'mkr');
        fprintf('%6s | ', 'family');
        fprintf('%10s | ', 'Length [m]');
        fprintf('%10s | ', 'Pass Meth.');
        fprintf('%9s | ', 'QS [1/km]');
        fprintf('%12s |', 'ex [pm.rad]');
        fprintf('%12s |', 'ey [pm.rad]');
        fprintf('%12s |', 'e0 [pm.rad]');
        fprintf('%6s\n', 'ey/ex');
        last = 0;
        for i=1:size(idx, 1)
            fam = unique(getcellstruct(ring, 'FamName', idx(i,:)));
            len = getcellstruct(ring, 'Length', idx(i,:));
            pas = unique(getcellstruct(ring, 'PassMethod', idx(i,:)));
            while pol_scale(i) ~= last
                la1 = insert_one_id(ring, idx(i,:), pol_scale(i));
                coup = calc_coupling(la1);
                rat = emit_ratio / coup.emit_ratio;
                last = pol_scale(i);
                pol_scale(i) = round(sqrt(rat) * pol_scale(i), 3);
            end
            fprintf('   %02i @ %5s | ', i, ring{idx(i,1)+1}.FamName);
            fprintf('%6s | ', fam{1});
            fprintf('%10.3f | ', sum(len));
            fprintf('%10s | ', pas{1});
            fprintf('%9.2f | ', pol_scale(i)*1000);
            fprintf('%12.3f |', 1e12*coup.emit_x);
            fprintf('%12.3f |', 1e12*coup.emit_y);
            fprintf('%12.3f |', 1e12*(coup.emit_x + coup.emit_y));
            fprintf('%6.3f\n', 100*coup.emit_ratio);
        end
    end
    data.idx = idx;
    data.pol_scale = pol_scale;
    pol_scale = repmat(pol_scale, n_rand_mach, 1);
    data.polynom_a = 2*(rand(size(pol_scale)) - 0.5) .* pol_scale;
 