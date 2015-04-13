function orbit_correct_transport_lines

r.tolx = 200e-6;
r.toly = 200e-6;
r.tole = 0.1 / 100;
r.nr_machines = 100;
r.nr_iterations  = 5;

%orbit_correct_ltlb(r);
orbit_correct_ltba(r);


function orbit_correct_ltba(r)

% loads transport line model and plots lattice functions
sirius_ltba;
[lt, TwissDataIn] = sirius_ts_lattice;
plot_optics(lt, TwissDataIn);


% loads aux. data structures
r.hcms = findcells(lt, 'FamName', 'hcm');
r.vcms = findcells(lt, 'FamName', 'vcm');
r.bpms = findcells(lt, 'FamName', 'BPM');


%% LTLB RMS calculation

% Corrects orbit al all BPMs using HCMs
% Considers initial random electron conditions at the line entrance


r.nr_sing_values_x = 4;
r.nr_sing_values_y = 4;
r.sigmax  = 1 * 290 / 1e6;
r.sigmaxl = 1 * 20 / 1e6; 
r.sigmay  = 1 * 142 / 1e6;
r.sigmayl = 1 * 25 / 1e6; 

orbit_correct_rms(r, lt);


%% LTLB SYS calculation

r.x_pos = (-1)*2* 0.20e-3;
r.x_ang = (-1)*2* 0.10e-3;
r.y_pos = (-1)*2* 0.029e-3;
r.y_ang = (-1)*2* 0.005e-3;

hcm1 = findcells(lt, 'FamName', 'msg'); 
hcm2 = findcells(lt, 'FamName', 'msf'); 
lt{hcm1}.KickAngle = [0,0]; lt{hcm1}.PassMethod = 'CorrectorPass';
lt{hcm2}.KickAngle = [0,0]; lt{hcm2}.PassMethod = 'CorrectorPass';
vcm = findcells(lt, 'FamName', 'vcm');
vcm1 = vcm(end-1);
vcm2 = vcm(end);
r.hcms = [hcm1 hcm2];
r.vcms = [vcm1 vcm2];

orbit_correct_sys(r, lt);


function orbit_correct_ltlb(r)

% loads transport line model and plots lattice functions
sirius_ltlb;
[lt, TwissDataIn] = sirius_lb_lattice;
plot_optics(lt, TwissDataIn);


% loads aux. data structures
r.hcms = findcells(lt, 'FamName', 'hcm');
r.vcms = findcells(lt, 'FamName', 'vcm');
r.bpms = findcells(lt, 'FamName', 'BPM');


%% LTLB RMS calculation

% Corrects orbit al all BPMs using HCMs
% Considers initial random electron conditions at the line entrance


r.nr_sing_values_x = 5;
r.nr_sing_values_y = 4;
r.sigmax  = 1 * 500 / 1e6;
r.sigmaxl = 1 * 500 / 1e6; 
r.sigmay  = 1 * 500 / 1e6;
r.sigmayl = 1 * 500 / 1e6; 

orbit_correct_rms(r, lt);


%% LTLB SYS calculation

r.x_pos = (-1)*2*50e-6;
r.x_ang = (-1)*2*200e-6;
r.y_pos = (-1)*2*5e-6;
r.y_ang = (-1)*2*16e-6;

hcm1 = findcells(lt, 'FamName', 'hcm'); hcm1 = hcm1(end);
hcm2 = findcells(lt, 'FamName', 'msep'); 
lt{hcm2}.KickAngle = [0,0]; lt{hcm2}.PassMethod = 'CorrectorPass';
vcm = findcells(lt, 'FamName', 'vcm');
vcm1 = vcm(end-1);
vcm2 = vcm(end);
r.hcms = [hcm1 hcm2];
r.vcms = [vcm1 vcm2];

orbit_correct_sys(r, lt);



function orbit_correct_rms(r, lt)


% calcs orbit response matrix for the transport line
r.respm = calc_respm_cod_rms(lt, r.bpms, r.hcms, r.vcms,'noprint');

