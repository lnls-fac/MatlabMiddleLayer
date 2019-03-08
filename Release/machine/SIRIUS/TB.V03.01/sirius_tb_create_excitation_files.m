function sirius_tb_create_excitation_files

[tpath, ~, ~] = fileparts(mfilename('fullpath'));

% QUAD
currs = {
    '-10A', '-9A', '-7A', '-5A', '-3A', '-1A', '-0A', '1A', '3A', '5A', '7A', '9A', '10A'
};
sirius_excdata.read_multipole_files(tpath, currs, 'QUAD', 'quadrupoles', 'TBQ-');
currents = [-10, -9, -7, -5, -3, -1, 0, 1, 3, 5, 7, 9, 10];
[sorting, currents, harmonics, n_avg, s_avg, n_std, s_std] = sirius_excdata.calc_excitation_stats(tpath, currents, 'QUAD', 'quadrupoles', 'sorting.txt', 7);
sirius_excdata.save_excdata(sorting, 'tb-quadrupole', currents, '0 normal', harmonics, n_avg, s_avg, n_std, s_std, 'sirius_tb_create_excitation_file.m');

% B
currs = {
    '0025p362A', '0050p724A', '0076p086A', '0101p449A', '0126p811A', ...
    '0152p173A', '0177p535A', '0202p898A', '0228p261A', '0240p941A', ...
    '0253p622A', '0266p303A', '0278p984A', '0304p346A', '0329p709A'};
serials = {'01', '02', '03'};
sirius_excdata.read_multipole_from_fmap_files(tpath, currs, 'B', 'TBD-', serials);
currents = [0, 25, 51, 76, 101, 127, 152, 178, 203, 228, 241, 254, 266, 279, 304, 330];
[sorting, currents, harmonics, n_avg, s_avg, n_std, s_std] = sirius_excdata.calc_excitation_stats(tpath, currents, 'B', 'dipoles', 'sorting.txt', 1);
sirius_excdata.save_excdata(sorting, 'tb-dipole-b-fam', currents, '0 normal', harmonics, n_avg, s_avg, n_std, s_std, 'sirius_tb_create_excitation_file.m');

% CH
currs = {
    'CH_01_-10A', 'CH_02_-8A', 'CH_03_-6A', 'CH_04_-4A', 'CH_05_-2A', ...
    'CH_06_-0A', 'CH_07_+2A', 'CH_08_+4A', 'CH_09_+6A', 'CH_10_+8A', ...
    'CH_11_+10A', ...
};
sirius_excdata.read_multipole_files(tpath, currs, 'CH', 'correctors', 'TBC-');
currents = [-10, -8, -6, -4, -2, 0, 2, 4, 6, 8, 10];
[sorting, currents, harmonics, n_avg, s_avg, n_std, s_std] = sirius_excdata.calc_excitation_stats(tpath, currents, 'CH', 'correctors', 'sorting.txt', 6);
sirius_excdata.save_excdata(sorting, 'tb-correctors-ch', currents, '0 normal', harmonics, n_avg, s_avg, n_std, s_std, 'sirius_tb_create_excitation_file.m');

% CV
currs = {
    'CV_01_-10A', 'CV_02_-8A', 'CV_03_-6A', 'CV_04_-4A', 'CV_05_-2A', ...
    'CV_06_+0A', 'CV_07_+2A', 'CV_08_+4A', 'CV_09_+6A', 'CV_10_+8A', ...
    'CV_11_+10A', ...
};
sirius_excdata.read_multipole_files(tpath, currs, 'CV', 'correctors', 'TBC-');
currents = [-10, -8, -6, -4, -2, 0, 2, 4, 6, 8, 10];
[sorting, currents, harmonics, n_avg, s_avg, n_std, s_std] = sirius_excdata.calc_excitation_stats(tpath, currents, 'CV', 'correctors', 'sorting.txt', 6);
sirius_excdata.save_excdata(sorting, 'tb-correctors-cv', currents, '0 skew', harmonics, -n_avg, -s_avg, n_std, s_std, 'sirius_tb_create_excitation_file.m');
   
