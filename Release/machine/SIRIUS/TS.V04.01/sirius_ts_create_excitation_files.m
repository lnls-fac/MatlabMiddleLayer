function sirius_ts_create_excitation_files

[tpath, ~, ~] = fileparts(mfilename('fullpath'));

% CV
currs = {
    'CV_01_-10A', 'CV_02_-9A', 'CV_03_-7A', 'CV_04_-5A', 'CV_05_-3A', ...
    'CV_06_-1A',  'CV_07_+0A', 'CV_08_+1A', 'CV_09_+3A', 'CV_10_+5A', ...
    'CV_11_+7A', 'CV_12_+9A', 'CV_13_+10A'
};
sirius_excdata.read_multipole_files(tpath, currs, 'CV', 'correctors', 'BC-');
sirius_excdata.transf_rot_z_p90('CV');
currents = [-10, -9, -7, -5, -3, -1, 0, 1, 3, 5, 7, 9, 10];
[sorting, currents, harmonics, n_avg, s_avg, n_std, s_std] = sirius_excdata.calc_excitation_stats(tpath, currents, 'CV_', 'correctors', 'sorting-cv-strong.txt', 7);
sirius_excdata.save_excdata(sorting, 'ts-correctors-cv', currents, '0 skew', harmonics, n_avg, s_avg, n_std, s_std, 'sirius_ts_create_excitation_files.m');

% CV_STRONG
currs = {
    'CV_01_-10A', 'CV_02_-9A', 'CV_03_-7A', 'CV_04_-5A', 'CV_05_-3A', ...
    'CV_06_-1A',  'CV_07_+0A', 'CV_08_+1A', 'CV_09_+3A', 'CV_10_+5A', ...
    'CV_11_+7A', 'CV_12_+9A', 'CV_13_+10A'
};
sirius_excdata.read_multipole_files(tpath, currs, 'CV_STRONG', 'correctors', 'BC-');
sirius_excdata.transf_rot_z_p90('CV');
currents = [-10, -9, -7, -5, -3, -1, 0, 1, 3, 5, 7, 9, 10];
[sorting, currents, harmonics, n_avg, s_avg, n_std, s_std] = sirius_excdata.calc_excitation_stats(tpath, currents, 'CV_STRONG', 'correctors', 'sorting-cv-strong.txt', 7);
sirius_excdata.save_excdata(sorting, 'ts-correctors-cv-strong', currents, '0 skew', harmonics, n_avg, s_avg, n_std, s_std, 'sirius_ts_create_excitation_files.m');

% B
currs = {
    '0040p31A', '0050p39A', '0060p46A', '0165p27A', '0330p54A', ...
    '0500p00A', '0640p00A', '0680p00A', '0720p00A', '0800p00A', ...
    '0942p05A', '0991p63A', '1041p21A'};
serials = {'006'};
sirius_excdata.read_multipole_from_fmap_files(tpath, currs, 'B', 'BD-', serials, 'excitation_curve');
currents = [0, 40.31, 50.39, 60.46, 165.27, 330.54, 500, 640, 680, 698.85, 720, 800, 942.05, 991.63, 1041.21];
[sorting, currents, harmonics, n_avg, s_avg, n_std, s_std] = sirius_excdata.calc_excitation_stats(tpath, currents, 'B', 'dipoles', 'sorting.txt', 1, true);
sirius_excdata.save_excdata({'BD-006'}, 'ts-dipole-b-fam', currents, '0 normal', harmonics, n_avg, s_avg, n_std, s_std, 'sirius_ts_create_excitation_files.m', 0);