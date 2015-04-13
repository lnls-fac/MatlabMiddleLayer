function r = lnls_optimize_dynapt(the_ring)

clc;

result_fname = 'result0000.mat';
try rmappdata(0, 'TuneRespM'); catch end;

if ~exist(result_fname,'file')
    
    if ~exist('the_ring','var')
        global THERING;
        THERING = sirius_si_lattice('AC20');
        the_ring = THERING;
    end
    
    % input parameters
    r.the_ring  = the_ring;
    
    r.ucell.beg_fname = 'mia';
    r.ucell.beg_idx   = 1;
    r.ucell.end_fname = 'mib';
    r.ucell.end_idx   = 1;
    
    %r.tune_correctors = {'qaf', 'qbd2', 'qbf', 'qbd1', 'qad'};
    r.tune_correctors = {'qaf', 'qbf', 'qbd1', 'qad'};
    
    r.knobs_pos.labels = {'sa1','sd1','sf1','sd2','sb1','sb2','sd3','sf2'};
    r.knobs_pos.nrsegs = [1 1 1 1 1 1 1 1];
    r.knobs_sxt.labels = {'sa2','sa1','sd1','sf1','sd2','sb1','sb2','sd3','sf2'};
    r.knobs_sxt.nrsegs = [1 1 1 1 1 1 1 1 1];
    r.knobs_sxt.func   = @constraints_mode_AC20;
     
    r.ucell = get_ucell_line(r.the_ring, r.ucell);
    r.knobs_sxt.idx = calc_indices(r.ucell, r.knobs_sxt);
    r.knobs_pos.idx = calc_indices(r.ucell, r.knobs_pos);
    
    r.the_ring = create_the_ring(r);
    r = search_dynapt(r);
    
    save(['result' num2str(0, '%04i') '.mat'], 'r');
    
else
    data = load(result_fname);
    r = data.r;
end

global THERING;
respm = calc_tune_respm(THERING, r.tune_correctors);

r.dynapt.quiet_mode = true;


iter = 0;
fprintf(['%03i: %8.3f   (%8.3f %8.3f %8.3f) mm^2, '  datestr(now, '[HH:MM:SS]\n')], iter, r.da_area, r.dynapt.da_area);
while (true)
    iter = iter + 1;
    r_new = change_machine(r);
    r_new = search_dynapt(r_new);
    if (r_new.da_area > r.da_area)
        r = r_new;
        save(['result' num2str(iter, '%04i') '.mat'], 'r');
    else
    end
    fprintf(['%03i: %8.3f %8.3f*   (%8.3f %8.3f %8.3f) mm^2, '  datestr(now, '[HH:MM:SS]\n')], iter, r_new.da_area, r.da_area, r.dynapt.da_area);
end


r = search_dynapt(r);

function r = change_machine(r0)

r = r0;
r = change_sextupoles_strength(r);
r = change_sextupoles_position(r);
r = r.knobs_sxt.func(r);
r = change_tunes(r);
r = correct_chromaticity(r);


function r = constraints_mode_AC20(r0)

r = r0;

% SB1 == SA1
idx = findcells(r.ucell.line, 'FamName', 'sa1');
S = getcellstruct(r.ucell.line, 'PolynomB', idx, 1, 3);
idx = findcells(r.ucell.line, 'FamName', 'sb1');
r.ucell.line = setcellstruct(r.ucell.line, 'PolynomB', idx, S(1), 1, 3);
% SB2 == SA2
idx = findcells(r.ucell.line, 'FamName', 'sa2');
S = getcellstruct(r.ucell.line, 'PolynomB', idx, 1, 3);
idx = findcells(r.ucell.line, 'FamName', 'sb2');
r.ucell.line = setcellstruct(r.ucell.line, 'PolynomB', idx, S(1), 1, 3);

r.the_ring = create_the_ring(r);


function r = search_dynapt(r0)

global THERING

r = r0;
THERING = r.the_ring;

if ~isfield(r, 'dynapt')
    
    dynapt.energy_deviation  = [-0.03 0 0.03];
    dynapt.quiet_mode = true;
    
    % finesse #1
    dynapt.radius_resolution = 0.001;
    dynapt.nr_turns          = 256;
    for i=1:length(dynapt.energy_deviation)
        dynapt.points_angle(i,:)  = linspace(0, pi, 9);
        dynapt.points_radius(i,:) = sqrt((0.015 * cos(dynapt.points_angle(i,:))).^2 + (0.006 * sin(dynapt.points_angle(i,:))).^2);
    end
    dynapt = lnls_dynapt(dynapt);
    
    % finesse #2
    dynapt.radius_resolution = 0.0005;
    for i=1:length(dynapt.energy_deviation)
        dynapt.new_points_angle(i,:)  = linspace(0, pi, 17);
    end
    dynapt = lnls_dynapt(dynapt);
    r.dynapt = dynapt;
end


% finesse #3
dynapt = r.dynapt;
dynapt.radius_resolution = 0.00025;
dynapt.nr_turns          = 512;
for i=1:length(dynapt.energy_deviation)
    dynapt.new_points_angle(i,:)  = linspace(0, pi, 33);
end
r.dynapt = lnls_dynapt(dynapt);

r.da_area = prod(r.dynapt.da_area)^(1/3);

function r = change_sextupoles_strength(r0)

str_step_size = 1; % [1/m^3]

