function data = get_ids_data(ring, indices, emit_ratio, n_rand_mach, pol_scale)
    fprintf(['-- Find Strength of IDs [', datestr(now), ']\n']);

    idx = indices.ids; 
    if ~exist('pol_scale', 'var')
        pol_scale = 3e-3*ones(1, size(idx, 1));

        fprintf('   . desired coupling (ey/ex): ');
        fprintf('%f \n', emit_ratio);
        fprintf('   . listing id configurations\n');
        fprintf('   %2s @ %5s | ', 'id', 'mkr');
        fprintf('%6s | ', 'family');
        fprintf('%10s | ', 'Length [m]');
        fprintf('%10s | ', 'Pass Meth.');
        fprintf('%9s | ', 'QS [1/km]');
        fprintf('%12s |', 'ex [pm.rad]');
        fprintf('%12s |', 'ey [pm.rad]');
        fprintf('%12s |', 'e0 [pm.rad]');
        fprintf('%6s\n', 'ey/ex');
        last = 0;
        for i=1:size(idx, 1)
            fam = unique(getcellstruct(ring, 'FamName', idx(i,:)));
            len = getcellstruct(ring, 'Length', idx(i,:));
            pas = unique(getcellstruct(ring, 'PassMethod', idx(i,:)));
            while pol_scale(i) ~= last
                la1 = insert_one_id(ring, idx(i,:), pol_scale(i));
                coup = lnls_calc_coupling(la1);
                rat = emit_ratio / coup.emit_ratio;
                last = pol_scale(i);
                pol_scale(i) = round(sqrt(rat) * pol_scale(i), 3);
            end
            fprintf('   %02i @ %5s | ', i, ring{idx(i,1)+1}.FamName);
            fprintf('%6s | ', fam{1});
            fprintf('%10.3f | ', sum(len));
            fprintf('%10s | ', pas{1});
            fprintf('%9.2f | ', pol_scale(i)*1000);
            fprintf('%12.3f |', 1e12*coup.emit_x);
            fprintf('%12.3f |', 1e12*coup.emit_y);
            fprintf('%12.3f |', 1e12*(coup.emit_x + coup.emit_y));
            fprintf('%6.3f\n', 100*coup.emit_ratio);
        end
    end
    data.idx = idx;
    data.goal_emit_ratio = emit_ratio;
    data.pol_scale = pol_scale;
    pol_scale = repmat(pol_scale, n_rand_mach, 1);
    data.polynom_a = 2*(rand(size(pol_scale)) - 0.5) .* pol_scale;
 