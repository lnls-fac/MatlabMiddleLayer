function calc_cod_sigma_from_vibrations

clc;
close('all');

p.coupling  = 1.0 * 0.01;
p.maxp      = 10.0 * 0.01;
p.selection = {'mia', 'mib', 'mc'};
%p.selection = 'all';



%p = girder0_AC20(p);
%p = girder1_AC20(p);
%p = girder2_AC20(p);
p = girder3_AC20(p);

%p = girder0_AC10(p);
%p = girder1_AC10(p);
%p = girder2_AC10(p);
%p = girder3_AC10(p);

calc_total_amps_and_tolerances(p);
plot_families_amps(p, {'b1','b2','b3', 'bc', 'qaf','qbf', 'qad','qbd1', 'qbd2', 'qf1','qf2','qf3','qf4'});
lnls_save_plots();


%% CASES

function p = girder0_AC20(p0)

p = p0;
p.mode = 'AC20';
p = load_girders1(p);
p = correlate_in_girders(p, {});

function p = girder1_AC20(p0)

p = p0;
p.mode = 'AC20';
p = load_girders1(p);
p = correlate_in_girders(p, {'girder_A','girder_B','girder_B1','girder_B2','girder_B3','girder_C1','girder_C2'});

function p = girder2_AC20(p0)

p = p0;
p.mode = 'AC20';
p = load_girders2(p);
p = correlate_in_girders(p, {'girder_A','girder_B','girder_B1B2','girder_BC'});

function p = girder3_AC20(p0)

p = p0;
p.mode = 'AC20';
p = load_girders3(p);
p = correlate_in_girders(p, {'girder_A','girder_B','girder_B2','girder_B3','girder_BC'});

function p = girder0_AC10(p0)

p = p0;
p.mode = 'AC10';
p = load_girders1(p);
p = correlate_in_girders(p, {});

function p = girder1_AC10(p0)

p = p0;
p.mode = 'AC10';
p = load_girders1(p);
p = correlate_in_girders(p, {'girder_A','girder_B','girder_B1','girder_B2','girder_B3','girder_C1','girder_C2'});

function p = girder2_AC10(p0)

p = p0;
p.mode = 'AC10';
p = load_girders2(p);
p = correlate_in_girders(p, {'girder_A','girder_B','girder_B1B2','girder_BC'});

function p = girder3_AC10(p0)

p = p0;
p.mode = 'AC10';
p = load_girders3(p);
p = correlate_in_girders(p, {'girder_A','girder_B','girder_B2','girder_B3','girder_BC'});


%% LOADS THERING AND CALCS AMP MATRIZ

function p = load_girders1(p0)

p = p0;

% important that elements in the model are NOT segmented!
p.the_ring = sirius_lattice_girder1(p.mode);
p.the_ring = single_segment_bc(p.the_ring);


if ischar(p.selection)
    p.obs_idxs = 1:length(p.the_ring);
else
    p.obs_idxs = [];
    for i=1:length(p.selection)
        p.obs_idxs = [p.obs_idxs findcells(p.the_ring, 'FamName', p.selection{i})];
    end
end

[p.Ax p.Ay] = calc_matrix(p.the_ring); setappdata(0, 'Ax', p.Ax); setappdata(0, 'Ay', p.Ay);
p.C = 1:size(p.Ax,1);

function p = load_girders2(p0)

p = p0;

% important that elements in the model are NOT segmented!
p.the_ring = sirius_lattice_girder2(p.mode);
p.the_ring = single_segment_bc(p.the_ring);

if ischar(p.selection)
    p.obs_idxs = 1:length(p.the_ring);
else
    p.obs_idxs = [];
    for i=1:length(p.selection)
        p.obs_idxs = [p.obs_idxs findcells(p.the_ring, 'FamName', p.selection{i})];
    end
end


[p.Ax p.Ay] = calc_matrix(p.the_ring); setappdata(0, 'Ax', p.Ax); setappdata(0, 'Ay', p.Ay);
p.C = 1:size(p.Ax,1);

function p = load_girders3(p0)

p = p0;

% important that elements in the model are NOT segmented!
p.the_ring = sirius_lattice_girder3(p.mode);
p.the_ring = single_segment_bc(p.the_ring);

if ischar(p.selection)
    p.obs_idxs = 1:length(p.the_ring);
else
    p.obs_idxs = [];
    for i=1:length(p.selection)
        p.obs_idxs = [p.obs_idxs findcells(p.the_ring, 'FamName', p.selection{i})];
    end
end

[p.Ax p.Ay] = calc_matrix(p.the_ring); setappdata(0, 'Ax', p.Ax); setappdata(0, 'Ay', p.Ay);
p.C = 1:size(p.Ax,1);



%% PLOT and CALC AMP functions

function plot_families_amps(p, families)

