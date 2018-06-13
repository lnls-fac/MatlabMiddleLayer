function nominal_data = controlled_coupling(ring, sim_anneal, indices)

    fprintf(['-- generating lattice with controlled coupling [', datestr(now), ']\n']);

    k = sim_anneal.target_coupling;

    % cluster qs indices in families
    famnames = unique(getcellstruct(ring, 'FamName', indices.qs(:,1)));
    qs_fams = cell(1,length(famnames));
    sz = size(indices.qs,2);
    for i=1:length(famnames)
        idx = findcells(ring, 'FamName', famnames{i});
        qs_fams{i} = reshape(intersect(idx, indices.qs(:)), [], sz);
    end
    
    % calcs nominal sigmay
    ref_sig = calc_nominal_sigmas(ring, k);

    % --- searches for nominal machine ---
    fprintf('   . simulated annealing search\n');
    r1 = calc_residue_nominal(ring, indices, sim_anneal, ref_sig);
    fprintf('   trial residue ... \n');
    fprintf(...
            '   %04i: %f  | %7.3f [deg] | %7.3f [um] | %7.3f %%\n',...
            0, r1.residue, (180/pi)*r1.r_tilt, 1e6*r1.r_sigmay, 100*r1.r_coup); 
    ps = update_nominal_plots(r1.coup, indices, ref_sig);
    stren0 = get_qs_in_families(ring, qs_fams);
    for i=1:sim_anneal.nr_iterations
        drawnow;
        delta_q = 2 * (rand(1, length(qs_fams)) - 0.5) * sim_anneal.qs_delta;
        new_ring = add_qs_in_families(ring, qs_fams, delta_q);
        r2 = calc_residue_nominal(new_ring, indices, sim_anneal, ref_sig);
        ratio = max(r2.coup.sigmas(2,:))/mean(r2.coup.sigmas(2,:));
        if (r2.residue < r1.residue) && (ratio < 3)
            r1 = r2;
            ring = new_ring;
            fprintf(...
                '   %04i: %f  | %7.3f [deg] | %7.3f [um] | %7.3f %%\n',...
                i, r1.residue, (180/pi)*r1.r_tilt, 1e6*r1.r_sigmay, 100*r1.r_coup); 
            ps = update_nominal_plots(r1.coup, indices, ref_sig, ps);
        end
    end
    stren = get_qs_in_families(ring, qs_fams);
    skew_stren = zeros(1, length(qs_fams));
    for i=1:length(qs_fams)
        skew_stren(i) = stren{i}(1) - stren0{i}(1);
    end
    fprintf('\n\n');
    nominal_data.skew_stren = skew_stren;
    nominal_data.qs_fams = qs_fams;    