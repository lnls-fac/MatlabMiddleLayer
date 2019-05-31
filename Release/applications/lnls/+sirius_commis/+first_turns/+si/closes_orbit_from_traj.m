function ft_data = closes_orbit_from_traj(machine_in, n_mach, param, param_errors, m_corr, n_part, n_pulse, n_sv_in, n_turns)

sirius_commis.common.initializations();

if n_mach == 1
    machine_cell = {machine_in};
    param_cell = {param};
    % param_err_cell = {param_errors};
elseif n_mach > 1
    machine_cell = machine_in;
    param_cell = param;
    % param_err_cell = param_errors;
end

fam = sirius_si_family_data(machine_cell{1});
ch = fam.CH.ATIndex;
cv = fam.CV.ATIndex;
bpm = fam.BPM.ATIndex;
% m_corr_x = m_corr(1:size(bpm, 1), 1:size(ch, 1));
% m_corr_y = m_corr(size(bpm, 1)+1:end, size(ch, 1)+1:end);

for j = 1:n_mach
fprintf('=================================================\n');
fprintf('MACHINE NUMBER %i \n', j)
fprintf('=================================================\n');
machine = machine_cell{j};
param = param_cell{j};

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

[count_turns, ~, ~,  ~, f_merit, ~, ~, r_bpm, int_bpm] = sirius_commis.first_turns.si.multiple_pulse_turn(machine, 1, param, param_errors, n_part, n_pulse, n_turns);

% [~, ~, ~, ~, r_bpm, int_bpm] = sirius_commis.injection.bo.multiple_pulse(machine, param, param_errors, n_part, n_pulse, length(machine), 'on', 'diag');

% rms_orbit_x_bpm_old = nanstd(r_bpm(1,:));
% rms_orbit_y_bpm_old = nanstd(r_bpm(2,:));
corr_lim = 300e-6;

eff_lim = 0.01;

n_cor = 1;
n_sv = n_sv_in;
n_fcod = true;

% rms_orbit_x_bpm_new = rms_orbit_x_bpm_old;
% rms_orbit_y_bpm_new = rms_orbit_y_bpm_old;
% inc_x = true; inc_y = true;
% ft_data.error = false;

int_bpm = squeeze(int_bpm);
int_bpm = reshape(int_bpm', n_bpm_turns, 1);
n_bpm_select_old = sum(int_bpm > eff_lim);
% lost = find(int_bpm > eff_lim);

rx = squeeze(r_bpm(:, 1, :));
ry = squeeze(r_bpm(:, 2, :));

rxx = reshape(rx', n_bpm_turns, 1);
ryy = reshape(ry', n_bpm_turns, 1);

ref_orbitx = repmat(rxx(1:n_bpm), n_turns, 1);
ref_orbity = repmat(ryy(1:n_bpm), n_turns, 1);
ref_orbit = [ref_orbitx; ref_orbity];
n_bpm_select_new = n_bpm_select_old;
count_turns_old = count_turns;
count_turns_new = count_turns_old;
machine_best = machine;

while count_turns_new < n_turns %int_bpm(end) < eff_lim
    
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
    
    rxx(int_bpm < eff_lim) = 0;
    ryy(int_bpm < eff_lim) = 0;

    ref_orbitx = repmat(rxx(1:n_bpm), n_turns, 1);
    ref_orbity = repmat(ryy(1:n_bpm), n_turns, 1);
    
    ref_orbit = [ref_orbitx; ref_orbity];
    
    if n_bpm_select_new < n_bpm_select_old 
        kicks = [theta_x; theta_y; 0] - delta_kicks;
        theta_x = kicks(1:length(ch));
        theta_y = kicks(length(ch)+1:end-1);
        % n_sv = n_sv - 5;
        % machine = lnls_set_kickangle(machine, theta_x, ch, 'x');
        % machine = lnls_set_kickangle(machine, theta_y, cv, 'y');
    else
        n_bpm_select_old = n_bpm_select_new;
    end
    
    r_bpm_turn = [rxx; ryy];
    
    ref_orbit(r_bpm_turn == 0) = 0;

    [U, S, V] = svd(m_corr, 'econ');
    S_inv = 1 ./ diag(S);
    S_inv(isinf(S_inv)) = 0;
    if n_sv > 280
        n_sv = 280;
    elseif n_sv < 1
        n_sv = 1;
    end
    S_inv(n_sv+1:end) = 0;
    S_inv = diag(S_inv);
    m_corr_inv = V * S_inv * U';
    % x_bpm = squeeze(r_bpm(1, ind_ok_bpm));
    % y_bpm = squeeze(r_bpm(2, ind_ok_bpm));
    % new_r_bpm = [x_bpm, y_bpm];
    
    if true %count_turns_new < 1 || int_bpm(n_bpm) < eff_lim
        ref_orbit(:) = 0;
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
        theta_y(over_kick_y) =  sign(theta_y(over_kick_y)) * corr_lim;
    end
      
    % if inc_x 
        machine_best = lnls_set_kickangle(machine, theta_x, ch, 'x');
    % end
    
    % if inc_y
        machine_best = lnls_set_kickangle(machine_best, theta_y, cv, 'y');
    % end
    
    [param, cod_data, first_cod] = checknan(machine, param, fam, first_cod, cod_data);
    % ft_data.firstcod = cod_data;
    
    
    [count_turns_new, ~, ~,  ~, f_merit, ~, ~, r_bpm, int_bpm] = sirius_commis.first_turns.si.multiple_pulse_turn(machine_best, 1, param, param_errors, n_part, n_pulse, n_turns);
    
    int_bpm = squeeze(int_bpm);
    int_bpm = reshape(int_bpm', n_bpm_turns, 1);
    
    n_bpm_select_new = sum(int_bpm > eff_lim);
    
    if n_bpm_select_new >= n_bpm_select_old
       fprintf('Number of selected BPMs: %i >>> %i \n', n_bpm_select_old, n_bpm_select_new);
       fprintf('Number of Singular Values %i \n', n_sv);
       machine = machine_best;
       n_sv = n_sv + 5;
       if n_sv > 100
          corr_lim = 300e-6;
       end
    else
       n_sv = n_sv - 10;
    end


    % [~, ~, ~, ~, r_bpm, int_bpm] = sirius_commis.injection.bo.multiple_pulse(machine, param, param_errors, n_part, n_pulse, length(machine), 'on', 'diag');
    % rms_orbit_x_bpm_new = nanstd(r_bpm(1,:)); rms_orbit_y_bpm_new = nanstd(r_bpm(2,:));
    
    if n_cor > 50
       %n_sv = n_sv - 1;
       %machine = lnls_set_kickangle(machine, zeros(length(ch), 1), ch, 'x');
       %machine = lnls_set_kickangle(machine, zeros(length(cv), 1), cv, 'y');
       %n_cor = 1;
       %warning('Number of Singular Values reduced')
       break
       if n_sv <= 1
           warning('Problems in Singular Values')
           ft_data.machine = machine;
           ft_data.error = true;
           ft_data.n_svd = n_sv;
           return
       end
    end
    n_cor = n_cor + 1;
    % if mod(n_cor, 2) == 0
    n_sv = n_sv + 1;
    % end
end
    ft_data{j}.machine = machine;
    ft_data{j}.sing_values = n_sv;
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