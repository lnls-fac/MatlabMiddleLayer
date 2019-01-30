function ft_data = correct_orbit_bpm_matrix(machine, param, param_errors, m_corr, n_part, n_pulse, n_sv, r_bpm, int_bpm)
% Increases the intensity of BPMs and adjusts the orbit by changing the
% correctors based on BPMs measurements with a matrix approach
%
% INPUTS:
%  - machine: booster ring model with errors
%  - param: cell of structs with adjusted injection parameters for each
% machine
%  - m_corr: first turn trajectory corrector matrix calculate from transfer
%  matrix as a response matrix
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
m_corr_x = m_corr(1:size(bpm, 1), 1:size(ch, 1));
m_corr_y = m_corr(size(bpm, 1)+1:end, size(ch, 1)+1:end);

theta_x = lnls_get_kickangle(machine, ch, 'x')';
theta_y = lnls_get_kickangle(machine, cv, 'y')';
gr_mach_x = zeros(length(ch), 1);
gr_mach_y = zeros(length(cv), 1);
first_cod = false;
cod_data = [];

[param, cod_data, first_cod] = checknan(machine, param, fam, first_cod, cod_data);
ft_data.firstcod = cod_data;

if ~exist('r_bpm', 'var') && ~exist('int_bpm', 'var')
    [~, ~, ~, r_bpm, int_bpm] = sirius_commis.injection.si.multiple_pulse(machine, param, param_errors, n_part, n_pulse, length(machine), 'on', 'diag');
end

rms_orbit_x_bpm_old = nanstd(r_bpm(1,:));
rms_orbit_y_bpm_old = nanstd(r_bpm(2,:));
corr_lim = 300e-6;

eff_lim = 1;
n_cor = 1;
n_fcod = true;

rms_orbit_x_bpm_new = rms_orbit_x_bpm_old;
rms_orbit_y_bpm_new = rms_orbit_y_bpm_old;
inc_x = true; inc_y = true;

while int_bpm(end) < eff_lim
    bpm_int_ok = bpm(int_bpm > 0.80);
    [~, ind_ok_bpm] = intersect(bpm, bpm_int_ok);
   
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
    
    [param, cod_data, first_cod] = checknan(machine, param, fam, first_cod, cod_data);
    ft_data.firstcod = cod_data;

    [~, ~, ~, r_bpm, int_bpm] = sirius_commis.injection.si.multiple_pulse(machine, param, param_errors, n_part, n_pulse, length(machine), 'on', 'diag');
    rms_orbit_x_bpm_new = nanstd(r_bpm(1,:)); rms_orbit_y_bpm_new = nanstd(r_bpm(2,:));
    
    if n_cor > 10
       n_sv = n_sv - 1;
       machine = lnls_set_kickangle(machine, zeros(length(ch), 1), ch, 'x');
       machine = lnls_set_kickangle(machine, zeros(length(cv), 1), cv, 'y');
       n_cor = 1;
       warning('Number of Singular Values reduced')
       if n_sv < 1
           error('Problems in Singular Values')
       end
    end
    n_cor = n_cor + 1;
end

kickx_ft = lnls_get_kickangle(machine, ch, 'x');
kicky_ft = lnls_get_kickangle(machine, cv, 'y');
orbit_ft = findorbit4(machine, 0, 1:length(machine));
r_bpm_ft = r_bpm;

[U, S, V] = svd(m_corr, 'econ');
S_inv = 1 ./ diag(S);
S_inv(isinf(S_inv)) = 0;
n_t = n_sv;
k = 1;
n_inc = 0;
stop_x = false; stop_y = false;
sv_change = false;

theta_x_i = theta_x;
theta_y_i = theta_y;

