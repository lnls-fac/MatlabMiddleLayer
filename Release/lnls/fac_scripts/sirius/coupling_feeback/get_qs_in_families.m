function stren = get_qs_in_families(ring, qs_fams)
    stren = cell(1, length(qs_fams));
    for i=1:length(qs_fams)
        stren{i} = getcellstruct(ring, 'PolynomA', qs_fams{i}, 1, 2);
    end
