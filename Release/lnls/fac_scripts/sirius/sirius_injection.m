function sirius_injection()

%% PARAMETERS

p.bo_version      = 'BO.V03.02';
p.ts_version      = 'TS.V02';
p.si_version      = 'SI.V16.01';
p.ts_mode         = 'M2';
p.nr_particles    = 1000;      % nr_particles in simulation
p.bo_coupling     = 0.10;     % booster transverse coupling (<1.0)
p.bo_kickex_kick  = 2.461e-3; % booster extraction kick [rad]
p.nr_turns        = 213;      % number of turns to track
p.plot_flag       = true;
p.print_flag      = true;
p.si_nlk_strength = 0.727;      % storage ring nlk strength [no unit] M2
p.si_nlk_pulse    = [1.0, 0.00, 0.00]; % temporal profile of nlk pulse
p.si_nlk_physaccp = [0.0095, Inf];
p.ts_chamber_rx_at_bo =  22e-3;   % [m]   (rx of center of TS vacuum chamber w.r.t. TS coord. system)
p.ts_chamber_px_at_bo =  5.0e-3;  % [rad] (px of center of TS vacuum chamber w.r.t. TS coord. system)
p.si_chamber_rx_at_ts =  0.01935; % [m]   (as measured at TS coordinates)
p.si_chamber_px_at_ts = -2.84e-3; % [rad] (as measured at SI coordinates)

% generates plots of NLK injection
p = generate_injection_plots(p);

% varies strength of NLK
%p = vary_nlk_strength(p);


% 
% % varies and plots injection efficiency vs si nlk strength
% % si_nlk_strength = p.si_nlk_strength * linspace(0.8,1.2,55);
% % p = vary_si_nlk_strength(p, si_nlk_strength);


function p = generate_injection_plots(p0)

p = p0;

p.plot_flag = false;
p.print_flag = false;

% creates lattice models
p = create_lattice_models(p);

% init random numbers
init_random_numbers();

% creates bunch at entrance of BO extraction kicker
p = create_initial_bunch(p);

% ejects bunch from booster
p = eject_from_booster(p);

% transports along ts
p = transport_along_ts(p);

% injection into si
p = inject_into_si_and_transports_to_nlk(p);

p.plot_flag = true;
p.print_flag = true;

% sets nlk and kicks beam first time
p = sets_nlk_and_kicks_beam(p);
axis([-12,1,-1,4]);
xlabel('X [mm]'); ylabel('PX [mrad]');

% tracks many turns in si
p = track_many_turns_in_si(p);
axis([-12,10,-0.8,0.8]);
grid('off');
xlabel('X [mm]');
title('Stored Beam and First 213 Turns of Injected Beam');



function p = vary_nlk_strength(p0)

p = p0;

p.plot_flag = false;
p.print_flag = false;

p = create_lattice_models(p);
init_random_numbers();
p = create_initial_bunch(p);
p = eject_from_booster(p);
p = transport_along_ts(p);
p = inject_into_si_and_transports_to_nlk(p);

si = p.si; bunch = p.bunch;

nlk_strengths = (1+linspace(-0.15,0.15,51)) * p.si_nlk_strength;
efficiency = zeros(size(nlk_strengths));
for i=1:length(nlk_strengths)
    fprintf('%03i/%02i: %f ', i, length(nlk_strengths), 100*nlk_strengths(i));
    p.si = si; p.bunch = bunch;
    p.si_nlk_strength = nlk_strengths(i);
    p.print_flag = false; 
    p.plot_flag = false; p = sets_nlk_and_kicks_beam(p); p.plot_flag = false;
    p = track_many_turns_in_si(p);
    p.print_flag = false;
    efficiency(i) = 100*(p.nr_particles - p.particle_loss)/p.nr_particles;
    fprintf('%f\n', efficiency(i));
end

figure; plot(100*nlk_strengths, efficiency);


function p = create_lattice_models(p0)

p = p0;

lnls_setpath_mml_at;
sirius_path = fullfile(lnls_get_root_folder(), 'code', 'MatlabMiddleLayer', 'Release', 'machine', 'SIRIUS');
close all; drawnow;

