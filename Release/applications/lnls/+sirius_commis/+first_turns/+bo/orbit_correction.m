function [machine_cell, hund_turns, count_turns, num_svd] = orbit_correction(machine, n_mach, param, param_errors, respm, svd_min, n_part, n_pulse, several_turns)

    sirius_commis.common.initializations();

    if n_mach == 1
        machine_cell = {machine};
        param_cell = {param};
    elseif n_mach > 1
        machine_cell = machine;
        param_cell = param;
    end
    hund_turns = zeros(n_mach, 1);
    count_turns = cell(n_mach, 1);
    num_svd = ones(n_mach, 1) * svd_min;
    corrected = true;
    param_errors.sigma_bpm = 3e-3;

    fam = sirius_bo_family_data(machine_cell{1});
    ch = fam.CH.ATIndex;
    cv = fam.CV.ATIndex;
    bpm = fam.BPM.ATIndex;

    U = respm.U;
    S = respm.S;
    V = respm.V;

    for j = 1:n_mach
        fprintf('======================= \n');
        fprintf('Machine number %i \n', j);
        fprintf('======================= \n');

        param_cell{j}.orbit = findorbit4(machine_cell{j}, 0, 1:size(machine_cell{j}, 2));

        machine = machine_cell{j};
        param = param_cell{j};
        
        machine = setcavity('off', machine);
        machine = setradiation('off', machine);
        
        orbit0 = findorbit4(machine, 0, 1:size(machine, 2));
        param.orbit = orbit0;

        theta_x = lnls_get_kickangle(machine, ch, 'x')';
        theta_y = lnls_get_kickangle(machine, cv, 'y')';

        [count_turns{j}, r_bpm, int_bpm] = sirius_commis.first_turns.bo.multiple_pulse_turn(machine, 1, param, param_errors, n_part, n_pulse, several_turns);
        min_turns_0 = min(count_turns{j});
        
        if min(int_bpm) == 0
            corrected = false;
            continue
        end

        n_correction = 1;
        orbitf = orbit0;

        min_turns_f = min_turns_0;
        ind = 0;
        x_bpm = squeeze(r_bpm(1, :));
        y_bpm = squeeze(r_bpm(2, :));
        rms_x_bpm_old = std(x_bpm);
        rms_y_bpm_old = std(y_bpm);
        rms_x_bpm_new = rms_x_bpm_old;
        rms_y_bpm_new = rms_y_bpm_old;
        ratio_x = 0;
        ratio_y = 0;
        conv = 95;
        
        turn_inc = 1;

        while min_turns_f < turn_inc * several_turns || ratio_x < conv || ratio_y < conv
