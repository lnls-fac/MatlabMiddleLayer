function plot_respm(respm_meas, respm_theory, gain, n_corr)

figure;
plot(respm_theory(:, n_corr), '-o'); 
hold on; 
plot(respm_meas(:, n_corr), '-o');

if n_corr <= (size(respm_meas, 2) - 1)/2
    plot(respm_meas(:, n_corr) .* gain(1, 1, n_corr), '-o');
else
    plot(respm_meas(:, n_corr) .* gain(2, 2, n_corr), '-o');
end

legend('TEORIA', 'MEDIDA', 'MEDIDA CORRIGIDA');

end