function sirius_bo_create_excitation_files

% SD
currs = {'2A', '4A', '6A', '8A', '10A', '30A', '50A', '70A', '90A', '110A', '130A', '150A'};
read_multipole_files(currs, 'SD', 'sextupoles', 'BS-');
mpole_inv_polarity('SD');
currents = [0, 2, 4, 6, 8, 10, 30, 50, 70, 90, 110, 130, 150];
[sorting, currents, harmonics, n_avg, s_avg, n_std, s_std] = calc_excitation_stats(currents, 'SD', 'sextupoles', 'sorting-sd.txt', 1);
[currents, n_avg, s_avg, n_std, s_std] = mpoles_add_negative_currents(currents, n_avg, s_avg, n_std, s_std);
save_excdata(sorting, 'bo-sextupole-sd-fam', currents, '2 normal', harmonics, n_avg, s_avg, n_std, s_std);

% SF
currs = {'2A', '4A', '6A', '8A', '10A', '30A', '50A', '70A', '90A', '110A', '130A', '150A'};
read_multipole_files(currs, 'SF', 'sextupoles', 'BS-');
currents = [0, 2, 4, 6, 8, 10, 30, 50, 70, 90, 110, 130, 150];
[sorting, currents, harmonics, n_avg, s_avg, n_std, s_std] = calc_excitation_stats(currents, 'SF', 'sextupoles', 'sorting-sf.txt', 1);
save_excdata(sorting, 'bo-sextupole-sf-fam', currents, '2 normal', harmonics, n_avg, s_avg, n_std, s_std);


% CV
currs = {
    'CH_01_-10A', 'CH_02_-9A', 'CH_03_-7A', 'CH_04_-5A', 'CH_05_-3A', ...
    'CH_06_-1A',  'CH_07_+0A', 'CH_08_+1A', 'CH_09_+3A', 'CH_10_+5A', ...
    'CH_11_+7A', 'CH_12_+9A', 'CH_13_+10A'
};
read_multipole_files(currs, 'CV', 'correctors', 'BC-');
mpole_rot_z_p90('CV');
currents = [-10, -9, -7, -5, -3, -1, 0, 1, 3, 5, 7, 9, 10];
[sorting, currents, harmonics, n_avg, s_avg, n_std, s_std] = calc_excitation_stats(currents, 'CV', 'correctors', 'sorting-cv.txt', 7);
save_excdata(sorting, 'bo-correctors-cv', currents, '0 skew', harmonics, n_avg, s_avg, n_std, s_std);

% CH
currs = {
    'CH_01_-10A', 'CH_02_-9A', 'CH_03_-7A', 'CH_04_-5A', 'CH_05_-3A', ...
    'CH_06_-1A',  'CH_07_+0A', 'CH_08_+1A', 'CH_09_+3A', 'CH_10_+5A', ...
    'CH_11_+7A', 'CH_12_+9A', 'CH_13_+10A'
};
read_multipole_files(currs, 'CH', 'correctors', 'BC-');
currents = [-10, -9, -7, -5, -3, -1, 0, 1, 3, 5, 7, 9, 10];
[sorting, currents, harmonics, n_avg, s_avg, n_std, s_std] = calc_excitation_stats(currents, 'CH', 'correctors', 'sorting-ch.txt', 7);
save_excdata(sorting, 'bo-correctors-ch', currents, '0 normal', harmonics, n_avg, s_avg, n_std, s_std);

% QD
currs = {'2A', '4A', '6A', '8A', '10A', '20A', '32A'};
read_multipole_files(currs, 'QD', 'quadrupoles-qd', 'BQD-');
mpole_inv_polarity('QD');
currents = [0, 2, 4, 6, 8, 10, 20, 32];
[sorting, currents, harmonics, n_avg, s_avg, n_std, s_std] = calc_excitation_stats(currents, 'QD', 'quadrupoles-qd', 'sorting.txt', 1);
[currents, n_avg, s_avg, n_std, s_std] = mpoles_add_negative_currents(currents, n_avg, s_avg, n_std, s_std);
save_excdata(sorting, 'bo-quadrupole-qd-fam', currents, '1 normal', harmonics, n_avg, s_avg, n_std, s_std);

