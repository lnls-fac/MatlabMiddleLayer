function [sigma_bpm, int_bpm] = bpm_error_inten(r_xy, n_part, sigma_bpm0)
% Estimative of BPM errors by the intensity of beam (resolution is a linear
% function of charge)
%
% INPUTS:
%   - r_xy: position x and y in bpms points for all pulses (dimension is
%   (2, number_of_pulses, number_of_bpms)
%   - n_part: total number of particles injected
%   - sigma_bpm0: nominal resolution of BPM
%
% OUTPUTS:
%   - sigma_bpm: charge dependent error in each BPM for each pulse
%   (dimension is the same as r_xy)
%   - int_bpm: corresponding intensity in each BPM (ratio of number of
%   particles reaching BPM and total number of particles injected)
    Rate = sirius_commis.common.calc_eff(n_part, r_xy(1, :, :));
    sigma = ( sigma_bpm0 ./ Rate )';
    sigma(isinf(sigma)) = NaN;
    cutoff = 1;
    sigma_bpm_x = lnls_generate_random_numbers(1, length(sigma), 'norm', cutoff) .* sigma;
    sigma_bpm_y = lnls_generate_random_numbers(1, length(sigma), 'norm', cutoff) .* sigma;
    sigma_bpm = [sigma_bpm_x; sigma_bpm_y];
    int_bpm = Rate;
end
