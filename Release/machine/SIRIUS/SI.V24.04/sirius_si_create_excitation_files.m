function sirius_si_create_excitation_files

[tpath, ~, ~] = fileparts(mfilename('fullpath'));

% Individual CV (same as BO-correctors)
currs = {
    'CV_01_-10A', 'CV_02_-9A', 'CV_03_-7A', 'CV_04_-5A', 'CV_05_-3A', ...
    'CV_06_-1A',  'CV_07_-0A', 'CV_08_+1A', 'CV_09_+3A', 'CV_10_+5A', ...
    'CV_11_+7A', 'CV_12_+9A', 'CV_13_+10A'
};
sirius_excdata.read_multipole_files(tpath, currs, 'CV', 'correctors', 'BC-');
sirius_excdata.transf_rot_z_p90('CV');
currents = [-10, -9, -7, -5, -3, -1, 0, 1, 3, 5, 7, 9, 10];
[sorting, currents, harmonics, n_avg, s_avg, n_std, s_std] = sirius_excdata.calc_excitation_stats(tpath, currents, 'CV', 'correctors', 'sorting-cv.txt', 7);
sirius_excdata.save_excdata(sorting, 'si-correctors-cv', currents, '0 skew', harmonics, n_avg, s_avg, n_std, s_std, 'sirius_si_create_excitation_files.m');

% B1-B2
currents = [0, 381.7, 401.8, 403.6, 421.9];

currs1 = {
    '381p7A', '401p8A', '403p6A', '421p9A'
    };
serials = {
    '002', '003', '004', '005', '006', '009', '010', '011', '012', '013', '014', ...
    '014', '015', '016', '017', '018', '019', '020', '021', '022', '023', '024', ...
    '025', '026', '027', '028', '029', '030', '031', '032', '033', '034', '035', ...
    '036', '037', '038', '039', '040', '041', '042', '043', '046'
    };
sirius_excdata.read_multipole_from_fmap_files(tpath, currs1, 'B', 'B1-', serials, 'excitation_curve');
[sorting1, currents, harmonics1, n_avg1, s_avg1, n_std1, s_std1] = sirius_excdata.calc_excitation_stats(tpath, currents, 'B', 'dipoles-b1', 'sorting.txt', 1, true);
sirius_excdata.save_excdata(sorting1, 'si-dipole-b1-fam', currents, '0 normal', harmonics1, n_avg1, s_avg1, n_std1, s_std1, 'sirius_si_create_excitation_files.m');

currs2 = {
    '381p7A', '401p8A', '421p9A'
    };
serials = {
    '001', '002', '003', '004', '005', '006', '007', '008', '009', '010', '011', '013', ...
    '014', '015', '016', '017', '018', '019', '021', '022', '023', '024', ...
    '025', '026', '027', '028', '029', '030', '031', '032', '033', '034', ...
    '036', '037', '038', '040', '042', '043', '044', '045', '046'
    };
sirius_excdata.read_multipole_from_fmap_files(tpath, currs2, 'B', 'B2-', serials, 'excitation_curve');
[sorting2, currents, harmonics2, n_avg2, s_avg2, n_std2, s_std2] = sirius_excdata.calc_excitation_stats(tpath, currents, 'B', 'dipoles-b2', 'sorting.txt', 1, true);
sirius_excdata.save_excdata(sorting2, 'si-dipole-b2-fam', currents, '0 normal', harmonics2, n_avg2, s_avg2, n_std2, s_std2, 'sirius_si_create_excitation_files.m');

n_avg12 = n_avg1 + n_avg2;
s_avg12 = s_avg1 + s_avg2;
n_std12 = sqrt(n_std1.^2 + n_std2.^2);
s_std12 = sqrt(s_std1.^2 + s_std2.^2);
sirius_excdata.save_excdata(sorting2, 'si-dipole-b1b2-fam', currents, '0 normal', harmonics2, n_avg12, s_avg12, n_std12, s_std12, 'sirius_si_create_excitation_files.m');

