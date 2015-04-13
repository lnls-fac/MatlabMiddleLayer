function r = fofb_on_IDs


%% input parameters
r.parms.brho          = 10;        % magnetic rigidity of the beam [T.m]
r.parms.nr_ids        = 20;        % number of IDs to include
r.parms.max_bx_int1   = 2  *1e-6; % [T.m]
r.parms.max_by_int1   = 2  *1e-6; % [T.m]
r.parms.nr_kicks      = 10;        % number of distributed kicks for each ID (even number)
r.parms.bpm_selection = repmat([1 0 0 0  1  0 0 0 1], 1, 20);
%r.parms.hcm_selection = repmat([1 1 1 1     1 1 1 1], 1, 20);
%r.parms.vcm_selection = repmat([1 1 1         1 1 1], 1, 20);
%r.parms.hcm_selection = repmat([1 1 0 0     0 0 1 1], 1, 20);
%r.parms.vcm_selection = repmat([1 1 0         0 1 1], 1, 20);
r.parms.hcm_selection = repmat([1 0 1 0     0 0 0 1], 1, 20);
r.parms.vcm_selection = repmat([1 0 1         0 0 1], 1, 20);

r.parms.nr_machines   = 50;
r.parms.coupling      = 1 / 100;


%% initializations
fclose('all'); close('all'); clc;
sirius;
RandStream.setDefaultStream(RandStream('mt19937ar','seed', 131071));

r = load_the_ring(r);
r = insert_kick_drift_elements_as_ids(r);

bpm = findcells(r.machine, 'FamName', 'BPM'); r.bpm_ind = bpm(r.parms.bpm_selection == 1);
hcm = findcells(r.machine, 'FamName', 'hcm'); r.hcm_ind = hcm(r.parms.hcm_selection == 1);
vcm = findcells(r.machine, 'FamName', 'vcm'); r.vcm_ind = vcm(r.parms.vcm_selection == 1);

r.respm = calc_respm_cod(r.machine, r.bpm_ind, r.hcm_ind, r.vcm_ind, true);

r.ref_orb = findorbit6(r.machine, 1:length(r.machine));


