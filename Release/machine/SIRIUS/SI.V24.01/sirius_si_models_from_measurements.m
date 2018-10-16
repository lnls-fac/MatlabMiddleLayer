function the_ring = sirius_si_models_from_measurements(the_ring0)

the_ring = the_ring0;
% the_ring = models_from_measurements_dipoles(the_ring);
% the_ring = models_from_measurements_quadrupoles_qf(the_ring);
% the_ring = models_from_measurements_quadrupoles_qd(the_ring);
% the_ring = models_from_measurements_correctors_ch(the_ring);
% the_ring = models_from_measurements_correctors_cv(the_ring);
the_ring = correct_optics(the_ring);


function the_ring = models_from_measurements_dipoles(the_ring0)

% OUT OD DATE: FROM BOOSTER! NEEDS UPDATING

the_ring = the_ring0;

data = sirius_bo_family_data(the_ring);
idx = data.B.ATIndex;

[tpath, ~, ~] = fileparts(mfilename('fullpath'));
sorting = sirius_excdata.importfile_sorting(fullfile(tpath, 'models', 'dipoles', 'sorting.txt'));

d2r = pi / 180.0;
ang_nominal = 7.2;

% get dipole nominal model
model_sim = [ getcellstruct(the_ring, 'Length', idx(1,:)), getcellstruct(the_ring, 'BendingAngle', idx(1,:)) / d2r];
    
for i=1:length(sorting)
    % load instance of dipole model
    maglabel = fullfile(tpath, 'models', 'dipoles', [lower(sorting{i}), '-3gev']);
    [harms, model, ~, ~, ~] = sirius_excdata.load_fmap_model(maglabel);
    if length(the_ring{idx(i, 1)}.PolynomB) ~= length(harms)
        error('Incompatible PolynomB and dipole model!')
    end
    % redistribute deflection angle, as compared in model segments
    ang_error = model(1, 3) * model(1, 1) + model(end, 3) * model(end, 1); % angle missing from segmodel
    ang_total = ang_nominal + ang_error / d2r; % total angle of dipole instance
    ang_segs = model(:,2) * (ang_total / ang_nominal); % renormalize sigment angles according to tot angle
    dang = ang_segs - model_sim(:,2); % difference between dipole instance and nominal dipole segment angles
    dpolB = (dang * d2r) ./ model(:,1); % converted to polynomB
    for j=1:size(idx,2)
        the_ring{idx(i, j)}.PolynomB = model(j,3:end); % higher-order multipoles from instance dipole (quad, sext, ...)
        the_ring{idx(i, j)}.PolynomB(1) = dpolB(j); % dipolar errors applied to segments
    end
end

function the_ring = models_from_measurements_quadrupoles_qf(the_ring0)

% OUT OD DATE: FROM BOOSTER! NEEDS UPDATING

the_ring = the_ring0;

data = sirius_bo_family_data(the_ring);
idx = data.QF.ATIndex;

[tpath, ~, ~] = fileparts(mfilename('fullpath'));
sorting = sirius_excdata.importfile_sorting(fullfile(tpath, 'models', 'quadrupoles-qf', 'sorting.txt'));

fname = fullfile(tpath, 'models', 'quadrupoles-qf', 'README-110A.md');
[~, kls_3gev] = load_readme_file(fname, 'BQF-');

fname = fullfile(tpath, 'models', 'quadrupoles-qf', 'README-4A.md');
[mags, kls_150mev] = load_readme_file(fname, 'BQF-');

e = the_ring{1}.Energy;
kls = kls_150mev + (e - 150e6) * (kls_3gev - kls_150mev) / (3e9 - 150e6);

kls_avg = mean(kls);
    
for i=1:length(sorting)
    for id=1:length(mags)
        if strcmp(mags{id}, sorting{i})
            break;
        end
    end
    k_i = kls(id);
    for j=1:size(idx,2)
        k_old = the_ring{idx(i, j)}.PolynomB(2);    
        k_new = k_old * (k_i / kls_avg);
        the_ring{idx(i, j)}.PolynomB(2) = k_new;
    end