% QF
currs = {'2A', '4A', '6A', '8A', '10A', '30A', '50A', '70A', '90A', '110A', '130A'};
read_multipole_files(currs, 'QF', 'quadrupoles-qf', 'BQF-');
currents = [0, 2, 4, 6, 8, 10, 30, 50, 70, 90, 110, 130];
[sorting, currents, harmonics, n_avg, s_avg, n_std, s_std] = calc_excitation_stats(currents, 'QF', 'quadrupoles-qf', 'sorting.txt', 1);
save_excdata(sorting, 'bo-quadrupole-qf-fam', currents, '1 normal', harmonics, n_avg, s_avg, n_std, s_std);


function save_excdata(sorting, fname, currents, main_mpole, harmonics, n_avg, s_avg, n_std, s_std)

% currs = {'2A', '4A', '6A', '8A', '10A', '30A', '50A', '70A', '90A', '110A', '130A', '150A'}; 
header = excdata_file_header(fname, harmonics, main_mpole);
[data_avg, data_std] = excdata_table(currents, n_avg, s_avg, n_std, s_std);
comments = excdata_file_comments(sorting);
poltable = excdata_file_polarity_table;
filefmt = excdata_fileformat;

fname = strrep(fname, 'correctors', 'corrector');

% save avg multipoles
fp = fopen([fname, '.txt'], 'w');
for i=1:length(header)
    fprintf(fp, [header{i}, '\n']);
end
for i=1:length(data_avg)
    fprintf(fp, [data_avg{i}, '\n']);
end
for i=1:length(comments)
    fprintf(fp, [comments{i}, '\n']);
end
for i=1:length(poltable)
    fprintf(fp, [poltable{i}, '\n']);
end
for i=1:length(filefmt)
    fprintf(fp, [filefmt{i}, '\n']);
end
fclose(fp);

% save std multipoles
fp = fopen([fname, '-std', '.txt'], 'w');
for i=1:length(header)
    fprintf(fp, [header{i}, '\n']);
end
for i=1:length(data_avg)
    fprintf(fp, [data_std{i}, '\n']);
end
for i=1:length(comments)
    fprintf(fp, [comments{i}, '\n']);
end
for i=1:length(poltable)
    fprintf(fp, [poltable{i}, '\n']);
end
for i=1:length(filefmt)
    fprintf(fp, [filefmt{i}, '\n']);
end
fclose(fp);

function [sorting, currents, harmonics, n_avg, s_avg, n_std, s_std] = calc_excitation_stats(currents, mag_field, mag_type, sorting_fname, index)

% load list of used magnets
[tpath, ~, ~] = fileparts(mfilename('fullpath'));
fname = fullfile(tpath, 'models', mag_type, sorting_fname);
sorting = sirius_bo_importfile_sorting(fname);

% read rotcoil data
rotcoil = getappdata(0, 'rotcoil');
harmonics = rotcoil.(mag_field).harms;
mags = rotcoil.(mag_field).mags;

% create list with all data
c = zeros(1,length(rotcoil.(mag_field).currents));
n = zeros(length(rotcoil.(mag_field).currents), size(rotcoil.(mag_field).nmpoles{1}, 2));
s = zeros(length(rotcoil.(mag_field).currents), size(rotcoil.(mag_field).smpoles{1}, 2));
n_all = {}; s_all = {};
for k=1:length(currents)
    n_all{end+1} = []; s_all{end+1} = [];
end
for i=1:length(mags)
    % continue, if mag not in sorting
    if ~any(strcmp(rotcoil.(mag_field).mags{i}, sorting))
        continue;
    end
    % build c, n, s for interpolation
    for j=1:length(rotcoil.(mag_field).currents)
        c(j) = rotcoil.(mag_field).currents{j}(i);
        n(j,:) = rotcoil.(mag_field).nmpoles{j}(i,:);
        s(j,:) = rotcoil.(mag_field).smpoles{j}(i,:);
    end
    % interpolate for currents set
    for k=1:length(currents)
        mn = interp1(c, n, currents(k), 'linear', 'extrap');
        ms = interp1(c, s, currents(k), 'linear', 'extrap');
        n_all{k} = [n_all{k}; mn];
        s_all{k} = [s_all{k}; ms];
    end
end


% calc stats
n_avg = zeros(length(currents), size(n_all{1}, 2));
s_avg = zeros(length(currents), size(s_all{1}, 2));
n_std = n_avg;
s_std = s_avg;
for k=1:length(currents)
    n_avg(k,:) = mean(n_all{k});
    s_avg(k,:) = mean(s_all{k});
    n_std(k,:) = std(n_all{k});
    s_std(k,:) = std(s_all{k});
end

% clear I=0
if index > 0
    n_avg(index,:) = 0 * n_avg(index,:);
    s_avg(index,:) = 0 * s_avg(index,:);