% random machines
all_codx       = zeros(r.nr_machines, length(lt));
all_cody       = zeros(r.nr_machines, length(lt));
all_codxl      = zeros(r.nr_machines, length(lt));
all_codyl      = zeros(r.nr_machines, length(lt));
all_hkicks     = zeros(r.nr_machines, length(r.hcms)); 
all_vkicks     = zeros(r.nr_machines, length(r.vcms)); 
for i=1:r.nr_machines
    r.lt = add_errors(lt, r);
    [hkicks, vkicks, codx, cody, codxl, codyl] = calc_correction(r);
    all_codx(i,:)   = codx;
    all_cody(i,:)   = cody;
    all_codxl(i,:)  = codxl;
    all_codyl(i,:)  = codyl;
    all_hkicks(i,:) = hkicks;
    all_vkicks(i,:) = vkicks;
%     fprintf('hkicks   [mrad]:'); fprintf('%+f ', 1000*hkicks); fprintf('\n');
%     fprintf('vkicks   [mrad]:'); fprintf('%+f ', 1000*vkicks); fprintf('\n');
%     fprintf('posx     [mm]  :'); fprintf('%+f ', 1e3*codx(r.bpms)); fprintf('\n');
%     fprintf('posy     [mm]  :'); fprintf('%+f ', 1e3*cody(r.bpms)); fprintf('\n');
end

% statistics
avg_hkicks = mean(all_hkicks); 
avg_vkicks = mean(all_vkicks); 
std_hkicks = std(all_hkicks); 
std_vkicks = std(all_vkicks); 
std_codx  = std(all_codx); 
std_cody  = std(all_cody); 
std_codxl = std(all_codxl); 
std_codyl = std(all_codyl); 

figure; hist(all_codx(:,end)/std_codx(end),50);

% shows results
clc;
fprintf('RESULTS RMS\n');
fprintf('===========\n');
fprintf('hkicks (avg) [mrad]: '); fprintf('%+f ', 1000*avg_hkicks); fprintf('\n');
fprintf('hkicks (std) [mrad]: '); fprintf('%+f ', 1000*std_hkicks); fprintf('\n');
fprintf('-- correctors --\n');
fprintf('vkicks (avg) [mrad]: '); fprintf('%+f ', 1000*avg_vkicks); fprintf('\n');
fprintf('vkicks (std) [mrad]: '); fprintf('%+f ', 1000*std_vkicks); fprintf('\n');
fprintf('-- cod @ end --\n');
fprintf('codx (std) [mm]  : '); fprintf('%+f ', 1000*std_codx(end)); fprintf('\n');
fprintf('codxl(std) [mrad]: '); fprintf('%+f ', 1000*std_codxl(end)); fprintf('\n');
fprintf('cody (std) [mm]  : '); fprintf('%+f ', 1000*std_cody(end)); fprintf('\n');
fprintf('codyl(std) [mrad]: '); fprintf('%+f ', 1000*std_codyl(end)); fprintf('\n');
fprintf('-- cod @ bpms --\n');
fprintf('codx(std)  @ bpms[mm]  : '); fprintf('%+f ', 1000*std_codx(r.bpms)); fprintf('\n');
fprintf('cody(std)  @ bpms[mm]  : '); fprintf('%+f ', 1000*std_cody(r.bpms)); fprintf('\n');