s = findspos(p.the_ring, 1:length(p.the_ring));
fx = figure;
fy = figure;
tot2x = 0 * s;
tot2y = 0 * s;
for i=1:length(families)
    idx = findcells(p.the_ring, 'FamName', families{i});
    ampx = sqrt(sum(p.Ax(idx,:).^2,1));
    ampy = sqrt(sum(p.Ay(idx,:).^2,1));
    tot2x = tot2x + ampx.^2;
    tot2y = tot2y + ampy.^2;
    figure(fx); hold all;
    plot(s, ampx);
    figure(fy); hold all;
    plot(s, ampy);
end

figure(fx);
plot(s, sqrt(tot2x));
plot(s, sqrt(p.correlated_ampx2));
xlabel('Pos [m]');
ylabel('Amplification Factor');
title('Horizontal Amplification Factors of Families');
axis([0, max(s)/9.99, 0, 1.1*max(sqrt(tot2x))]);
legend([families, 'TOTAL-U', 'TOTAL-C']);
set(gcf, 'Name', 'Horizontal Amp Factors for Families');

figure(fy);
plot(s, sqrt(tot2y));
plot(s, sqrt(p.correlated_ampy2));
xlabel('Pos [m]');
ylabel('Amplification Factor');
title('Vertical Amplification Factors of Families');
axis([0, max(s)/9.99, 0, 1.1*max(sqrt(tot2y))]);
legend([families, 'TOTAL-U', 'TOTAL-C']);
set(gcf, 'Name', 'Vertical Amp Factors for Families');

function calc_total_amps_and_tolerances(p)

s = findspos(p.the_ring, 1:length(p.the_ring));

sigmax = 1e-9;
sigmay = 1e-9;

uC = unique(p.C);
sigma2_codx = zeros(1,length(p.the_ring));
sigma2_cody = zeros(1,length(p.the_ring));
for i=1:length(uC)
    idx = find(p.C == uC(i));
    sigma2_codx = sigma2_codx + sum(p.Ax(idx,:),1).^2;
    sigma2_cody = sigma2_cody + sum(p.Ay(idx,:),1).^2;
end
sigma_codx = sqrt(sigma2_codx) * sigmax;
sigma_cody = sqrt(sigma2_cody) * sigmay;

optics = calctwiss(p.the_ring);
atsumm = atsummary(p.the_ring);
beamsizex = sqrt(optics.betax * atsumm.naturalEmittance + (optics.etax * atsumm.naturalEnergySpread).^2)';
beamsizey = sqrt(optics.betay * atsumm.naturalEmittance * p.coupling + (optics.etay * atsumm.naturalEnergySpread).^2)';


maxx = max(sigma_codx(p.obs_idxs) ./ beamsizex(p.obs_idxs));
maxy = max(sigma_cody(p.obs_idxs) ./ beamsizey(p.obs_idxs));

tolx = (p.maxp/maxx) * 1e-9;
toly = (p.maxp/maxy) * 1e-9;

AxU = sqrt(sum(p.Ax.^2,1));
AxC = sqrt(sigma2_codx);
AyU = sqrt(sum(p.Ay.^2,1));
AyC = sqrt(sigma2_cody);
fprintf('%15s -  X: %5.1f -> %5.1f Y: %5.1f -> %5.1f\n','TOTAL',max(AxU(p.obs_idxs)), max(AxC(p.obs_idxs)), max(AyU(p.obs_idxs)), max(AyC(p.obs_idxs)));
fprintf('StdDev Vib. X: %3.1f nm\n', 1e9*tolx);
fprintf('StdDev Vib. Y: %3.1f nm\n', 1e9*toly);
fprintf('Acoplamento  : %4.1f %%\n', 100*p.coupling); 

sigma_codx = sigma_codx * (tolx / 1e-9);
sigma_cody = sigma_cody * (toly / 1e-9);

figure;
hold all;
plot(s, 100 * sigma_codx ./ beamsizex);
xlabel('Pos [m]');
ylabel('Increase [%]');
title('Horizontal BeamSize Increase');
set(gcf, 'Name', 'Horizontal BeamSize Increase');

figure;
hold all;
plot(s, 100 * sigma_cody ./ beamsizey);
xlabel('Pos [m]');
ylabel('Increase [%]');
title('Vertical BeamSize Increase');
set(gcf, 'Name', 'Vertical BeamSize Increase');
   
function p = correlate_and_plot_girders_amps(p0, girder_label)

p = p0;

s = findspos(p.the_ring, 1:length(p.the_ring));
girder_idx = findcells(p.the_ring, 'FamName', girder_label);
girder_idx = reshape(girder_idx, 2, [])';

tu_ampx2 = zeros(1,length(p.the_ring));
tc_ampx2 = zeros(1,length(p.the_ring));
tu_ampy2 = zeros(1,length(p.the_ring));
tc_ampy2 = zeros(1,length(p.the_ring));
% loop over girders
for i=1:size(girder_idx,1)
    idx = girder_idx(i,1)+1:girder_idx(i,2)-1;
    tu_ampx2 = tu_ampx2 + sum(p.Ax(idx,:).^2,1);
    tc_ampx2 = tc_ampx2 + sum(p.Ax(idx,:),1).^2;
    tu_ampy2 = tu_ampy2 + sum(p.Ay(idx,:).^2,1);
    tc_ampy2 = tc_ampy2 + sum(p.Ay(idx,:),1).^2;
    minc = min(p.C(idx));
    p.C(idx) = minc; % correlates elements on the girder