end

function read_multipole_files(currs, mag_field, mag_type, mag_label) 

[tpath, ~, ~] = fileparts(mfilename('fullpath'));
rotcoil = getappdata(0, 'rotcoil');
if isempty(rotcoil)
    rotcoil = struct();
end
rotcoil.(mag_field).nmpoles = {};
rotcoil.(mag_field).smpoles = {};
rotcoil.(mag_field).currents = {};
for i=1:length(currs)
    cname = ['MULTIPOLES-', currs{i}, '.txt'];
    fname = fullfile(tpath, 'models', mag_type, cname);
    [rotcoil.(mag_field).harms, rotcoil.(mag_field).mags, curr, nmp, smp] = load_multipoles_file(fname, mag_label);
    rotcoil.(mag_field).currents{end+1} = curr;
    rotcoil.(mag_field).nmpoles{end+1} = nmp;
    rotcoil.(mag_field).smpoles{end+1} = smp;
end
setappdata(0, 'rotcoil', rotcoil);

function [harms, mags, currents, nmpoles, smpoles] = load_multipoles_file(filename, substr)

fp = fopen(filename, 'rt');
text = textscan(fp, '%s', 'Delimiter', '\n');
text = text{1};
mags = {};
currents = [];
nmpoles = [];
smpoles = [];
for i=1:length(text)
    line = text{i};
    if ~isempty(strfind(line, 'harmonics'))
        words = strsplit(line, 'n=0):');
        harms = str2num(words{2});
        n = length(harms);
    elseif ~isempty(strfind(line, substr))
        words = strsplit(line, ' ');
        mags{end+1} = words{1};
        mpoles = str2num(str2mat(words(2:end)));
        currents(end+1) = mpoles(1);
        nmpoles = [nmpoles; currents(end) * mpoles(2:1+n)'];
        smpoles = [smpoles; currents(end) * mpoles(2+n:end)'];
    end
end

function [text_avg, text_std] = excdata_table(currents, n_avg, s_avg, n_std, s_std)

text_avg = {
'';
'# EXCITATION DATA';
'# ===============';
};
text_std = text_avg;
fmt1 = '%+08.2f';
fmt2 = '%+11.4e';
for i=1:length(currents)
    text_avg{end+1} = [num2str(currents(i), fmt1), '  '];
    text_std{end+1} = [num2str(currents(i), fmt1), '  '];
    for j=1:size(n_avg, 2)
        text_avg{end} = [text_avg{end}, num2str(n_avg(i,j), fmt2), ' ', num2str(s_avg(i,j), fmt2), '  '];
        text_std{end} = [text_std{end}, num2str(n_std(i,j), fmt2), ' ', num2str(s_std(i,j), fmt2), '  '];
    end
end

function text = excdata_file_comments(mags)

text = {
' ';
'# COMMENTS';
'# ========';
'# 1. generated automatically with "sirius_bo_create_excitation_file.m"';
'# 2. data taken from rotcoil measurements';
'# 3. average excitation curves for magnets:';
'#    ';
};

for i=1:length(mags)
    text{end} = [text{end}, mags{i}, ' '];
    if rem(i, 10) == 0
        text{end+1} = '#    ';
    end
end
if ~strcmpi(text{end}, '#    ')
    text{end+1} = '#    ';
end

function text = excdata_file_polarity_table

text = {
' ';
'# POLARITY TABLE';
'# ==============';
'# ';
'# Magnet function         | IntStrength(1) | IntField(2) | ConvSign(3) | Current(4)';
'# ------------------------|----------------|-------------|-------------|-----------';
'# dipole                  | Angle > 0      | BYL  < 0    | -1.0        | I > 0';
'# corrector-horizontal    | HKick > 0      | BYL  > 0    | +1.0        | I > 0';
'# corrector-vertical      | VKick > 0      | BXL  < 0    | -1.0        | I > 0';
'# quadrupole (focusing)   | KL    > 0      | D1NL < 0    | -1.0        | I > 0';
'# quadrupole (defocusing) | KL    < 0      | D1NL > 0    | -1.0        | I > 0';
'# quadrupole (skew)       | KL    > 0      | D1SL > 0    | +1.0        | I > 0';
'# sextupole  (focusing)   | SL    > 0      | D2NL < 0    | -1.0        | I > 0';
'# sextupole  (defocusing) | SL    < 0      | D2NL > 0    | -1.0        | I > 0';
'# ';
'# Defs:';
'# ----';
'# BYL   := \\int{dz By|_{x=y=0}}.';
'# BXL   := \\int{dz Bx|_{x=y=0}}.';
'# D1NL  := \\int{dz \\frac{dBy}{dx}_{x=y=0}}';
'# D2NL  := (1/2!) \\int{dz \\frac{d^2By}{dx^2}_{x=y=0}}';
'# D1SL  := \\int{dz \\frac{dBx}{dx}_{x=y=0}}';
'# Brho  := magnetic rigidity.';
'# Angle := ConvSign * BYL / abs(Brho)';
'# HKick := ConvSign * BYL / abs(Brho)';
'# VKick := ConvSign * BXL / abs(Brho)';
'# KL    := ConvSign * D1NL / abs(Brho)';
'# SL    := ConvSign * D2NL / abs(Brho)';
'# ';
'# Obs:';
'# ---';
'# (1) Parameter definition.';
'#     IntStrength values correspond to integrated PolynomA and PolynomB parameters';
'#     of usual beam tracking codes, with the exception that VKick has its sign';
'#     reversed with respecto to its corresponding value in PolynomA.';
'# (2) Sirius coordinate system and Lorentz force.';
'# (3) Conversion sign for IntField <-> IntStrength';
'# (4) Convention of magnet excitation polarity, so that when I > 0 the strength';
'#     of the magnet has the expected conventional sign.';
};

function text = excdata_file_header(label, harmonics, main_mpole_str)

harms = int2str(harmonics);
units = 'Ampere  ';
for h=harmonics
    if h == 0
        u = 'T*m T*m  ';
    elseif h == 1
        u = 'T T  ';
    elseif h == 2
        u = 'T/m T/m  ';
    else
        u = ['T/m^', int2str(h-1), ' ', 'T/m^', int2str(h-1), '  '];
    end
    units = [units, u];
end

text = {
'# HEADER';
'# ======';
['# label           ', label];
['# harmonics       ', harms];
['# main_harmonic   ', main_mpole_str];
['# units           ', units];
};

function text = excdata_fileformat

text = {
' '; 
'# STATIC DATA FILE FORMAT';
'# =======================';
'# ';
'# These static data files should comply with the following formatting rules:';
'# 1. If the first alphanumeric character of the line is not the pound sign';
'#    then the lines is a comment.';
'# 2. If the first alphanumeric character is "#" then if';
'#    a) it is followed by "[<parameter>] <value>" a parameter names <parameter>';
'#       is define with value <value>. if the string <value> has spaces in it';
'#       it is split as a list of strings.';
'#    b) otherwise the line is ignored as a comment line.';
};

function mpole_rot_z_p90(mag_field)
% +90 degrees rotation around z axis
rotcoil = getappdata(0, 'rotcoil');
for i=1:length(rotcoil.(mag_field).currents)
    for j=1:size(rotcoil.(mag_field).nmpoles{i}, 1)
        for k=1:size(rotcoil.(mag_field).nmpoles{i}, 2)
            n = rotcoil.(mag_field).harms(k);
            nm = rotcoil.(mag_field).nmpoles{i}(j,k);
            sm = rotcoil.(mag_field).smpoles{i}(j,k);
            zi = (nm + 1j*sm);
            zf = (-1j)^(n+1) * zi;
            rotcoil.(mag_field).nmpoles{i}(j,k) = real(zf);
            rotcoil.(mag_field).smpoles{i}(j,k) = imag(zf);
        end
    end
end
setappdata(0, 'rotcoil', rotcoil);

function mpole_inv_polarity(mag_field)
% polarity inversion
rotcoil = getappdata(0, 'rotcoil');
for i=1:length(rotcoil.(mag_field).currents)
    rotcoil.(mag_field).nmpoles{i} = - rotcoil.(mag_field).nmpoles{i};
    rotcoil.(mag_field).smpoles{i} = - rotcoil.(mag_field).smpoles{i};
end
setappdata(0, 'rotcoil', rotcoil);

function [currents2, n_avg2, s_avg2, n_std2, s_std2] = mpoles_add_negative_currents(currents, n_avg, s_avg, n_std, s_std)

currents2 = [-fliplr(currents(2:end)), currents];
n_avg2 = [-flipud(n_avg(2:end,:)); n_avg];
s_avg2 = [-flipud(s_avg(2:end,:)); s_avg];
n_std2 = [-flipud(n_std(2:end,:)); n_std];
s_std2 = [-flipud(s_std(2:end,:)); s_std];
   