figure;
plot(findspos(lt,1:length(lt)), 1000*all_codx');
xlabel('pos [m]');
ylabel('codx [mm]');

figure;
plot(findspos(lt,1:length(lt)), 1000*all_cody');
xlabel('pos [m]');
ylabel('cody [mm]');

function orbit_correct_sys(r, lt)

r.lt = lt;
r.lt{1}.x = 0;
r.lt{1}.xl = 0;
r.lt{1}.y = 0;
r.lt{1}.yl = 0;
r.respm = calc_respm_cod_sys(lt, r.hcms, r.vcms);

[hkicks, vkicks, codx, cody, codxl, codyl] = calc_correction_sys(r);

% shows results
fprintf('RESULTS SYS\n');
fprintf('===========\n');
fprintf('hkicks [mrad]: '); fprintf('%+f ', 1000*hkicks); fprintf('\n');
fprintf('vkicks [mrad]: '); fprintf('%+f ', 1000*vkicks); fprintf('\n');
fprintf('-- cod @ end --\n');
fprintf('codx  [mm]  : '); fprintf('%+f ', 1000*codx(end)); fprintf('\n');
fprintf('codxl [mrad]: '); fprintf('%+f ', 1000*codxl(end)); fprintf('\n');
fprintf('cody  [mm]  : '); fprintf('%+f ', 1000*cody(end)); fprintf('\n');
fprintf('codyl [mrad]: '); fprintf('%+f ', 1000*codyl(end)); fprintf('\n');
fprintf('-- cod @ bpms --\n');
fprintf('codx @ bpms[mm]  : '); fprintf('%+f ', 1000*codx(r.bpms)); fprintf('\n');
fprintf('cody @ bpms[mm]  : '); fprintf('%+f ', 1000*cody(r.bpms)); fprintf('\n');



%% Aux. functions

function ltlb = add_errors(orig_ltlb, r)

ltlb = orig_ltlb;
errors = lnls_generate_random_numbers(r.tolx, length(ltlb), 'gauss', 1, 0);
ltlb = lnls_add_misalignmentX(errors, 1:length(ltlb), ltlb);
errors = lnls_generate_random_numbers(r.toly, length(ltlb), 'gauss', 1, 0);
ltlb = lnls_add_misalignmentY(errors, 1:length(ltlb), ltlb);
errors = lnls_generate_random_numbers(r.tole, length(ltlb), 'gauss', 1, 0);
ltlb = lnls_add_excitation(errors, 1:length(ltlb), ltlb);
ltlb{1}.x  = lnls_generate_random_numbers(r.sigmax, 1, 'gauss', 1, 0);
ltlb{1}.xl = lnls_generate_random_numbers(r.sigmaxl, 1, 'gauss', 1, 0);
ltlb{1}.y  = lnls_generate_random_numbers(r.sigmay, 1, 'gauss', 1, 0);
ltlb{1}.yl = lnls_generate_random_numbers(r.sigmayl, 1, 'gauss', 1, 0);

function plot_optics(ltlb, TwissDataIn)


TwissData  = twissline(ltlb,0, TwissDataIn, 1:length(ltlb)+1);
Betas = reshape([TwissData(:).beta],2,[]);
BX  = Betas(1,:);
BY  = Betas(2,:);
pos = findspos(ltlb, 1:length(ltlb)+1); 

close('all');
figure; hold all;
plot(pos, BX);
plot(pos, BY);
xlabel('Pos [m]');
ylabel('Beta [m]');

drawlattice(0,1,gca,ltlb);

function [codx, cody, codxl, codyl] = calc_cod(the_ring, init_orbit)

if ~exist('init_orbit','var')
	init_orbit = [0;0;0;0;0;0];
end
p = linepass(the_ring, init_orbit, 1:length(the_ring));
codx  = p(1,:);
cody  = p(3,:);
codxl = p(2,:);
codyl = p(4,:);


%% RMS functions 

function [the_ring, hkicks, vkicks, codx, cody, codxl, codyl] = cod_sg(cod_respm, nr_sing_values_x, nr_sing_values_y, the_ring0, bpms, hcms, vcms, nr_iterations, init_orbit, goal_codx, goal_cody)

the_ring = the_ring0;

S = cod_respm.Sx;
U = cod_respm.Ux;
V = cod_respm.Vx;

% selection of singular values
iS = diag(1./diag(S));
diS = diag(iS);
diS(nr_sing_values_x+1:end) = 0;
iS = diag(diS);
CMx = -(V*iS*U');

S = cod_respm.Sy;
U = cod_respm.Uy;
V = cod_respm.Vy;

% selection of singular values
iS = diag(1./diag(S));
diS = diag(iS);
diS(nr_sing_values_y+1:end) = 0;
iS = diag(diS);
CMy = -(V*iS*U');

for k=1:nr_iterations
    % calcs kicks
    [codx, cody, ~, ~] = calc_cod(the_ring);
    dx = codx(bpms); dy = cody(bpms);
    delt_hkicks =CMx * (dx' - goal_codx(:));
    delt_vkicks =CMy * (dy' - goal_cody(:));
    %delta_kick = CM * [dx' - goal_codx(:); dy' - goal_cody(:)];
    %delt_hkicks = delta_kick(1:length(hcms));
    %delt_vkicks = delta_kick((1+length(hcms)):end);
    init_hkicks = getcellstruct(the_ring, 'KickAngle', hcms, 1, 1);
    init_vkicks = getcellstruct(the_ring, 'KickAngle', vcms, 1, 2);
    tota_hkicks = init_hkicks + delt_hkicks;
    tota_vkicks = init_vkicks + delt_vkicks;
    the_ring = setcellstruct(the_ring, 'KickAngle', hcms, tota_hkicks, 1, 1);
    the_ring = setcellstruct(the_ring, 'KickAngle', vcms, tota_vkicks, 1, 2);
end
hkicks = getcellstruct(the_ring, 'KickAngle', hcms, 1, 1);
vkicks = getcellstruct(the_ring, 'KickAngle', vcms, 1, 2);
[codx, cody, codxl, codyl] = calc_cod(the_ring);

function [hkicks, vkicks, codx, cody, codxl, codyl] = calc_correction(r)

goal_codx = zeros(length(r.bpms),1);
goal_cody = zeros(length(r.bpms),1);
init_orbit = [r.lt{1}.x; r.lt{1}.xl; r.lt{1}.y; r.lt{1}.yl; 0; 0];
[~, hkicks, vkicks, codx, cody, codxl, codyl] = cod_sg(r.respm, r.nr_sing_values_x, r.nr_sing_values_y, r.lt, r.bpms, r.hcms, r.vcms, r.nr_iterations, init_orbit, goal_codx, goal_cody);




%% SYS functions

function [the_ring, hkicks, vkicks, codx, cody, codxl, codyl] = cod_sg_sys(cod_respm, nr_sing_values_x,  nr_sing_values_y, the_ring0, hcms, vcms, nr_iterations, init_orbit, goal_codx, goal_cody)

the_ring = the_ring0;

S = cod_respm.Sx;
U = cod_respm.Ux;
V = cod_respm.Vx;
iS = diag(1./diag(S));
diS = diag(iS);
diS(nr_sing_values_x+1:end) = 0;
iS = diag(diS);
CMx = -(V*iS*U');

S = cod_respm.Sy;
U = cod_respm.Uy;
V = cod_respm.Vy;
iS = diag(1./diag(S));
diS = diag(iS);
diS(nr_sing_values_y+1:end) = 0;
iS = diag(diS);
CMy = -(V*iS*U');


for k=1:nr_iterations
    % calcs kicks
    [codx, cody, codxl, codyl] = calc_cod(the_ring);
    % sets kicks
    delt_hkicks = CMx * [codx(end) - goal_codx(1); codxl(end) - goal_codx(2)];
    delt_vkicks = CMy * [cody(end) - goal_cody(1); codyl(end) - goal_cody(2)];
    init_hkicks = getcellstruct(the_ring, 'KickAngle', vcms, 1, 1);
    init_vkicks = getcellstruct(the_ring, 'KickAngle', vcms, 1, 2);
    tota_hkicks = init_hkicks + delt_hkicks;
    tota_vkicks = init_vkicks + delt_vkicks;
    the_ring = setcellstruct(the_ring, 'KickAngle', hcms, tota_hkicks, 1, 1);
    the_ring = setcellstruct(the_ring, 'KickAngle', vcms, tota_vkicks, 1, 2);
end
hkicks = getcellstruct(the_ring, 'KickAngle', hcms, 1, 1);
vkicks = getcellstruct(the_ring, 'KickAngle', vcms, 1, 2);
[codx, cody, codxl, codyl] = calc_cod(the_ring);

function [hkicks, vkicks, codx, cody, codxl, codyl] = calc_correction_sys(r)

goal_codx = [r.x_pos;r.x_ang];
goal_cody = [r.y_pos;r.y_ang];

r.nr_iterations = 5;
r.nr_sing_values_x = 2;
r.nr_sing_values_y = 2;
init_orbit = [r.lt{1}.x; r.lt{1}.xl; r.lt{1}.y; r.lt{1}.yl; 0; 0];
[~, hkicks, vkicks, codx, cody, codxl, codyl] = cod_sg_sys(r.respm, r.nr_sing_values_x, r.nr_sing_values_y, r.lt, r.hcms, r.vcms, r.nr_iterations, init_orbit, goal_codx, goal_cody);

function respm = calc_respm_cod_sys(lt, hcms, vcms)

step_kick = 0.00001;
 
the_ring = lt;
mxx = zeros(2,2);
for i=1:length(hcms)
    idx = hcms(i);
    the_ring{idx}.KickAngle = the_ring{idx}.KickAngle - 0.5 * [step_kick, 0];
    [codx1, cody1, codxl1, codyl1] = calc_cod(the_ring);
    the_ring{idx}.KickAngle = the_ring{idx}.KickAngle + 1.0 * [step_kick, 0];
    [codx2, cody2, codxl2, codyl2] = calc_cod(the_ring);
    the_ring{idx}.KickAngle = the_ring{idx}.KickAngle - 0.5 * [0 step_kick];
    mxx(:,i) = [(codx2(end)-codx1(end)), (codxl2(end)-codxl1(end))] / step_kick;
end


the_ring = lt;
myy = zeros(2,2);
for i=1:length(vcms)
    idx = vcms(i);
    the_ring{idx}.KickAngle = the_ring{idx}.KickAngle - 0.5 * [0 step_kick];
    [codx1, cody1, codxl1, codyl1] = calc_cod(the_ring);
    the_ring{idx}.KickAngle = the_ring{idx}.KickAngle + 1.0 * [0 step_kick];
    [codx2, cody2, codxl2, codyl2] = calc_cod(the_ring);
    the_ring{idx}.KickAngle = the_ring{idx}.KickAngle - 0.5 * [0 step_kick];
    myy(:,i) = [(cody2(end)-cody1(end)), (codyl2(end)-codyl1(end))] / step_kick;
end

[U,S,V] = svd(mxx,'econ');
respm.Ux = U;
respm.Vx = V;
respm.Sx = S;

[U,S,V] = svd(myy,'econ');
respm.Uy = U;
respm.Vy = V;
respm.Sy = S;

function respm = calc_respm_cod_rms(the_ring, bpm_idx, hcm_idx, vcm_idx, no_print)

if ~exist('no_print','var'), print=true; else print=false; end

if print, fprintf(['--- calc_cod_respm [' datestr(now) '] ---\n']); end;

step_kick = 0.00001;

if print
    fprintf('nr bpms: %03i\n', length(bpm_idx));
    fprintf('nr hcms: %03i\n', length(hcm_idx));
    fprintf('nr vcms: %03i\n', length(vcm_idx));
end

mxx = zeros(length(bpm_idx), length(hcm_idx));
for i=1:length(hcm_idx)
    idx = hcm_idx(i);
    the_ring{idx}.KickAngle = the_ring{idx}.KickAngle - 0.5 * [step_kick 0];
    [codx1, cody1, ~, ~] = calc_cod(the_ring);
    the_ring{idx}.KickAngle = the_ring{idx}.KickAngle + 1.0 * [step_kick 0];
    [codx2, cody2, ~, ~] = calc_cod(the_ring);
    the_ring{idx}.KickAngle = the_ring{idx}.KickAngle - 0.5 * [step_kick 0];
    mxx(:,i) = (codx2(bpm_idx) - codx1(bpm_idx)) / step_kick;
end 
 
myy = zeros(length(bpm_idx), length(vcm_idx));
for i=1:length(vcm_idx)
    idx = vcm_idx(i);
    the_ring{idx}.KickAngle = the_ring{idx}.KickAngle - 0.5 * [0 step_kick];
    [codx1, cody1, ~, ~] = calc_cod(the_ring);
    the_ring{idx}.KickAngle = the_ring{idx}.KickAngle + 1.0 * [0 step_kick];
    [codx2, cody2, ~, ~] = calc_cod(the_ring);
    the_ring{idx}.KickAngle = the_ring{idx}.KickAngle - 0.5 * [0 step_kick];
    myy(:,i) = (cody2(bpm_idx) - cody1(bpm_idx)) / step_kick;
end

[U,S,V] = svd(mxx,'econ');
respm.Ux = U;
respm.Vx = V;
respm.Sx = S;

[U,S,V] = svd(myy,'econ');
respm.Uy = U;
respm.Vy = V;
respm.Sy = S;


if print
    fprintf('singular values of X+Y cod response matrix:\n');
    for i=1:size(S,1)
        fprintf('%9.2E ', S(i,i));
        if rem(i,10) == 0, fprintf('\n'); end;
    end
    fprintf('\n');
    fprintf('\n');
end

