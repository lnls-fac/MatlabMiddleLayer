function response = calc_feedback_respm(ring, indices, b2_selection)
    fprintf(['-- running coupling feedback [', datestr(now), ']\n']);

    response.b2_selection = b2_selection;
    response.delta_qs = 0.001;
    b2_idx = indices.b2(b2_selection);
    response.matrix = zeros(size(b2_idx,1), size(indices.qs,1));

    fprintf('   angle monitors at: ');
    names = unique(getcellstruct(ring, 'FamName', b2_idx));
    for i=1:length(names)
        fprintf('%s ', names{i});
    end
    fprintf(' (%03i)\n', size(b2_idx,1));

    fprintf('   skew correctors at: ');
    names = unique(getcellstruct(ring, 'FamName', indices.qs));
    for i=1:length(names)
        fprintf('%s ', names{i});
    end
    fprintf(' (%03i)\n', size(indices.qs,1));

    fprintf('   ');
    for i=1:size(response.matrix,2)
        fprintf('%03i ',i);
        if (rem(i,10) == 0)
            fprintf('\n   ');
        end
        qs0 = getcellstruct(ring, 'PolynomA', indices.qs(i,:), 1, 2);
        ring = setcellstruct(ring, 'PolynomA', indices.qs(i,:), qs0 + response.delta_qs/2, 1, 2);
        coupling_p = calc_coupling(ring);
        ring = setcellstruct(ring, 'PolynomA', indices.qs(i,:), qs0 - response.delta_qs/2, 1, 2);
        coupling_n = calc_coupling(ring);
        ring = setcellstruct(ring, 'PolynomA', indices.qs(i,:), qs0, 1, 2);
        tilt = coupling_p.tilt(b2_idx) - coupling_n.tilt(b2_idx);
        response.matrix(:,i) = tilt / response.delta_qs;
    end
    fprintf('\n');
    [response.U, response.S, response.V] = svd(response.matrix, 'econ');
    response.S = diag(response.S);

    
