function symmetrization_of_optics_with_ids

clc;

% selects SIRIUS version

% number of optics matching iterations
max_nr_iters = 500;
fitting_tol_symm = 0.01;
fitting_tol_tune = 3.0;

% loads ID definitions
%ids_def = create_ids_def_PH_old;
%ids_def = create_ids_def_PV_old;
%ids_def = create_ids_def_PC_old;
%ids_def = create_ids_def_PH;

% % old ID table
% ids = [];
% ids = [ids ids_def.araucaria1];
% ids = [ids ids_def.araucaria2];
% ids = [ids ids_def.sibipiruna1];
% ids = [ids ids_def.sibipiruna2];
% ids = [ids ids_def.caterete];
% ids = [ids ids_def.mangabeira];
% ids = [ids ids_def.manaca];
% ids = [ids ids_def.carnauba];
% ids = [ids ids_def.w2t];
% ids = [ids ids_def.scw3t];
% ids = [ids ids_def.inga1];
% ids = [ids ids_def.inga2];


ids_def = create_ids_def_PH_new_order;
ids = [];

% --- phase 1 ---
ids = [ids ids_def.caterete];
ids = [ids ids_def.ema];
ids = [ids ids_def.manaca];
ids = [ids ids_def.carnauba];
ids = [ids ids_def.jatoba];
ids = [ids ids_def.inga];
ids = [ids ids_def.sabia];
ids = [ids ids_def.ipe];
% --- phase 2 ---
ids = [ids ids_def.caterete2];
ids = [ids ids_def.ema2];
ids = [ids ids_def.manaca2];
ids = [ids ids_def.carnauba2];
ids = [ids ids_def.inga2];
ids = [ids ids_def.sabia2];
ids = [ids ids_def.ipe2];

% loads initial SIRIUS lattice model
%global THERING
%sirius('_V402');
%sirius;
% the_ring0 = THERING;
% data = load('the_ring_withids_ac10_5_2014-05-15.mat');
%the_ring0 = data.the_ring;
the_ring0 = sirius_si_lattice('ac10_5');

the_ring0 = start_at_last_element(the_ring0, 'mc'); % shifts model to start at center of 2T bending magnets
twiss0 = calc_short_twiss(the_ring0); % calcs original twiss parameters
fprintf('tunes: %9.6f %9.6f\n', twiss0.tunes(1), twiss0.tunes(2));

% inserts IDs and does initial symmetrization
the_ring = insert_ids_set(the_ring0, ids, 1.0);
%the_ring = insert_ids_set(the_ring0, ids2, 1.0);
the_ring = locally_symmetrize_ids(the_ring, twiss0, ids, fitting_tol_symm, max_nr_iters);


for i=1:3
    
    residue = Inf;
    nr_iters = 0;
    while (residue > fitting_tol_tune) && (nr_iters <= max_nr_iters)
        [the_ring, residue_vector] = adjust_tunes(the_ring, twiss0.tunes, []);
        residue = calc_rms(residue_vector);
        nr_iters = nr_iters + 1;
    end
    twiss = calc_short_twiss(the_ring);

    the_ring = locally_symmetrize_ids(the_ring, twiss, ids, fitting_tol_symm, max_nr_iters);
    %twiss = calc_short_twiss(the_ring); % calcs original twiss parameters

end

% saves lattice model with ids
the_ring = restore_lattice_ordering(the_ring);
save('the_ring_withids_ac10_5_2014-05-15_phase2.mat', 'the_ring');



function the_ring = insert_ids_set(the_ring_old, ids, strength)

[~,  id_ssections_number] = get_id_ssections_indices(the_ring_old, ids);

% excludes markers for the end of 2-meter IDs
the_ring = the_ring_old(setdiff(1:length(the_ring_old), findcells(the_ring_old, 'FamName', 'id_end')));
%the_ring = the_ring_old;

for i=1:length(ids)
    fprintf('\n'); fprintf('insertion: %s\n', ids(i).label);
    ids(i).strength = strength;
    the_ring = insert_ID(the_ring, id_ssections_number(i), ids(i));
end


function [the_ring residue nr_iters] = locally_symmetrize_ids(the_ring_old, twiss, ids, tol, max_nr_iters)

[~,  id_ssections_number] = get_id_ssections_indices(the_ring_old, ids);

the_ring = the_ring_old;
for i=1:length(ids)
    fprintf('\n'); fprintf('insertion: %s\n', ids(i).label);
    residue(i) = Inf;
    nr_iters(i) = 0;
    factor = 1;
    old_residue = Inf;
    while (residue(i) > tol) && (nr_iters(i) <= max_nr_iters)
        [the_ring residue_vector] = symmetrize_id_straight_sector(the_ring, id_ssections_number(i), twiss, factor);
        new_residue = calc_rms(residue_vector);
        if (new_residue / old_residue > 0.95)
            factor = factor / 2;
        else
            factor = min([factor * 2, 1]);
        end
        residue(i) = calc_rms(residue_vector);
        nr_iters(i) = nr_iters(i) + 1;
    end
    %t = calctwiss(the_ring);
    %fprintf('tunes: %9.6f %9.6f\n', t.mux(end)/2/pi, t.muy(end)/2/pi);
