function [the_ring, skewstr, init_fm,best_fm, iter, n_times] = coup_sg(the_ring, coup)

tol = abs(coup.tolerance);

skew_lst = coup.scm_idx(:);

U = coup.respm.U;
V = coup.respm.V;
S = coup.respm.S;

if ischar(coup.svs) && strcmpi(coup.svs, 'all')
    sing_vals = min(size(S));
else
    sing_vals = coup.svs;
end

% selection of singular values
iS = diag(1./diag(S));
diS = diag(iS);
diS(sing_vals+1:end) = 0;
iS = diag(diS);
CM = -(V*iS*U');

best_coupvec = calc_residue_for_optimization(the_ring, coup);
best_skew    = the_ring(skew_lst);
best_fm = sqrt(lnls_meansqr(best_coupvec));
init_fm = best_fm;
factor = 1;
n_times = 0;
for iter = 1:coup.max_nr_iter
    % calcs kicks
    delta_kicks = factor*CM * best_coupvec;
    delta_kicks = repmat(delta_kicks,size(coup.scm_idx,2),1);
    
    % sets kicks
    init_kicks = getcellstruct(the_ring, 'PolynomA', skew_lst, 1, 2);
    tota_kicks = init_kicks + delta_kicks;
    the_ring   = setcellstruct(the_ring, 'PolynomA', skew_lst, tota_kicks, 1, 2);

    coup_vec = calc_residue_for_optimization(the_ring, coup);
    fm = sqrt(lnls_meansqr(coup_vec));
    residue = abs(best_fm-fm)/best_fm;
    if (fm < best_fm)
        best_fm      = fm;
        best_skew    = the_ring(skew_lst);
        factor = 1; % reset the correction strength to 1
        best_coupvec  = coup_vec;
    else
        the_ring(skew_lst) = best_skew;
        factor = factor * 0.75; % reduces the strength of the correction
        n_times = n_times + 1; % to check how many times it passed here;
    end
    % breaks the loop in case convergence is reached
    if residue < tol
        break;
    end
end
skewstr = getcellstruct(the_ring, 'PolynomA', skew_lst, 1, 2);
skewstr = skewstr.*getcellstruct(the_ring, 'Length', skew_lst);
skewstr = sum(reshape(skewstr, size(coup.scm_idx,1), []), 2)';

function residue = calc_residue_for_optimization(the_ring, coup)

bpms = coup.bpm_idx;
hcms = coup.hcm_idx;
vcms = coup.vcm_idx;

[M, Disp, ~] = get_matrix_disp(the_ring, bpms, hcms, vcms);
[~, Mxy, Myx, ~, ~, Dispy] = prepare_data_for_symm(the_ring, coup, M, Disp);
residue = calc_residue_coupling(Mxy, Myx, Dispy, bpms, hcms, vcms);
