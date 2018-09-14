function r_scrn3 = screen3(machine, param, n_part, n_pulse, scrn3)
    fprintf('=================================================\n');
    fprintf('SCREEN 3 ON \n')
    fprintf('=================================================\n');
    [~, r_final_pulse3, sigma_scrn3] = bo_pulses(machine, param, n_part, n_pulse, 0, scrn3, 1);
    r_scrn3 = r_final_pulse3(:, [1,3], :, scrn3);
    r_scrn3 = squeeze(nanmean(r_scrn3, 3));
    r_scrn3 = r_scrn3 + sigma_scrn3;
    r_scrn3 = squeeze(nanmean(r_scrn3, 1));
end

