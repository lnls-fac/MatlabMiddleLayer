function [machine, param, s] = bo_set_machine(bo_ring)

    initializations();

    %=====================================================================
    %=====================================================================

    % Setting parameters of injection 

    sept = findcells(bo_ring, 'FamName', 'InjSept');
    bo_ring = circshift(bo_ring, [0, - (sept - 1)]);
    bo_twiss = calctwiss(bo_ring);

    param.betax0 = bo_twiss.betax(1);
    param.betay0 = bo_twiss.betay(1);
    param.alphax0 = bo_twiss.alphax(1);
    param.alphay0 = bo_twiss.alphay(1);
    param.etax0 = bo_twiss.etax(1);
    param.etay0 = bo_twiss.etay(1);
    param.etaxl0 = bo_twiss.etaxl(1);
    param.etayl0 = bo_twiss.etayl(1);

    param.offset_x0 = -30e-3;
    param.offset_x = -30e-3;
    param.offset_xl0 = 14.3e-3;
    param.offset_xl = 14.3e-3;
    param.kckr0 = -19.34e-3;
    param.kckr = -19.34e-3;
    
    p = 2;
    x_error = lnls_generate_random_numbers(1, 1, 'norm') * p * 3e-3;
    param.offset_x_erro = param.offset_x0 + x_error;
    
    xl_error = lnls_generate_random_numbers(1, 1, 'norm') * p * 2e-3;
    param.offset_xl_erro = param.offset_xl0 + xl_error;
    param.xl_error_pulse = 0.27e-3;
    
    kckr_error = lnls_generate_random_numbers(1, 1, 'norm') * p * 2e-3;
    param.kckr_erro = param.kckr0 + kckr_error;
    param.kckr_error_pulse = 0.074e-3;
    
    param.emitx = 170e-9;
    param.emity = param.emitx;
    param.sigmae = 0.5e-2;
    param.sigmaz = 0.5e-3;

    param.cutoff = 3;
    param.sigma_bpm = 2e-3;
    param.sigma_scrn = 0.5e-3;
    % res_scrn = param.sigma_scrn;
    
    % sigma_scrn_x1 = lnls_generate_random_numbers(1, 1, 'norm') * res_scrn;
    % sigma_scrn_y1 = lnls_generate_random_numbers(1, 1, 'norm') * res_scrn;
    % param.sigma_scrn1 = [sigma_scrn_x1; sigma_scrn_y1];
    
    % sigma_scrn_x2 = lnls_generate_random_numbers(1, 1, 'norm') * res_scrn;
    % sigma_scrn_y2 = lnls_generate_random_numbers(1, 1, 'norm') * res_scrn;
    % param.sigma_scrn2 = [sigma_scrn_x2; sigma_scrn_y2];
    
    % sigma_scrn_x3 = lnls_generate_random_numbers(1, 1, 'norm') * res_scrn;
    % sigma_scrn_y3 = lnls_generate_random_numbers(1, 1, 'norm') * res_scrn;
    % param.sigma_scrn3 = [sigma_scrn_x3; sigma_scrn_y3];
    
    %=====================================================================
    %=====================================================================
    
    % Setting the machine configurations

    [machine, s] = vchamber_injection(bo_ring);
    
    % Error in the magnets (allignment, rotation, excitation, multipoles,
    % setting off rf cavity and radiation emission
    machine = setcavity('off', machine);
    machine = setradiation('off', machine);
    family_data = sirius_bo_family_data(machine);
    machine  = create_apply_errors(machine, family_data);
    machine  = create_apply_multipoles(machine, family_data);
    machine = machine{1};
    
    function [machine, s] = vchamber_injection(machine)
        %Values of vacuum chamber radius in horizontal plane at the end of
        %injection septum and the initial point of injection kicker
        xcv_sep = 41.86e-3;
        xcv_kckr = 30.14e-3;

        s = findspos(machine, 1:length(machine));
        injkckr = findcells(machine, 'FamName','InjKckr');
        xcv = (xcv_kckr - xcv_sep) / (s(injkckr) - s(1)) * s(1:injkckr)  + xcv_sep;

        % Vacuum chamber inside the inj. kicker set as the same as initial point
        xcv = [xcv, xcv(end)];
        machine = setcellstruct(machine, 'VChamber', 1:injkckr+1, xcv, 1, 1);
    end
end
%% Initializations
function initializations()

    fprintf('\n<initializations> [%s]\n\n', datestr(now));

    % seed for random number generator
    seed = 131071;
    fprintf('-  initializing random number generator with seed = %i ...\n', seed);
    RandStream.setGlobalStream(RandStream('mt19937ar','seed', seed));

end
%% Magnet Errors:
function machine = create_apply_errors(the_ring, family_data)

    fprintf('\n<error generation and random machines creation> [%s]\n\n', datestr(now));

    % constants
    um = 1e-6; mrad = 0.001; percent = 0.01;

    % <quadrupoles> alignment, rotation and excitation errors
    config.fams.quads.labels     = {'QF','QD','QS'};
    config.fams.quads.sigma_x    = 160 * um;
    config.fams.quads.sigma_y    = 160 * um;
    config.fams.quads.sigma_roll = 0.800 * mrad;
    config.fams.quads.sigma_e    = 0.3 * percent;

    % <sextupoles> alignment, rotation and excitation errors
    config.fams.sexts.labels     = {'SD','SF'};
    config.fams.sexts.sigma_x    = 160 * um;
    config.fams.sexts.sigma_y    = 160 * um;
    config.fams.sexts.sigma_roll = 0.800 * mrad;
    config.fams.sexts.sigma_e    = 0.3 * percent;

    % <dipoles with more than one piece> alignment, rotation and excitation errors
    config.fams.b.labels       = {'B'};
    config.fams.b.sigma_x      = 160 * um;
    config.fams.b.sigma_y      = 160 * um;
    config.fams.b.sigma_roll   = 0.800 * mrad;
%         config.fams.b.sigma_e      = 0.15 * percent * 1;
    config.fams.b.sigma_e      = 0.05 * percent; % based on estimated error of measured fmap analysis from measurement bench fluctuation - XRR - 2018-08-23
%         config.fams.b.sigma_e_kdip = 2.4 * percent * 1;  % quadrupole errors due to pole variations
    config.fams.b.sigma_e_kdip = 0.3 * percent;  % based on measured fmap analysis - XRR - 2018-08-23 - see /home/fac_files/lnls-ima/bo-dipoles/model-09/analysis/hallprobe/production/magnet-dispersion.ipynb

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
    name = 'CONFIG';

    errors        = lnls_latt_err_generate_errors(name, the_ring, config, nr_machines, cutoff_errors, rndtype);

    % applies errors to machines
    fractional_delta = 1;
    fprintf('-  creating %i random machines and applying errors ...\n', nr_machines);
    fprintf('-  finding closed-orbit distortions with sextupoles off ...\n\n');
    machine = lnls_latt_err_apply_errors(name, the_ring, errors, fractional_delta);
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

    % adds systematic multipole errors to random machines
    for i=1:length(machine)
        machine{i} = sirius_bo_multipole_systematic_errors(machine{i});
    end
    
    name = 'CONFIG';
    cutoff_errors = 2;
    multi_errors  = lnls_latt_err_generate_multipole_errors(name, machine{1,1}, multi, length(machine), cutoff_errors);
    machine = lnls_latt_err_apply_multipole_errors(name, machine, multi_errors, multi);

end