function septum_adjustment(bo_ring, n_part)

    [machine, param, ~] = set_machine(bo_ring);
    
    pp = pulsos(machine, param, n_part, 10);
 
    function plot = pulsos(machine, param, n_part, n_pulse)
        injkckr = findcells(machine, 'FamName', 'InjKckr');
        eff = zeros(1,n_pulse);
    
        for j=1:n_pulse;
            error_kckr_pulse = lnls_generate_random_numbers(1, 1, 'norm') * param.kckr_error_pulse;
            param.kckr = param.kckr_erro + error_kckr_pulse;
            machine = lnls_set_kickangle(machine, param.kckr, injkckr, 'x'); 

            error_inj_pulse = lnls_generate_random_numbers(1, 1, 'norm') * param.xl_error_pulse;
            param.offset_xl = param.offset_xl_erro + error_inj_pulse;

            r_final = sirius_booster_injection(machine, param, n_part);
            [~, eff(j)] = graficos(machine, r_final, n_part);
            plot = 1;
            end

            fprintf('EFICIENCIA MEDIA %f: \n', mean(eff)) ;
    
        end

    scrn = findcells(machine, 'FamName', 'Scrn');
    scrn1 = scrn(1);
    scrn2 = scrn(2);
    scrn3 = scrn(3);
    
    [r_scrn1, param] = screen1(machine, param, n_part, scrn1);
    [~, machine] = screen2(machine, param, n_part, r_scrn1, scrn1, scrn2);
    
end
    
    %===============================SCREEN 1===============================
    function [r_scrn1, param] = screen1(machine, param, n_part, scrn1)
    dxf_e = 1;
    res_scrn = param.sigma_scrn;
    s = findspos(machine, 1:length(machine));
    
    inj_kckr = findcells(machine, 'FamName', 'InjKckr');
    inj_kckr_struct = machine(inj_kckr(1));
    inj_kckr_struct = inj_kckr_struct{1};

    L_kckr = inj_kckr_struct.Length;
    
    d_kckr_scrn = s(scrn1) - s(inj_kckr) - L_kckr/2; % posicao s é no inicio do elemento // PASSA EM X=0 NO CENTRO DO KICKER
    x_kckr_scrn = tan(-param.kckr0) * d_kckr_scrn;
    sigma_scrn_x1 = lnls_generate_random_numbers(1, 1, 'norm') * res_scrn;
    sigma_scrn_y1 = lnls_generate_random_numbers(1, 1, 'norm') * res_scrn;
    sigma_scrn1 = [sigma_scrn_x1; sigma_scrn_y1];
    
    while dxf_e > res_scrn
        
        error_inj_pulse = lnls_generate_random_numbers(1, 1, 'norm') * param.xl_error_pulse;
        param.offset_xl = param.offset_xl_erro + error_inj_pulse;
        
        r_final = sirius_booster_injection(machine, param, n_part);
        r_scrn1 = r_final([1,3], :, scrn1);
        r_scrn1 = nanmean(r_scrn1, 2) + sigma_scrn1;
        
        dxf = r_scrn1(1) - x_kckr_scrn;
        dtheta0 = scrn_septum_corresp(machine, dxf, scrn1);
        param.offset_xl_erro = param.offset_xl_erro + dtheta0;
        dxf_e = abs(dxf);
       
        fprintf('Posicao x da Screen 1: %f mm SEM KICKER, erro %f mm \n', r_scrn1(1)*1e3, dxf_e*1e3);
        % fprintf('Posicao y da Screen: %f mm\n', r_scrn(2)*1e3);
        
 
    end
   
    injkckr = findcells(machine, 'FamName', 'InjKckr');
    error_kckr_pulse = lnls_generate_random_numbers(1, 1, 'norm') * param.kckr_error_pulse;
    param.kckr = param.kckr_erro + error_kckr_pulse;
    machine = lnls_set_kickangle(machine, param.kckr, injkckr, 'x'); 

    error_inj_pulse = lnls_generate_random_numbers(1, 1, 'norm') * param.xl_error_pulse;
    param.offset_xl = param.offset_xl_erro + error_inj_pulse;

    r_final = sirius_booster_injection(machine, param, n_part);
    r_scrn1 = r_final([1,2], :, scrn1);
    r_scrn1 = nanmean(r_scrn1, 2) + sigma_scrn1;        

    fprintf('Posicao x da Screen 1: %f mm COM KICKER \n', r_scrn1(1)*1e3);
    % r_final = graficos(machine, r_final, n_part);
    
    end
    
        
    % for j=1:2;
    %    error_inj_pulse = lnls_generate_random_numbers(1, 1, 'norm') * param.xl_error_pulse;
    %    param.offset_xl = param.offset_xl_sept + error_inj_pulse;
    %    r_final = sirius_booster_injection(machine, param, n_part);
    %    r_final = graficos(machine, r_final, n_part);
    %    r_kckr = r_final([1,3], :, inj_kckr);
    %    r_kckr2 = r_final([1,3], :, inj_kckr+1);
    %    r_kckr = squeeze(nanmean(r_kckr, 2));
    %    r_kckr2 = squeeze(nanmean(r_kckr2, 2));
    %    a = tan((r_kckr2(1)-r_kckr(1))/(s(inj_kckr+1) - s(inj_kckr)));
    %    d_0 = a*0.2 + r_kckr(1);
    %    fprintf('x_kckr: %f mm \n', d_0*1e3);
    % end
   
    