% Q14 - Trims
currs = {'2A', '4A', '6A', '8A', '10A'};
sirius_excdata.read_multipole_files(tpath, currs, 'Q14trim', 'quadrupoles-q14', 'Q14-');
% sirius_excdata.transf_inv_polarity('QD');
% currents = [0, 2, 4, 6, 8, 10, 30, 50, 70, 90, 110, 130, 148];
rotcoil = getappdata(0, 'rotcoil');
currents(1) = 0;
for k = 1:length(rotcoil.Q14trim.currents)
    currents(k+1) = mean(rotcoil.Q14trim.currents{k});
end   
% currents = [0.0003, 1.9951, 3.9977, 5.9968, 7.9956, 9.9958, 29.9956, 49.9945, 69.9942, 89.9973, 109.9969, 129.9966, 147.9959];
[sorting, currents, harmonics, n_avg, s_avg, n_std, s_std] = sirius_excdata.calc_excitation_stats(tpath, currents, 'Q14trim', 'quadrupoles-q14', 'sorting.txt', 1);
ncoil_main = 20;
ncoil_trim = 28;
harmonics = harmonics(2:end);
n_avg = n_avg(:, 2:end) .* (ncoil_trim/ncoil_main);
s_avg = s_avg(:, 2:end) .* (ncoil_trim/ncoil_main);
n_std = n_std(:, 2:end) .* (ncoil_trim/ncoil_main);
s_std = s_std(:, 2:end) .* (ncoil_trim/ncoil_main);
% [currents, n_avg, s_avg, n_std, s_std] = sirius_excdata.transf_add_negative_currents(currents, n_avg, s_avg, n_std, s_std);
sirius_excdata.save_excdata(sorting, 'si-quadrupole-q14-trim', currents, '1 normal', harmonics, n_avg, s_avg, n_std, s_std, 'sirius_si_create_excitation_files.m', 1);

% Q20 - QFA, Q1, Q2, Q3 and Q4 - trims
currs = {'2A', '4A', '6A', '8A', '10A'};
sirius_excdata.read_multipole_files(tpath, currs, 'Q20trim', 'quadrupoles-q20', 'Q20-');
% sirius_excdata.transf_inv_polarity('QD');
rotcoil = getappdata(0, 'rotcoil');
currents(1) = 0;
for k = 1:length(rotcoil.Q20trim.currents)
    currents(k+1) = mean(rotcoil.Q20trim.currents{k});
end
% currents = [0, 2, 4, 6, 8, 10, 30, 50, 70, 90, 110, 130, 157];
% currents = [0.0003, 1.9951, 3.9977, 5.9968, 7.9956, 9.9958, 29.9956, 49.9945, 69.9942, 89.9973, 109.9969, 129.9966, 147.9959];
[sorting, currents, harmonics, n_avg, s_avg, n_std, s_std] = sirius_excdata.calc_excitation_stats(tpath, currents, 'Q20trim', 'quadrupoles-q20', 'sorting.txt', 1);
ncoil_main = 23.25;
ncoil_trim = 18.00;
harmonics = harmonics(2:end);
n_avg = n_avg(:, 2:end) .* (ncoil_trim/ncoil_main);
s_avg = s_avg(:, 2:end) .* (ncoil_trim/ncoil_main);
n_std = n_std(:, 2:end) .* (ncoil_trim/ncoil_main);
s_std = s_std(:, 2:end) .* (ncoil_trim/ncoil_main);
% [currents, n_avg, s_avg, n_std, s_std] = sirius_excdata.transf_add_negative_currents(currents, n_avg, s_avg, n_std, s_std);
sirius_excdata.save_excdata(sorting, 'si-quadrupole-q20-trim', currents, '1 normal', harmonics, n_avg, s_avg, n_std, s_std, 'sirius_si_create_excitation_files.m', 1);

% Q30 - QFB, QFP - trims
currs = {'2A', '4A', '6A', '8A', '10A'};
sirius_excdata.read_multipole_files(tpath, currs, 'Q30trim', 'quadrupoles-q30', 'Q30-');
% sirius_excdata.transf_inv_polarity('QD');
rotcoil = getappdata(0, 'rotcoil');
currents(1) = 0;
for k = 1:length(rotcoil.Q30trim.currents)
    currents(k+1) = mean(rotcoil.Q30trim.currents{k});
