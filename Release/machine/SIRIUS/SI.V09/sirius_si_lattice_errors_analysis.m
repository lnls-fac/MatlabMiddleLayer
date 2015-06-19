function machine = sirius_si_lattice_errors_analysis()

fprintf('\n')
fprintf('Lattice Errors Run\n');
fprintf('==================\n');

% first step is to initialize global auxiliary structures
name = 'CONFIG'; name_saved_machines = name;
initializations();

% next a nominal model is chosen for the study 
the_ring = create_nominal_model();
family_data = sirius_si_family_data(the_ring);

% application of errors to the nominal model
machine  = create_apply_errors(the_ring, family_data);

%application of bpm offset errors
machine = create_apply_bpm_errors(machine, family_data);

% orbit correction is performed
machine  = correct_orbit(machine, family_data);

% tune correction
machine  = correct_tune(machine);

% next, coupling correction
machine  = correct_coupling(machine, family_data);

% lattice symmetrization
%machine = correct_optics(machine, family_data);

% at last, multipole errors are applied
machine  = create_apply_multipoles(machine, family_data);

% finalizations are done
finalizations();


%% Initializations
    function initializations()
        
        fprintf('\n<initializations> [%s]\n\n', datestr(now));
        
        % seed for random number generator
        seed = 131071;
        fprintf('-  initializing random number generator with seed = %i ...\n', seed);
        RandStream.setGlobalStream(RandStream('mt19937ar','seed', seed));
        
        % saves this file to working directory so that what has been done
        % is registered
        p = mfilename('fullpath');
        copyfile([p '.m'], 'lattice_errors_analysis.m');
        
        % sends copy of all output to a diary in a file
        fprintf('-  creating diary file ...\n');
        diary([name, '_summary.txt']);
        
    end

%% finalizations
    function finalizations()
        
        % closes diary and all open plots
        diary 'off'; fclose('all');
        
    end

%% Definition of the nominal AT model
    function the_ring = create_nominal_model()
        
        fprintf('\n<nominal model> [%s]\n\n', datestr(now));
        
        % loads nominal ring as the default lattice for a particular
        % lattice version. It is assumed that sirius MML structure has been
        % loaded with 'sirius' command the appropriate lattice version.
        fprintf('-  loading model ...\n');
        fprintf('   file: %s\n', which('sirius_si_lattice'));
        the_ring = sirius_si_lattice();
        
        % sets cavity and radiation off for 4D trackings
        fprintf('-  turning radiation and cavity off ...\n');
        the_ring = setcavity('off', the_ring);
        the_ring = setradiation('off', the_ring);
        
        % saves nominal lattice to file
        save([name,'_the_ring.mat'], 'the_ring');
        
    end

%% Magnet Errors:
    function machine = create_apply_errors(the_ring, family_data)
        
        fprintf('\n<error generation and random machines creation> [%s]\n\n', datestr(now));
        
        % constants
        um = 1e-6; mrad = 0.001; percent = 0.01;

        % <quadrupoles> alignment, rotation and excitation errors
        config.fams.quads.labels     = {'qfa','qdb2','qfb','qdb1','qda','qf1','qf2','qf3','qf4'};
        config.fams.quads.sigma_x    = 40 * um * 1;
        config.fams.quads.sigma_y    = 40 * um * 1;
        config.fams.quads.sigma_roll = 0.30 * mrad * 1;
        config.fams.quads.sigma_e    = 0.05 * percent * 1;
        
        % <sextupoles> alignment, rotation and excitation errors
        config.fams.sexts.labels     = {'sda','sfa','sd1','sf1','sd2','sd3','sf2','sf3','sd4','sd5','sf4','sd6','sdb','sfb'};
        config.fams.sexts.sigma_x    = 40 * um * 1;
        config.fams.sexts.sigma_y    = 40 * um * 1;
        config.fams.sexts.sigma_roll = 0.30 * mrad * 1;
        config.fams.sexts.sigma_e    = 0.05 * percent * 1;
        
        %ERRORS FOR DIPOLES B1 AND B2 ARE DEFINED IN GIRDERS AND IN THE
        %MAGNET BLOCKS
        
        % <dipoles with only one piece> alignment, rotation and excitation errors
        config.fams.b3bc.labels     = {'b3','bc'};
        config.fams.b3bc.sigma_y    = 40 * um * 1;
        config.fams.b3bc.sigma_x    = 40 * um * 1;
        config.fams.b3bc.sigma_roll = 0.30 * mrad * 1;
        config.fams.b3bc.sigma_e    = 0.05 * percent * 1;
        config.fams.b3bc.sigma_e_kdip = 0.10 * percent * 1;  % quadrupole errors due to pole variations
        
        % <girders> alignment and rotation
        config.girder.girder_error_flag = true;
        config.girder.correlated_errors = false;
        config.girder.sigma_x     = 80 * um * 1;
        config.girder.sigma_y     = 80 * um * 1;
        config.girder.sigma_roll  = 0.30 * mrad * 1;
        
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
        
        % <dipole pieces> alignment, rotation and excitation
        % errors for each 
        config.fams.bendblocks.labels       = {'b1','b2'};
        config.fams.bendblocks.nrsegs       = [1,1];
        config.fams.bendblocks.sigma_x      = 40 * um * 1;
        config.fams.bendblocks.sigma_y      = 40 * um * 1;
        config.fams.bendblocks.sigma_roll   = 0.30 * mrad * 1;
        config.fams.bendblocks.sigma_e      = 0.05 * percent * 1;
        config.fams.bendblocks.sigma_e_kdip = 0.10 * percent * 1;  % quadrupole errors due to pole variations

        
        % generates error vectors
        nr_machines   = 20;
        rndtype       = 'gaussian';
        cutoff_errors = 1;
        fprintf('-  generating errors ...\n');
        errors        = lnls_latt_err_generate_errors(name, the_ring, config, nr_machines, cutoff_errors, rndtype);
        
        % applies errors to machines
        fractional_delta = 1;
        fprintf('-  creating %i random machines and applying errors ...\n', nr_machines);
        fprintf('-  finding closed-orbit distortions with sextupoles off ...\n\n');
        machine = lnls_latt_err_apply_errors(name, the_ring, errors, fractional_delta);
        
    end

