function [sorting, currents, harmonics, n_avg, s_avg, n_std, s_std] = calc_excitation_stats(tpath, currents, mag_field, mag_type, sorting_fname, index, check_not_in_sort)

if ~exist('check_not_in_sort', 'var')
    check_not_in_sort = false;
end

% load list of used magnets
fname = fullfile(tpath, 'models', mag_type, sorting_fname);
sorting = sirius_excdata.importfile_sorting(fname);

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
    if ~check_not_in_sort && ~any(strcmp(rotcoil.(mag_field).mags{i}, sorting))
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
    n_avg(k,:) = mean(n_all{k}, 1);
    s_avg(k,:) = mean(s_all{k}, 1);
    n_std(k,:) = std(n_all{k}, 0, 1);
    s_std(k,:) = std(s_all{k}, 0, 1);
end

% clear I=0
if index > 0
    n_avg(index,:) = 0 * n_avg(index,:);
    s_avg(index,:) = 0 * s_avg(index,:);
end
