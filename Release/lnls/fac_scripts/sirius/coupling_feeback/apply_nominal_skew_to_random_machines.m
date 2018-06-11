function rand_mach = apply_nominal_skew_to_random_machines(rand_mach, nominal_data)
    fprintf(['-- applying nominal skew to random machines [', datestr(now), ']\n']);
    for i=1:length(rand_mach)
        latt = rand_mach{i};
        latt = add_qs_in_families(latt, nominal_data.qs_fams, nominal_data.skew_stren);
        rand_mach{i} = latt;
    end  