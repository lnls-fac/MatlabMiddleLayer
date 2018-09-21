function plot_booster_turn(machine, r_final, points, n_part, sigma_bpm)
    VChamb = cell2mat(getcellstruct(machine, 'VChamber', 1:length(machine)))';
    s_total = findspos(machine, 1:length(machine));
    bpm = findcells(machine, 'FamName', 'BPM');
    
    if length(points) == length(bpm);
        s = s_total(points);
        sigma_bpm = bpm_error_inten(r_final, n_part, sigma_bpm);
        x = squeeze(nanmean(r_final(1, :, :), 2));
        x = x' + sigma_bpm(1, :);
        y = squeeze(nanmean(r_final(2, :, :), 2));
        y = y' + sigma_bpm(2, :);
        gcf();
        ax = gca();
        hold off;
        plot(ax, s, x, '.-r', 'linewidth', 1);
        hold all
        plot(ax, s_total, VChamb(1,:),'k');
        plot(ax, s_total, -VChamb(1,:),'k');
        drawnow;
    elseif points == length(machine)
        s = s_total;  
        xx = squeeze(nanmean(r_final(1, :, :), 2));
        sxx = squeeze(nanstd(r_final(1, :, :), 0, 2));
        gcf();
        ax = gca();
        hold off;
        plot(ax, s, (xx+3*sxx)', 'b --');
        hold all;
        plot(ax, s, (xx-3*sxx)', 'b --');
        plot(ax, s, (xx)', '.-r', 'linewidth', 3);
        plot(ax, s_total, VChamb(1,:),'k');
        plot(ax, s_total, -VChamb(1,:),'k');
        drawnow;
    end
end