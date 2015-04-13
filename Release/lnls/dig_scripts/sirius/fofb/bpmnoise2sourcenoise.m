function orbit4d_dist = bpmnoise2sourcenoise

global THERING

% Orbit points (light sources, BPMs, fast orbit correctors)
mc   = findcells(THERING, 'FamName', 'mc')';
mia  = findcells(THERING, 'FamName', 'mia')';
mib  = findcells(THERING, 'FamName', 'mib')';
bpm  = findcells(THERING, 'FamName', 'BPM')';
crhv = findcells(THERING, 'FamName', 'crhv')';
[source, order] =  sort([mc; mia; mib]);

nbpm = length(bpm);
nsource = length(source);
ncrhv = length(crhv);

% Response matrix: fast corrector kick -> 4-D orbit at BPM points
Mhbpm = respmcorr(THERING, bpm, crhv, 'h');
Mvbpm = respmcorr(THERING, bpm, crhv, 'v');
Mbpm = zeros(nbpm,2*ncrhv,4);
Mbpm(:, 1:ncrhv, :) = Mhbpm;
Mbpm(:, ncrhv+(1:ncrhv), :) = Mvbpm;

% Response matrix: fast corrector kick -> 4-D orbit at source points
Mhsource = respmcorr(THERING, source, crhv, 'h');
Mvsource = respmcorr(THERING, source, crhv, 'v');
Msource = zeros(nsource,2*ncrhv,4);
Msource(:, 1:ncrhv, :) = Mhsource;
Msource(:, ncrhv+(1:ncrhv), :) = Mvsource;

% Correction matrices
Ch = pinv(Mbpm(:,:,1));
Cv = pinv(Mbpm(:,:,3));

% Response matrices: BPM noise -> 4-D orbit residual distortion
Mh_hpos = Msource(:,:,1)*Ch;
Mh_hang = Msource(:,:,2)*Ch;
Mv_vpos = Msource(:,:,3)*Cv;
Mv_vang = Msource(:,:,4)*Cv;

% Standard deviation gain (from BPM noise to source point distortion)
hpos = sqrt(sum(Mh_hpos.^2,2));
hang = sqrt(sum(Mh_hang.^2,2));
vpos = sqrt(sum(Mv_vpos.^2,2));
vang = sqrt(sum(Mv_vang.^2,2));

orbit4d_dist = [hpos vpos hang vang];

[~,reorder] = sort(order);
mc_idx = reorder(1:length(mc));
mia_idx = reorder(length(mc)+(1:length(mia)));
mib_idx = reorder((length(mc)+length(mia))+(1:length(mib)));

% Show results
figure
plot(1:nsource, orbit4d_dist)
hold on
plot(mc_idx, orbit4d_dist(mc_idx,:), 'o')
plot(mia_idx, orbit4d_dist(mia_idx,:), '^')
plot(mib_idx, orbit4d_dist(mib_idx,:), 's')

title({'BPM noise -> 4-D orbit residual distortion standard deviation factors (uncorrelated noise on BPMs)', 'circle: BC', 'triangle: straight section A', 'square: straight section B'})
xlabel('Source point')
ylabel('Gain [m/m or rad/m]')
legend('H position (m/m)', 'V position (m/m)', 'H angle (rad/m)', 'V angle (rad/m)')