function r = lnls_optimize_dynapt(config_name)

global THERING;

if ~exist('config_name', 'var')
    config_name = 'CONFIG01';
end

% adiciona caminhos ao PATH do matlab
rpath = fileparts(mfilename('fullpath'));
addpath(genpath(rpath));

% configuração e inicialização
r = eval(config_name);
r.config_name = config_name;
r.path = rpath;

if ~exist('THERING', 'var')
    fprintf('Please, load initialize your AT-MML system first!\n');
    return;
end

r.random_stream = RandStream('mt19937ar', 'Seed', 131071); % inicializa stream de numeros aleatorios.

r = load_previous_results(r);
if ~isfield(r, 'chrom_respm')
    r.chrom_respm = get_chrom_respm(r);
    config.the_ring = THERING;
    correct_chromaticity(r, [0 0]');
    [TD, tunes, chrom] = twissring(THERING, 0, 'chrom', 1e-8);
    fprintf('Chroms: %f %f\n', chrom);
    config.dynapt = calc_initial_dynapt(r.dynapt);
    config.fmerit = calc_figure_merit(config.dynapt);
    config.better = true;
    r.best_configs = config;
    save_results(r);
else
    better = find([r.best_configs.better]);
    config = r.best_configs(better(end));
    THERING = config.the_ring;
end

if isfield(r.dynapt, 'new_points_angle')
    config.dynapt.new_points_angle = r.dynapt.new_points_angle;
    config.fmerit = 0; % assim a primeira config gerada com novos ang é aceita.
end

figure;
hold on;
plot_results(r);

niter = 1;
while true
    
    new_config = config;
    new_config.the_ring = change_config(r);
    THERING = new_config.the_ring;
    new_config.dynapt = lnls_dynapt(config.dynapt);
    new_config.fmerit = calc_figure_merit(new_config.dynapt);
    
    if (new_config.fmerit >= config.fmerit)
        new_config.better = true;
        config = new_config;
    else
        new_config.better = false;
        THERING = config.the_ring;
        new_config.the_ring = 0;
    end
    
    if new_config.better
        fprintf('%04i: %8.3f * (%8.3f) mm\n', niter, new_config.fmerit, max([r.best_configs.fmerit]));
    else
        fprintf('%04i: %8.3f   (%8.3f) mm\n', niter, new_config.fmerit, max([r.best_configs.fmerit]));
    end
    r.best_configs(end+1) = new_config;
    
    save_results(r);
    plot_results(r);
    
    niter = niter + 1;
    
end

function plot_results(r)

clf;
hold on;
da = [];
nrpts = length(r.best_configs);
for i=1:nrpts
    da = [da; r.best_configs(i).dynapt.da_area(:)' r.best_configs(i).fmerit];
end
plot(1:nrpts, da(:,1), 'r');
plot(1:nrpts, da(:,2), 'b');
plot(1:nrpts, da(:,3), 'g');
plot(1:nrpts, da(:,4), 'k');

better = find([r.best_configs.better]);
scatter(better, da(better,1), 25, 'r', 'Filled');
scatter(better, da(better,2), 25, 'b', 'Filled');
scatter(better, da(better,3), 25, 'g', 'Filled');
scatter(better, da(better,4), 25, 'k', 'Filled');


function r = load_previous_results(r0)

r = r0;
filename = fullfile(r.path, 'CONFIGS', r.config_name, [r.config_name '.mat']);
if ~exist(filename, 'file'), return; end;
load(filename);
if isfield(r0.dynapt, 'new_points_angle')
    r.dynapt.new_points_angle = r0.dynapt.new_points_angle;
end

function save_results(r)

filename = fullfile(r.path, 'CONFIGS', r.config_name, [r.config_name '.mat']);
save(filename, 'r');


function new_ring = change_config(r)

global THERING;

change_sextupoles(r);
change_quadrupoles(r);

new_ring = THERING;

function change_quadrupoles(r)

global THERING;

fp = 1 + (r.quad_step_size/100) * 2 * (rand(r.random_stream) - 0.5);
fn = 1 + (r.quad_step_size/100) * 2 * (rand(r.random_stream) - 0.5);
qfams = findmemberof('quad');
THERING0 = THERING;
for i=1:length(qfams)
    v = getpv(qfams{i}, 'Physics');
    if v > 0, v = v * fp; else v = v * fn; end;
    setpv(qfams{i}, v, 'Physics');
end
[TD, tunes] = twissring(THERING, 0, 1:length(THERING)+1);

% respeita limite imposto sobre sintonias
if isfield(r, 'tune_max_frac')
    fractunes = TD(end).mu / (2*pi) - round(TD(end).mu / (2*pi));
    if any(fractunes > r.tune_max_frac)
        THERING = THERING0;
        [TD, tunes] = twissring(THERING, 0, 1:length(THERING)+1);
    end
end

fprintf('Tunes: %f %f\n', TD(end).mu / (2*pi));


function change_sextupoles(r)

global THERING;


% muda forças
for i=1:length(r.sext_harmo_fams)
    rn = rand(r.random_stream);
    delta_sext = 2*(rn - 0.5) * r.sext_step_size;
    steppv(r.sext_harmo_fams{i}, delta_sext);
end
% amarra familias?
% setpv('SSA1', getpv('SS1', [1 1], 'Physics'), 'Physics');
% setpv('SSB1', getpv('SS1', [1 1], 'Physics'), 'Physics');
% setpv('SSA2', getpv('SS2', [1 1], 'Physics'), 'Physics');
% setpv('SSB2', getpv('SS2', [1 1], 'Physics'), 'Physics');

if isfield(r, 'sext_pos_step_size')
    % muda posições
    change_sextupoles_positions(r);
end

r.chrom_respm = get_chrom_respm(r);
correct_chromaticity(r, [0 0]');
[TD, tunes, chrom] = twissring(THERING, 0, 'chrom', 1e-8);
fprintf('Chroms: %f %f\n', chrom);

function change_sextupoles_positions(r)

global THERING;

% quebrar simetria na posição?
all_sexts = [r.sext_harmo_fams r.sext_chrom_fams];
for i=1:length(all_sexts)
    ATIndex = getfamilydata(all_sexts{i}, 'AT', 'ATIndex');
    rn = rand(r.random_stream);
    delta_pos = r.sext_pos_step_size * 2*(rn-0.5);
    for j=1:size(ATIndex,1)
        i1 = ATIndex(j,1)-1;
        i2 = ATIndex(j,end)+1;
        if ~strcmpi(THERING{i1}.PassMethod, 'DriftPass') || ~strcmpi(THERING{i2}.PassMethod, 'DriftPass')
            fprintf('Either sextupole upstream element #%i or downstream element #%i is not a drift!\n', i1, i2);
            continue;
        end
        len1_old = THERING{i1}.Length;
        len2_old = THERING{i2}.Length;
        len1_new = len1_old + delta_pos;
        len2_new = len2_old - delta_pos;
        if (len1_new > 0) && (len2_new > 0)
            THERING{i1}.Length = len1_new; 
            THERING{i2}.Length = len2_new;
        end
    end
end

return;

% amarra familias
clone_fams = {'SSA1','SSB1','SSA2','SSB2'};
origi_fams = {'SS1','SS1','SS2','SS2'};
for i=1:length(clone_fams)
    ATIndex_origi = getfamilydata(origi_fams{i}, 'AT', 'ATIndex');
    ATIndex_clone = getfamilydata(clone_fams{i}, 'AT', 'ATIndex');
    for j=1:size(ATIndex_clone,1)
        i1_origi = ATIndex_origi(j,1)-1;
        i2_origi = ATIndex_origi(j,end)+1;
        i1_clone = ATIndex_clone(j,1)-1;
        i2_clone = ATIndex_clone(j,end)+1;
        THERING{i1_clone}.Length = THERING{i1_origi}.Length;
        THERING{i2_clone}.Length = THERING{i2_origi}.Length;
    end
end



function correct_chromaticity(r, golden_chrom)

global THERING

[TD, tunes, chrom0] = twissring(THERING, 0, 'chrom', 1e-8);

delta_sext = pinv(r.chrom_respm) * (golden_chrom(:) - chrom0(:));
for i=1:length(r.sext_chrom_fams)
    steppv(r.sext_chrom_fams{i}, delta_sext(i), 'Physics');
end

function fmerit = calc_figure_merit(dynapt)

% média geométrica das areas da aberturas dinâmicas de diferentes energias
fmerit = prod(dynapt.da_area) ^ (1/length(dynapt.da_area));

function dynapt = calc_initial_dynapt(dynapt0)

dynapt_tmp = dynapt0;
dynapt_tmp.energy_deviation = dynapt0.energy_deviation(1);
dynapt_tmp.points_angle = dynapt0.points_angle(1,:);
dynapt_tmp.points_radius = dynapt0.points_radius(1,:);
dynapt_tmp = lnls_dynapt(dynapt_tmp);

dynapt = dynapt_tmp;

for i=2:length(dynapt0.energy_deviation)
    
    dynapt_tmp.energy_deviation = dynapt0.energy_deviation(i);
    dynapt_tmp.points_angle = dynapt0.points_angle(i,:);
    dynapt_tmp.points_radius = dynapt.points_radius(end,:);
    dynapt_tmp = lnls_dynapt(dynapt_tmp);
    
    dynapt.energy_deviation(end+1) = dynapt_tmp.energy_deviation;
    dynapt.points_angle(end+1,:) = dynapt_tmp.points_angle;
    dynapt.points_radius(end+1,:) = dynapt_tmp.points_radius;
    dynapt.points_x(end+1,:) = dynapt_tmp.points_x;
    dynapt.points_y(end+1,:) = dynapt_tmp.points_y;
    dynapt.da_area(end+1) = dynapt_tmp.da_area;
    
end

function M = get_chrom_respm(r)

global THERING;

M = zeros(2, length(r.sext_chrom_fams));

[TD, tunes, chrom0] = twissring(THERING, 0, 'chrom', 1e-8);
for i=1:length(r.sext_chrom_fams)
    steppv(r.sext_chrom_fams{i},  r.sext_chrom_step);
    [TD, tunes, chrom] = twissring(THERING, 0, 'chrom', 1e-8);
    steppv(r.sext_chrom_fams{i}, -r.sext_chrom_step);
    delta_chrom = (chrom - chrom0);
    M(:,i) = delta_chrom(:);
end
M = M /r.sext_chrom_step;