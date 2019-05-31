function plot_kicks(machine1, machine2, machine3, fam, n_mach)

urad = 1e6;
s = findspos(machine1{1}, 1:length(machine1{1}));
s_ch = s(fam.CH.ATIndex);
s_cv = s(fam.CV.ATIndex);

    for i = 1:n_mach
       kickx1(i, :) = lnls_get_kickangle(machine1{i}, fam.CH.ATIndex, 'x') * urad;
       kicky1(i, :) = lnls_get_kickangle(machine1{i}, fam.CV.ATIndex, 'y') * urad;
       kickx2(i, :) = lnls_get_kickangle(machine2{i}, fam.CH.ATIndex, 'x') * urad;
       kicky2(i, :) = lnls_get_kickangle(machine2{i}, fam.CV.ATIndex, 'y') * urad;
       kickx3(i, :) = lnls_get_kickangle(machine3{i}, fam.CH.ATIndex, 'x') * urad;
       kicky3(i, :) = lnls_get_kickangle(machine3{i}, fam.CV.ATIndex, 'y') * urad;
    end
    
    kickx_rms1 = squeeze(nanstd(kickx1, 1));
    kicky_rms1 = squeeze(nanstd(kicky1, 1));
    kickx_rms2 = squeeze(nanstd(kickx2, 1));
    kicky_rms2 = squeeze(nanstd(kicky2, 1));
    kickx_rms3 = squeeze(nanstd(kickx3, 1));
    kicky_rms3 = squeeze(nanstd(kicky3, 1));
    
    figure;
    hold all;
    
    % for i = 1:n_mach
    %     plot(abs(kickx1(i, :)), '--', 'Color', [0, 0, 1], 'LineWidth', 1)
    %     plot(-abs(kicky1(i, :)), '--', 'Color', [1, 0, 0], 'LineWidth', 1)
    % end
    
    plot(s_ch, abs(kickx_rms1),'-o', 'MarkerSize', 15, 'Color', [0, 0, 1], 'LineWidth', 1)
    plot(s_cv, -abs(kicky_rms1), '-o', 'MarkerSize', 15, 'Color', [1, 0, 0], 'LineWidth', 1)
    plot(s_ch, abs(kickx_rms2), '-^', 'MarkerSize', 15, 'Color', [0, 0, 1], 'LineWidth', 1)
    plot(s_cv, -abs(kicky_rms2), '-^', 'MarkerSize', 15, 'Color', [1, 0, 0], 'LineWidth', 1)
    plot(s_ch, abs(kickx_rms3), '-*', 'MarkerSize', 15, 'Color', [0, 0, 1], 'LineWidth', 1)
    plot(s_cv, -abs(kicky_rms3), '-*', 'MarkerSize', 15, 'Color', [1, 0, 0], 'LineWidth', 1)
    
    grid on;
    
    xlabel('s [m]');
    ylabel('Corrector Kick [urad]');
    legend('FTx','FTy', 'MTx', 'MTy', 'COx', 'COy');
    
end