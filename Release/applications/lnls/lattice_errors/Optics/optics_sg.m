function [the_ring, quadstr, init_fm,best_fm, iter, n_times] = optics_sg(the_ring, optics)

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
iS = diag(1./diag(S));
diS = diag(iS);
diS(sing_vals+1:end) = 0;
iS = diag(diS);
CM = -(V*iS*U');

best_optvec = calc_residue_for_optimization(the_ring, optics);
best_quad    = the_ring(quad_lst);
best_fm = sqrt(sumsqr(best_optvec));
init_fm = best_fm;
init_kicks = getcellstruct(the_ring, 'PolynomB', quad_lst, 1, 2);
factor = 1;
n_times = 0;
for iter = 1:optics.max_nr_iter
    % calcs kicks
    delta_kicks = factor*CM * best_optvec;
    delta_kicks = repmat(delta_kicks,size(optics.kbs_idx,2),1);
    % sets kicks
    tota_kicks = getcellstruct(the_ring, 'PolynomB', quad_lst, 1, 2);
    tota_kicks = tota_kicks + delta_kicks;
    the_ring   = setcellstruct(the_ring, 'PolynomB', quad_lst, tota_kicks, 1, 2);

    opt_vec = calc_residue_for_optimization(the_ring, optics);
    fm = sqrt(sumsqr(opt_vec));
    residue = abs(best_fm-fm)/best_fm;
    if (fm < best_fm)
        best_fm      = fm;
        best_quad    = the_ring(quad_lst);
        factor = 1; % reset the correction strength to 1
        best_optvec  = opt_vec;
    else
        the_ring(quad_lst) = best_quad;
        factor = factor * 0.75; % reduces the strength of the correction
        n_times = n_times + 1; % to check how many times it passed here;
    end
    % breaks the loop in case convergence is reached
    if residue < tol
        break;
    end
end
quadstr = getcellstruct(the_ring, 'PolynomB', quad_lst, 1, 2);
quadstr = (quadstr-init_kicks).*getcellstruct(the_ring, 'Length', quad_lst);
quadstr = sum(reshape(quadstr, size(optics.kbs_idx,1), []), 2)';



function residue = calc_residue_for_optimization(the_ring, optics)

bpms = optics.bpm_idx;
hcms = optics.hcm_idx;
vcms = optics.vcm_idx;
tune0 = optics.tune_goal;

Tsym = findcells(the_ring,'FamName','mia');
Msym = sort([Tsym, findcells(the_ring,'FamName','mib')]);
Msym = Msym(1:end/2);

[M, Disp, tune] = get_matrix_disp(the_ring, bpms, hcms, vcms);
[Mxx, ~, ~, Myy, Dispx, ~] = prepare_data_for_symm(the_ring, optics, M, Disp);
residue = calc_residue_optics(Mxx, Myy, Dispx, tune, tune0, bpms, hcms, vcms, Tsym, Msym);
