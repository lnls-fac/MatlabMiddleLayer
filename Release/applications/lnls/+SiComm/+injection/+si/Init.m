function MD = Init(THERING)
% Setting of random machines, nominal injection parameters (without errors), parameters with errors and the standard deviation to generate errors.
% It includes random errors of excitation and alignment of magnets and also
% adjustes the vacuum chamber at injection point (injection septum).
%
% INPUT:
% - THERING: nominal ring model
% - NMACH: number of machines that will be generated
%
% OUTPUTS:
% - MD (machine_data): struct with the following fields
%         - machine: cell with NMACH elements which are random machines models
%         - parameters: injection parameters with errors added for each machine
%         - errors: injection errors introduced in the nominal parameters
%         - sigma_errors: standard deviation to generate random errors
%         - nominal_parameters: nominal injection parameters
%
% NOTE: once the function sirius_bo_lattice_errors_analysis() is updated,
% this function must be updated too in the parts of magnet errors.
%
% See also: SiComm.common.add_errors

    % Seeds initialization for the sake of reprodubility
    % SiComm.common.initializations();

    % Shifting the ring to begin in the injection septum
    THERING = shift_ring(THERING, 'InjSeptF');
    fam = sirius_si_family_data(THERING);

    %Twiss function at injection point
    si_twiss = calctwiss(THERING);
    MD.Inj.Twiss.betax0 = si_twiss.betax(1);
    MD.Inj.Twiss.betay0 = si_twiss.betay(1);
    MD.Inj.Twiss.alphax0 = si_twiss.alphax(1);
    MD.Inj.Twiss.alphay0 = si_twiss.alphay(1);
    MD.Inj.Twiss.etax0 = si_twiss.etax(1);
    MD.Inj.Twiss.etay0 = si_twiss.etay(1);
    MD.Inj.Twiss.etaxl0 = si_twiss.etaxl(1);
    MD.Inj.Twiss.etayl0 = si_twiss.etayl(1);

    %Beam parameters from Booster
    MD.Beam.emitn = 3.47e-9; k = 3e-2;
    MD.Beam.coupling = k;
    MD.Beam.emitx =  MD.Beam.emitn / (1+k);
    MD.Beam.emity = MD.Beam.emitx * k;
    MD.Beam.sigmae = 9e-4;
    MD.Beam.sigmaz = 3e-3;
    MD.Beam.Cutoff = 3;
    MD.Beam.NPart = 100;
    MD.Beam.Lost = 0.10;

    %Nominal settings for injection
    MD.Inj.R0.offset_x0 = -17.92e-3;
    MD.Inj.R0.offset_xl0 = 5.608e-3;
    MD.Inj.R0.offset_y0 = 0;
    MD.Inj.R0.offset_yl0 = 0;
    MD.Inj.R0.kckr0 = -5.608e-3;
    MD.Inj.R0.delta0 = 0;
    MD.Inj.R0.delta_ave = 0;
    MD.Inj.R0.phase = 0;
    MD.Inj.NPulses = 1;
    MD.Inj.NTurns = 1;

    %One sigma to generate systematic and jitter errors in injection parameters and also in the diagnostics
    MD.Err.Sigma.x_syst = 2e-3; MD.Err.Sigma.x_jit = 500e-6;
    MD.Err.Sigma.xl_syst = 3e-3; MD.Err.Sigma.xl_jit = 30e-6;
    MD.Err.Sigma.y_syst = 2e-3; MD.Err.Sigma.y_jit = 500e-6;
    MD.Err.Sigma.yl_syst = 3e-3; MD.Err.Sigma.yl_jit = 30e-6;
    MD.Err.Sigma.kckr_syst = 1e-3; MD.Err.Sigma.kckr_jit = 30e-6;
    MD.Err.Sigma.energy_syst = 1e-2; MD.Err.Sigma.energy_jit = 0.3e-2;
    MD.Err.Sigma.bpm_offset = 500e-6; MD.Err.Sigma.bpm_jit = 2e-3;
    MD.Err.Sigma.scrn_offset = 1e-3; MD.Err.Sigma.scrn_jit = 500e-6;

    %Calculates the horizontal dispersion function at BPMs
    bpms = fam.BPM.ATIndex;
    delta = 1e-8;
    r_init_n = [0; 0; 0; 0; - delta / 2; 0];
    r_final_n = linepass(THERING, r_init_n, bpms);
    r_init_p = [0; 0; 0; 0; + delta / 2; 0];
    r_final_p = linepass(THERING, r_init_p, bpms);
    x_n = r_final_n(1, :);
    x_p = r_final_p(1, :);
    MD.Inj.Twiss.DispersionBPMs = (x_p - x_n) ./ delta;

    MD.Ring = THERING;
    MD.Err.Sigma.Cutoff = 1;

    %Turning off the cavity and radiation effects
    MD.Ring = setcavity('off', MD.Ring);
    MD.Ring = setradiation('off', MD.Ring);

    factor = 1;

    %Alignments, rolls and excitation errors
    MD.Ring  = create_apply_errors(MD.Ring, fam, 1, factor);

    %Higher-order multipoles errors
    MD.Ring  = create_apply_multipoles(MD.Ring, fam);

    %Including offsets in the BPMs measurements
    MD.Ring = create_apply_bpm_errors(MD.Ring, fam, factor, MD.Err.Sigma.bpm_offset);
    MD.Ring = MD.Ring{1};

    MD = SiComm.common.add_errors(MD);
    
    MD.COD4D = findorbit4(MD.Ring, 0, 1:length(MD.Ring));
    MD.COD6D = findorbit6(MD.Ring, 1:length(MD.Ring));
end

%% Magnet Errors:
function machine = create_apply_errors(the_ring, family_data, NMACH, factor)

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
        nr_machines   = NMACH;
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