r = r0;
for i=1:length(r.knobs_sxt.labels)
    idx = r.knobs_sxt.idx{i}(:);
    % strength
    idx_flat = idx(:);
    S0 = getcellstruct(r.ucell.line, 'PolynomB', idx_flat, 1, 3);
    dS = str_step_size * 2 * (rand - 0.5);
    Sf = S0 + dS;
    r.ucell.line = setcellstruct(r.ucell.line, 'PolynomB', idx_flat, Sf, 1, 3);
end
r.the_ring = create_the_ring(r);


function r = change_sextupoles_position(r0)

len_step_size = 5; %   [%]

r = r0;
for i=1:length(r.knobs_pos.labels)
    idx = r.knobs_pos.idx{i}(:);
    % position
    for j=1:size(idx,1)
        idx_flat = idx(j,:);
        idx1 = idx_flat(1)-1;   % upstream drift index
        idx2 = idx_flat(end)+1; % downstream drift index
        len1 = r.ucell.line{idx1}.Length;
        len2 = r.ucell.line{idx2}.Length;
        % changes upstream and downstream drifts
        len1l = len1 * (1 + (len_step_size/100) * 2 * (rand - 0.5));
        len2l = len2 * (1 + (len_step_size/100) * 2 * (rand - 0.5));
        % norms lengths so that (len1l + len2l) = (len1 + len2)
        corre = (len1 + len2) / (len1l + len2l);
        len1l = len1l * corre;
        len2l = len2l * corre;
        % sets new lengths
        r.ucell.line{idx1}.Length = len1l;
        r.ucell.line{idx2}.Length = len2l;
    end
end
r.the_ring = create_the_ring(r);


function r = change_tunes(r0)

r = r0;

tune_step = 0.005;

respm = getappdata(0, 'TuneRespM');
if isempty(respm)
    respm = calc_tune_respm(r.the_ring, r.tune_correctors);
    setappdata(0, 'TuneRespM', respm);
end

dtune = tune_step * 2 * (rand(2,1) - 0.5);
dK = respm.C * dtune;
for i=1:length(dK)
    idx = findcells(r.ucell.line, 'FamName', r.tune_correctors{i});
    K0 = getcellstruct(r.ucell.line, 'K', idx);
    K  = K0 + dK(i);
    r.ucell.line = setcellstruct(r.ucell.line, 'K', idx, K);
    r.ucell.line = setcellstruct(r.ucell.line, 'PolynomB', idx, K, 1, 2);
end
r.the_ring = create_the_ring(r);






function respm = calc_tune_respm(the_ring, quad_families)

step_k = 0.001;
M = zeros(2, length(quad_families));
for i=1:length(quad_families)
    idx = findcells(the_ring, 'FamName', quad_families{i});
    K0 = getcellstruct(the_ring, 'K', idx);
    % negative step
    K  = K0 - step_k/2;
    the_ring = setcellstruct(the_ring, 'K', idx, K);
    the_ring = setcellstruct(the_ring, 'PolynomB', idx, K, 1, 2);
    r = calctwiss(the_ring); t1 = [r.mux(end); r.muy(end)]/2/pi; 
    % positive step
    K  = K0 + step_k/2;
    the_ring = setcellstruct(the_ring, 'K', idx, K);
    the_ring = setcellstruct(the_ring, 'PolynomB', idx, K, 1, 2);
    r = calctwiss(the_ring); t2 = [r.mux(end); r.muy(end)]/2/pi;
    % restore condition
    the_ring = setcellstruct(the_ring, 'K', idx, K0);
    the_ring = setcellstruct(the_ring, 'PolynomB', idx, K0, 1, 2);
    
    M(:,i) = (t2 - t1) / step_k;
end
[U,S,V] = svd(M, 'econ');
respm.M = M;
respm.U = U;
respm.S = S;
respm.V = V;
iS = pinv(S);
respm.C = -(V*iS*U');

function r = correct_chromaticity(r0)

global THERING;

r = r0;

THERING = r.the_ring;
fitchrom2([0 0], 'sd1', 'sf1');
fitchrom2([0 0], 'sd1', 'sf1');
fitchrom2([0 0], 'sd1', 'sf1');
r.the_ring = THERING;


function idx = calc_indices(ucell, knobs)

for i=1:length(knobs.labels)
    idx_tmp = findcells(ucell.line, 'FamName', knobs.labels{i});
    idx{i} = reshape(idx_tmp, [], knobs.nrsegs(i));
end

function the_ring = create_the_ring(r)

line = r.ucell.line;
the_ring = [line fliplr(line)];
the_ring = repmat(the_ring, 1, 10);
%the_ring = lnls_simplify_lattice(the_ring, 'CORout');

function ucell = get_ucell_line(the_ring, ucell0)

ucell = ucell0;
beg_idx = findcells(the_ring, 'FamName', ucell.beg_fname);
end_idx = findcells(the_ring, 'FamName', ucell.end_fname);
idx     = beg_idx(ucell.beg_idx):end_idx(ucell.end_idx);
line    = the_ring(idx);
ucell.line = line;

ucell.line = lnls_simplify_lattice(ucell.line, 'CORout');


idx1 = findcells(line, 'PolynomB');
idx2 = findcells(line, 'K');
idx3 = findcells(line, 'BendingAngle');
ucell.sxt_idx = setdiff(idx1, [idx2 idx3]);