% loads BO model
addpath(fullfile(sirius_path, p.bo_version));
p.bo = sirius_bo_lattice(3.0);
[p.bo, ~] = setcavity('on', p.bo);
[p.bo, ~, ~, ~, ~, ~, ~] = setradiation('on', p.bo);

% loads TS model
addpath(fullfile(sirius_path, p.ts_version));
p.ts = sirius_ts_lattice(p.ts_mode);
[p.ts, ~] = setcavity('on', p.ts);
[p.ts,~,~,~,~,~,~] = setradiation('on', p.ts);

% loads SI model
addpath(fullfile(sirius_path, p.si_version));
p.si = sirius_si_lattice();
[p.si, ~] = setcavity('on', p.si);
[p.si,~,~,~,~,~,~] = setradiation('on', p.si);
% adds defined acceptance as VChamber at entrance of nlk
p.si_nlk_idx = findcells(p.si, 'FamName', 'nlk');
p.si{p.si_nlk_idx}.VChamber(1) = p.si_nlk_physaccp(1);

% shifts it so that it starts at begining of extraction kicker
bo_kickex_idx = findcells(p.bo, 'FamName', 'kick_ex');
p.bo = [p.bo(bo_kickex_idx(1):end) p.bo(1:bo_kickex_idx(1)-1)];
p.bo_kickex_idx = findcells(p.bo, 'FamName', 'kick_ex');

% shifts si so that it starts at injection point
injection_point = findcells(p.si, 'FamName', 'eseptinj');
p.si = [p.si(injection_point:end) p.si(1:injection_point-1)];

fprintf('\n');

function init_random_numbers

% seed for random number generator
seed = 131071;
fprintf('- initializing random number generator with seed = %i ...\n', seed);
RandStream.setGlobalStream(RandStream('mt19937ar','seed', seed));

function p = create_initial_bunch(p0)

p = p0;

%% INITIAL BUNCH

% generates bunch at entrance of BO extraction kicker
bo_twiss = calctwiss(p.bo);
bo_eqparms = atsummary(p.bo);
e0 = bo_eqparms.naturalEmittance; k = p.bo_coupling;
emitx =  1 * e0 / (1.0 + k); emity =  k * e0 / (1.0 + k);
bo_twiss0 = create_twiss(bo_twiss,1);
co = findorbit6(p.bo);
p.bunch = lnls_generate_bunch(emitx, emity, bo_eqparms.naturalEnergySpread, bo_eqparms.bunchlength, bo_twiss0, p.nr_particles-1, 30);
p.bunch = [co, p.bunch + repmat(co, 1, size(p.bunch,2))];
if p.plot_flag, create_new_x_phase_space_plot(p.bunch, [], [], 'bunch at entrance of BO extraction kicker'); end
if p.print_flag, fprintf('- initial beam with %i particles\n', p.nr_particles); end;
p.loss_bo_ejekicker = 0;

function p = eject_from_booster(p0)

p = p0;

% sets extraction kicker and kicks beam
p.bo = lnls_set_kickangle(p.bo, p.bo_kickex_kick, p.bo_kickex_idx, 'x');

% transport bunch from entrance of extraction kicker to entrance of extraction thin septum
p.bo_ejesepta_idx = findcells(p.bo, 'FamName', 'sept_ex');
trajectories = linepass(p.bo, p.bunch, 1:p.bo_ejesepta_idx(1));
if p.print_flag, fprintf('- setting bo extraction kick to %+.3f mrad\n', p.bo_kickex_kick*1000); end
bunch = trajectories(:,get_bunch(p.bo_kickex_idx(end)+1, p.nr_particles)); % bunch after kicker

% plots bunch after extraction kicker
if p.plot_flag, create_new_x_phase_space_plot(bunch, [], [], 'bunch after extraction kicker'); end

% calcs particle loss and plots trajectories
[tbunch, p.loss_ts_ejesepta] = calc_particle_loss(trajectories, p.bo(1:p.bo_ejesepta_idx(1)), p.nr_particles, 'from BO extraction kicker to extraction septum', p.plot_flag);
if p.print_flag, fprintf('- number of electrons lost from entrance of bo extkicker to entrance of bo extsepta: %i\n', p.loss_ts_ejesepta - p.loss_bo_ejekicker); end

