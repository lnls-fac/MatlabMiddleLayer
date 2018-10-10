function [machine, theta_x, theta_y] = orbit_correction(machine, param, respm, n_part, n_pulse, n_turns)

    initializations();
    
    param.sigma_bpm = 3e-3;

    % orbit0 = param.orbit;

    orbit0 = findorbit4(machine, 0, 1:length(machine));
    param.orbit = orbit0;

    fam = sirius_bo_family_data(machine);
    ch = fam.CH.ATIndex;
    cv = fam.CV.ATIndex;
    bpm = fam.BPM.ATIndex;
    % r_bpm_turns = zeros(n_pulse, 2, length(bpm));
    % int_bpm_turns = zeros(n_pulse, length(bpm));


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

    theta_x = zeros(length(ch), 1);
    theta_y = zeros(length(cv), 1);
    
    [count_turns, r_bpm, int_bpm] = sirius_commis.first_turns.bo.multiple_pulse_turn(machine, 1, param, n_part, n_pulse, n_turns);
    min_turns = min(count_turns);
    
 while min_turns < 100   
    
    sirius_commis.common.plot_bpms(machine, orbit0, r_bpm, int_bpm);
    
    fig = figure('OuterPosition', [100, 100, 800, 900]);
    ax1 = subplottight(3,1,1, 'vspace', 0.05);
    ax2 = subplottight(3,1,2, 'vspace', 0.05);
    ax3 = subplottight(3,1,3, 'vspace', 0.05);
    setappdata(0, 'fig', fig);
    setappdata(0, 'ax1', ax1);
    setappdata(0, 'ax2', ax2);
    setappdata(0, 'ax3', ax3);
    drawnow();
    
    [machine, orbitf] = set_kicks(machine, r_bpm, m_resp_inv_x, m_resp_inv_y, ch, cv);
    param.orbit = orbitf;
        
    [count_turns, r_bpm, int_bpm] = sirius_commis.first_turns.bo.multiple_pulse_turn(machine, 1, param, n_part, n_pulse);
    min_turns = min(count_turns);
    
    sirius_commis.common.plot_bpms(machine, orbitf, r_bpm, int_bpm);
 end
    
        
%         for j = 1:n_pulse
%             fprintf('=================================================\n');
%             fprintf('Pulse n %0.2i \n', j);
%             fprintf('=================================================\n');
%             [~, ~, r_bpm_turns(j, :, :), int_bpm_turns(j, :)] = sirius_commis.first_turns.bo.single_pulse_turn(machine, 1, param, n_part, min_turns);
%         end
    
%         r_bpm = squeeze(mean(r_bpm_turns, 1));
%         int_bpm = squeeze(mean(int_bpm_turns, 1));
% 
%         [machine, orbitf] = set_kicks(machine, r_bpm, m_resp_inv_x, m_resp_inv_y, ch, cv);
%         param.orbit = orbitf;

%         sigx0 = std(orbit0(1, :));
%         sigy0 = std(orbit0(3, :));
% 
%         um = 1e6;
% 
%         sirius_commis.common.plot_bpms(machine, orbit0, r_bpm, int_bpm);
% 
%         fig = figure('OuterPosition', [100, 100, 800, 900]);
%         ax1 = subplottight(3,1,1, 'vspace', 0.05);
%         ax2 = subplottight(3,1,2, 'vspace', 0.05);
%         ax3 = subplottight(3,1,3, 'vspace', 0.05);
%         setappdata(0, 'fig', fig);
%         setappdata(0, 'ax1', ax1);
%         setappdata(0, 'ax2', ax2);
%         setappdata(0, 'ax3', ax3);
%         drawnow();

    %     for j = 1:n_pulse
    %     fprintf('=================================================\n');
    %     fprintf('Pulse n %0.2i \n', j);
    %     fprintf('=================================================\n');
    %     [~, ~, r_bpm_turns(j, :, :), int_bpm_turns(j, :)] = sirius_commis.first_turns.bo.single_pulse_turn(machine, 1, param, n_part, n_turns+10);
    %     end

    %     r_bpm = squeeze(mean(r_bpm_turns, 1));
    %     int_bpm = squeeze(mean(int_bpm_turns, 1));
    %     
    %     meanx_bpm = mean(r_bpm(1, :));  meanxf = mean(orbitf(1, :));
    %     meany_bpm = mean(r_bpm(2, :));  meanyf = mean(orbitf(3, :));

% 
%         sigxf = std(orbitf(1, :));
%         sigyf = std(orbitf(3, :));
% 
% %         count_turns = sirius_commis.first_turns.bo.multiple_pulse_turn(machine, 1, param, n_part, n_pulse, n_turns);
% %         min_turns = min(count_turns);
% 
%         fprintf('rmsx_orbit0 %f um, rmsy_orbit0 %f um \n', sigx0 * um, sigy0 * um)
%         fprintf('rmsx_orbitf %f um , rmsy_orbitf %f um \n', sigxf * um, sigyf * um) 

end

function [machine, orbitf] = set_kicks(machine, r_bpm_turns, m_corr_inv_x, m_corr_inv_y, ch, cv)
  fprintf('ORBIT CORRECTION \n')

  x_bpm = r_bpm_turns(1, :);
  theta_x =  - m_corr_inv_x * x_bpm';

  y_bpm = r_bpm_turns(2, :);
  theta_y = - m_corr_inv_y * y_bpm';

  machine = lnls_set_kickangle(machine, theta_x, ch, 'x');
  machine = lnls_set_kickangle(machine, theta_y, cv, 'y');

  param.orbit = findorbit4(machine, 0, 1:length(machine));
  orbitf = param.orbit;
end
