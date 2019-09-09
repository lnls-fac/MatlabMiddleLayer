function sigma_scrn = screen_error_inten(r_xy, n_part, scrn, sigma_scrn0)
% Estimative of screen errors by the intensity of beam (resolution is a linear
% function of charge)
%
% INPUTS:
%   - r_xy: position x and y in bpms points for all pulses (dimension is
%   (2, number_of_pulses, number_of_bpms)
%   - n_part: total number of particles injected
%   - scrn: screen position
%   - sigma_scrn0: screen nominal resolution
%
% OUTPUTS:
%   - sigma_scrn: charge dependent error in the choosen screen for each pulse
%   (dimension is the same as r_xy)

    Rate = sirius_commis.common.calc_eff(n_part, r_xy(1, :, scrn));
    if Rate == 0
        sigma_scrn = [NaN, NaN];
        return;
    end
    sigma = sigma_scrn0 / Rate;
    sigma_scrn_x = lnls_generate_random_numbers(1, 1, 'norm') * sigma;
    sigma_scrn_y = lnls_generate_random_numbers(1, 1, 'norm') * sigma;
    sigma_scrn = [sigma_scrn_x, sigma_scrn_y];
end