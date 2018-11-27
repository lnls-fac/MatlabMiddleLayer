function plot_bpms(machine, orbit, r_bpm, int_bpm)
    VChamb = cell2mat(getcellstruct(machine, 'VChamber', 1:length(machine)))';
    s_total = findspos(machine, 1:length(machine));
    bpm = findcells(machine, 'FamName', 'BPM');
    s = s_total(bpm);
    mm = 1e3;
    x = r_bpm(1, :)* mm;
    y = r_bpm(2, :)* mm;
    if ~isappdata(0, 'fig')
        fig = figure('OuterPosition', [100, 100, 800, 900]);
        ax1 = subplottight(3,1,1, 'vspace', 0.05);
        ax2 = subplottight(3,1,2, 'vspace', 0.05);
        ax3 = subplottight(3,1,3, 'vspace', 0.05);
        setappdata(0, 'fig', fig);
        setappdata(0, 'ax1', ax1);
        setappdata(0, 'ax2', ax2);
        setappdata(0, 'ax3', ax3);
    else
        fig = getappdata(0, 'fig');
        try
            get(fig, 'type');
        catch
            fig = figure('OuterPosition', [100, 100, 800, 900]);
            ax1 = subplottight(3,1,1, 'vspace', 0.05);
            ax2 = subplottight(3,1,2, 'vspace', 0.05);
            ax3 = subplottight(3,1,3, 'vspace', 0.05);
            setappdata(0, 'fig', fig);
            setappdata(0, 'ax1', ax1);
            setappdata(0, 'ax2', ax2);
            setappdata(0, 'ax3', ax3);
        end
        ax1 = getappdata(0, 'ax1');
        ax2 = getappdata(0, 'ax2');
        ax3 = getappdata(0, 'ax3');
    end
    hold(ax1, 'off');
    hold(ax2, 'off');
    hold(ax3, 'off');
    plot(ax1, s, x, '.-b', 'linewidth', 1, 'MarkerSize', 15);
    plot(ax2, s, y, '.-r', 'linewidth', 1, 'MarkerSize', 15);
    plot(ax3, s, int_bpm, '.-k', 'linewidth', 1);
    ylim(ax3, [-0.1, 1.1]);
    hold(ax1, 'on');
    hold(ax2, 'on');
    hold(ax3, 'on');
    plot(ax1, s_total, orbit(1, :) * mm, '.-k', 'linewidth', 2);
    plot(ax2, s_total, orbit(3, :) * mm, '.-k', 'linewidth', 2);
    plot(ax1, s_total, VChamb(1,:) * mm,'k');
    plot(ax1, s_total, -VChamb(1,:) * mm,'k');
    plot(ax2, s_total, VChamb(2,:) * mm,'k');
    plot(ax2, s_total, -VChamb(2,:) * mm,'k');
    ylim(ax1, [-20, 20]);
    grid(ax1, 'on');
    grid(ax2, 'on');
    grid(ax3, 'on');
    drawnow();
end
