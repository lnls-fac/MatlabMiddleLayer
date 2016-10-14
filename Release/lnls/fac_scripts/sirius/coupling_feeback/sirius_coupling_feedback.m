function feedback = sirius_coupling_feedback

close all; drawnow; fprintf('\n\n');
setappdata(0,'sirius_cfb_run_all', false);


setappdata(0,'sirius_cfb_run_at', '');
% setappdata(0,'sirius_cfb_run_at', 'the_ring_coup');
% setappdata(0,'sirius_cfb_run_at', 'random_machines');
% setappdata(0,'sirius_cfb_run_at', 'random_machines_opt');
%setappdata(0,'sirius_cfb_run_at', 'random_machines_opt_ids');
setappdata(0,'sirius_cfb_run_at', 'calc_respm');


% --- load nominal machine ---
if strcmp(getappdata(0,'sirius_cfb_run_at'), '')
    the_ring.lattice_version = 'SI.V18.01';
    save('results.mat'); setappdata(0,'sirius_cfb_run_all',true);
    clear('the_ring');
end

% --- generate nominal machine with controlled coupling
if getappdata(0,'sirius_cfb_run_all') || strcmp(getappdata(0,'sirius_cfb_run_at'), 'the_ring_coup')
    load('results.mat');
    coup.target_coupling = 3.0/100;
    coup.sim_anneal.qs_delta = 0.001/2;
    coup.sim_anneal.nr_iterations = 0*10000;
    coup.sim_anneal.scale_tilt = 0.5 * (pi / 180); 
    coup.sim_anneal.scale_sigmay = 0.5 * 1e-6;
    coup.fname_the_ring_coup = [the_ring.lattice_version, '-ring_coup3p0-5.1016.mat'];
    the_ring_coup = generate_the_ring_with_controlled_coupling(the_ring, coup); clear('coup'); clear('the_ring');
    save('results.mat'); setappdata(0,'sirius_cfb_run_all',true);
    clear('the_ring_coup');
end

% --- load random machines ---
if getappdata(0,'sirius_cfb_run_all') || strcmp(getappdata(0,'sirius_cfb_run_at'), 'random_machines')
    load('results.mat');
    fname_random_machines = '/home/fac_files/data/sirius/beam_dynamics/si.v18.01/oficial/s05.01/multi.cod.tune.coup/cod_matlab/CONFIG_machines_cod_corrected_tune_coup_multi.mat';
    random_machines = load_random_machines(fname_random_machines); clear('fname_random_machines');
    save('results.mat'); setappdata(0,'sirius_cfb_run_all',true);
    clear('random_machines'); clear('the_ring_coup');
end

% --- control coupling of random machines
if getappdata(0,'sirius_cfb_run_all') || strcmp(getappdata(0,'sirius_cfb_run_at'), 'random_machines_opt')
    load('results.mat'); 
    random_machines_opt = optimize_lifetime_random_machines(random_machines, the_ring_coup); 
    clear('random_machines'); clear('the_ring_coup');
    save('results.mat'); setappdata(0,'sirius_cfb_run_all',true);
    clear('random_machines_opt'); 
end

% --- insert IDs into random lattices
if getappdata(0,'sirius_cfb_run_all') || strcmp(getappdata(0,'sirius_cfb_run_at'), 'random_machines_opt_ids')
    id_coupling_label = 'SI.V18.01, 1% coupling IDs';
    load('results.mat'); if ~exist('random_machines_opt','var'), random_machines_opt = random_machines_opt_ids.random_machines_opt; end
    show_summary_machines(random_machines_opt, 'random machines with controlled coupling');
    ids_config = get_coupling_polynom_a_scale(id_coupling_label);
    random_machines_opt_ids = insert_ids(random_machines_opt, ids_config);
    clear('ids_config'); clear('random_machines_opt'); clear('id_coupling_label');
    save('results.mat'); setappdata(0,'sirius_cfb_run_all',true);
    clear('random_machines_opt_ids');
end

% --- run coupling feedback on random machines ---
if getappdata(0,'sirius_cfb_run_all') || strcmp(getappdata(0,'sirius_cfb_run_at'), 'calc_respm')
    load('results.mat'); if ~exist('random_machines_opt_ids','var'), random_machines_opt_ids = feedback.random_machines_opt_ids; end
    %show_summary_machines(random_machines_opt_ids, 'random machines with IDs on');
    %b2_selection = logical(repmat([1,0,1,0, 1,0,1,0],1,5)); % for 20 B2 beamlines
    b2_selection = logical(repmat([1,0,0,0, 1,0,0,0],1,5)); % for 10 B2 beamlines
    %b2_selection = logical(repmat([1,0,0,0, 0,0,0,0],1,5)); % for 05 B2 beamlines
    %b2_selection = logical([[1,0,0,0, 0,0,0,0], repmat([0,0,0,0, 0,0,0,0],1,4)]); % for 01 B2 beamlines
    feedback.respm = calc_feedback_respm(random_machines_opt_ids, b2_selection);
    clear('b2_selection'); clear('random_machines_opt_ids'); clear
    save('results.mat'); setappdata(0,'sirius_cfb_run_all',true);
end
    




