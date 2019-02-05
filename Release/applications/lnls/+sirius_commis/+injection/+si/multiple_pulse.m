function [eff, r_point, r_end, r_bpm, int_bpm] = multiple_pulse(machine, param, param_errors, n_part, n_pulse, point, kckr, plt, diag, shape)
% Simulation of injection pulses to the booster. The starting point is the
% end of injection septum. 
%
% INPUTS: 
% - machine: cell with storage ring model which the first point is InjSeptF
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
% - r_point: returns the x and y position of specified point averaged over the pulses and
% the particles
% - r_end: a n_pulse x 6 x n_part vector at the end of ring which can be
% used to perform turns around the ring of the injected pulses 
% - machine: the machine with injection kicker turned on
% - r_bpm: 2 x 50 matrix with BPM measurements with errors averaged over
% injection pulses and over particles
% - int_bpm: intensity of particles reaching the each BPMs (efficiency in
% the BPMs points), used to estimate the intensity dependent BPM error.
%
% Version 1 - Murilo B. Alves - December, 2018.

% sirius_commis.common.initializations();

injkckr = findcells(machine, 'FamName', 'InjDpKckr');
bpm = findcells(machine, 'FamName', 'BPM');
l_bpm = length(bpm);
eff = zeros(1, n_pulse);
param_errors.sigma_bpm = 2e-3;
sigma_bpm = zeros(n_pulse, 2, l_bpm);
r_pulse = zeros(n_pulse, 2, point(end));
r_diag_bpm = zeros(n_pulse, 2, l_bpm);
r_end = zeros(n_pulse, 6, n_part);
r_point = zeros(2, n_part, length(point));
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
flag_shape = false;

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
    elseif(strcmp(diag,'shape'))
        flag_diag = false;
        flag_shape = true;
    end
elseif(~exist('diag','var')) && ~flag_diag
        flag_diag = false;
end

if(exist('shape', 'var'))
    if(strcmp(shape, 'shape'))
        flag_shape = true;
    else
        error('Variable shape problem')
    end
elseif(~exist('shape', 'var')) && ~flag_shape
    flag_shape = false;
end

p = 0;
for j=1:n_pulse     
    error_x_pulse = lnls_generate_random_numbers(1, 1, 'norm') * param_errors.x_error_pulse;
    param.offset_x = param.offset_x_sist + p * error_x_pulse;

    error_xl_pulse = lnls_generate_random_numbers(1, 1, 'norm', param_errors.cutoff) * param_errors.xl_error_pulse;
    param.offset_xl = param.offset_xl_sist + p * error_xl_pulse;
    % Peak to Peak values from measurements - cutoff = 1;
    
    error_y_pulse = lnls_generate_random_numbers(1, 1, 'norm') * param_errors.y_error_pulse;
    param.offset_y = param.offset_y_sist + p * error_y_pulse;

    error_yl_pulse = lnls_generate_random_numbers(1, 1, 'norm', param_errors.cutoff) * param_errors.yl_error_pulse;
    param.offset_yl = param.offset_yl_sist + p * error_yl_pulse;

    if flag_kckr
        error_kckr_pulse = lnls_generate_random_numbers(1, 1, 'norm', param_errors.cutoff) * param_errors.kckr_error_pulse;
        param.kckr = param.kckr_sist + p * error_kckr_pulse;
        machine = lnls_set_kickangle(machine, param.kckr, injkckr, 'x');
    end

    error_delta_pulse = lnls_generate_random_numbers(1, 1, 'norm', param_errors.cutoff) * param_errors.delta_error_pulse;
    param.delta = param.delta_sist + 0 * error_delta_pulse;
    
    param.phase = param_errors.phase_offset;

    if flag_diag        
        [r_xy, r_end_part, r_point, r_bpm] = sirius_commis.injection.si.single_pulse(machine, param, n_part, point);
        if n_part == 1
            r_diag_bpm(j, :, :) = r_bpm;
        else
            r_diag_bpm(j, :, :) =  nanmean(r_bpm, 2);
        end
        [sigma_bpm(j, :, :), int_bpm] = sirius_commis.common.bpm_error_inten(r_bpm, n_part, param_errors.sigma_bpm);
    else
        [r_xy, r_end_part, r_point] = sirius_commis.injection.si.single_pulse(machine, param, n_part, point);
        
        if length(point) > 1 
            for i = 1:length(point)
                [erro_bpm(:, j, i), int_bpm(i)] = sirius_commis.common.bpm_error_inten(squeeze(r_point(:, :,i)), n_part, param_errors.sigma_bpm);
            end
        else
            [erro_bpm(:, j), int_bpm] = sirius_commis.common.bpm_error_inten(r_point, n_part, param_errors.sigma_bpm);
        end
            
    end    
    r_pulse(j, :, :) =  nanmean(r_xy, 2);
    r_part(j, :, :, :) = r_point;
    r_end(j, :, :, :) = r_end_part;
    
    eff(j) = sirius_commis.common.calc_eff(n_part, squeeze(r_xy(:, :, point(end))));      

    if flag_plot && ~flag_shape
        plot_si_turn(machine, r_xy);
    end

    if ~mod(j, 10)
        fprintf('. %i pulses \n', j);
    else
        fprintf('.');
    end
