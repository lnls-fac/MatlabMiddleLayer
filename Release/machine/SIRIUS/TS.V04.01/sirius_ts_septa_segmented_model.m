function sept_model = sirius_ts_septa_segmented_model(dip_nam, dip_len, dip_ang, strengths, nseg)

    if nseg < 2
        error('Num of segments must be >=2')
    end

    deg_2_rad = (pi/180);

    bend_pass_method = 'BndMPoleSymplectic4Pass';
    matrix_pass = 'Matrix66Pass';

    % -- bo injection septum --
    % dip_nam =  'InjSept';
    matrix_name = [dip_nam, 'M66'];
    dip_ang = dip_ang * deg_2_rad;

    polya = [0, 0, 0];
    polyb = [0, 0, 0];

    seg_len = dip_len/nseg;
    seg_ang = dip_ang/nseg;

    septine = rbend_sirius(dip_nam, seg_len, seg_ang, 1*dip_ang/2, 0*dip_ang, 0,0,0, polya, polyb, bend_pass_method);
    septins = rbend_sirius(dip_nam, seg_len, seg_ang, 0*dip_ang, 1*dip_ang/2, 0,0,0, polya, polyb, bend_pass_method);

    seg_kxl = strengths.kxl/(nseg -1);
    seg_kyl = strengths.kyl/(nseg -1);
    seg_ksxl = strengths.ksxl/(nseg -1);
    seg_ksyl = strengths.ksyl/(nseg -1);

    M = eye(6);
    M(2, 1) = -seg_kxl;
    M(4, 3) = -seg_kyl;
    M(2, 3) = -seg_ksxl;
    M(4, 1) = -seg_ksyl;

    segs = zeros(1,2*(nseg-2)+1);
    segs(1) = matrix66(matrix_name, 0, M, matrix_pass);
    for i=1:(nseg-2)
        segs(2*i) = rbend_sirius(dip_nam, seg_len, seg_ang, 0, 0, 0,0,0, polya, polyb, bend_pass_method);
        segs(2*i+1) = matrix66(matrix_name, 0, M, matrix_pass);
    end

    bseptin = marker('bInjS','IdentityPass');
    mseptin = marker('mInjS','IdentityPass');
    eseptin = marker('eInjS','IdentityPass');

    half_idx = round(length(segs)/2);
    segs = [segs(1:half_idx), mseptin, segs(half_idx+1:end)];
    sept_model = [bseptin, septine, segs, septins, eseptin]; % excluded ch to make it consistent with other codes. the corrector can be implemented in the polynomB.
