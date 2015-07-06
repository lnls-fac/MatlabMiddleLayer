function [the_ring, residue, nr_iters] = ids_locally_symmetrize(the_ring, ids, params)

% Start at the last mc marker to preserve sections numbers
idx = findcells(the_ring, 'FamName', 'mc');  idx = idx(end)-1;
the_ring = circshift(the_ring,[0,-idx]);
mc = unique(sort([1 findcells(the_ring, 'FamName', 'mc') length(the_ring)]));

fprintf('\nLOCAL SYMMETRIZATION OF OPTICS:\n');
residue  = Inf*ones(1,length(ids));
nr_iters = ones(1,length(ids));
for i=1:length(ids)
    %find the straight section number
    if strcmp(ids(i).straight_label,'mia'), 
        section_nr = (ids(i).straight_number - 1) * 2 + 1;
    else
        section_nr = ids(i).straight_number * 2;
    end
    fprintf('\ninsertion: %12s --> ', ids(i).label);
    
    % builds index vector that selects whole straight section
    line = mc(section_nr):mc(section_nr+1);
    the_line = the_ring(line);
    
    % Find indices of knobs
    knobs_idx = find_knobs_idx(the_line,params.knobs);
    
    % builds optionals for symmetrizations
    symm_point = findcells(the_line, 'FamName', ids(i).straight_label);
    optionals = {symm_point,params.goal(1),params.goal(2),params.goal(3)};
    
    factor = 1;
    old_residue = Inf;
    while (residue(i) > params.tol) && (nr_iters(i) <= params.nr_iters) && (factor > 0.01)
        [the_line new_residue] = symmetrize_id_straight_sector(the_line, optionals, factor, knobs_idx,params.maxdK);
        if (new_residue / old_residue > 0.95)
            factor = factor / 2;
        else
            factor = min([factor * 2, 1]);
        end
        residue(i) = new_residue;
        nr_iters(i) = nr_iters(i) + 1;
    end
    fprintf('residue: %7.2g;  nr_iters: %3d',residue(i),nr_iters(i));
    the_ring(line) = the_line;
end
the_ring = circshift(the_ring,[0,idx]);
fprintf('\n');

function [best_the_line, residue] = symmetrize_id_straight_sector(the_line, optionals, factor, knobs_idx, maxdK)

%calculate response matrix
respm = ids_calc_response_matrix(the_line, knobs_idx, @calc_residue_local_symm, optionals);
residue = calc_residue_local_symm(the_line, optionals);
% fprintf('%d -> %f %f\n', 0, 0, calc_rms(residue));

min_residue = residue;
best_the_line = the_line;
for i=1:length(respm.S)
    iS = 1./respm.S;
    iS(i+1:end) = 0;
    dK = - (respm.V * diag(iS) * respm.U') * residue;
    if (max(abs(dK)) > maxdK), continue; end;
    new_the_line = set_delta_K(the_line, knobs_idx, factor*dK);
    new_residue = calc_residue_local_symm(new_the_line, optionals);
%     fprintf('%d -> %f %f', i, max(abs(dK)), calc_rms(new_residue));
    if (calc_rms(new_residue) < calc_rms(min_residue))
        min_residue = new_residue;
        best_the_line = new_the_line;
%         fprintf(' (*) ');
    end
%     fprintf('\n');
end
residue = calc_rms(min_residue);


function residue = calc_residue_local_symm(the_ring, optionals)
symm_point = optionals{1};
betax0     = optionals{2};
betay0     = optionals{3};
etax0      = optionals{4};

scale_alpha = 1e-5;
scale_eta   = 1e-5;

TwissDataIn.ClosedOrbit = [0 0 0 0]';
TwissDataIn.Dispersion = [etax0 0 0 0]';
TwissDataIn.beta = [betax0 betay0];
TwissDataIn.alpha = [0 0];
TwissDataIn.mu = [0 0];
TwissData = twissline(the_ring, 0, TwissDataIn, 1:length(the_ring)+1, 'Chrom');
alphax = TwissData(symm_point).alpha(1);
alphay = TwissData(symm_point).alpha(2);
etax   = TwissData(symm_point).Dispersion(1);
etaxl  = TwissData(symm_point).Dispersion(2);
residue = [alphax / scale_alpha, alphay / scale_alpha]';
%residue = [alphax / scale_alpha, alphay / scale_alpha,  etaxl / scale_alpha]';
% residue = [alphax / scale_alpha, alphay / scale_alpha,  etaxl / scale_alpha, etax / scale_eta]';

% function residue = calc_residue_local_symm(the_ring, optionals)
% symm_point = 1;
% betax0     = optionals{2};
% betay0     = optionals{3};
% etax0      = optionals{4};
% 
% scale_alpha = 1e-5;
% scale_eta   = 1e-5;
% 
% TwissData = twissring(the_ring, 0, 1:length(the_ring)+1, 'Chrom');
% betax = TwissData(symm_point).beta(1);
% betay = TwissData(symm_point).beta(2);
% etax   = TwissData(symm_point).Dispersion(1);
% etaxl  = TwissData(symm_point).Dispersion(2);
% residue = [(betax-betax0) / scale_alpha, (betay-betay0) / scale_alpha]';
% % residue = [(betax-betax0) / scale_alpha, (betay-betay0) / scale_alpha, (etax-etax0)/scale_eta]';