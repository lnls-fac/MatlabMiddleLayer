function the_ring = ids_globally_symmetrize(the_ring, tunes_goal, id_ssections, params)

% builds quads knobs indices cellarray of vectors
knobs_idx = find_knobs_idx(the_ring,params.knobs);

mi  = sort([findcells(the_ring, 'FamName', 'mia'), findcells(the_ring, 'FamName', 'mib')]);
mc  = findcells(the_ring, 'FamName', 'mc');
alphax_idx = sort([mi mc]);
alphay_idx = sort([mi mc]);
etaxl_idx  = sort([mi mc]);
etax_idx   = sort(setdiff(mi, mi(id_ssections)));

optionals = {tunes_goal, alphax_idx, alphay_idx, etaxl_idx, etax_idx};

fprintf('\nGLOBAL SYMMETRIZATION OF OPTICS:\n');
respm = ids_calc_response_matrix(the_ring, knobs_idx, @calc_residue_global_symm, optionals, true);
residue_rms = Inf;
nr_iters = 1;
factor = 1;
while (residue_rms > params.tol) && (nr_iters <= params.nr_iters)
    
    residue = calc_residue_global_symm(the_ring, optionals);
    fprintf('%d -> %f %f\n', 0, 0, calc_rms(residue));
    
    min_residue = residue; best_the_ring = the_ring;
    for i=1:length(respm.S)
        iS = 1./respm.S;
        iS(i+1:end) = 0;
        dK = - (respm.V * diag(iS) * respm.U') * residue;
        if (max(abs(dK)) > params.maxdK), continue; end;
        new_the_ring = set_delta_K(the_ring, knobs_idx, factor*dK);
        new_residue = calc_residue_global_symm(new_the_ring, optionals);
        fprintf('%d -> %f %f', i, max(abs(dK)), calc_rms(new_residue));
        if (calc_rms(new_residue) < calc_rms(min_residue))
            min_residue = new_residue;
            best_the_ring = new_the_ring;
            fprintf(' (*) ');
        end
        fprintf('\n');
    end
    if (calc_rms(min_residue) / residue_rms > 0.95), factor = factor / 2;
    else factor = min([factor * 2, 1]); end
    the_ring = best_the_ring;
    residue_rms = calc_rms(min_residue);
    nr_iters = nr_iters + 1;
end

fprintf('\n')

function residue = calc_residue_global_symm(the_ring, optionals)

tunes = optionals{1};
alphax_idx = optionals{2};
alphay_idx = optionals{3};
etaxl_idx  = optionals{4};
etax_idx   = optionals{5};

twiss = calctwiss(the_ring, 'n+1');

scale_alpha = 1e-5;
scale_tune  = 1e-5;
scale_eta   = 1e-5;

residue = [];
residue = ([twiss.mux(end); twiss.muy(end)]/2/pi - tunes') / scale_tune;
residue = [residue; twiss.alphax(alphax_idx) / scale_alpha];
residue = [residue;  twiss.alphay(alphay_idx) / scale_alpha];
residue = [residue;  twiss.etaxl(etaxl_idx) / scale_alpha];
residue = [residue;  twiss.etax(etax_idx) / scale_eta];