%             sirius_commis.common.plot_bpms(machine, orbitf, r_bpm, int_bpm);
%
%             fig = figure('OuterPosition', [100, 100, 800, 900]);
%             ax1 = subplottight(3,1,1, 'vspace', 0.05);
%             ax2 = subplottight(3,1,2, 'vspace', 0.05);
%             ax3 = subplottight(3,1,3, 'vspace', 0.05);
%             setappdata(0, 'fig', fig);
%             setappdata(0, 'ax1', ax1);
%             setappdata(0, 'ax2', ax2);
%             setappdata(0, 'ax3', ax3);
%             drawnow();

            turn_inc = turn_inc + 1;
            
            if rms_x_bpm_new <= rms_x_bpm_old && rms_y_bpm_new <= rms_y_bpm_old
                plane = 'xy';
            elseif rms_x_bpm_new < rms_x_bpm_old && rms_y_bpm_new > rms_y_bpm_old
                plane = 'x';
                if ratio_x > conv
                    break
                end
            elseif rms_x_bpm_new > rms_x_bpm_old && rms_y_bpm_new < rms_y_bpm_old
                if ratio_y > conv
                    break
                end
                plane = 'y';
            else
                ind = 0;
                corrected = false;
                break
            end
            
            rms_x_bpm_old = rms_x_bpm_new;
            rms_y_bpm_old = rms_y_bpm_new;

            ind = num_svd(j) + 1;

            S_inv = 1 ./ diag(S);
            S_inv(isinf(S_inv)) = 0;

            if ind < (size(ch, 1) + size(cv, 1))
                S_inv(ind:end) = 0;
            end

            S_inv = diag(S_inv);

            
            M_resp_inv = V * S_inv * U';

            m_resp_inv_x = M_resp_inv(1:size(ch, 1), 1:size(bpm, 1));
            m_resp_inv_y = M_resp_inv(size(ch)+1:end, size(bpm, 1)+1:end);

            [machine_n, param.orbit, theta_x, theta_y] = set_kicks(machine, r_bpm, m_resp_inv_x, m_resp_inv_y, ch, cv, theta_x, theta_y, plane);

            [count_turns{j}, r_bpm, int_bpm] = sirius_commis.first_turns.bo.multiple_pulse_turn(machine_n, 1, param, param_errors, n_part, n_pulse, turn_inc*several_turns);
            min_turns_0 = min(count_turns{j});
            
            x_bpm = squeeze(r_bpm(1, :));
            y_bpm = squeeze(r_bpm(2, :));
            
            rms_x_bpm_new = std(x_bpm);
            rms_y_bpm_new = std(y_bpm);

            if min_turns_0 < min_turns_f
                num_svd(j) = num_svd(j) - 1;
                turn_inc = turn_inc - 1;
                if num_svd(j) < 0
                    num_svd(j) = 0;
                end
            else
                num_svd(j) = num_svd(j) + 2;
                machine = machine_n;
            end

            if min(int_bpm) == 0
                corrected = false;
                break
            end
            
            sirius_commis.common.plot_bpms(machine, orbitf, r_bpm, int_bpm);
            n_correction = n_correction + 1;
            
            if n_correction > 20
                machine_cell{j} = machine;
                corrected = false;
                break
            end
            
            min_turns_f = min_turns_0;
            
            fprintf('Horizontal Orbit RMS changed from %f mm to %f mm  \n', rms_x_bpm_old*1e3, rms_x_bpm_new*1e3);
            fprintf('Vertical Orbit RMS changed from %f mm to %f mm  \n', rms_y_bpm_old*1e3, rms_y_bpm_new*1e3);
            
            ratio_x = sirius_commis.common.prox_percent(rms_x_bpm_old, rms_x_bpm_new);
            ratio_y = sirius_commis.common.prox_percent(rms_y_bpm_old, rms_y_bpm_new);
            
            if ratio_x > conv || ratio_y > conv
                machine_cell{j} = machine;
            end
        end
        
       
        if ind == 0
           num_svd(j) = 0; 
        end
        
        
        if corrected
            machine_cell{j} = machine;
            hund_turns(j) = 1;
            param_cell{j}.orbit = orbitf;
        end
    end
end

function [machine, orbitf, theta_x, theta_y] = set_kicks(machine, r_bpm_turns, m_corr_inv_x, m_corr_inv_y, ch, cv, theta_x_in, theta_y_in, plane)
  fprintf('ORBIT CORRECTION \n');
  

  x_bpm = r_bpm_turns(1, :);
  y_bpm = r_bpm_turns(2, :);
  
  if strcmp(plane, 'x')
    theta_x = theta_x_in - m_corr_inv_x * x_bpm';
    machine = lnls_set_kickangle(machine, theta_x, ch, 'x');
    theta_y = theta_y_in;
  elseif strcmp(plane, 'y')
    theta_y = theta_y_in - m_corr_inv_y * y_bpm';
    machine = lnls_set_kickangle(machine, theta_y, cv, 'y');
    theta_x = theta_x_in;
  elseif strcmp(plane, 'xy')
    theta_x = theta_x_in - m_corr_inv_x * x_bpm';
    machine = lnls_set_kickangle(machine, theta_x, ch, 'x');
    theta_y = theta_y_in - m_corr_inv_y * y_bpm';
    machine = lnls_set_kickangle(machine, theta_y, cv, 'y');
  end

  param.orbit = findorbit4(machine, 0, 1:size(machine, 2));
  orbitf = param.orbit;
end
