function plot_bpms(machine, orbit, r_bpm, int_bpm)
    VChamb = cell2mat(getcellstruct(machine, 'VChamber', 1:length(machine)))';
    s_total = findspos(machine, 1:length(machine));
    bpm = findcells(machine, 'FamName', 'BPM');
    s = s_total(bpm);
    mm = 1e3;
    x = r_bpm(1, :)* mm;
    y = r_bpm(2, :)* mm;
    if ~isappdata(0, 'figBPM')
        figBPM = figure('OuterPosition', [100, 100, 800, 900]);
        ax1BPM = subplottight(3,1,1, 'vspace', 0.05);
        ax2BPM = subplottight(3,1,2, 'vspace', 0.05);
        ax3BPM = subplottight(3,1,3, 'vspace', 0.05);
        setappdata(0, 'figBPM', figBPM);
        setappdata(0, 'ax1BPM', ax1BPM);
        setappdata(0, 'ax2BPM', ax2BPM);
        setappdata(0, 'ax3BPM', ax3BPM);
    else
        figBPM = getappdata(0, 'figBPM');
        try
            get(figBPM, 'type');
        catch
            figBPM = figure('OuterPosition', [100, 100, 800, 900]);
            ax1BPM = subplottight(3,1,1, 'vspace', 0.05);
            ax2BPM = subplottight(3,1,2, 'vspace', 0.05);
            ax3BPM = subplottight(3,1,3, 'vspace', 0.05);
            setappdata(0, 'figBPM', figBPM);
            setappdata(0, 'ax1BPM', ax1BPM);
            setappdata(0, 'ax2BPM', ax2BPM);
            setappdata(0, 'ax3BPM', ax3BPM);
        end
        ax1BPM = getappdata(0, 'ax1BPM');
        ax2BPM = getappdata(0, 'ax2BPM');
        ax3BPM = getappdata(0, 'ax3BPM');
    end
    hold(ax1BPM, 'off');
    hold(ax2BPM, 'off');
    hold(ax3BPM, 'off');
    plot(ax1BPM, s, x, '.-b', 'linewidth', 1, 'MarkerSize', 15);
    plot(ax2BPM, s, y, '.-r', 'linewidth', 1, 'MarkerSize', 15);
    plot(ax3BPM, s, int_bpm, '.-k', 'linewidth', 1);
    ylim(ax3BPM, [-0.1, 1.1]);
    hold(ax1BPM, 'on');
    hold(ax2BPM, 'on');
    hold(ax3BPM, 'on');
    plot(ax1BPM, s_total, orbit(1, :) * mm, '.-k', 'linewidth', 2);
    plot(ax2BPM, s_total, orbit(3, :) * mm, '.-k', 'linewidth', 2);
    plot(ax1BPM, s_total, VChamb(1,:) * mm,'k');
    plot(ax1BPM, s_total, -VChamb(1,:) * mm,'k');
    plot(ax2BPM, s_total, VChamb(2,:) * mm,'k');
    plot(ax2BPM, s_total, -VChamb(2,:) * mm,'k');
    ylim(ax1BPM, [-15, 15]);
    xlim(ax1BPM, [0, s_total(end)*1.1]);
    xlim(ax2BPM, [0, s_total(end)*1.1]);
    xlim(ax3BPM, [0, s_total(end)*1.1]);
    grid(ax1BPM, 'on');
    grid(ax2BPM, 'on');
    grid(ax3BPM, 'on');
    drawnow();
end
