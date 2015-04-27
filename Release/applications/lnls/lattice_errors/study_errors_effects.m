function machine = study_errors_effects()

% constants
um       = 1e-6;
mrad     = 0.001;
percent  = 0.01;

name = 'CONFIG';
name_saved_machines = name;
diary([name, '_summary.txt']);
RandStream.setGlobalStream(RandStream('mt19937ar','seed', 131071));

the_ring = create_nominal_model();
family_data = sirius_si_family_data(the_ring);

machine = create_apply_errors(the_ring);

machine = correct_orbit(machine, family_data);

machine = correct_coupling(machine, family_data);

machine = correct_tune(machine);

machine = create_apply_multipoles(machine);

% finalizacoes
diary 'off'
fclose('all');
cd('../');








%% Definition of the nominal AT model
    function the_ring = create_nominal_model()
%         fun_name = ls('../firstRun_*');
%         [path,fun_name] = fileparts(fun_name);
%         cur_dir = pwd;
%         cd(path);
        the_ring  = sirius_si_lattice('C','05');
%         cd(cur_dir);
        the_ring = setcavity('off', the_ring);
        the_ring = setradiation('off', the_ring);
        save([name,'the_ring.mat'], 'the_ring');
    end
%% Magnet Errors:
    function machine = create_apply_errors(the_ring)
        %Quads
        config.fams.quads.labels = {'qfa','qdb2','qfb','qdb1','qda',...
            'qf1','qf2','qf3','qf4'};
        config.fams.quads.nrsegs = ones(1,9);
        config.fams.quads.sigma_x      = 40 * um * 1;
        config.fams.quads.sigma_y      = 40 * um * 1;
        config.fams.quads.sigma_roll   = 0.20 * mrad * 1;
        config.fams.quads.sigma_e      = 0.05 * percent * 1;
        % config.fams.quads.sigma_yaw    = 0.10 * mrad * 0;
        % config.fams.quads.sigma_pitch  = 0.10 * mrad * 0;
        
        %Sexts
        config.fams.sexts.labels = {'sda','sfa','sd1','sf1','sd2','sd3',...
            'sf2','sf3','sd4','sd5','sf4','sd6','sdb','sfb'};
        config.fams.sexts.nrsegs = ones(1, 14);
        config.fams.sexts.sigma_x      = 40 * um * 1;
        config.fams.sexts.sigma_y      = 40 * um * 1;
        config.fams.sexts.sigma_roll   = 0.20 * mrad * 1;
        config.fams.sexts.sigma_e      = 0.05 * percent * 1;
        % config.fams.sexts.sigma_yaw    = 0.10 * mrad * 0;
        % config.fams.sexts.sigma_pitch  = 0.10 * mrad * 0;
        
        %Dips
        config.fams.bends.labels = {'b1','b2','b3'};
        config.fams.bends.nrsegs = [2 2 2];
        config.fams.bends.sigma_x      = 40 * um * 1;
        config.fams.bends.sigma_y      = 40 * um * 1;
        config.fams.bends.sigma_roll   = 0.20 * mrad * 1;
        config.fams.bends.sigma_e      = 0.05 * percent * 1;
        config.fams.bends.sigma_e_kdip = 0.10 * percent * 1;
        % config.fams.bends.sigma_pitch  = 0.05 * mrad * 0;
        % config.fams.bends.sigma_yaw    = 0.05 * mrad * 0;
        
        %BC
        config.fams.cbend.labels = {'bc'};
        config.fams.cbend.nrsegs = 2;
        config.fams.cbend.sigma_y      = 40 * um * 1;
        config.fams.cbend.sigma_x      = 40 * um * 1;
        config.fams.cbend.sigma_roll   = 0.20 * mrad * 1;
        config.fams.cbend.sigma_e      = 0.05 * percent * 1;
        % config.fams.cbend.sigma_yaw    = 0.10 * mrad * 0;
        % config.fams.cbend.sigma_pitch  = 0.10 * mrad * 0;
        
        %Girders
        config.girder.girder_error_flag = false;
        config.girder.correlated_errors = false;
        config.girder.sigma_x     = 100 * um * 1;
        config.girder.sigma_y     = 100 * um * 1;
        config.girder.sigma_roll  =  0.20 * mrad * 1;
        % config.girder.sigma_yaw   =  20 * mrad * 0;
        % config.girder.sigma_pitch =  20 * mrad * 0;
        
        % gera vetores com erros
        nr_machines = 2;
        cutoff_errors = 1;
        errors  = lnls_latt_err_generate_errors(name, the_ring, config, nr_machines, cutoff_errors);
        
        fraction = 1;
        machine = lnls_latt_err_apply_errors(name, the_ring, errors, fraction);
    end

