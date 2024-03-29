function [param_out, machine, r_bpm] = single_adj_loop(si_ring, n_part, n_pulse, param_in, param_errors_in, matrix_inj)
% Single loop of injection parameters adjustment. It uses measurements of
% screen 1 to adjust the injection angle with injection kicker turned off, after that turns
% on the kicker and with screen 1 again adjustes the kicker angle for the first time.
% With screen 2 adjustes kicker angle for the second time and comparing
% measurements of screen 1 and 2 perform a fine adjustment of kicker angle.
% If after this step the absolute value of position of screen 2 is still
% greater than 0.5 mm, with this value it changes the injection angle to compensate
% the injetion position error which is not being correted. This part is
% repeated until the position of screen 2 is lesser than 0.5 mm (screen
% resolution). The last step of single loop is check the position of screen
% 3 to determine the energy deviation error, correct this energy changing the
% energy of particles (equivalent to change the current of dipoles) and
% after this proceed to the next single loop.
%
% INPUTS:
% - si_ring: storage ring model
% - n_part: number of particles
% - n_pulse: number of pulses to average the measurements
% - set_m: 'yes' set a machine from nominal model, 'no' consider that bo_ring is
% already a machine with errors included
% - param_in: if set_machine is 'no' it requires injection parameters,
% which must be given in the struct param_in (used after the single loop of
% injection adjustment algorithm)
%
% OUTPUTS:
% - param_out: injection parameters after one loop of algorithm
% - machine: storage ring model after setting kicker and errors (if
% set_machine = 'yes', otherwise, machine = bo_ring
% - r_bpm2: position x and y of BPM 2 to check if the energy was
% properly corrected
%
% Version 1 - Murilo B. Alves - December, 2018
    machine = si_ring;
    param0 = param_in;
    param0_errors = param_errors_in;
    bpm = findcells(machine, 'FamName', 'BPM');
    param0.orbit = findorbit4(machine, 0, 1:length(machine));
    
    
    % if ~corr_energy
        % SCREEN 1 ON
        % kckr = 'off';
        % [~, param_out] = sirius_commis.injection.si.bpm1_sept(machine, param0, param0_errors, n_part, n_pulse, bpm(1), kckr);
        % KICKER ON -->> WITH BPM 1 MEASUREMENT, ADJUST THE KICKER
        kckr = 'on';
        % [~, param_out] = sirius_commis.injection.si.bpm1_kckr(machine, param_out, param0_errors, n_part, n_pulse, bpm(1), kckr);
        
        % param_out = sirius_commis.injection.si.kckr_scan(machine, param_out, param0_errors, n_part, n_pulse, 15, kckr);
        % matrix_inj = sirius_commis.injection.si.calc_respm_inj(machine, param_out, param0_errors, n_part);
        % [param_out, machine] = sirius_commis.injection.si.inj_corr(machine, param_out, param0_errors, n_part, n_pulse, matrix_inj);
        % sirius_commis.injection.si.bba_inj(machine, param_out, param0_errors, n_part, n_pulse, 11, kckr)
        
        param_out = sirius_commis.injection.si.pso_run(machine, param0, param0_errors, n_part, n_pulse, 14, 50, 12880, 0);
        
        
    % else
    %    param_out = param0;
    %    kckr = 'on';
    % end

    % [param_out, r_bpm] = sirius_commis.injection.si.bpm2_energy(machine, param_out, param0_errors, n_part, n_pulse, [bpm(1), bpm(2), bpm(3)], kckr);
    r_bpm = [0, 0];
end