%% BPM and Correctors Errors
    function machine = create_apply_bpm_errors(machine, family_data)
        % BPM  anc Corr errors are treated differently from magnet errors:
        % constants
        um = 1e-6;
        
        control.bpm.idx = family_data.bpm.ATIndex;
        control.bpm.sigma_offsetx   = 20 * um * 1; % BBA precision
        control.bpm.sigma_offsety   = 20 * um * 1;
        
        cutoff_errors = 1;
        machine = lnls_latt_err_generate_apply_bpmcorr_errors(name, machine, control, cutoff_errors);
    end


%% Cod Correction
    function machine = correct_orbit(machine, family_data)
        
        fprintf('\n<closed-orbit distortions correction> [%s]\n\n', datestr(now));
        
        % parameters for slow correction algorithms
        orbit.bpm_idx = sort(family_data.bpm.ATIndex);
        orbit.hcm_idx = sort(family_data.chs.ATIndex);
        orbit.vcm_idx = sort(family_data.cvs.ATIndex);
        
        % parameters for SVD correction
        orbit.sext_ramp         = [0 1];
        orbit.svs               = 'all';
        orbit.max_nr_iter       = 50;
        orbit.tolerance         = 1e-5;
        orbit.correct2bba_orbit = false;
        orbit.simul_bpm_err     = false;
        
        % calcs nominal cod response matrix, if chosen
        use_respm_from_nominal_lattice = true; 
        if use_respm_from_nominal_lattice
            fprintf('-  calculating orbit response matrix from nominal machine ...\n');
            lattice_symmetry = 10;  
            orbit.respm = calc_respm_cod(the_ring, orbit.bpm_idx, orbit.hcm_idx, orbit.vcm_idx, lattice_symmetry, true); 
            orbit.respm = orbit.respm.respm;
        end 
        
        % loops over random machine, correcting COD...
        machine = lnls_latt_err_correct_cod(name, machine, orbit);
        
        % saves results to file
        name_saved_machines = [name_saved_machines,'_machines_cod_corrected'];
        save([name_saved_machines '.mat'], 'machine');
        
    end


%% Symmetrization of the optics
    function machine = correct_optics(machine, family_data)
        
        fprintf('\n<optics symmetrization> [%s]\n\n', datestr(now));
        
        optics.bpm_idx = sort(family_data.bpm.ATIndex);
        optics.hcm_idx = sort(family_data.chs.ATIndex);
        optics.vcm_idx = sort(family_data.cvs.ATIndex);
        optics.kbs_idx = sort(family_data.qn.ATIndex);
        
        optics.svs                = 156;
        optics.max_nr_iter        = 50;
        optics.tolerance          = 1e-5;
        [~, optics.tune_goal]     = twissring(the_ring,0,1:length(the_ring)+1);
        optics.simul_bpm_corr_err = false;
        
        % calcs optics symmetrization matrix
        fname = [name '_info_optics.mat'];
        lattice_symmetry = 10;
        if ~exist(fname, 'file')
            [respm, info] = calc_respm_optics(the_ring, optics, lattice_symmetry);
            optics.respm = respm;
            save(fname, 'info');
        else
            data = load(fname);
            [respm, ~] = calc_respm_optics(the_ring, optics, lattice_symmetry, data.info);
            optics.respm = respm;
        end
        machine = lnls_latt_err_correct_optics(name, machine, optics, the_ring);
        
        name_saved_machines = [name_saved_machines '_symm'];
        save([name_saved_machines '.mat'], 'machine');
    end