end

    r_mean_pulse = squeeze(nanmean(r_part, 1));
    
    %gcf();
    % figure;
    % hold off;
    % scatter(1e3*r_mean_pulse(1, :), 1e3*r_mean_pulse(2, :), 'b');
    % hold on;
    % VChamber = machine{point}.VChamber;
    % circle(0, 0, VChamber(1,1)*1e3);
    %grid on;
    % ylim([-5, 5]);
    % xlim([-5, 5]);
    %drawnow();
    
    if flag_shape
        sirius_commis.scatplot(1e3 * r_mean_pulse(1, :), 1e3 * r_mean_pulse(2, :), 'circles', 2e-2, 1e3, 5, 1, 4);
    end
    %function circle(x,y,r)
        %x and y are the coordinates of the center of the circle
        %r is the radius of the circle
        %0.01 is the angle step, bigger values will draw the circle faster but
        %you might notice imperfections (not very smooth)
    %    ang=0:0.01:2*pi; 
    %    xp=r*cos(ang);
    %    yp=r*sin(ang);
    %    plot(x+xp,y+yp, 'r');
    %end

fprintf('AVERAGE EFFICIENCY :  %g %% \n', mean(eff)*100);

if ~flag_diag
    offset = getcellstruct(machine, 'Offsets', bpm);
    if length(point) > 1
        r_bpm_inj = zeros(n_pulse, 2, length(point));
        for i = 1:length(point)
            r_bpm_inj(:, :, i) = squeeze(r_pulse(:, :, point(i)));
            r_bpm_inj(:, :, i) = r_bpm_inj(:, :, i) + p * erro_bpm(:, :, i)';

        % The comparison with vacuum chamber in this case is screen-like.
            r_bpm_inj2(:, i) = squeeze(nanmean(r_bpm_inj(:, :, i), 1));
            r_bpm_inj2(:, i) = r_bpm_inj2(:, i) + offset{bpm == point(i)}';
            r_bpm_inj2(:, i) = sirius_commis.common.compares_vchamb(machine, r_bpm_inj2(:, i)', point(i), 'screen');
        end
        clear r_point
        r_point = r_bpm_inj2;
    else
        r_point = squeeze(r_pulse(:, :, point));
        r_point = r_point + p * erro_bpm';

        % The comparison with vacuum chamber in this case is screen-like.
        r_point = squeeze(nanmean(r_point, 1));
        r_point = r_point + offset{bpm == point};
        r_point = sirius_commis.common.compares_vchamb(machine, r_point, point, 'screen');
    end
        
end

if flag_diag
    r_diag_bpm = r_diag_bpm + p * sigma_bpm;
    if n_pulse > 1
        r_diag_bpm = squeeze(nanmean(r_diag_bpm, 1));
    else
        r_diag_bpm = squeeze(r_diag_bpm);
    end
    offset = getcellstruct(machine,'Offsets', bpm);
    offset = cell2mat(offset)';
    r_diag_bpm = r_diag_bpm + offset;
    % orbit = findorbit4(machine, 0, 1:length(machine));
    r_bpm = sirius_commis.common.compares_vchamb(machine, r_diag_bpm, bpm, 'bpm');
    % sirius_commis.common.plot_bpms(machine, orbit, r_bpm, int_bpm);
end
 fprintf('=================================================\n');
end

function plot_si_turn(machine, r_final)
    VChamb = cell2mat(getcellstruct(machine, 'VChamber', 1:size(r_final, 3)))';
    s = findspos(machine, 1:size(r_final, 3));
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
    grid on;
    % plot(ax, s, orbit(1, :) * mm, '.-k', 'linewidth', 2);
    % plot(ax, s, orbit(3, :) * mm, '.-k', 'linewidth', 2);
    ylim(ax, [-mm*VChamb(1,1), mm*VChamb(1,1)]);
    xlim(ax, [0, s(end)]);
    drawnow;        
end




