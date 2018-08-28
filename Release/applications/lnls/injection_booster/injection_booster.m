function r_final = injection_booster(ring, alpha, beta, eta, emitx, emity, sigmae, sigmaz, n_part)


% first step is to initialize global auxiliary structures
name = 'CONFIG';
initializations();

family_data = sirius_bo_family_data(ring);

% application of errors to the nominal model
machine  = create_apply_errors(ring, family_data);

% orbit correction is performed
% machine  = correct_orbit(machine, family_data);

% tune correction
% machine  = correct_tune(machine);

% at last, multipole errors are applied
machine  = create_apply_multipoles(machine, family_data);

% finalizations are done
finalizations();

machine = machine{1,1};

% machine = create_nominal_model(3);

sept = findcells(machine, 'FamName','InjSept');
injkckr = findcells(machine, 'FamName','InjKckr');
machine = lnls_set_kickangle(machine, -19.34e-3, injkckr, 'x');

machine = circshift(machine,[0,-(sept-1)]);

sept_n = findcells(machine, 'FamName','InjSept');
injkckr_n = findcells(machine, 'FamName','InjKckr');

len = getcellstruct(machine, 'Length', sept_n:1:injkckr_n-1);

d_sept_kckr = cumsum(len);

xcv = vchamber_injection(d_sept_kckr, d_sept_kckr(end));

    function xcv = vchamber_injection(s, d_sep_kckr)
        x_sep = -41.86e-3;
        x_kckr = -30.14e-3;
        xcv = (x_kckr - x_sep) / d_sep_kckr * s + x_sep;
    end

machine = setcellstruct(machine,'VChamber',sept_n:1:injkckr_n-1, abs(xcv), 1,1);
% machine = setcellstruct(machine,'VChamber',sept_n:1:injkckr_n-1, abs(xcv), 1,2);

cutoff = 1;

offset_x = -30e-3;
offset_xl = 14.3e-3;

twi.betax = beta(sept, 1); twi.alphax = alpha(sept, 1);
twi.betay = beta(sept, 2); twi.alphay = alpha(sept, 2);
twi.etax = eta(sept, 1);   twi.etaxl = eta(sept, 2);
twi.etay = eta(sept, 3);   twi.etayl = eta(sept, 4);

r_init = lnls_generate_bunch(emitx, emity, sigmae, sigmaz, twi, n_part, cutoff);

r_init(1,:) = r_init(1,:) + offset_x;
r_init(2,:) = r_init(2,:) + offset_xl;

r_final = linepass(machine, r_init, 1:length(machine));

r_final = reshape(r_final, 6, n_part, length(machine));

VChamb = cell2mat(getcellstruct(machine, 'VChamber', 1:1:length(machine)));

% problema de transposição no caso n_part = 1

x_final = squeeze(r_final(1, :, :));
y_final = squeeze(r_final(3, :, :));

ind = bsxfun(@gt, abs(x_final'), VChamb(:, 1)) | bsxfun(@gt, abs(y_final'), VChamb(:, 2));
ft = zeros(n_part,1);

if any(ind)
   for l=1:n_part
       ft(l) = find(ind(:,l), 1, 'first');
       r_final(:, l, ft(l):end) = NaN;
   end
end

% r_final(:,:, ind) = NaN;
%% Initializations
    function initializations()

        fprintf('\n<initializations> [%s]\n\n', datestr(now));

        % seed for random number generator
        seed = 131071;
        fprintf('-  initializing random number generator with seed = %i ...\n', seed);
        RandStream.setGlobalStream(RandStream('mt19937ar','seed', seed));

        % sends copy of all output to a diary in a file
        fprintf('-  creating diary file ...\n');
        diary([name, '_summary.txt']);

    end
