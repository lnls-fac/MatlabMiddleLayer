function change_bend_Ks(scale_range, offset_range, r)

global THERING;

bend_fnames = r.parms.bend_k.fnames;


% seleciona familias q serao variadas
rp = randperm(length(bend_fnames));
bend_fnames = bend_fnames(rp(1:r.parms.bend_k.nr_fams));


for i=1:length(bend_fnames)
    fname = bend_fnames{i};
    v1 = gen_rand_vector(1, r);
    v2 = gen_rand_vector(1, r);
    scale   = scale_range(1)   + v1 * (scale_range(2)   - scale_range(1));
    offset  = offset_range(1)  + v2 * (offset_range(2)  - offset_range(1));
    ATIndex = getfamilydata(fname, 'AT', 'ATIndex');
    k_orig  = getcellstruct(THERING, 'K', ATIndex);
    k_new   = k_orig * scale + offset;
    THERING = setcellstruct(THERING, 'K', ATIndex, k_new);
    THERING = setcellstruct(THERING, 'PolynomB', ATIndex, k_new, 1, 2);
end