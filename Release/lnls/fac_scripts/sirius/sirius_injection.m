function sirius_injection()

%% PARAMETERS

p.bo_version      = 'BO.V03.02';
p.ts_version      = 'TS.V02';
p.si_version      = 'SI.V16.01';
p.ts_mode         = 'M1';
p.nr_particles    = 100;      % nr_particles in simulation
p.bo_coupling     = 0.10;     % booster transverse coupling (<1.0)
p.bo_kickex_kick  = 2.461e-3; % booster extraction kick [rad]
p.nr_turns        = 150;      % number of turns to track
p.plot_flag       = true;
p.print_flag      = true;
%p.si_pmm_strength = 0.80;     % storage ring pmm strength [no unit] M1
p.si_pmm_strength = 0.72;      % storage ring pmm strength [no unit] M2
p.si_pmm_pulse    = [1.0, 0.00, 0.00]; % temporal profile of pmm pulse
p.si_pmm_physaccp = [0.0095, Inf];

% creates lattice models
p = create_lattice_models(p);

% shifts models
p = shift_models(p);

% creates bunch at entrance of BO extraction kicker
p = create_initial_bunch(p);

% sets extraction kicker and kicks beam
p.bo = lnls_set_kickangle(p.bo, p.bo_kickex_kick, p.bo_kickex_idx, 'x');

% transport bunch from entrance of extraction kicker to entrance of extraction thin septum
bo_septex_idx = findcells(p.bo, 'FamName', 'sept_ex');
tbunch = linepass(bo, p.bunch, 1:p.bo_septex_idx(1));
if p.print_flag, fprintf('- setting bo extraction kick to %+.3f mrad\n', p.bo_kickex_kick*1000); end

% plots bunch after extraction kicker
if p.plot_flag, create_new_x_phase_space_plot(tbunch(:,get_bunch(p.bo_kickex_idx(end)+1, p.nr_particles)), [], [], 'bunch after extraction kicker'); end

% calcs particle loss and plots trajectories
[tbunch, p.lost_particles1] = calc_particle_loss(tbunch, p.bo(1:p.bo_septex_idx(1)), p.nr_particles, 'from BO extraction kicker to extraction septum', p.plot_flag);
if p.print_flag, fprintf('- number of electrons lost from entrance of bo extkicker to entrance of bo extsepta: %i\n', p.lost_particles1); end

% gets bunch at entrance of thin extraction septum
p.bunch = tbunch(:,get_bunch(bo_septex_idx(1), p.nr_particles));
if p.plot_flag, create_new_x_phase_space_plot(p.bunch, [], [], 'bunch at entrance of extraction septa (BO coordinates)'); end


% varies and plots injection efficiency vs si pmm strength
si_pmm_strength = p.si_pmm_strength * linspace(0.8,1.2,55);
p = vary_si_pmm_strength(p, si_pmm_strength);



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
    
fprintf('\n');


function p = shift_models(p0)

p = p0;

% shifts it so that it starts at begining of extraction kicker
bo_kickex_idx = findcells(p.bo, 'FamName', 'kick_ex');
p.bo = [p.bo(bo_kickex_idx(1):end) p.bo(1:bo_kickex_idx(1)-1)];
p.bo_kickex_idx = findcells(p.bo, 'FamName', 'kick_ex');

% shifts si so that it starts at injection point
injection_point = findcells(p.si, 'FamName', 'eseptinj');
p.si = [p.si(injection_point:end) p.si(1:injection_point-1)];


function p = vary_si_pmm_strength(p0, si_pmm_strength)

p = p0;

efficiency = zeros(size(si_pmm_strength));
for i=1:length(si_pmm_strength)
    close all; drawnow;
    fprintf('%03i: pmm_strength = %.4f, ', i, si_pmm_strength(i));
    p.si_pmm_strength = si_pmm_strength(i);
    p = sirius_injection_local(p);
    efficiency(i) = (p.nr_particles - p.lost_particles)/p.nr_particles;
    fprintf('efficienty = %7.3f %%\n', 100*efficiency(i));
