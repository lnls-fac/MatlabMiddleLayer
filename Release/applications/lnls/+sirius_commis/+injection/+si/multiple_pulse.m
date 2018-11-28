function [eff, r_end, machine, r_bpm, int_bpm] = multiple_pulse(machine, param, param_errors, n_part, n_pulse, point, kckr, plt, diag)
% Simulation of injection pulses to the booster. The starting point is the
% end of injection septum. 
%
% INPUTS: 
% - machine: cell with ring model which the first point is InjSept
% - param: struct with injection parameters and systematic/pulsed errors
% - n_part: number of particles
% - n_pulse: number of injection pulses
% - point: specific point over the ring to stop tracking 
% - kckr: 'on' or 'off' turns on or off the injection kicker
% - plt [optional]: 'plot' or empty is used to plot the points of tracking
% - diag [optional]: 'diag' is the diagnostic indicator, enable the
% functionality of return the measured position on BPM with errors and also
% plot its values (if plot is activated)
%
% OUTPUTS:
% - eff: efficiency of each injected pulse until the specified point (input
% point) comparison between remaining particle reaching the point and
% n_part
% - r_scrn: returns the x and y position of specified point (used to determine
% the position on a screen when point = Scrn) averaged over the pulses and
% the particles
% - r_end: a n_pulse x 6 x n_part vector at the end of ring which can be
% used to perform turns around the ring of the injected pulses 
% - machine: the machine with injection kicker turned on
% - r_bpm: 2 x 50 matrix with BPM measurements with errors averaged over
% injection pulses and over particles
% - int_bpm: intensity of particles reaching the each BPMs (efficiency in
% the BPMs points), used to estimate the intensity dependent BPM error.
%
% Version 1 - Murilo B. Alves - October 4th, 2018.

sirius_commis.common.initializations();

injkckr = findcells(machine, 'FamName', 'InjDpKckr');
bpm = findcells(machine, 'FamName', 'BPM');
l_bpm = length(bpm);
eff = zeros(1, n_pulse);

sigma_bpm = zeros(n_pulse, 2, l_bpm);
r_pulse = zeros(n_pulse, 2, point);
r_diag_bpm = zeros(n_pulse, 2, l_bpm);
r_end = zeros(n_pulse, 6, n_part);
if(exist('kckr','var'))
    if(strcmp(kckr,'on'))
        flag_kckr = true;
    elseif(strcmp(kckr,'off'))
        flag_kckr = false;
    end            
else
    error('Set if the kicker is turned on or off')
end

flag_diag = false;

if(exist('plt','var'))
    if(strcmp(plt,'plot'))
        flag_plot = true;
    elseif(strcmp(plt,'diag'))
        flag_diag = true;
        flag_plot = false;
        orbit = param.orbit;
    else
        error('Variable plot problem');
    end
elseif(~exist('plt','var'))
        flag_plot = false;
end

if(exist('diag','var'))
    if(strcmp(diag,'diag'))
        flag_diag = true;
        orbit = findorbit4(machine, 0, 1:length(machine));
        param.orbit = orbit;
    end
elseif(~exist('diag','var')) && ~flag_diag
        flag_diag = false;
end

for j=1:n_pulse     
    error_x_pulse = lnls_generate_random_numbers(1, 1, 'norm') * param_errors.x_error_pulse;
    param.offset_x = param.offset_x_sist + 0*error_x_pulse;

    error_xl_pulse = lnls_generate_random_numbers(1, 1, 'norm', param_errors.cutoff) * param_errors.xl_error_pulse;
    param.offset_xl = param.offset_xl_sist + 0*error_xl_pulse;
    % Peak to Peak values from measurements - cutoff = 1;

    if flag_kckr
        error_kckr_pulse = lnls_generate_random_numbers(1, 1, 'norm', param_errors.cutoff) * param_errors.kckr_error_pulse;
        param.kckr = param.kckr_sist + 0*error_kckr_pulse;
        machine = lnls_set_kickangle(machine, param.kckr, injkckr, 'x');
    end

    error_delta_pulse = lnls_generate_random_numbers(1, 1, 'norm', param_errors.cutoff) * param_errors.delta_error_pulse;
    param.delta = param.delta_sist + 0*error_delta_pulse;
    
    param.phase = param_errors.phase_offset;

    if flag_diag        
        [r_xy, r_end_part, r_bpm] = sirius_commis.injection.si.single_pulse(machine, param, n_part, point);
        r_diag_bpm(j, :, :) =  nanmean(r_bpm, 2);
        [sigma_bpm(j, :, :), int_bpm] = sirius_commis.common.bpm_error_inten(r_bpm, n_part, param_errors.sigma_bpm);
    else
        [r_xy, r_end_part] = sirius_commis.injection.si.single_pulse(machine, param, n_part, point);
    end    
    r_pulse(j, :, :) =  nanmean(r_xy, 2);
    r_end(j, :, :) = r_end_part;
    
    eff(j) = sirius_commis.common.calc_eff(n_part, r_xy(:, :, point));      

    if flag_plot
        plot_si_turn(machine, param.orbit, r_xy);
    end

    if ~mod(j, 10)
    fprintf('. %i pulses \n', j);
    else
    fprintf('.');
    end
end

fprintf('AVERAGE EFFICIENCY :  %g %% \n', mean(eff)*100);

if flag_diag
    r_diag_bpm = r_diag_bpm + sigma_bpm;
    if n_pulse > 1
        r_diag_bpm = squeeze(nanmean(r_diag_bpm, 1));
    else
        r_diag_bpm = squeeze(r_diag_bpm);
    end
    r_bpm = sirius_commis.common.compares_vchamb(machine, r_diag_bpm, bpm, 'bpm');
    sirius_commis.common.plot_bpms(machine, orbit, r_bpm, int_bpm);
end
 fprintf('=================================================\n');
end

function plot_si_turn(machine, orbit, r_final)
    VChamb = cell2mat(getcellstruct(machine, 'VChamber', 1:length(machine)))';
    s = findspos(machine, 1:length(machine));
    xx = squeeze(nanmean(r_final(1, :, :), 2));
    sxx = squeeze(nanstd(r_final(1, :, :), 0, 2));
    gcf();
    ax = gca();
    mm = 1e3;
    hold off;
    plot(ax, s, mm*(xx+3*sxx)', 'b --');
    hold all;
    plot(ax, s, mm*(xx-3*sxx)', 'b --');
    plot(ax, s, mm*(xx)', '.-r', 'linewidth', 3);
    plot(ax, s, mm*VChamb(1,:),'k');
    plot(ax, s, -mm*VChamb(1,:),'k');
    % plot(ax, s, orbit(1, :) * mm, '.-k', 'linewidth', 2);
    % plot(ax, s, orbit(3, :) * mm, '.-k', 'linewidth', 2);
    ylim(ax, [-15, 15]);
    xlim(ax, [0, 520]);
    drawnow;        
end




