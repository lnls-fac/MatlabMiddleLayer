function show_summary_machines(rand_mach, indices, plot_label)
    f1 = figure;  % tilt angle
    ax1 = axes(f1);
    hold(ax1, 'all');
    grid(ax1, 'on');
    box(ax1, 'on');
    xlim(ax1, [0, indices.pos(end)]);
    xlabel(ax1, 'pos [m]');
    ylabel(ax1, 'angle [deg.]');
    title(ax1, plot_label);
    f2 = figure;  % sigmay
    ax2 = axes(f2);
    hold(ax2, 'all');
    grid(ax2, 'on');
    box(ax2, 'on');
    xlim(ax2, [0, indices.pos(end)]);
    xlabel(ax2, 'pos [m]');
    ylabel(ax2, 'sigmay [um]');
    title(ax2, plot_label);
    drawnow;
    
    bl_all = indices.bl_all;
    for i=1:length(rand_mach)
        coup = calc_coupling(rand_mach{i});
        fprintf('   mach = %02i; ex/ey = %5.2f \n', i, coup.emit_ratio*100);
        plot(ax1, indices.pos, (180/pi)*coup.tilt, 'Color', [1.0,0.6,0.6]);
        scatter(ax1, ...
            indices.pos(bl_all),...
            (180/pi)*coup.tilt(bl_all), ...
            50, [1.0,0.4,0.4], 'filled');
        
        plot(ax2, indices.pos, 1e6*coup.sigmas(2,:), 'Color', [0.6,0.6,1.0]);
        scatter(ax2, ...
            indices.pos(bl_all),...
            1e6*coup.sigmas(2, bl_all),...
            50, [0.4,0.4,1], 'filled');
        drawnow;
    end
    fprintf('\n\n');

