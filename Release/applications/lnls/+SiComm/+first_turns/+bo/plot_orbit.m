function plot_orbit(orbit1, orbit2, fam, n_mach)

mm = 1e3;

    for i = 1:n_mach
       orbit_1i(i, :, :) = orbit1{i} .* mm;
       orbit_2i(i, :, :) = orbit2{i} .* mm;
       % orbit_3i(i, :, :) = orbit3{i} .* mm;
    end
    
    orbitx_rms1 = squeeze(nanstd(orbit_1i(:, 1, :), 1));
    orbity_rms1 = squeeze(nanstd(orbit_1i(:, 3, :), 1));
    orbitx_rms2 = squeeze(nanstd(orbit_2i(:, 1, :), 1));
    orbity_rms2 = squeeze(nanstd(orbit_2i(:, 3, :), 1));
    % orbitx_rms3 = squeeze(nanstd(orbit_3i(:, 1, :), 1));
    % orbity_rms3 = squeeze(nanstd(orbit_3i(:, 3, :), 1));
    
    figure;
    hold all;
    
    % for i = 1:n_mach
    %     plot(abs(kickx1(i, :)), '--', 'Color', [0, 0, 1], 'LineWidth', 1)
    %     plot(-abs(kicky1(i, :)), '--', 'Color', [1, 0, 0], 'LineWidth', 1)
    % end
    % trecho = 1:fam.BPM.ATIndex(2)+1;
    trecho = 1:1897;
    plot(abs(orbitx_rms1(trecho)),'-', 'Color', [0, 0, 1], 'LineWidth', 1)
    plot(-abs(orbity_rms1(trecho)), '-', 'Color', [1, 0, 0], 'LineWidth', 1)
    plot(abs(orbitx_rms2(trecho)), '--', 'Color', [0, 0, 1], 'LineWidth', 1)
    plot(-abs(orbity_rms2(trecho)), '--', 'Color', [1, 0, 0], 'LineWidth', 1)
    % plot(abs(orbitx_rms3(trecho)), '-.', 'Color', [0, 0, 1], 'LineWidth', 1)
    % plot(-abs(orbity_rms3(trecho)), '-.', 'Color', [1, 0, 0], 'LineWidth', 1)
    
    grid on;
    
    xlabel('Corrector');
    ylabel('COD [mm]');
    legend('FTx','FTy', 'MTx', 'MTy', 'COx', 'COy');
    
end