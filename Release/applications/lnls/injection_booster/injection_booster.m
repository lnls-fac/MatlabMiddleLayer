function r_final = injection_booster(ring, twiss, emitx, emity, sigmae, sigmaz, n_part)


sept = findcells(ring, 'FamName','InjSept');

cutoff = 1;

offset_x = -30e-3;
offset_xl = 14.3e-3;

twi.betax = twiss.beta(sept, 1); twi.alphax = twiss.alpha(sept, 1);
twi.betay = twiss.beta(sept, 2); twi.alphay = twiss.alpha(sept, 2);
twi.etax = twiss.Dispersion(sept, 1); twi.etaxl = twiss.Dispersion(sept, 2);
twi.etay = twiss.Dispersion(sept, 3); twi.etayl = twiss.Dispersion(sept, 4);

r_init = lnls_generate_bunch(emitx, emity, sigmae, sigmaz, twi, n_part, cutoff);

% r_init = [0;0;0;0;0;0];

r_init(1) = r_init(1) + offset_x;
r_init(2) = r_init(2) + offset_xl;

ring = circshift(ring,[0,-(sept-1)]);

% first step is to initialize global auxiliary structures
name = 'CONFIG';
initializations();

family_data = sirius_bo_family_data(ring);

% application of errors to the nominal model
machine  = create_apply_errors(ring, family_data);

%application of bpm offset errors
machine = create_apply_bpm_errors(machine, family_data);

% at last, multipole errors are applied
% machine  = create_apply_multipoles(machine, family_data);

% finalizations are done
finalizations();

machine = machine{1,1};

r_final = linepass(machine, r_init, [1: length(machine)]);

for j=5:length(machine)
    if abs(r_final(1,j)) > machine{j}.VChamber(1) || abs(r_final(2,j)) > machine{j}.VChamber(2)
        fprintf('Bateu na camara no elemento %01i !\n', j);
        break
    end
end

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
        config.fams.b.sigma_e      = 0.15 * percent * 1;
        config.fams.b.sigma_e_kdip = 2.4 * percent * 1;  % quadrupole errors due to pole variations

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

%% BPM and Correctors Errors
    function machine = create_apply_bpm_errors(machine, family_data)
        % BPM  anc Corr errors are treated differently from magnet errors:
        % constants
        um = 1e-6; mrad = 0.001; percent = 0.01;

        control.bpm.idx = family_data.BPM.ATIndex;
        control.bpm.sigma_offsetx   = 300 * um * 1;
        control.bpm.sigma_offsety   = 300 * um * 1;

        cutoff_errors = 1;
        machine = lnls_latt_err_generate_apply_bpmcorr_errors(name, machine, control, cutoff_errors);
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
        multi.bends.main_vals = [5.5, 4*ones(1,4)]*1e-4;
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
        multi_errors  = lnls_latt_err_generate_multipole_errors(name, ring, multi, length(machine), cutoff_errors);
        machine = lnls_latt_err_apply_multipole_errors(name, machine, multi_errors, multi);

        for i=1:length(machine)
            machine{i} = circshift(machine{i},[0,idx]);
        end

        name_saved_machines = [name_saved_machines '_multi'];
        save([name_saved_machines '.mat'], 'machine');
    end


%% finalizations
    function finalizations()

        % closes diary and all open plots
        diary 'off'; fclose('all');

    end
end