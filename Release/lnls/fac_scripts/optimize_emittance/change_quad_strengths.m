function change_quad_strengths(scale_range, offset_range, r)

quad_fnames = r.parms.quad_strength.fnames;
rp = randperm(length(quad_fnames));
quad_fnames = quad_fnames(rp(1:r.parms.quad_strength.nr_fams));

for i=1:length(quad_fnames)
    fname = quad_fnames{i};
    v1 = gen_rand_vector(1, r);
    v2 = gen_rand_vector(1, r);
    scale   = scale_range(1)  + v1 * (scale_range(2)  - scale_range(1));
    offset  = offset_range(1) + v2 * (offset_range(2) - offset_range(1));
    k_orig = getpv(fname, 'Physics');
    k_new  = k_orig * scale + offset;
    setpv(fname, k_new, 'Physics');
end