end
figure; plot(si_pmm_strength, efficiency); 


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






function p = sirius_injection_local(p0)



%% INITIALIZATIONS

p = p0;

% global parameters
sirius_path = fullfile(lnls_get_root_folder(), 'code', 'MatlabMiddleLayer', 'Release', 'machine', 'SIRIUS');


%% LOADING MODELS

if ~isfield(p, 'bo') || isempty(p.bo)
    % loads BO model
    addpath(fullfile(sirius_path, p.bo_version));
    bo = sirius_bo_lattice(3.0);
else
    bo = p.bo;
end
% shifts it so that it starts at begining of extraction kicker
bo_kickex_idx = findcells(bo, 'FamName', 'kick_ex');
bo = [bo(bo_kickex_idx(1):end) bo(1:bo_kickex_idx(1)-1)];
bo_kickex_idx = findcells(bo, 'FamName', 'kick_ex');

if ~isfield(p, 'ts') || isempty(p.ts)
    % loads TS model
    addpath(fullfile(sirius_path, p.ts_version));
    ts = sirius_ts_lattice(p.ts_mode);
else
    ts = p.ts;
end

if ~isfield(p, 'si') || isempty(p.si)
    % loads SI model
    addpath(fullfile(sirius_path, p.si_version));
    si = sirius_si_lattice();
else
    si = p.si;
end
% shifts si so that it starts at injection point
injection_point = findcells(si, 'FamName', 'eseptinj');
si = [si(injection_point:end) si(1:injection_point-1)];


%% INITIAL BUNCH

% generates bunch at entrance of BO extraction kicker
bo_twiss = calctwiss(bo);
bo_eqparms = atsummary(bo);
e0 = bo_eqparms.naturalEmittance; k = p.bo_coupling;
emitx =  1 * e0 / (1.0 + k); emity =  k * e0 / (1.0 + k);
bo_twiss0 = create_twiss(bo_twiss,1);
co = findorbit6(bo);
bunch = lnls_generate_bunch(emitx, emity, bo_eqparms.naturalEnergySpread, bo_eqparms.bunchlength, bo_twiss0, p.nr_particles-1, 30);
bunch = [co, bunch + repmat(co, 1, size(bunch,2))];
if p.plot_flag, create_new_x_phase_space_plot(bunch, [], [], 'bunch at entrance of BO extraction kicker'); end
if p.print_flag, fprintf('- initial beam with %i particles\n', p.nr_particles); end;


%% EXTRACTION KICK

% sets extraction kicker and kicks beam
bo = lnls_set_kickangle(bo, p.bo_kickex_kick, bo_kickex_idx, 'x');

% transport bunch from entrance of extraction kicker to entrance of extraction thin septum
bo_septex_idx = findcells(bo, 'FamName', 'sept_ex');
tbunch = linepass(bo, bunch, 1:bo_septex_idx(1));
if p.print_flag, fprintf('- setting bo extraction kick to %+.3f mrad\n', p.bo_kickex_kick*1000); end

% plots bunch after extraction kicker
if p.plot_flag, create_new_x_phase_space_plot(tbunch(:,get_bunch(bo_kickex_idx(end)+1, p.nr_particles)), [], [], 'bunch after extraction kicker'); end

% calcs particle loss and plots trajectories
[tbunch, p.lost_particles1] = calc_particle_loss(tbunch, bo(1:bo_septex_idx(1)), p.nr_particles, 'from BO extraction kicker to extraction septum', p.plot_flag);
if p.print_flag, fprintf('- number of electrons lost from entrance of bo extkicker to entrance of bo extsepta: %i\n', p.lost_particles1); end

% gets bunch at entrance of thin extraction septum
bunch = tbunch(:,get_bunch(bo_septex_idx(1), p.nr_particles));
if p.plot_flag, create_new_x_phase_space_plot(bunch, [], [], 'bunch at entrance of extraction septa (BO coordinates)'); end


%% TRANSPORT ALONG TS


