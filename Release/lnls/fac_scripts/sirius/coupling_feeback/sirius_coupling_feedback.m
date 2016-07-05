function coupling_feedback


% --- initialization ---
close all; drawnow;
version = 'SI.E19.01';
run_initializations(version);

% --- loads/creates nominal machine ---
sim_anneal.qs_delta = 0.001;
sim_anneal.nr_iterations = 10000;
sim_anneal.scale_tilt = 0.5 * (pi / 180); 
sim_anneal.scale_sigmay = 0.5 * 1e-6;
target_coupling = 0.03;
save_fname = 'e19-01_3.0coup.mat';

%b2_selection = logical(repmat([1,0,1,0, 1,0,1,0],1,5)); % 20 B2
b2_selection = logical(repmat([1,0,0,0, 1,0,0,0],1,5)); % 10 B2
%b2_selection = logical(repmat([1,0,0,0, 0,0,0,0],1,5)); % 05 B2
%b2_selection = logical([[1,0,0,0, 0,0,0,0], repmat([0,0,0,0, 0,0,0,0],1,4)]); % 01 B2
%[r.nominal, r.indices] = create_nominal_machine(version, target_coupling, save_fname, sim_anneal, b2_selection);
[r.nominal, r.indices] = loads_nominal_machine(save_fname,b2_selection);


% --- loads random machines --- 
fname = '/home/fac_files/data/sirius/beam_dynamics/si.v19.01/calcs/s05.01/study.less_qs_configs/si.e19.01/cod_matlab/CONFIG_machines_cod_corrected_tune_coup_multi.mat';
%fname = '/home/fac_files/data/sirius/beam_dynamics/si.v18.01/oficial/s05.01/multi.cod.tune.coup/cod_matlab/CONFIG_machines_cod_corrected_tune_coup_multi.mat';
%fname = '/home/fac_files/data/sirius/beam_dynamics/si.v19.01/oficial/s05.01/multi.cod.tune.coup/cod_matlab/CONFIG_machines_cod_corrected_tune_coup_multi.mat';
r.machines = load_random_machines(fname, r.indices);


% --- adds qs from nominal machine to random machines ---
r.machines = enhance_lifetime(r.machines, r.nominal, r.indices);
show_summary_machines(r.machines, r.nominal, r.indices);

r.machines = calc_respm_machines(r.machines, r.indices);

for i=1:length(r.machines.machine)
    fprintf('machine #%02i\n', i);
    goal_tilt = r.machines.coupling{i}.tilt;
    [r.machines.machine{i}, ids] = insert_ids(r.machines.machine{i}, r.indices);
    r.machines.machine{i} = set_ids_configs(r.machines.machine{i}, ids);
    r.machines.coupling_ids{i} = calc_coupling(r.machines.machine{i}, r.indices);
    r.machines.feedback{i}.svd_nr_svs = length(r.machines.feedback{i}.S);
    r.machines.feedback{i}.svd_nr_iterations = 50;
    [r.machines.machine{i}, r.machines.coupling_ids_feedback{i}] = correct_coupling_tilt(r.machines.machine{i}, goal_tilt, r.machines.coupling_ids{i}, r.machines.feedback{i}, r.indices);
end
save(strrep(save_fname, 'coup', 'coup_1.0coup-ids_20b2_results'));


function [the_ring, ids] = insert_ids(the_ring0, indices)


the_ring = the_ring0;
idx = indices.ids(2:end); idx(2) = [];
indices_ids_coup = sort([idx-1, idx+1]);
nlk = [findcells(the_ring, 'FamName', 'nlk'); findcells(the_ring, 'FamName', 'pmm');];
for i=indices_ids_coup
    len = the_ring{i}.Length;
    fam = the_ring{i}.FamName;
    the_ring{i} = the_ring{nlk};
    the_ring{i}.Length = len;
    the_ring{i}.FamName = fam;
    the_ring{i}.PolynomA = 0 * the_ring{i}.PolynomA;
    the_ring{i}.PolynomB = 0 * the_ring{i}.PolynomB;