function [r_scrn2, machine] = screen2(machine, param, n_part, r_scrn1, scrn1, scrn2)
    %===============================SCREEN 2===============================
    dxl = 1;
    res_scrn = param.sigma_scrn;
    s = findspos(machine, 1:length(machine));
    
    sigma_scrn_x2 = lnls_generate_random_numbers(1, 1, 'norm') * res_scrn;
    sigma_scrn_y2 = lnls_generate_random_numbers(1, 1, 'norm') * res_scrn;
    sigma_scrn2 = [sigma_scrn_x2; sigma_scrn_y2];
    
    injkckr = findcells(machine, 'FamName', 'InjKckr');
    xl_scrn1 =1;
    
    while abs(dxl) > res_scrn
        error_kckr_pulse = lnls_generate_random_numbers(1, 1, 'norm') * param.kckr_error_pulse;
        param.kckr = param.kckr_erro + error_kckr_pulse;
        machine = lnls_set_kickangle(machine, param.kckr, injkckr, 'x');

        error_inj_pulse = lnls_generate_random_numbers(1, 1, 'norm') * param.xl_error_pulse;
        param.offset_xl = param.offset_xl_erro + error_inj_pulse;

        r_final = sirius_booster_injection(machine, param, n_part);
        r_scrn2 = r_final([1,3], :, scrn2);
        r_scrn2 = nanmean(r_scrn2, 2) + sigma_scrn2;
        
        ddd = (s(scrn2) - s(scrn1));
        xl_scrn1 = (r_scrn2(1) - r_scrn1(1)) / (s(scrn2) - s(scrn1));
        dxl = r_scrn2(1) - r_scrn1(1);
        param.kckr_erro = param.kckr_erro - xl_scrn1;
        % r_final = graficos(machine, r_final, n_part);
        
        fprintf('Posicao x da Screen 2: %f mm COM KICKER,  erro %f mm, angulo %f mrad \n', r_scrn2(1)*1e3, abs(dxl)*1e3, abs(xl_scrn1)*1e3);
    end
    
    injkckr = findcells(machine, 'FamName', 'InjKckr');
    eff = zeros(1, 30);
    
    for j=1:30;
    error_kckr_pulse = lnls_generate_random_numbers(1, 1, 'norm') * param.kckr_error_pulse;
    param.kckr = param.kckr_erro + error_kckr_pulse;
    machine = lnls_set_kickangle(machine, param.kckr, injkckr, 'x'); 

    error_inj_pulse = lnls_generate_random_numbers(1, 1, 'norm') * param.xl_error_pulse;
    param.offset_xl = param.offset_xl_erro + error_inj_pulse;

    r_final = sirius_booster_injection(machine, param, n_part);

    %fprintf('Posicao x da Screen 1: %f mm COM KICKER \n', r_scrn1(1)*1e3);
    [~, eff(j)] = graficos(machine, r_final, n_part);
    end
    fprintf('EFICIENCIA MEDIA %f \n', mean(eff));
end
        
function dtheta = scrn_septum_corresp(machine, dxf, scrn)
    s = findspos(machine, 1:length(machine));

    qf = findcells(machine, 'FamName', 'QF');
    qf_struct = machine(qf(1));
    qf_struct = qf_struct{1};

    K_QF = qf_struct.PolynomB;
    K_QF = K_QF(2);
    L_QF = qf_struct.Length; % metade do tamanho do quadrupolo
    
    KL_QF =  2 * K_QF * L_QF;
    
    mqf = findcells(machine, 'FamName', 'mQF');

    d1 = s(mqf(1));
    d2 = s(scrn) - d1; 

    % Drift from the end inj sept to the center of QF, then apply QF, and one
    % more drift from the center of QF to the first screen (relation
    % between x_scrn and x'_septum
    
    factor = d1 + d2  - d1 * d2 / KL_QF;
    
    dtheta = 1 / factor * dxf;
end

function [r_final, eff] = graficos(machine, r_final, n_part)

    s = findspos(machine, 1:length(machine));
    VChamb = cell2mat(getcellstruct(machine, 'VChamber', 1:length(machine)))';
    VChamb = VChamb([1, 2], :);
    VChamb = reshape(VChamb, 2, [], length(machine));

    xy_final = r_final([1, 3], :, :);
    ind = bsxfun(@gt, abs(xy_final), VChamb);

    or = ind(1, :, :) | ind(2, :, :);
    ind(1, :, :) = or;
    ind(2, :, :) = or;
    ind_sum = cumsum(ind, 3);

    xy_final(ind_sum >= 1) = NaN;

    r_final([1, 3], :, :) = xy_final;

    xx = squeeze(nanmean(r_final(1, :, :), 2));
    % xx = squeeze(r_final(1, :, :));
    sxx = squeeze(nanstd(r_final(1, :, :), 0, 2));
    f = figure;
    plot(s, (xx+3*sxx)', 'b --');
    hold all
    plot(s, (xx-3*sxx)', 'b --');

    % x = squeeze(nanmean(r_final(1, :, bpm), 2));
    % f = figure;
    plot(s, (xx)', '-r', 'linewidth', 3);
    % hold all
    plot(s, VChamb(1,:),'k');
    plot(s, -VChamb(1,:),'k');
    movegui(f,'east');
    n_perdida = sum(isnan(r_final(1,:, end)));
    eff = (1-n_perdida / n_part)*100;
    fprintf('%i particulas perdidas de %i (eficiencia %g %%)\n', n_perdida, n_part, (1-n_perdida / n_part)*100);
end