% 
% 
% 
% % --- calc IDs polynom_a scale ---
% id_coup_strength = 1.0/100;
% ids = get_coupling_polynom_a_scale(id_coup_strength, the_ring);
% 
% 
% config.target_coupling = 0.03;
% config.fname_nominal_machine = 'nominal_SI.V18.01_coup3p0.mat';
% 
% config.id_coupling = 0.01;
% config.feedback.nr_b2 = 10;
% 
% % --- select number of b2 in feedback ---
% config.b2_selection = get_b2_selection(config);
% 
% %config.fname_random_machines = '/home/fac_files/data/sirius/beam_dynamics/si.v20.01/oficial/s05.01/multi.cod.tune.coup/cod_matlab/CONFIG_machines_cod_corrected_tune_coup_multi.mat';
% config.fname_random_machines = '/home/fac_files/data/sirius/beam_dynamics/si.v18.01/oficial/s05.01/multi.cod.tune.coup/cod_matlab/CONFIG_machines_cod_corrected_tune_coup_multi.mat';
% 
% 
% % --- generate nominal machine with controled coupling
% [r.nominal, r.indices] = create_nominal_machine(r, config);
% close all; now;
% 
% [the_ring0, ids] = insert_ids(r.the_ring0, r.indices);
% % % --- shows coupling for IDs polynom_a scales ---
% % ids.coupling_polynom_a_scale = coupling_polynom_a_scale;
% % for i=1:size(ids.indices_ids_coup,1) 
% %     the_ring = setcellstruct(the_ring0, 'PolynomA', ids.indices_ids_coup(i,:), ids.coupling_polynom_a_scale(i), 1, 2);
% %     [Tilt, Eta, EpsX, EpsY, Ratio, ENV, DP, DL, sigmas] = calccoupling(the_ring);
% %     fprintf('ID %03i: coupling %f %%\n', i, 100*Ratio);
% % end
%     
%     
% % --- load random machines ---
% r.machines = load_random_machines(config.fname_random_machines, r.indices);
%     
% % --- add qs from nominal machine to random machines ---
% r.machines = add_dqs_to_random_machines(r.machines, r.nominal, r.indices);
% show_summary_machines(r.machines, r.nominal, r.indices);
% 
% % --- add ids to machines ---
% ids.coupling_polynom_a_scale = coupling_polynom_a_scale;
% for i=1:length(r.machines.machine)
%     [r.machines.machine{i}, ~] = insert_ids(r.machines.machine{i}, r.indices);
%     r.machines.machine_ids{i} = set_ids_configs(r.machines.machine{i}, ids);
%     r.machines.coupling_ids{i} = calc_coupling(r.machines.machine_ids{i}, r.indices);
% end
% 
% save(fname,'r');
% close all; drawnow;
% 
% % --- calc feedback matrix ---
% if exist('feedback.mat','file')
%     data = load('feedback.mat'); r.machines.feedback = data.feedback;
% else
%     r.machines = calc_respm_machines(r.machines, r.indices);
%     feedback = r.machines.feedback; save('feedback.mat', 'feedback');
% end
%     
% % --- apply feedback ---
% for i=1:length(r.machines.machine)
%     fprintf('machine #%02i\n', i);
%     goal_tilt = r.machines.coupling{i}.tilt;
%     [r.machines.machine{i}, ~] = insert_ids(r.machines.machine{i}, r.indices);
%     r.machines.machine{i} = set_ids_configs(r.machines.machine{i}, ids);
%     r.machines.coupling_ids{i} = calc_coupling(r.machines.machine{i}, r.indices);
%     r.machines.feedback{i}.svd_nr_svs = length(r.machines.feedback{i}.S);
%     r.machines.feedback{i}.svd_nr_iterations = 100;
%     [r.machines.machine{i}, r.machines.coupling_ids_feedback{i}] = correct_coupling_tilt(r.machines.machine{i}, goal_tilt, r.machines.coupling_ids{i}, r.machines.feedback{i}, r.indices);
% end
% 
% % --- save results ---
% save('results.mat');


function the_ring_coup = generate_the_ring_with_controlled_coupling(the_ring, coup)

fprintf(['-- generating the_ring with controlled coupling [', datestr(now), ']\n']);

fname = fullfile(pwd(), coup.fname_the_ring_coup);
if exist(fname,'file')
    fprintf(['   . !!! reading data from file ', fname, '\n']);
    data = load(fname); the_ring_coup = data.the_ring_coup;
else
    % loads model
    fprintf('   . loading lattice model\n');
    the_ring_coup.the_ring = load_model(the_ring.lattice_version);
    
    % calcs nominal sigmay
    fprintf('   . calculating nominal optics\n');
    tw = calctwiss(the_ring_coup.the_ring.lattice);
    tw.gammax = (1 + tw.alphax.^2) ./ tw.betax;
    tw.gammay = (1 + tw.alphay.^2) ./ tw.betay;
    as = atsummary(the_ring_coup.the_ring.lattice);
    k = coup.target_coupling;
    ex = as.naturalEmittance / (1 + k);
    ey = k * as.naturalEmittance / (1 + k);
    the_ring_coup.coup.nominal_sigmas(1,:) = sqrt(ex * tw.betax + (as.naturalEnergySpread * tw.etax).^2);
    the_ring_coup.coup.nominal_sigmas(2,:) = sqrt(ey * tw.betay + (as.naturalEnergySpread * tw.etay).^2);
    % initial search lattice
    the_ring_coup.lattice_coup = the_ring_coup.the_ring.lattice;