% gets bunch at entrance of thin extraction septum
p.bunch = tbunch(:,get_bunch(p.bo_ejesepta_idx(1), p.nr_particles));
if p.plot_flag, create_new_x_phase_space_plot(p.bunch, [], [], 'bunch at entrance of extraction septa (BO coordinates)'); end

function p = transport_along_ts(p0)

p = p0;

% translation of bunch coordinates from BO to TS
ts_chamber_at_bo = [p.ts_chamber_rx_at_bo;p.ts_chamber_px_at_bo;0;0;0;0];
p.bunch = p.bunch - repmat(ts_chamber_at_bo, 1, size(p.bunch,2));
if p.plot_flag, create_new_x_phase_space_plot(p.bunch, [], [], 'bunch at beginning of TS'); end

% adds error in thin and thick BO extraction septa
% (INCOMPLETE!!! right now they have ideal pulses)

% transports bunch through TS
trajectories = linepass(p.ts, p.bunch, 1:length(p.ts)+1);

% calcs particle loss and plots trajectories
[trajectories, p.loss_si_injpoint] = calc_particle_loss(trajectories, [p.ts p.ts(1)], p.nr_particles, 'bunch transported along TS', p.plot_flag);
if p.print_flag, fprintf('- number of electrons lost from entrance of bo extsepta to exit of ts line: %i\n', p.loss_si_injpoint - p.loss_ts_ejesepta); end

% plots bunch at end of TS
p.bunch = trajectories(:,get_bunch(length(p.ts)+1, p.nr_particles));
if p.plot_flag, create_new_x_phase_space_plot(p.bunch, [], [], 'bunch at end of TS'); end

function p = inject_into_si_and_transports_to_nlk(p0)

p = p0;

%% INJECTION IN SI
% translation of bunch coordinates from TS to SI
co = findorbit6(p.si);
p.beam_long_center_at_si_injection = mean(p.bunch(6,:));
si_chamber_at_ts = [p.si_chamber_rx_at_ts;p.si_chamber_px_at_ts;0;0;0;p.beam_long_center_at_si_injection-co(6)];
p.bunch = p.bunch - repmat(si_chamber_at_ts, 1, size(p.bunch,2)); % bunch at injection point
if p.print_flag, fprintf('- beam centroid at si injpoint (rx,px)(ry,py): (%+.3f mm, %+.3f mrad) (%+.3f mm, %+.3f mrad)\n', 1000*p.bunch([1,2,3,4],1)); end

% plots bunch at SI injection point
if p.plot_flag, create_new_x_phase_space_plot(p.bunch,[], [], 'bunch at injection point of SI'); end

% transports bunch from injection point to nlk
p.si_nlk_idx = findcells(p.si, 'FamName', 'nlk');
inj_2_nlk  = p.si(1:p.si_nlk_idx(1));
trajectories = linepass(inj_2_nlk, p.bunch, 1:length(inj_2_nlk));
[trajectories, p.loss_si_nlk] = calc_particle_loss(trajectories, inj_2_nlk, p.nr_particles, 'from SI injection point to entrance of nlk', p.plot_flag);
if p.print_flag, fprintf('- number of electrons lost from si injpoint to entrance of si nlk: %i\n', p.loss_si_nlk - p.loss_si_injpoint); end
p.bunch = trajectories(:,get_bunch(length(inj_2_nlk),p.nr_particles)); % bunch at entrance of si nlk
if p.print_flag, fprintf('- beam centroid at entrance of si nlk (rx,px): (%+.3f mm, %+.3f mrad)\n', 1000*p.bunch([1,2],1)); end

% shifts si so that it starts at nlk
p.si = [p.si(p.si_nlk_idx:end) p.si(1:p.si_nlk_idx-1)];
p.si_nlk_idx = findcells(p.si, 'FamName', 'nlk');
p.si{p.si_nlk_idx}.VChamber(1) = p.si_nlk_physaccp(1);

function p = sets_nlk_and_kicks_beam(p0)

p = p0;