%% Magnet Errors:
    function machine = create_apply_errors(the_ring, family_data)

        fprintf('\n<error generation and random machines creation> [%s]\n\n', datestr(now));

        % constants
        um = 1e-6; mrad = 0.001; percent = 0.01;

        % <quadrupoles> alignment, rotation and excitation errors
        config.fams.quads.labels     = {'QF','QD','QS'};
        config.fams.quads.sigma_x    = 160 * um * 1;
        config.fams.quads.sigma_y    = 160 * um * 1;
        config.fams.quads.sigma_roll = 0.800 * mrad * 1;
        config.fams.quads.sigma_e    = 0.3 * percent * 1;

        % <sextupoles> alignment, rotation and excitation errors
        config.fams.sexts.labels     = {'SD','SF'};
        config.fams.sexts.sigma_x    = 160 * um * 1;
        config.fams.sexts.sigma_y    = 160 * um * 1;
        config.fams.sexts.sigma_roll = 0.800 * mrad * 1;
        config.fams.sexts.sigma_e    = 0.3 * percent * 1;

        % <dipoles with more than one piece> alignment, rotation and excitation errors
        config.fams.b.labels       = {'B'};
        config.fams.b.sigma_x      = 160 * um * 1;
        config.fams.b.sigma_y      = 160 * um * 1;
        config.fams.b.sigma_roll   = 0.800 * mrad * 1;
%         config.fams.b.sigma_e      = 0.15 * percent * 1;
        config.fams.b.sigma_e      = 0.05 * percent * 1; % based on estimated error of measured fmap analysis from measurement bench fluctuation - XRR - 2018-08-23
%         config.fams.b.sigma_e_kdip = 2.4 * percent * 1;  % quadrupole errors due to pole variations
        config.fams.b.sigma_e_kdip = 0.3 * percent * 1;  % based on measured fmap analysis - XRR - 2018-08-23 - see /home/fac_files/lnls-ima/bo-dipoles/model-09/analysis/hallprobe/production/magnet-dispersion.ipynb


        % sets number of segmentations for each family
        families = fieldnames(config.fams);
        for i=1:length(families)
            family = families{i};
            labels = config.fams.(family).labels;
            config.fams.(family).nrsegs = zeros(1,length(labels));
            for j=1:length(labels)
                config.fams.(family).nrsegs(j) = family_data.(labels{j}).nr_segs;
            end
        end

        % generates error vectors
        nr_machines   = 1;
        rndtype       = 'gaussian';
        cutoff_errors = 1;
        fprintf('-  generating errors ...\n');
        % I have to do this for the booster, because the lattice begins at
        % the middle of the quadrupole:
        idx = findcells(the_ring,'FamName','BPM'); idx = idx(end)-1;
        the_ring = circshift(the_ring,[0,-idx]);

        errors        = lnls_latt_err_generate_errors(name, the_ring, config, nr_machines, cutoff_errors, rndtype);

        % applies errors to machines
        fractional_delta = 1;
        fprintf('-  creating %i random machines and applying errors ...\n', nr_machines);
        fprintf('-  finding closed-orbit distortions with sextupoles off ...\n\n');
        machine = lnls_latt_err_apply_errors(name, the_ring, errors, fractional_delta);
        for i=1:length(machine)
            machine{i} = circshift(machine{i},[0,idx]);
        end
    end

%% Multipoles insertion
    function machine = create_apply_multipoles(machine, family_data)

        fprintf('\n<application of multipole errors> [%s]\n\n', datestr(now));

        % QUADRUPOLES
        multi.quads.labels = {'QD','QF','QS'};
        multi.quads.main_multipole = 2;% positive for normal negative for skew
        multi.quads.r0 = 17.5e-3;
        multi.quads.order     = [3, 4, 5, 6, 7, 8, 9]; % 1 for dipole
        multi.quads.main_vals = [7.0, 4*ones(1,6)]*1e-4;
        multi.quads.skew_vals = [10, 5, ones(1,5)]*1e-4;

        % SEXTUPOLES
        multi.sexts.labels = {'SD','SF'};
        multi.sexts.main_multipole = 3;% positive for normal negative for skew
        multi.sexts.r0 = 17.5e-3;
        multi.sexts.order     = [4, 5, 6, 7, 8, 9, 10]; % 1 for dipole
        multi.sexts.main_vals = ones(1,7)*4e-4;
        multi.sexts.skew_vals = ones(1,7)*1e-4;

        % DIPOLES
        multi.bends.labels = {'B'};
        multi.bends.main_multipole = 1;% positive for normal negative for skew
        multi.bends.r0 = 17.5e-3;
        multi.bends.order = [3, 4, 5, 6, 7]; % 1 for dipole
        % based on measured fmap analysis - XRR - 2018-08-23 - see /home/fac_files/lnls-ima/bo-dipoles/model-09/analysis/hallprobe/production/magnet-dispersion.ipynb
        % (dSL)r_0^2 / (DL) ~ 2.3e-3, dSL ~ 0.945 T/m, DL ~ 0.126 T.m