end
the_ring_coup.coup.sim_anneal = coup.sim_anneal;


% --- searches for nominal machine ---
fprintf('   . simulated annealing search\n');
[r1, t1, s1, c1] = calc_residue(the_ring_coup.lattice_coup, the_ring_coup.the_ring.indices, coup.sim_anneal, the_ring_coup.coup.nominal_sigmas);
the_ring_coup.coupling = c1;
save(coup.fname_the_ring_coup,'the_ring_coup');
fprintf('   trial residue ... \n');
fprintf('   %04i: %f  | %7.3f [deg] | %7.3f [um]\n', 0, r1, (180/pi)*t1, 1e6*s1); 
[f1,p1,f2,p2] = update_sim_annel_plots(c1,the_ring_coup.the_ring.indices, the_ring_coup.coup.nominal_sigmas);
for i=1:coup.sim_anneal.nr_iterations
    drawnow;
    new_lattice = vary_qs_in_families(the_ring_coup.lattice_coup, the_ring_coup.the_ring.indices, coup.sim_anneal);
    [r2, t2, s2, c2] = calc_residue(new_lattice, the_ring_coup.the_ring.indices, coup.sim_anneal, the_ring_coup.coup.nominal_sigmas);
    ratio = max(c2.sigmas(2,:))/mean(c2.sigmas(2,:));
    if (r2 < r1) && (ratio < 3);
        r1 = r2; t1 = t2; s1 = s2; c1 = c2; 
        the_ring_coup.lattice_coup = new_lattice;
        the_ring_coup.coupling = c1;
        fprintf('   %04i: %f  | %7.3f [deg] | %7.3f [um]\n', i, r1, (180/pi)*t1, 1e6*s1); 
        [f1,p1,f2,p2] = update_sim_annel_plots(c1,the_ring_coup.the_ring.indices,the_ring_coup.coup.nominal_sigmas,f1,p1,f2,p2);
        save(coup.fname_the_ring_coup,'the_ring_coup');
    end
end

[~, ~, ~, ~, the_ring_coup.emittances_ratio, ~, ~, ~, ~] = calccoupling(the_ring_coup.lattice_coup);
fprintf('   ey/ex = %.2f%%\n', 100*the_ring_coup.emittances_ratio);

fprintf('\n\n');

function the_ring = load_model(lattice_version)

% add paths
the_ring.lattice_version = lattice_version;
lnls_setpath_mml_at;
siriuspath = fullfile(lnls_get_root_folder(),'code','MatlabMiddleLayer','Release','machine','SIRIUS',lattice_version);
addpath(siriuspath);

% creates model
the_ring.lattice = sirius_si_lattice();
[the_ring.lattice, ~, ~, ~, ~, ~, ~] = setradiation('On', the_ring.lattice);
the_ring.lattice = setcavity('On', the_ring.lattice);

% finding lattice indices
fprintf('   . finding lattice indices\n');
the_ring.indices = find_indices(the_ring.lattice);

function indices = find_indices(the_ring0)

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
indices.b2  = data.b2.ATIndex(:,b2_seg_idx);
indices.qs  = data.qs.ATIndex;
indices.pos = findspos(the_ring, 1:length(the_ring)+1);

% cluster qs indices in families
famnames = unique(getcellstruct(the_ring, 'FamName', data.qs.ATIndex(:,1)));
indices.qs_fams = cell(1,length(famnames));
for i=1:length(famnames)
    idx = findcells(the_ring, 'FamName', famnames{i});
    indices.qs_fams{i} = reshape(intersect(idx, data.qs.ATIndex(:)), [], size(data.qs.ATIndex,2));
end
[~, ~, ~, ~, ~, indices.rad, ~] = setradiation('On', the_ring);

function [residue, r_tilt, r_sigmay, coupling] = calc_residue(the_ring, indices, sim_anneal, nominal_sigmas)

coupling = calc_coupling(the_ring, indices);


r_tilt = sqrt(sum(coupling.tilt(indices.ids).^2)/length(indices.ids));
%r_sigmay = sqrt(sum((real(coupling.sigmas(2,indices.b2)) - 1*nominal.sigmas(2,indices.b2)).^2)/length(indices.b2));
r_sigmay = sqrt(sum((real(coupling.sigmas(2,1:end-1)) - 1*nominal_sigmas(2,:)).^2)/size(nominal_sigmas,2));
residue = 0.5 * r_tilt / sim_anneal.scale_tilt + 0.5 * (r_sigmay / sim_anneal.scale_sigmay);

function coupling = calc_coupling(the_ring, indices)

