function [eff, r_point, r_end, machine, r_bpm, int_bpm] = bo_pulses(machine, param, n_part, n_pulse, point, kckr, plt, diag)
    injkckr = findcells(machine, 'FamName', 'InjKckr');
    eff = zeros(1, n_pulse);
    sigma_scrn = zeros(n_pulse, 2);
    sigma_bpm = zeros(n_pulse, 2, 50);
    r_pulse = zeros(n_pulse, 2, point);
    r_diag_bpm = zeros(n_pulse, 2, 50);
    r_end = zeros(n_pulse, 6, n_part);
    orbit = param.orbit;
    if(exist('kckr','var'))
        if(strcmp(kckr,'on'))
            flag_kckr = true;
        elseif(strcmp(kckr,'off'))
            flag_kckr = false;
        end            
    else
        error('Set if the kicker is turned on or off')
    end
    
    flag_diag = false;
    
    if(exist('plt','var'))
        if(strcmp(plt,'plot'))
            flag_plot = true;
        elseif(strcmp(plt,'diag'))
            flag_diag = true;
            flag_plot = false;
        else
            error('Variable plot problem');
        end
    elseif(~exist('plt','var'))
            flag_plot = false;
    end
    
    if(exist('diag','var'))
        if(strcmp(diag,'diag'))
            flag_diag = true;
        end
    elseif(~exist('diag','var')) && ~flag_diag
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
            [sigma_bpm(j, :, :), int_bpm] = bpm_error_inten(r_bpm, n_part, param.sigma_bpm);
        else
            [r_xy, r_end_part] = sirius_booster_injection(machine, param, n_part, point);
        end    
        r_pulse(j, :, :) =  nanmean(r_xy, 2);
        r_end(j, :, :) = r_end_part;

        eff(j) = calc_eff(n_part, r_xy(:, :, point));      
        sigma_scrn(j, :) = scrn_error_inten(r_xy, n_part, point, param.sigma_scrn);
        
    
        if flag_plot
            plot_booster_turn(machine, r_xy);
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
        else
            r_diag_bpm = squeeze(r_diag_bpm);
        end
        r_bpm = compares_vchamb(machine, r_diag_bpm, bpm, 'bpm');
        plot_bpms(machine, orbit, r_bpm, int_bpm);
    end
     fprintf('=================================================\n');
end

% function plot_bpms(machine, r_bpm, orbit, int_bpm)
%     VChamb = cell2mat(getcellstruct(machine, 'VChamber', 1:length(machine)))';
%     s_total = findspos(machine, 1:length(machine));
%     bpm = findcells(machine, 'FamName', 'BPM');
%     s = s_total(bpm);
%     x = r_bpm(1, :);
%     y = r_bpm(2, :);
%     if ~isappdata(0, 'fig')
%         fig = figure('OuterPosition', [100, 100, 800, 900]);
%         ax1 = subplottight(3,1,1, 'vspace', 0.05);
%         ax2 = subplottight(3,1,2, 'vspace', 0.05);
%         ax3 = subplottight(3,1,3, 'vspace', 0.05);
%         setappdata(0, 'fig', fig);
%         setappdata(0, 'ax1', ax1);
%         setappdata(0, 'ax2', ax2);
%         setappdata(0, 'ax3', ax3);
%     else
%         fig = getappdata(0, 'fig');
%         try
%             get(fig, 'type');
%         catch
%             fig = figure('OuterPosition', [100, 100, 800, 900]);
%             ax1 = subplottight(3,1,1, 'vspace', 0.05);
%             ax2 = subplottight(3,1,2, 'vspace', 0.05);
%             ax3 = subplottight(3,1,3, 'vspace', 0.05);
%             setappdata(0, 'fig', fig);
%             setappdata(0, 'ax1', ax1);
%             setappdata(0, 'ax2', ax2);
%             setappdata(0, 'ax3', ax3);
%         end
%         ax1 = getappdata(0, 'ax1');
%         ax2 = getappdata(0, 'ax2');
%         ax3 = getappdata(0, 'ax3');
%     end
%     hold(ax1, 'off');
%     hold(ax2, 'off');
%     hold(ax3, 'off');
%     plot(ax1, s, x, '.-b', 'linewidth', 1);
%     plot(ax2, s, y, '.-r', 'linewidth', 1);
%     plot(ax3, s, int_bpm, '.-k', 'linewidth', 1);
%     hold(ax1, 'on');
%     hold(ax2, 'on');
%     hold(ax3, 'on');
%     plot(ax1, s, orbit(1, :), '.-k', 'linewidth', 2);
%     plot(ax2, s, orbit(3, :), '--k', 'linewidth', 2);
%     plot(ax1, s_total, VChamb(1,:),'k');
%     plot(ax1, s_total, -VChamb(1,:),'k');
%     plot(ax2, s_total, VChamb(2,:),'k');
%     plot(ax2, s_total, -VChamb(2,:),'k');
%     ylim(ax1, [-0.02, 0.02]);
%     grid(ax1, 'on');
%     grid(ax2, 'on');
%     grid(ax3, 'on');
%     drawnow;
% end

function plot_booster_turn(machine, r_final)
    VChamb = cell2mat(getcellstruct(machine, 'VChamber', 1:length(machine)))';
    s = findspos(machine, 1:length(machine));
    xx = squeeze(nanmean(r_final(1, :, :), 2));
    sxx = squeeze(nanstd(r_final(1, :, :), 0, 2));
    gcf();
    ax = gca();
    hold off;
    plot(ax, s, (xx+3*sxx)', 'b --');
    hold all;
    plot(ax, s, (xx-3*sxx)', 'b --');
    plot(ax, s, (xx)', '.-r', 'linewidth', 3);
    plot(ax, s, VChamb(1,:),'k');
    plot(ax, s, -VChamb(1,:),'k');
    drawnow;        
end