% calcs stored beam and acceptance
if ~isfield(p,'si_stored_bunch')
    % does tracking 
    co = findorbit6(p.si); 
    si = p.si; [si,~] = setcavity('off',si); [si, ~,~,~,~,~,~] = setradiation('off',si);
    fp = [co(1:4);0;0]+[-p.si_nlk_physaccp(1);0;0;0;0;0];
    p.si_acceptance_nlk = ringpass(si,fp,1000);
    %p.si_acceptance_nlk = ringpass(p.si, co+[-p.si_nlk_physaccp(1);0;0;0;0;0], 1000);
    si_twiss = calctwiss(p.si); p.si_twiss_nlk = create_twiss(si_twiss, 1);
    si_eqparms = atsummary(p.si);
    e0 = si_eqparms.naturalEmittance; k = 0.01;
    emitx =  1 * e0 / (1.0 + k); emity =  k * e0 / (1.0 + k);
    bunch = lnls_generate_bunch(emitx, emity, si_eqparms.naturalEnergySpread, si_eqparms.bunchlength, p.si_twiss_nlk, p.nr_particles-1, 30);
    p.si_stored_bunch = [co, bunch + repmat(co, 1, size(bunch,2))];
    %s = findspos(p.si,1:length(p.si));
    %[p.si_xaccept_nlk,yaccept,~,err] = lnls_calcula_aceitancias(p.si, s, si_twiss.betax, si_twiss.betay, -1);
end
        
% gets nlk pulse parameters
p.si_nlk_pulse = [p.si_nlk_pulse, zeros(1,p.nr_turns-length(p.si_nlk_pulse))];
[x, integ_field, kickx, p.LPolyB] = sirius_si_nlk_kick(p.si_nlk_strength, [2,3,4,5,6,7,8,9,10], p.plot_flag);

% sets nlk
p.si_nlk_idx = findcells(p.si, 'FamName', 'nlk');
p.si = sets_nlk(p.si, p.si_nlk_idx, p.si_nlk_pulse(1), p.LPolyB);
    
% plots bunch at SI NLK entrance
if p.plot_flag
    %si_twiss = calctwiss(p.si); twiss0 = create_twiss(si_twiss, 1);
    %s = findspos(p.si,1:length(p.si));
    %[xaccept,yaccept,~,err] = lnls_calcula_aceitancias(p.si, s, si_twiss.betax, si_twiss.betay, -1);
    %p.fig = create_new_x_phase_space_plot(p.bunch, xaccept, twiss0, 'bunch before NLK');
    p.fig = create_new_x_phase_space_plot(p.bunch, [], [], 'bunch before NLK');
    figure(p.fig); plot(1000*x,-1000*kickx, 'Color', [0,0.6,0]);
end

% kicks beam
p.bunch = linepass(p.si(p.si_nlk_idx(1):p.si_nlk_idx(end)), p.bunch); 

% shifts si lattice to the end of NLK
p.si = [p.si(p.si_nlk_idx(end)+1:end) p.si(1:p.si_nlk_idx(end))];
p.si_nlk_idx = findcells(p.si, 'FamName', 'nlk');

% plots bunch after nlk kick
if p.plot_flag
    %si_twiss = calctwiss(p.si); twiss0 = create_twiss(si_twiss, 1);
    %s = findspos(p.si,1:length(p.si));
    %[xaccept,yaccept,~,err] = lnls_calcula_aceitancias(p.si, s, si_twiss.betax, si_twiss.betay, -1);
    %create_new_x_phase_space_plot(p.bunch, xaccept, twiss0, 'Bunch before and after NLK', p.fig);
    create_new_x_phase_space_plot(p.bunch, [], [], 'Bunch before and after NLK', p.fig);
end

% plots stored beam and acceptance
if p.plot_flag
    create_new_x_phase_space_plot(p.si_stored_bunch, [], [], 'Bunch before and after NLK', p.fig, 'k.'); 
    plot(1000*p.si_acceptance_nlk(1,:), 1000*p.si_acceptance_nlk(2,:), 'k.');
end

function p = track_many_turns_in_si(p0)

p = p0;


p.fig = [];
if p.plot_flag
    p.fig = figure; hold all;
    plot(1000*p.si_acceptance_nlk(1,:), 1000*p.si_acceptance_nlk(2,:), 'k.');
