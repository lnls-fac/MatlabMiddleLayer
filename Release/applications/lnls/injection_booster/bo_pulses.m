function [eff, r_final_pulse, sigma_scrn] = bo_pulses(machine, param, n_part, n_pulse, graf, scrn, kckr)
    injkckr = findcells(machine, 'FamName', 'InjKckr');
    eff = zeros(1, n_pulse);
    sigma_scrn = zeros(n_pulse, 2);
    r_final_pulse = zeros(n_pulse, 6, n_part, length(machine));
    
    for j=1:n_pulse;
        error_inj_pulse = lnls_generate_random_numbers(1, 1, 'norm') * param.xl_error_pulse;
        param.offset_xl = param.offset_xl_erro + error_inj_pulse;
        
        if kckr ==1
            error_kckr_pulse = lnls_generate_random_numbers(1, 1, 'norm') * param.kckr_error_pulse;
            param.kckr = param.kckr_erro + error_kckr_pulse;
            machine = lnls_set_kickangle(machine, param.kckr, injkckr, 'x');
        end
        
        r_final = sirius_booster_injection(machine, param, n_part);
        r_final_pulse(j, :, :, :) =  r_final(:, :, :);
        [~, eff(j)] = graficos(machine, r_final([1,3], :, :), n_part, graf, scrn);
        sigma_scrn(j, :) = scrn_error_inten(r_final, n_part, scrn, param.sigma_scrn);
    end
end

function sigma_scrn = scrn_error_inten(r_final, n_part, scrn, sigma_scrn0)
    N_loss = squeeze(sum(isnan(r_final(1,:, scrn))));
    Rate = (n_part - N_loss) / n_part;
    sigma = sigma_scrn0 / Rate;
    sigma_scrn_x = lnls_generate_random_numbers(1, 1, 'norm') * sigma;
    sigma_scrn_y = lnls_generate_random_numbers(1, 1, 'norm') * sigma;
    sigma_scrn = [sigma_scrn_x, sigma_scrn_y];
end

function [r_final, effi] = graficos(machine, r_final, n_part, graf, indice)

    [~, VChamb] = compares_vchamb(machine, r_final, 1:length(machine));
    s = findspos(machine, 1:length(machine));
    
    if graf == 1;
        xx = squeeze(nanmean(r_final(1, :, :), 2));
        sxx = squeeze(nanstd(r_final(1, :, :), 0, 2));
        f = gcf();
        ax = gca();
        hold off;
        plot(ax, s, (xx+3*sxx)', 'b --');
        hold all
        plot(ax, s, (xx-3*sxx)', 'b --');
        plot(ax, s, (xx)', '-r', 'linewidth', 3);
        plot(ax, s, VChamb(1,:),'k');
        plot(ax, s, -VChamb(1,:),'k');
        movegui(f,'east');
    end
    
    n_perdida = sum(isnan(r_final(1,:, indice)));
    effi = (1-n_perdida / n_part);
    fprintf('%i LOST PARTICLES OUT OF %i (EFFICIENCY %g %%)\n', n_perdida, n_part, (1-n_perdida / n_part)*100);
end



