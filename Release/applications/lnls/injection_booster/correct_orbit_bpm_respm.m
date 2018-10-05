function [machine, theta_x, theta_y, rms_orbit_bpm, max_orbit_bpm] = correct_orbit_bpm_respm(machine, param, respm, n_part, n_turns)
% Increases the intensity of BPMs and adjusts the orbit by changing the
% correctors based on BPMs measurements with a matrix approach
%
% INPUTS:
%  - machine: booster ring model with errors
%  - param: cell of structs with adjusted injection parameters for each
% machine
%  - MS_acc: transfer matrix from the origin (InjSept) to all the elements
%  of machine ([~, MS] = find44())
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

initializations();

fam = sirius_bo_family_data(machine);
ch = fam.CH.ATIndex;
cv = fam.CV.ATIndex;
bpm = fam.BPM.ATIndex;

m_corr_x = respm.mxx;
m_corr_y = respm.myy;

theta_x = zeros(length(ch), 1);
theta_y = zeros(length(cv), 1);
RBPM = zeros(n_turns, 2, 50);
INTBPM = zeros(n_turns, 1, 50);

[~, ~, r_bpm, int_bpm, r_init] = booster_turns(machine, 1, param, n_part, n_turns);

% rms_orbit_x_bpm = nanstd(r_bpm(1,:));
% rms_orbit_y_bpm = nanstd(r_bpm(2,:));
% 
% eff_lim = 0.95;
% pos_lim = 1e-3; %param.sigma_bpm / eff_lim;

% while mean(int_bpm) < eff_lim ||  rms_orbit_x_bpm > pos_lim || rms_orbit_y_bpm > pos_lim;
    bpm_int_ok = bpm(int_bpm > 0.80);
    [~, ind_ok_bpm] = intersect(bpm, bpm_int_ok);

    m_corr_x_ok = m_corr_x(ind_ok_bpm, :);
    [Ux, Sx, Vx] = svd(m_corr_x_ok, 'econ');
    Sx_inv = 1 ./ diag(Sx);
    Sx_inv(isinf(Sx_inv)) = 0;
    Sx_inv = diag(Sx_inv);
    m_corr_inv_x = Vx * Sx_inv * Ux';    

    x_bpm = squeeze(r_bpm(1, ind_ok_bpm));
    theta_x =  theta_x - m_corr_inv_x * x_bpm';

    m_corr_y_ok = m_corr_y(ind_ok_bpm, :);
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
    
    fprintf('========================= \n')
    fprintf('ORBIT CORRECTION \n')
    fprintf('========================= \n')
    for i = 1:n_turns
        [r_init, ~, eff, RBPM(i, :, :), ~] = single_turn(machine, n_part, r_init, i+n_turns, 'bpm', param);
        if eff < 0.50
            break
        end
    end
    r_bpm = squeeze(mean(RBPM, 1));    
    rms_orbit_x_bpm = nanstd(r_bpm(1,:));
    rms_orbit_y_bpm = nanstd(r_bpm(2,:));
% end
    [max_orbit_x_bpm, i_max_x] = nanmax(abs(r_bpm(1,:)));
    max_orbit_x_bpm = sign(r_bpm(1, i_max_x)) * max_orbit_x_bpm;
    [max_orbit_y_bpm, i_max_y] = nanmax(abs(r_bpm(2,:)));
    max_orbit_y_bpm = sign(r_bpm(2, i_max_y)) * max_orbit_y_bpm;
    rms_orbit_bpm = [rms_orbit_x_bpm, rms_orbit_y_bpm];
    max_orbit_bpm = [max_orbit_x_bpm, max_orbit_y_bpm];
end

function [r_init, r_out, eff, r_bpm, int_bpm] = single_turn(machine, n_part, r_init, turn_n, bpm, param)
    if(exist('bpm','var'))
        if(strcmp(bpm,'bpm'))
            flag_bpm = true;
        end
    elseif(~exist('bpm','var'))
            flag_bpm = false;
    end

    if turn_n ~= 2
        r_out = linepass(machine, r_init, 1:length(machine), 'reuse');
    else
        r_out = linepass(machine, r_init, 1:length(machine));
    end
   
    r_out = reshape(r_out, 6, length(r_init(1,:)), length(machine));        
    r_out_xy = compares_vchamb(machine, r_out([1,3], :, :), 1:length(machine), false);
    r_out([1,3], :, :) = r_out_xy;
    r_init = squeeze(r_out(:, :, end));
    loss_ind = ~isnan(r_out(1, :, length(machine)));
    r_init = r_init(:, loss_ind);
    eff = calc_eff(n_part, r_init);
    fprintf('Turn number %i , Efficiency %f %% \n', turn_n, eff*100);
    
    if flag_bpm
        sigma_bpm0 = param.sigma_bpm;
        bpm = findcells(machine, 'FamName', 'BPM');
        r_out_bpm = r_out_xy(:, :, bpm);
        [sigma_bpm, int_bpm] = bpm_error_inten(r_out_bpm, n_part, sigma_bpm0);
        r_diag_bpm = squeeze(nanmean(r_out_bpm, 2)) + sigma_bpm;
        r_bpm = compares_vchamb(machine, r_diag_bpm, bpm, 'bpm');
        plot_bpms(machine, param.orbit, r_bpm, int_bpm);
    end
end
