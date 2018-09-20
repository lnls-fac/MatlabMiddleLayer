function [r_scrn2, param] = fine_adjust_scrn1_scrn2(machine, param, n_part, n_pulse, kckr, scrn1, scrn2, r_scrn2)
    res_scrn = param.sigma_scrn;
    s = findspos(machine, 1:length(machine));
    dx12 = 1;
    machine1 = setcellstruct(machine, 'VChamber', scrn1+1:length(machine), 0, 1, 1);
    machine2 = setcellstruct(machine, 'VChamber', scrn2+1:length(machine), 0, 1, 1); 
    % kckr_inicial = param.kckr_init;
    
    if isempty(r_scrn2)
        error('It is necessary a screen 2 measurement as input');
    end
    
    while abs(dx12) > res_scrn 
        if isnan(r_scrn2(1))
           error('PARTICLES ARE LOST BEFORE SCREEN 2');
        end
        
        fprintf('=================================================\n');
        fprintf('SCREEN 1 ON \n')
        fprintf('=================================================\n');

        [eff1, r_scrn1] = bo_pulses(machine1, param, n_part, n_pulse, scrn1, kckr);
        
        if mean(eff1) < 0.75
            param = screen_low_intensity(machine1, param, n_part, n_pulse, scrn1, kckr, mean(eff1), 1, 0.75);
            [~, r_scrn1] = bo_pulses(machine1, param, n_part, n_pulse, scrn1, kckr);
        end

        if isnan(r_scrn1(1))
           error('PARTICLES ARE LOST BEFORE SCREEN 1');
        end
        
        dx12 = r_scrn2(1) - r_scrn1(1);
        d12 = s(scrn2) - s(scrn1);
        theta12 = atan(dx12 / d12);

        if abs(dx12) < res_scrn
            param.kckr_sist = param.kckr_sist - theta12;
            fprintf('SCREEN 1 AND 2 DIFFERENCE: %f mm, ANGLE AFTER KICKER: %f mrad \n', abs(dx12)*1e3, abs(theta12)*1e3);
            break
        end
        
        % fprintf('error: %f mm, angle: %f mrad \n', abs(dx12)*1e3, abs(theta12)*1e3);
        param.kckr_sist = param.kckr_sist - theta12;
        fprintf('=================================================\n');
        fprintf('SCREEN 2 ON \n')
        fprintf('=================================================\n');
        [eff2, r_scrn2] = bo_pulses(machine2, param, n_part, n_pulse, scrn2, kckr);
        
        if mean(eff2) < 0.75
            param = screen_low_intensity(machine2, param, n_part, n_pulse, scrn1, kckr, mean(eff2), 2, 0.75);
            [~, r_scrn2] = bo_pulses(machine2, param, n_part, n_pulse, scrn2, kckr);
        end
    end
%       
%     fprintf('=================================================\n');
%     erro = abs(kckr_inicial - param.kckr_sist); 
%     fprintf('KICKER ANGLE ADJUSTED TO %f mrad, THE ERROR WAS %f mrad \n', param.kckr_sist*1e3, erro*1e3);
%     agr = prox_percent(erro, param.kckr_error_sist);
%     fprintf('THE GENERATED ERROR WAS %f mrad, Conf. %f %% \n', param.kckr_error_sist*1e3, agr);
%     fprintf('=================================================\n');
end