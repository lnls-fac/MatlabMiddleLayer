function r_particles_out = multiple_pulse(machine, param, param_errors, n_part, n_pulse, point, kckr, plt, diag, shape)
% Simulation of injection pulses in the storage ring. The starting point is the
% end of injection septum.
%
% INPUTS:
% - machine: cell with ring model which the first point is InjSeptF
% - param: struct with injection parameters and systematic/pulsed errors
% - n_part: number of particles
% - n_pulse: number of injection pulses
% - point: specific point over the ring to stop tracking
% - kckr: 'on' or 'off' turns on or off the dipolar injection kicker
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
    sigma_bpm = zeros(n_pulse, 2, l_bpm);
    r_end = zeros(n_pulse, 6, n_part);
    r_point = zeros(2, n_part, point(end));
    r_bpm_pulse = zeros(n_pulse, 2, l_bpm);
    r_track_pulse = zeros(n_pulse, 2, point(end));
    r_bpm_inj2 = zeros(2, length(point));
    erro_bpm = zeros(2, n_pulse, length(point));
    orbit = param.orbit;

    injkckr = findcells(machine, 'FamName', 'InjDpKckr');

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
    flag_shape = false;

    if(exist('plt','var'))
        if(strcmp(plt,'plot'))
            flag_plot = true;
        elseif(strcmp(plt,'diag'))
            flag_diag = true;
            flag_plot = false;
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

    pbp = 0; % Pulse by Pulse variation
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
            error_x_pulse = lnls_generate_random_numbers(1, 1, 'norm', param_errors.cutoff) * param_errors.x_error_pulse;
            param.offset_x = param.offset_x_syst + pbp * error_x_pulse;

            error_xl_pulse = lnls_generate_random_numbers(1, 1, 'norm', param_errors.cutoff) * param_errors.xl_error_pulse;
            param.offset_xl =  param.offset_xl_syst + pbp * error_xl_pulse;

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

        r_particles = sirius_commis.injection.si.single_pulse(machine, param, n_part, point);

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
        else
            if length(point) > 1
                for i = 1:length(point)
                    [erro_bpm(:, j, i), int_bpm(i)] = sirius_commis.common.bpm_error_inten(squeeze(r_particles.r_point(:, :,i)), n_part, param_errors.sigma_bpm);
                end
            else
                [erro_bpm(:, j), int_bpm] = sirius_commis.common.bpm_error_inten(r_particles.r_point, n_part, param_errors.sigma_bpm);
            end
        end

        r_xy = squeeze(r_particles.r_track([1,3], :, :)); %(x,y) position only
        
        if n_part == 1
            r_xy = reshape(r_xy, 2, 1, point(end));
        end
        
        r_track_pulse(j, :, :) =  squeeze(nanmean(r_xy, 2));  %(x, y) position for the centroid and for each pulse
        eff(j) = sirius_commis.common.calc_eff(n_part, squeeze(r_xy(:, :, point(end)))); %efficiency of particles reaching the required point
       
        r_end(j, :, :, :) = r_particles.r_track(:, :, end); % 6D position at the last element (used to simulate multiple turns)

        

        if flag_plot && ~flag_shape
            plot_si_turn(machine, r_xy);
        end

        if ~mod(j, 10)
            fprintf('. %i pulses \n', j);
        else
            fprintf('.');
        end
        
        if flag_shape
             sirius_commis.scatplot(1e3 * squeeze(r_track_pulse(j, 1, :)), 1e3 * squeeze(r_track_pulse(j, 2, :)), 'circles', 2e-2, 1e3, 5, 1, 4);
        end
    end
    
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

    % fprintf('AVERAGE EFFICIENCY :  %g %% \n', mean(eff)*100);

    if ~flag_diag
        offset = getcellstruct(machine, 'Offsets', bpm);
        if length(point) > 1
            r_bpm_inj = zeros(n_pulse, 2, length(point));
            for i = 1:length(point)
                r_bpm_inj(:, :, i) = squeeze(r_track_pulse(:, :, point(i)));
                r_bpm_inj(:, :, i) = r_bpm_inj(:, :, i) + pbp * squeeze(erro_bpm(:, :, i))';

            % The comparison with vacuum chamber in this case is screen-like.
                r_bpm_inj2(:, i) = squeeze(nanmean(r_bpm_inj(:, :, i), 1));
                r_bpm_inj2(:, i) = r_bpm_inj2(:, i) - offset{bpm == point(i)}';
                r_bpm_inj2(:, i) = sirius_commis.common.compares_vchamb(machine, r_bpm_inj2(:, i)', point(i), 'screen');
            end
            clear r_point
            r_point = r_bpm_inj2;
        else
            r_point = squeeze(r_track_pulse(:, :, point));
            r_point = r_point + pbp * squeeze(erro_bpm)';

            % The comparison with vacuum chamber in this case is screen-like.
            r_point = squeeze(nanmean(r_point, 1));
            r_point = r_point - offset{bpm == point};
            r_point = sirius_commis.common.compares_vchamb(machine, r_point, point, 'screen');
        end
    end

    if flag_diag
        r_bpm_pulse = r_bpm_pulse + pbp * sigma_bpm;
        if n_pulse > 1
            r_bpm_mean = squeeze(nanmean(r_bpm_pulse, 1));
        else
            r_bpm_mean = squeeze(r_bpm_pulse);
        end

        offset = getcellstruct(machine, 'Offsets', bpm);
        offset = cell2mat(offset)';
        r_bpm_mean = r_bpm_mean -  offset;
        machine = lnls_set_kickangle(machine, 0, injkckr, 'x');
        % orbit = zeros(6, length(machine));
        r_bpm = sirius_commis.common.compares_vchamb(machine, r_bpm_mean, bpm, 'bpm');
        sirius_commis.common.plot_bpms(machine, orbit, r_bpm, int_bpm);
        r_particles_out.r_bpm = r_bpm;
        r_particles_out.sum_bpm = int_bpm;
    end

    r_particles_out.r_end = r_end;
    r_particles_out.r_point = r_point;
    r_particles_out.efficiency = eff;
end

function plot_si_turn(machine, r_final)
    VChamb = cell2mat(getcellstruct(machine, 'VChamber', 1:size(r_final, 3)))';
    s = findspos(machine, 1:size(r_final, 3));
    xx = squeeze(nanmean(r_final(1, :, :), 2));
    sxx = squeeze(nanstd(r_final(1, :, :), 0, 2));
    yy = squeeze(nanmean(r_final(2, :, :), 2));
    syy = squeeze(nanstd(r_final(2, :, :), 0, 2));
    gcf();
    ax1a = subplottight(2,1,1, 'vspace', 0.05);
    ax2a = subplottight(2,1,2, 'vspace', 0.05);
    mm = 1e3;
    hold(ax1a, 'off');
    plot(ax1a, s, mm*(xx+3*sxx)', 'b --');
    hold(ax1a, 'on');
    plot(ax1a, s, mm*(xx-3*sxx)', 'b --');
    plot(ax1a, s, mm*(xx)', '.-r', 'linewidth', 3);
    plot(ax1a, s, mm*VChamb(1,:),'k');
    plot(ax1a, s, -mm*VChamb(1,:),'k');
    grid(ax1a, 'on');
    ylim(ax1a, [-mm*VChamb(1,1), mm*VChamb(1,1)]);
    xlim(ax1a, [0, s(end)]);
    hold(ax2a, 'off');
    plot(ax2a, s, mm*(yy+3*syy)', 'r --');
    hold(ax2a, 'on');
    plot(ax2a, s, mm*(yy-3*syy)', 'r --');
    plot(ax2a, s, mm*(yy)', '.-b', 'linewidth', 3);
    plot(ax2a, s, mm*VChamb(2,:),'k');
    plot(ax2a, s, -mm*VChamb(2,:),'k');
    grid(ax2a, 'on');
%     plot(ax, s, orbit(1, :) * mm, '.-k', 'linewidth', 2);
%     plot(ax, s, orbit(3, :) * mm, '.-k', 'linewidth', 2);
    ylim(ax2a, [-mm*VChamb(2,1), mm*VChamb(2,1)]);
    xlim(ax2a, [0, s(end)]);
    drawnow;
end
