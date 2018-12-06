function [machine, r_bpm, gr_mach_x, gr_mach_y] = correct_orbit_bpm_matrix(machine, param, param_errors, MS_acc, n_part, n_pulse, n_sv, r_bpm, int_bpm)
% Increases the intensity of BPMs and adjusts the orbit by changing the
% correctors based on BPMs measurements with a matrix approach
%
% INPUTS:
%  - machine: booster ring model with errors
%  - param: cell of structs with adjusted injection parameters for each
% machine
%  - MS_acc: transfer matrix from the origin (InjSept) to all the elements
%  of machine ([~, MS] = findm44())
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

% sirius_commis.common.initializations();

fam = sirius_si_family_data(machine);
ch = fam.CH.ATIndex;
cv = fam.CV.ATIndex;
bpm = fam.BPM.ATIndex;
m_corr_x = zeros(length(bpm), length(ch));
m_corr_y = zeros(length(bpm), length(cv));

theta_x = zeros(length(ch), 1);
theta_y = zeros(length(cv), 1);
gr_mach_x = zeros(length(ch), 1);
gr_mach_y = zeros(length(cv), 1);

if ~exist('r_bpm', 'var') && ~exist('int_bpm', 'var')
    [~, ~, ~, r_bpm, int_bpm] = sirius_commis.injection.si.multiple_pulse(machine, param, param_errors, n_part, n_pulse, length(machine), 'on', 'diag');
end

M_bpms_x = MS_acc(1:2, 1:2, bpm);
M_bpms_y = MS_acc(3:4, 3:4, bpm);

rms_orbit_x_bpm_old = nanstd(r_bpm(1,:));
rms_orbit_y_bpm_old = nanstd(r_bpm(2,:));

 corr_lim = 310e-6;

for j = 1:length(ch)
    ind_bpms_ch = bpm > ch(j);
    first = find(ind_bpms_ch);

    if ~isempty(first)
        first = first(1);
        trecho = first:length(bpm);
        M_ch = MS_acc(1:2, 1:2, ch(j));
        for i=1:length(trecho)
            M_x = M_bpms_x(:, :, trecho(i)) / M_ch; 
            m_corr_x(trecho(i), j) = squeeze(M_x(1, 2, :));
        end
    end

    ind_bpms_cv = bpm > cv(j);
    first = find(ind_bpms_cv);

    if ~isempty(first)
        first = first(1);
        trecho = first:length(bpm);
        M_cv = MS_acc(3:4, 3:4, cv(j));
        for i=1:length(trecho)
            M_y = M_bpms_y(:, :, trecho(i)) / M_cv; 
            m_corr_y(trecho(i), j) = squeeze(M_y(1, 2, :));
        end
    end

end

eff_lim = 1;
% if n_pulse <= 10
   % pos_lim = param_errors.sigma_bpm / eff_lim / sqrt(n_pulse);
% else
 %   pos_lim = 1e-3;
%end
n_cor = 1;

rms_orbit_x_bpm_new = rms_orbit_x_bpm_old;
rms_orbit_y_bpm_new = rms_orbit_y_bpm_old;
inc_x = true; inc_y = true;
stop_x = false; stop_y = false;

while int_bpm(end) < eff_lim  ||  inc_x || inc_y
    bpm_int_ok = bpm(int_bpm > 0.80);
    [~, ind_ok_bpm] = intersect(bpm, bpm_int_ok);
    
    rms_orbit_x_bpm_old = rms_orbit_x_bpm_new;
    rms_orbit_y_bpm_old = rms_orbit_y_bpm_new;

    m_corr_x_ok = m_corr_x(ind_ok_bpm, :);
    [Ux, Sx, Vx] = svd(m_corr_x_ok, 'econ');
    Sx_inv = 1 ./ diag(Sx);
    Sx_inv(isinf(Sx_inv)) = 0;
    Sx_inv(n_sv+1:end) = 0;
    % Sx_inv(Sx_inv > 5 * Sx_inv(1)) = 0;
    Sx_inv = diag(Sx_inv);
    m_corr_inv_x = Vx * Sx_inv * Ux';    

    x_bpm = squeeze(r_bpm(1, ind_ok_bpm));
    theta_x =  theta_x - m_corr_inv_x * x_bpm';
    over_kick_x = abs(theta_x) > corr_lim;
    
    if any(over_kick_x)
        warning('Horizontal corrector kick greater than maximum')
        gr_mach_x(over_kick_x) = 1;
        theta_x(over_kick_x) =  sign(theta_x(over_kick_x)) * corr_lim;
    end

    m_corr_y_ok = m_corr_y(ind_ok_bpm, :);
    [Uy, Sy, Vy] = svd(m_corr_y_ok, 'econ');
    Sy_inv = 1 ./ diag(Sy);
    Sy_inv(isinf(Sy_inv)) = 0;
    Sy_inv(n_sv+1:end) = 0;
    % Sy_inv(Sy_inv > 5 * Sy_inv(1)) = 0;
    Sy_inv = diag(Sy_inv);
    m_corr_inv_y = Vy * Sy_inv * Uy';

    y_bpm = squeeze(r_bpm(2, ind_ok_bpm));
    theta_y = theta_y - m_corr_inv_y * y_bpm';
    over_kick_y = abs(theta_y) > corr_lim;
    
    if any(over_kick_y)
        warning('Vertical corrector kick greater than maximum')
        gr_mach_y(over_kick_y) = 1;
        theta_x(over_kick_y) =  sign(theta_x(over_kick_y)) * corr_lim;
    end
    
    if inc_x 
        machine = lnls_set_kickangle(machine, theta_x, ch, 'x');
    end
    
    if inc_y
        machine = lnls_set_kickangle(machine, theta_y, cv, 'y');
    end
    
    param.orbit = findorbit4(machine, 0, 1:length(machine));

    [~, ~, ~, r_bpm, int_bpm] = sirius_commis.injection.si.multiple_pulse(machine, param, param_errors, n_part, n_pulse, length(machine), 'on', 'diag');
    rms_orbit_x_bpm_new = nanstd(r_bpm(1,:));
    rms_orbit_y_bpm_new = nanstd(r_bpm(2,:));
    
    if int_bpm(end) >= eff_lim
        n_cor = 1;
        if ~stop_x
            inc_x = rms_orbit_x_bpm_new < rms_orbit_x_bpm_old;
            if ~inc_x
                theta_x = theta_x + m_corr_inv_x * x_bpm';
                machine = lnls_set_kickangle(machine, theta_x, ch, 'x');
                stop_x = true;
            end
        end
        if ~stop_y
            inc_y = rms_orbit_y_bpm_new < rms_orbit_y_bpm_old;
            if ~inc_y  
                theta_y = theta_y + m_corr_inv_y * y_bpm';
                machine = lnls_set_kickangle(machine, theta_y, cv, 'y');
                stop_y = true;
            end
        end
    elseif int_bpm(end) < eff_lim && n_cor > 5
       n_sv = n_sv - 5;
       machine = lnls_set_kickangle(machine, zeros(length(ch), 1), ch, 'x');
       machine = lnls_set_kickangle(machine, zeros(length(cv), 1), cv, 'y');
       n_cor = 1;
       warning('Number of Singular Values reduced')
       if n_sv == 0
           error('Problems in Singular Values')
       end
    end
    n_cor = n_cor + 1;
end
end
% [rms_orbit_bpm, max_orbit_bpm] = calc_rms(r_bpm);

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


