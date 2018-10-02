function [param, machine, r_scrn3] = bo_injection_adjustment(bo_ring, n_part, n_pulse, set_m, param_in)

    if(exist('set_m','var'))
        if(strcmp(set_m,'yes'))
            flag_machine = true;
        elseif(strcmp(set_m,'no'))
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
    [~, param] = screen1(machine, param0_errors, n_part, n_pulse, scrn(1), kckr);
    % KICKER ON -->> WITH SCREEN 1 MEASUREMENT, ADJUST THE KICKER
    kckr = 'on';
    [~, param] = screen1_kckr(machine, param, n_part, n_pulse, scrn(1), kckr);
    % SCREEN 2 ON TO ADJUST KICKER AGAIN // KICKER ON
    [r_scrn2, param] = screen2(machine, param, n_part, n_pulse, scrn(2), kckr);
    % FINE ADJUSTMENT OF ANGLE IN SCREEN 1
    [r_scrn2, param] = fine_adjust_scrn1_scrn2(machine, param, n_part, n_pulse, kckr, scrn(1), scrn(2), r_scrn2);
    
    if abs(r_scrn2(1)) > param.sigma_scrn;    
        fprintf('=================================================\n');
        fprintf('READJUSTING THE BEAM TO REACH THE KICKER CENTER\n');
        fprintf('=================================================\n');

        param = center_kicker(machine, param, r_scrn2(1));
        fprintf('=================================================\n');
        fprintf('REPEAT THE PROCESS \n');
        fprintf('=================================================\n');

        % KICKER ON -->> WITH SCREEN 1 MEAS., ADJUST THE KICKER
        kckr = 'on';
        [~, param] = screen1_kckr(machine, param, n_part, n_pulse, scrn(1), kckr);
        % SCREEN 2 ON TO ADJUST KICKER AGAIN // KICKER ON
        [r_scrn2, param] = screen2(machine, param, n_part, n_pulse, scrn(2), kckr);
        % FINE ADJUSTMENT OF ANGLE IN SCREEN 1
        [~, param] = fine_adjust_scrn1_scrn2(machine, param, n_part, n_pulse, kckr, scrn(1), scrn(2), r_scrn2);
    end
    
    [param, r_scrn3] = screen3(machine, param, n_part, n_pulse, scrn(3), kckr);
end
    
 

        



