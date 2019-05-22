function machine_data = set_machine(si_ring, n_mach)
% Setting of random machines, nominal injection parameters (without errors), parameters with errors and the standard deviation to generate errors.
% It includes random errors of excitation and alignment of magnets and also
% adjustes the vacuum chamber at injection point (injection septum).
%
% INPUT:
% - si_ring: nominal ring model
% - n_mach: number of machines that will be generated
%
% OUTPUTS:
% - machine_data: struct with the following fields
%         - machine: cell with n_mach elements which are random machines models
%         - parameters: injection parameters with errors added for each machine
%         - errors: injection errors introduced in the nominal parameters
%         - sigma_errors: standard deviation to generate random errors
%         - nominal_parameters: nominal injection parameters
%
% NOTE: once the function sirius_bo_lattice_errors_analysis() is updated,
% this function must be updated too in the parts of magnet errors.
%
% See also: sirius_commis.common.add_errors

    % Seeds initialization for the sake of reprodubility
    sirius_commis.common.initializations();

    % Initializing variables
    param_errors = cells(n_mach, 1);
    param = cells(n_mach, 1);

    % Shifting the ring to begin in the injection septum
    si_ring = shift_ring(si_ring, 'InjSeptF');
    fam = sirius_si_family_data(si_ring);

    %Twiss function at injection point
    si_twiss = calctwiss(si_ring);
    param_init.twiss.betax0 = si_twiss.betax(1);
    param_init.twiss.betay0 = si_twiss.betay(1);
    param_init.twiss.alphax0 = si_twiss.alphax(1);
    param_init.twiss.alphay0 = si_twiss.alphay(1);
    param_init.twiss.etax0 = si_twiss.etax(1);
    param_init.twiss.etay0 = si_twiss.etay(1);
    param_init.twiss.etaxl0 = si_twiss.etaxl(1);
    param_init.twiss.etayl0 = si_twiss.etayl(1);

    %Beam parameters from Booster
    param_init.beam.emitn = 3.47e-9; k = 3e-2;
    param_init.beam.coupling = k;
    param_init.beam.emitx =  param_init.beam.emitn / (1+k);
    param_init.beam.emity = param_init.beam.emitx * k;
    param_init.beam.sigmae = 9e-4;
    param_init.beam.sigmaz = 3e-3;

    %Nominal settings for injection
    param_init.offset_x0 = -17.92e-3;
    param_init.offset_xl0 = 5.608e-3;
    param_init.offset_y0 = 0;
    param_init.offset_yl0 = 0;
    param_init.kckr0 = -5.608e-3;
    param_init.delta0 = 0;
    param_init.delta_ave = 0;
    param_init.phase = 0;

    %One sigma to generate systematic and jitter errors in injection parameters and also in the diagnostics
    param_sigma.x_syst = 2e-3; param_sigma.x_jit = 500e-6;
    param_sigma.xl_syst = 3e-3; param_sigma.xl_jit = 30e-6;
    param_sigma.y_syst = 2e-3; param_sigma.y_jit = 500e-6;
    param_sigma.yl_syst = 2e-3; param_sigma.yl_jit = 30e-6;
    param_sigma.kckr_syst = 1e-3; param_sigma.kckr_jit = 30e-6;
    param_sigma.energy_syst = 1e-2; param_sigma.energy_jit = 0.3e-2;
    param_sigma.bpm_offset = 500e-6; param_sigma.bpm_jit = 2e-3;
    param_sigma.scrn_offset = 1e-3; param_sigma.scrn_jit = 500e-6;

    %Calculates the horizontal dispersion function at BPMs
    bpms = fam.BPM.ATIndex;
    delta = 1e-8;
    r_init_n = [0; 0; 0; 0; - delta / 2; 0];
    r_final_n = linepass(si_ring, r_init_n, bpms);
    r_init_p = [0; 0; 0; 0; + delta / 2; 0];
    r_final_p = linepass(si_ring, r_init_p, bpms);
    x_n = r_final_n(1, :);
    x_p = r_final_p(1, :);
    param_init.etax_bpms = (x_p - x_n) ./ delta;

    machine = si_ring;
    factor = 1; %Can be used to control the error tolerances

    %Turning off the cavity and radiation effects
    machine = setcavity('off', machine);
    machine = setradiation('off', machine);

    %Alignments, rolls and excitation errors
    machine  = create_apply_errors(machine, fam, n_mach, factor);

    %Higher-order multipoles errors
    machine  = create_apply_multipoles(machine, fam);

    %Including offsets in the BPMs measurements
    machine = create_apply_bpm_errors(machine, fam, factor, param_sigma.bpm_offset);

    %For each random machine, based on the sigma errors given by param_sigma, generate random injection parameters errors
    for i = 1:n_mach
        [param_errors{i}, param{i}] = sirius_commis.common.add_errors(param_init, param_sigma);
    end

    machine_data.machine = machine;
    machine_data.parameters = param;
    machine_data.errors = param_errors;
    machine_data.sigma_errors = param_sigma;
    machine_data.nominal_parameters = param_init;
end