%% Cod Correction
    function machine = correct_orbit(machine, family_data)
        % parameters for slow correction algorithms
        
        orbit.bpm_idx = sort(family_data.bpm.ATIndex);
        orbit.hcm_idx = sort(family_data.chs.ATIndex);
        orbit.vcm_idx = sort(family_data.cvs.ATIndex);
        
        orbit.sext_ramp         = [0 1];
        orbit.svs               = 'all';
        orbit.max_nr_iter       = 50;
        orbit.tolerance         = 1e-5;
        orbit.correct2bba_orbit = false;
        orbit.simul_bpm_err     = false;
        
        nper = 10;
        orbit.respm = calc_respm_cod(the_ring, orbit.bpm_idx, orbit.hcm_idx, orbit.vcm_idx, nper, true);
        orbit.respm = orbit.respm.respm;
        machine = lnls_latt_err_correct_cod(name, machine, orbit);
        
        name_saved_machines = [name_saved_machines,'_machines_cod_corrected'];
        save([name_saved_machines '.mat'], 'machine');
    end

%% Coupling Correction
    function machine = correct_coupling(machine, family_data)
        
        coup.scm_idx = sort(family_data.qs.ATIndex);
        coup.bpm_idx = sort(family_data.bpm.ATIndex);
        coup.hcm_idx = sort(family_data.chs.ATIndex);
        coup.vcm_idx = sort(family_data.cvs.ATIndex);
        coup.svs           = 'all';
        coup.max_nr_iter   = 50;
        coup.tolerance     = 1e-5;
        coup.simul_bpm_corr_err = false;
        
        % calcs coupling symmetrization matrix
        nper = 10;
%         fname = [name '_info_coup.mat'];
%         if ~exist(fname, 'file')
            [respm, info] = calc_respm_coupling(the_ring, coup, nper);
            coup.respm = respm;
%             save(fname, 'info');
%         else
%             data = load(fname);
%             [respm, ~] = calc_respm_coupling(the_ring, coup, nper, data.info);
%             coup.respm = respm;
%         end
        machine = lnls_latt_err_correct_coupling(name, machine, coup);
        
        name_saved_machines = [name_saved_machines '_coup'];
        save([name_saved_machines '.mat'], 'machine');
    end

%% Tune Correction
    function machine = correct_tune(machine)
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
    function machine = create_apply_multipoles(machine)
        % QUADRUPOLES
        % quadM multipoles from model3 fieldmap '2015-02-05 Quadrupolo_Anel_QM_Modelo 3_-12_12mm_-500_500mm_156.92A.txt'
        multi.quadsM.labels = {'qfa','qfb','qdb2','qf1','qf2','qf3','qf4'};
        multi.quadsM.nrsegs = ones(1,7);
        multi.quadsM.main_multipole = 2;% positive for normal negative for skew
        multi.quadsM.r0 = 11.7e-3;
        multi.quadsM.order       = [ 3   4   5   6   7   8   9   10]; % 1 for dipole
        multi.quadsM.main_vals = 1*ones(1,8)*4e-5;
        multi.quadsM.skew_vals = 1*ones(1,8)*1e-5;
        
        % quadC multipoles from model2 fielmap '2015-01-27 Quadrupolo_Anel_QC_Modelo 2_-12_12mm_-500_500mm.txt'
        multi.quadsC.labels = {'qdb1','qda'};
        multi.quadsC.nrsegs = ones(1,2);
        multi.quadsC.main_multipole = 2;% positive for normal negative for skew
        multi.quadsC.r0 = 11.7e-3;
        multi.quadsC.order       = [ 3   4   5   6   7   8   9   10]; % 1 for dipole
        multi.quadsC.main_vals = 1*ones(1,8)*4e-5;
        multi.quadsC.skew_vals = 1*ones(1,8)*1e-5;
        
        
        % SEXTUPOLES
        % multipoles from model1 fieldmap 'Sextupolo_Anel_S_Modelo 1_-12_12mm_-500_500mm.txt'
        multi.sexts.labels = {'sda','sfa','sd1','sf1','sd2','sd3','sf2','sf3','sd4','sd5','sf4','sd6','sdb','sfb'};
        multi.sexts.nrsegs = ones(1, 14);
        multi.sexts.main_multipole = 3;% positive for normal negative for skew
        multi.sexts.r0 = 11.7e-3;
        multi.sexts.order       = [4   5   6   7   8   9   10  11]; % 1 for dipole
        multi.sexts.main_vals = 1*ones(1,8)*4e-5;
        multi.sexts.skew_vals = 1*ones(1,8)*1e-5;
        
        % DIPOLES
        %The default systematic multipoles for the dipoles were changed.
        %Now we are using the values of a standard pole dipole which Ricardo
        %optimized (2015/02/02) as base for comparison with the other alternative with
        %incrusted coils in the poles for independent control of que gradient.
        multi.bends.labels = {'b1','b2','b3', 'bc'};
        multi.bends.nrsegs = [2 3 2 2];
        multi.bends.main_multipole = 1;% positive for normal negative for skew
        multi.bends.r0 = 11.7e-3;
        multi.bends.order       = [ 3   4   5   6   7   8   9 ]; % 1 for dipole
        multi.bends.main_vals = 1*ones(1,7)*4e-5;
        multi.bends.skew_vals = 1*ones(1,7)*1e-5;
        
        cutoff_errors = 2;
        multi_errors  = lnls_latt_err_generate_multipole_errors(name, the_ring, multi, length(machine), cutoff_errors);
        machine = lnls_latt_err_apply_multipole_errors(name, machine, multi_errors, multi);
        
        name_saved_machines = [name_saved_machines '_multi'];
        save([name_saved_machines '.mat'], 'machine');
    end
end
