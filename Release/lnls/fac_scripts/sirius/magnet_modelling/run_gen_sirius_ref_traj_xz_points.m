function run_gen_sirius_ref_traj_xz_points

global THERING;

clc;
sirius;

[pos ang] = lnls_build_ref_orbit(THERING, 'mc');

% elements selection
idx = [];
idx = [idx findcells(THERING, 'FamName', 'mia')];
idx = [idx findcells(THERING, 'FamName', 'mib')];
idx = [idx findcells(THERING, 'FamName', 'mc')];
idx = [idx findcells(THERING, 'FamName', 'mb1')];
idx = [idx findcells(THERING, 'FamName', 'mb2')];
idx = [idx findcells(THERING, 'FamName', 'mb3')];
idx = sort(idx);

s = findspos(THERING, 1:length(THERING));
bends = findcells(THERING, 'BendingAngle');
ang        = zeros(1,length(THERING));
ang(bends) = getcellstruct(THERING, 'BendingAngle', bends);
ang        = cumsum([0 ang]);
fprintf('INDX   FAMILYNAME   POSX___[mm]  POSZ___[mm]     POSS___[mm]    ANG.[deg]\n');
for i=1:length(idx)
    fprintf('%04i   %-10s   %+11.4f  %+11.4f    %12.4f    %9.5f\n', i, THERING{idx(i)}.FamName, 1000*pos(:,idx(i)), 1000*s(idx(i)), ang(idx(i))*(180/pi));
end
%fprintf('%04i   %-10s   %+11.4f  %+11.4f    %12.4f    %9.5f\n', 1, THERING{idx(1)}.FamName, 1000*pos(:,idx(1)), 1000*s(end), 360);