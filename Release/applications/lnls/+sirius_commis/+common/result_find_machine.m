function result_find_machine(respm_init, respm_final, respm_goal, ring_init, ring_final)

n_ch_cv = size(respm_init, 2) - 1;
n_bpm = size(respm_init, 1) / 2;
dif_init = zeros(n_ch_cv, 1);
dif_final = zeros(n_ch_cv, 1);

for c1 = 1:n_ch_cv
    for i = 1:2*n_bpm
        dif_init(c1) = dif_init(c1) + (respm_init(i, c1) - respm_goal(i, c1))^2;
        dif_final(c1) = dif_final(c1) + (respm_final(i, c1) - respm_goal(i, c1))^2;
    end
end

v_init_m = nanmean(dif_init);
v_final_m = nanmean(dif_final);

v_init_r = nanstd(dif_init) / std2(respm_init);
v_final_r = nanstd(dif_final) / std2(respm_final);

twiss_init = calctwiss(ring_init);
twiss_final = calctwiss(ring_final);

tunex_init = twiss_init.mux(end)/2/pi;
tuney_init = twiss_init.muy(end)/2/pi;
tunex_final = twiss_final.mux(end)/2/pi;
tuney_final = twiss_final.muy(end)/2/pi;


idx_qf = findcells(ring_init, 'FamName', 'QF');
idx_qd = findcells(ring_init, 'FamName', 'QD');
k_qf_init = getcellstruct(ring_init, 'PolynomB', idx_qf(1), 1, 2);
k_qd_init = getcellstruct(ring_init, 'PolynomB', idx_qd(1), 1, 2);
k_qf_final = getcellstruct(ring_final, 'PolynomB', idx_qf(1), 1, 2);
k_qd_final = getcellstruct(ring_final, 'PolynomB', idx_qd(1), 1, 2);
L_qf = 2 * getcellstruct(ring_init, 'Length', idx_qf(1));
L_qd = getcellstruct(ring_init, 'Length', idx_qf(1));
kl_qf_init = k_qf_init * L_qf;
kl_qf_final = k_qf_final * L_qf;
kl_qd_init = k_qd_init * L_qd;
kl_qd_final = k_qd_final * L_qd;

format long

fprintf('Initial Diff RMS: %f  \n', v_init_r)
fprintf('Final Diff RMS: %f \n', v_final_r)
fprintf('Reduction factor: %f \n', v_init_r/v_final_r)

fprintf('Change in KL_QF: %f --->>> %f (%1.1f %%) \n', kl_qf_init, kl_qf_final, calc_percent(kl_qf_final, kl_qf_init))
fprintf('Change in KL_QD: %f --->>> %f (%1.1f %%) \n', kl_qd_init, kl_qd_final, calc_percent(kl_qd_final, kl_qd_init))

fprintf('Change in Tune x: %f --->>> %f (%1.1f %%) \n', tunex_init, tunex_final, calc_percent(tunex_init, tunex_final))
fprintf('Change Tune y: %f --->>> %f (%1.1f %%) \n', tuney_init, tuney_final, calc_percent(tuney_init, tuney_final))

end

function p = calc_percent(a, b)
p = 100 * (abs(a -b) / max(abs(a), abs(b)));
end