%% Magnet Errors:
function machine = create_apply_errors(the_ring, family_data, n_mach, factor)

          fprintf('\n<error generation and random machines creation> [%s]\n\n', datestr(now));
        name = 'CONFIG';
        % constants
        um = 1e-6; mrad = 0.001; percent = 0.01;

        % <quadrupoles> alignment, rotation and excitation errors
        config.fams.quads.labels     = {'QFA','QDA',...
                                        'QDB2','QFB','QDB1',...
                                        'QDP2','QFP','QDP1',...
                                        'Q1','Q2','Q3','Q4','FC1','FC2',...
                                        };
        config.fams.quads.sigma_x    = factor * 40 * um;
        config.fams.quads.sigma_y    = factor * 40 * um;
        config.fams.quads.sigma_roll = factor * 0.30 * mrad;
        config.fams.quads.sigma_e    = factor * 0.05 * percent;

        % <sextupoles> alignment, rotation and excitation errors
        config.fams.sexts.labels     = {'SFA0','SFB0','SFP0',...
                                        'SFA1','SFB1','SFP1',...
                                        'SFA2','SFB2','SFP2',...
                                        'SDA0','SDB0','SDP0',...
                                        'SDA1','SDB1','SDP1',...
                                        'SDA2','SDB2','SDP2',...
                                        'SDA3','SDB3','SDP3',...
                                        };
        config.fams.sexts.sigma_x    = factor * 40 * um;
        config.fams.sexts.sigma_y    = factor * 40 * um;
        config.fams.sexts.sigma_roll = factor * 0.17 * mrad; % based on batch measurements (see Luana'a and James' emails of 2018-04-23)
        config.fams.sexts.sigma_e    = factor * 0.05 * percent;

        %ERRORS FOR DIPOLES B1 AND B2 ARE DEFINED IN GIRDERS AND IN THE
        %MAGNET BLOCKS

        % <dipoles with only one piece> alignment, rotation and excitation errors
        config.fams.bc.labels     = {'BC'};
        config.fams.bc.sigma_y    = factor * 40 * um;
        config.fams.bc.sigma_x    = factor * 40 * um;
        config.fams.bc.sigma_roll = factor * 0.30 * mrad;
        config.fams.bc.sigma_e    = factor * 0.05 * percent;
        config.fams.bc.sigma_e_kdip = factor * 0.10 * percent;  % quadrupole errors due to pole variations

        % <girders> alignment and rotation
        config.girder.girder_error_flag = true;
        config.girder.correlated_errors = false;
        config.girder.sigma_x     = factor * 80 * um;
        config.girder.sigma_y     = factor * 80 * um;
        config.girder.sigma_roll  = factor * 0.30 * mrad;

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
        config.fams.bendblocks.labels       = {'B1','B2'};
        B1_nrsegs = family_data.B1.nr_segs;
        B2_nrsegs = family_data.B2.nr_segs;
        if mod(B1_nrsegs,2) || mod(B2_nrsegs,3)
            error('nrsegs of B1/B2 must be a multiple of 2/3.');
        end
        config.fams.bendblocks.nrsegs       = [B1_nrsegs/2,B2_nrsegs/3];
        config.fams.bendblocks.sigma_x      = factor * 40 * um;
        config.fams.bendblocks.sigma_y      = factor * 40 * um;
        config.fams.bendblocks.sigma_roll   = factor * 0.30 * mrad;
        config.fams.bendblocks.sigma_e      = factor * 0.05 * percent;
        config.fams.bendblocks.sigma_e_kdip = factor * 0.10 * percent;  % quadrupole errors due to pole variations


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
%%
function machine = create_apply_bpm_errors(machine, family_data, factor, offset)
        % BPM  anc Corr errors are treated differently from magnet errors:
        name = 'CONFIG';

        control.bpm.idx = family_data.BPM.ATIndex;
        control.bpm.sigma_offsetx   = factor * offset;
        control.bpm.sigma_offsety   = factor * offset;

        cutoff_errors = 1;
        machine = lnls_latt_err_generate_apply_bpmcorr_errors(name, machine, control, cutoff_errors);
    end

%% Multipoles insertion
function machine = create_apply_multipoles(machine, family_data)

    fprintf('\n<application of multipole errors> [%s]\n\n', datestr(now));
    name = 'CONFIG';

        % QUADRUPOLES
        multi.quadsM.labels = {'QFA','QDA',...
                               'QDB2','QFB','QDB1',...
                               'QDP2','QFP','QDP1',...
                               'Q1','Q2','Q3','Q4',...
                               };
        multi.quadsM.main_multipole = 2;% positive for normal negative for skew
        multi.quadsM.r0 = 12e-3;
        multi.quadsM.order     = [ 3   4   5   6]; % 1 for dipole
        multi.quadsM.main_vals = ones(1,4)*1.5e-4;
        multi.quadsM.skew_vals = ones(1,4)*0.5e-4;

        % SEXTUPOLES
        multi.sexts.labels = {'SFA0','SFB0','SFP0',...
                              'SFA1','SFB1','SFP1',...
                              'SFA2','SFB2','SFP2',...
                              'SDA0','SDB0','SDP0',...
                              'SDA1','SDB1','SDP1',...
                              'SDA2','SDB2','SDP2',...
                              'SDA3','SDB3','SDP3',...
                              };
        multi.sexts.main_multipole = 3;% positive for normal negative for skew
        multi.sexts.r0 = 12e-3;
        % random errors based on batch measurements (see Luana's and James' emails of 2018-04-23 for ximenes)
        multi.sexts.order     = [ 3     4     5     6 ]; % 1 for dipole
        multi.sexts.main_vals = [ 7e-4, 5e-4, 4e-4, 2e-4];
        multi.sexts.skew_vals = [ 5e-4, 5e-4, 5e-5, 9e-5];

        % DIPOLES
        multi.bends.labels = {'B1','B2','BC'};
        multi.bends.main_multipole = 1;% positive for normal negative for skew
        multi.bends.r0 = 12e-3;
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
            machine{i} = sirius_si_multipole_systematic_errors(machine{i},family_data);
        end

        cutoff_errors = 2;
        multi_errors  = lnls_latt_err_generate_multipole_errors(name, machine{1}, multi, length(machine), cutoff_errors);
        machine = lnls_latt_err_apply_multipole_errors(name, machine, multi_errors, multi);
end
