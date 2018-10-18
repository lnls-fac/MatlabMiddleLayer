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

        while min_turns_f < several_turns
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

            [machine_n, ~, theta_x, theta_y] = set_kicks(machine, r_bpm, m_resp_inv_x, m_resp_inv_y, ch, cv, theta_x, theta_y);
            orbitf = findorbit4(machine_n, 0, 1:size(machine_n, 2));
            param.orbit = orbitf;

            [count_turns{j}, r_bpm, int_bpm] = sirius_commis.first_turns.bo.multiple_pulse_turn(machine_n, 1, param, param_errors, n_part, n_pulse, several_turns);
            min_turns_0 = min(count_turns{j});
            
            if min_turns_0 < min_turns_f
                num_svd(j) = num_svd(j) - 1;
                if num_svd(j) < 0
                    num_svd(j) = 0;
                end
                continue
            else
                num_svd(j) = num_svd(j) + 2;
                machine = machine_n;
            end
            
            if min(int_bpm) == 0
                corrected = false;
                continue
            end
            sirius_commis.common.plot_bpms(machine, orbitf, r_bpm, int_bpm);
            n_correction = n_correction + 1;
            if n_correction > 10
                machine_cell{j} = machine;
                corrected = false;
            end
            min_turns_f = min_turns_0;
        end
        if corrected
            machine_cell{j} = machine;
            hund_turns(j) = 1;
            param_cell{j}.orbit = orbitf;
        end
    end
end

function [machine, orbitf, theta_x, theta_y] = set_kicks(machine, r_bpm_turns, m_corr_inv_x, m_corr_inv_y, ch, cv, theta_x_in, theta_y_in)
  fprintf('ORBIT CORRECTION \n');
  
  x_bpm = r_bpm_turns(1, :);
  theta_x = theta_x_in - m_corr_inv_x * x_bpm';

  y_bpm = r_bpm_turns(2, :);
  theta_y = theta_y_in - m_corr_inv_y * y_bpm';

  machine = lnls_set_kickangle(machine, theta_x, ch, 'x');
  machine = lnls_set_kickangle(machine, theta_y, cv, 'y');

  param.orbit = findorbit4(machine, 0, 1:size(machine, 2));
  orbitf = param.orbit;
end