posx = []; posy = [];
angx = []; angy = [];
hkic = []; vkic = [];
for i=1:r.parms.nr_machines
    res = create_new_machine(r);
    posx = [posx; res.corrected_orb(1,:) - res.ref_orb(1,:)];
    posy = [posy; res.corrected_orb(3,:) - res.ref_orb(3,:)];
    angx = [angx; res.corrected_orb(2,:) - res.ref_orb(2,:)];
    angy = [angy; res.corrected_orb(4,:) - res.ref_orb(4,:)];
    hkic = [hkic; res.hkicks'];
    vkic = [vkic; res.vkicks'];
end

posx_std = std(posx);
posy_std = std(posy);
angx_std = std(angx);
angy_std = std(angy);
hkic_std = std(hkic);
vkic_std = std(vkic);

mia  = findcells(r.machine, 'FamName', 'mia');
mib  = findcells(r.machine, 'FamName', 'mib');
mbc  = findcells(r.machine, 'FamName', 'mc');



t = r;
t = insert_kick_drift_elements_as_ids(t);
b = calctwiss(t.machine);
b.gammax = (1 + b.alphax.^2)./b.betax;
b.gammay = (1 + b.alphay.^2)./b.betay;
ats = atsummary(t.machine);
sigmax  = sqrt(b.betax * ats.naturalEmittance + (b.etax * ats.naturalEnergySpread).^2)'; 
sigmaxl = sqrt(b.gammax * ats.naturalEmittance + (b.etaxl * ats.naturalEnergySpread).^2)'; 
sigmay  = sqrt(t.parms.coupling * b.betay * ats.naturalEmittance + (b.etay * ats.naturalEnergySpread).^2)'; 
sigmayl = sqrt(t.parms.coupling * b.gammay * ats.naturalEmittance + (b.etayl * ats.naturalEnergySpread).^2)'; 

clc;
fprintf('SUMMARY\n');
fprintf('-------\n');
fprintf('nr_ids            : %i\n', r.parms.nr_ids);
fprintf('nr_machines       : %i\n', r.parms.nr_machines);
fprintf('nr_bpms           : %i\n', length(find(r.parms.bpm_selection)));
fprintf('nr_hcms           : %i\n', length(find(r.parms.hcm_selection)));
fprintf('nr_vcms           : %i\n', length(find(r.parms.vcm_selection)));
fprintf('max_bx_int1 [G.cm]: %f\n', r.parms.max_bx_int1 * 1e6);
fprintf('max_by_int1 [G.cm]: %f\n', r.parms.max_by_int1 * 1e6);
fprintf('--- kicks ---\n');
fprintf('avg (hkicks_std)  [urad]: %6.2f\n', 1e6 * mean(hkic_std));
fprintf('avg (vkicks_std)  [urad]: %6.2f\n', 1e6 * mean(vkic_std));
fprintf('max (abs(hkicks)) [urad]: %6.2f\n', 1e6 * max(abs(hkic(:))));
fprintf('max (abs(vkicks)) [urad]: %6.2f\n', 1e6 * max(abs(vkic(:))));
fprintf('RESIDUAL ORBIT @        MIAs   MIBs   BCs   allBPMs\n');
fprintf('--- pos ---\n');
fprintf('mean sigmax     [um]: %6.2f %6.2f %6.2f %6.2f \n', 1e6*mean(sigmax(mia)),  1e6*mean(sigmax(mib)),  1e6*mean(sigmax(mbc)),  1e6*mean(sigmax(r.bpm_ind))); 
fprintf('max  posx_std   [um]: %6.2f %6.2f %6.2f %6.2f \n', 1e6*max(posx_std(mia)), 1e6*max(posx_std(mib)), 1e6*max(posx_std(mbc)), 1e6*max(posx_std(r.bpm_ind)));
fprintf('mean sigmay     [um]: %6.2f %6.2f %6.2f %6.2f \n', 1e6*mean(sigmay(mia)),  1e6*mean(sigmay(mib)),  1e6*mean(sigmay(mbc)),  1e6*mean(sigmay(r.bpm_ind))); 
fprintf('max  posy_std   [um]: %6.2f %6.2f %6.2f %6.2f \n', 1e6*max(posy_std(mia)), 1e6*max(posy_std(mib)), 1e6*max(posy_std(mbc)), 1e6*max(posy_std(r.bpm_ind)));
fprintf('--- ang ---\n');
fprintf('mean sigmaxl  [urad]: %6.2f %6.2f %6.2f %6.2f \n', 1e6*mean(sigmaxl(mia)), 1e6*mean(sigmaxl(mib)), 1e6*mean(sigmaxl(mbc)), 1e6*mean(sigmaxl(r.bpm_ind))); 
fprintf('max  angx_std [urad]: %6.2f %6.2f %6.2f %6.2f \n', 1e6*max(angx_std(mia)), 1e6*max(angx_std(mib)), 1e6*max(angx_std(mbc)), 1e6*max(angx_std(r.bpm_ind)));
fprintf('mean sigmayl  [urad]: %6.2f %6.2f %6.2f %6.2f \n', 1e6*mean(sigmayl(mia)), 1e6*mean(sigmayl(mib)), 1e6*mean(sigmayl(mbc)), 1e6*mean(sigmayl(r.bpm_ind))); 
fprintf('max angy_std  [urad]: %6.2f %6.2f %6.2f %6.2f \n', 1e6*max(angy_std(mia)), 1e2*max(angy_std(mib)), 1e6*max(angy_std(mbc)), 1e6*max(angy_std(r.bpm_ind)));

disp('ok');






function r = create_new_machine(r0)

r = r0;

r = set_ids_dipolar_field_errors(r);
%plot_cod(r.machine);
r.uncorrected_orb = findorbit6(r.machine, 1:length(r.machine));

[r.machine r.hkicks r.vkicks] = correct_cod(r, size(r.respm.S,1), 3, r.ref_orb);
%plot_cod(r.machine);

r.corrected_orb = findorbit6(r.machine, 1:length(r.machine));


% fprintf('\n\n');
% fprintf('CORRECTION:\n');
% fprintf('orbit@bpm  max_x  :(%5.1f -> %6.2f) um    max_y  :(%5.1f -> %6.2f) um\n', 1e6*max(abs(orb1_bpm(1,:))), 1e6*max(abs(orb2_bpm(1,:))), 1e6*max(abs(orb1_bpm(3,:))), 1e6*max(abs(orb2_bpm(3,:))));
% fprintf('orbit@bpm  max_xl :(%5.1f -> %6.2f) urad  max_yl :(%5.1f -> %6.2f) urad\n', 1e6*max(abs(orb1_bpm(2,:))), 1e6*max(abs(orb2_bpm(2,:))), 1e6*max(abs(orb1_bpm(4,:))), 1e6*max(abs(orb2_bpm(4,:))));
% fprintf('orbit@all  max_x  :(%5.1f -> %6.2f) um    max_y  :(%5.1f -> %6.2f) um\n', 1e6*max(abs(orb1(1,:))), 1e6*max(abs(orb2(1,:))), 1e6*max(abs(orb1(3,:))), 1e6*max(abs(orb2(3,:))));
% fprintf('corrector  max_hcm: %7.3f urad          max_vcm: %7.3f urad\n', 1e6 * max(abs(hkicks)), 1e6 * max(abs(vkicks)));




function [machine hkicks vkicks] = correct_cod(r, sv_list, nr_iterations, ref_orb)

fprintf(['--- correct_cod [' datestr(now) '] ---\n']);

machine = r.machine;

scale_x = 200e-6;
scale_y = 100e-6;

codx = zeros(1, length(r.machine));
cody = zeros(1, length(r.machine));

best_fm = Inf;
for s=sv_list
    [machine hkicks vkicks orb] = cod_sg(r, s, machine, nr_iterations, ref_orb);
    tcodx = orb(1,:); tcody = orb(3,:);
    fm = max([max(abs(tcodx))/scale_x; max(abs(tcody))/scale_y]);
    if (fm < best_fm)
        best_fm      = fm;
        best_hkicks  = hkicks;
        best_vkicks  = vkicks;
        best_machine = machine;
        best_codx    = tcodx;
        best_cody    = tcody;
    else
        machine = best_machine;
    end
end
% restores best config of orbit correction singular values
machine    = best_machine;
hkicks     = best_hkicks;
vkicks     = best_vkicks;

codx(1,:)    = best_codx;
cody(1,:)    = best_cody;
fprintf('codx[um] %6.2f(max) %6.2f(std) | cody[um] %6.2f(max) %6.2f(std) | max. kick x y [mrad] %5.3f %5.3f\n', 1e6*max(abs(codx(1,:))), 1e6*std(codx(1,:)), 1e6*max(abs(cody(1,:))), 1e6*std(cody(1,:)), 1e3*max(abs(hkicks)), 1e3*max(abs(vkicks)));


function [the_ring hkicks vkicks orb] = cod_sg(r, nr_sing_values, the_ring0, nr_iterations, ref_orb)

the_ring = the_ring0;

S = r.respm.S;
U = r.respm.U;
V = r.respm.V;

% selection of singular values
iS = diag(1./diag(S));
diS = diag(iS);
diS(nr_sing_values+1:end) = 0;
iS = diag(diS);
CM = -(V*iS*U');

for k=1:nr_iterations
    % calcs kicks
    orb = calc_cod(the_ring);
    codx = orb(1,r.bpm_ind)'; cody = orb(3,r.bpm_ind)';
    codx_ref = ref_orb(1,r.bpm_ind)'; cody_ref = ref_orb(3,r.bpm_ind)';
    delta_kick = CM * [codx - codx_ref; cody - cody_ref];
    % sets kicks
    delt_hkicks = delta_kick(1:length(r.hcm_ind));
    delt_vkicks = delta_kick((1+length(r.hcm_ind)):end);
    init_hkicks = getcellstruct(the_ring, 'KickAngle', r.hcm_ind, 1, 1);
    init_vkicks = getcellstruct(the_ring, 'KickAngle', r.vcm_ind, 1, 2);
    tota_hkicks = init_hkicks + delt_hkicks;
    tota_vkicks = init_vkicks + delt_vkicks;
    the_ring = setcellstruct(the_ring, 'KickAngle', r.hcm_ind, tota_hkicks, 1, 1);
    the_ring = setcellstruct(the_ring, 'KickAngle', r.vcm_ind, tota_vkicks, 1, 2);
end
hkicks = getcellstruct(the_ring, 'KickAngle', r.hcm_ind, 1, 1);
vkicks = getcellstruct(the_ring, 'KickAngle', r.vcm_ind, 1, 2);
orb = calc_cod(the_ring);







function plot_cod(the_ring)

global THERING;
THERING0 = THERING;
THERING = the_ring;
figure; plotcod;
THERING = THERING0;

function r = insert_kick_drift_elements_as_ids(r0)

% finds indices of ID straight sections
r = r0;
mia = findcells(r.the_ring, 'FamName', 'mia');
mib = findcells(r.the_ring, 'FamName', 'mib');
idx = sort([mia mib]); 

% finds US and DS indices for the ID straight sections
for i=1:length(idx)
    us(i) = idx(i); while (~strcmpi(r.the_ring{us(i)}.PassMethod, 'DriftPass')), us(i) = us(i) - 1; if (us(i) < 1), us(i) = length(r.the_ring); end; end;
    ds(i) = idx(i); while (~strcmpi(r.the_ring{ds(i)}.PassMethod, 'DriftPass')), ds(i) = ds(i) + 1; if (ds(i) > length(r.the_ring)), ds(i) = 1; end; end;
    IDKicksUS{i} = gen_kicks(r.the_ring, us(i), r.parms.nr_kicks/2);
    IDKicksDS{i} = gen_kicks(r.the_ring, ds(i), r.parms.nr_kicks/2);
end

% inserts distributed dipolar errors in the lattice model
the_ring = {};
for i=1:length(r.the_ring)
    idxus = find(i == us); idxds = find(i == ds);
    if ~isempty(idxus)
        the_ring = [the_ring IDKicksUS{idxus}];
    elseif ~isempty(idxds)
        the_ring = [the_ring IDKicksDS{idxds}];
    else
        the_ring = [the_ring r.the_ring{i}];
    end  
end

r.machine = the_ring;
idkicks = findcells(r.machine, 'FamName', 'IDKICKS');
nr_els = 3*(r.parms.nr_kicks/2);
nr_ss  = length(idx);
idkicks = [idkicks(end-nr_els+1:end) idkicks(1:end-nr_els)];
r.idkicks_ind = reshape(idkicks, [], nr_ss)';



function IDKicks = gen_kicks(the_ring, i, nr_kicks)

drift_element = the_ring{i};

L = drift_element.Length;
d = drift('IDKICKS', L/nr_kicks/2, 'DriftPass');
k = corrector('IDKICKS',0, [0 0], 'CorrectorPass');
ring = [];
for i=1:nr_kicks
    ring = [ring d k d];
end
IDKicks = buildlat(ring);

function r = set_ids_dipolar_field_errors(r0)

r = r0;

% zeros all previous ID kicks
idx = intersect(findcells(r.machine, 'FamName', 'IDKICKS'), findcells(r.machine, 'PassMethod', 'CorrectorPass'));
r.machine = setcellstruct(r.machine, 'KickAngle', idx, 0, 1, 1);
r.machine = setcellstruct(r.machine, 'KickAngle', idx, 0, 1, 2);

% selects straight sections randomly
rids = randperm(size(r.idkicks_ind, 1));
ids  = rids(1:r.parms.nr_ids);

% calcs upstream and downstream driftspaces (that will be converted into ID
% kicks) and randomly chooses dipolar integrated errors
for i=1:length(ids)
    %r.bx_int1(i) = r.parms.max_bx_int1 * 2 * (rand - 0.5);
    %r.by_int1(i) = r.parms.max_by_int1 * 2 * (rand - 0.5);
    r.bx_int1(i) = (-1 + 2 * randi([0 1])) * r.parms.max_bx_int1;
    r.by_int1(i) = (-1 + 2 * randi([0 1])) * r.parms.max_by_int1;
    fprintf('ID @ SS%02i -> Int1Bx:%+6.2E T.m  Int1By:%+6.2E T.m\n', ids(i), r.bx_int1(i), r.by_int1(i));
    r.machine = add_kicks(r.machine, r.parms.brho, r.idkicks_ind(ids(i),:), r.bx_int1(i), r.by_int1(i));
end

function machine = add_kicks(machine0, brho, idx, bx_int1, by_int1)

machine = machine0;
kick_idx = intersect(findcells(machine, 'PassMethod', 'CorrectorPass'), idx);
kickx = - (by_int1/brho) / length(kick_idx);
kicky = - (bx_int1/brho) / length(kick_idx);
kickx = (kickx/3) * 2*(rand(1,length(kick_idx)) - 0.5) + kickx;
kicky = (kicky/3) * 2*(rand(1,length(kick_idx)) - 0.5) + kicky;
machine = setcellstruct(machine, 'KickAngle', kick_idx, kickx, 1, 1);
machine = setcellstruct(machine, 'KickAngle', kick_idx, kicky, 1, 2);



function r = load_the_ring(r0)

global THERING

if isempty(getao())
    sirius;
end

setcavity('on');
setradiation('on');
    
r = r0;
r.the_ring = THERING;

function respm = calc_respm_cod(the_ring, bpm_ind, hcm_ind, vcm_ind, no_print)

if ~exist('no_print','var'), no_print=true; else no_print=false; end

if ~no_print, fprintf(['--- calc_cod_respm [' datestr(now) '] ---\n']); end;

step_kick = 0.0001;

if ~no_print
    fprintf('nr bpms: %03i\n', length(bpm_ind));
    fprintf('nr hcms: %03i\n', length(hcm_ind));
    fprintf('nr vcms: %03i\n', length(vcm_ind));
end

mxx = zeros(length(bpm_ind), length(hcm_ind));
myx = zeros(length(bpm_ind), length(hcm_ind));
lnls_create_waitbar('Calcs H-COD Response Matrix',0.5,length(hcm_ind));
for i=1:length(hcm_ind)
    idx = hcm_ind(i);
    the_ring{idx}.KickAngle = the_ring{idx}.KickAngle - 0.5 * [step_kick 0];
    %[codx1 cody1] = calc_cod(the_ring);
    orb1 = calc_cod(the_ring);
    the_ring{idx}.KickAngle = the_ring{idx}.KickAngle + 1.0 * [step_kick 0];
    orb2 = calc_cod(the_ring);
    %[codx2 cody2] = calc_cod(the_ring);
    the_ring{idx}.KickAngle = the_ring{idx}.KickAngle - 0.5 * [step_kick 0];
    mxx(:,i) = (orb2(1,bpm_ind) - orb1(1,bpm_ind)) / step_kick;
    myx(:,i) = (orb2(3,bpm_ind) - orb1(3,bpm_ind)) / step_kick;
    lnls_update_waitbar(i);
end
lnls_delete_waitbar;

mxy = zeros(length(bpm_ind), length(vcm_ind));
myy = zeros(length(bpm_ind), length(vcm_ind));
lnls_create_waitbar('Calcs V-COD Response Matrix',0.5,length(vcm_ind));
for i=1:length(vcm_ind)
    idx = vcm_ind(i);
    the_ring{idx}.KickAngle = the_ring{idx}.KickAngle - 0.5 * [0 step_kick];
    %[codx1 cody1] = calc_cod(the_ring);
    orb1 = calc_cod(the_ring);
    the_ring{idx}.KickAngle = the_ring{idx}.KickAngle + 1.0 * [0 step_kick];
    %[codx2 cody2] = calc_cod(the_ring);
    orb2 = calc_cod(the_ring);
    the_ring{idx}.KickAngle = the_ring{idx}.KickAngle - 0.5 * [0 step_kick];
    mxy(:,i) = (orb2(1,bpm_ind) - orb1(1,bpm_ind)) / step_kick;
    myy(:,i) = (orb2(3,bpm_ind) - orb1(3,bpm_ind)) / step_kick;
    
    lnls_update_waitbar(i);
end
lnls_delete_waitbar;

[U,S,V] = svd([mxx mxy; myx myy],'econ');
respm.mxx = mxx;
respm.mxy = mxy;
respm.myx = myx;
respm.myy = myy;
respm.U = U;
respm.V = V;
respm.S = S;

if ~no_print
    fprintf('singular values of X+Y cod response matrix:\n');
    for i=1:size(S,1)
        fprintf('%9.2E ', S(i,i));
        if rem(i,10) == 0, fprintf('\n'); end;
    end
    fprintf('\n');
    fprintf('\n');
end


function orb = calc_cod(the_ring)

orb = findorbit6(the_ring, 1:length(the_ring));