end




function [id_ssections_idx, id_ssections_number] = get_id_ssections_indices(the_ring, ids)

% gets index of marker for the center of ssection where ID will be
all_id_ssections_idx = sort([findcells(the_ring, 'FamName', 'mia') findcells(the_ring, 'FamName', 'mib')]);
id_ssections_idx    = zeros(1,length(ids));
id_ssections_number = zeros(1,length(ids));
for i=1:length(ids)
    id = ids(i);
    idx = findcells(the_ring, 'FamName', id.straight_label);
    id_ssections_idx(i)    = idx(id.straight_number);
    id_ssections_number(i) = find(id_ssections_idx(i) == all_id_ssections_idx);
end



function the_ring = restore_lattice_ordering(the_ring_old)

the_ring = start_at_first_element(the_ring_old, 'inicio');

% re-label all quadrupolos flanking IDs to original strings
dipoles = findcells(the_ring, 'BendingAngle');
quadrupoles = setdiff(findcells(the_ring, 'K'), dipoles);
for i=1:length(quadrupoles)
    if strfind(the_ring{quadrupoles(i)}.FamName, '_ID')
        the_ring{quadrupoles(i)}.FamName = the_ring{quadrupoles(i)}.FamName(1:end-5);
    end
end


function twiss = calc_short_twiss(the_ring)

t = calctwiss(the_ring, 'n+1');
twiss.betax = t.betax(1);
twiss.betay = t.betay(1);
twiss.etax  = t.etax(1);
twiss.tunes = [t.mux(end) t.muy(end)] / 2 / pi;


function [the_ring residue] = symmetrize_id_straight_sector(the_ring_old, section_nr,  twiss, factor)




% builds index vector that selects whole straight section
mc = unique(sort([1 findcells(the_ring_old, 'FamName', 'mc') length(the_ring_old)]));
line = mc(section_nr):mc(section_nr+1);
the_ring = the_ring_old(line);

% builds index vector (relative to 'line') of symmetry point and quad knobs.
symm_point = [findcells(the_ring, 'FamName', 'mia') findcells(the_ring, 'FamName', 'mib')];
knobs = define_knobs(the_ring, false);


optionals = {symm_point,twiss.betax,twiss.betay,twiss.etax};
residue_function = @calc_residue_symm;


%residue = residue_function(the_ring, optionals);


respm = calc_response_matrix(the_ring, knobs, @calc_residue_symm, optionals);

residue = residue_function(the_ring, optionals);
fprintf('%i -> %f %f\n', 0, 0, calc_rms(residue));

