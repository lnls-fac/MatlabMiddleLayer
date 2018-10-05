function [param_out, machine, r_scrn3] = bo_injection_adjustment(bo_ring, n_part, n_pulse, set_machine, param_in)
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
% - bo_ring: booster ring model
% - n_part: number of particles
% - n_pulse: number of pulses to average the measurements
% - set_m: 'yes' set a machine from nominal model, 'no' consider that bo_ring is
% already a machine with errors included
% - param_in: if set_machine is 'no' it requires injection parameters,
% which must be given in the struct param_in (used after the first loop of
% injection adjustment algorithm)
%
% OUTPUTS:
% - param_out: injection parameters after one loop of algorithm
% - machine: booster ring model after setting kicker and errors (if
% set_machine = 'yes', otherwise, machine = bo_ring
% - r_scrn3: position x and y of screen 3 to check if the energy was
% properly corrected
%
% Version 1 - Murilo B. Alves - October 4th, 2018


    if(exist('set_m','var'))
        if(strcmp(set_machine,'yes'))
            flag_machine = true;
        elseif(strcmp(set_machine,'no'))
            flag_machine = false;
        end            
    else
        error('Set machine: yes or no')
    end
    
    if flag_machine
        [machine, param0, ~] = bo_set_machine(bo_ring);
        param0_errors = add_errors_injection(param0);
    else
        machine = bo_ring;
        param0_errors = param_in;
        if(~exist('param_in', 'var'))
            error('Struct with parameters missing');
        end
    end
    
    scrn = findcells(machine, 'FamName', 'Scrn');
    
    % SCREEN 1 ON
    kckr = 'off';   
    [~, param_out] = screen1(machine, param0_errors, n_part, n_pulse, scrn(1), kckr);
    % KICKER ON -->> WITH SCREEN 1 MEASUREMENT, ADJUST THE KICKER
    kckr = 'on';
    [~, param_out] = screen1_kckr(machine, param_out, n_part, n_pulse, scrn(1), kckr);
    % SCREEN 2 ON TO ADJUST KICKER AGAIN // KICKER ON
    [r_scrn2, param_out] = screen2(machine, param_out, n_part, n_pulse, scrn(2), kckr);
    % FINE ADJUSTMENT OF ANGLE IN SCREEN 1
    [r_scrn2, param_out] = fine_adjust_scrn1_scrn2(machine, param_out, n_part, n_pulse, kckr, scrn(1), scrn(2), r_scrn2);
    
    if abs(r_scrn2(1)) > param_out.sigma_scrn;    
        fprintf('=================================================\n');
        fprintf('READJUSTING THE BEAM TO REACH THE KICKER CENTER\n');
        fprintf('=================================================\n');

        param_out = center_kicker(machine, param_out, r_scrn2(1));
        fprintf('=================================================\n');
        fprintf('REPEAT THE PROCESS \n');
        fprintf('=================================================\n');

        % KICKER ON -->> WITH SCREEN 1 MEAS., ADJUST THE KICKER
        kckr = 'on';
        [~, param_out] = screen1_kckr(machine, param_out, n_part, n_pulse, scrn(1), kckr);
        % SCREEN 2 ON TO ADJUST KICKER AGAIN // KICKER ON
        [r_scrn2, param_out] = screen2(machine, param_out, n_part, n_pulse, scrn(2), kckr);
        % FINE ADJUSTMENT OF ANGLE IN SCREEN 1
        [~, param_out] = fine_adjust_scrn1_scrn2(machine, param_out, n_part, n_pulse, kckr, scrn(1), scrn(2), r_scrn2);
    end
    
    [param_out, r_scrn3] = screen3(machine, param_out, n_part, n_pulse, scrn(3), kckr);
end
    
 

        



