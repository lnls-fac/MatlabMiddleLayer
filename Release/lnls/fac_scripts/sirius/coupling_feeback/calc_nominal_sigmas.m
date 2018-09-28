function ref_sig = calc_nominal_sigmas(ring, emit_ratio)
    tw = calctwiss(ring, 'N+1');
    tw.gammax = (1 + tw.alphax.^2) ./ tw.betax;
    tw.gammay = (1 + tw.alphay.^2) ./ tw.betay;
    as = atsummary(ring);
    ex = as.naturalEmittance / (1 + emit_ratio);
    ey = as.naturalEmittance / (1 + emit_ratio) * emit_ratio;
    spread = as.naturalEnergySpread;
    ref_sig(1,:) = sqrt(ex * tw.betax + (spread * tw.etax).^2);
    ref_sig(2,:) = sqrt(ey * tw.betay + (spread * tw.etay).^2);