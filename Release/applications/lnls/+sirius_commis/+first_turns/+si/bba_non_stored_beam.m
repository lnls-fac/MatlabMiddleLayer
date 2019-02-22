function bba_data = bba_non_stored_beam(machine, n_mach, param, param_errors, n_part, n_pulse, M_acc, n_points, plane, data_bpm, data_input)

    mili = 1e-3; micro = 1e-6;
    bpm_stop = 200;
    
    if n_mach == 1
        machine_cell = {machine};
        param_cell = {param};
    elseif n_mach > 1
        machine_cell = machine;
        param_cell = param;
    end
    
    off_bpm = cell(n_mach, 1);
    off_quad = cell(n_mach, 1);
    off_bba = cell(n_mach, 1);
    off_theta = cell(n_mach, 1);
    m_resp = cell(n_mach, 1);
    pos_bpm_i = cell(n_mach, 1); pos_bpm_f = cell(n_mach, 1);
    
    for j = 1:n_mach       
        fprintf('================================================\n');
        fprintf('MACHINE NUMBER # %i / %i \n', j, n_mach);
        fprintf('================================================\n');
    
        machine = machine_cell{j};
        param = param_cell{j};
        
        % [machine, ~, ~] = sirius_commis.first_turns.si.turn_off_sext(machine_nonlinear);
    
        fam = sirius_si_family_data(machine);
        ch = fam.CH.ATIndex;
        cv = fam.CV.ATIndex;
        bpm = fam.BPM.ATIndex;
        quads = fam.QN.ATIndex;
        ZERO_BPM = zeros(length(bpm), 1);
        % quads_skew = fam.QS.ATIndex;
        % all_quads = sort([quads; quads_skew]);
        % sexts = fam.SN.ATIndex;
        % sext_nocorr = setdiff(sexts, ch);
        % sext_nocorr = setdiff(sext_nocorr, cv);
        % machine = setcellstruct(machine, 'PassMethod', sext_nocorr, 'DriftPass');
        
        if (~exist('data_input', 'var'))
            factor = 1;
            flag_data_input = false;
            n_points_new = n_points;
        else
            theta_off = data_input.off_theta;
            theta_off = theta_off{j};
            thetax_off = theta_off(:, 1); thetay_off = theta_off(:, 2);
            factor = data_input.factor;
            m_resp_in = data_input.m_resp;
            m_resp_in = m_resp_in{j};
            flag_data_input = true;
            n_points_new = factor * n_points;
        end
        
        if ~mod(n_points_new, 2)
            n_points_new = n_points_new + 1;
        end
        
        theta_x0 = lnls_get_kickangle(machine, ch, 'x')';
        theta_y0 = lnls_get_kickangle(machine, cv, 'y')';
        off_bba_x = ZERO_BPM; off_bba_y = ZERO_BPM;
        off_bba_theta_x = ZERO_BPM; off_bba_theta_y = ZERO_BPM;
        bpm_ok_x = ZERO_BPM; bpm_ok_y = ZERO_BPM;
        m_resp_x = ZERO_BPM; m_resp_y = ZERO_BPM;
        mx = ZERO_BPM; my = ZERO_BPM;
        Ri_x = zeros(length(bpm), n_points_new, 2, length(bpm));
        Rf_x = zeros(length(bpm), n_points_new, 2, length(bpm));
        Ri_y = zeros(length(bpm), n_points_new, 2, length(bpm));
        Rf_y= zeros(length(bpm), n_points_new, 2, length(bpm));
        
        bba_ind = get_bba_ind(machine, bpm, quads);
        
        % INITIAL TEST: SET QUADRUPOLE MISALIGNMENT TO ZERO
        
        % offset_quadx2 = getcellstruct(machine, 'T2', bba_ind, 1, 1);
        % offset_quady2 = getcellstruct(machine, 'T2', bba_ind, 1, 3);
        % offset_quadx1 = getcellstruct(machine, 'T1', bba_ind, 1, 1);
        % offset_quady1 = getcellstruct(machine, 'T1', bba_ind, 1, 3);
        
        % machine = setcellstruct(machine, 'T1', bba_ind, offset_quadx1.*0 , 1, 1);
        % machine = setcellstruct(machine, 'T1', bba_ind, offset_quady1.*0 , 1, 3);
        % machine = setcellstruct(machine, 'T2', bba_ind, offset_quadx2.*0 , 1, 1);
        % machine = setcellstruct(machine, 'T2', bba_ind, offset_quady2.*0 , 1, 3);
        
        [m_corr_x, m_corr_y] = sirius_commis.common.trajectory_matrix(fam, M_acc);
        [~ , ind_best_x] = max(abs(m_corr_x), [], 2);
        [~ , ind_best_y] = max(abs(m_corr_y), [], 2);
        
        delta_x = 1.0 * mili / factor;
        delta_y = 1.0 * mili / factor;
        corr_lim_max = 300 * micro;
        
        for k = 1:length(bpm)
            if bba_ind(k) > bpm(k)
                trecho = machine(bpm(k)+1:bba_ind(k)-1);
            else
                trecho = machine(bba_ind(k)+1:bpm(k)-1);
            end
            pass = getcellstruct(trecho, 'PassMethod', 1:length(trecho));
            
            if any(~strcmp(pass, 'DriftPass') | strcmp(pass, 'IdentityPass'))
                continue
            else
                bpm_ok_x(k) = 1;
                bpm_ok_y(k) = 1;
            end
            
            mx(k) = m_corr_x(k, ind_best_x(k));
            tx = theta_x0(ind_best_x(k));
            dtx = abs(abs(tx) - corr_lim_max);
            dx = mx(k) * dtx;
    
            if abs(dx) < delta_x * factor 
               bpm_ok_x(k) = 0;
            end
                
            my(k) = m_corr_y(k, ind_best_y(k));
            ty = theta_y0(ind_best_y(k));
            dty = abs(abs(ty) - corr_lim_max);
            dy = my(k) * dty;
            if abs(dy) < delta_y * factor
               bpm_ok_y(k) = 0;
            end
        end
        
        bpms_x = find(bpm_ok_x);
        bpms_y = find(bpm_ok_y);
        
        for kx = 1:length(bpms_x)
           if ~ismember(bpms_x(kx), data_bpm.good_bpm_x)
               bpm_ok_x(bpms_x(kx)) = 0;
           end
           % elseif ismember(bpms_x(kx), data_bpm.bad_bpm_x)
           %     bpm_ok_x(bpms_x(kx)) = 0;
           % else
           %     continue
           % end
        end
        
        for ky = 1:length(bpms_y)
           if ~ismember(bpms_y(ky), data_bpm.good_bpm_y)
               bpm_ok_y(bpms_y(ky)) = 0;
           % elseif ismember(bpms_y(ky), data_bpm.bad_bpm_y)
           %     bpm_ok_y(bpms_y(ky)) = 0;
           % else
           %     continue
           end
        end
        
        
        % clsf = ZERO_BPM; number_corr = ZERO_BPM;
        % pi_num = pi;
        %{
        mux_bpm = twiss.mux(bpm(i));
        mux_corr = twiss.mux(ch(m_corr_x(i, :) ~= 0));
        mux_matrix = twiss.mux(ch(ind_best_x(i)));
        dmux_matrix = mux_bpm - mux_matrix;
        dmux_mod_matrix = abs(dmux_matrix - pi_num * round(dmux_matrix / pi_num)) ./ pi_num;
        dmux_mod_matrix(dmux_mod_matrix > 0.5) = 1 - dmux_mod_matrix(dmux_mod_matrix > 0.5);
        dmux = repmat(mux_bpm, length(mux_corr), 1) - mux_corr;
        dmux_mod_pi = abs(dmux - pi_num * round(dmux / pi_num)) ./ pi_num;
        dmux_mod_pi(dmux_mod_pi > 0.5) = 1 - dmux_mod_pi(dmux_mod_pi > 0.5);

        org = sort(dmux_mod_pi);
        ind_best_x_phase(i) = find(twiss.mux(ch(:)) == mux_corr(dmux_mod_pi == org(1)));
        mx_phase(i) = m_corr_x(i, ind_best_x_phase(i));
        tx_phase = theta_x0(ind_best_x_phase(i));
        dtx_phase = abs(abs(tx_phase) - corr_lim_max);
        dx_phase(i) = mx_phase(i) * dtx_phase;

        % phase_good(i) = abs(dx_phase) > delta_x;
        %}
        % mx(i) = m_corr_x(i, ind_best_x(i));
        % tx = theta_x0(ind_best_x(i));
        % dtx = abs(abs(tx) - corr_lim_max);
        % dx = mx(i) * dtx;

        % clsf(i) = find(org == dmux_mod_matrix);
        % number_corr(i) = length(org);
        %}

         
        % delta_x = max(dx_phase) / factor;
        % score = [clsf, number_corr]; 
        if strcmp(plane, 'x') || strcmp(plane, 'xy')
            fprintf('================================================\n');
            fprintf('HORIZONTAL BBA \n');
            fprintf('================================================\n');
            for i = 1:length(bpm)
                if sum(bpm_ok_x(1:i)) > bpm_stop
                   break
                end
                if bpm_ok_x(i)
                    fprintf('BPM NUMBER %i \n', i);
                    if flag_data_input
                        % theta0 = theta_x0(ind_best_x(i));
                        % mm_error = m_corr_x_error(i);
                        % mmx = m_resp_in(i, 1);
                        mmx_nominal = mx(i);
                        if abs(thetax_off(i)) >= corr_lim_max
                            bpm_ok_x(i) = 0;
                            off_bba_x(i) = 0;
                            continue
                        end
                        theta1 = thetax_off(i) - delta_x / mmx_nominal;
                        theta2 = thetax_off(i) + delta_x / mmx_nominal;
                        theta_min = min(theta1, theta2);
                        theta_max = max(theta1, theta2);
                    else
                        theta0 = theta_x0(ind_best_x(i));
                        delta_theta = abs(delta_x / mx(i));
                        theta1 = theta0 - delta_theta;
                        theta2 = theta0 + delta_theta;
                        theta_min = min(theta1, theta2);
                        theta_max = max(theta1, theta2);
                    end
                    if abs(theta_min) > corr_lim_max
                        warning('on')
                        warning('CALCULATED CORRECTOR KICK GREATER THAN MAX, 300 um APPLIED')
                        bpm_ok_x(i) = 0;
                        off_bba_x(i) = 0;
                        off_bba_theta_x(i) = corr_lim_max;
                        continue
                    end
                    if abs(theta_max) > corr_lim_max
                        warning('CALCULATED CORRECTOR KICK GREATER THAN MAX, 300 um APPLIED')
                        bpm_ok_x(i) = 0;
                        off_bba_x(i) = 0;
                        off_bba_theta_x(i) = corr_lim_max;
                        continue
                    end

                    dtheta_corr = linspace(theta_min, theta_max, n_points_new);  

                    fprintf('================================================\n');
                    fprintf('BPM NUMBER # %i / %i \n', sum(bpm_ok_x(1:i)), sum(bpm_ok_x));
                    fprintf('================================================\n');
                else
                    continue
                end

                [ri_x, rf_x] = bba_process(machine, param, param_errors, n_part, n_pulse, bba_ind, ind_best_x, dtheta_corr, i, n_points_new, fam, 'x');
                [quadratic_x, linear_x, m_resp_x(i), mono] = sirius_commis.common.bba_analysis(ri_x, rf_x, i, dtheta_corr, 'x', 'plot');
                % off_bba_x(i) = quadratic_x.offset_bpm;
                % off_bba_theta_x(i) = quadratic_x.offset_theta;
                % if mono
                %     off_bba_x(i) = 0;
                %     off_bba_theta_x(i) = corr_lim_max;
                % else
                %     off_bba_x(i) = linear_x.offset_bpm;
                % end
                % off_bba_theta_x(i) = linear_x.offset_theta;
                off_bba_x(i) = quadratic_x.offset_bpm;
                off_bba_theta_x(i) = quadratic_x.offset_theta;
                Ri_x(i, :, :, :) = ri_x; Rf_x(i, :, :, :) = rf_x;
            end
        end
        if strcmp(plane, 'y') || strcmp(plane, 'xy')
            fprintf('================================================\n');
            fprintf('VERTICAL BBA \n');
            fprintf('================================================\n');

            for i = 1:length(bpm)
                if sum(bpm_ok_y(1:i)) > bpm_stop
                    break
                end
                if bpm_ok_y(i)
                    if flag_data_input
                        % theta0 = theta_y0(ind_best_y(i));
                        % mmy = m_resp_in(i, 2);
                        % mm_error = m_corr_x_error(i);
                        mmy_nominal = my(i);
                        theta1 = thetay_off(i) - delta_y / mmy_nominal;
                        theta2 = thetay_off(i) + delta_y / mmy_nominal;
                        theta_min = min(theta1, theta2);
                        theta_max = max(theta1, theta2);
                    else
                        theta0 = theta_y0(ind_best_y(i));
                        theta1 = theta0 - delta_y / my(i);
                        theta2 = theta0 + delta_y / my(i);
                        theta_min = min(theta1, theta2);
                        theta_max = max(theta1, theta2);
                    end
                    if abs(theta_min) > corr_lim_max
                        % theta_min = sign(theta_min) * corr_lim_max;
                        warning('on')
                        warning('CALCULATED CORRECTOR KICK GREATER THAN MAX, 300 um APPLIED')
                        bpm_ok_y(i) = 0;
                        off_bba_y(i) = 0;
                        off_bba_theta_y(i) = corr_lim_max;
                        continue
                    end
                    if abs(theta_max) > corr_lim_max
                        % theta_max = sign(theta_max) * corr_lim_max;
                        warning('CALCULATED CORRECTOR KICK GREATER THAN MAX, 300 um APPLIED')
                        bpm_ok_y(i) = 0;
                        off_bba_y(i) = 0;
                        off_bba_theta_y(i) = corr_lim_max;
                        continue
                    end

                    dtheta_corr = linspace(theta_min, theta_max, n_points_new);

                    fprintf('================================================\n');
                    fprintf('BPM NUMBER # %i / %i \n', sum(bpm_ok_y(1:i)), sum(bpm_ok_y));
                    fprintf('================================================\n');
                else
                    continue
                end

                [ri_y, rf_y] = bba_process(machine, param, param_errors, n_part, n_pulse, bba_ind, ind_best_y, dtheta_corr, i, n_points_new, fam, 'y');
                [quadratic_y, linear_y, m_resp_y(i)] = sirius_commis.common.bba_analysis(ri_y, rf_y, i, dtheta_corr, 'y', 'plot');
                % off_bba_y(i) = linear_y.offset_bpm;
                % off_bba_theta_y(i) = linear_y.offset_theta;
                off_bba_y(i) = quadratic_y.offset_bpm;
                off_bba_theta_y(i) = quadratic_y.offset_theta;
                Ri_y(i, :, :, :) = ri_y; Rf_y(i, :, :, :) = rf_y;
            end
        end
        offset_quadx = getcellstruct(machine, 'T2', bba_ind, 1, 1);
        offset_quady = getcellstruct(machine, 'T2', bba_ind, 1, 3);
        offset_quad = [offset_quadx, offset_quady];    
        offset_bpm = getcellstruct(machine, 'Offsets', bpm);
        offset_bpm = cell2mat(offset_bpm);
        off_bpm{j} = offset_bpm;
        off_quad{j} = offset_quad;
        off_bba{j} = [off_bba_x, off_bba_y];
        off_theta{j} = [off_bba_theta_x, off_bba_theta_y];
        m_resp{j} = [m_resp_x, m_resp_y];
        pos_bpm_i{j} = [Ri_x, Ri_y];
        pos_bpm_f{j} = [Rf_x, Rf_y];
    end
    bba_data.off_bba = off_bba;
    bba_data.off_theta = off_theta;
    bba_data.off_bpm = off_bpm;
    bba_data.off_quad = off_quad;
    bba_data.m_resp = m_resp;
    bba_data.pos_bpm_i = pos_bpm_i;
    bba_data.pos_bpm_f = pos_bpm_f;
    bba_data.bpm_ok_x = bpm_ok_x;
    bba_data.bpm_ok_y = bpm_ok_y;
