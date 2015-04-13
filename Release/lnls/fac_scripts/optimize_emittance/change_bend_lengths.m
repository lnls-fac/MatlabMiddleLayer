function change_bend_lengths(scale_range, offset_range, r)

global THERING;

bend_fnames = r.parms.bend_length.fnames;


% seleciona familias q serao variadas
rp = randperm(length(bend_fnames));
bend_fnames = bend_fnames(rp(1:r.parms.bend_length.nr_fams));


for i=1:length(bend_fnames)
    fname = bend_fnames{i};
    v1 = gen_rand_vector(1, r);
    v2 = gen_rand_vector(1, r);
    scale   = scale_range(1)   + v1 * (scale_range(2)   - scale_range(1));
    offset  = offset_range(1)  + v2 * (offset_range(2)  - offset_range(1));
    ATIndex = getfamilydata(fname, 'AT', 'ATIndex');
    len_orig  = getcellstruct(THERING, 'Length', ATIndex);
    len_new   = len_orig * scale + offset;
    THERING = setcellstruct(THERING, 'Length', ATIndex, len_new);
end