end

function the_ring = models_from_measurements_quadrupoles_qd(the_ring0)

% OUT OD DATE: FROM BOOSTER! NEEDS UPDATING

the_ring = the_ring0;

data = sirius_bo_family_data(the_ring);
idx = data.QD.ATIndex;

[tpath, ~, ~] = fileparts(mfilename('fullpath'));
sorting = sirius_excdata.importfile_sorting(fullfile(tpath, 'models', 'quadrupoles-qd', 'sorting.txt'));

fname = fullfile(tpath, 'models', 'quadrupoles-qd', 'README-2A.md');
[mags, kls] = load_readme_file(fname, 'BQD-');

kls_avg = mean(kls);
    
for i=1:length(sorting)
    for id=1:length(mags)
        if strcmp(mags{id}, sorting{i})
            break;
        end
    end
    k_i = kls(id);
    for j=1:size(idx,2)
        k_old = the_ring{idx(i, j)}.PolynomB(2);    
        k_new = k_old * (k_i / kls_avg);
        the_ring{idx(i, j)}.PolynomB(2) = k_new;
    end
end

function the_ring = models_from_measurements_correctors_ch(the_ring0)

% OUT OD DATE: FROM BOOSTER! NEEDS UPDATING

the_ring = the_ring0;

function the_ring = models_from_measurements_correctors_cv(the_ring0)

% OUT OD DATE: FROM BOOSTER! NEEDS UPDATING

% should use the same data as in correctors_ch but rotated 90 degrees.
% C'_n = (-i)^(n+1) C_n
% where C_n = (B_n + i A_n)

the_ring = the_ring0;

function the_ring = correct_optics(the_ring0)

% goal tunes ans chroms as calculated with calctwiss, not atsummary!
goal_tunes = [49.09624, 14.15188];
goal_chrom = [2.58, 2.50];
the_ring = the_ring0;

fams_chrom = {'SDA1', 'SDA2', 'SDA3', 'SFA1', 'SFA2', ...
              'SDB1', 'SDB2', 'SDB3', 'SFB1', 'SFB2', ...
              'SDP1', 'SDP2', 'SDP3', 'SFP1', 'SFP2'};
fams_tunes = {'QDA','QFA','QDB1','QDB2','QFB','QDP1','QDP2','QFP'};

tw1 = calctwiss(the_ring);
corrected = false;
while any(abs([tw1.mux(end), tw1.muy(end)]/2/pi - goal_tunes) > 0.00001) || any(abs([tw1.chromx, tw1.chromy] - goal_chrom) > 0.04)
    corrected = true;
    the_ring = lnls_correct_chrom(the_ring, goal_chrom, fams_chrom);
    [the_ring, conv, t2, t1] = lnls_correct_tunes(the_ring, goal_tunes, fams_tunes, 'svd', 'add', 10, 1e-9);
    tw1 = calctwiss(the_ring);
end

if corrected
    fprintf('   Tunes and Chromaticities corrected!\n');
    for i=1:length(fams_tunes)
        idx = findcells(the_ring, 'FamName', fams_tunes{i});
        fprintf('   %s_strength = %+.14f;\n', fams_tunes{i}, the_ring{idx(1)}.PolynomB(2));
    end
    for i=1:length(fams_chrom)
        idx = findcells(the_ring, 'FamName', fams_chrom{i});
        fprintf('   %s_strength = %+.14f;\n', fams_chrom{i}, the_ring{idx(1)}.PolynomB(3));
    end
end

function [mags, kls] = load_readme_file(filename, substr)

fp = fopen(filename, 'rt');
text = textscan(fp, '%s', 'Delimiter', '\n');
text = text{1};
mags = {};
kls = [];
for i=1:length(text)
    line = text{i};
    if ~isempty(strfind(line, substr))
        words = strsplit(line, ' ');
        mags{end+1} = words{1};
        kls(end+1) = str2double(words{5});
    end
end