end
% currents = [0, 2, 4, 6, 8, 10, 30, 50, 70, 90, 110, 130, 155];
% currents = [0.0003, 1.9951, 3.9977, 5.9968, 7.9956, 9.9958, 29.9956, 49.9945, 69.9942, 89.9973, 109.9969, 129.9966, 147.9959];
[sorting, currents, harmonics, n_avg, s_avg, n_std, s_std] = sirius_excdata.calc_excitation_stats(tpath, currents, 'Q30trim', 'quadrupoles-q30', 'sorting.txt', 1);
ncoil_main = 23.25;
ncoil_trim = 18.00;
harmonics = harmonics(2:end);
n_avg = n_avg(:, 2:end) .* (ncoil_trim/ncoil_main);
s_avg = s_avg(:, 2:end) .* (ncoil_trim/ncoil_main);
n_std = n_std(:, 2:end) .* (ncoil_trim/ncoil_main);
s_std = s_std(:, 2:end) .* (ncoil_trim/ncoil_main);
% [currents, n_avg, s_avg, n_std, s_std] = sirius_excdata.transf_add_negative_currents(currents, n_avg, s_avg, n_std, s_std);
sirius_excdata.save_excdata(sorting, 'si-quadrupole-q30-trim', currents, '1 normal', harmonics, n_avg, s_avg, n_std, s_std, 'sirius_si_create_excitation_files.m', 1);

% Q14 - All QD
currs = {'2A', '4A', '6A', '8A', '10A', '30A', '50A', '70A', '90A', '110A', '130A', '148A'};
sirius_excdata.read_multipole_files(tpath, currs, 'Q14', 'quadrupoles-q14', 'Q14-');
% sirius_excdata.transf_inv_polarity('QD');
% currents = [0, 2, 4, 6, 8, 10, 30, 50, 70, 90, 110, 130, 148];
rotcoil = getappdata(0, 'rotcoil');
currents(1) = 0;
for k = 1:length(rotcoil.Q14.currents)
    currents(k+1) = mean(rotcoil.Q14.currents{k});
end   
% currents = [0.0003, 1.9951, 3.9977, 5.9968, 7.9956, 9.9958, 29.9956, 49.9945, 69.9942, 89.9973, 109.9969, 129.9966, 147.9959];
[sorting, currents, harmonics, n_avg, s_avg, n_std, s_std] = sirius_excdata.calc_excitation_stats(tpath, currents, 'Q14', 'quadrupoles-q14', 'sorting.txt', 1);
% [currents, n_avg, s_avg, n_std, s_std] = sirius_excdata.transf_add_negative_currents(currents, n_avg, s_avg, n_std, s_std);
sirius_excdata.save_excdata(sorting, 'si-quadrupole-q14-fam', currents, '1 normal', harmonics, n_avg, s_avg, n_std, s_std, 'sirius_si_create_excitation_files.m');

% Q20 - QFA, Q1, Q2, Q3 and Q4
currs = {'2A', '4A', '6A', '8A', '10A', '30A', '50A', '70A', '90A', '110A', '130A', '157A'};
sirius_excdata.read_multipole_files(tpath, currs, 'Q20', 'quadrupoles-q20', 'Q20-');
% sirius_excdata.transf_inv_polarity('QD');
rotcoil = getappdata(0, 'rotcoil');
currents(1) = 0;
for k = 1:length(rotcoil.Q20.currents)
    currents(k+1) = mean(rotcoil.Q20.currents{k});
end
% currents = [0, 2, 4, 6, 8, 10, 30, 50, 70, 90, 110, 130, 157];
% currents = [0.0003, 1.9951, 3.9977, 5.9968, 7.9956, 9.9958, 29.9956, 49.9945, 69.9942, 89.9973, 109.9969, 129.9966, 147.9959];
[sorting, currents, harmonics, n_avg, s_avg, n_std, s_std] = sirius_excdata.calc_excitation_stats(tpath, currents, 'Q20', 'quadrupoles-q20', 'sorting.txt', 1);
% [currents, n_avg, s_avg, n_std, s_std] = sirius_excdata.transf_add_negative_currents(currents, n_avg, s_avg, n_std, s_std);
sirius_excdata.save_excdata(sorting, 'si-quadrupole-q20-fam', currents, '1 normal', harmonics, n_avg, s_avg, n_std, s_std, 'sirius_si_create_excitation_files.m');