% translation of bunch coordinates from BO to TS
ts_chamber_rx_at_bo = 22e-3;  % [m]   (rx of center of TS vacuum chamber w.r.t. TS coord. system)
ts_chamber_px_at_bo = 5.0e-3; % [rad] (px of center of TS vacuum chamber w.r.t. TS coord. system)
ts_chamber_at_bo = [ts_chamber_rx_at_bo;ts_chamber_px_at_bo;0;0;0;0];
bunch = bunch - repmat(ts_chamber_at_bo, 1, size(bunch,2));
if p.plot_flag, create_new_x_phase_space_plot(bunch, [], [], 'bunch at beginning of TS'); end

% adds error in thin and thick BO extraction septa
% (INCOMPLETE!!! right now they have ideal pulses)

% transports bunch through TS
tbunch = linepass(si, bunch, 1:length(si)+1);

% calcs particle loss and plots trajectories
[tbunch, p.lost_particles2] = calc_particle_loss(tbunch, [si si(1)], p.nr_particles, 'bunch transported along TS', p.plot_flag);
if p.print_flag, fprintf('- number of electrons lost from entrance of bo extsepta to exit of ts line: %i\n', p.lost_particles2 - p.lost_particles1); end

% plots bunch at end of TS
bunch = tbunch(:,get_bunch(length(si)+1, p.nr_particles));
if p.plot_flag, create_new_x_phase_space_plot(bunch, [], [], 'bunch at end of TS'); end


%% INJECTION IN SI

% translation of bunch coordinates from TS to SI
si_chamber_rx_at_ts =  0.01935; % [m]   (as measured at TS coordinates)
si_chamber_px_at_ts = -2.84e-3; % [rad] (as measured at SI coordinates)
co = findorbit6(si);
p.beam_center_at_si_injection = mean(bunch(6,:));
% p.beam_spread_at_si_injection = std(bunch(6,:));
% fprintf('- beam longitudinal center at si injection point is %.3f mm\n', 1000*p.beam_center_at_si_injection);
% fprintf('- beam longitudinal spread at si injection point is %.3f mm\n', 1000*p.beam_spread_at_si_injection);
si_chamber_at_ts = [si_chamber_rx_at_ts;si_chamber_px_at_ts;0;0;0;p.beam_center_at_si_injection-co(6)];
bunch = bunch - repmat(si_chamber_at_ts, 1, size(bunch,2)); % bunch at injection point
if p.print_flag, fprintf('- beam centroid at si injpoint (rx,px)(ry,py): (%+.3f mm, %+.3f mrad) (%+.3f mm, %+.3f mrad)\n', 1000*bunch([1,2,3,4],1)); end

% plots bunch at SI injection point
if p.plot_flag, create_new_x_phase_space_plot(bunch,[], [], 'bunch at injection point of SI'); end

% transports bunch from injection point to pmm
si_pmm_idx = findcells(si, 'FamName', 'pmm');
inj_2_pmm  = si(1:si_pmm_idx(1));
bunch = linepass(inj_2_pmm, bunch, 1:length(inj_2_pmm));
[bunch, p.lost_particles3] = calc_particle_loss(bunch, inj_2_pmm, p.nr_particles, 'from SI injection point to entrance of PMM', p.plot_flag);
if p.print_flag, fprintf('- number of electrons lost from si injpoint to entrance of si pmm: %i\n', p.lost_particles3 - p.lost_particles2); end
bunch = bunch(:,get_bunch(length(inj_2_pmm),p.nr_particles)); % bunch at entrance of si pmm
if p.print_flag, fprintf('- beam centroid at entrance of si pmm (rx,px): (%+.3f mm, %+.3f mrad)\n', 1000*bunch([1,2],1)); end

% shifts si so that it starts at injection point
si = [si(si_pmm_idx:end) si(1:si_pmm_idx-1)];
si_pmm_idx = findcells(si, 'FamName', 'pmm');
si{si_pmm_idx}.VChamber(1) = p.si_pmm_physaccp(1);
si_twiss = calctwiss(si);