end

function [Ri, Rf] = bba_process(machine_in, param, param_errors, n_part, n_pulse, bba_ind, ind_best, dtheta_corr, n_bpm, n_points, fam, plane)

% quad_skew = fam.QS.ATIndex;
% skew = ismember(bba_ind(n_bpm), quad_skew);

skew = false;
if strcmp(plane, 'x')
    if skew
        flag_x = false;
    else
        flag_x = true;
    end
elseif strcmp(plane, 'y')
    if skew
        flag_x = true;
    else
        flag_x = false;
    end
end

% if strcmp(method, 'quad')
%     flag_quad = true;
% else
%     flag_quad = false;
% end

if flag_x
    corr = fam.CH.ATIndex;
else
    corr = fam.CV.ATIndex;
end

bpm = fam.BPM.ATIndex;
% skew_lim = 0.0667;
quad_lim1 = 3.72;
quad_lim2 = 4.54;

q20 = sort([fam.QDA.ATIndex; fam.QDB1.ATIndex; fam.QDB2.ATIndex; fam.QDP1.ATIndex; fam.QDP2.ATIndex]);

if ismember(bba_ind(n_bpm), q20)
    quad_lim = quad_lim1;
else
    quad_lim = quad_lim2;
end 

if skew
    polyA = getcellstruct(machine_in, 'PolynomA', bba_ind(n_bpm), 1, 2);
    polyA_bba = skew_lim;
    if abs(polyA_bba) > skew_lim
        polyA_bba = sign(polyA_bba) * skew_lim;
        warning('Skew Quadrupole Strength greater than maximum');
    end