% Q30 - QFB, QFP
currs = {'2A', '4A', '6A', '8A', '10A', '30A', '50A', '70A', '90A', '110A', '130A', '155A'};
sirius_excdata.read_multipole_files(tpath, currs, 'Q30', 'quadrupoles-q30', 'Q30-');
% sirius_excdata.transf_inv_polarity('QD');
rotcoil = getappdata(0, 'rotcoil');
currents(1) = 0;
for k = 1:length(rotcoil.Q30.currents)
    currents(k+1) = mean(rotcoil.Q30.currents{k});
end
% currents = [0, 2, 4, 6, 8, 10, 30, 50, 70, 90, 110, 130, 155];
% currents = [0.0003, 1.9951, 3.9977, 5.9968, 7.9956, 9.9958, 29.9956, 49.9945, 69.9942, 89.9973, 109.9969, 129.9966, 147.9959];
[sorting, currents, harmonics, n_avg, s_avg, n_std, s_std] = sirius_excdata.calc_excitation_stats(tpath, currents, 'Q30', 'quadrupoles-q30', 'sorting.txt', 1);
% [currents, n_avg, s_avg, n_std, s_std] = sirius_excdata.transf_add_negative_currents(currents, n_avg, s_avg, n_std, s_std);
sirius_excdata.save_excdata(sorting, 'si-quadrupole-q30-fam', currents, '1 normal', harmonics, n_avg, s_avg, n_std, s_std, 'sirius_si_create_excitation_files.m');

% S15 - SD
currs = {'2A', '4A', '6A', '8A', '10A', '30A', '50A', '70A', '90A', '110A', '130A', '150A', '168A'};
sirius_excdata.read_multipole_files(tpath, currs, 'S15', 'sextupoles-s15', 'S15-');
sirius_excdata.transf_inv_polarity('S15');
rotcoil = getappdata(0, 'rotcoil');
currents(1) = 0;
for k = 1:length(rotcoil.S15.currents)
    currents(k+1) = mean(rotcoil.S15.currents{k});
end
[sorting, currents, harmonics, n_avg, s_avg, n_std, s_std] = sirius_excdata.calc_excitation_stats(tpath, currents, 'S15', 'sextupoles-s15', 'sorting-s15-sd.txt', 1);
% [currents, n_avg, s_avg, n_std, s_std] = sirius_excdata.transf_add_negative_currents(currents, n_avg, s_avg, n_std, s_std);
sirius_excdata.save_excdata(sorting, 'si-sextupole-s15-sd-fam', currents, '2 normal', harmonics, n_avg, s_avg, n_std, s_std, 'sirius_si_create_excitation_files.m');

% S15 - SF
currs = {'2A', '4A', '6A', '8A', '10A', '30A', '50A', '70A', '90A', '110A', '130A', '150A', '168A'};
sirius_excdata.read_multipole_files(tpath, currs, 'S15', 'sextupoles-s15', 'S15-');
rotcoil = getappdata(0, 'rotcoil');
currents(1) = 0;
for k = 1:length(rotcoil.S15.currents)
    currents(k+1) = mean(rotcoil.S15.currents{k});
end
[sorting, currents, harmonics, n_avg, s_avg, n_std, s_std] = sirius_excdata.calc_excitation_stats(tpath, currents, 'S15', 'sextupoles-s15', 'sorting-s15-sf.txt', 1);
% [currents, n_avg, s_avg, n_std, s_std] = sirius_excdata.transf_add_negative_currents(currents, n_avg, s_avg, n_std, s_std);
sirius_excdata.save_excdata(sorting, 'si-sextupole-s15-sf-fam', currents, '2 normal', harmonics, n_avg, s_avg, n_std, s_std, 'sirius_si_create_excitation_files.m');