%% Coupling Correction
    function machine = correct_coupling(machine, family_data)
        
        fprintf('\n<coupling correction> [%s]\n\n', datestr(now));
         
        coup.scm_idx = family_data.qs.ATIndex;
        coup.bpm_idx = family_data.bpm.ATIndex;
        coup.hcm_idx = family_data.chs.ATIndex;
        coup.vcm_idx = family_data.cvs.ATIndex;
        coup.svs           = 'all';
        coup.max_nr_iter   = 50;
        coup.tolerance     = 1e-5;
        coup.simul_bpm_corr_err = false;
        
        % calcs coupling symmetrization matrix
        fname = [name '_info_coup.mat'];
        lattice_symmetry = 10;
        if ~exist(fname, 'file')
            [respm, info] = calc_respm_coupling(the_ring, coup, lattice_symmetry);
            coup.respm = respm;
            save(fname, 'info');
        else
            data = load(fname);
            [respm, ~] = calc_respm_coupling(the_ring, coup, lattice_symmetry, data.info);
            coup.respm = respm;
        end
        machine = lnls_latt_err_correct_coupling(name, machine, coup);
        
        name_saved_machines = [name_saved_machines '_coup'];
        save([name_saved_machines '.mat'], 'machine');
    end

%% Tune Correction
    function machine = correct_tune(machine)
        
        fprintf('\n<tune correction> [%s]\n\n', datestr(now));
        
        tune.correction_flag = false;
        tune.families        = {'qfa','qdb2','qfb','qdb1','qda'};
        [~, tune.goal]       = twissring(the_ring,0,1:length(the_ring)+1);
        tune.max_iter        = 10;
        tune.tolerance       = 1e-6;
     
        % faz correcao de tune
        machine = lnls_latt_err_correct_tune_machines(tune, machine);
        
        name_saved_machines = [name_saved_machines '_tune'];
        save([name_saved_machines '.mat'], 'machine');
    end

%% Multipoles insertion
    function machine = create_apply_multipoles(machine, family_data)
        
        fprintf('\n<application of multipole errors> [%s]\n\n', datestr(now));
        
        % QUADRUPOLES
        multi.quadsM.labels = {'qdb1','qda', 'qfa','qfb','qdb2','qf1','qf2','qf3','qf4'};
        multi.quadsM.main_multipole = 2;% positive for normal negative for skew
        multi.quadsM.r0 = 11.7e-3;
        multi.quadsM.order     = [ 3   4   5   6]; % 1 for dipole
        multi.quadsM.main_vals = ones(1,4)*1.5e-4;
        multi.quadsM.skew_vals = ones(1,4)*0.5e-4;
        
        % SEXTUPOLES
        multi.sexts.labels = {'sda','sfa','sd1','sf1','sd2','sd3','sf2','sf3','sd4','sd5','sf4','sd6','sdb','sfb'};
        multi.sexts.main_multipole = 3;% positive for normal negative for skew
        multi.sexts.r0 = 11.7e-3;
        multi.sexts.order     = [4   5   6   7 ]; % 1 for dipole
        multi.sexts.main_vals = ones(1,4)*1.5e-4;
        multi.sexts.skew_vals = ones(1,4)*0.5e-4;
        
        % DIPOLES
        multi.bends.labels = {'b1','b2','b3', 'bc'};
        multi.bends.main_multipole = 1;% positive for normal negative for skew
        multi.bends.r0 = 11.7e-3;
        multi.bends.order = [ 3   4   5   6]; % 1 for dipole
        multi.bends.main_vals = ones(1,4)*1.5e-4;
        multi.bends.skew_vals = ones(1,4)*0.5e-4;
        
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
        
        % adds systematic multipole errors to random machines
        for i=1:length(machine)
            machine{i} = sirius_si_multipole_systematic_errors(machine{i});
        end
        fname = which('sirius_si_multipole_systematic_errors');
        copyfile(fname, [name '_multipole_systematic_errors.m']);
        
        cutoff_errors = 2;
        multi_errors  = lnls_latt_err_generate_multipole_errors(name, the_ring, multi, length(machine), cutoff_errors);
        machine = lnls_latt_err_apply_multipole_errors(name, machine, multi_errors, multi);
        
        name_saved_machines = [name_saved_machines '_multi'];
        save([name_saved_machines '.mat'], 'machine');
    end
end
