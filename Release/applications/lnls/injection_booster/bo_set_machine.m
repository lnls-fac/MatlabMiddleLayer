function [machine, param] = bo_set_machine(bo_ring)
    name = 'CONFIG'; name_saved_machines = name;
    initializations();

    %=====================================================================
    %=====================================================================

    % Setting parameters of injection 

    sept = findcells(bo_ring, 'FamName', 'InjSept');
    bo_ring = circshift(bo_ring, [0, - (sept - 1)]);
    bo_twiss = calctwiss(bo_ring);
    
    
    %VARIAR COM PARAM DE TWISS
    param.betax0 = bo_twiss.betax(1);
    param.betay0 = bo_twiss.betay(1);
    param.alphax0 = bo_twiss.alphax(1);
    param.alphay0 = bo_twiss.alphay(1);
    param.etax0 = bo_twiss.etax(1);
    param.etay0 = bo_twiss.etay(1);
    param.etaxl0 = bo_twiss.etaxl(1);
    param.etayl0 = bo_twiss.etayl(1);
    
    param.emitx = 170e-9;
    param.emity = param.emitx;
    param.sigmae = 0.5e-2;
    param.sigmaz = 0.5e-3;
    
    param.offset_x0 = -30e-3;
    param.offset_xl0 = 14.3e-3;
    param.kckr0 = -19.34e-3;
    param.delta0 = 0;
    param.delta_ave = 0;
    param.delta_energy_scrn3 = 0;
    
    %Calculates the horizontal dispersion function at screen 3    
    dipole = findcells(bo_ring, 'FamName', 'B');
    dipole = dipole(1);
    scrn = findcells(bo_ring, 'FamName', 'Scrn');
    scrn3 = scrn(3);
    delta = 1e-5;
    d = dipole:scrn3;
    r_init_n = [0; 0; 0; 0; -delta; 0];
    r_final_n = linepass(bo_ring(d), r_init_n);
    r_init_p = [0; 0; 0; 0; +delta; 0];
    r_final_p = linepass(bo_ring(d), r_init_p);
    x_n = r_final_n(1);
    x_p = r_final_p(1);
    param.etax_scrn3 = (x_p - x_n) / 2 / delta;
    
    %Calculates the horizontal dispersion function at BPMS    
    bpms = findcells(bo_ring, 'FamName', 'BPM');
    delta = 1e-5;
    r_init_n = [0; 0; 0; 0; -delta; 0];
    r_final_n = linepass(bo_ring, r_init_n, bpms);
    r_init_p = [0; 0; 0; 0; +delta; 0];
    r_final_p = linepass(bo_ring, r_init_p, bpms);
    x_n = r_final_n(1, :);
    x_p = r_final_p(1, :);
    param.etax_bpms = (x_p - x_n) ./ 2 ./ delta;
    %=====================================================================
    %=====================================================================
    
    % Setting the machine configurations

    machine = vchamber_injection(bo_ring);
    
    % Error in the magnets (allignment, rotation, excitation, multipoles,
    % setting off rf cavity and radiation emission
    
    machine = setcavity('off', machine);
    machine = setradiation('off', machine);
    family_data = sirius_bo_family_data(machine);
    machine  = create_apply_errors(machine, family_data);
    machine  = create_apply_multipoles(machine, family_data);
    
    % for k = 1:length(machine)
    %    bpm = findcells(machine{k}, 'FamName', 'BPM');
    %    param.orbit{k} = findorbit4(machine{k}, 0, bpm);
    % end
    
    function machine = vchamber_injection(machine)
        
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
    config.fams.b.sigma_e      = 0*0.05 * percent; % based on estimated error of measured fmap analysis from measurement bench fluctuation - XRR - 2018-08-23
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
    
    fname = which('sirius_bo_multipole_systematic_errors');
    copyfile(fname, [name '_multipole_systematic_errors.m']);

    cutoff_errors = 2;
    multi_errors  = lnls_latt_err_generate_multipole_errors(name, machine{1,1}, multi, length(machine), cutoff_errors);
    machine = lnls_latt_err_apply_multipole_errors(name, machine, multi_errors, multi);
    name_saved_machines = [name_saved_machines '_multi'];
    save([name_saved_machines '.mat'], 'machine');
end
end