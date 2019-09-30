function save_excdata(sorting, fname, currents, main_mpole, harmonics, n_avg, s_avg, n_std, s_std, mfilename, mirror)

if ~exist('mirror', 'var')
    mirror = 0;
end
header = excdata_file_header(fname, harmonics, main_mpole);
[data_avg, data_std] = excdata_table(currents, n_avg, s_avg, n_std, s_std, mirror);
comments = excdata_file_comments(sorting, mfilename);
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


function text = excdata_file_comments(mags, mfilename)

text = {
' ';
'# COMMENTS';
'# ========';
['# 1. generated automatically with "', mfilename, '"'];
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
'# quadrupole (skew)       | KL    < 0      | D1SL > 0    | -1.0        | I > 0';
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
'# KL    := ConvSign * D1SL / abs(Brho)';
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

function [text_avg, text_std] = excdata_table(currents, n_avg, s_avg, n_std, s_std, mirror)

text_avg = {
'';
'# EXCITATION DATA';
'# ===============';
};
text_std = text_avg;
fmt1 = '%+08.2f';
fmt2 = '%+13.6e';
if mirror
    for i=length(currents):-1:2
        text_avg{end+1} = [num2str(-currents(i), fmt1), '  '];
        text_std{end+1} = [num2str(-currents(i), fmt1), '  '];
        for j=1:size(n_avg, 2)
            text_avg{end} = [text_avg{end}, num2str(-n_avg(i,j), fmt2), ' ', num2str(-s_avg(i,j), fmt2), '  '];
            text_std{end} = [text_std{end}, num2str(n_std(i,j), fmt2), ' ', num2str(s_std(i,j), fmt2), '  '];
        end
end

end
for i=1:length(currents)
    text_avg{end+1} = [num2str(currents(i), fmt1), '  '];
    text_std{end+1} = [num2str(currents(i), fmt1), '  '];
    for j=1:size(n_avg, 2)
        text_avg{end} = [text_avg{end}, num2str(n_avg(i,j), fmt2), ' ', num2str(s_avg(i,j), fmt2), '  '];
        text_std{end} = [text_std{end}, num2str(n_std(i,j), fmt2), ' ', num2str(s_std(i,j), fmt2), '  '];
    end
end
