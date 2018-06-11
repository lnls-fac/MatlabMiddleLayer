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
    r1 = calc_residue(ring, indices, sim_anneal, ref_sig);
    fprintf('   trial residue ... \n');
    fprintf(...
            '   %04i: %f  | %7.3f [deg] | %7.3f [um] | %7.3f %%\n',...
            0, r1.residue, (180/pi)*r1.r_tilt, 1e6*r1.r_sigmay, 100*r1.r_coup); 
    [p1, p2] = update_sim_annel_plots(r1.coup, indices, ref_sig);
    stren0 = get_qs_in_families(ring, qs_fams);
    for i=1:sim_anneal.nr_iterations
        drawnow;
        delta_q = 2 * (rand(1, length(qs_fams)) - 0.5) * sim_anneal.qs_delta;
        new_ring = add_qs_in_families(ring, qs_fams, delta_q);
        r2 = calc_residue(new_ring, indices, sim_anneal, ref_sig);
        ratio = max(r2.coup.sigmas(2,:))/mean(r2.coup.sigmas(2,:));
        if (r2.residue < r1.residue) && (ratio < 3)
            r1 = r2;
            ring = new_ring;
            fprintf(...
                '   %04i: %f  | %7.3f [deg] | %7.3f [um] | %7.3f %%\n',...
                i, r1.residue, (180/pi)*r1.r_tilt, 1e6*r1.r_sigmay, 100*r1.r_coup); 
            [p1, p2] = update_sim_annel_plots(r1.coup, indices, ref_sig, p1, p2);
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


function ref_sig = calc_nominal_sigmas(ring, emit_ratio)
    tw = calctwiss(ring, 'N+1');
    tw.gammax = (1 + tw.alphax.^2) ./ tw.betax;
    tw.gammay = (1 + tw.alphay.^2) ./ tw.betay;
    as = atsummary(ring);
    ex = as.naturalEmittance / (1 + emit_ratio);
    ey = as.naturalEmittance / (1 + emit_ratio) * emit_ratio;
    spread = as.naturalEnergySpread;
    ref_sig(1,:) = sqrt(ex * tw.betax + (spread * tw.etax).^2);
    ref_sig(2,:) = sqrt(ey * tw.betay + (spread * tw.etay).^2);

    
function stren = get_qs_in_families(ring, qs_fams)
    stren = cell(1, length(qs_fams));
    for i=1:length(qs_fams)
        stren{i} = getcellstruct(ring, 'PolynomA', qs_fams{i}, 1, 2);
    end
    
    
function r = calc_residue(ring, indices, sim_anneal, nominal_sigmas)

    r.coup = calc_coupling(ring);

    r.r_tilt = rms(r.coup.tilt(indices.bl_ids));
    r.r_sigmay = rms(r.coup.sigmas(2,:) - nominal_sigmas(2,:));
    r.r_coup = abs(sim_anneal.target_coupling - r.coup.emit_ratio);
    
    r.residue = r.r_tilt / sim_anneal.scale_tilt + ...
                r.r_sigmay / sim_anneal.scale_sigmay + ...
                r.r_coup / sim_anneal.scale_coup;
          

function [p1, p2] = update_sim_annel_plots(coup, indices, nominal_sigmas, p1, p2)

    maxsigmay = max(nominal_sigmas(2,:));
    b2 = indices.b2;
    mic = indices.mic;
    bl_ids = indices.bl_ids;
    pos = indices.pos;
    if ~exist('p1','var')
        figure; hold all;
        p1{1} = plot(pos, 1e6*coup.sigmas(2,:), 'Color', [0.8, 0.8, 1]);
        p1{2} = scatter(pos(b2), 1e6*nominal_sigmas(2, b2), 52, [0,0,1], 'filled');
        p1{3} = scatter(pos(b2), 1e6*coup.sigmas(2, b2), 50, [0.5,0.5,1], 'filled');
        ax = get(p1{3},'Parent');
        ylim(ax, [0,1e6*1.2*maxsigmay]);
        xlim(ax, [0, pos(end)]);
        ylabel(ax, 'sigmay [um]'); 
        figure;
        hold all;
        p2{1} = plot(pos, (180/pi)*coup.tilt, 'Color', [1, 0.8, 0.8]);
        p2{2} = scatter(pos(mic), (180/pi)*coup.tilt(mic), 50, [1,0.5,0.5], 'filled');
        p2{3} = scatter(pos(bl_ids), (180/pi)*coup.tilt(bl_ids), 50, [1,0,0], 'filled');
        ax = get(p2{3},'Parent');
        xlim(ax, [0, pos(end)]);
        ylim(ax, [-45,45]);
        ylabel(ax, 'tilt angle [degree]'); 
    else
        set(p1{1}, 'YData', 1e6*coup.sigmas(2,:)); 
        set(p1{2}, 'YData', 1e6*nominal_sigmas(2, b2)); 
        set(p1{3}, 'YData', 1e6*coup.sigmas(2, b2));
        ax = get(p1{3},'Parent');
        ylim(ax, [0,1e6*1.2*maxsigmay]);
        set(p2{1}, 'YData', (180/pi)*coup.tilt); 
        set(p2{2}, 'YData', (180/pi)*coup.tilt(mic)); 
        set(p2{3}, 'YData', (180/pi)*coup.tilt(bl_ids)); 
        ax = get(p2{3},'Parent');
        ylim(ax, [-45,45]);
    end
    drawnow;
    