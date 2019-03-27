function respm_meas_corr = correct_meas_respm(respm_meas, corr_gain)
n_ch = (size(respm_meas, 2) - 1)/2;
n_cv = (size(respm_meas, 2) - 1) - n_ch;
respm_meas_corr = respm_meas;

    for i=1:n_ch+n_cv
       if i <= n_ch
          respm_meas_corr(:, i) = respm_meas(:, i) .* corr_gain(1, 1, i);
       else
          respm_meas_corr(:, i) = respm_meas(:, i) .* corr_gain(2, 2, i);
       end
    end
end