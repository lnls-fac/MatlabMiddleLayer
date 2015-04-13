function tune_from_stripline


clc; delete(timerfindall);

%% units
m  = 1; mm = 1e-3; um = 1e-6; s  = 1; Hz = 1; urad = 1e-6;

%% loads initial AT model
the_ring = load_initial_lattice_model;

 
%% nominal lattice parameters
twiss = calctwiss(the_ring);
tunex = twiss.mux(end) / 2 / pi; frac_tunex = tunex - floor(tunex);
tuney = twiss.muy(end) / 2 / pi; frac_tuney = tuney - floor(tuney);

%% tune measurement parameters
kick_amp     = 1 * 1 * urad;   % kick amplitude of stripline (both horizontal and vertical
nr_pts       = 1 * 125;        % nr of points taken in the measurement
bpm_res      = 1 * 20 * um;    % BPM resolution
excit_sweep  = linspace(frac_tuney - 0.05, frac_tunex + 0.05, 2^10); 
%excit_sweep  = linspace(frac_tuney - 0.02, frac_tuney + 0.02, 2^8); 
nr_particles = 1;

%% measurement simulation
damped_orbit = repmat(findorbit6(the_ring, length(the_ring)+1), 1, nr_particles);
h = figure; h1 = axes('Parent',h);
lnls_create_waitbar('sweeping excitation tunes', 0.5, length(excit_sweep));
init_orbit = damped_orbit + gen_distribution(the_ring, nr_particles);
fftexcit_x = zeros(size(excit_sweep));
fftexcit_y = zeros(size(excit_sweep));
mx = 0; my = 0; me = 0;
i0 = 100;

for i=1:length(excit_sweep)
    
    % track data with fixed excitation frequency
    [fftexcit_x(i) fftexcit_y(i) max_x max_y max_e init_orbit] = make_measurement(the_ring, kick_amp, excit_sweep(i), nr_pts, bpm_res, init_orbit);
    mx = max([mx max_x]); my = max([my max_y]); me = max([me max_e]);
    init_orbit = damped_orbit + gen_distribution(the_ring, nr_particles); % damps the beam
    
    % plots data
    clf(h1); 
    miny = min([min(fftexcit_x(fftexcit_x > 0)) min(fftexcit_y(fftexcit_y > 0))]);
    semilogy(h1, excit_sweep(1:i), [fftexcit_x(1:i)' fftexcit_y(1:i)']); hold on; 
    semilogy(h1, [frac_tunex frac_tunex], [miny max(fftexcit_x)], 'k--');
    semilogy(h1, [frac_tuney frac_tuney], [miny max(fftexcit_y)], 'k--');
    xlabel('excitation tune'); ylabel('abs(fft(response)) [a.u.]'); title(['MaxH: ' num2str(1e6*mx) ' um, MaxV: ', num2str(1e6*my), ' um, MaxE: ', num2str(1e6*me), ' ppm']);
    drawnow;
    if (i>i0)
        [fit_tunex fit_tuney] = fit_tunes(excit_sweep, fftexcit_x, fftexcit_y, 0.007);
    else
        [fit_tunex fit_tuney] = fit_tunes(excit_sweep, fftexcit_x, fftexcit_y, 0.007);
    end
    fprintf('%04i %7.5f:  %6.1f um, %6.1f um, (%8.6f %8.6f), (%8.6f %8.6f)\n', i, excit_sweep(i), 1e6*max_x, 1e6*max_y, abs(fit_tunex), abs(fit_tunex - frac_tunex), abs(fit_tuney), abs(fit_tuney - frac_tuney));
    

    lnls_update_waitbar(i);
end
lnls_delete_waitbar;

function [fit_tunex fit_tuney] = fit_tunes(excit_sweep, fftexcit_x, fftexcit_y, tune_window)

% fitting
[~,  idx] = max(fftexcit_y);
sel = (abs(excit_sweep - excit_sweep(idx)) < tune_window) & (fftexcit_y ~= 0);
x = excit_sweep(sel);
y = log10(fftexcit_y(sel));
if length(y) > 2
    p = polyfit(x, y, 2);
    fit_tuney = -p(2)/p(1)/2;
else
    fit_tuney = 0;
end

[~,  idx] = max(fftexcit_x);
sel = (abs(excit_sweep - excit_sweep(idx)) < tune_window) & (fftexcit_x ~= 0);
x = excit_sweep(sel);
y = log10(fftexcit_x(sel));
if length(y) > 2
    p = polyfit(x, y, 2);
    fit_tunex = -p(2)/p(1)/2;
else
    fit_tunex = 0;
end

function the_ring = load_initial_lattice_model

global THERING

% initial SIRIUS model @ 3 GeV
sirius; setenergymodel(3.0);
%setoperationalmode(2);
%lnls1; %setpv('SD',0);
setcavity('on');
setradiation('on');

% sexts = findmemberof('SEXT');
% for i=1:length(sexts)
%     setpv(sexts{i}, 0);
% end

% adds stripline
the_ring = THERING;
t = corrector('STRIPLINE', 0, [0 0], 'CorrectorPass');
r = buildlat([t]);
the_ring(1) = r(1);



 
function [fftexcit_x fftexcit_y max_x max_y max_e final] = make_measurement(the_ring, kick_amp, excit_tune, nr_pts, bpm_res, init)

the_ring{1}.PassMethod = 'CorrectorPass';
the_ring{1}.KickAngle  = [0 0];

error_x = bpm_res * random('norm', 0, 1, nr_pts, 1);
error_y = bpm_res * random('norm', 0, 1, nr_pts, 1);

datax = 0; datay = 0;
max_x = 0; max_y = 0; max_e = 0;
nturn = 0;
for n=1:nr_pts
    kick = 1 * kick_amp * sin(2*pi*excit_tune*nturn);
    the_ring{1}.KickAngle(1) = 1*kick;
    the_ring{1}.KickAngle(2) = 1*kick;
    orb = linepass(the_ring, init, length(the_ring)+1);
    init = orb;
    beam_x =  mean(init(1,:));
    beam_y =  mean(init(3,:));
    beam_e =  mean(init(5,:));
    max_x = max([max_x abs(beam_x)]);
    max_y = max([max_y abs(beam_y)]);
    max_e = max([max_e abs(beam_e)]);
    meas_x = beam_x + error_x(n);
    meas_y = beam_y + error_y(n);
    datax = datax + meas_x * exp(2*pi*excit_tune*nturn*1j);
    datay = datay + meas_y * exp(2*pi*excit_tune*nturn*1j);
    nturn = nturn + 1;
end
%fprintf('excit %7.5f: %6.2f %6.2f um \n', excit_tune, 1e6*max_x, 1e6*max_y);
fftexcit_x = abs(datax) / sqrt(nr_pts);
fftexcit_y = abs(datay) / sqrt(nr_pts);
final = init;
setappdata(0, 'NTurn', nturn);



function population = gen_distribution(the_ring, nr_particles)


population = zeros(6, nr_particles);

if nr_particles > 1
    
    twiss = calctwiss(the_ring);
    ats   = atsummary(the_ring);
    twiss.gammax = (1 + twiss.alphax.^2) ./ twiss.betax;
    twiss.gammay = (1 + twiss.alphay.^2) ./ twiss.betay;
    sigmax  = sqrt(twiss.betax * ats.naturalEmittance + (twiss.etax * ats.naturalEnergySpread).^2);
    sigmaxl = sqrt(twiss.gammax * ats.naturalEmittance + (twiss.etaxl * ats.naturalEnergySpread).^2);
    sigmay  = sqrt(twiss.betay * ats.naturalEmittance + (twiss.etay * ats.naturalEnergySpread).^2);
    sigmayl = sqrt(twiss.gammay * ats.naturalEmittance + (twiss.etayl * ats.naturalEnergySpread).^2);
    sigmae  = ats.naturalEnergySpread;
    sigmal  = ats.bunchlength;
        
    population(1,2:end) = random('norm', 0, sigmax(1), nr_particles-1,1);
    population(2,2:end) = random('norm', 0, sigmaxl(1), nr_particles-1,1);
    population(3,2:end) = random('norm', 0, sigmay(1), nr_particles-1,1);
    population(4,2:end) = random('norm', 0, sigmayl(1), nr_particles-1,1);
    population(5,2:end) = random('norm', 0, sigmae, nr_particles-1,1);
    population(6,2:end) = random('norm', 0, sigmal, nr_particles-1,1);
end








