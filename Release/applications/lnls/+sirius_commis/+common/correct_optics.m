function the_ring = correct_optics(the_ring0, tunex, tuney)

% see 'set_magnets_strength_booster.m' file with strength values.
% goal_tunes = [19.20433, 7.31417];
goal_tunes = [tunex, tuney];
goal_chrom = [0.5, 0.5];
the_ring = the_ring0;
idx_qf = findcells(the_ring, 'FamName', 'QF');
idx_qd = findcells(the_ring, 'FamName', 'QD');
idx_sf = findcells(the_ring, 'FamName', 'SF');
idx_sd = findcells(the_ring, 'FamName', 'SD');
the_ring = setcellstruct(the_ring, 'PolynomB', idx_qf, +1.65374903807441, 1, 2);
the_ring = setcellstruct(the_ring, 'PolynomB', idx_qd, -0.10250366405148, 1, 2);
the_ring = setcellstruct(the_ring, 'PolynomB', idx_sf, +11.25394814115368, 1, 3);
the_ring = setcellstruct(the_ring, 'PolynomB', idx_sd, +11.09496614284700, 1, 3);
ats = atsummary(the_ring);
if any(abs(ats.tunes - goal_tunes) > 0.00001) || any(abs(ats.chromaticity - goal_chrom) > 0.05)
    for i=1:8
        the_ring = fitchrom2(the_ring, goal_chrom, 'SD', 'SF');
        [the_ring, conv, t2, t1] = lnls_correct_tunes(the_ring, goal_tunes, {'QF','QD'}, 'svd', 'add', 10, 1e-9);
    end
    fprintf('   Tunes and Chromaticities corrected!\n');
    fprintf('   qf_strength = %+.14f;\n', the_ring{idx_qf(1)}.PolynomB(2));
    fprintf('   qd_strength = %+.14f;\n', the_ring{idx_qd(1)}.PolynomB(2));
    fprintf('   sf_strength = %+.14f;\n', the_ring{idx_sf(1)}.PolynomB(3));
    fprintf('   sd_strength = %+.14f;\n', the_ring{idx_sd(1)}.PolynomB(3));
end