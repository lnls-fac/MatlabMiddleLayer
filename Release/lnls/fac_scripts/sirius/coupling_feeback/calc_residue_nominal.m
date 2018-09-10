function r = calc_residue_nominal(ring, indices, sim_anneal, nominal_sigmas)

    r.coup = lnls_calc_coupling(ring);

    r.r_tilt = rms(r.coup.tilt(indices.bl_ids));
    r.r_sigmay = rms(r.coup.sigmas(2,:) - nominal_sigmas(2,:));
    r.r_coup = abs(sim_anneal.target_coupling - r.coup.emit_ratio);
    
    r.residue = r.r_tilt / sim_anneal.scale_tilt + ...
                r.r_sigmay / sim_anneal.scale_sigmay + ...
                r.r_coup / sim_anneal.scale_coup;
