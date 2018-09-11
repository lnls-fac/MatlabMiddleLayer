function param = fine_adjust_scrn1_scrn2(machine, param, n_part, scrn1, scrn2, n_pulse, r_scrn2_in, sigma_scrn2_in)
    res_scrn = param.sigma_scrn;
    s = findspos(machine, 1:length(machine));
    dx12 = 1;
    theta12 = 0;
    
    if ~isempty(r_scrn2_in)
        r_scrn2 = r_scrn2_in(:, [1,3], :, scrn1);
        r_scrn2 = squeeze(nanmean(r_scrn2, 3));
        r_scrn2 = r_scrn2 + sigma_scrn2_in;
        r_scrn2 = squeeze(nanmean(r_scrn2, 1));
        
        if isnan(r_scrn2(1))
            error('PARTICLES ARE LOST BEFORE SCREEN 2');
        end
        
        fprintf('Screen 2 - x position: %f mm \n', r_scrn2(1)*1e3);
        
        fprintf('=================================================\n');
        fprintf('SCREEN 1 ON \n')
        fprintf('=================================================\n');
        [~, r_final_pulse1, sigma_scrn1] = bo_pulses(machine, param, n_part, n_pulse, 0, scrn1, 1);
        % sigma_scrn1 = scrn_error_inten(r_final_pulse1, n_part, scrn1, param.sigma_scrn);
      
        r_scrn1 = r_final_pulse1(:, [1,3], :, scrn1);
        r_scrn1 = squeeze(nanmean(r_scrn1, 3));
        r_scrn1 = r_scrn1 + sigma_scrn1;
        r_scrn1 = squeeze(nanmean(r_scrn1, 1));
        
        if isnan(r_scrn1(1))
            error('PARTICLES ARE LOST BEFORE SCREEN 1');
        end
      
        fprintf('Screen 1 - x position: %f mm \n', r_scrn1(1)*1e3);
        
        dx12 = r_scrn2(1) - r_scrn1(1);
        d12 = s(scrn2) - s(scrn1);
        theta12 = atan(dx12 / d12);
        
        fprintf('error: %f mm, angle: %f mrad \n', abs(dx12)*1e3, abs(theta12)*1e3);
    end
    
    if isempty(r_scrn2_in) && isempty(sigma_scrn2_in)
        r_scrn2_in = 0;
        sigma_scrn2_in = 0;
    end
        
        
    while abs(dx12) > res_scrn
        
        param.kckr_erro = param.kckr_erro - theta12;
        fprintf('=================================================\n');
        fprintf('SCREEN 1 ON \n')
        fprintf('=================================================\n');
        [~, r_final_pulse1, sigma_scrn1] = bo_pulses(machine, param, n_part, n_pulse, 0, scrn1, 1);
      
        r_scrn1 = r_final_pulse1(:, [1,3], :, scrn1);
        r_scrn1 = squeeze(nanmean(r_scrn1, 3));
        r_scrn1 = r_scrn1 + sigma_scrn1;
        r_scrn1 = squeeze(nanmean(r_scrn1, 1));
        
        if isnan(r_scrn1(1))
            error('PARTICLES ARE LOST BEFORE SCREEN 1');
        end
        
        fprintf('Screen 1 - x position: %f mm \n', r_scrn1(1)*1e3);
        fprintf('=================================================\n');
        fprintf('SCREEN 1 OFF AND SCREEN 2 ON \n')
        fprintf('=================================================\n');
        
        [~, r_final_pulse2, sigma_scrn2] = bo_pulses(machine, param, n_part, n_pulse, 0, scrn2, 1);
       
        r_scrn2 = r_final_pulse2(:, [1,3], :, scrn1);
        r_scrn2 = squeeze(nanmean(r_scrn2, 3));
        r_scrn2 = r_scrn2 + sigma_scrn2;
        r_scrn2 = squeeze(nanmean(r_scrn2, 1));
        
        if isnan(r_scrn2(1))
            error('PARTICLES ARE LOST BEFORE SCREEN 2');
        end
        
        fprintf('Screen 2 - x position: %f mm \n', r_scrn2(1)*1e3);

        dx12 = r_scrn2(1) - r_scrn1(1);
        d12 = s(scrn2) - s(scrn1);
        theta12 = atan(dx12 / d12);
        
        fprintf('error: %f mm, angle: %f mrad \n', abs(dx12)*1e3, abs(theta12)*1e3);
    end
    fprintf('=================================================\n');
    fprintf('KICKER ANGLE ADJUSTED TO %f mrad \n', param.kckr_erro*1e3);
    fprintf('=================================================\n');
end