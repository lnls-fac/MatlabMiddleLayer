function [bba_analy, bpmx_ok, bpmy_ok] = plot_bba(bba_data, n_mach, loop, plt, bpms_bba, bpm_cutoff)

if loop
    for i = 1:n_mach
        bba_analy{i} = analy(bba_data, i, plt, bpms_bba, bpm_cutoff);
        bba_before(i, :) = bba_analy{i}.dif_nobba_std;
        bba_after(i, :) = bba_analy{i}.dif_bba_std;
    end
    
    for i = 1:size(bba_analy{1}.dif_nobba, 1)
        for j = 1:n_mach
           bba_rand_nobba(j, :) = bba_analy{j}.dif_nobba(i, :);
           bba_rand_bba(j, :) = bba_analy{j}.dif_bba(i, :);
           bba_obt(j, :) = bba_analy{j}.bba_obt(i, :);
        end
        rand_stat_nobba(i, :) = nanstd(bba_rand_nobba, 1);
        rand_stat_bba(i, :) = nanstd(bba_rand_bba, 1);
        bba_fail = isnan(bba_obt);
        
        if sum(bba_fail(:, 1)) <= round(1 * n_mach) % n_mach / 2 
            rand_stat_bba_obt(i, 1) = nanstd(bba_obt(:, 1), 1);
        else
            rand_stat_bba_obt(i, 1) = NaN;
        end
        
        if sum(bba_fail(:, 2)) <= round(1 * n_mach)
            rand_stat_bba_obt(i, 2) = nanstd(bba_obt(:, 2), 1);
        else
            rand_stat_bba_obt(i, 2) = NaN;
        end
            
    end
    
    bpms_bba_ok_x = find(~isnan(rand_stat_bba_obt(:, 1)));
    bpms_bba_ok_y = find(~isnan(rand_stat_bba_obt(:, 2)));
    
    rand_stat_nobba(isnan(rand_stat_bba_obt)) = NaN;
    rand_stat_bba(isnan(rand_stat_bba_obt)) = NaN;
    
    meanx_before = nanmean(rand_stat_nobba(:, 1)); stdx_before = nanstd(rand_stat_nobba(:, 1));
    meanx_after = nanmean(rand_stat_bba(:, 1)); stdx_after = nanstd(rand_stat_bba(:, 1));
    
    meany_before = nanmean(rand_stat_nobba(:, 2)); stdy_before = nanstd(rand_stat_nobba(:, 2));
    meany_after = nanmean(rand_stat_bba(:, 2)); stdy_after = nanstd(rand_stat_bba(:, 2));
    
    % bba_after_mx = squeeze(nanmax(bba_after(:, 1)));
    % bba_after_my = squeeze(nanmax(bba_after(:, 2)));
    % bba_before_mx = squeeze(nanmax(bba_before(:, 1)));
    % bba_before_my = squeeze(nanmax(bba_before(:, 2)));
    table(meanx_before, stdx_before, meanx_after, stdx_after, ...
        'VariableNames',{'MeanX_before','SigmaX_before', 'MeanX_after', 'SigmaX_after'})
    table(meany_before, stdy_before, meany_after, stdy_after, ...
        'VariableNames',{'MeanY_before','SigmaY_before', 'MeanY_after', 'SigmaY_after'})
    % fprintf('Machines Stat RMS Offset Before BBA X: %f um Y: %f um \n', bba_before_mx, bba_before_my);
    % fprintf('Machines Stat RMS Offset After BBA X: %f um Y: %f um \n ', bba_after_mx, bba_after_my);
    % fprintf('Machines Stat RMS Offset Reduction Factor X: %f Y: %f \n \n ', bba_before_mx / bba_after_mx, bba_before_my/ bba_after_my);
    bpmx_ok = length(bpms_bba_ok_x);
    bpmy_ok = length(bpms_bba_ok_y);
    
    if plt
       plot_stat(bba_analy, rand_stat_nobba, rand_stat_bba, n_mach)
    end
else
    bba_analy = analy(bba_data, n_mach, plt, bpms_bba, bpm_cutoff);
    bba_before = bba_analy.dif_nobba_std;
    bba_after = bba_analy.dif_bba_std;
    bba_analy.bpms_ok_x = bpms_bba_ok_x;
    bba_analy.bpms_ok_y = bpms_bba_ok_y;
    bpmx_ok = length(bpms_bba_ok_x);
    bpmy_ok = length(bpms_bba_ok_y);
    % fprintf('Machines Stat RMS Offset Before BBA X: %f um Y: %f um \n', bba_before(1),  bba_before(2));
    % fprintf('Machines Stat RMS Offset After BBA X: %f um Y: %f um \n ', bba_after(1),  bba_after(2));
    % fprintf('Machines Stat RMS Offset Reduction Factor X: %f Y: %f \n \n', bba_before(1)/bba_after(1),  bba_before(2)/bba_after(2));
end
    
end

