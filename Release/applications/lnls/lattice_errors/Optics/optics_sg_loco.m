function [the_ring, quadstr, init_fm,best_fm, iter, n_times] = optics_sg_loco(the_ring, optics, goal)

% assumes uniform quadrupolar field in quadrupole models

tol = abs(optics.tolerance);

quad_lst = optics.kbs_idx(:);

U = optics.respm.U;
V = optics.respm.V;
S = optics.respm.S;

if ischar(optics.svs) && strcmpi(optics.svs, 'all')
    sing_vals = min(size(S));
else
    sing_vals = optics.svs;
end

% selection of singular values
iS = diag(1./diag(S)); diS = diag(iS); diS(sing_vals+1:end) = 0; iS = diag(diS);
CM = -(V*iS*U');
n_flag = false;

best_optvec = calc_residue_optics_loco(the_ring, optics, goal);
best_quad    = the_ring(quad_lst);
best_fm = sqrt(sumsqr(best_optvec));
init_fm = best_fm;
init_kicks = getcellstruct(the_ring, 'PolynomB', quad_lst, 1, 2);
factor = 1;
n_times = 0;
for iter = 1:optics.max_nr_iter
    % calcs kicks
    if n_flag
        delta_kicks = factor* CMn * best_optvec;
    else
        delta_kicks = factor* CM * best_optvec;
    end
    delta_kicks = repmat(delta_kicks,size(optics.kbs_idx,2),1);
    % sets kicks
    tota_kicks = getcellstruct(the_ring, 'PolynomB', quad_lst, 1, 2);
    tota_kicks = tota_kicks + delta_kicks;
    the_ring   = setcellstruct(the_ring, 'PolynomB', quad_lst, tota_kicks, 1, 2);

    opt_vec = calc_residue_optics_loco(the_ring, optics, goal);
    fm = sqrt(sumsqr(opt_vec));
    residue = abs(best_fm-fm)/best_fm;
    if (fm < best_fm)
        n_flag = false;
        best_fm      = fm;
        best_quad    = the_ring(quad_lst);
        factor = 1; % reset the correction strength to 1
        best_optvec  = opt_vec;
    else
        the_ring(quad_lst) = best_quad;
        factor = factor * 0.5; % reduces the strength of the correction
        n_times = n_times + 1; % to check how many times it passed here;
        if factor < 0.05
            if n_flag
                break;
            end
            respm = calc_respm_optics_loco(the_ring, optics, goal);
            Un = respm.U;
            Vn = respm.V;
            Sn = respm.S;
            iSn = diag(1./diag(Sn)); diSn = diag(iSn); diSn(sing_vals+1:end) = 0; iSn = diag(diSn);
            CMn = -(Vn*iSn*Un');
            factor = 1;
            n_flag = true;
        end
    end
    % breaks the loop in case convergence is reached
    if residue < tol
        break;
    end
end
quadstr = getcellstruct(the_ring, 'PolynomB', quad_lst, 1, 2);
quadstr = (quadstr-init_kicks).*getcellstruct(the_ring, 'Length', quad_lst);
quadstr = sum(reshape(quadstr, size(optics.kbs_idx,1), []), 2)';
