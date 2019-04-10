function ft_data = closes_orbit_from_traj(machine, param, param_errors, m_corr, n_part, n_pulse, n_sv, n_turns)
% Increases the intensity of BPMs and adjusts the orbit by changing the
% correctors based on BPMs measurements with a matrix approach
%
% INPUTS:
%  - machine: booster ring model with errors
%  - param: cell of structs with adjusted injection parameters for each
% machine
%  - param_errors: struct with injection parameters errors and
%  measurements errors
%  - m_corr: first turn trajectory corrector matrix with 2 * #BPMs rows
%  and #CH + #CV + 1 columns
%  - n_part: number of particles
%  - n_pulse: number of pulses to average
%  - n_sv: number of singular values to use in correction
%  - r_bpm: BPM position measurements (2 x #BPMs) from previous first turn
%  tracking
%  - int_bpm: BPM sum signal (1 x #BPMs) from previous first turn tracking
%
% OUTPUTS:
%  - ft_data: first turn data struct with the following properties:
%  * first_cod: First COD solution obtained
%  * final_cod: Last COD solution when algorithm has converged
%  * machine: booster ring lattice with corrector kicks applied
%  * max_kick: vector with 0 and 1 where 1 means that the kick
%  reached the maximum value for the specific corrector
%  * n_svd: number of singular values when the algorithm converge
%  * ft_cod: data with kicks setting to obtain first COD solution, its
%  values and statistics

% Version 1 - Murilo B. Alves - October, 2018
% Version 2 - Murilo B. Alves - March, 2019

sirius_commis.common.initializations();

fam = sirius_bo_family_data(machine);
ch = fam.CH.ATIndex;
cv = fam.CV.ATIndex;
bpm = fam.BPM.ATIndex;
% m_corr_x = m_corr(1:size(bpm, 1), 1:size(ch, 1));
% m_corr_y = m_corr(size(bpm, 1)+1:end, size(ch, 1)+1:end);

theta_x = lnls_get_kickangle(machine, ch, 'x')';
theta_y = lnls_get_kickangle(machine, cv, 'y')';
gr_mach_x = zeros(length(ch), 1);
gr_mach_y = zeros(length(cv), 1);
first_cod = false;
cod_data = [];
n_bpm = length(bpm);
n_bpm_turns = n_bpm * n_turns;
bpm_idx = [1:1:n_bpm_turns];
rxy_bpm = zeros(1, n_bpm_turns);

[count_turns, ~, ~,  ~, f_merit, ~, ~, r_bpm, int_bpm] = sirius_commis.first_turns.bo.multiple_pulse_turn(machine, 1, param, param_errors, n_part, n_pulse, n_turns);

% [~, ~, ~, ~, r_bpm, int_bpm] = sirius_commis.injection.bo.multiple_pulse(machine, param, param_errors, n_part, n_pulse, length(machine), 'on', 'diag');

% rms_orbit_x_bpm_old = nanstd(r_bpm(1,:));
% rms_orbit_y_bpm_old = nanstd(r_bpm(2,:));
corr_lim = 300e-6;

eff_lim = 0.50;

n_cor = 1;
n_fcod = true;

% rms_orbit_x_bpm_new = rms_orbit_x_bpm_old;
% rms_orbit_y_bpm_new = rms_orbit_y_bpm_old;
inc_x = true; inc_y = true;
ft_data.error = false;

int_bpm = squeeze(int_bpm);
int_bpm = reshape(int_bpm', n_bpm_turns, 1);
% lost = find(int_bpm > eff_lim);

rx = squeeze(r_bpm(:, 1, :));
ry = squeeze(r_bpm(:, 2, :));

rxx = reshape(rx', n_bpm_turns, 1);
ryy = reshape(ry', n_bpm_turns, 1);

ref_orbitx = repmat(rxx(1:n_bpm), n_turns, 1);
ref_orbity = repmat(ryy(1:n_bpm), n_turns, 1);
ref_orbit = [ref_orbitx; ref_orbity];

while count_turns < n_turns %int_bpm(end) < eff_lim
    
    % bpm_int_ok = bpm(int_bpm > 0.80);
    % [~, ind_ok_bpm] = intersect(bpm, bpm_int_ok);
    
    % bpm_select = zeros(length(bpm), 1);
    % bpm_select(ind_ok_bpm) = 1;
    %{
    if sum(bpm_select) == 1
       warning('Only 1 BPM with good sum signal!')
       ft_data.machine = machine;
       ft_data.error = true;
       ft_data.n_svd = n_sv;
       return
    end
    %}
    % m_corr_ok = m_corr([ind_ok_bpm; length(bpm) + ind_ok_bpm], :);
    
    int_bpm = squeeze(int_bpm);
    int_bpm = reshape(int_bpm', n_bpm_turns, 1);
    % lost = find(int_bpm > eff_lim);

    rx = squeeze(r_bpm(:, 1, :));
    ry = squeeze(r_bpm(:, 2, :));

    rxx = reshape(rx', n_bpm_turns, 1);
    ryy = reshape(ry', n_bpm_turns, 1);

    ref_orbitx = repmat(rxx(1:n_bpm), n_turns, 1);
    ref_orbity = repmat(ryy(1:n_bpm), n_turns, 1);
    % ref_orbit = [ref_orbitx; ref_orbity];

    rxx(int_bpm < eff_lim) = 0;
    ryy(int_bpm < eff_lim) = 0;
    r_bpm_turn = [rxx; ryy];

    [U, S, V] = svd(m_corr, 'econ');
    S_inv = 1 ./ diag(S);
    S_inv(isinf(S_inv)) = 0;
    S_inv(n_sv+1:end) = 0;
    S_inv = diag(S_inv);
    m_corr_inv = V * S_inv * U';
    % x_bpm = squeeze(r_bpm(1, ind_ok_bpm));
    % y_bpm = squeeze(r_bpm(2, ind_ok_bpm));
    % new_r_bpm = [x_bpm, y_bpm];
    
    if count_turns == n_turns
        ref_orbit = 0.*ref_orbit;
        % n_sv = n_sv + 5;
        % ref_orbit = [ref_orbitx; ref_orbity];
    end
    delta_kicks = m_corr_inv * (ref_orbit - r_bpm_turn);
    kicks = [theta_x; theta_y; 0] + delta_kicks;
    theta_x = kicks(1:length(ch));
    theta_y = kicks(length(ch)+1:end-1);
        
    over_kick_x = abs(theta_x) > corr_lim;
    if any(over_kick_x)
        warning('Horizontal corrector kick greater than maximum')
        gr_mach_x(over_kick_x) = 1;
        theta_x(over_kick_x) =  sign(theta_x(over_kick_x)) * corr_lim;
    end
    
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
    
    
    [count_turns, ~, ~,  ~, f_merit, ~, ~, r_bpm, int_bpm] = sirius_commis.first_turns.bo.multiple_pulse_turn(machine, 1, param, param_errors, n_part, n_pulse, n_turns);


    % [~, ~, ~, ~, r_bpm, int_bpm] = sirius_commis.injection.bo.multiple_pulse(machine, param, param_errors, n_part, n_pulse, length(machine), 'on', 'diag');
    % rms_orbit_x_bpm_new = nanstd(r_bpm(1,:)); rms_orbit_y_bpm_new = nanstd(r_bpm(2,:));
    
    if n_cor > 10
       n_sv = n_sv - 1;
       machine = lnls_set_kickangle(machine, zeros(length(ch), 1), ch, 'x');
       machine = lnls_set_kickangle(machine, zeros(length(cv), 1), cv, 'y');
       n_cor = 1;
       warning('Number of Singular Values reduced')
       if n_sv <= 1
           warning('Problems in Singular Values')
           ft_data.machine = machine;
           ft_data.error = true;
           ft_data.n_svd = n_sv;
           return
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
    S_inv_var = diag(S_inv_var);
    m_corr_inv = V * S_inv_var * U';
    x_bpm = squeeze(r_bpm(1, :));
    y_bpm = squeeze(r_bpm(2, :));
    new_r_bpm = [x_bpm, y_bpm];
    kicks = [theta_x_i; theta_y_i; 0] - m_corr_inv * new_r_bpm';
    
    if inc_x 
        % x_bpm = squeeze(r_bpm(1, :));
        % theta_x_f =  theta_x_i - m_corr_inv_x * x_bpm';
        theta_x_f = kicks(1:length(ch));
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
        % y_bpm = squeeze(r_bpm(2, :));
        % theta_y_f = theta_y_i - m_corr_inv_y * y_bpm';
        theta_y_f = kicks(length(ch)+1:end-1);
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
    
    param.orbit = findorbit4(machine, 0, 1:length(machine));
    ft_data.finalcod.bpm_pos = r_bpm;

    [~, ~, ~, ~, r_bpm, int_bpm] = sirius_commis.injection.bo.multiple_pulse(machine, param, param_errors, n_part, n_pulse, length(machine), 'on', 'diag');
    
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
        