while inc_x || inc_y
    S_inv_var = S_inv;
    
    theta_x0 = lnls_get_kickangle(machine, ch, 'x')';
    theta_y0 = lnls_get_kickangle(machine, cv, 'y')';

    if ~sv_change
        if ~stop_x
            rms_orbit_x_bpm_old = rms_orbit_x_bpm_new;
        end
        if ~stop_y
            rms_orbit_y_bpm_old = rms_orbit_y_bpm_new;
        end
    end
    
    S_inv_var(n_t + 1:end) = 0;
    % Sx_inv(Sx_inv > 5 * Sx_inv(1)) = 0;
    S_inv_var = diag(S_inv_var);
    m_corr_inv = V * S_inv_var * U';
    
    m_corr_inv_x = m_corr_inv(1:size(ch, 1), 1:size(bpm, 1));
    m_corr_inv_y = m_corr_inv(size(ch)+1:end, size(bpm, 1)+1:end);
    
    if inc_x 
        x_bpm = squeeze(r_bpm(1, :));
        theta_x_f =  theta_x_i - m_corr_inv_x * x_bpm';
        over_kick_x = abs(theta_x_f) > corr_lim;
    
        if any(over_kick_x)
            warning('Horizontal corrector kick greater than maximum')
            gr_mach_x(over_kick_x) = 1;
            theta_x_f(over_kick_x) =  sign(theta_x_f(over_kick_x)) * corr_lim;
        end
        
        machine = lnls_set_kickangle(machine, theta_x_f, ch, 'x');
        fprintf('HORIZONTAL CORRECTION \n');
        
        theta_x_i = theta_x_f;
    end
    
    if inc_y
        y_bpm = squeeze(r_bpm(2, :));
        theta_y_f = theta_y_i - m_corr_inv_y * y_bpm';
        over_kick_y = abs(theta_y_f) > corr_lim;
    
        if any(over_kick_y)
            warning('Vertical corrector kick greater than maximum')
            gr_mach_y(over_kick_y) = 1;
            theta_y_f(over_kick_y) =  sign(theta_y_f(over_kick_y)) * corr_lim;
        end
        
        machine = lnls_set_kickangle(machine, theta_y_f, cv, 'y');
        fprintf('VERTICAL CORRECTION \n');
        
        theta_y_i = theta_y_f;
    end
    
    [param, cod_data, first_cod] = checknan(machine, param, fam, first_cod, cod_data);
    ft_data.firstcod = cod_data;
    
    % param.orbit = findorbit4(machine, 0, 1:length(machine));
    ft_data.finalcod.bpm_pos = r_bpm;

    [~, ~, ~, r_bpm, int_bpm] = sirius_commis.injection.si.multiple_pulse(machine, param, param_errors, n_part, n_pulse, length(machine), 'on', 'diag');
    
    if int_bpm(end) < eff_lim
        machine = lnls_set_kickangle(machine, theta_x0, ch, 'x');
        machine = lnls_set_kickangle(machine, theta_y0, cv, 'y');
        [~, cod_data, ~] = checknan(machine, param, fam, first_cod, cod_data);
        ft_data.firstcod = cod_data;
        ft_data.machine = machine;
        ft_data.max_kick = [gr_mach_x; gr_mach_y];
        ft_data.n_svd = n_t;
        ft_data.ftcod.kickx = kickx_ft;
        ft_data.ftcod.kicky = kicky_ft;
        ft_data.ftcod.orbit = orbit_ft;
        rms_x = nanstd(orbit_ft(1, :));   rms_y = nanstd(orbit_ft(3, :));
        ft_data.ftcod.rms_x = rms_x;      ft_data.ftcod.rms_y = rms_y; 
        ft_data.ftcod.bpm_pos = r_bpm_ft;    
        return    
    end
    
    if first_cod && n_fcod
        cod_data.bpm_pos = r_bpm;
        ft_data.firstcod = cod_data;
        n_fcod = false;
    end
    
    rms_orbit_x_bpm_new = nanstd(r_bpm(1,:));
    rms_orbit_y_bpm_new = nanstd(r_bpm(2,:));
    
    if ~stop_x
        inc_x = rms_orbit_x_bpm_new < rms_orbit_x_bpm_old;
        if ~inc_x
            machine = lnls_set_kickangle(machine, theta_x0, ch, 'x');
            stop_x = true;
        end
    end
    
    if ~stop_y
        inc_y = rms_orbit_y_bpm_new < rms_orbit_y_bpm_old;
        if ~inc_y
            machine = lnls_set_kickangle(machine, theta_y0, cv, 'y');
            stop_y = true;
        end
    end
    
    if ~inc_x && ~inc_y
        if n_inc == 0
            % theta_x = theta_x + m_corr_inv_x * x_bpm';
            % theta_y = theta_y + m_corr_inv_y * y_bpm';
            % machine = lnls_set_kickangle(machine, theta_x, ch, 'x');
            % machine = lnls_set_kickangle(machine, theta_y, cv, 'y');
            [~, cod_data, ~] = checknan(machine, param, fam, first_cod, cod_data);
            ft_data.firstcod = cod_data;
            ft_data.machine = machine;
            ft_data.max_kick = [gr_mach_x; gr_mach_y];
            ft_data.n_svd = n_t;
            ft_data.ftcod.kickx = kickx_ft;
            ft_data.ftcod.kicky = kicky_ft;
            ft_data.ftcod.orbit = orbit_ft;
            rms_x = nanstd(orbit_ft(1, :));   rms_y = nanstd(orbit_ft(3, :));
            ft_data.ftcod.rms_x = rms_x;      ft_data.ftcod.rms_y = rms_y; 
            ft_data.ftcod.bpm_pos = r_bpm_ft;
            return
        else
            n_t = n_sv + k * 5;
            inc_x = true; inc_y = true;
            stop_x = false; stop_y = false;
            k = k+1;
            n_inc = 0;
            sv_change = true;
            fprintf('Number of Singular Values: %i \n', n_t);
            continue
        end
    end
    n_inc = n_inc + 1;
    sv_change = false;
end
end

function [param, cod_data, first_cod] = checknan(machine, param, fam, first_cod, cod_data)
        if first_cod
            orbit = findorbit4(machine, 0, 1:length(machine));
            param.orbit = orbit;
            return
        end
        orbit = findorbit4(machine, 0, 1:length(machine));
        param.orbit = orbit;
        cod_nan = sum(isnan(orbit(:))) > 0;
        if ~cod_nan
            theta_x = lnls_get_kickangle(machine, fam.CH.ATIndex, 'x')';
            theta_y = lnls_get_kickangle(machine, fam.CV.ATIndex, 'y')';
            rms_x = nanstd(orbit(1, :));   rms_y = nanstd(orbit(3, :));
            cod_data.kickx = theta_x;   cod_data.kicky = theta_y;
            cod_data.rms_x = rms_x;     cod_data.rms_y = rms_y;
            cod_data.orbit = orbit;
            first_cod = true;
        end
end
        
