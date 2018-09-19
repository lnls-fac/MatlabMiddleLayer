function [r_scrn2, param] = fine_adjust_scrn1_scrn2(machine, param, n_part, scrn1, scrn2, n_pulse, r_scrn2_in, sigma_scrn2_in, kckr)
    res_scrn = param.sigma_scrn;
    s = findspos(machine, 1:length(machine));
    dx12 = 1;
    theta12 = 0;
    machine1 = setcellstruct(machine, 'VChamber', scrn1+1:length(machine), 0, 1, 1);
    machine2 = setcellstruct(machine, 'VChamber', scrn2+1:length(machine), 0, 1, 1); 
    kckr_inicial = param.kckr_inicial;
    if ~isempty(r_scrn2_in)
        r_scrn2 = r_scrn2_in(:, :, scrn1);
        r_scrn2 = r_scrn2 + sigma_scrn2_in;
        r_scrn2 = squeeze(nanmean(r_scrn2, 1));
        r_scrn2 = compares_vchamb(machine2, r_scrn2, scrn2);
        
        if isnan(r_scrn2(1))
            error('PARTICLES ARE LOST BEFORE SCREEN 2');
        end
        
        fprintf('Screen 2 - x position: %f mm \n', r_scrn2(1)*1e3);
        
        fprintf('=================================================\n');
        fprintf('SCREEN 1 ON \n')
        fprintf('=================================================\n');
        [~, r_final_pulse1, sigma_scrn1] = bo_pulses(machine1, param, n_part, n_pulse, 0, scrn1, kckr);
        r_scrn1 = r_final_pulse1(:, :, scrn1);
        r_scrn1 = r_scrn1 + sigma_scrn1;
        r_scrn1 = squeeze(nanmean(r_scrn1, 1));
        r_scrn1 = compares_vchamb(machine1, r_scrn1, scrn1);
        
        if isnan(r_scrn1(1))
           error('PARTICLES ARE LOST BEFORE SCREEN 1');
        end
      
        fprintf('Screen 1 - x position: %f mm \n', r_scrn1(1)*1e3);
        
        dx12 = r_scrn2(1) - r_scrn1(1);
        d12 = s(scrn2) - s(scrn1);
        theta12 = atan(dx12 / d12);
        
        fprintf('error: %f mm, angle: %f mrad \n', abs(dx12)*1e3, abs(theta12)*1e3);
    end        
        
    while abs(dx12) > res_scrn
        
        param.kckr_erro = param.kckr_erro - theta12;
        fprintf('=================================================\n');
        fprintf('SCREEN 1 OFF AND SCREEN 2 ON \n')
        fprintf('=================================================\n');
        [~, r_final_pulse2, sigma_scrn2] = bo_pulses(machine2, param, n_part, n_pulse, 0, scrn2, kckr);
       
        r_scrn2 = r_final_pulse2(:, :, scrn1);
        r_scrn2 = r_scrn2 + sigma_scrn2;
        r_scrn2 = squeeze(nanmean(r_scrn2, 1));
        r_scrn2 = compares_vchamb(machine2, r_scrn2, scrn2);
        
        if isnan(r_scrn2(1))
            error('PARTICLES ARE LOST BEFORE SCREEN 2');
        end
        
        fprintf('Screen 2 - x position: %f mm \n', r_scrn2(1)*1e3);

        dx12 = r_scrn2(1) - r_scrn1(1);
        d12 = s(scrn2) - s(scrn1);
        theta12 = atan(dx12 / d12);
        
        fprintf('error: %f mm, angle: %f mrad \n', abs(dx12)*1e3, abs(theta12)*1e3);
        
        if abs(dx12) < res_scrn
            break
        end
        
        fprintf('=================================================\n');
        fprintf('SCREEN 1 ON \n')
        fprintf('=================================================\n');
        [~, r_final_pulse1, sigma_scrn1] = bo_pulses(machine1, param, n_part, n_pulse, 0, scrn1, kckr);
      
        r_scrn1 = r_final_pulse1(:, :, scrn1);
        r_scrn1 = r_scrn1 + sigma_scrn1;
        r_scrn1 = squeeze(nanmean(r_scrn1, 1));
        r_scrn1 = compares_vchamb(machine1, r_scrn1, scrn1);
        
        if isnan(r_scrn1(1))
            error('PARTICLES ARE LOST BEFORE SCREEN 1');
        end
        
        fprintf('Screen 1 - x position: %f mm \n', r_scrn1(1)*1e3);
    end
    fprintf('=================================================\n');
    erro = abs(kckr_inicial - param.kckr_erro); 
    fprintf('KICKER ANGLE ADJUSTED TO %f mrad, THE ERROR WAS %f mrad \n', param.kckr_erro*1e3, erro*1e3);
    agr = (1-abs(erro - param.kckr_error_sist)/param.kckr_error_sist)*100;
    fprintf('THE GENERATED ERROR WAS %f mrad, EFF %f %% \n', param.kckr_error_sist*1e3, agr);
    fprintf('=================================================\n');
end