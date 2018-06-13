function ps = update_nominal_plots(coup, indices, nominal_sigmas, ps)

    maxsigmay = max(nominal_sigmas(2,:));
    b2 = indices.b2;
    mic = indices.mic;
    bl_ids = indices.bl_ids;
    pos = indices.pos;
    if ~exist('ps','var')
        figure; hold all;
        p1{1} = plot(pos, 1e6*coup.sigmas(2,:), 'Color', [0.8, 0.8, 1]);
        p1{2} = scatter(pos(b2), 1e6*nominal_sigmas(2, b2), 52, [0,0,1], 'filled');
        p1{3} = scatter(pos(b2), 1e6*coup.sigmas(2, b2), 50, [0.5,0.5,1], 'filled');
        ax = get(p1{3},'Parent');
        ylim(ax, [0,1e6*1.2*maxsigmay]);
        xlim(ax, [0, pos(end)]);
        ylabel(ax, 'sigmay [um]'); 
        figure;
        hold all;
        p2{1} = plot(pos, (180/pi)*coup.tilt, 'Color', [1, 0.8, 0.8]);
        p2{2} = scatter(pos(mic), (180/pi)*coup.tilt(mic), 50, [1,0.5,0.5], 'filled');
        p2{3} = scatter(pos(bl_ids), (180/pi)*coup.tilt(bl_ids), 50, [1,0,0], 'filled');
        ax = get(p2{3},'Parent');
        xlim(ax, [0, pos(end)]);
        ylim(ax, [-45,45]);
        ylabel(ax, 'tilt angle [degree]'); 
        ps = {p1, p2};
    else
        p1 = ps{1};
        p2 = ps{2};
        set(p1{1}, 'YData', 1e6*coup.sigmas(2,:)); 
        set(p1{2}, 'YData', 1e6*nominal_sigmas(2, b2)); 
        set(p1{3}, 'YData', 1e6*coup.sigmas(2, b2));
        ax = get(p1{3},'Parent');
        ylim(ax, [0,1e6*1.2*maxsigmay]);
        set(p2{1}, 'YData', (180/pi)*coup.tilt); 
        set(p2{2}, 'YData', (180/pi)*coup.tilt(mic)); 
        set(p2{3}, 'YData', (180/pi)*coup.tilt(bl_ids)); 
        ax = get(p2{3},'Parent');
        ylim(ax, [-45,45]);
    end
    drawnow;
