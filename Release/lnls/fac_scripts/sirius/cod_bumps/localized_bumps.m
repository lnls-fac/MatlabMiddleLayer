function localized_bumps

global THERING;
the_ring = THERING;

%% parameters with desired localized kicks
bump_x = 1e-3;
bump_y = 1e-3;
nr_cms = 5*2;



%%  selects half straight section and calc indices for upstream and downstream correctors
hcm = findcells(the_ring, 'FamName', 'hcm');
vcm = findcells(the_ring, 'FamName', 'vcm');
min_idx = min([hcm(end-(nr_cms/2-1):end) vcm(end-(nr_cms/2-1):end)]);
half_ssection = the_ring(min_idx:end);
hcm = findcells(half_ssection, 'FamName', 'hcm'); hcm = fliplr(hcm); hcm = hcm(1:(nr_cms/2)); hcm = fliplr(hcm);
vcm = findcells(half_ssection, 'FamName', 'vcm'); vcm = fliplr(vcm); vcm = vcm(1:(nr_cms/2)); vcm = fliplr(vcm);



clc; fclose('all'); close('all');


%% calcs kick amplitudes
half_ssection0 = half_ssection;

half_ssection = half_ssection0;
orb0 = linepass(half_ssection, [0 0 0 0 0 0]', 1:length(half_ssection));
bump_x0  = orb0(1,end); bump_xl0 = orb0(2,end); 
while true
    [Mx My] = calc_respm(half_ssection, hcm, vcm, nr_cms);
    [U,S,V] = svd(Mx,'econ');
    dkicksx = (V*pinv(S)*U') * [bump_x - bump_x0; 0 - bump_xl0];
    kicksx0 = getcellstruct(half_ssection, 'KickAngle', hcm, 1);
    kicksx = kicksx0 + dkicksx;
    half_ssection = setcellstruct(half_ssection, 'KickAngle', hcm, kicksx, 1);
    orb = linepass(half_ssection, [0 0 0 0 0 0]', 1:length(half_ssection));
    bump_x0 = orb(1,end); bump_xl0 = orb(2,end);
    if abs(bump_xl0) < 1e-15, break; end
end


fprintf('HORIZONTAL BUMP\n');
fprintf('===============\n');
pos = findspos(half_ssection, 1:length(half_ssection));
figure; plot(pos, 1e3*orb(1,:)); xlabel('Pos [m]'); ylabel('Orbit X [mm]'); title('Horizontal Bump');  hold all;
the_ring = THERING; THERING = half_ssection; drawlattice(-2, 1, gca); THERING = the_ring;
fprintf('posx: %+7.3f mm\n', 1e3*bump_x0);
fprintf('angx: %+6.1f urad\n', 1e6*bump_xl0);
for i=1:length(hcm)
    fprintf('kick: %+6.3f mrad\n', 1e3*kicksx(i));
end

% plots closedf-orbit
the_ring0 = THERING;
hcms = findcells(THERING, 'FamName', 'hcm');
for i=1:length(kicksx)
    THERING{hcms(i)}.KickAngle(1) = kicksx(end-i+1);
    THERING{hcms(end-length(kicksx)+i)}.KickAngle(1) = kicksx(i);
end
% closed-orbit
setcavity('on'); setradiation('on'); o = findorbit6(THERING, 1:length(THERING), [bump_x 0 0 0 0 0]');
pos = findspos(THERING, 1:length(THERING));
figure; plot(pos, 1e3*o(1,:)); xlabel('Pos [m]'); ylabel('Orb X [mm]'); title('Horizontal Closed Orbit');
THERING = the_ring0;


half_ssection = half_ssection0;
orb0 = linepass(half_ssection, [0 0 0 0 0 0]', 1:length(half_ssection));
bump_y0  = orb0(3,end); bump_yl0 = orb0(4,end); 
while true
    [Mx My] = calc_respm(half_ssection, hcm, vcm, nr_cms);
    [U,S,V] = svd(My,'econ');
    dkicksy = (V*pinv(S)*U') * [bump_y - bump_y0; 0 - bump_yl0];
    kicksy0 = getcellstruct(half_ssection, 'KickAngle', vcm, 2);
    kicksy = kicksy0 + dkicksy;
    half_ssection = setcellstruct(half_ssection, 'KickAngle', vcm, kicksy, 2);
    orb = linepass(half_ssection, [0 0 0 0 0 0]', 1:length(half_ssection));
    bump_y0 = orb(3,end); bump_yl0 = orb(4,end);
    if abs(bump_yl0) < 1e-15, break; end
end




fprintf('VERTICAL BUMP\n');
fprintf('=============\n');
pos = findspos(half_ssection, 1:length(half_ssection));
figure; plot(pos, 1e3*orb(3,:)); xlabel('Pos [m]'); ylabel('Orbit Y [mm]'); title('Vertical Bump');  hold all;
the_ring = THERING; THERING = half_ssection; drawlattice(-2, 1, gca); THERING = the_ring;
fprintf('posx: %+7.3f mm\n', 1e3*bump_y0);
fprintf('angx: %+6.1f urad\n', 1e6*bump_yl0);
for i=1:length(vcm)
    fprintf('kick: %+6.3f mrad\n', 1e3*kicksy(i));
end

% plots closedf-orbit
the_ring0 = THERING;
vcms = findcells(THERING, 'FamName', 'vcm');
for i=1:length(kicksy)
    THERING{vcms(i)}.KickAngle(2) = kicksy(end-i+1);
    THERING{vcms(end-length(kicksx)+i)}.KickAngle(2) = kicksy(i);
end
setcavity('on'); setradiation('on'); o = findorbit6(THERING, 1:length(THERING), [bump_x 0 0 0 0 0]');
pos = findspos(THERING, 1:length(THERING));
figure; plot(pos, 1e3*o(3,:)); xlabel('Pos [m]'); ylabel('Orb Y [mm]');  title('Vertical Closed Orbit');
THERING = the_ring0;





function [Mx My] = calc_respm(half_ssection, hcm, vcm, nr_cms)


%% build response matrices
delta_kick = 0.01e-3;

half_ssection0 = half_ssection;

Mx = zeros(2,nr_cms/2);
for i=1:(nr_cms/2)
    half_ssection = half_ssection0; half_ssection{hcm(i)}.KickAngle = half_ssection{hcm(i)}.KickAngle - [delta_kick/2 0];
    orbn = linepass(half_ssection, [0 0 0 0 0 0]', 1:length(half_ssection));
    half_ssection = half_ssection0; half_ssection{hcm(i)}.KickAngle = half_ssection{hcm(i)}.KickAngle + [delta_kick/2 0];
    orbp = linepass(half_ssection, [0 0 0 0 0 0]', 1:length(half_ssection));
    Mx(1,i) = (orbp(1,end) - orbn(1,end)) / delta_kick;
    Mx(2,i) = (orbp(2,end) - orbn(2,end)) / delta_kick;
end

My = zeros(2,nr_cms/2);
for i=1:(nr_cms/2)
    half_ssection = half_ssection0; half_ssection{vcm(i)}.KickAngle = half_ssection{vcm(i)}.KickAngle - [0 delta_kick/2];
    orbn = linepass(half_ssection, [0 0 0 0 0 0]', 1:length(half_ssection));
    half_ssection = half_ssection0; half_ssection{vcm(i)}.KickAngle = half_ssection{vcm(i)}.KickAngle + [0 delta_kick/2];
    orbp = linepass(half_ssection, [0 0 0 0 0 0]', 1:length(half_ssection));
    My(1,i) = (orbp(3,end) - orbn(3,end)) / delta_kick;
    My(2,i) = (orbp(4,end) - orbn(4,end)) / delta_kick;
end






