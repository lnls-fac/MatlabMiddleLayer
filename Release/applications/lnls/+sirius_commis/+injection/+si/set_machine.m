function [machine, param, param_errors] = set_machine(si_ring, n_mach)
% Setting of random machines and nominal injection parameters (without errors).
% It includes random errors of excitation and alignment of magnets and also
% adjustes the vacuum chamber at injection point (injection septum).
%
% INPUT:
% - si_ring: nominal storage ring model
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
% Version 1 - Murilo B. Alves - December, 2018.

    name = 'CONFIG'; name_saved_machines = name;
    initializations();

    % Setting parameters of injection
    sept = findcells(si_ring, 'FamName', 'InjSeptF');
    si_ring = circshift(si_ring, [0, - (sept - 1)]);
    si_twiss = calctwiss(si_ring);
    fam = sirius_si_family_data(si_ring);

    param.twiss.betax0 = si_twiss.betax(1);
    param.twiss.betay0 = si_twiss.betay(1);
    param.twiss.alphax0 = si_twiss.alphax(1);
    param.twiss.alphay0 = si_twiss.alphay(1);
    param.twiss.etax0 = si_twiss.etax(1);
    param.twiss.etay0 = si_twiss.etay(1);
    param.twiss.etaxl0 = si_twiss.etaxl(1);
    param.twiss.etayl0 = si_twiss.etayl(1);

    param.beam.emitn = 3.47e-9;
    k = 3e-2;
    param.beam.coupling = 3e-2;
    param.beam.emitx =  param.beam.emitn / (1+k);
    param.beam.emity = param.beam.emitx * k;
    param.beam.sigmae = 0.087e-2;
    param.beam.sigmaz = 11.25e-3;

    param.offset_x0 = -17.92e-3;
    param.offset_xl0 = 5.608e-3;
    param.offset_y0 = 0;
    param.offset_yl0 = 0;
    
    param.kckr0 = -5.608e-3;
    param.delta0 = 0;
    param.delta_ave = 0;
    param.phase = 0;

    param.orbit = NaN(4, length(si_ring));


    %Calculates the horizontal dispersion function at BPMs
    bpms = fam.BPM.ATIndex;
    delta = 1e-5;
    r_init_n = [0; 0; 0; 0; -delta; 0];
    r_final_n = linepass(si_ring, r_init_n, bpms);
    r_init_p = [0; 0; 0; 0; +delta; 0];
    r_final_p = linepass(si_ring, r_init_p, bpms);
    x_n = r_final_n(1, :);
    x_p = r_final_p(1, :);
    param.etax_bpms = (x_p - x_n) ./ 2 ./ delta;

    % Setting the vacuum chamber at injection point
    % machine = vchamber_injection(si_ring);
    machine = si_ring;

    % Error in the magnets (allignment, rotation, excitation, multipoles,
    % setting off rf cavity and radiation emission
    machine = setcavity('off', machine);
    machine = setradiation('off', machine);
    machine  = create_apply_errors(machine, fam, n_mach);
    machine  = create_apply_multipoles(machine, fam);
    machine = create_apply_bpm_errors(machine, fam);

    
    [param_errors, param] = sirius_commis.injection.si.add_errors(param);

    function machine = vchamber_injection(machine)
        %Values of vacuum chamber radius in horizontal plane at the end of
        %injection septum and the initial point of injection kicker
        xcv_sep = 41.86e-3;
        xcv_kckr = 30.14e-3;

        s = findspos(machine, 1:length(machine));
        injkckr = findcells(machine, 'FamName','InjDpKckr');
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
function machine = create_apply_errors(the_ring, family_data, n_mach)

          fprintf('\n<error generation and random machines creation> [%s]\n\n', datestr(now));

        % constants
        um = 1e-6; mrad = 0.001; percent = 0.01;

        % <quadrupoles> alignment, rotation and excitation errors
        config.fams.quads.labels     = {'QFA','QDA',...
                                        'QDB2','QFB','QDB1',...
                                        'QDP2','QFP','QDP1',...
                                        'Q1','Q2','Q3','Q4','FC1','FC2',...
                                        };
        config.fams.quads.sigma_x    = 40 * um * 1;
        config.fams.quads.sigma_y    = 40 * um * 1;
        config.fams.quads.sigma_roll = 0.30 * mrad * 1;
        config.fams.quads.sigma_e    = 0.05 * percent * 1;

        % <sextupoles> alignment, rotation and excitation errors
        config.fams.sexts.labels     = {'SFA0','SFB0','SFP0',...
                                        'SFA1','SFB1','SFP1',...
                                        'SFA2','SFB2','SFP2',...
                                        'SDA0','SDB0','SDP0',...
                                        'SDA1','SDB1','SDP1',...
                                        'SDA2','SDB2','SDP2',...
                                        'SDA3','SDB3','SDP3',...
                                        };
        config.fams.sexts.sigma_x    = 40 * um * 1;
        config.fams.sexts.sigma_y    = 40 * um * 1;
        config.fams.sexts.sigma_roll = 0.17 * mrad * 1; % based on batch measurements (see Luana'a and James' emails of 2018-04-23)
        config.fams.sexts.sigma_e    = 0.05 * percent * 1;

        %ERRORS FOR DIPOLES B1 AND B2 ARE DEFINED IN GIRDERS AND IN THE
        %MAGNET BLOCKS

        % <dipoles with only one piece> alignment, rotation and excitation errors
        config.fams.bc.labels     = {'BC'};
        config.fams.bc.sigma_y    = 40 * um * 1;
        config.fams.bc.sigma_x    = 40 * um * 1;
        config.fams.bc.sigma_roll = 0.30 * mrad * 1;
        config.fams.bc.sigma_e    = 0.05 * percent * 1;
        config.fams.bc.sigma_e_kdip = 0.10 * percent * 1;  % quadrupole errors due to pole variations

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
        config.fams.bendblocks.labels       = {'B1','B2'};
        B1_nrsegs = family_data.B1.nr_segs;
        B2_nrsegs = family_data.B2.nr_segs;
        if mod(B1_nrsegs,2) || mod(B2_nrsegs,3)
            error('nrsegs of B1/B2 must be a multiple of 2/3.');
        end
        config.fams.bendblocks.nrsegs       = [B1_nrsegs/2,B2_nrsegs/3];
        config.fams.bendblocks.sigma_x      = 40 * um * 1;
        config.fams.bendblocks.sigma_y      = 40 * um * 1;
        config.fams.bendblocks.sigma_roll   = 0.30 * mrad * 1;
        config.fams.bendblocks.sigma_e      = 0.05 * percent * 1;
        config.fams.bendblocks.sigma_e_kdip = 0.10 * percent * 1;  % quadrupole errors due to pole variations


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
function machine = create_apply_bpm_errors(machine, family_data)
        % BPM  anc Corr errors are treated differently from magnet errors:
        % constants
        mm = 1e-3;
        
        control.bpm.idx = family_data.BPM.ATIndex;
        control.bpm.sigma_offsetx   = 0.5 * mm * 1; % BBA precision
        control.bpm.sigma_offsety   = 0.5 * mm * 1;
        
        cutoff_errors = 1;
        machine = lnls_latt_err_generate_apply_bpmcorr_errors(name, machine, control, cutoff_errors);
    end

%% Multipoles insertion
function machine = create_apply_multipoles(machine, family_data)

    fprintf('\n<application of multipole errors> [%s]\n\n', datestr(now));

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
        fname = which('sirius_si_multipole_systematic_errors');
        copyfile(fname, [name '_multipole_systematic_errors.m']);

        cutoff_errors = 2;
        multi_errors  = lnls_latt_err_generate_multipole_errors(name, machine{1}, multi, length(machine), cutoff_errors);
        machine = lnls_latt_err_apply_multipole_errors(name, machine, multi_errors, multi);

        name_saved_machines = [name_saved_machines '_multi'];
        save([name_saved_machines '.mat'], 'machine');
        % save2file(name_saved_machines,machine);
end
end
