function the_ring = ids_globally_symmetrize(the_ring, tunes_goal, params)

% Start at the last mc marker to preserve sections numbers
idx = findcells(the_ring, 'FamName', 'mc');  idx = idx(end)-1;
the_ring = circshift(the_ring,[0,-idx]);

% builds quads knobs indices cellarray of vectors
knobs_idx   = find_knobs_idx(the_ring, params.knobs, params.id_sections);

% section_markers
mia  = findcells(the_ring, 'FamName', 'mia');
mib  = findcells(the_ring, 'FamName', 'mib');
mip  = findcells(the_ring, 'FamName', 'mip');
mc  = findcells(the_ring, 'FamName', 'mc');
optionals = {tunes_goal, mia, mib, mip, mc};

fprintf('\nGLOBAL SYMMETRIZATION OF OPTICS:\n');
respm = ids_calc_response_matrix(the_ring, knobs_idx, @calc_residue_global_symm, optionals, true);
for sv = params.svs_lst
    residue_vec = calc_residue_global_symm(the_ring, optionals);
    residue     = calc_rms(residue_vec);
    old_residue = residue*2;
    nr_iters    = 0;
    factor      = 1;
    fprintf('nr_svs: %2d\n',sv);
    fprintf('iter: %03d, residue: %8.3g, maxdk: %7.4g\n',nr_iters,residue,0);
    condition_2_continue = true;
    while condition_2_continue
        nr_iters = nr_iters + 1;
        iS = 1./respm.S; iS(sv+1:end) = 0;
        dK = - factor*(respm.V * diag(iS) * respm.U') * residue_vec;
        new_the_ring = set_delta_K(the_ring, knobs_idx, dK);
        new_residue_vec = calc_residue_global_symm(new_the_ring, optionals);
        new_residue     = calc_rms(new_residue_vec);
        if (new_residue < residue)
            residue_vec = new_residue_vec;
            old_residue = residue;
            residue = new_residue;
            the_ring = new_the_ring;
            factor = min([factor * 2, 1]);
            fprintf('iter: %03d, residue: %8.3g, maxdk: %7.4g\n',nr_iters,residue,max(abs(dK)));
            respm = ids_calc_response_matrix(new_the_ring, knobs_idx, ...
                @calc_residue_global_symm, optionals, false);
        else
            factor = factor / 2;
        end
        if ((old_residue-residue)/old_residue < 0.001) || (factor < 0.001)
            fprintf('Terminated due to lack of improvement\n');
            condition_2_continue = false;
        end
        if (residue < params.tol);
            fprintf('Convergence achieved\n');
            condition_2_continue = false;
        end
        if (nr_iters >= params.nr_iters);
            fprintf('Maximum iteration number achieved\n');
            condition_2_continue = false;
        end
    end
end
the_ring = circshift(the_ring,[0,idx]);
fprintf('\n')

function residue = calc_residue_global_symm(the_ring, optionals)

tunes_goal = optionals{1};
mia        = optionals{2};
mib        = optionals{3};
mip        = optionals{4};
mc         = optionals{5};

% Calculate Twiss parameters:
% twiss = calctwiss(the_ring, 'n+1');
[TD, tunes] = twissring(the_ring,0,1:(length(the_ring)+1));
beta = cat(1, TD.beta);
twiss.betax = beta(:,1);
twiss.betay = beta(:,2);
alpha = cat(1, TD.alpha);
twiss.alphax = alpha(:,1);
twiss.alphay = alpha(:,2);

scale_alpha = 1e5;
scale_tune  = 1e5;
scale_beta  = 1e1;

residue = (tunes - tunes_goal)' * scale_tune * 80;
residue = [residue; twiss.alphax([mia, mib, mip, mc]) * scale_alpha];
residue = [residue; twiss.alphay([mia, mib, mip, mc]) * scale_alpha];
residue = [residue; (twiss.betax(mia)-twiss.betax(circshift(mia,[0,1]))) * scale_beta];
residue = [residue; (twiss.betax(mib)-twiss.betax(circshift(mib,[0,1]))) * scale_beta];
residue = [residue; (twiss.betax(mip)-twiss.betax(circshift(mip,[0,1]))) * scale_beta];
residue = [residue; (twiss.betay(mia)-twiss.betay(circshift(mia,[0,1]))) * scale_beta];
residue = [residue; (twiss.betay(mib)-twiss.betay(circshift(mib,[0,1]))) * scale_beta];
residue = [residue; (twiss.betay(mip)-twiss.betay(circshift(mip,[0,1]))) * scale_beta];

% residue = [residue;  twiss.etaxl(etaxl_idx) / scale_alpha];
% residue = [residue;  twiss.etax(etax_idx) / scale_eta];


function knobs_idx = find_knobs_idx(the_ring, knobs, id_sections)
mc = unique(sort([1 findcells(the_ring, 'FamName', 'mc') length(the_ring)]));
j = 1;
for i = 1:length(knobs)
    for ii = id_sections'
        indcs = findcells(the_ring(mc(ii):mc(ii+1)),'FamName',knobs{i});
        if isempty(indcs), continue; end
        knobs_idx{j} = (mc(ii)-1) + indcs;
        j = j + 1;
    end
end
for i = 1:length(knobs)
    knobs_idx{j} = [];
    for ii = setdiff(1:20,id_sections')
        indcs = findcells(the_ring(mc(ii):mc(ii+1)),'FamName',knobs{i});
        if isempty(indcs), continue; end
        knobs_idx{j} = [knobs_idx{j}, (mc(ii)-1) + indcs];
    end
    if isempty(knobs_idx{j}), 
        knobs_idx = knobs_idx(1:j-1);
    else
        j = j + 1;
    end
end