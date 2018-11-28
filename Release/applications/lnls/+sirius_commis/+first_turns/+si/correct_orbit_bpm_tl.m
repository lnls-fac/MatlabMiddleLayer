function [machine, r_bpm, gr_mach_x, gr_mach_y] = correct_orbit_bpm_tl(machine, param, param_errors, MS_acc, n_part, n_pulse)
% Increases the intensity of BPMs and adjusts the orbit by changing the
% correctors based on BPMs measurements with a transport line approach
%
% INPUTS:
%  - machine: booster ring model with errors
%  - param: cell of structs with adjusted injection parameters for each
% machine
%  - MS_acc: transfer matrix from the origin (InjSept) to all the elements
%  of machine
%  - n_part: number of particles
%  - n_pulse: number of pulses to average
%
% OUTPUTS:
%  - machine: booster ring model with corrector setup adjusted for 1st turn
%  - theta_x: horizontal correctors forces
%  - theta_y: vertical correctors forces
%  - rms_orbit_bpm: standard deviation x and y of 1 turn measured by BPMs
%  - rms_orbit_bpm: maximum values x and y of 1 turn measured by BPMs
%
% Version 1 - Murilo B. Alves - October 4th, 2018

% sirius_commis.common.initializations()

fam = sirius_bo_family_data(machine);
ch = fam.CH.ATIndex;
cv = fam.CV.ATIndex;
bpm = fam.BPM.ATIndex;

theta_x = zeros(1, length(ch));
theta_y = zeros(1, length(cv));
gr_mach_x = zeros(length(ch), 1);
gr_mach_y = zeros(length(cv), 1);

corr_lim = 310e-6*10;
chute = 10e-6;
int_lim = 0.8;
pos_lim = param_errors.sigma_bpm / int_lim;

eff1 = sirius_commis.first_turns.bo.single_pulse_turn(machine, 1, param, param_errors, n_part);

[~, ~, ~, ~, r_bpm, int_bpm] = sirius_commis.injection.bo.multiple_pulse(machine, param, param_errors, n_part, n_pulse, length(machine), 'on', 'diag');

if eff1 > 0.95
    % [rms_orbit_bpm, max_orbit_bpm] = calc_rms(r_bpm);
    return
end