end
    
    
bunch0 = p.bunch;
% tracks turn 1
p.si = sets_nlk(p.si, p.si_nlk_idx, p.si_nlk_pulse(2), p.LPolyB); % sets nlk to 2nd kick
trajectories = linepass(p.si, bunch0, 1:length(p.si)+1);
[trajectories, loss_turn] = calc_particle_loss(trajectories, [p.si p.si(1)], p.nr_particles, 'first turn in SI', p.plot_flag);
if p.print_flag, fprintf('- number of electrons lost after turn 001: %i\n', loss_turn); end
bunch1 = trajectories(:,get_bunch(length(p.si)+1,p.nr_particles));
% tracks turn 2
p.si = sets_nlk(p.si, p.si_nlk_idx, p.si_nlk_pulse(3), p.LPolyB); % sets nlk to 3rd kick
trajectories = linepass(p.si, bunch1, 1:length(p.si)+1);
[trajectories, loss_turn] = calc_particle_loss(trajectories, [p.si p.si(1)], p.nr_particles, 'second turn in SI', false);
if p.print_flag, fprintf('- number of electrons lost after turn 002: %i\n', loss_turn); end
bunch2 = trajectories(:,get_bunch(length(p.si)+1,p.nr_particles));
% tracks turn 3
p.si = sets_nlk(p.si, p.si_nlk_idx, p.si_nlk_pulse(4), p.LPolyB); % sets nlk to 4th kick
trajectories = linepass(p.si, bunch2, 1:length(p.si)+1);
[trajectories, loss_turn] = calc_particle_loss(trajectories, [p.si p.si(1)], p.nr_particles, 'third turn in SI', false);
if p.print_flag, fprintf('- number of electrons lost after turn 003: %i\n', loss_turn); end
bunch3 = trajectories(:,get_bunch(length(p.si)+1,p.nr_particles));


bunch = bunch3;
for i=5:p.nr_turns
    p.si = sets_nlk(p.si, p.si_nlk_idx, p.si_nlk_pulse(i), p.LPolyB); % sets nlk
    trajectories = linepass(p.si, bunch, 1:length(p.si)+1);
    [trajectories, loss_turn] = calc_particle_loss(trajectories, [p.si p.si(1)], p.nr_particles, '', false);
    if p.print_flag, fprintf('- number of electrons lost after turn %03i: %i\n', i-1, loss_turn); end
    bunch = trajectories(:,get_bunch(length(p.si)+1,p.nr_particles));
    if p.plot_flag, p.fig = create_new_x_phase_space_plot(bunch, [], [], 'Injected and Stored Beams', p.fig, 'c[0.7,0.7,0.7]'); end
    if (loss_turn == p.nr_particles ), break; end;
end
p.particle_loss = loss_turn;


if p.plot_flag
    p.fig = create_new_x_phase_space_plot(p.si_stored_bunch, [], [], 'Injected and Stored Beams', p.fig, 'c[0,0,0]');
    plot(1000*p.si_acceptance_nlk(1,:), 1000*p.si_acceptance_nlk(2,:), 'k.');
end

if p.plot_flag
    p.fig = create_new_x_phase_space_plot(bunch0, [], [], 'First turns in SI', p.fig, 'b.'); 
    p.fig = create_new_x_phase_space_plot(bunch1, [], [], 'First turns in SI', p.fig, 'r.'); 
    p.fig = create_new_x_phase_space_plot(bunch2, [], [], 'First turns in SI', p.fig, 'g.'); 
    p.fig = create_new_x_phase_space_plot(bunch3, [], [], 'First turns in SI', p.fig, 'y.'); 
end




function p = vary_si_nlk_strength(p0, si_nlk_strength)

p = p0;

efficiency = zeros(size(si_nlk_strength));
for i=1:length(si_nlk_strength)
    close all; drawnow;
    fprintf('%03i: nlk_strength = %.4f, ', i, si_nlk_strength(i));
    p.si_nlk_strength = si_nlk_strength(i);
    p = sirius_injection_local(p);
    efficiency(i) = (p.nr_particles - p.lost_particles)/p.nr_particles;
    fprintf('efficienty = %7.3f %%\n', 100*efficiency(i));
end
figure; plot(si_nlk_strength, efficiency);

function twiss = create_twiss(twissv, idx)
twiss.betax = twissv.betax(idx);
twiss.betay = twissv.betay(idx);
twiss.alphax = twissv.alphax(idx);
twiss.alphay = twissv.alphay(idx);
twiss.etax = twissv.etax(idx);
twiss.etay = twissv.etay(idx);
twiss.etaxl = twissv.etaxl(idx);
twiss.etayl = twissv.etayl(idx);

