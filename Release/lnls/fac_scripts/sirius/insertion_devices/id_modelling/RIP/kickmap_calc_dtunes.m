function ebeam_dtune = kickmap_calc_dtunes(id_def, kickmaps, ebeam_def)

mm_2_m = 1e-3;

posx = kickmaps.posx;
posy = kickmaps.posy;

[eb_beta eb_gamma eb_brho] = lnls_beta_gamma(ebeam_def.ebeam_energy);

[dkickx_dx dkickx_dy] = kickmap_calc_derivatives(kickmaps.kickx, mm_2_m * posx, mm_2_m * posy);
[dkicky_dx dkicky_dy] = kickmap_calc_derivatives(kickmaps.kicky, mm_2_m * posx, mm_2_m * posy);
KxL = -dkickx_dx / eb_brho^2;
KyL = -dkicky_dy / eb_brho^2;
id_length = id_def.period * id_def.nr_periods / 1000; % mm -> m
op_betax = ebeam_def.betax;
op_betay = ebeam_def.betay;
dmux = KxL * op_betax * (1 + id_length^2/12/op_betax^2) / 4 / pi;
dmuy = KyL * op_betay * (1 + id_length^2/12/op_betay^2) / 4 / pi;

ebeam_dtune.KxL = KxL;
ebeam_dtune.KyL = KyL;
ebeam_dtune.dmux = dmux;
ebeam_dtune.dmuy = dmuy;