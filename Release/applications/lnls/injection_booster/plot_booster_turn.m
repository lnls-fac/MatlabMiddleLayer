function plot_booster_turn(machine, r_final, points)
    [~, VChamb] = compares_vchamb(machine, r_final, points);
    s = findspos(machine, points);
    xx = squeeze(nanmean(r_final(1, :, points), 2));
    sxx = squeeze(nanstd(r_final(1, :, points), 0, 2));
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
    drawnow; 
end

