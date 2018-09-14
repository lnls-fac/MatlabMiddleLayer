function bo_injection_adjustment(bo_ring, n_part, n_pulse)

    [machine, param, ~] = bo_set_machine(bo_ring);
    scrn = findcells(machine, 'FamName', 'Scrn');
    
    %PULSOS INICIAIS MOSTRAM QUE NÃO HÁ VOLTA COM CONFIG. INICIAIS
    
    fprintf('=================================================\n');
    fprintf('INITIAL CONFIGURATION \n')
    fprintf('=================================================\n');
    [eff0, ~] = bo_pulses(machine, param, n_part, n_pulse, 0, length(machine), 1);
    fprintf('=================================================\n');
    fprintf('AVERAGE EFFICIENCY %g %% +/- %g %% \n', mean(eff0)*100, std(eff0)*100);
    fprintf('=================================================\n');
    
    %ABAIXA SCREEN 1 // KICKER OFF
    machine1 = setcellstruct(machine, 'VChamber', scrn(1)+1:length(machine), 0, 1, 1);      
    %BASEADO NAS MEDIDAS DA SCREEN 1, AJUSTA ANGULO DE SAÍDA DO SEPTUM // KICKER OFF   
    [~, param] = screen1(machine1, param, n_part, n_pulse, scrn(1));
    
    % COM A SCREEN 1 ABAIXADA // KICKER ON
    [~, param] = screen1_kckr(machine1, param, n_part, n_pulse, scrn(1));
    [eff1, ~] = bo_pulses(machine, param, n_part, n_pulse, 1, length(machine), 1);
    fprintf('=================================================\n');
    fprintf('AVERAGE EFFICIENCY %g %% +/- %g %% \n', mean(eff1)*100, std(eff1)*100);
    fprintf('=================================================\n');
       
    %ABAIXA SCREEN 2 // KICKER ON
    machine2 = setcellstruct(machine, 'VChamber', scrn(2)+1:length(machine), 0, 1, 1);  
    [~, param] = screen2(machine2, param, n_part, n_pulse, scrn(2));
    [eff2, r_scrn2_in, sigma_scrn2_in] = bo_pulses(machine, param, n_part, n_pulse, 1, length(machine), 1);
    fprintf('=================================================\n');
    fprintf('AVERAGE EFFICIENCY %g %% +/- %g %% \n', mean(eff2)*100, std(eff2)*100);
    fprintf('=================================================\n');
    %FINE ADJUSTMENT OF ANGLE IN SCREEN 1
    param = fine_adjust_scrn1_scrn2(machine, param, n_part, scrn(1), scrn(2), n_pulse, r_scrn2_in, sigma_scrn2_in);
    % NESTAS CONFIG. DÁ VÁRIOS PULSOS 
    [eff3, ~] = bo_pulses(machine, param, n_part, n_pulse, 1, length(machine), 1);
    fprintf('=================================================\n');
    fprintf('AVERAGE EFFICIENCY %g %% +/- %g %% \n', mean(eff3)*100, std(eff3)*100);
    fprintf('=================================================\n');
    
    fprintf('=================================================\n');
    fprintf('IMPROVEMENT %g %% -> %g %% -> %g %% -> %g %% \n', mean(eff0)*100, mean(eff1)*100, mean(eff2)*100, mean(eff3)*100);
    fprintf('=================================================\n');
    
    r_scrn3 = screen3(machine, param, n_part, n_pulse, scrn(3));
    fprintf('Screen 3 - x position %f mm \n', r_scrn3(1)*1e3);
end
    
 

        



