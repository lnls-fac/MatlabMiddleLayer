function fb_data = perform_feedback(...
        rand_mach, rand_mach_goal, indices, response, corr_params)

    fb_strens = zeros(length(rand_mach), length(indices.qs(:)));
    for i=1:length(rand_mach)
        fprintf('   . correcting machine %02i...\n', i);
        goal_tilt = calc_coupling(rand_mach_goal{i});
        goal_tilt = goal_tilt.tilt;
        fb_strens(i,:) = correct_coupling_tilt(...
            rand_mach{i}, goal_tilt, response, indices, corr_params);
    end
    fb_data.quad_strens = fb_strens;
    fb_data.idx = indices.qs(:);
    
    
function qs_stren = correct_coupling_tilt(ring, goal_tilt, response, indices, params)
    if ~isfield(response, 'svd_nr_svs')
        response.svd_nr_svs = length(response.S);
    end

    iS = pinv(response.S);
    iS(response.svd_nr_svs+1:end) = 0;
    iS = diag(iS);

    idx = indices.b2(response.b2_selection);
    
    target = goal_tilt(idx)';
    coup = calc_coupling(ring);
    actual = coup.tilt(idx)';
    residue = actual - target;
    res_ang = (180/pi)*std(residue);
    qs_ini = getcellstruct(ring, 'PolynomA', indices.qs(:), 1, 2);
    for j=0:params.max_nr_iter
        if ~mod(j,10)
            fprintf('%03d : %f\n', j, res_ang);
        end
        qs = -1.0 * (response.V*iS*response.U') * residue;
        qs = repmat(qs, 1, size(indices.qs, 2));
        qs0 = getcellstruct(ring, 'PolynomA', indices.qs(:), 1, 2);
        ring = setcellstruct(ring, 'PolynomA', indices.qs(:), qs0 + qs(:), 1, 2);
        coup = calc_coupling(ring);
        actual = coup.tilt(idx)';
        residue = actual - target;
        res_ang = (180/pi)*std(residue);
        if res_ang < params.min_res
            break;
        end
    end
    qs_fin = getcellstruct(ring, 'PolynomA', indices.qs(:), 1, 2);
    qs_stren = qs_fin - qs_ini;
    fprintf('final residue : %f\n', (180/pi)*std(residue));
    fprintf('\n');
