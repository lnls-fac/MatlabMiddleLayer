function change_drift_lengths(scale_range, offset_range, r)

global THERING

fnames = fieldnames(r.parms.drift_length.fnames);
rp = randperm(length(fnames));
fnames = fnames(rp(1:r.parms.drift_length.nr_fams));

for i=1:length(fnames)
    v1 = gen_rand_vector(1, r);
    v2 = gen_rand_vector(1, r);
    scale   = scale_range(1)  + v1 * (scale_range(2)  - scale_range(1));
    offset  = offset_range(1) + v2 * (offset_range(2) - offset_range(1));
    lengths_orig = getcellstruct(THERING, 'Length', r.parms.drift_length.fnames.(fnames{i}));
    lengths_new  = lengths_orig .* scale + offset;
    invalid_idx = (lengths_new <= 0);
    lengths_new(invalid_idx) = lengths_orig(invalid_idx); % avoid negative drifts
    THERING = setcellstruct(THERING, 'Length', r.parms.drift_length.fnames.(fnames{i}), lengths_new);
end