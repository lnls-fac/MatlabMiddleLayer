function show_summary_nominal(ring, indices, sim_anneal)
    
    ref_sig = calc_nominal_sigmas(ring, sim_anneal.target_coupling);
    
    r1 = calc_residue_nominal(ring, indices, sim_anneal, ref_sig);
    fprintf('\n%s\n\n', strjust(sprintf('%87s', 'Summary of nominal ring'), 'center'));
    fprintf('Residue: %12.5f  |', r1.residue); 
    fprintf(' Angle: %7.3f [deg] |', (180/pi)*r1.r_tilt); 
    fprintf(' Sigmay: %7.3f [um] |', 1e6*r1.r_sigmay); 
    fprintf(' ex/ey: %7.3f %%\n\n', 100*r1.r_coup); 
    
    update_nominal_plots(r1.coup, indices, ref_sig);