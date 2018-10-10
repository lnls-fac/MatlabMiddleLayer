function [machine, theta_x, theta_y, rms_orbit_bpm, max_orbit_bpm] = correct_orbit_bpm_respm(machine, param, respm, n_part, n_pulse)
% Increases the intensity of BPMs and adjusts the orbit by changing the
% correctors based on BPMs measurements with the response matrix
%
% INPUTS:
%  - machine: booster ring model with errors
%  - param: cell of structs with adjusted injection parameters for each
% machine
%  - respm: response matrix from calc_respm_cod();
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
% Version 1 - Murilo B. Alves - October 8th, 2018

% initializations();

fam = sirius_bo_family_data(machine);
ch = fam.CH.ATIndex;
cv = fam.CV.ATIndex;
bpm = fam.BPM.ATIndex;

m_corr_x = respm.mxx;
m_corr_y = respm.myy;

theta_x = zeros(length(ch), 1);
theta_y = zeros(length(cv), 1);

[~, ~, ~, ~, r_bpm, int_bpm] = sirius_commis.injection.bo.multiple_pulse(machine, param, n_part, n_pulse, length(machine), 'on', 'diag');

rms_orbit_x_bpm = nanstd(r_bpm(1,:));
rms_orbit_y_bpm = nanstd(r_bpm(2,:));

eff_lim = 0.95;
pos_lim = param.sigma_bpm / eff_lim;


for j = 1:length(ch)
    m_corr_x(bpm < ch(j), j) = 0;
    m_corr_y(bpm < cv(j), j) = 0;
end

while mean(int_bpm) < eff_lim ||  rms_orbit_x_bpm > pos_lim || rms_orbit_y_bpm > pos_lim;
    bpm_int_ok = bpm(int_bpm > 0.80);
    [~, ind_ok_bpm] = intersect(bpm, bpm_int_ok);
    
    m_corr_x_ok = m_corr_x(ind_ok_bpm, :);
    m_corr_x_ok(:, ch > bpm_int_ok(end)) = 0;
    [Ux, Sx, Vx] = svd(m_corr_x_ok, 'econ');
    Sx_inv = 1 ./ diag(Sx);
    Sx_inv(isinf(Sx_inv)) = 0;
    Sx_inv = diag(Sx_inv);
    m_corr_inv_x = Vx * Sx_inv * Ux';    

    x_bpm = squeeze(r_bpm(1, ind_ok_bpm));
    theta_x =  theta_x - m_corr_inv_x * x_bpm';

    m_corr_y_ok = m_corr_y(ind_ok_bpm, :);
    m_corr_y_ok(:, cv > bpm_int_ok(end)) = 0;
    [Uy, Sy, Vy] = svd(m_corr_y_ok, 'econ');
    Sy_inv = 1 ./ diag(Sy);
    Sy_inv(isinf(Sy_inv)) = 0;
    Sy_inv = diag(Sy_inv);
    m_corr_inv_y = Vy * Sy_inv * Uy';

    y_bpm = squeeze(r_bpm(2, ind_ok_bpm));
    theta_y = theta_y - m_corr_inv_y * y_bpm';

    machine = lnls_set_kickangle(machine, theta_x, ch, 'x');
    machine = lnls_set_kickangle(machine, theta_y, cv, 'y');
    
    param.orbit = findorbit4(machine, 0, 1:length(machine));
    
    [~, ~, ~, ~, r_bpm, int_bpm] = sirius_commis.injection.bo.multiple_pulse(machine, param, n_part, n_pulse, length(machine), 'on', 'diag');
    rms_orbit_x_bpm = nanstd(r_bpm(1,:));
    rms_orbit_y_bpm = nanstd(r_bpm(2,:));
end
    [max_orbit_x_bpm, i_max_x] = nanmax(abs(r_bpm(1,:)));
    max_orbit_x_bpm = sign(r_bpm(1, i_max_x)) * max_orbit_x_bpm;
    [max_orbit_y_bpm, i_max_y] = nanmax(abs(r_bpm(2,:)));
    max_orbit_y_bpm = sign(r_bpm(2, i_max_y)) * max_orbit_y_bpm;
    rms_orbit_bpm = [rms_orbit_x_bpm, rms_orbit_y_bpm];
    max_orbit_bpm = [max_orbit_x_bpm, max_orbit_y_bpm];
    
end