function plot_stat(bba_analy, rand_stat_nobba, rand_stat_bba, n_mach)
    figure;
    hold all
    
    meanx_before = nanmean(rand_stat_nobba(:, 1)); stdx_before = nanstd(rand_stat_nobba(:, 1));
    meanx_after = nanmean(rand_stat_bba(:, 1)); stdx_after = nanstd(rand_stat_bba(:, 1));
    
    meany_before = nanmean(rand_stat_nobba(:, 2)); stdy_before = nanstd(rand_stat_nobba(:, 2));
    meany_after = nanmean(rand_stat_bba(:, 2)); stdy_after = nanstd(rand_stat_bba(:, 2));
    for k = 1:n_mach
        plot(abs(bba_analy{k}.dif_nobba(:, 1)), 'o--');
        plot(-abs(bba_analy{k}.dif_nobba(:, 2)), 'o--');
    end
    
    plot(abs(rand_stat_nobba(:, 1)), 'bo', 'LineWidth', 3);
    plot(repmat(abs(meanx_before), 160, 1), 'b-', 'LineWidth', 3);
    plot(repmat((meanx_before + stdx_before), 160, 1), 'b--', 'LineWidth', 3);
    plot(repmat((meanx_before - stdx_before), 160, 1), 'b--', 'LineWidth', 3);
    plot(-abs(rand_stat_nobba(:, 2)),'ro', 'LineWidth', 3);
    plot(-repmat(abs(meany_before), 160, 1), 'r-', 'LineWidth', 3);
    plot(-repmat((meany_before + stdy_before), 160, 1), 'r--', 'LineWidth', 3);
    plot(-repmat((meany_before - stdy_before), 160, 1), 'r--', 'LineWidth', 3);
    xlabel('BPM Number');
    ylabel('Diff [um]');
    grid on
    
    figure;
    hold all
    for k = 1:n_mach
        plot(abs(bba_analy{k}.dif_bba(:, 1)), 'o--');
        plot(-abs(bba_analy{k}.dif_bba(:, 2)), 'o--');
    end
    
    plot(abs(rand_stat_bba(:, 1)), 'bo', 'LineWidth', 3);
    plot(repmat(abs(meanx_after), 160, 1), 'b-', 'LineWidth', 3);
    plot(repmat((meanx_after + stdx_after), 160, 1), 'b--', 'LineWidth', 3);
    plot(repmat((meanx_after - stdx_after), 160, 1), 'b--', 'LineWidth', 3);
    plot(-abs(rand_stat_bba(:, 2)),'ro', 'LineWidth', 3);
    plot(-repmat(abs(meany_after), 160, 1), 'r-', 'LineWidth', 3);
    plot(-repmat(abs(meany_after + stdy_after), 160, 1), 'r--', 'LineWidth', 3);
    plot(-repmat(abs(meany_after - stdy_after), 160, 1), 'r--', 'LineWidth', 3);
    xlabel('BPM Number');
    ylabel('Diff [um]');
    grid on
end