%         multi.bends.main_vals = [5.5, 4*ones(1,4)]*1e-4;
        multi.bends.main_vals = [23, 4*ones(1,4)]*1e-4; 
        
        multi.bends.skew_vals = ones(1,5)*1e-4;

        % sets number of segmentations for each family
        families = fieldnames(multi);
        for i=1:length(families)
            family = families{i};
            labels = multi.(family).labels;
            multi.(family).nrsegs = zeros(1,length(labels));
            for j=1:length(labels)
                multi.(family).nrsegs(j) = family_data.(labels{j}).nr_segs;
            end
        end

        % I have to do this for the booster, because the lattice begins at
        % the middle of the quadrupole:
        idx = findcells(ring,'FamName','BPM'); idx = idx(end)-1;
        the_ring = circshift(ring,[0,-idx]);
        for i=1:length(machine)
            machine{i} = circshift(machine{i},[0,-idx]);
        end

        % adds systematic multipole errors to random machines
        for i=1:length(machine)
            machine{i} = sirius_bo_multipole_systematic_errors(machine{i});
        end
        fname = which('sirius_bo_multipole_systematic_errors');
        copyfile(fname, [name '_multipole_systematic_errors.m']);

        cutoff_errors = 2;
        multi_errors  = lnls_latt_err_generate_multipole_errors(name, the_ring, multi, length(machine), cutoff_errors);
        machine = lnls_latt_err_apply_multipole_errors(name, machine, multi_errors, multi);

        for i=1:length(machine)
            machine{i} = circshift(machine{i},[0,idx]);
        end
    end

%% Cod Correction
    function machine = correct_orbit(machine, family_data)

        fprintf('\n<closed-orbit distortions correction> [%s]\n\n', datestr(now));

        % parameters for slow correction algorithms
        orbit.bpm_idx = family_data.BPM.ATIndex;
        orbit.hcm_idx = family_data.CH.ATIndex;
        orbit.vcm_idx = family_data.CV.ATIndex;

        % parameters for SVD correction
        orbit.sext_ramp         = [0 1];
        orbit.svs               = 'all';
        orbit.max_nr_iter       = 50;
        orbit.tolerance         = 1e-5;
        orbit.correct2bba_orbit = false;
        orbit.simul_bpm_err     = true;

        % calcs nominal cod response matrix, if chosen
        use_respm_from_nominal_lattice = true;
        if use_respm_from_nominal_lattice
            fprintf('-  calculating orbit response matrix from nominal machine ...\n');
            lattice_symmetry = 1;
            orbit.respm = calc_respm_cod(ring, orbit.bpm_idx, orbit.hcm_idx, orbit.vcm_idx, lattice_symmetry, true);
            orbit.respm = orbit.respm.respm;
        end

        % loops over random machine, correcting COD...
        machine = lnls_latt_err_correct_cod(name, machine, orbit);
    end

%% Tune Correction
    function machine = correct_tune(machine)

        fprintf('\n<tune correction> [%s]\n\n', datestr(now));

        tune.correction_flag = false;
        tune.families        = {'QF','QD'};
        [~, tune.goal]       = twissring(ring,0,1:length(ring)+1);
        tune.max_iter        = 10;
        tune.tolerance       = 1e-6;
        tune.method          = 'svd';
        tune.variation       = 'add';

        % faz correcao de tune
        machine = lnls_latt_err_correct_tune_machines(tune, machine);
    end



%% finalizations
    function finalizations()

        % closes diary and all open plots
        diary 'off'; fclose('all');

    end
end