else
    polyB = getcellstruct(machine_in, 'PolynomB', bba_ind(n_bpm), 1, 2);
    polyB_bba = 1.01 * polyB;
    if abs(polyB_bba) > quad_lim
        polyB_bba = sign(polyB_bba) * quad_lim;
        warning('Quadrupole Strength greater than maximum');
    end
end

bpm_bba = bpm(bpm > bba_ind(n_bpm));
[~, ind_bpm_bba] = intersect(bpm, bpm_bba);
% Ri = zeros(n_points, 2, length(ind_bpm_bba));
Ri = zeros(n_points, 2, length(bpm));
Rf = Ri;

for ii = 1:n_points
        if n_bpm > 1
            machine1 = lnls_set_kickangle(machine_in, dtheta_corr(ii) , corr(ind_best(n_bpm)), plane);
        else
            param.kckr_sist = dtheta_corr(ii);
            machine1 = machine_in;
        end
        
        if skew
            machine2 = setcellstruct(machine1, 'PolynomA', bba_ind(n_bpm), polyA_bba, 1, 2);
            machine1 = setcellstruct(machine1, 'PolynomA', bba_ind(n_bpm), polyA, 1, 2);
        else
            machine2 = setcellstruct(machine1, 'PolynomB', bba_ind(n_bpm), polyB_bba, 1, 2);
            machine1 = setcellstruct(machine1, 'PolynomB', bba_ind(n_bpm), polyB, 1, 2);
        end
        
        % [~, r_bpm1, int_bpm1, ~, ~, ~] = sirius_commis.first_turns.si.multiple_pulse_turn(machine1, 1, param, param_errors, n_part, n_pulse, n_turns);
        % [~, r_bpm2, int_bpm2, ~, ~, ~] = sirius_commis.first_turns.si.multiple_pulse_turn(machine2, 1, param, param_errors, n_part, n_pulse, n_turns);
        % param.orbit = findorbit4(machine1, 0, 1:length(machine1));
        [~, ~, ~, r_bpm1, int_bpm1] = sirius_commis.injection.si.multiple_pulse(machine1, param, param_errors, n_part, n_pulse, length(machine_in), 'on', 'diag');
        % param.orbit = findorbit4(machine2, 0, 1:length(machine2));
        [~, ~, ~, r_bpm2, int_bpm2] = sirius_commis.injection.si.multiple_pulse(machine2, param, param_errors, n_part, n_pulse, length(machine_in), 'on', 'diag');
        % orbit1 = findorbit4(machine1, 0, bpm);
        % orbit2 = findorbit4(machine2, 0, bpm);
        % r_bpm1 = orbit1(1, :);
        % r_bpm2 = orbit2(1, :);
        % int_bpm1 = ones(length(bpm), 1);
        % int_bpm2 = int_bpm1;
        
        fprintf('================================================\n');
        fprintf('CORRECTOR CHANGE NUMBER # %i / %i \n', ii, n_points);
        fprintf('================================================\n');
        
        
        % if mean(int_bpm1) < int_min || mean(int_bpm2) < int_min
        %     fm(ii) = NaN;
        %     r_bpm(ii) = NaN;
        %     continue
        % end
        % if n_corr == 1
            
        %     n_corr = 0;
        % end
        int_min = 0.80;
        dif = setdiff([1:1:160]', ind_bpm_bba);
        
        % Ri(ii, :, :) = r_bpm1(:, ind_bpm_bba);
        % Rf(ii, :, :) = r_bpm2(:, ind_bpm_bba);
        Ri(ii, :, :) = r_bpm1; Ri(ii, :, dif) = NaN;
        Rf(ii, :, :) = r_bpm2; Rf(ii, :, dif) = NaN;
        bpm_discard = int_bpm1(ind_bpm_bba) < int_min | int_bpm2(ind_bpm_bba) < int_min;
        first = ind_bpm_bba(bpm_discard);
        if ~isempty(first)
            first = first(1);
            Ri(ii, :, first:end)= NaN;
            Rf(ii, :, first:end) = NaN;
        end
        
        % bpm_bba = bpm(int_bpm1 > int_min & int_bpm2 > int_min & bpm > bba_ind(n_bpm));
        % [~, ind_bpm_bba] = intersect(bpm, bpm_bba);
        %{    
        if flag_quad   
            if flag_x
                fm(ii) = nansum((r_bpm1(1, ind_bpm_bba) - r_bpm2(1, ind_bpm_bba)).^2);
                r_bpm(ii) = r_bpm1(1, n_bpm);
            else
                fm(ii) = nansum((r_bpm1(2, ind_bpm_bba) - r_bpm2(2, ind_bpm_bba)).^2);
                r_bpm(ii) = r_bpm1(2, n_bpm);
            end
        else
            if flag_x
                fm(ii, :) = r_bpm1(1, ind_bpm_bba') - r_bpm2(1, ind_bpm_bba');
                r_bpm(ii, :) = r_bpm1(1, ind_bpm_bba);
            else
                fm(ii, :) = r_bpm1(2, ind_bpm_bba') - r_bpm2(2, ind_bpm_bba');
                r_bpm(ii, :) = r_bpm1(2, ind_bpm_bba);
            end
        end
        %}
end
end

