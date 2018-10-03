function sirius_bo_create_excitation_files

[tpath, ~, ~] = fileparts(mfilename('fullpath'));

% % B
% currs = {
%     '0025p362A', '0050p724A', '0076p086A', '0101p449A', '0126p811A', ...
%     '0152p173A', '0177p535A', '0202p898A', '0228p261A', '0240p941A', ...
%     '0253p622A', '0266p303A', '0278p984A', '0304p346A', '0329p709A'};
% serials = {'01', '02', '03'};
% read_multipoles_from_fmap_files(currs, 'B', 'TBD-', serials);
% currents = [0, 25, 51, 76, 101, 127, 152, 178, 203, 228, 241, 254, 266, 279, 304, 330];
% [sorting, currents, harmonics, n_avg, s_avg, n_std, s_std] = calc_excitation_stats(currents, 'B', 'dipoles', 'sorting.txt', 1);
% save_excdata(sorting, 'tb-dipole-b-fam', currents, '0 normal', harmonics, n_avg, s_avg, n_std, s_std);

% SD
currs = {'2A', '4A', '6A', '8A', '10A', '30A', '50A', '70A', '90A', '110A', '130A', '150A'};
sirius_excdata.read_multipole_files(tpath, currs, 'SD', 'sextupoles', 'BS-');
sirius_excdata.transf_inv_polarity('SD');
currents = [0, 2, 4, 6, 8, 10, 30, 50, 70, 90, 110, 130, 150];
[sorting, currents, harmonics, n_avg, s_avg, n_std, s_std] = sirius_excdata.calc_excitation_stats(tpath, currents, 'SD', 'sextupoles', 'sorting-sd.txt', 1);
[currents, n_avg, s_avg, n_std, s_std] = sirius_excdata.transf_add_negative_currents(currents, n_avg, s_avg, n_std, s_std);
sirius_excdata.save_excdata(sorting, 'bo-sextupole-sd-fam', currents, '2 normal', harmonics, n_avg, s_avg, n_std, s_std);

% SF
currs = {'2A', '4A', '6A', '8A', '10A', '30A', '50A', '70A', '90A', '110A', '130A', '150A'};
sirius_excdata.read_multipole_files(tpath, currs, 'SF', 'sextupoles', 'BS-');
currents = [0, 2, 4, 6, 8, 10, 30, 50, 70, 90, 110, 130, 150];
[sorting, currents, harmonics, n_avg, s_avg, n_std, s_std] = sirius_excdata.calc_excitation_stats(tpath, currents, 'SF', 'sextupoles', 'sorting-sf.txt', 1);
sirius_excdata.save_excdata(sorting, 'bo-sextupole-sf-fam', currents, '2 normal', harmonics, n_avg, s_avg, n_std, s_std);


% CV
currs = {
    'CH_01_-10A', 'CH_02_-9A', 'CH_03_-7A', 'CH_04_-5A', 'CH_05_-3A', ...
    'CH_06_-1A',  'CH_07_+0A', 'CH_08_+1A', 'CH_09_+3A', 'CH_10_+5A', ...
    'CH_11_+7A', 'CH_12_+9A', 'CH_13_+10A'
};
sirius_excdata.read_multipole_files(tpath, currs, 'CV', 'correctors', 'BC-');
sirius_excdata.transf_rot_z_p90('CV');
currents = [-10, -9, -7, -5, -3, -1, 0, 1, 3, 5, 7, 9, 10];
[sorting, currents, harmonics, n_avg, s_avg, n_std, s_std] = sirius_excdata.calc_excitation_stats(tpath, currents, 'CV', 'correctors', 'sorting-cv.txt', 7);
sirius_excdata.save_excdata(sorting, 'bo-correctors-cv', currents, '0 skew', harmonics, n_avg, s_avg, n_std, s_std);

% CH
currs = {
    'CH_01_-10A', 'CH_02_-9A', 'CH_03_-7A', 'CH_04_-5A', 'CH_05_-3A', ...
    'CH_06_-1A',  'CH_07_+0A', 'CH_08_+1A', 'CH_09_+3A', 'CH_10_+5A', ...
    'CH_11_+7A', 'CH_12_+9A', 'CH_13_+10A'
};
sirius_excdata.read_multipole_files(tpath, currs, 'CH', 'correctors', 'BC-');
currents = [-10, -9, -7, -5, -3, -1, 0, 1, 3, 5, 7, 9, 10];
[sorting, currents, harmonics, n_avg, s_avg, n_std, s_std] = sirius_excdata.calc_excitation_stats(tpath, currents, 'CH', 'correctors', 'sorting-ch.txt', 7);
sirius_excdata.save_excdata(sorting, 'bo-correctors-ch', currents, '0 normal', harmonics, n_avg, s_avg, n_std, s_std);

% QD
currs = {'2A', '4A', '6A', '8A', '10A', '20A', '32A'};
sirius_excdata.read_multipole_files(tpath, currs, 'QD', 'quadrupoles-qd', 'BQD-');
sirius_excdata.transf_inv_polarity('QD');
currents = [0, 2, 4, 6, 8, 10, 20, 32];
[sorting, currents, harmonics, n_avg, s_avg, n_std, s_std] = sirius_excdata.calc_excitation_stats(tpath, currents, 'QD', 'quadrupoles-qd', 'sorting.txt', 1);
[currents, n_avg, s_avg, n_std, s_std] = sirius_excdata.transf_add_negative_currents(currents, n_avg, s_avg, n_std, s_std);
sirius_excdata.save_excdata(sorting, 'bo-quadrupole-qd-fam', currents, '1 normal', harmonics, n_avg, s_avg, n_std, s_std);

% QF
currs = {'2A', '4A', '6A', '8A', '10A', '30A', '50A', '70A', '90A', '110A', '130A'};
sirius_excdata.read_multipole_files(tpath, currs, 'QF', 'quadrupoles-qf', 'BQF-');
currents = [0, 2, 4, 6, 8, 10, 30, 50, 70, 90, 110, 130];
[sorting, currents, harmonics, n_avg, s_avg, n_std, s_std] = sirius_excdata.calc_excitation_stats(tpath, currents, 'QF', 'quadrupoles-qf', 'sorting.txt', 1);
sirius_excdata.save_excdata(sorting, 'bo-quadrupole-qf-fam', currents, '1 normal', harmonics, n_avg, s_avg, n_std, s_std);