function bba_analy = analy(bba_data, n_mach, plt, bpms_bba, bpm_cutoff)
        % off1 = bba_data.off_bba1; off1 = off1{n_mach}; off1(off1 == 0) = NaN;
        % off2 = bba_data.off_bba2; off2 = off2{n_mach}; off2(off2 == 0) = NaN;
        off1f = bba_data.off_bba1f; off1f = off1f{n_mach}; off1f(off1f == 0) = NaN;
        % off2f = bba_data.off_bba2f; off2f = off2f{n_mach}; off2f(off2f == 0) = NaN;
        off_bpm = bba_data.off_bpm; off_bpm = off_bpm{n_mach}; 
        off_quad = bba_data.off_quad; off_quad = off_quad{n_mach};
        um = 1e6;
        % lim = 1000e-6;
        
        n_bpm = length(off1f(:, 1));
        ind = zeros(n_bpm, 1);
        bpm_number = mod([1:1:160], 8);
        % bpms_bba = 0; % [0,1, 2, 7];
        for i = 1:n_bpm
           if ismember(bpm_number(i), bpms_bba)
               ind(i) = 1;
           end
        end
        
        %{
        mu = nanmean(off1f); sigma = nanstd(off1f);
        lower = mu - sigma/10; upper = mu + sigma/10;
        off1f(off1f < lower) = NaN; 
        off1f(off1f > upper) = NaN;
        %}
        
        % off1f(abs(off1f) > lim) = NaN;
        
        off1f([~ind, ~ind]) = NaN;
        
        off1f(bpm_cutoff:end, :) = NaN;
        
        bba_real = off_quad - off_bpm;
        bba_real(isnan(off1f)) = NaN;
        new_off_bpm = off_bpm + off1f;
        bba_analy.bba_obt = off_quad - new_off_bpm;
        % bba_obt(isnan(off1f)) = NaN;
        %{
        if plt
            figure;
            subplot(2,1,1);
            % plot(off1(:, 1) * um, 'o');
            xlabel('BPM Number')
            ylabel('X Offset [um]');
            hold on
            plot(off1f(:, 1) * um, 'o');
            % plot(off2(:, 1) * um, 'o');
            % plot(off2f(:, 1) * um, 'o');
            plot(bba_real(:, 1) * um, '-o');
            % plot(repmat(mu(1) * um, length(off1f(:, 1)), 1), 'k-');
            % plot(repmat(lower(1) * um, length(off1f(:, 1)), 1), 'r--');
            % plot(repmat(upper(1) * um, length(off1f(:, 1)), 1), 'r--');
            legend('Linear Fitting', 'Real Value');
            grid on

            subplot(2,1,2);
            % plot(off1(:, 2) * um, 'o');
            xlabel('BPM Number')
            ylabel('Y Offset [um]');
            hold on
            sirius_commis.first_turns.si.plot_bba(bba2_all, 10, true, false, [], 160); plot(off1f(:, 2) * um, 'o');
            % plot(off2(:, 2) * um, 'o');
            % plot(off2f(:, 2) * um, 'o');
            plot(bba_real(:, 2) * um, '-o');
            % plot(repmat(mu(2) * um, length(off1f(:, 2)), 1), 'k-');
            % plot(repmat(lower(2) * um, length(off1f(:, 2)), 1), 'r--');
            % plot(repmat(upper(2) * um, length(off1f(:, 2)), 1), 'r--');
            legend('Linear Fitting', 'Real Value');
            % legend('Linear Tracking', 'Linear Fitting', 'Quadratic Tracking', 'Quadratic Fitting', 'Real Value');
            grid on
        end
        %}

        % dif1 = abs(off1) - abs(bba_real);
        % dif2 = abs(off2) - abs(bba_real);
        dif1f = bba_real - off1f;
        % dif1f(isnan(dif1f)) = bba_real(isnan(dif1f));
        % dif2f = abs(off2f) - abs(bba_real);
        
        %{
        mu = nanmean(dif1f); sigma = nanstd(dif1f);
        lower = mu - sigma/20; upper = mu + sigma/20;
        dif1f(dif1f < lower) = NaN; 
        dif1f(dif1f > upper) = NaN;
        %}
        
        bba_analy.dif_nobba = bba_real * um;
        bba_analy.dif_nobba_mean = nanmean(bba_real)*um;
        bba_analy.dif_nobba_std = nanstd(bba_real)*um;
        
        % bba_analy.dif_bba = bba_obt * um;
        % bba_analy.dif_bba_mean = nanmean(bba_obt)*um;
        % bba_analy.dif_bba_std = nanstd(bba_obt)*um;
        
        bba_analy.dif_bba = dif1f * um;
        bba_analy.dif_bba_mean = nanmean(dif1f)*um;
        bba_analy.dif_bba_std = nanstd(dif1f)*um;


        % bba_analy.dif1m = nanmean(dif1) * um; bba_analy.dif1r = nanstd(dif1) * um; 
        % bba_analy.dif2m = nanmean(dif2) * um; bba_analy.dif2r = nanstd(dif2) * um;
        bba_analy.dif1fm = nanmean(dif1f) * um; bba_analy.dif1fr = nanstd(dif1f) * um;
        % bba_analy.dif2fm = nanmean(dif2f) * um; bba_analy.dif2fr = nanstd(dif2f) * um;
        %{
        if plt
            figure;
            hold off
            subplot(2,1,1);
            % plot(dif1(:, 1) * um, 'o');
            xlabel('BPM Number')
            ylabel('Diff X Offset [um]');
            hold on
            plot(dif1f(:, 1) * um, 'o');
            % plot(repmat(mu(1) * um, length(dif1f(:, 1)), 1), 'k-');
            % plot(repmat(lower(1) * um, length(dif1f(:, 1)), 1), 'r--');
            % plot(repmat(upper(1) * um, length(dif1f(:, 1)), 1), 'r--');
            % plot(dif2(:, 1) * um, 'o');
            % plot(dif2f(:, 1) * um, 'o');
            % legend('Linear Tracking', 'Linear Fitting', 'Quadratic Tracking', 'Quadratic Fitting');
            grid on

            subplot(2,1,2);
            % plot(dif1(:, 2) * um, 'o');
            xlabel('BPM Number')
            ylabel('Diff Y Offset [%]');
            hold on
            plot(dif1f(:, 2) * um, 'o');
            % plot(repmat(mu(2) * um, length(dif1f(:, 2)), 1), 'k-');
            % plot(repmat(lower(2) * um, length(dif1f(:, 2)), 1), 'r--');
            % plot(repmat(upper(2) * um, length(dif1f(:, 2)), 1), 'r--');
            % plot(dif2(:, 2) * um, 'o');
            % plot(dif2f(:, 2) * um, 'o');
            % legend('Linear Tracking', 'Linear Fitting', 'Quadratic Tracking', 'Quadratic Fitting');
            grid on
        end
%}
end