end
ids.indices_ids_coup = reshape(indices_ids_coup,2,[])';
ids.coupling_ss = ['mib','mib','mia','mib','mip','mib','mia','mib','mip','mib','mia','mib','mip','mib','mia','mib','mip','mib'];
ids.coupling_polynom_a_scale = [24,24,4,22,24,24,4,24,24,24,4,22,24,24,4,22,22,24]/1000;


function the_ring = set_ids_configs(the_ring0, ids)

the_ring = the_ring0;
polya = 2*(rand(1,length(ids.coupling_polynom_a_scale))-0.5) .* ids.coupling_polynom_a_scale;
for i=1:length(polya)
    the_ring = setcellstruct(the_ring, 'PolynomA', ids.indices_ids_coup(i,:), polya(i), 1, 2);
end


function [the_ring, coupling] = correct_coupling_tilt(the_ring0, goal_tilt, coupling, feedback, indices)

the_ring = the_ring0;

if ~isfield(feedback, 'svd_nr_svs')
    feedback.svd_nr_svs = length(feedback.S);
end

iS = pinv(feedback.S);
iS(feedback.svd_nr_svs+1:end) = 0;
iS = diag(iS);
    
target = goal_tilt(indices.b2)';
actual = coupling.tilt(indices.b2)';
residue = actual - target;
    