end
tu_ampx = sqrt(tu_ampx2);
tc_ampx = sqrt(tc_ampx2);
tu_ampy = sqrt(tu_ampy2);
tc_ampy = sqrt(tc_ampy2);

p.correlated_ampx2 = p.correlated_ampx2 + tc_ampx2;
p.correlated_ampy2 = p.correlated_ampy2 + tc_ampy2;

figure;
hold all;
plot(s, tu_ampx);
plot(s, tc_ampx);
xlabel('Pos [m]');
ylabel('Amplification Factor');
title(['X Amplification Factor for ' strrep(girder_label, '_', '-')]);
legend({'Uncorrelated','Correlated'});
axis([0, max(s)/9.99, 0, max([max(tu_ampx) max(tc_ampx)])]); 
set(gcf, 'Name', [strrep(girder_label, '_', '-') ' Horizontal']);

figure;
hold all;
plot(s, tu_ampy);
plot(s, tc_ampy);
xlabel('Pos [m]');
ylabel('Amplification Factor');
title(['Y Amplification Factor for ' strrep(girder_label, '_', '-')]);
legend({'Uncorrelated','Correlated'});
axis([0, max(s)/9.99, 0, max([max(tu_ampy) max(tc_ampy)])]); 
set(gcf, 'Name', [strrep(girder_label, '_', '-') ' Vertical']);

fprintf('%15s -  X: %5.1f -> %5.1f Y: %5.1f -> %5.1f\n', girder_label, max(tu_ampx(p.obs_idxs)), max(tc_ampx(p.obs_idxs)), max(tu_ampy(p.obs_idxs)), max(tc_ampy(p.obs_idxs)));


%% AMPLIFICATION MATRIX

function [Ax Ay]= calc_matrix(the_ring)

delta_pos = 1e-6;

cod0 = findorbit4(the_ring, 0, 1:length(the_ring));

Ax = zeros(length(the_ring), length(the_ring));
Ay = zeros(length(the_ring), length(the_ring));
lnls_create_waitbar('Calc respm...', 0.1, length(the_ring));
for i=1:length(the_ring)
    
    new_ring = the_ring;
    new_ring = lattice_errors_set_misalignmentX(delta_pos, i, new_ring);
    cod = findorbit4(new_ring, 0, 1:length(new_ring));
    Ax(i,:) = (cod(1,:) - cod0(1,:)) / delta_pos;
    
    new_ring = the_ring;
    new_ring = lattice_errors_set_misalignmentY(delta_pos, i, new_ring);
    cod = findorbit4(new_ring, 0, 1:length(new_ring));
    Ay(i,:) = (cod(3,:) - cod0(3,:)) / delta_pos;
    
    lnls_update_waitbar(i);
    
end
lnls_delete_waitbar;

    
%% AUX FUNCTIONS

function p = correlate_in_girders(p0, girders_list)

p = p0;
p.correlated_ampx2 = zeros(1,length(p.the_ring));
p.correlated_ampy2 = zeros(1,length(p.the_ring));
for i=1:length(girders_list)
    p = correlate_and_plot_girders_amps(p, girders_list{i});
end

function new_ring = single_segment_bc(the_ring)

bc = findcells(the_ring, 'FamName', 'bc');
bc = reshape(bc, 2, [])';
new_ring  = the_ring;
for i=1:size(bc,1)
    new_ring{bc(i,1)}.BendingAngle = 2 * new_ring{bc(i,1)}.BendingAngle;
    new_ring{bc(i,1)}.ExitAngle = new_ring{bc(i,1)}.EntranceAngle;
end
new_ring(bc(:,2)) = [];

function new_ring = lattice_errors_set_misalignmentX(errors, indices, old_ring)

new_ring = old_ring;

for i=1:size(indices,1)
    new_error = [-errors(i) 0 0 0 0 0];
    for j=1:size(indices,2)
        idx = indices(i,j);
        if (isfield(new_ring{idx},'T1') == 1); % checa se o campo T1 existe
            new_ring{idx}.T1 = new_ring{idx}.T1 + new_error;
            new_ring{idx}.T2 = new_ring{idx}.T2 - new_error;
        end
    end
end

function new_ring = lattice_errors_set_misalignmentY(errors, indices, old_ring)

new_ring = old_ring;

for i=1:size(indices,1)
    new_error = [0 0 -errors(i) 0 0 0];
    for j=1:size(indices,2)
        idx = indices(i,j);
        if (isfield(new_ring{idx},'T1') == 1); % checa se o campo T1 existe
            new_ring{idx}.T1 = new_ring{idx}.T1 + new_error;
            new_ring{idx}.T2 = new_ring{idx}.T2 - new_error;
        end
    end
end