function [tbunch, lost_particles] = calc_particle_loss(original_tbunch, lattice, nr_particles, ptitle, plot_flag)

if ~exist('plot_flag','var')
    plot_flag = true;
end


tbunch = original_tbunch;
s = findspos(lattice, 1:length(lattice));

x = reshape(tbunch(1,:), nr_particles, []);
xapert0 = getcellstruct(lattice, 'VChamber', 1:length(lattice), 1, 1)';
y = reshape(tbunch(3,:), nr_particles, []);
yapert0 = getcellstruct(lattice, 'VChamber', 1:length(lattice), 1, 2)';

xapert = repmat(xapert0, nr_particles, 1);
yapert = repmat(yapert0, nr_particles, 1);
xlost = (x >= xapert) | (x <= -xapert) | isnan(x);
ylost = (y >= yapert) | (y <= -yapert) | isnan(y);

if plot_flag
    % plots horizontal trajectory
    xmin = min(-1000*xapert0); xmax = max(1000*xapert0);
    %figure;
    lnls_plot_horizontal_vchamber(lattice); hold all;
    plot(s, 1000*x');
    lnls_plot_lattice(lattice, 0, max(s), xmin - 0.5*(xmax-xmin), 0.5*(xmax-xmin));
    xlabel('s / m'); ylabel('rx / mm'); title(['Horizontal trajectories: ', ptitle]);
    yaxis([3*xmin,xmax]);
    %% plots vertical trajectory
    %ymin = min(-1000*yapert0); ymax = max(1000*yapert0);
    %lnls_plot_vertical_vchamber(lattice); hold all;
    %lnls_plot_lattice(lattice, 0, max(s), ymin - 0.5*(ymax-ymin), 0.5*(ymax-ymin));
    %yaxis([3*ymin,ymax]);
    %plot(s, 1000*y');
    %xlabel('s / m'); ylabel('ry / mm'); title(['Vertical trajectories: ', ptitle]);
    drawnow;
end

[xr,xc] = find(xlost);
[yr,yc] = find(ylost);
lost_particles = unique([xr; yr]);
%fprintf('nr particles lost: %i/%i\n', length(lost_particles), nr_particles);

for i=1:length(lost_particles)
    p = lost_particles(i);
    tbunch(:,p:nr_particles:end) = NaN;
end

lost_particles = length(lost_particles);

function si = sets_nlk(old_si, nlk_idx, strength, LPolyB)
si = old_si;
si_nlk_len = sum(getcellstruct(si, 'Length', nlk_idx));
PolynomB = LPolyB/si_nlk_len;
for i=nlk_idx
    si{i}.PolynomB = strength * PolynomB;
    si{i}.PolynomA = zeros(1,length(PolynomB));
    si{i}.MaxOrder = length(PolynomB)-1;
end

function indcs = get_bunch(element_idx, nr_particles)
indcs = (nr_particles*(element_idx-1)+1):(nr_particles*(element_idx));

function handle = create_new_x_phase_space_plot(bunch, accept, twiss, ptitle, fig_handle, bunch_color)

if ~exist('bunch_color','var')
    bunch_color = 'b.';
end


if ~exist('fig_handle','var') || isempty(fig_handle)
    handle = figure; hold all;
else
    handle = fig_handle;
end
if bunch_color(1) == 'c'
    color = eval(bunch_color(2:end));
    figure(handle); plot(1e3*bunch(1,:), 1e3*bunch(2,:), '.', 'Color', color);
else
    figure(handle); plot(1e3*bunch(1,:), 1e3*bunch(2,:), bunch_color);
end
%figure(handle); plot(1e3*bunch(1,1), 1e3*bunch(2,1), 'x', 'MarkerEdgeColor','r','MarkerFaceColor','r');
if ~isempty(accept) && ~isempty(twiss)
    a = linspace(0,2*pi,300);
    rx = sqrt(accept/1e6*twiss.betax) * cos(a);
    px = -sqrt(accept/1e6/twiss.betax)*(twiss.alphax*cos(a)-sin(a));
    figure(handle); plot(1e3*rx,1e3*px, 'k');
end
figure(handle); xlabel('RX [mm]'); ylabel('PX [mrad]'); title(ptitle); grid('on');
drawnow;