[ENV, ~, ~] = my_ohmienvelope(the_ring, indices.rad', 1:length(the_ring)+1);
coupling.sigmas = cat(2, ENV.Sigma);
coupling.tilt = cat(2, ENV.Tilt);
coupling.tiltl = cat(2, ENV.TiltL);

function [ENVELOPE, RMSDP, RMSBL] = my_ohmienvelope(RING,RADELEMINDEX,varargin)
%OHMIENVELOPE calculates equilibrium beam envelope in a 
% circular accelerator using Ohmi's beam envelope formalism [1]
% [1] K.Ohmi et al. Phys.Rev.E. Vol.49. (1994)
% 
% [ENVELOPE, RMSDP, RMSBL] = OHMIENVELOPE(RING,RADELEMINDEX,REFPTS)
% 
% ENVELOPE is a structure with fields
% Sigma   - [SIGMA(1); SIGMA(2)] - RMS size [m] along 
%           the principal axis of a tilted ellips 
%           Assuming normal distribution exp(-(Z^2)/(2*SIGMA))
% Tilt    - Tilt angle of the XY ellips [rad]
%           Positive Tilt corresponds to Corkscrew (right) 
%           rotatiom of XY plane around s-axis
% R       - 6-by-6 equilibrium envelope matrix R
%
% RMSDP   - RMS momentum spread 
% RMSBL   - RMS bunch length[m]
% modified by Fernando (2015-01-29) for improvement in speed.

NumElements = length(RING);
 
[MRING, MS, orbit] = findm66(RING,1:NumElements+1);

B = cell(1,NumElements); % B{i} is the diffusion matrix of the i-th element
BATEXIT = B;             % BATEXIT{i} is the cumulative diffusion matrix from 
                         % element 0 to the end of the i-th element

% calculate Radiation-Diffusion matrix B for elements with radiation
for i = RADELEMINDEX
   B{i} = findmpoleraddiffmatrix(RING{i},orbit(:,i));
end

% Calculate cumulative Radiation-Diffusion matrix for the ring
BCUM = zeros(6,6); % Cumulative diffusion matrix of the entire ring

% Calculate 6-by-6 linear transfer matrix in each element
% near the equilibrium orbit 
for i = 1:NumElements
   % Fernando: I changed the direct calculation of the element Matrix by
   % the manipulation of the result obtained in MS, to speed up the
   % process:
%    ELEM = RING{i};
%    M = findelemm66(ELEM,ELEM.PassMethod,orbit(:,i));
   M =  MS(:,:,i+1)/MS(:,:,i);
   % Set Radiation-Diffusion matrix B to 0 in elements without radiation
   if ~isempty(B{i})
       BCUM = M*BCUM*M' + B{i};
   else
       BCUM = M*BCUM*M';
   end
   BATEXIT{i} = BCUM;
end

% ------------------------------------------------------------------------
% Equation for the moment matrix R is
%         R = MRING*R*MRING' + BCUM;
% We rewrite it in the form of Lyapunov equation to use MATLAB's LYAP function
%            AA*R + R*BB = -CC  
% where 
%				AA =  inv(MRING)
%				BB = -MRING'
%				CC = -inv(MRING)*BCUM
% -----------------------------------------------------------------------
AA =  inv(MRING);
BB = -MRING';
CC = -inv(MRING)*BCUM;
 
R = lyap(AA,BB,CC);     % Envelope matrix at the rinng entrance

RMSDP = sqrt(R(5,5));   % R.M.S. energy spread
RMSBL = sqrt(R(6,6));   % R.M.S. bunch lenght

if nargin == 2 % no REFPTS
    ENVELOPE.R = R;
elseif nargin == 3
    REFPTS = varargin{1};
    
    REFPTSX = REFPTS;
    % complete REFPTS with 1 and NumElements+1 if necessary
    if REFPTS(1)~=1
        REFPTSX = [1 REFPTS];
    end
    if REFPTS(end)~= NumElements+1
        REFPTSX = [REFPTSX NumElements+1];
    end
    % Now REFPTS has at least 2 ponts and the first one is the ring entrance
    
    NRX = length(REFPTSX);
    ENVELOPE = struct('Sigma',num2cell(zeros(2,NRX),1),...
        'Tilt',0,'R',zeros(6)); 
    
    ENVELOPE(1).R = R;

    for i=2:NRX
        ELEM = REFPTSX(i);
        ENVELOPE(i).R = MS(:,:,ELEM)*R*MS(:,:,ELEM)'+BATEXIT{ELEM-1};
    end
    
   
    if REFPTS(1)~=1
        ENVELOPE = ENVELOPE(2:end);
    end
    if REFPTS(end)~= NumElements+1
        ENVELOPE = ENVELOPE(1:end-1);
    end

else
    error('Too many input arguments');
end

for i=1:length(ENVELOPE)
    [U,DR] = eig(ENVELOPE(i).R([1 3],[1 3]));
    ENVELOPE(i).Tilt = asin((U(2,1)-U(1,2))/2);
    ENVELOPE(i).Sigma(1) = sqrt(DR(1,1));
    ENVELOPE(i).Sigma(2) = sqrt(DR(2,2));
    
    [U,DR] = eig(ENVELOPE(i).R([2 4],[2 4]));
    ENVELOPE(i).TiltL = asin((U(2,1)-U(1,2))/2);
    ENVELOPE(i).SigmaL(1) = sqrt(DR(1,1));
    ENVELOPE(i).SigmaL(2) = sqrt(DR(2,2));
end

function [f1, p1, f2, p2] = update_sim_annel_plots(coupling, indices, nominal_sigmas, f1o, p1o, f2o, p2o)

maxsigmay = max(nominal_sigmas(2,:));
if ~exist('f1o','var')
    f1 = figure; hold all;
    p1{1} = plot(indices.pos, 1e6*coupling.sigmas(2,:), 'Color', [0.8, 0.8, 1]);
    p1{2} = scatter(indices.pos(indices.b2), 1e6*nominal_sigmas(2,indices.b2), 52, [0,0,1], 'filled');
    p1{3} = scatter(indices.pos(indices.b2), 1e6*nominal_sigmas(2,indices.b2), 50, [0.5,0.5,1], 'filled');
    figure(f1); ylim([0,1e6*1.2*maxsigmay]); ylabel('sigmay [um]'); 
    f2 = figure; hold all;
    p2{1} = plot(indices.pos, (180/pi)*coupling.tilt, 'Color', [1, 0.8, 0.8]);
    p2{2} = scatter(indices.pos(indices.all), (180/pi)*coupling.tilt(indices.all), 50, [1,0.5,0.5], 'filled');
    figure(f2); ylim([-45,45]); ylabel('tilt angle [degree]'); 
else
    f1 = f1o; p1 = p1o; f2 = f2o; p2 = p2o;
    set(p1{1}, 'YData', 1e6*coupling.sigmas(2,:)); 
    set(p1{2}, 'YData', 1e6*nominal_sigmas(2,indices.b2)); 
    set(p1{3}, 'YData', 1e6*nominal_sigmas(2,indices.b2));
    figure(f1); ylim([0,1e6*1.2*maxsigmay]);
    set(p2{1}, 'YData', (180/pi)*coupling.tilt); 
    set(p2{2}, 'YData', (180/pi)*coupling.tilt(indices.all)); 
    figure(f2); ylim([-45,45]);
end
drawnow;

function random_machines = load_random_machines(fname_random_machines)

fprintf(['-- loading random machines [', datestr(now), ']\n']);

% loads random machines
random_machines.fname = fname_random_machines;
data = load(fname_random_machines);
random_machines.lattices = data.machine;

% calcs coupling parameters
for i=1:length(random_machines.lattices)
    fprintf('   . loading machine %02i | ', i);
    [random_machines.lattices{i}, ~, ~, ~, ~, ~, ~] = setradiation('On', random_machines.lattices{i});
    random_machines.lattices{i} = setcavity('On', random_machines.lattices{i});
    [~, ~, ~, ~, random_machines.emittances_ratio(i), ~, ~, ~, ~] = calccoupling(random_machines.lattices{i});
    fprintf('ey/ex = %.2f %%\n', 100*random_machines.emittances_ratio(i));
end

fprintf('\n\n');

function random_machines_opt = optimize_lifetime_random_machines(random_machines, the_ring_coup)

fprintf(['-- optimizing lifetime in random machines [', datestr(now), ']\n']);
random_machines_opt.the_ring_coup = the_ring_coup;
random_machines_opt.random_machines = random_machines;
nominal_qs = getcellstruct(the_ring_coup.lattice_coup, 'PolynomA', the_ring_coup.the_ring.indices.qs, 1, 2);
for i=1:length(random_machines.lattices)
    fprintf('   . applying dQS to machine %02i | ', i);
    original_qs = getcellstruct(random_machines.lattices{i}, 'PolynomA', the_ring_coup.the_ring.indices.qs, 1, 2);
    new_qs = original_qs + nominal_qs;
    random_machines_opt.lattices{i} = setcellstruct(random_machines.lattices{i}, 'PolynomA', the_ring_coup.the_ring.indices.qs, new_qs, 1, 2);
    random_machines_opt.coupling{i} = calc_coupling(random_machines_opt.lattices{i}, the_ring_coup.the_ring.indices);
    fprintf('max_qs %.3f -> %.3f [1/m^2] | ', max(abs(original_qs)), max(abs(new_qs)));
    [~, ~, ~, ~, random_machines_opt.emittances_ratio(i), ~, ~, ~, ~] = calccoupling(random_machines_opt.lattices{i});
    fprintf('ey/ex = %.2f %%\n', 100*random_machines_opt.emittances_ratio(i));

end

fprintf('\n\n');

function show_summary_machines(random_machines, plot_label)

% tilt angle
fprintf(['-- plotting coupling info of optimizing random machines [', datestr(now), ']\n']);
f1 = figure; hold all;
if isfield('random_machines','the_ring_coup')
    indices = random_machines.the_ring_coup.the_ring.indices;
    ref_coupling = random_machines.the_ring_coup.coupling;
else
    indices = random_machines.random_machines_opt.the_ring_coup.the_ring.indices;
    ref_coupling = random_machines.random_machines_opt.the_ring_coup.coupling;
end

for i=1:length(random_machines.lattices)
    figure(f1);
    plot(indices.pos, (180/pi)*random_machines.coupling{i}.tilt, 'Color', [1.0,0.6,0.6]); drawnow
end
for i=1:length(random_machines.lattices)
    figure(f1);
    scatter(indices.pos(indices.all), (180/pi)*random_machines.coupling{i}.tilt(indices.all), 50, [1.0,0.4,0.4], 'filled'); drawnow;
end
figure(f1);
scatter(indices.pos(indices.all), (180/pi)*ref_coupling.tilt(indices.all), 50, [1.0,0.0,0.0], 'filled'); drawnow;
xlabel('pos [m]'); ylabel('angle [deg.]');
title(plot_label);

% sigmay
f1 = figure; hold all;
for i=1:length(random_machines.lattices)
    figure(f1);
    plot(indices.pos, 1e6*random_machines.coupling{i}.sigmas(2,:), 'Color', [0.6,0.6,1.0]); drawnow
end
for i=1:length(random_machines.lattices)
    figure(f1);
    scatter(indices.pos(indices.all), 1e6*random_machines.coupling{i}.sigmas(2,indices.all), 50, [0.4,0.4,1], 'filled'); drawnow;
end
figure(f1);
scatter(indices.pos(indices.all), 1e6*ref_coupling.sigmas(2,indices.all), 50, [0.0,0.0,1], 'filled'); drawnow;
xlabel('pos [m]'); ylabel('sigmay [um]');
title(plot_label);

fprintf('\n\n');

function ids_config = get_coupling_polynom_a_scale(config_label)

ids_config.config_label = config_label;

% straights:
% =========
% 'mia'(INJ), 'mib', 'mip'(CAV), 'mib'
% 'mia',      'mib', 'mip',      'mib'
% 'mia',      'mib', 'mip',      'mib'
% 'mia',      'mib', 'mip',      'mib'
% 'mia',      'mib', 'mip',      'mib' 

% if strcmp(config_label, 'SI.V18.01, 1% coupling IDs')
%     ids_config.polynom_a_scale = [...
%         0.03238,0.03238,...
%         0.00563,0.03238,0.03238,0.03238,...
%         0.00563,0.03238,0.03238,0.03238,...
%         0.00563,0.03238,0.03238,0.03238,...
%         0.00563,0.03238,0.03238,0.03238];
% elseif strcmp(config_label, 'SI.V18.01, 0.55% coupling IDs')
%     ids_config.coupling_polynom_a_scale = [...
%         0.024,0.024,...
%         0.004,0.024,0.024,0.024,...
%         0.004,0.024,0.024,0.024,...
%         0.004,0.024,0.024,0.024,...
%         0.004,0.024,0.024,0.024];
% elseif strcmp(config_label, 'SI.V18.01, 0.15% coupling IDs')
%     ids_config.coupling_polynom_a_scale = [...
%         0.024,0.024,...
%         0.004,0.024,0.024,0.024,...
%         0.004,0.024,0.024,0.024,...
%         0.004,0.024,0.024,0.024,...
%         0.004,0.024,0.024,0.024]/2;
% elseif strcmp(config_label, 'SI.V18.01, 0.08% coupling IDs')
%     ids_config.coupling_polynom_a_scale = [...
%         0.03238,0.03238,...
%         0.00563,0.03238,0.03238,0.03238,...
%         0.00563,0.03238,0.03238,0.03238,...
%         0.00563,0.03238,0.03238,0.03238,...
%         0.00563,0.03238,0.03238,0.03238]/5;
% elseif strcmp(config_label, 'SI.V18.01, 0.01% coupling IDs')
%     ids_config.coupling_polynom_a_scale = [...
%         0.03238,0.03238,...
%         0.00563,0.03238,0.03238,0.03238,...
%         0.00563,0.03238,0.03238,0.03238,...
%         0.00563,0.03238,0.03238,0.03238,...
%         0.00563,0.03238,0.03238,0.03238]/10;

if strcmp(config_label, 'SI.V18.01, 1% coupling IDs')
    ids_config.polynom_a_scale = [...
        0.0021694000, 0.0021694000, ...
        0.0021689575, 0.0021694000, 0.0021694000, 0.0021694000, ...
        0.0021689575, 0.0021694000, 0.0021694000, 0.0021694000, ...
        0.0021689575, 0.0021694000, 0.0021694000, 0.0021694000, ...
        0.0021689575, 0.0021694000, 0.0021694000, 0.0021694000, ...
        ];
else
    error('undefined ID coupling strength or lattice_version');
end

function random_machines_opt_ids = insert_ids(random_machines_opt, ids_config)

fprintf(['-- inserting IDs into random machines [', datestr(now), ']\n']);


random_machines_opt_ids.random_machines_opt = random_machines_opt;
random_machines_opt_ids.ids_config = ids_config;
indices = random_machines_opt.the_ring_coup.the_ring.indices;
idx = indices.ids;
idx([1 3]) = []; % section 01A and 03P have no IDs
random_machines_opt_ids.ids_config.indices = reshape(sort([idx-2, idx-1, idx+1, idx+2]), 4, [])';
pol = random_machines_opt_ids.ids_config.polynom_a_scale;
fprintf('   . polynom_a values [1/m^2]: '); fprintf('%f ', unique(pol)); fprintf('\n');
fprintf('   . listing id configurations\n');
for i=1:size(random_machines_opt_ids.ids_config.indices,1);
    la0 = random_machines_opt.the_ring_coup.the_ring.lattice;
    fam = unique(getcellstruct(la0, 'FamName', random_machines_opt_ids.ids_config.indices(i,:)));
    len = getcellstruct(la0, 'Length', random_machines_opt_ids.ids_config.indices(i,:));
    pas = unique(getcellstruct(la0, 'PassMethod', random_machines_opt_ids.ids_config.indices(i,:)));
    la1 = insert_one_id(la0, random_machines_opt_ids.ids_config.indices(i,:), pol(i));
    [~,~,~,~,random_machines_opt_ids.eyex_ratio(i),~,~,~,~] = calccoupling(la1); 
    fprintf('   id %02i @ %5s | ', i, random_machines_opt.the_ring_coup.the_ring.lattice{random_machines_opt_ids.ids_config.indices(i,2)+1}.FamName);
    fprintf('%6s | ', fam{1});
    fprintf('%.3f [m] | ', sum(len));
    fprintf('%10s | ', pas{1});
    fprintf('%6.2f\n', 100*random_machines_opt_ids.eyex_ratio(i));
end
   
fprintf('   . inserting IDs in random machines\n');
for i=1:length(random_machines_opt.lattices)
    fprintf('   processing machine %02i\n', i);
    random_machines_opt_ids.lattices{i} = random_machines_opt.lattices{i};
    for j=1:length(random_machines_opt_ids.ids_config.indices)
       polynom_a = 2*(rand()-0.5) * pol(j);
       random_machines_opt_ids.lattices{i} = insert_one_id(random_machines_opt_ids.lattices{i}, random_machines_opt_ids.ids_config.indices(j,:), polynom_a);
    end
    random_machines_opt_ids.coupling{i} = calc_coupling(random_machines_opt_ids.lattices{i}, indices);
end

function the_ring = insert_one_id(the_ring0, idx, polynom_a_str)

the_ring = the_ring0;
nlk = [findcells(the_ring, 'FamName', 'nlk'); findcells(the_ring, 'FamName', 'pmm');];

for i=1:length(idx)
    len = the_ring{i}.Length;
    fam = the_ring{i}.FamName;
    the_ring{i} = the_ring{nlk};
    the_ring{i}.Length = len;
    the_ring{i}.FamName = fam;
    the_ring{i}.PolynomA = 0 * the_ring{i}.PolynomA;
    the_ring{i}.PolynomB = 0 * the_ring{i}.PolynomB;
    the_ring{i}.PolynomA(2) = polynom_a_str;
end


function respm = calc_feedback_respm(random_machines_opt_ids, b2_selection)

fprintf(['-- running couling feedback [', datestr(now), ']\n']);
respm.b2_selection = b2_selection;
respm.random_machines_opt_ids = random_machines_opt_ids;
lat0 = random_machines_opt_ids.random_machines_opt.the_ring_coup.lattice_coup;
indices = random_machines_opt_ids.random_machines_opt.the_ring_coup.the_ring.indices;
%feedback.responses = calc_feedback_responses(random_machines_opt_ids.lattices, indices, b2_selection);
response = calc_respm_tilt(lat0, indices, b2_selection, true);
for i=1:length(random_machines_opt_ids.lattices)
    respm.response{i} = response;
end

for i=1:length(random_machines_opt_ids.lattices)
    
end

function response = calc_feedback_responses(lattices, indices, b2_selection)

for i=1:length(machines.machine)
    fprintf('   . feedback matrix for machine #%02i\n', i);
    response{i} = calc_respm_tilt(lattices{i}, indices, true);
end

function response = calc_respm_tilt(the_ring, indices, b2_selection, print_results)

response.delta_qs = 0.001;
b2_idx = indices.b2(b2_selection);
response.matrix = zeros(size(b2_idx,1), size(indices.qs,1));


if ~exist('print_results','var')
    print_results = false;
end

if print_results
    fprintf('angle monitors at: ');
    names = unique(getcellstruct(the_ring, 'FamName', b2_idx));
    for i=1:length(names)
        fprintf('%s ', names{i});
    end; fprintf(' (%03i)\n', size(b2_idx,1));

    fprintf('skew correctors at: ');
    names = unique(getcellstruct(the_ring, 'FamName', indices.qs));
    for i=1:length(names)
        fprintf('%s ', names{i});
    end; fprintf(' (%03i)\n', size(indices.qs,1));
end

fprintf('   ');
for i=1:size(response.matrix,2)
    if print_results
        fprintf('%03i ',i);
        if (rem(i,10) == 0)
            fprintf('\n   ');
        end
    end
    qs0 = getcellstruct(the_ring, 'PolynomA', indices.qs(i,:), 1, 2);
    the_ring = setcellstruct(the_ring, 'PolynomA', indices.qs(i,:), qs0 + response.delta_qs/2, 1, 2);
    coupling_p = calc_coupling(the_ring, indices);
    the_ring = setcellstruct(the_ring, 'PolynomA', indices.qs(i,:), qs0 - response.delta_qs/2, 1, 2);
    coupling_n = calc_coupling(the_ring, indices);
    the_ring = setcellstruct(the_ring, 'PolynomA', indices.qs(i,:), qs0, 1, 2);
    tilt = coupling_p.tilt(b2_idx) - coupling_n.tilt(b2_idx);
    response.matrix(:,i) = tilt / response.delta_qs;
end
fprintf('\n');
[response.U, response.S, response.V] = svd(response.matrix, 'econ');
response.S = diag(response.S);













function b2_selection = get_b2_selection(config)

if (config.feedback.nr_b2 == 20)
    config.b2_selection = logical(repmat([1,0,1,0, 1,0,1,0],1,5)); % 20 B2
elseif (config.feedback.nr_b2 == 10)
    b2_selection = logical(repmat([1,0,0,0, 1,0,0,0],1,5)); % 10 B2
elseif (config.feedback.nr_b2 == 5)
    b2_selection = logical(repmat([1,0,0,0, 0,0,0,0],1,5)); % 05 B2
elseif (config.feedback.nr_b2 == 1)    
    b2_selection = logical([[1,0,0,0, 0,0,0,0], repmat([0,0,0,0, 0,0,0,0],1,4)]); % 01 B2
else
    error('invalid number of b2 in feedbac system');
end

function ids = find_coupling_polynom_a_strength(r, target_id_coupling)

[the_ring0, ids] = insert_ids(r.the_ring0, r.indices);

ids.coupling_polynom_a_scale = zeros(1,size(ids.indices_ids_coup,1));

for i=1:size(ids.indices_ids_coup,1) 
    
    % initial points
    x = [0, 0.03236,  0.005629, linspace(0.06/9,0.06,9)]; 
    y = [0];
    for j=2:length(x)
        the_ring = setcellstruct(the_ring0, 'PolynomA', ids.indices_ids_coup(i,:), x(j), 1, 2);
        [Tilt, Eta, EpsX, EpsY, Ratio, ENV, DP, DL, sigmas] = calccoupling(the_ring); y(j) = Ratio;
        if any(abs(y - target_id_coupling)/abs(target_id_coupling) < 0.01) 
            break;
        end
    end
       
    while all(abs(y - target_id_coupling)/abs(target_id_coupling) > 0.01)
        %figure; scatter(x,y);
        nx = interp1(y, x, target_id_coupling, 'linear','extrap');
        the_ring = setcellstruct(the_ring0, 'PolynomA', ids.indices_ids_coup(i,:), nx, 1, 2);
        [Tilt, Eta, EpsX, EpsY, Ratio, ENV, DP, DL, sigmas] = calccoupling(the_ring);
        if (Ratio > 0) && (Ratio < 1)
            x(end+1) = nx;
            y(end+1) = Ratio;
        end
    end
    
    ids.coupling_polynom_a_scale(i) = interp1(y, x(1:length(y)), target_id_coupling, 'spline','extrap');
    fprintf('id %02i : strength %f 1/m^2\n', i, ids.coupling_polynom_a_scale(i));
    
end
    
function the_ring = vary_qs_in_families(the_ring0, indices, sim_anneal)

sel_fam_idx = randi(length(indices.qs_fams),1,1);
delta_q = 2*(rand()-0.5)*sim_anneal.qs_delta;
q0 = getcellstruct(the_ring0, 'PolynomA', indices.qs_fams{sel_fam_idx}, 1, 2);
q1 = q0 + delta_q;
the_ring = setcellstruct(the_ring0, 'PolynomA', indices.qs_fams{sel_fam_idx}, q1, 1, 2);

function machines = calc_respm_machines(machines0, indices)

machines = machines0;
for i=1:length(machines.machine)
    fprintf('response matrix for machine #%02i\n', i);
    machines.feedback{i} = calc_respm_tilt(machines.machine{i}, indices, true);
end

function feedback = calc_respm_tilt(the_ring, indices, b2_selection, print_results)

feedback.delta_qs = 0.001;
feedback.matrix = zeros(size(indices.b2,1), size(indices.qs,1));
b2_idx = indices.b2(b2_selection);

if ~exist('print_results','var')
    print_results = false;
end

if print_results
    fprintf('angle monitors at: ');
    names = unique(getcellstruct(the_ring, 'FamName', b2_idx));
    for i=1:length(names)
        fprintf('%s ', names{i});
    end; fprintf(' (%03i)\n', size(b2_idx,1));

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
    tilt = coupling_p.tilt(b2_idx) - coupling_n.tilt(b2_idx);
    feedback.matrix(:,i) = tilt / feedback.delta_qs;
end

[feedback.U, feedback.S, feedback.V] = svd(feedback.matrix, 'econ');
feedback.S = diag(feedback.S);

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
    
fprintf('%f\n ', 0, (180/pi)*std(residue));
for j=1:feedback.svd_nr_iterations
    qs      = -0.5 * (feedback.V*iS*feedback.U') * residue;
    for i=1:size(feedback.matrix,2)
        qs0 = getcellstruct(the_ring, 'PolynomA', indices.qs(i,:), 1, 2);
        the_ring = setcellstruct(the_ring, 'PolynomA', indices.qs(i,:), qs0 + qs(i), 1, 2);
    end
    coupling = calc_coupling(the_ring, indices);
    actual = coupling.tilt(indices.b2)';
    residue = actual - target;
    fprintf('%f ', (180/pi)*std(residue));
    if (mod(j,5)==0) 
        fprintf('\n');
    end
end

function the_ring = set_ids_configs(the_ring0, ids)

the_ring = the_ring0;
polya = 2*(rand(1,length(ids.coupling_polynom_a_scale))-0.5) .* ids.coupling_polynom_a_scale;
for i=1:size(ids.indices_ids_coup,1)
    the_ring = setcellstruct(the_ring, 'PolynomA', ids.indices_ids_coup(i,:), polya(i), 1, 2);
end