function [machine, theta_x, theta_y] = orbit_correction(machine, param, param_errors, respm, n_part, n_pulse, n_turns)

    sirius_commis.common.initializations();
    
    param_errors.sigma_bpm = 3e-3;
    
    orbit0 = findorbit4(machine, 0, 1:length(machine));
    param.orbit = orbit0;

    fam = sirius_bo_family_data(machine);
    ch = fam.CH.ATIndex;
    cv = fam.CV.ATIndex;
    bpm = fam.BPM.ATIndex;
    
    U = respm.U;
    S = respm.S;
    V = respm.V;

    S_inv = 1 ./ diag(S);
    S_inv(isinf(S_inv)) = 0;
    S_inv(S_inv > 5 * S_inv(1)) = 0;
    S_inv = diag(S_inv);

    M_resp_inv = V * S_inv * U';

    m_resp_inv_x = M_resp_inv(1:length(ch), 1:length(bpm));
    m_resp_inv_y = M_resp_inv(length(ch)+1:end, length(bpm)+1:end);

    theta_x = lnls_get_kickangle(machine, ch, 'x')';
    theta_y = lnls_get_kickangle(machine, cv, 'y')';
    
    [count_turns, r_bpm, int_bpm] = sirius_commis.first_turns.bo.multiple_pulse_turn(machine, 1, param, param_errors, n_part, n_pulse, n_turns);
    min_turns = min(count_turns);
    
    n_correction = 1;
    orbitf = orbit0;
    
    while min_turns < 50
        sirius_commis.common.plot_bpms(machine, orbitf, r_bpm, int_bpm);

        fig = figure('OuterPosition', [100, 100, 800, 900]);
        ax1 = subplottight(3,1,1, 'vspace', 0.05);
        ax2 = subplottight(3,1,2, 'vspace', 0.05);
        ax3 = subplottight(3,1,3, 'vspace', 0.05);
        setappdata(0, 'fig', fig);
        setappdata(0, 'ax1', ax1);
        setappdata(0, 'ax2', ax2);
        setappdata(0, 'ax3', ax3);
        drawnow();

        [machine, orbitf, theta_x, theta_y] = set_kicks(machine, r_bpm, m_resp_inv_x, m_resp_inv_y, ch, cv, theta_x, theta_y);
        
        param.orbit = orbitf;

        [count_turns, r_bpm, int_bpm] = sirius_commis.first_turns.bo.multiple_pulse_turn(machine, 1, param, param_errors, n_part, 3, (n_correction + 1)*min_turns);
        min_turns = min(count_turns);

        sirius_commis.common.plot_bpms(machine, orbitf, r_bpm, int_bpm);
        n_correction = n_correction + 1;
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

  param.orbit = findorbit4(machine, 0, 1:length(machine));
  orbitf = param.orbit;
end
