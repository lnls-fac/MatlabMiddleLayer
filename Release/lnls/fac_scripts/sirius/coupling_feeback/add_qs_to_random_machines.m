function rand_mach = add_qs_to_random_machines(rand_mach, idx, quad_stren)
    fprintf(['-- Applying Feedback correction to random machines [', datestr(now), ']\n']);

    for i=1:length(rand_mach)
        qs0 = getcellstruct(rand_mach{i}, 'PolynomA', idx, 1, 2);
        qs = qs0 + quad_stren(i,:)';
        rand_mach{i} = setcellstruct(rand_mach{i}, 'PolynomA', idx, qs, 1, 2);
    end