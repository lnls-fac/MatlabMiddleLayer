function the_ring = ids_symmetrize(the_ring, params)

% Start at the last mc marker to preserve sections numbers
idx = findcells(the_ring, 'FamName', 'mc');  idx = idx(end)-1;
the_ring = circshift(the_ring,[0,-idx]);
mc = unique(sort([1 findcells(the_ring, 'FamName', 'mc') length(the_ring)]));


% Replicate calculations for the nominal model of the ring:
the_ring0 = params.the_ring0;
idx0 = findcells(the_ring0, 'FamName', 'mc');  idx0 = idx0(end)-1;
the_ring0 = circshift(the_ring0,[0,-idx0]);
mc0 = unique(sort([1 findcells(the_ring0, 'FamName', 'mc') length(the_ring0)]));
optionals.twiss0 = calctwiss(the_ring0,'n+1');


id_sections = params.id_sections;
fprintf('\nSYMMETRIZATION OF OPTICS:\n');
for i=1:length(id_sections)
    fprintf('\nsection: %02d --> ', id_sections(i));
    
    % builds index vector that selects whole straight section
    line = mc(id_sections(i)):mc(id_sections(i)+1);
    the_line = the_ring(line);
    
    % Find indices of knobs
    knobs_idx  = {};
    knobs_fams = {};
    for ii=1:length(params.knobs)
        indcs = findcells(the_line,'FamName',params.knobs{ii});
        if isempty(indcs), continue; end
        knobs_idx{end+1} = indcs;
        knobs_fams{end+1} = params.knobs{ii};
    end
    
    % builds optionals for symmetrizations
    if ~mod(id_sections(i),2), straight_label = 'mib'; 
    else if mod(id_sections(i),4)==1, straight_label = 'mia';
        else                          straight_label = 'mip';
        end
    end
    optionals.symm_point = findcells(the_line, 'FamName', straight_label);
    optionals.ini_point0 = mc0(id_sections(i));
    optionals.fin_point0 = mc0(id_sections(i)+1);
    optionals.look_tune  = params.look_tune;
    
    % symmetrize one ID
    the_line = symmetrize_id_straight_sector(the_line, optionals, knobs_idx, knobs_fams, params);
    the_ring(line) = the_line;
end
the_ring = circshift(the_ring,[0,idx]);
fprintf('\n');
end


function the_line = symmetrize_id_straight_sector(the_line, optionals, knobs_idx, knobs_fams, params)

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
fprintf('residue: %7.2g;  nr_iters: %3d; dKs:  ',residue,nr_iters);
for i=1:length(knobs_fams)
    fprintf('%s --> %7.4g   ',knobs_fams{i},accum_dK(i));
end
fprintf('\n');
end

function residue = calc_residue_local_symm(the_line, optionals)
symm_point = optionals.symm_point;
ini0       = optionals.ini_point0;
fin0       = optionals.fin_point0;
twi0       = optionals.twiss0;

betax0     = twi0.betax(ini0);
alphax0    = twi0.alphax(ini0);
betay0     = twi0.betay(ini0);
alphay0    = twi0.alphay(ini0);
etax0      = twi0.etax(ini0);
etaxl0     = twi0.etaxl(ini0);
mux0       = (twi0.mux(fin0)-twi0.mux(ini0))/2;
muy0       = (twi0.muy(fin0)-twi0.muy(ini0))/2;

scale_alpha = 1e-5;
% scale_eta   = 1e-5;
scale_mu    = 1e-3;

TwissDataIn.ClosedOrbit = [0 0 0 0]';
TwissDataIn.Dispersion = [etax0 etaxl0 0 0]';
TwissDataIn.beta = [betax0 betay0];
TwissDataIn.alpha = [alphax0 alphay0];
TwissDataIn.mu = [0 0];
% TwissData = twissline(the_line, 0, TwissDataIn, 1:length(the_line)+1, 'Chrom');
TwissData = twissline(the_line, 0, TwissDataIn, 1:length(the_line)+1);
alphax = TwissData(symm_point).alpha(1);
alphay = TwissData(symm_point).alpha(2);
% etax   = TwissData(symm_point).Dispersion(1);
% etaxl  = TwissData(symm_point).Dispersion(2);
dmux = TwissData(symm_point).mu(1) - mux0;
dmuy = TwissData(symm_point).mu(2) - muy0;
if optionals.look_tune
    residue = [alphax / scale_alpha, alphay / scale_alpha, [dmux,dmuy]/scale_mu]';
else
    residue = [alphax / scale_alpha, alphay / scale_alpha]';
end
end