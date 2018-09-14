function [param, machine] = bo_injection_adjustment(bo_ring, n_part, n_pulse, set_m, param)

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
        param0_errors = add_errors(param0);
    else
        machine = bo_ring;
        if(~exist('param', 'var'))
            error('Struct with parameters missing');
        end
    end
    
    scrn = findcells(machine, 'FamName', 'Scrn');
    lm = length(machine);
    
    % PULSOS INICIAIS MOSTRAM QUE NÃO HÁ VOLTA COM CONFIG. INICIAIS
    % KICKER ON    
    fprintf('=================================================\n');
    fprintf('INITIAL CONFIGURATION \n')
    fprintf('=================================================\n');
    kckr = 'on';
    [eff0, ~] = bo_pulses(machine, param0_errors, n_part, n_pulse, 1, lm, kckr);
    fprintf('=================================================\n');
    fprintf('AVERAGE EFFICIENCY %g %% +/- %g %% \n', mean(eff0)*100, std(eff0)*100);
    fprintf('=================================================\n');
    
    % SCREEN 1 ON // KICKER OFF
    kckr = 'off';
    machine1 = setcellstruct(machine, 'VChamber', scrn(1)+1:lm, 0, 1, 1);      
    
    % WITH SCREEN 1 MEASUREMENTS, ADJUST THE SEPTUM FINAL ANGLE // KICKER OFF   
    [~, param] = screen1(machine1, param0_errors, n_part, n_pulse, scrn(1), kckr);
    
    % KICKER ON -->> WITH SCREEN 1 MEAS., ADJUST THE KICKER
    kckr = 'on';
    [~, param] = screen1_kckr(machine1, param, n_part, n_pulse, scrn(1), kckr);
    [eff1, ~] = bo_pulses(machine, param, n_part, n_pulse, 1, lm, kckr);
    fprintf('=================================================\n');
    fprintf('AVERAGE EFFICIENCY %g %% +/- %g %% \n', mean(eff1)*100, std(eff1)*100);
    fprintf('=================================================\n');
       
    % SCREEN 2 ON TO ADJUST KICKER AGAIN // KICKER ON
    machine2 = setcellstruct(machine, 'VChamber', scrn(2)+1:lm, 0, 1, 1);  
    [~, param] = screen2(machine2, param, n_part, n_pulse, scrn(2), kckr);
    [eff2, r_scrn2_in, sigma_scrn2_in] = bo_pulses(machine, param, n_part, n_pulse, 1, lm, kckr);
    fprintf('=================================================\n');
    fprintf('AVERAGE EFFICIENCY %g %% +/- %g %% \n', mean(eff2)*100, std(eff2)*100);
    fprintf('=================================================\n');
    % FINE ADJUSTMENT OF ANGLE IN SCREEN 1
    [r_scrn2, param] = fine_adjust_scrn1_scrn2(machine, param, n_part, scrn(1), scrn(2), n_pulse, r_scrn2_in, sigma_scrn2_in, kckr);
    % CHECK THE PULSES WITH THIS CONFIGURATION
    
    fprintf('ADJUST KICKER CENTER!!!! \n');
    
    param = centro_kicker(machine, param, r_scrn2(1));
    
     fprintf('CHECK AGAIN!!!! \n');
    
    % KICKER ON -->> WITH SCREEN 1 MEAS., ADJUST THE KICKER
    kckr = 'on';
    [~, param] = screen1_kckr(machine1, param, n_part, n_pulse, scrn(1), kckr);
    [eff1, ~] = bo_pulses(machine, param, n_part, n_pulse, 1, lm, kckr);
    fprintf('=================================================\n');
    fprintf('AVERAGE EFFICIENCY %g %% +/- %g %% \n', mean(eff1)*100, std(eff1)*100);
    fprintf('=================================================\n');
       
    % SCREEN 2 ON TO ADJUST KICKER AGAIN // KICKER ON
    machine2 = setcellstruct(machine, 'VChamber', scrn(2)+1:lm, 0, 1, 1);  
    [~, param] = screen2(machine2, param, n_part, n_pulse, scrn(2), kckr);
    [eff2, r_scrn2_in, sigma_scrn2_in] = bo_pulses(machine, param, n_part, n_pulse, 1, lm, kckr);
    fprintf('=================================================\n');
    fprintf('AVERAGE EFFICIENCY %g %% +/- %g %% \n', mean(eff2)*100, std(eff2)*100);
    fprintf('=================================================\n');
    % FINE ADJUSTMENT OF ANGLE IN SCREEN 1
    [~, param] = fine_adjust_scrn1_scrn2(machine, param, n_part, scrn(1), scrn(2), n_pulse, r_scrn2_in, sigma_scrn2_in, kckr);
    % CHECK THE PULSES WITH THIS CONFIGURATION      
    
    [eff3, ~] = bo_pulses(machine, param, n_part, n_pulse, 1, lm, kckr);
    fprintf('=================================================\n');
    fprintf('AVERAGE EFFICIENCY %g %% +/- %g %% \n', mean(eff3)*100, std(eff3)*100);
    fprintf('=================================================\n');
    
    param = screen3(machine, param, n_part, n_pulse, scrn(3), kckr);
    [eff4, ~] = bo_pulses(machine, param, n_part, 2*n_pulse, 1, lm, kckr);
    fprintf('=================================================\n');
    fprintf('AVERAGE EFFICIENCY %g %% +/- %g %% \n', mean(eff4)*100, std(eff4)*100);
    fprintf('=================================================\n');
    
    fprintf('=================================================\n');
    fprintf('IMPROVEMENT %g %% -> %g %% -> %g %% -> %g %% -> %g %% \n', mean(eff0)*100, mean(eff1)*100, mean(eff2)*100, mean(eff3)*100, mean(eff4)*100);
    fprintf('=================================================\n');
end
    
 

        



