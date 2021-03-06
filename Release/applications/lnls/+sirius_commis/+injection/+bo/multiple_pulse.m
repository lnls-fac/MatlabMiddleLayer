function r_particles_out = multiple_pulse(machine, param, param_errors, n_part, n_pulse, point, kckr, plt, diag)
% Simulation of injection pulses in the booster. The starting point is the
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
% - r_particles: structure with the fields
%       - r_track: 6D coordinates for all the particles at all the points of
%       ring model
%       - r_bpm: position x and y for all the particles at BPM points
%       - int_bpm: intensity of particles reaching the each BPMs (efficiency in
%        the BPMs points), used to estimate the intensity dependent BPM error.
%       - eff: efficiency of each injected pulse until the specified point comparison between remaining particle reaching the point and n_part
%       - r_scrn: returns the x and y position of specified point (used to determine the position on a screen when point = Scrn) averaged over the pulses and the particles

% sirius_commis.common.initializations();

    % Initializing variables
    bpm = findcells(machine, 'FamName', 'BPM');
    l_bpm = length(bpm);
    eff = zeros(1, n_pulse);
    sigma_scrn = zeros(n_pulse, 2);
    sigma_bpm = zeros(n_pulse, 2, l_bpm);
    r_bpm_pulse = zeros(n_pulse, 2, l_bpm);
    r_track_pulse = zeros(n_pulse, 2, point);
    r_end = zeros(n_pulse, 6, n_part);

    injkckr = findcells(machine, 'FamName', 'InjKckr');
    scrn = findcells(machine, 'FamName', 'Scrn');

    % If the required point is one of the screens, it takes the correspondent offset value
    if ismember(point, scrn)
        off_scrn = param_errors.offset_scrn(:, point == scrn);
    else
        off_scrn = 0;
    end

    % The tracking can be done either with the kicker turned on or off
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
            orbit = param.orbit;
        end
    elseif(~exist('diag','var')) && ~flag_diag
            flag_diag = false;
    end

    pbp = 1/10; % Pulse by Pulse variation
    inj_nom = false; % Injection with nominal parameters (no errors)

    for j=1:n_pulse
        if inj_nom
            % Setting nominal values for injection parameters
            param.offset_x = param.offset_x0;
            param.offset_xl =  param.offset_xl0;
            param.offset_y = param.offset_y0;
            param.offset_yl = param.offset_yl0;

            if flag_kckr
                % Setting the kicker on
                machine = lnls_set_kickangle(machine, param.kckr0, injkckr, 'x');
            end

            % No energy errors
            param.delta = 0;
            param.delta_ave = 0;
        else
            % Setting injection parameters systematic errors and with pulse by pulse variations
            error_x_pulse = lnls_generate_random_numbers(1, 1, 'norm') * param_errors.x_error_pulse;
            param.offset_x = param.offset_x_syst + pbp * error_x_pulse;

            error_xl_pulse = lnls_generate_random_numbers(1, 1, 'norm', param_errors.cutoff) * param_errors.xl_error_pulse;
            param.offset_xl = param.offset_xl_syst + pbp * error_xl_pulse;

            error_y_pulse = lnls_generate_random_numbers(1, 1, 'norm') * param_errors.y_error_pulse;
            param.offset_y = param.offset_y_syst + pbp * error_y_pulse;

            error_yl_pulse = lnls_generate_random_numbers(1, 1, 'norm', param_errors.cutoff) * param_errors.yl_error_pulse;
            param.offset_yl = param.offset_yl_syst + pbp * error_yl_pulse;

            if flag_kckr
                error_kckr_pulse = lnls_generate_random_numbers(1, 1, 'norm', param_errors.cutoff) * param_errors.kckr_error_pulse;
                param.kckr = param.kckr_syst + pbp * error_kckr_pulse;
                machine = lnls_set_kickangle(machine, param.kckr, injkckr, 'x');
            end

            error_delta_pulse = lnls_generate_random_numbers(1, 1, 'norm', param_errors.cutoff) * param_errors.delta_error_pulse;
            param.delta = param.delta_syst + pbp * error_delta_pulse;
        end

        param.phase = param_errors.phase_offset;

        r_particles = sirius_commis.injection.bo.single_pulse(machine, param, n_part, point);

        if flag_diag
            % Simulation of BPM measurements for each pulse
            if n_part == 1
                r_bpm_pulse(j, :, :) = r_particles.r_bpm;
            else
                % Averaging over particles to obtain centroid position
                r_bpm_pulse(j, :, :) =  nanmean(r_particles.r_bpm, 2);
            end

            %Calculates the intensity dependent error in the BPM measurement
            [sigma_bpm(j, :, :), int_bpm] = sirius_commis.common.bpm_error_inten(r_particles.r_bpm, n_part, param_errors.sigma_bpm);
        end

        r_xy = squeeze(r_particles.r_track([1,3], :, :)); %(x,y) position only
        r_track_pulse(j, :, :) =  squeeze(nanmean(r_xy, 2)); %(x, y) position for the centroid and for each pulse
        r_end(j, :, :) = r_particles.r_track(:, :, end); % 6D position at the last element (used to simulate multiple turns)

        eff(j) = sirius_commis.common.calc_eff(n_part, squeeze(r_xy(:, :, point(end)))); %efficiency of particles reaching the required point

        if flag_plot
            plot_booster_turn(machine, r_xy);
        end

        if ~mod(j, 10)
            fprintf('. %i pulses \n', j);
        else
            fprintf('.');
        end

        if ~flag_diag
            sigma_scrn(j, :) = sirius_commis.injection.bo.screen_error_inten(r_xy, n_part, point, param_errors.sigma_scrn_pulse); %Calculates the intensity dependent error in the Screen measurement
        end
    end

    if point ~= length(machine)
        fprintf('AVERAGE INTENSITY ON SCREEN :  %g %% \n', mean(eff) * 100);
    end

    if ~flag_diag
        r_scrn = r_track_pulse(:, :, point);
        r_scrn = r_scrn + pbp * sigma_scrn; % Jitter Errors
        r_scrn = squeeze(nanmean(r_scrn, 1)); % Average over pulses
        r_scrn = r_scrn - off_scrn'; % Offset error
        r_scrn = sirius_commis.common.compares_vchamb(machine, r_scrn, point, 'screen'); % Vacuum chamber comparison
        r_particles_out.r_screen = r_scrn;
    end

    r_particles_out.r_end = squeeze(r_end);
    r_particles_out.efficiency = eff;

    % sirius_commis.scatplot(1e3 * r_mean_pulse(1, :), 1e3 * r_mean_pulse(2, :), 'circles', 1, 100, 5, 1, 4);

    if flag_diag
        r_bpm_pulse = r_bpm_pulse + pbp * sigma_bpm; % Jitter Errors

        if n_pulse > 1
            r_bpm_mean = squeeze(nanmean(r_bpm_pulse, 1)); % Average over pulses
        else
            r_bpm_mean = squeeze(r_bpm_pulse);
        end

        offset = getcellstruct(machine, 'Offsets', bpm);
        offset = cell2mat(offset)';
        r_bpm_mean = r_bpm_mean - offset; % Offset error
        r_bpm = sirius_commis.common.compares_vchamb(machine, r_bpm_mean, bpm, 'bpm'); % Vacuum chamber compariso
        sirius_commis.common.plot_bpms(machine, orbit, r_bpm, int_bpm);
        r_particles_out.r_bpm = r_bpm;
        r_particles_out.sum_bpm = int_bpm;
    end
end

function plot_booster_turn(machine, r_final)
    VChamb = cell2mat(getcellstruct(machine, 'VChamber', 1:length(machine)))';
    s = findspos(machine, 1:length(machine));
    xx = squeeze(nanmean(r_final(1, :, :), 2));
    sxx = squeeze(nanstd(r_final(1, :, :), 0, 2));
    gcf();
    ax = gca();
    hold off;
    plot(ax, s, (xx+3*sxx)', 'b --');
    hold all;
    plot(ax, s, (xx-3*sxx)', 'b --');
    plot(ax, s, (xx)', '.-r', 'linewidth', 3);
    plot(ax, s, VChamb(1,:),'k');
    plot(ax, s, -VChamb(1,:),'k');
    drawnow;
end
