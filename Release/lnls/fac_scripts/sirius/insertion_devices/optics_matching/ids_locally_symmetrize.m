function the_ring = ids_locally_symmetrize(the_ring, params)

% Start at the last mc marker to preserve sections numbers
idx = findcells(the_ring, 'FamName', 'mc');  idx = idx(end)-1;
the_ring = circshift(the_ring,[0,-idx]);
mc = unique(sort([1 findcells(the_ring, 'FamName', 'mc') length(the_ring)]));

id_sections = params.id_sections;

fprintf('\nLOCAL SYMMETRIZATION OF OPTICS:\n');
for i=1:length(id_sections)
    fprintf('\nsection: %02d --> ', id_sections(i));
    
    % builds index vector that selects whole straight section
    line = mc(id_sections(i)):mc(id_sections(i)+1);
    the_line = the_ring(line);
    
    % Find indices of knobs
    knobs_idx = {};
    j = 1;
    for ii=1:length(params.knobs)
        indcs = findcells(the_line,'FamName',params.knobs{ii});
        if isempty(indcs), continue; end
        knobs_idx{j} = indcs;
        j = j+1;
    end
    
    % builds optionals for symmetrizations
    if ~mod(id_sections(i),2), straight_label = 'mib'; else straight_label = 'mia';end
    symm_point = findcells(the_line, 'FamName', straight_label);
    optionals = {symm_point,params.goal(1),params.goal(2),params.goal(3),...
                            params.goal(4),params.goal(5),params.goal(6)};

    % symmetrize one ID
    the_line = symmetrize_id_straight_sector(the_line, optionals, knobs_idx, params);
    the_ring(line) = the_line;
end
the_ring = circshift(the_ring,[0,idx]);
fprintf('\n');

function the_line = symmetrize_id_straight_sector(the_line, optionals, knobs_idx, params)

factor = 1;
residue_vec = calc_residue_local_symm(the_line, optionals);
residue = calc_rms(residue_vec);
nr_iters = 0;
respm = ids_calc_response_matrix(the_line, knobs_idx, @calc_residue_local_symm, optionals);
accum_dK = zeros(size(respm.M,2),1);

while (residue > params.tol) && (nr_iters < params.nr_iters) && (factor > 0.001)
    dK = - factor * (respm.V * diag(1./respm.S) * respm.U') * residue_vec;
    new_the_line = set_delta_K(the_line, knobs_idx, dK);
    new_residue_vec = calc_residue_local_symm(new_the_line, optionals);
    new_residue = calc_rms(new_residue_vec);
    if (new_residue < residue)
        respm = ids_calc_response_matrix(new_the_line, knobs_idx, ...
                                    @calc_residue_local_symm, optionals);
        residue_vec = new_residue_vec;
        residue = new_residue;
        the_line = new_the_line;
        factor = min([factor * 2, 1]);
        accum_dK = accum_dK + dK;
    else
        factor = factor / 2;
    end
    nr_iters = nr_iters + 1;
end
fprintf('residue: %7.2g;  nr_iters: %3d; maxdK: %7.4g',residue,nr_iters,max(abs(accum_dK)));


function residue = calc_residue_local_symm(the_ring, optionals)
symm_point = optionals{1};
betax0     = optionals{2};
alphax0    = optionals{3};
betay0     = optionals{4};
alphay0    = optionals{5};
etax0      = optionals{6};
etaxl0     = optionals{7};

scale_alpha = 1e-5;
scale_eta   = 1e-5;

TwissDataIn.ClosedOrbit = [0 0 0 0]';
TwissDataIn.Dispersion = [etax0 etaxl0 0 0]';
TwissDataIn.beta = [betax0 betay0];
TwissDataIn.alpha = [alphax0 alphay0];
TwissDataIn.mu = [0 0];
TwissData = twissline(the_ring, 0, TwissDataIn, 1:length(the_ring)+1, 'Chrom');
alphax = TwissData(symm_point).alpha(1);
alphay = TwissData(symm_point).alpha(2);
etax   = TwissData(symm_point).Dispersion(1);
etaxl  = TwissData(symm_point).Dispersion(2);
residue = [alphax / scale_alpha, alphay / scale_alpha]';
% residue = [alphax / scale_alpha, alphay / scale_alpha,  etaxl / scale_alpha, etax / scale_eta]';