fprintf('%02i: %f ', 0, (180/pi)*std(residue));
for j=1:feedback.svd_nr_iterations
    qs      = -0.5 * (feedback.V*iS*feedback.U') * residue;
    for i=1:size(feedback.matrix,2)
        qs0 = getcellstruct(the_ring, 'PolynomA', indices.qs(i,:), 1, 2);
        the_ring = setcellstruct(the_ring, 'PolynomA', indices.qs(i,:), qs0 + qs(i), 1, 2);
    end
    coupling = calc_coupling(the_ring, indices);
    actual = coupling.tilt(indices.b2)';
    residue = actual - target;
    fprintf('%f ', j, (180/pi)*std(residue));
    if (mod(j,5)==0) 
        fprintf('\n');
    end
end


function machines = calc_respm_machines(machines0, indices)

machines = machines0;
for i=1:length(machines.machine)
    fprintf('response matrix for machine #%02i\n', i);
    machines.feedback{i} = calc_respm_tilt(machines.machine{i}, indices, true);
end


function machines = enhance_lifetime(machines0, nominal, indices)

machines = machines0;

nominal_qs = getcellstruct(nominal.the_ring, 'PolynomA', indices.qs, 1, 2);
for i=1:length(machines.machine)
    original_qs = getcellstruct(machines.machine{i}, 'PolynomA', indices.qs, 1, 2);
    new_qs = original_qs + nominal_qs;
    machines.machine{i} = setcellstruct(machines.machine{i}, 'PolynomA', indices.qs, new_qs, 1, 2);
    machines.coupling{i} = calc_coupling(machines.machine{i}, indices);
    
    fprintf('%02i: max_qs %.3f -> %.3f [1/m^2] | \n', i, max(abs(original_qs)), max(abs(new_qs)));
end


function show_summary_machines(machines, nominal, indices)

% tilt angle
f1 = figure; hold all;
for i=1:length(machines.machine)
    figure(f1);
    plot(indices.pos, (180/pi)*machines.coupling{i}.tilt, 'Color', [0.6,0.6,1.0]); drawnow
end
for i=1:length(machines.machine)
    figure(f1);
    scatter(indices.pos(indices.all), (180/pi)*machines.coupling{i}.tilt(indices.all), 50, [0.4,0.4,1], 'filled'); drawnow;
end
figure(f1);
scatter(indices.pos(indices.all), (180/pi)*nominal.coupling.tilt(indices.all), 50, [0.0,0.0,1], 'filled'); drawnow;
xlabel('pos [m]'); ylabel('angle [deg.]');

% sigmay
f1 = figure; hold all;
for i=1:length(machines.machine)
    figure(f1);
    plot(indices.pos, 1e6*machines.coupling{i}.sigmas(2,:), 'Color', [1.0,0.6,0.6]); drawnow
end
for i=1:length(machines.machine)
    figure(f1);
    scatter(indices.pos(indices.all), 1e6*machines.coupling{i}.sigmas(2,indices.all), 50, [1.0,0.4,0.4], 'filled'); drawnow;
end
figure(f1);
scatter(indices.pos(indices.all), 1e6*nominal.coupling.sigmas(2,indices.all), 50, [1.0,0.0,0.0], 'filled'); drawnow;
xlabel('pos [m]'); ylabel('sigmay [um]');


function run_initializations(version)

sirius(version);

%close all; drawnow;
seed = 131071;
RandStream.setGlobalStream(RandStream('mt19937ar','seed', seed));


function machines = load_random_machines(machines_fname, indices)

% loads random machines
machines.fname = machines_fname;
data = load(machines_fname);
machines.machine = data.machine;

% calcs coupling parameters
for i=1:length(machines.machine)
    [machines.machine{i}, ~, ~, ~, ~, ~, ~] = setradiation('On', machines.machine{i});
    machines.machine{i} = setcavity('On', machines.machine{i});
    machines.coupling{i} = calc_coupling(machines.machine{i}, indices);
end


function [nominal, indices] = create_nominal_machine(version, target_coupling, save_fname, sim_anneal, b2_selection)


% --- creates nominal machine ---
nominal.version = version;
nominal.target_coupling = target_coupling;
nominal.save_fname = save_fname;

if exist(save_fname, 'file')
    nominal = loads_nominal_machine(save_fname);
else
    nominal.the_ring = load_model(version);
    % calcs nominal sigmay
    tw = calctwiss(nominal.the_ring);
    tw.gammax = (1 + tw.alphax.^2) ./ tw.betax;
    tw.gammay = (1 + tw.alphay.^2) ./ tw.betay;
    as = atsummary(nominal.the_ring);
    ex = as.naturalEmittance / (1 + target_coupling);
    ey = target_coupling * as.naturalEmittance / (1 + target_coupling);
    nominal.sigmas(1,:) = sqrt(ex * tw.betax + (as.naturalEnergySpread * tw.etax).^2);
    nominal.sigmas(2,:) = sqrt(ey * tw.betay + (as.naturalEnergySpread * tw.etay).^2);
end

% --- builds vectors with various indices ---
if exist('b2_selection','var')
    indices = find_indices(nominal.the_ring, b2_selection);
else
    indices = find_indices(nominal.the_ring);
end

% --- searches for nominal machine ---
[r1, c1] = calc_residue(nominal.the_ring, indices, sim_anneal, nominal);
fprintf('%04i: %f\n', 0, r1);
[f1,p1,f2,p2] = update_sim_annel_plots(c1,indices, nominal);
for i=1:sim_anneal.nr_iterations
    drawnow;
    the_ring = vary_qs_in_families(nominal.the_ring, indices, sim_anneal);
    [r2, c2] = calc_residue(the_ring, indices, sim_anneal, nominal);
    if (r2 < r1)
       r1 = r2; c1 = c2; nominal.the_ring = the_ring;
       fprintf('%04i: %f\n', i, r1);
       [f1,p1,f2,p2] = update_sim_annel_plots(c1,indices,nominal,f1,p1,f2,p2);
       save(save_fname,'nominal');
    end
end


function [nominal, indices] = loads_nominal_machine(save_fname, b2_selection)

data = load(save_fname); 
nominal = data.nominal;
if exist('b2_selection','var')
    indices = find_indices(nominal.the_ring, b2_selection);
else
    indices = find_indices(nominal.the_ring);
end
nominal.coupling = calc_coupling(nominal.the_ring, indices);


function [f1, p1, f2, p2] = update_sim_annel_plots(coupling, indices, nominal, f1o, p1o, f2o, p2o)

maxsigmay = max(nominal.sigmas(2,:));
if ~exist('f1o','var')
    f1 = figure; hold all;
    p1{1} = plot(indices.pos, 1e6*coupling.sigmas(2,:), 'Color', [0.8, 0.8, 1]);
    p1{2} = scatter(indices.pos(indices.b2), 1e6*nominal.sigmas(2,indices.b2), 52, [0,0,1], 'filled');
    p1{3} = scatter(indices.pos(indices.b2), 1e6*coupling.sigmas(2,indices.b2), 50, [0.5,0.5,1], 'filled');
    figure(f1); ylim([0,1e6*1.2*maxsigmay]);
    f2 = figure; hold all;
    p2{1} = plot(indices.pos, (180/pi)*coupling.tilt, 'Color', [1, 0.8, 0.8]);
    p2{2} = scatter(indices.pos(indices.all), (180/pi)*coupling.tilt(indices.all), 50, [1,0.5,0.5], 'filled');
    figure(f2); ylim([-45,45]);
else
    f1 = f1o; p1 = p1o; f2 = f2o; p2 = p2o;
    set(p1{1}, 'YData', 1e6*coupling.sigmas(2,:)); 
    set(p1{2}, 'YData', 1e6*nominal.sigmas(2,indices.b2)); 
    set(p1{3}, 'YData', 1e6*coupling.sigmas(2,indices.b2));
    figure(f1); ylim([0,1e6*1.2*maxsigmay]);
    set(p2{1}, 'YData', (180/pi)*coupling.tilt); 
    set(p2{2}, 'YData', (180/pi)*coupling.tilt(indices.all)); 
    figure(f2); ylim([-45,45]);
end
drawnow;


function coupling = calc_coupling(the_ring, indices)

[ENV, ~, ~] = ohmienvelope(the_ring, indices.rad', 1:length(the_ring)+1);
coupling.sigmas = cat(2, ENV.Sigma);
coupling.tilt = cat(2, ENV.Tilt);


function [residue, coupling] = calc_residue(the_ring, indices, sim_anneal, nominal)

coupling = calc_coupling(the_ring, indices);

% r_tilt1 = sqrt(sum(coupling.tilt(indices.ids).^2)/length(indices.ids));
% r_tilt2 = sqrt(sum(coupling.tilt(indices.mic).^2)/length(indices.mic));
% r_tilt = 0.5 * r_tilt1 / sim_anneal.scale_tilt + 0.5 * r_tilt2 / (4*sim_anneal.scale_tilt);

r_tilt = sqrt(sum(coupling.tilt(indices.ids).^2)/length(indices.ids));
r_sigmay = sqrt(sum((coupling.sigmas(2,indices.b2) - 1*nominal.sigmas(2,indices.b2)).^2)/length(indices.b2));

%residue = 0.5 * r_tilt + 0.5 * (r_sigmay / sim_anneal.scale_sigmay);
residue = 0.5 * r_tilt / sim_anneal.scale_tilt + 0.5 * (r_sigmay / sim_anneal.scale_sigmay);


function the_ring = vary_qs_in_families(the_ring0, indices, sim_anneal)

sel_fam_idx = randi(length(indices.qs_fams),1,1);
delta_q = 2*(rand()-0.5)*sim_anneal.qs_delta;
q0 = getcellstruct(the_ring0, 'PolynomA', indices.qs_fams{sel_fam_idx}, 1, 2);
q1 = q0 + delta_q;
the_ring = setcellstruct(the_ring0, 'PolynomA', indices.qs_fams{sel_fam_idx}, q1, 1, 2);


function [indices, the_ring] = find_indices(the_ring0, b2_selection)

the_ring = the_ring0;

% --- builds vectors with various indices ---
data = sirius_si_family_data(the_ring);
indices.mia = findcells(the_ring, 'FamName', 'mia');
indices.mib = findcells(the_ring, 'FamName', 'mib');
indices.mip = findcells(the_ring, 'FamName', 'mip');
indices.mic = findcells(the_ring, 'FamName', 'mc');
indices.ids = sort([indices.mia, indices.mib, indices.mip]);
indices.all = sort([indices.ids, indices.mic]);
b2_seg_idx   = 8;  % corresponds to 13 mrad (correct value : ~16 mrad)
if exist('b2_selection','var')
    indices.b2  = data.b2.ATIndex(b2_selection,b2_seg_idx);
else
    indices.b2  = data.b2.ATIndex(:,b2_seg_idx);
end
indices.qs  = data.qs.ATIndex;
indices.pos = findspos(the_ring, 1:length(the_ring)+1);

famnames = unique(getcellstruct(the_ring, 'FamName', data.qs.ATIndex(:,1)));
indices.qs_fams = cell(1,length(famnames));
for i=1:length(famnames)
    idx = findcells(the_ring, 'FamName', famnames{i});
    indices.qs_fams{i} = reshape(intersect(idx, data.qs.ATIndex(:)), [], size(data.qs.ATIndex,2));
end
[the_ring, ~, ~, ~, ~, indices.rad, ~] = setradiation('On', the_ring);


function the_ring = load_model(version)

% add paths
lnls_setpath_mml_at;
siriuspath = fullfile(lnls_get_root_folder(),'code','MatlabMiddleLayer','Release','machine','SIRIUS',version);
addpath(siriuspath);

% creates model
the_ring = sirius_si_lattice();
[the_ring, ~, ~, ~, ~, ~, ~] = setradiation('On', the_ring);
the_ring = setcavity('On', the_ring);


function feedback = calc_respm_tilt(the_ring, indices, print_results)

feedback.delta_qs = 0.001;
feedback.matrix = zeros(size(indices.b2,1), size(indices.qs,1));

if ~exist('print_results','var')
    print_results = false;
end

if print_results
    fprintf('angle monitors at: ');
    names = unique(getcellstruct(the_ring, 'FamName', indices.b2));
    for i=1:length(names)
        fprintf('%s ', names{i});
    end; fprintf(' (%03i)\n', size(indices.b2,1));

    fprintf('skew correctors at: ');
    names = unique(getcellstruct(the_ring, 'FamName', indices.qs));
    for i=1:length(names)
        fprintf('%s ', names{i});
    end; fprintf(' (%03i)\n', size(indices.qs,1));
end

for i=1:size(feedback.matrix,2)
    if print_results
        fprintf('%03i ',i);
        if (rem(i,10) == 0)
            fprintf('\n');
        end
    end
    qs0 = getcellstruct(the_ring, 'PolynomA', indices.qs(i,:), 1, 2);
    the_ring = setcellstruct(the_ring, 'PolynomA', indices.qs(i,:), qs0 + feedback.delta_qs/2, 1, 2);
    coupling_p = calc_coupling(the_ring, indices);
    the_ring = setcellstruct(the_ring, 'PolynomA', indices.qs(i,:), qs0 - feedback.delta_qs/2, 1, 2);
    coupling_n = calc_coupling(the_ring, indices);
    the_ring = setcellstruct(the_ring, 'PolynomA', indices.qs(i,:), qs0, 1, 2);
    tilt = coupling_p.tilt(indices.b2) - coupling_n.tilt(indices.b2);
    feedback.matrix(:,i) = tilt / feedback.delta_qs;
end

[feedback.U, feedback.S, feedback.V] = svd(feedback.matrix, 'econ');
feedback.S = diag(feedback.S);


