function eff = calc_eff(n_part, r_init)
n_perdida = squeeze(n_part - size(r_init, 2) + sum(isnan(r_init(1, :, :))));
eff = (1 - n_perdida / n_part);
end