min_residue = residue; best_the_ring = the_ring;
for i=1:length(respm.S)
    iS = 1./respm.S;
    iS(i+1:end) = 0;
    dK = - (respm.V * diag(iS) * respm.U') * residue;
    if (max(abs(dK)) > 1.2), continue; end;
    new_the_ring = set_delta_K(the_ring, knobs, factor*dK);
    new_residue = residue_function(new_the_ring, optionals);
    fprintf('%i -> %f %f', i, max(abs(dK)), calc_rms(new_residue));
    if (calc_rms(new_residue) < calc_rms(min_residue))
        min_residue = new_residue;
        best_the_ring = new_the_ring;
        fprintf(' (*) ');
    end
    fprintf('\n');
end

the_ring = the_ring_old;
the_ring(line) = best_the_ring; 
residue = min_residue;

function [the_ring, residue] = adjust_tunes(the_ring_old, tunes_goal, id_ssections)

fprintf('global tune adjustments\n');
the_ring = the_ring_old;
knobs = define_knobs(the_ring, true);

mia = findcells(the_ring, 'FamName', 'mia');
mib = findcells(the_ring, 'FamName', 'mib');
mi  = sort([mia mib]);
mc  = findcells(the_ring, 'FamName', 'mc');

alphax_idx = sort([mi mc]);
alphay_idx = sort([mi mc]);
etaxl_idx  = sort([mi mc]);
etax_idx   = sort(setdiff(mi, mi(id_ssections)));

%etax_idx   = [];
%etaxl_idx  = [];

optionals = {tunes_goal, alphax_idx, alphay_idx, etaxl_idx, etax_idx};
respm = calc_response_matrix(the_ring, knobs, @calc_residue_tunes, optionals);

residue = calc_residue_tunes(the_ring, optionals);
fprintf('%i -> %f %f\n', 0, 0, calc_rms(residue));

min_residue = residue; best_the_ring = the_ring;
for i=1:length(respm.S)
    iS = 1./respm.S;
    iS(i+1:end) = 0;
    dK = - (respm.V * diag(iS) * respm.U') * residue;
    if (max(abs(dK)) > 0.2), continue; end;
    new_the_ring = set_delta_K(the_ring, knobs, dK);
    new_residue = calc_residue_tunes(new_the_ring, optionals);
    fprintf('%i -> %f %f', i, max(abs(dK)), calc_rms(new_residue));
    if (calc_rms(new_residue) < calc_rms(min_residue))
        min_residue = new_residue;
        best_the_ring = new_the_ring;
        fprintf(' (*) ');
    end
    fprintf('\n');
end

the_ring = best_the_ring;
residue  = min_residue;
fprintf('\n')


function the_ring = insert_ID(the_ring_old, section_nr, id)

the_ring = the_ring_old;

% insert ID a kicktable
mc = unique([1 findcells(the_ring, 'FamName', 'mc') length(the_ring)]);
elements = mc(section_nr):mc(section_nr+1);
center = intersect([findcells(the_ring, 'FamName', 'mia') findcells(the_ring, 'FamName', 'mib')], elements);
the_ring = lnls_insert_kicktable(the_ring, center, id.kicktable_file, id.nr_segs, id.strength, id.label);

% change family names of local quadrupols
mc = unique([1 findcells(the_ring, 'FamName', 'mc') length(the_ring)]);
elements = mc(section_nr):mc(section_nr+1);
dipoles_all = findcells(the_ring, 'BendingAngle');
quadrupoles_all = setdiff(findcells(the_ring, 'K'), dipoles_all);
quadrupoles = intersect(quadrupoles_all, elements);
ssection_label = num2str(section_nr, '_ID%02i');
for i=1:length(quadrupoles)
    the_ring{quadrupoles(i)}.FamName = [the_ring{quadrupoles(i)}.FamName  ssection_label];
end


function knobs = define_knobs(the_ring, include_disp_quads)


dipoles  = findcells(the_ring, 'BendingAngle');
quads    = setdiff(findcells(the_ring, 'K'), dipoles);
famnames = unique(getcellstruct(the_ring, 'FamName', quads));

knobs = {};
if include_disp_quads
    for i=1:length(famnames)
        knobs{i} = findcells(the_ring, 'FamName', famnames{i});
    end;
else
    for i=1:length(famnames)
        if strfind(famnames{i}, 'qf1'), continue; end;
        if strfind(famnames{i}, 'qf2'), continue; end;
        if strfind(famnames{i}, 'qf3'), continue; end;
        if strfind(famnames{i}, 'qf4'), continue; end;     
        knobs{end+1} = findcells(the_ring, 'FamName', famnames{i});
    end;
end

function rms = calc_rms(residue)

rms = sqrt(norm(residue)^2/length(residue));

function the_ring = set_delta_K(the_ring_old, knobs, dK)

the_ring = the_ring_old;
for i=1:length(dK)
    K = getcellstruct(the_ring, 'K', knobs{i});
    newK = K + dK(i);
    the_ring = setcellstruct(the_ring, 'K', knobs{i}, newK);
    the_ring = setcellstruct(the_ring, 'PolynomB', knobs{i}, newK, 1, 2);
end

function respm = calc_response_matrix(the_ring, knobs, residue_function, optionals)

delta_K = 0.01;


%respm = getappdata(0, 'RespM'); if ~isempty(respm), return; end;

M = [];
fprintf('number of knobs: %03i\n', length(knobs));
for i=1:length(knobs)
    
    fprintf('%03i ', i); if (mod(i,10) == 0), fprintf('\n'); end;
    idx = knobs{i};
    K = getcellstruct(the_ring, 'K', idx);
    
    newK = K + delta_K / 2;
    the_ring_tmp = setcellstruct(the_ring, 'K', idx, newK);
    the_ring_tmp = setcellstruct(the_ring_tmp, 'PolynomB', idx, newK, 1, 2);
    residue_p = residue_function(the_ring_tmp, optionals);
    
    newK = K - delta_K / 2;
    the_ring_tmp = setcellstruct(the_ring, 'K', idx, newK);
    the_ring_tmp = setcellstruct(the_ring_tmp, 'PolynomB', idx, newK, 1, 2);
    residue_n = residue_function(the_ring_tmp, optionals);
    
    M(:,end+1) = (residue_p - residue_n) / delta_K;
    
end
fprintf('\n');


[U,S,V] = svd(M, 'econ');

respm.M = M;
respm.U = U;
respm.S = diag(S);
respm.V = V;

setappdata(0, 'RespM', respm);

function the_ring = start_at_first_element(the_ring_old, famname)

idx = findcells(the_ring_old, 'FamName', famname);
the_ring = [the_ring_old(idx(1):end) the_ring_old(1:(idx(1)-1))];

function the_ring = start_at_last_element(the_ring_old, famname)

idx = findcells(the_ring_old, 'FamName', famname);
the_ring = [the_ring_old(idx(end):end) the_ring_old(1:(idx(end)-1))];

function residue = calc_residue_symm(the_ring, optionals)

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
%residue = [alphax / scale_alpha, alphay / scale_alpha,  etaxl / scale_alpha, etax / scale_eta]';

function residue = calc_residue_tunes(the_ring, optionals)

tunes = optionals{1};
alphax_idx = optionals{2};
alphay_idx = optionals{3};
etaxl_idx  = optionals{4};
etax_idx   = optionals{5};



residue = [];
twiss = calctwiss(the_ring, 'n+1');

scale_alpha = 1e-5;
scale_tune  = 1e-5;
scale_eta   = 1e-5;

residue(end+1,1) = (twiss.mux(end)/2/pi - tunes(1)) / scale_tune;
residue(end+1,1) = (twiss.muy(end)/2/pi - tunes(2)) / scale_tune;

% alphax
for i=1:length(alphax_idx)
    residue(end+1,1) = twiss.alphax(alphax_idx(i)) / scale_alpha;
end;

% alphay
for i=1:length(alphay_idx)
    residue(end+1,1) = twiss.alphay(alphay_idx(i)) / scale_alpha;
end;

% etaxl
for i=1:length(etaxl_idx)
    residue(end+1,1) = twiss.etaxl(etaxl_idx(i)) / scale_alpha;
end;

% etax
for i=1:length(etax_idx)
    residue(end+1,1) = twiss.etax(etax_idx(i)) / scale_eta;
end;

function ids_def = create_ids_def_PH_new_order

% trechos impares - Betas Baixos

% --- phase 1 ---
ids_def.caterete.label           = 'caterete';
ids_def.caterete.kicktable_file  = '../id_modelling/U19/U19_kicktable.txt';
ids_def.caterete.nr_segs         = 20;
ids_def.caterete.straight_label  = 'mib';
ids_def.caterete.straight_number = 5;
ids_def.caterete.strength        = 1;

ids_def.ema.label                = 'ema';
ids_def.ema.kicktable_file       = '../id_modelling/U19/U19_kicktable.txt';
ids_def.ema.nr_segs              = 20;
ids_def.ema.straight_label       = 'mib';
ids_def.ema.straight_number      = 4;
ids_def.ema.strength             = 1;

ids_def.manaca.label             = 'manaca';
ids_def.manaca.kicktable_file    = '../id_modelling/U19/U19_kicktable.txt';
ids_def.manaca.nr_segs           = 20;
ids_def.manaca.straight_label    = 'mib';
ids_def.manaca.straight_number   = 6;
ids_def.manaca.strength          = 1;

ids_def.carnauba.label           = 'carnauba';
ids_def.carnauba.kicktable_file  = '../id_modelling/U19/U19_kicktable.txt';
ids_def.carnauba.nr_segs         = 20;
ids_def.carnauba.straight_label  = 'mib';
ids_def.carnauba.straight_number = 3;
ids_def.carnauba.strength        = 1;

% --- phase 2 ---
ids_def.caterete2.label           = 'caterete2';
ids_def.caterete2.kicktable_file  = '../id_modelling/U19/U19_kicktable.txt';
ids_def.caterete2.nr_segs         = 20;
ids_def.caterete2.straight_label  = 'mib';
ids_def.caterete2.straight_number = 1;
ids_def.caterete2.strength        = 1;

ids_def.ema2.label                = 'ema2';
ids_def.ema2.kicktable_file       = '../id_modelling/U19/U19_kicktable.txt';
ids_def.ema2.nr_segs              = 20;
ids_def.ema2.straight_label       = 'mib';
ids_def.ema2.straight_number      = 2;
ids_def.ema2.strength             = 1;

ids_def.manaca2.label             = 'manaca2';
ids_def.manaca2.kicktable_file    = '../id_modelling/U19/U19_kicktable.txt';
ids_def.manaca2.nr_segs           = 20;
ids_def.manaca2.straight_label    = 'mib';
ids_def.manaca2.straight_number   = 7;
ids_def.manaca2.strength          = 1;

ids_def.carnauba2.label           = 'carnauba2';
ids_def.carnauba2.kicktable_file  = '../id_modelling/U19/U19_kicktable.txt';
ids_def.carnauba2.nr_segs         = 20;
ids_def.carnauba2.straight_label  = 'mib';
ids_def.carnauba2.straight_number = 8;
ids_def.carnauba2.strength        = 1;



% trechos impares - Betas Altos

% --- phase 1 ---
ids_def.jatoba.label             = 'jatoba';
ids_def.jatoba.kicktable_file    = '../id_modelling/SCW4T/SCW4T_kicktable.txt';
ids_def.jatoba.nr_segs           = 20;
ids_def.jatoba.straight_label    = 'mia';
ids_def.jatoba.straight_number   = 4;
ids_def.jatoba.strength          = 1;

ids_def.inga.label               = 'inga';
ids_def.inga.kicktable_file      = '../id_modelling/U25/U25_kicktable_4meters.txt';
ids_def.inga.nr_segs             = 40;
ids_def.inga.straight_label      = 'mia';
ids_def.inga.straight_number     = 5;
ids_def.inga.strength            = 2; % two IDs in series

ids_def.sabia.label              = 'sabia';
ids_def.sabia.kicktable_file     = '../id_modelling/EPU80/EPU80_PH_kicktable_5p4meters.txt';
ids_def.sabia.nr_segs            = 40;
ids_def.sabia.straight_label     = 'mia';
ids_def.sabia.straight_number    = 7;
ids_def.sabia.strength           = 2; % two IDs in series

ids_def.ipe.label                = 'ipe';
ids_def.ipe.kicktable_file       = '../id_modelling/EPU80/EPU80_PH_kicktable_5p4meters.txt';
ids_def.ipe.nr_segs              = 40;
ids_def.ipe.straight_label       = 'mia';
ids_def.ipe.straight_number      = 6;
ids_def.ipe.strength             = 2; % two IDs in series

% --- phase 2 ---
ids_def.inga2.label               = 'inga2';
ids_def.inga2.kicktable_file      = '../id_modelling/U25/U25_kicktable_4meters.txt';
ids_def.inga2.nr_segs             = 40;
ids_def.inga2.straight_label      = 'mia';
ids_def.inga2.straight_number     = 3;
ids_def.inga2.strength            = 2; % two IDs in series

ids_def.sabia2.label              = 'sabia2';
ids_def.sabia2.kicktable_file     = '../id_modelling/EPU80/EPU80_PH_kicktable_5p4meters.txt';
ids_def.sabia2.nr_segs            = 40;
ids_def.sabia2.straight_label     = 'mia';
ids_def.sabia2.straight_number    = 8;
ids_def.sabia2.strength           = 2; % two IDs in series

ids_def.ipe2.label                = 'ipe2';
ids_def.ipe2.kicktable_file       = '../id_modelling/EPU80/EPU80_PH_kicktable_5p4meters.txt';
ids_def.ipe2.nr_segs              = 40;
ids_def.ipe2.straight_label       = 'mia';
ids_def.ipe2.straight_number      = 9;
ids_def.ipe2.strength             = 2; % two IDs in series



function ids_def = create_ids_def_PH


ids_def.caterete.label           = 'caterete';
ids_def.caterete.kicktable_file  = '../id_modelling/U19/U19_kicktable.txt';
ids_def.caterete.nr_segs         = 20;
ids_def.caterete.straight_label  = 'mib';
ids_def.caterete.straight_number = 1;
ids_def.caterete.strength        = 1;

ids_def.ema.label           = 'ema';
ids_def.ema.kicktable_file  = '../id_modelling/U19/U19_kicktable.txt';
ids_def.ema.nr_segs         = 20;
ids_def.ema.straight_label  = 'mib';
ids_def.ema.straight_number = 2;
ids_def.ema.strength        = 1;

ids_def.manaca.label           = 'manaca';
ids_def.manaca.kicktable_file  = '../id_modelling/U19/U19_kicktable.txt';
ids_def.manaca.nr_segs         = 20;
ids_def.manaca.straight_label  = 'mib';
ids_def.manaca.straight_number = 3;
ids_def.manaca.strength        = 1;

ids_def.carnauba.label           = 'carnauba';
ids_def.carnauba.kicktable_file  = '../id_modelling/U19/U19_kicktable.txt';
ids_def.carnauba.nr_segs         = 20;
ids_def.carnauba.straight_label  = 'mib';
ids_def.carnauba.straight_number = 4;
ids_def.carnauba.strength        = 1;

% ids_def.jatoba.label           = 'jatoba';
% ids_def.jatoba.kicktable_file  = '../id_modelling/SCW4T/SCW4T_kicktable.txt';
% ids_def.jatoba.nr_segs         = 20;
% ids_def.jatoba.straight_label  = 'mib';
% ids_def.jatoba.straight_number = 6;
% ids_def.jatoba.strength        = 1;

ids_def.inga1.label           = 'inga1';
ids_def.inga1.kicktable_file  = '../id_modelling/U25/U25_kicktable.txt';
ids_def.inga1.nr_segs         = 20;
ids_def.inga1.straight_label  = 'mib';
ids_def.inga1.straight_number = 7;
ids_def.inga1.strength        = 1;

ids_def.inga2.label           = 'inga2';
ids_def.inga2.kicktable_file  = '../id_modelling/U25/U25_kicktable.txt';
ids_def.inga2.nr_segs         = 20;
ids_def.inga2.straight_label  = 'mib';
ids_def.inga2.straight_number = 8;
ids_def.inga2.strength        = 1;

ids_def.sabia1.label           = 'sabia1';
ids_def.sabia1.kicktable_file  = '../id_modelling/EPU80/EPU80_PH_kicktable.txt';
ids_def.sabia1.nr_segs         = 20;
ids_def.sabia1.straight_label  = 'mia';
ids_def.sabia1.straight_number = 4;
ids_def.sabia1.strength        = 1;

ids_def.sabia2.label           = 'sabia2';
ids_def.sabia2.kicktable_file  = '../id_modelling/EPU80/EPU80_PH_kicktable.txt';
ids_def.sabia2.nr_segs         = 20;
ids_def.sabia2.straight_label  = 'mia';
ids_def.sabia2.straight_number = 5;
ids_def.sabia2.strength        = 1;


ids_def.ipe1.label           = 'ipe1';
ids_def.ipe1.kicktable_file  = '../id_modelling/EPU80/EPU80_PH_kicktable.txt';
ids_def.ipe1.nr_segs         = 20;
ids_def.ipe1.straight_label  = 'mia';
ids_def.ipe1.straight_number = 6;
ids_def.ipe1.strength        = 1;

ids_def.ipe2.label           = 'ipe2';
ids_def.ipe2.kicktable_file  = '../id_modelling/EPU80/EPU80_PH_kicktable.txt';
ids_def.ipe2.nr_segs         = 20;
ids_def.ipe2.straight_label  = 'mia';
ids_def.ipe2.straight_number = 7;
ids_def.ipe2.strength        = 1;

ids_def.jatoba.label           = 'jatoba';
ids_def.jatoba.kicktable_file  = '../id_modelling/SCW4T/SCW4T_kicktable.txt';
ids_def.jatoba.nr_segs         = 20;
ids_def.jatoba.straight_label  = 'mia';
ids_def.jatoba.straight_number = 8;
ids_def.jatoba.strength        = 1;



function ids_def = create_ids_def_PH_old


ids_def.caterete.label           = 'caterete';
ids_def.caterete.kicktable_file  = '../id_modelling/U18/U18_kicktable.txt';
ids_def.caterete.nr_segs         = 20;
ids_def.caterete.straight_label  = 'mib';
ids_def.caterete.straight_number = 1;
ids_def.caterete.strength        = 1;

ids_def.mangabeira.label           = 'mangabeira';
ids_def.mangabeira.kicktable_file  = '../id_modelling/U18/U18_kicktable.txt';
ids_def.mangabeira.nr_segs         = 20;
ids_def.mangabeira.straight_label  = 'mib';
ids_def.mangabeira.straight_number = 2;
ids_def.mangabeira.strength        = 1;

ids_def.manaca.label           = 'manaca';
ids_def.manaca.kicktable_file  = '../id_modelling/U18/U18_kicktable.txt';
ids_def.manaca.nr_segs         = 20;
ids_def.manaca.straight_label  = 'mib';
ids_def.manaca.straight_number = 3;
ids_def.manaca.strength        = 1;

ids_def.carnauba.label           = 'carnauba';
ids_def.carnauba.kicktable_file  = '../id_modelling/U18/U18_kicktable.txt';
ids_def.carnauba.nr_segs         = 20;
ids_def.carnauba.straight_label  = 'mib';
ids_def.carnauba.straight_number = 4;
ids_def.carnauba.strength        = 1;


ids_def.w2t.label           = 'w2t';
ids_def.w2t.kicktable_file  = '../id_modelling/W2T/W2T_kicktable.txt';
ids_def.w2t.nr_segs         = 20;
ids_def.w2t.straight_label  = 'mib';
ids_def.w2t.straight_number = 5;
ids_def.w2t.strength        = 1;

ids_def.scw3t.label           = 'scw3t';
ids_def.scw3t.kicktable_file  = '../id_modelling/SCW3T/SCW3T_kicktable.txt';
ids_def.scw3t.nr_segs         = 20;
ids_def.scw3t.straight_label  = 'mib';
ids_def.scw3t.straight_number = 6;
ids_def.scw3t.strength        = 1;

ids_def.inga1.label           = 'inga1';
ids_def.inga1.kicktable_file  = '../id_modelling/U18/U18_kicktable.txt';
ids_def.inga1.nr_segs         = 20;
ids_def.inga1.straight_label  = 'mib';
ids_def.inga1.straight_number = 7;
ids_def.inga1.strength        = 1;

ids_def.inga2.label           = 'inga2';
ids_def.inga2.kicktable_file  = '../id_modelling/U18/U18_kicktable.txt';
ids_def.inga2.nr_segs         = 20;
ids_def.inga2.straight_label  = 'mib';
ids_def.inga2.straight_number = 8;
ids_def.inga2.strength        = 1;

ids_def.araucaria1.label           = 'araucaria1';
%ids_def.araucaria1.kicktable_file  = '../id_modelling/EPU50/EPU50_PV_kicktable.txt';
ids_def.araucaria1.kicktable_file  = '../id_modelling/EPU50/EPU50_PH_kicktable.txt';
ids_def.araucaria1.nr_segs         = 20;
ids_def.araucaria1.straight_label  = 'mia';
ids_def.araucaria1.straight_number = 4;
ids_def.araucaria1.strength        = 1;

ids_def.araucaria2.label           = 'araucaria2';
%ids_def.araucaria2.kicktable_file  = '../id_modelling/EPU200/EPU200_PV_kicktable.txt';
ids_def.araucaria2.kicktable_file  = '../id_modelling/EPU200/EPU200_PH_kicktable.txt';
ids_def.araucaria2.nr_segs         = 20;
ids_def.araucaria2.straight_label  = 'mia';
ids_def.araucaria2.straight_number = 5;
ids_def.araucaria2.strength        = 1;


ids_def.sibipiruna1.label           = 'sibipiruna1';
%ids_def.sibipiruna1.kicktable_file  = '../id_modelling/EPU50/EPU50_PV_kicktable.txt';
ids_def.sibipiruna1.kicktable_file  = '../id_modelling/EPU50/EPU50_PH_kicktable.txt';
ids_def.sibipiruna1.nr_segs         = 20;
ids_def.sibipiruna1.straight_label  = 'mia';
ids_def.sibipiruna1.straight_number = 6;
ids_def.sibipiruna1.strength        = 1;


ids_def.sibipiruna2.label           = 'sibipiruna2';
%ids_def.sibipiruna2.kicktable_file  = '../id_modelling/EPU200/EPU200_PV_kicktable.txt';
ids_def.sibipiruna2.kicktable_file  = '../id_modelling/EPU200/EPU200_PH_kicktable.txt';
ids_def.sibipiruna2.nr_segs         = 20;
ids_def.sibipiruna2.straight_label  = 'mia';
ids_def.sibipiruna2.straight_number = 7;
ids_def.sibipiruna2.strength        = 1;

function ids_def = create_ids_def_PV_old


ids_def.caterete.label           = 'caterete';
ids_def.caterete.kicktable_file  = '../id_modelling/U18/U18_kicktable.txt';
ids_def.caterete.nr_segs         = 20;
ids_def.caterete.straight_label  = 'mib';
ids_def.caterete.straight_number = 1;
ids_def.caterete.strength        = 1;

ids_def.mangabeira.label           = 'mangabeira';
ids_def.mangabeira.kicktable_file  = '../id_modelling/U18/U18_kicktable.txt';
ids_def.mangabeira.nr_segs         = 20;
ids_def.mangabeira.straight_label  = 'mib';
ids_def.mangabeira.straight_number = 2;
ids_def.mangabeira.strength        = 1;

ids_def.manaca.label           = 'manaca';
ids_def.manaca.kicktable_file  = '../id_modelling/U18/U18_kicktable.txt';
ids_def.manaca.nr_segs         = 20;
ids_def.manaca.straight_label  = 'mib';
ids_def.manaca.straight_number = 3;
ids_def.manaca.strength        = 1;

ids_def.carnauba.label           = 'carnauba';
ids_def.carnauba.kicktable_file  = '../id_modelling/U18/U18_kicktable.txt';
ids_def.carnauba.nr_segs         = 20;
ids_def.carnauba.straight_label  = 'mib';
ids_def.carnauba.straight_number = 4;
ids_def.carnauba.strength        = 1;


ids_def.w2t.label           = 'w2t';
ids_def.w2t.kicktable_file  = '../id_modelling/W2T/W2T_kicktable.txt';
ids_def.w2t.nr_segs         = 20;
ids_def.w2t.straight_label  = 'mib';
ids_def.w2t.straight_number = 5;
ids_def.w2t.strength        = 1;

ids_def.scw3t.label           = 'scw3t';
ids_def.scw3t.kicktable_file  = '../id_modelling/SCW3T/SCW3T_kicktable.txt';
ids_def.scw3t.nr_segs         = 20;
ids_def.scw3t.straight_label  = 'mib';
ids_def.scw3t.straight_number = 6;
ids_def.scw3t.strength        = 1;

ids_def.inga1.label           = 'inga1';
ids_def.inga1.kicktable_file  = '../id_modelling/U18/U18_kicktable.txt';
ids_def.inga1.nr_segs         = 20;
ids_def.inga1.straight_label  = 'mib';
ids_def.inga1.straight_number = 7;
ids_def.inga1.strength        = 1;

ids_def.inga2.label           = 'inga2';
ids_def.inga2.kicktable_file  = '../id_modelling/U18/U18_kicktable.txt';
ids_def.inga2.nr_segs         = 20;
ids_def.inga2.straight_label  = 'mib';
ids_def.inga2.straight_number = 8;
ids_def.inga2.strength        = 1;

ids_def.araucaria1.label           = 'araucaria1';
%ids_def.araucaria1.kicktable_file  = '../id_modelling/EPU50/EPU50_PV_kicktable.txt';
ids_def.araucaria1.kicktable_file  = '../id_modelling/EPU50/EPU50_PH_kicktable.txt';
ids_def.araucaria1.nr_segs         = 20;
ids_def.araucaria1.straight_label  = 'mia';
ids_def.araucaria1.straight_number = 4;
ids_def.araucaria1.strength        = 1;

ids_def.araucaria2.label           = 'araucaria2';
ids_def.araucaria2.kicktable_file  = '../id_modelling/EPU200/EPU200_PV_kicktable.txt';
%ids_def.araucaria2.kicktable_file  = '../id_modelling/EPU200/EPU200_PH_kicktable.txt';
ids_def.araucaria2.nr_segs         = 20;
ids_def.araucaria2.straight_label  = 'mia';
ids_def.araucaria2.straight_number = 5;
ids_def.araucaria2.strength        = 1;


ids_def.sibipiruna1.label           = 'sibipiruna1';
ids_def.sibipiruna1.kicktable_file  = '../id_modelling/EPU50/EPU50_PV_kicktable.txt';
%ids_def.sibipiruna1.kicktable_file  = '../id_modelling/EPU50/EPU50_PH_kicktable.txt';
ids_def.sibipiruna1.nr_segs         = 20;
ids_def.sibipiruna1.straight_label  = 'mia';
ids_def.sibipiruna1.straight_number = 6;
ids_def.sibipiruna1.strength        = 1;


ids_def.sibipiruna2.label           = 'sibipiruna2';
ids_def.sibipiruna2.kicktable_file  = '../id_modelling/EPU200/EPU200_PV_kicktable.txt';
%ids_def.sibipiruna2.kicktable_file  = '../id_modelling/EPU200/EPU200_PH_kicktable.txt';
ids_def.sibipiruna2.nr_segs         = 20;
ids_def.sibipiruna2.straight_label  = 'mia';
ids_def.sibipiruna2.straight_number = 7;
ids_def.sibipiruna2.strength        = 1;

function ids_def = create_ids_def_PC_old


ids_def.caterete.label           = 'caterete';
ids_def.caterete.kicktable_file  = '../id_modelling/U18/U18_kicktable.txt';
ids_def.caterete.nr_segs         = 20;
ids_def.caterete.straight_label  = 'mib';
ids_def.caterete.straight_number = 1;
ids_def.caterete.strength        = 1;

ids_def.mangabeira.label           = 'mangabeira';
ids_def.mangabeira.kicktable_file  = '../id_modelling/U18/U18_kicktable.txt';
ids_def.mangabeira.nr_segs         = 20;
ids_def.mangabeira.straight_label  = 'mib';
ids_def.mangabeira.straight_number = 2;
ids_def.mangabeira.strength        = 1;

ids_def.manaca.label           = 'manaca';
ids_def.manaca.kicktable_file  = '../id_modelling/U18/U18_kicktable.txt';
ids_def.manaca.nr_segs         = 20;
ids_def.manaca.straight_label  = 'mib';
ids_def.manaca.straight_number = 3;
ids_def.manaca.strength        = 1;

ids_def.carnauba.label           = 'carnauba';
ids_def.carnauba.kicktable_file  = '../id_modelling/U18/U18_kicktable.txt';
ids_def.carnauba.nr_segs         = 20;
ids_def.carnauba.straight_label  = 'mib';
ids_def.carnauba.straight_number = 4;
ids_def.carnauba.strength        = 1;


ids_def.w2t.label           = 'w2t';
ids_def.w2t.kicktable_file  = '../id_modelling/W2T/W2T_kicktable.txt';
ids_def.w2t.nr_segs         = 20;
ids_def.w2t.straight_label  = 'mib';
ids_def.w2t.straight_number = 5;
ids_def.w2t.strength        = 1;

ids_def.scw3t.label           = 'scw3t';
ids_def.scw3t.kicktable_file  = '../id_modelling/SCW3T/SCW3T_kicktable.txt';
ids_def.scw3t.nr_segs         = 20;
ids_def.scw3t.straight_label  = 'mib';
ids_def.scw3t.straight_number = 6;
ids_def.scw3t.strength        = 1;

ids_def.inga1.label           = 'inga1';
ids_def.inga1.kicktable_file  = '../id_modelling/U18/U18_kicktable.txt';
ids_def.inga1.nr_segs         = 20;
ids_def.inga1.straight_label  = 'mib';
ids_def.inga1.straight_number = 7;
ids_def.inga1.strength        = 1;

ids_def.inga2.label           = 'inga2';
ids_def.inga2.kicktable_file  = '../id_modelling/U18/U18_kicktable.txt';
ids_def.inga2.nr_segs         = 20;
ids_def.inga2.straight_label  = 'mib';
ids_def.inga2.straight_number = 8;
ids_def.inga2.strength        = 1;

ids_def.araucaria1.label           = 'araucaria1';
%ids_def.araucaria1.kicktable_file  = '../id_modelling/EPU50/EPU50_PV_kicktable.txt';
%ids_def.araucaria1.kicktable_file  = '../id_modelling/EPU50/EPU50_PH_kicktable.txt';
ids_def.araucaria1.kicktable_file  = '../id_modelling/EPU50/EPU50_PC_kicktable.txt';
ids_def.araucaria1.nr_segs         = 20;
ids_def.araucaria1.straight_label  = 'mia';
ids_def.araucaria1.straight_number = 4;
ids_def.araucaria1.strength        = 1;

ids_def.araucaria2.label           = 'araucaria2';
%ids_def.araucaria2.kicktable_file = '../id_modelling/EPU200/EPU200_PV_kicktable.txt';
%ids_def.araucaria2.kicktable_file = '../id_modelling/EPU200/EPU200_PH_kicktable.txt';
ids_def.araucaria2.kicktable_file  = '../id_modelling/EPU200/EPU200_PC_kicktable.txt';
ids_def.araucaria2.nr_segs         = 20;
ids_def.araucaria2.straight_label  = 'mia';
ids_def.araucaria2.straight_number = 5;
ids_def.araucaria2.strength        = 1;


ids_def.sibipiruna1.label           = 'sibipiruna1';
%ids_def.sibipiruna1.kicktable_file = '../id_modelling/EPU50/EPU50_PV_kicktable.txt';
%ids_def.sibipiruna1.kicktable_file = '../id_modelling/EPU50/EPU50_PH_kicktable.txt';
ids_def.sibipiruna1.kicktable_file  = '../id_modelling/EPU50/EPU50_PC_kicktable.txt';
ids_def.sibipiruna1.nr_segs         = 20;
ids_def.sibipiruna1.straight_label  = 'mia';
ids_def.sibipiruna1.straight_number = 6;
ids_def.sibipiruna1.strength        = 1;


ids_def.sibipiruna2.label           = 'sibipiruna2';
%ids_def.sibipiruna2.kicktable_file = '../id_modelling/EPU200/EPU200_PV_kicktable.txt';
%ids_def.sibipiruna2.kicktable_file = '../id_modelling/EPU200/EPU200_PH_kicktable.txt';
ids_def.sibipiruna2.kicktable_file  = '../id_modelling/EPU200/EPU200_PC_kicktable.txt';
ids_def.sibipiruna2.nr_segs         = 20;
ids_def.sibipiruna2.straight_label  = 'mia';
ids_def.sibipiruna2.straight_number = 7;
ids_def.sibipiruna2.strength        = 1;

