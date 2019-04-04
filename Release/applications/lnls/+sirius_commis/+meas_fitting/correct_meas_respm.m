function respm_meas_corr = correct_meas_respm(respm_meas, corr_gain, bpm_gain)
n_bpm = size(respm_meas, 1)/2; 
n_ch = (size(respm_meas, 2) - 1)/2;
n_cv = (size(respm_meas, 2) - 1) - n_ch;
respm_meas_corr = respm_meas;

    if ~isempty(corr_gain)
        for i=1:n_ch+n_cv
            if i <= n_ch
                respm_meas_corr(:, i) = respm_meas(:, i) .* corr_gain(1, 1, i);
            else
                respm_meas_corr(:, i) = respm_meas(:, i) .* corr_gain(2, 2, i);
            end
        end
    end
    
    if ~isempty(bpm_gain)
        for i=1:2*n_bpm
            if i <= n_bpm
                respm_meas_corr(i, :) = respm_meas_corr(i, :) .* bpm_gain(1, 1, i);
            else
                respm_meas_corr(i, :) = respm_meas_corr(i, :) .* bpm_gain(2, 2, i-n_bpm); 
            end
        end
    end
end