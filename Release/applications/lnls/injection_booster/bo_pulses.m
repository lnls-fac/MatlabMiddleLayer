function [eff, r_point, r_end, machine, r_bpm] = bo_pulses(machine, param, n_part, n_pulse, point, kckr, plt, diag)
    injkckr = findcells(machine, 'FamName', 'InjKckr');
    eff = zeros(1, n_pulse);
    sigma_scrn = zeros(n_pulse, 2);
    sigma_bpm = zeros(n_pulse, 2, 50);
    r_pulse = zeros(n_pulse, 2, point);
    r_diag_bpm = zeros(n_pulse, 2, 50);
    r_end = zeros(n_pulse, 6, n_part);
    if(exist('kckr','var'))
        if(strcmp(kckr,'on'))
            flag_kckr = true;
        elseif(strcmp(kckr,'off'))
            flag_kckr = false;
        end            
    else
        error('Set if the kicker is turned on or off')
    end
    
    if(exist('plt','var'))
        if(strcmp(plt,'plot'))
            flag_plot = true;
        end
    elseif(~exist('plt','var'))
            flag_plot = false;
    end
    
    if(exist('diag','var'))
        if(strcmp(diag,'diag'))
            flag_diag = true;
        end
    elseif(~exist('diag','var'))
            flag_diag = false;
    end
    
    for j=1:n_pulse;        
        error_x_pulse = lnls_generate_random_numbers(1, 1, 'norm') * param.x_error_pulse;
        param.offset_x = param.offset_x_sist + error_x_pulse;
        
        error_xl_pulse = lnls_generate_random_numbers(1, 1, 'norm') * param.xl_error_pulse;
        param.offset_xl = param.offset_xl_sist + error_xl_pulse;
        
        if flag_kckr
            error_kckr_pulse = lnls_generate_random_numbers(1, 1, 'norm') * param.kckr_error_pulse;
            param.kckr = param.kckr_sist + error_kckr_pulse;
            machine = lnls_set_kickangle(machine, param.kckr, injkckr, 'x');
        end
        
        error_delta_pulse = lnls_generate_random_numbers(1, 1, 'norm') * param.delta_error_pulse;
        param.delta = param.delta_sist + error_delta_pulse;
        
        if flag_diag        
            [r_xy, r_end_part, r_bpm] = sirius_booster_injection(machine, param, n_part, point);
            r_diag_bpm(j, :, :) =  nanmean(r_bpm, 2);
            bpm = findcells(machine, 'FamName', 'BPM');
            sigma_bpm(j, :, :) = bpm_error_inten(r_bpm, n_part, param.sigma_bpm);
        else
            [r_xy, r_end_part] = sirius_booster_injection(machine, param, n_part, point);
        end    
        r_pulse(j, :, :) =  nanmean(r_xy, 2);
        r_end(j, :, :) = r_end_part;

        eff(j) = calc_eff(n_part, r_xy(:, :, point));      
        sigma_scrn(j, :) = scrn_error_inten(r_xy, n_part, point, param.sigma_scrn);
        
    
        if flag_plot && flag_diag
            % plot_booster_turn(machine, r_bpm, bpm, n_part, param.sigma_bpm);
        elseif flag_plot
            plot_booster_turn(machine, r_xy, 1:length(machine), n_part, param.sigma_bpm);
        end
        
        if ~mod(j, 10)
        fprintf('. %i pulses \n', j);
        else
        fprintf('.');
        end
    end
    
    if point ~= length(machine)
       fprintf('AVERAGE INTENSITY ON SCREEN :  %g %% \n', mean(eff)*100);
    else 
       fprintf('AVERAGE EFFICIENCY :  %g %% \n', mean(eff)*100);
    end
    
    
    r_point = r_pulse(:, :, point);
    r_point = r_point + sigma_scrn;
    r_point = compares_vchamb(machine, r_point, point, 'screen');
    r_point = squeeze(nanmean(r_point, 1));
    r_end = squeeze(r_end(end, :, :));
    
    if flag_diag
        r_diag_bpm = r_diag_bpm + sigma_bpm;
        if n_pulse > 1
            r_diag_bpm = squeeze(nanmean(r_diag_bpm, 1));
        end
        r_bpm = compares_vchamb(machine, r_diag_bpm, bpm, 'bpm');
        r_bpm = squeeze(nanmean(r_bpm, 1));
        plot_bpms(machine, r_bpm);
    end
     fprintf('=================================================\n');
end

function plot_bpms(machine, r_bpm)
    VChamb = cell2mat(getcellstruct(machine, 'VChamber', 1:length(machine)))';
    s_total = findspos(machine, 1:length(machine));
    bpm = findcells(machine, 'FamName', 'BPM');
    s = s_total(bpm);
    x = r_bpm(1, :);
    gcf();
    ax = gca();
    hold off;
    plot(ax, s, x, '.-r', 'linewidth', 1);
    hold all
    plot(ax, s_total, VChamb(1,:),'k');
    plot(ax, s_total, -VChamb(1,:),'k');
    drawnow;
end



