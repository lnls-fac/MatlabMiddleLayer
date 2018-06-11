function ring = add_qs_in_families(ring, qs_fams, stren)
    for i=1:length(qs_fams)
        stren0 = getcellstruct(ring, 'PolynomA', qs_fams{i}, 1, 2);
        stren0 = stren0 + stren(i);
        ring = setcellstruct(ring, 'PolynomA', qs_fams{i}, stren0, 1, 2);
    end