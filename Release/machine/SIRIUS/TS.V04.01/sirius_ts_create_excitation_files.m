function sirius_ts_create_excitation_files

[tpath, ~, ~] = fileparts(mfilename('fullpath'));

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