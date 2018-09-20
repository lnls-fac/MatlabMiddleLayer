function sigma_scrn = scrn_error_inten(r_xy, n_part, scrn, sigma_scrn0)
    Rate = calc_eff(n_part, r_xy(1, :, scrn));
    if Rate == 0;
        sigma_scrn = [NaN, NaN];
        return;
    end
    sigma = sigma_scrn0 / Rate;
    sigma_scrn_x = lnls_generate_random_numbers(1, 1, 'norm') * sigma;
    sigma_scrn_y = lnls_generate_random_numbers(1, 1, 'norm') * sigma;
    sigma_scrn = [sigma_scrn_x, sigma_scrn_y];
end