for i = 1:length(ch)
    fprintf('Corretoras %0.2i \n', i);
    ch_loop = ch(i);
    cv_loop = cv(i);

    bpm_x_ch = bpm( bpm > ch_loop);
    bpm_y = bpm( bpm > cv_loop);
    if length(bpm_y) > 1
        bpm_y = bpm_y(2);
    end

    int_bpm_x = (int_bpm(bpm == bpm_x_ch(1)) + int_bpm(bpm == bpm_x_ch(2)))/2;
    while int_bpm_x < int_lim
        theta_x(i) = theta_x(i) + chute;
        machine = lnls_set_kickangle(machine, theta_x(i), ch_loop, 'x');
        [~, ~, ~, ~, ~, int_bpm] = sirius_commis.injection.bo.multiple_pulse(machine, param, n_part, n_pulse, length(machine), 'on', 'diag');
        int_bpm_x = (int_bpm(bpm == bpm_x_ch(1)) + int_bpm(bpm == bpm_x_ch(2)))/2;
        if theta_x(i) > corr_lim - chute
            theta_x(i) = 0;
            while int_bpm_x < int_lim
                theta_x(i) = theta_x(i) - chute;
                machine = lnls_set_kickangle(machine, theta_x(i), ch_loop, 'x');
                [~, ~, ~, ~, ~, int_bpm] = sirius_commis.injection.bo.multiple_pulse(machine, param, n_part, n_pulse, length(machine), 'on', 'diag');
                int_bpm_x = (int_bpm(bpm == bpm_x_ch(1)) + int_bpm(bpm == bpm_x_ch(2)))/2;
                if abs(theta_x(i)) > corr_lim + chute
                    error('Serious problem on x plane')
                end
            end
        end
    end

    int_bpm_y = int_bpm(bpm == bpm_y);
    while int_bpm_y < int_lim
        theta_y(i) = theta_y(i) + chute;
        machine = lnls_set_kickangle(machine, theta_y(i), cv_loop, 'y');
        [~, ~, ~, ~, ~, int_bpm] = sirius_commis.injection.bo.multiple_pulse(machine, param, n_part, n_pulse, length(machine), 'on', 'diag');
        int_bpm_y = int_bpm(bpm == bpm_y);
        if theta_y(i) > corr_lim - chute
            theta_y(i) = 0;
            while int_bpm_y < int_lim
                theta_y(i) = theta_y(i) + chute;
                machine = lnls_set_kickangle(machine, theta_y(i), cv_loop, 'y');
                [~, ~, ~, ~, ~, int_bpm] = sirius_commis.injection.bo.multiple_pulse(machine, param, n_part, n_pulse, length(machine), 'on', 'diag');
                int_bpm_y = int_bpm(bpm == bpm_y);
                if abs(theta_y(i)) > corr_lim + chute
                    error('Serious problem on y plane')
                end
            end
        end
    end

    x_bpm = (r_bpm(1, bpm == bpm_x_ch(1)) + r_bpm(1, bpm == bpm_x_ch(2)))/2;
    y_bpm = r_bpm(2, bpm == bpm_y);

    M_bpm_x = MS_acc(:, :, bpm_x_ch(2));
    M_bpm_y = MS_acc(:, :, bpm_y);
    M_corr_x = MS_acc(:, :, ch_loop);
    M_corr_y = MS_acc(:, :, cv_loop);
    M_x = M_bpm_x / M_corr_x;
    M_y = M_bpm_y / M_corr_y;

    while abs(x_bpm) > pos_lim
        fprintf('Adjusting horizontal corrector %0.2i \n', i);
        theta_x(i) = theta_x(i) - x_bpm / M_x(1, 2);
        if abs(theta_x(i)) > corr_lim
            warning('Horizontal corrector kick greater than maximum')
            gr_mach_x(i) = 1;
            theta_x(i) = sign(theta_x(i)) * corr_lim;
        end
        machine = lnls_set_kickangle(machine, theta_x(i), ch_loop, 'x');
        param.orbit = findorbit4(machine, 0, bpm);
        [~, ~, ~, ~, r_bpm, ~] = sirius_commis.injection.bo.multiple_pulse(machine, param, n_part, n_pulse, length(machine), 'on', 'diag');
        fprintf('Horizontal corrector %i adjusted to %f urad \n', i, theta_x(i)*1e6);
        x_bpm = (r_bpm(1, bpm == bpm_x_ch(1)) + r_bpm(1, bpm == bpm_x_ch(2)))/2;
    end

    while abs(y_bpm) > pos_lim
        fprintf('Adjusting vertical corrector %0.2i \n', i);
        theta_y(i) = theta_y(i) - y_bpm / M_y(3, 4);
        if abs(theta_y(i)) > corr_lim
            warning('Vertical corrector kick greater than maximum')
            gr_mach_y(i) = 1;
            theta_y(i) = sign(theta_y(i)) * corr_lim;
        end
        machine = lnls_set_kickangle(machine, theta_y(i), cv_loop, 'y');
        param.orbit = findorbit4(machine, 0, bpm);
        [~, ~, ~, ~, r_bpm, ~] = sirius_commis.injection.bo.multiple_pulse(machine, param, n_part, n_pulse, length(machine), 'on', 'diag');
        fprintf('Vertical corrector %i adjusted to %f urad \n', i, theta_y(i)*1e6);
        y_bpm = r_bpm(2, bpm == bpm_y);
    end
end
% [rms_orbit_bpm, max_orbit_bpm] = calc_rms(r_bpm);
end

% function [rms_orbit_bpm, max_orbit_bpm] = calc_rms(r_bpm)
%     rms_orbit_x_bpm = nanstd(r_bpm(1,:));
%     rms_orbit_y_bpm = nanstd(r_bpm(2,:));
%     [max_orbit_x_bpm, i_max_x] = nanmax(abs(r_bpm(1,:)));
%     max_orbit_x_bpm = sign(r_bpm(1, i_max_x)) * max_orbit_x_bpm;
%     [max_orbit_y_bpm, i_max_y] = nanmax(abs(r_bpm(2,:)));
%     max_orbit_y_bpm = sign(r_bpm(2, i_max_y)) * max_orbit_y_bpm;
%     rms_orbit_bpm = [rms_orbit_x_bpm, rms_orbit_y_bpm];
%     max_orbit_bpm = [max_orbit_x_bpm, max_orbit_y_bpm];
% end
