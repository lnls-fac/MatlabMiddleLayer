function sigma_bpm = bpm_error_inten(r_xy, n_part, sigma_bpm0)           
    Rate = calc_eff(n_part, r_xy(1, :, :));
    sigma = ( sigma_bpm0 ./ Rate )';
    sigma_bpm_x = lnls_generate_random_numbers(1, length(sigma), 'norm') .* sigma;   
    sigma_bpm_y = lnls_generate_random_numbers(1, length(sigma), 'norm') .* sigma;
    sigma_bpm = [sigma_bpm_x; sigma_bpm_y];
end