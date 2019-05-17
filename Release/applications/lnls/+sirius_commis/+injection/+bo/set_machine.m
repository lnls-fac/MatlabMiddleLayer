function machine_data = set_machine(bo_ring, n_mach)
% Setting of random machines and nominal injection parameters (without errors).
% It includes random errors of excitation and alignment of magnets and also
% adjustes the vacuum chamber at injection point (injection septum).
%
% INPUT:
% - bo_ring: nominal ring model
%
% OUTPUTS:
% - machine: ring model with vacuum chamber adjusted and magnet errors
% - param: nominal injection parameters struct
%
% NOTE: once the function sirius_bo_lattice_errors_analysis() is updated,
% this function must be updated too in the parts of magnet errors.
%
% See also: add_errors_injection, bo_injection_adjustment
%
% Version 1 - Murilo B. Alves - October 4th, 2018.

    sirius_commis.common.initializations();

    % Setting parameters of injection
    bo_ring = shift_ring(bo_ring, 'InjSept');
    bo_twiss = calctwiss(bo_ring);
    fam = sirius_bo_family_data(bo_ring);

    param_init.twiss.betax0 = bo_twiss.betax(1);
    param_init.twiss.betay0 = bo_twiss.betay(1);
    param_init.twiss.alphax0 = bo_twiss.alphax(1);
    param_init.twiss.alphay0 = bo_twiss.alphay(1);
    param_init.twiss.etax0 = bo_twiss.etax(1);
    param_init.twiss.etay0 = bo_twiss.etay(1);
    param_init.twiss.etaxl0 = bo_twiss.etaxl(1);
    param_init.twiss.etayl0 = bo_twiss.etayl(1);

    param_init.beam.emitx = 170e-9;
    param_init.beam.emity = param_init.beam.emitx;
    param_init.beam.sigmae = 0.5e-2;
    param_init.beam.sigmaz = 3e-3;

    param_init.offset_x0 = -30e-3;
    param_init.offset_xl0 = 14.3e-3;
    param_init.offset_y0 = 0;
    param_init.offset_yl0 = 0;
    param_init.kckr0 = -19.34e-3;
    param_init.delta0 = 0;
    param_init.delta_ave = 0;
    param_init.delta_energy_scrn3 = 0;

    param_sigma.x_syst = 2e-3; param_sigma.x_jit = 500e-6;
    param_sigma.xl_syst = 3e-3; param_sigma.xl_jit = 30e-6;
    param_sigma.y_syst = 2e-3; param_sigma.y_jit = 500e-6;
    param_sigma.yl_syst = 2e-3; param_sigma.yl_jit = 30e-6;
    param_sigma.kckr_syst = 1e-3; param_sigma.kckr_jit = 30e-6;
    param_sigma.energy_syst = 1e-2; param_sigma.energy_jit = 0.3e-2;
    param_sigma.bpm_offset = 500e-6; param_sigma.bpm_jit = 2e-3;
    param_sigma.scrn_offset = 1e-3; param_sigma.scrn_jit = 500e-6;

    %Calculates the horizontal dispersion function at screen 3
    % dipole = findcells(bo_ring, 'FamName', 'B');
    dipole = fam.B.ATIndex(1);
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
    param_init.etax_scrn3 = (x_p - x_n) / 2 / delta;

    %Calculates the horizontal dispersion function at BPMs
    bpms = fam.BPM.ATIndex;
    delta = 1e-5;
    r_init_n = [0; 0; 0; 0; -delta; 0];
    r_final_n = linepass(bo_ring, r_init_n, bpms);
    r_init_p = [0; 0; 0; 0; +delta; 0];
    r_final_p = linepass(bo_ring, r_init_p, bpms);
    x_n = r_final_n(1, :);
    x_p = r_final_p(1, :);
    param_init.etax_bpms = (x_p - x_n) ./ 2 ./ delta;

    % Setting the vacuum chamber at injection point
    machine = sirius_commis.injection.bo.vchamber_injection(bo_ring);

    % Error in the magnets (allignment, rotation, excitation, multipoles,
    % setting off rf cavity and radiation emission

    factor = 1;
    machine = setcavity('off', machine);
    machine = setradiation('off', machine);
    machine  = create_apply_errors(machine, fam, n_mach, factor);
    machine  = create_apply_multipoles(machine, fam);
    machine = create_apply_bpm_errors(machine, fam, factor, param_sigma.bpm_offset);

    for i = 1:n_mach
        [param_errors{i}, param{i}] = sirius_commis.injection.bo.add_errors(param_init, param_sigma);
    end

    machine_data.machine = machine;
    machine_data.parameters = param;
    machine_data.errors = param_errors;
    machine_data.sigma_errors = param_sigma;
end
%% Magnet Errors:
function machine = create_apply_errors(the_ring, family_data, n_mach, factor)

    fprintf('\n<error generation and random machines creation> [%s]\n\n', datestr(now));

    % constants
    um = 1e-6; mrad = 0.001; percent = 0.01;
    name = 'CONFIG';

    % <quadrupoles> alignment, rotation and excitation errors
    config.fams.quads.labels     = {'QF','QD','QS'};
    config.fams.quads.sigma_x    = factor * 160 * um;
    config.fams.quads.sigma_y    = factor * 160 * um;
    config.fams.quads.sigma_roll = factor * 0.800 * mrad;
    config.fams.quads.sigma_e    = factor * 0.3 * percent;

    % <sextupoles> alignment, rotation and excitation errors
    config.fams.sexts.labels     = {'SD','SF'};
    config.fams.sexts.sigma_x    = factor * 160 * um;
    config.fams.sexts.sigma_y    = factor * 160 * um;
    config.fams.sexts.sigma_roll = factor * 0.800 * mrad;
    config.fams.sexts.sigma_e    = factor * 0.3 * percent;

    % <dipoles with more than one piece> alignment, rotation and excitation errors
    config.fams.b.labels       = {'B'};
    config.fams.b.sigma_x      = factor * 160 * um;
    config.fams.b.sigma_y      = factor * 160 * um;
    config.fams.b.sigma_roll   = factor * 0.800 * mrad;
%         config.fams.b.sigma_e      = 0.15 * percent * 1;
    config.fams.b.sigma_e      = factor * 0.05 * percent; % based on estimated error of measured fmap analysis from measurement bench fluctuation - XRR - 2018-08-23
%         config.fams.b.sigma_e_kdip = 2.4 * percent * 1;  % quadrupole errors due to pole variations
    config.fams.b.sigma_e_kdip = factor * 0.3 * percent;  % based on measured fmap analysis - XRR - 2018-08-23 - see /home/fac_files/lnls-ima/bo-dipoles/model-09/analysis/hallprobe/production/magnet-dispersion.ipynb

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
    nr_machines   = n_mach;
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

function machine = create_apply_bpm_errors(machine, family_data, factor, offset)
        % BPM  anc Corr errors are treated differently from magnet errors:
        % constants
        name = 'CONFIG';
        control.bpm.idx = family_data.BPM.ATIndex;
        control.bpm.sigma_offsetx   = factor * offset * 1;
        control.bpm.sigma_offsety   = factor * offset * 1;

        cutoff_errors = 1;
        machine = lnls_latt_err_generate_apply_bpmcorr_errors(name, machine, control, cutoff_errors);
end
%% Multipoles insertion
function machine = create_apply_multipoles(machine, family_data)

    fprintf('\n<application of multipole errors> [%s]\n\n', datestr(now));
    name = 'CONFIG';

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

    cutoff_errors = 2;
    multi_errors  = lnls_latt_err_generate_multipole_errors(name, machine{1,1}, multi, length(machine), cutoff_errors);
    machine = lnls_latt_err_apply_multipole_errors(name, machine, multi_errors, multi);
end