% gets pmm pulse parameters
p.si_pmm_pulse = [p.si_pmm_pulse, zeros(1,p.nr_turns-length(p.si_pmm_pulse))];
[x, integ_field, kickx, LPolyB] = sirius_si_pmm_kick(p.si_pmm_strength, [2,3,4,5,6,7,8,9,10], p.plot_flag);

% plots bunch at SI pmm entrance
twiss = calctwiss(si); twiss0 = create_twiss(si_twiss, 1);
s = findspos(si,1:length(si));
[xaccept,yaccept,~,err] = lnls_calcula_aceitancias(si, s, twiss.betax, twiss.betay, -1);
if p.plot_flag
    fig = create_new_x_phase_space_plot(bunch, xaccept, twiss0, 'bunch before pmm kick'); 
    figure(fig); plot(1000*x,-1000*kickx);
end


for i=1:p.nr_turns
    
    % sets PMM
    si = sets_pmm(si, si_pmm_idx, p.si_pmm_pulse(i), LPolyB);

    % tracks 1 turn
    trajectories = linepass(si, bunch, 1:length(si)+1);

    % plots bunch after pmm kick
    tbunch = trajectories(:,get_bunch(si_pmm_idx(end)+1,p.nr_particles)); % bunch at exit of si pmm
    if p.plot_flag, create_new_x_phase_space_plot(tbunch, xaccept, twiss0, 'bunch before and after pmm kick', fig); end

    % calcs particle loss
    if i==1
        p.pos_pmm_1stkick = 1000*tbunch([1,2],1);
        if p.print_flag, fprintf('- beam centroid at first si pmm kick (rx,px): (%+.3f mm, %+.3f mrad)\n', p.pos_pmm_1stkick); end
        % calcs kicks from first passage in the PMM
        p.kickx = tbunch(2,1) - bunch(2,1);
        % plots trajectory in first turn
        [trajectories, lost_particles] = calc_particle_loss(trajectories, [si si(1)], p.nr_particles, '1-turn around SI', p.plot_flag);
    else
        [trajectories, lost_particles] = calc_particle_loss(trajectories, [si si(1)], p.nr_particles, '1-turn around SI', false);
    end
    if p.print_flag, fprintf('- number of electrons lost after %i turns: %i\n', i, lost_particles); end
    bunch = trajectories(:,get_bunch(length(si)+1,p.nr_particles));       % bunch at entrance si pmm
    if lost_particles == p.nr_particles, break; end
end

p.lost_particles = lost_particles;




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


function si = sets_pmm(old_si, pmm_idx, strength, LPolyB)
si = old_si;
si_pmm_len = sum(getcellstruct(si, 'Length', pmm_idx));
PolynomB = LPolyB/si_pmm_len;
for i=pmm_idx
    si{i}.PolynomB = strength * PolynomB; 
    si{i}.PolynomA = zeros(1,length(PolynomB));
    si{i}.MaxOrder = length(PolynomB)-1;
end


function indcs = get_bunch(element_idx, nr_particles)
indcs = (nr_particles*(element_idx-1)+1):(nr_particles*(element_idx));


function handle = create_new_x_phase_space_plot(bunch, accept, twiss, ptitle, fig_handle)

if ~exist('fig_handle','var') || isempty(fig_handle)
    handle = figure; hold all;
else
    handle = fig_handle;
end
figure(handle); plot(1e3*bunch(1,:), 1e3*bunch(2,:), '.'); 
figure(handle); plot(1e3*bunch(1,1), 1e3*bunch(2,1), 'o', 'MarkerEdgeColor','r','MarkerFaceColor','r');
if ~isempty(accept) && ~isempty(twiss)
    a = linspace(0,2*pi,300);
    rx = sqrt(accept/1e6*twiss.betax) * cos(a);
    px = -sqrt(accept/1e6/twiss.betax)*(twiss.alphax*cos(a)-sin(a));
    figure(handle); plot(1e3*rx,1e3*px, 'r');
end
figure(handle); xlabel('rx / mm'); ylabel('px / mrad'); title(ptitle); grid('on');
drawnow;




