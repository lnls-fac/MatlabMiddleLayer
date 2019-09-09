function [machine, hund_turns, count_turns] = orbit_correction(machine, n_mach, param, param_errors, respm, n_sv, n_part, n_pulse, several_turns)
% Closed orbit correction algorithm
%
% INPUTS:
%  - machine: storage ring model with errors
%  - n_mach: number of random machines
%  - param: cell of structs with adjusted injection parameters for each
%  machine
%  - param_errors: errors in the injection parameters
%  - respm: response matrix from nominal model
%  - n_sv: initial number of singular values of response matrix to start the correction
%  - n_part: number of particles
%  - n_pulse: number of pulses injected
%  - several_turns: number of turns to consider that the orbit correction
%  already reached the several turns regime
%
% OUTPUTs: 
%  - machine_cell: booster ring model with correctors adjusted to produce
%  several turns 
%  - hund_turns: if 1 indicates that the closed orbit was corrected,
%  otherwise is 0
%  - count_turns: is maximum number of turns reached in each injection
%  pulse
%  - n_sv_f: final number of single values used to obtain the correction
%
%  Version 1 - December, 2018.

    sirius_commis.common.initializations();

    if n_mach == 1
        machine_cell = {machine};
        param_cell = {param};
    elseif n_mach > 1
        machine_cell = machine;
        param_cell = param;
    end
    
%   cavity_ind = findcells(machine, 'Frequency');    
%   f_rf0 = cavity.Frequency;
%   error = 5e-6; % THIS ERROR CORRESPONDS TO A BOOSTER LENGTH ERROR OF 2.5mm
%   df_erro = error * f_rf0;
    
%   machine{cavity_ind}.Frequency = 499653094.937151;
%   machine{cavity_ind}.PhaseLag = 2.28479465715621;
    
    hund_turns = zeros(n_mach, 1);
    count_turns = cell(n_mach, 1);
    % n_sv_f = ones(n_mach, 1) * n_sv;
    param_errors.sigma_bpm = 3e-3;

    fam = sirius_si_family_data(machine_cell{1});
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
        
        sext_idx = findcells(machine_cell{j},'PolynomB');
        polynomb_orig = getcellstruct(machine_cell{j}, 'PolynomB', sext_idx);
        
        for k=1:length(polynomb_orig)
           PolyB = machine_cell{j}{sext_idx(k)}.PolynomB; % necessary so that correctors kicks are not lost
           PolyB(3:end) = polynomb_orig{k}(3:end) * 0;
           machine_cell{j} = setcellstruct(machine_cell{j},'PolynomB',sext_idx(k),{PolyB});
        end

        machine = machine_cell{j};
        param = param_cell{j};
        
        machine = setcavity('off', machine);
        machine = setradiation('on', machine);
        
        orbit = findorbit4(machine, 0, 1:size(machine, 2));
        param.orbit = orbit;

        [count_turns{j}, r_bpm, ~, ~, ~, fm_i] = sirius_commis.first_turns.si.multiple_pulse_turn(machine, 1, param, param_errors, n_part, n_pulse, several_turns);

        % n_correction = 1;
       
        x_bpm = squeeze(r_bpm(1, :)); y_bpm = squeeze(r_bpm(2, :));
        rms_x_bpm_old = std(x_bpm); rms_y_bpm_old = std(y_bpm);
        rms_x_bpm_new = rms_x_bpm_old; rms_y_bpm_new = rms_y_bpm_old;
        % ratio_x = 0;
        % ratio_y = 0;
        % conv = 95;
        
        % fm_new = fm_old;
        k = 1;
        n_inc = 1;
        n_t = n_sv;
        stop_x = false; stop_y = false;
        inc_x = true; inc_y = true;
        sv_change = false;
        
        % theta_x_i = lnls_get_kickangle(machine, ch, 'x')';
        % theta_y_i = lnls_get_kickangle(machine, cv, 'y')';
        corr_lim = 300e-6;
        n_corr = 1;
        S_inv = 1 ./ diag(S);
        
        fm_f = fm_i; 
        while fm_f >= fm_i%inc_x || inc_y
            
            theta_x0 = lnls_get_kickangle(machine, ch, 'x')';
            theta_y0 = lnls_get_kickangle(machine, cv, 'y')';
            theta_x_i = theta_x0; theta_y_i = theta_y0;
            
            fm_i = fm_f;
            
            orbit0 = findorbit4(machine, 0, 1:size(machine, 2));            
            % theta_x_i = lnls_get_kickangle(machine, ch, 'x')';
            % theta_y_i = lnls_get_kickangle(machine, cv, 'y')';

            if ~sv_change
                if ~stop_x
                    rms_x_bpm_old = rms_x_bpm_new;
                end
                if ~stop_y
                    rms_y_bpm_old = rms_y_bpm_new;
                end
            end

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

                % turn_inc = turn_inc + 1;

                S_inv_var = S_inv;
                S_inv_var(isinf(S_inv_var)) = 0;
                S_inv_var(n_t + 1:end) = 0;
                S_inv_var = diag(S_inv_var);
                M_resp_inv = V * S_inv_var * U';

                m_resp_inv_x = M_resp_inv(1:size(ch, 1), 1:size(bpm, 1));
                m_resp_inv_y = M_resp_inv(size(ch, 1)+1:end, size(bpm, 1)+1:end);

                % fm_old = fm_new;

                % if inc_x 
                    x_bpm = squeeze(r_bpm(1, :));
                    theta_x_f =  theta_x_i - m_resp_inv_x * x_bpm';
                    over_kick_x = abs(theta_x_f) > corr_lim;

                    if any(over_kick_x)
                        warning('Horizontal corrector kick greater than maximum')
                        % gr_mach_x(over_kick_x) = 1;
                        theta_x_f(over_kick_x) =  sign(theta_x_f(over_kick_x)) * corr_lim;
                    end

                    machine = lnls_set_kickangle(machine, theta_x_f, ch, 'x');
                    fprintf('HORIZONTAL CORRECTION \n');

                    % theta_x_i = theta_x_f;
                % end

                % if inc_y
                    y_bpm = squeeze(r_bpm(2, :));
                    theta_y_f = theta_y_i - m_resp_inv_y * y_bpm';
                    over_kick_y = abs(theta_y_f) > corr_lim;

                if any(over_kick_y)
                    warning('Vertical corrector kick greater than maximum')
                    % gr_mach_y(over_kick_y) = 1;
                    theta_y_f(over_kick_y) =  sign(theta_y_f(over_kick_y)) * corr_lim;
                end

                    machine = lnls_set_kickangle(machine, theta_y_f, cv, 'y');
                    fprintf('VERTICAL CORRECTION \n');

                    % theta_y_i = theta_y_f;
                % end

                % theta_x_i = lnls_get_kickangle(machine, ch, 'x')';
                % theta_y_i = lnls_get_kickangle(machine, cv, 'y')';

                % ind = num_sv(j);

                [count_turns{j}, r_bpm, int_bpm, ~, ~, fm_f] = sirius_commis.first_turns.si.multiple_pulse_turn(machine, 1, param, param_errors, n_part, n_pulse, n_corr*several_turns);

                % if int_bpm(end) == 0
                %     continue
                % end

                rms_x_bpm_new = nanstd(r_bpm(1,:));
                rms_y_bpm_new = nanstd(r_bpm(2,:));
                
                if fm_f < fm_i

                if ~stop_x
                    inc_x = rms_x_bpm_new < rms_x_bpm_old;
                    if ~inc_x
                        machine = lnls_set_kickangle(machine, theta_x0, ch, 'x');
                        stop_x = true;
                    end
                end

                if ~stop_y
                    inc_y = rms_y_bpm_new < rms_y_bpm_old;
                    if ~inc_y
                        machine = lnls_set_kickangle(machine, theta_y0, cv, 'y');
                        stop_y = true;
                    end
                end
                
                end

                if ~inc_x && ~inc_y && fm_f < fm_i
                    if n_inc == 0
                % theta_x = theta_x + m_corr_inv_x * x_bpm';
                % theta_y = theta_y + m_corr_inv_y * y_bpm';
                machine = lnls_set_kickangle(machine, theta_x0, ch, 'x');
                machine = lnls_set_kickangle(machine, theta_y0, cv, 'y');
                return
                else
                    n_t = n_sv + k * 5;
                    inc_x = true; inc_y = true;
                    stop_x = false; stop_y = false;
                    k = k+1;
                    n_inc = 0;
                    sv_change = true;
                    fprintf('Number of Singular Values: %i \n', n_t);
                    fm_f = fm_i;
                continue
                    end
                end
                n_inc = n_inc + 1;
                sv_change = false;
                n_corr = n_corr + 1;


                param.orbit = findorbit4(machine, 0, 1:size(machine, 2));

                sirius_commis.common.plot_bpms(machine, param.orbit, r_bpm, int_bpm);
                % n_correction = n_correction + 1;

                % if n_correction > 20
                %    machine_cell{j} = machine;
                %    corrected = false;
                %    break
                % end


                fprintf('BPM X rms %f um -->> %f um  \n', rms_x_bpm_old*1e6, rms_x_bpm_new*1e6);
                fprintf('BPM Y rms %f um -->> %f um  \n', rms_y_bpm_old*1e6, rms_y_bpm_new*1e6);
                fprintf('COD X rms %f um -->> %f um  \n', std(orbit0(1,:))*1e6, std(param.orbit(1,:))*1e6);
                fprintf('COD Y rms %f um -->> %f um  \n', std(orbit0(3,:))*1e6, std(param.orbit(3,:))*1e6);

        end
    end
end

            %{
            orbit0 = findorbit4(machine, 0, 1:size(machine, 2));

            [theta_x, theta_y] = calc_kicks(r_bpm, m_resp_inv_x, m_resp_inv_y, theta_x_i, theta_y_i, plane);
            
            if ~stop_x
                machine = lnls_set_kickangle(machine, theta_x, ch, 'x');
            end
            if ~stop_y
                machine = lnls_set_kickangle(machine, theta_y, cv, 'y');
            end
  
            param.orbit = findorbit4(machine, 0, 1:size(machine, 2));

            [count_turns{j}, r_bpm, int_bpm] = sirius_commis.first_turns.si.multiple_pulse_turn(machine, 1, param, param_errors, n_part, n_pulse, several_turns);
            
            x_bpm = squeeze(r_bpm(1, :));
            y_bpm = squeeze(r_bpm(2, :));
            
            rms_x_bpm_new = std(x_bpm);
            rms_y_bpm_new = std(y_bpm);
            %}
            
            % if min_turns_0 < min_turns_f
            %    num_sv(j) = num_sv(j) - 5;
            %    turn_inc = turn_inc - 1;
            %    if num_sv(j) < 0
            %        num_sv(j) = 0;
            %    end
            %else
            %    num_sv(j) = num_sv(j) + 2;
            %    machine = machine_n;
            %end

            %if min(int_bpm) == 0
            %    corrected = false;
            %    break
            %end
            
            % sirius_commis.common.plot_bpms(machine, param.orbit, r_bpm, int_bpm);
            % n_correction = n_correction + 1;
            
            % if n_correction > 20
            %    machine_cell{j} = machine;
            %    corrected = false;
            %    break
            % end
            
            % fprintf('BPM X rms %f um -->> %f um  \n', rms_x_bpm_old*1e6, rms_x_bpm_new*1e6);
            % fprintf('BPM Y rms %f um -->> %f um  \n', rms_y_bpm_old*1e6, rms_y_bpm_new*1e6);
            % fprintf('COD X rms %f um -->> %f um  \n', std(orbit0(1,:))*1e6, std(param.orbit(1,:))*1e6);
            % fprintf('COD Y rms %f um -->> %f um  \n', std(orbit0(3,:))*1e6, std(param.orbit(3,:))*1e6);
            
            % ratio_x = sirius_commis.common.prox_percent(rms_x_bpm_old, rms_x_bpm_new);
            % ratio_y = sirius_commis.common.prox_percent(rms_y_bpm_old, rms_y_bpm_new);
            
            % if ratio_x > conv || ratio_y > conv
            %     machine_cell{j} = machine;
            % end
            %{
            if rms_x_bpm_new > rms_x_bpm_old && rms_y_bpm_new > rms_y_bpm_old
                machine = lnls_set_kickangle(machine, theta_x_i, ch, 'x');
                machine = lnls_set_kickangle(machine, theta_y_i, cv, 'y');
                param.orbit = findorbit4(machine, 0, 1:size(machine, 2));
                if n_inc == 0
                    break
                else
                    n_t(j) = n_sv(j) + k * 10;
                    fprintf('Number of Singular Values: %i \n', n_t(j));
                    k = k + 1;
                    % fm_old = fm_new;
                    n_inc = 0;
                    stop_x = false; stop_y = false;
                    rms_x_bpm_new = rms_x_bpm_old;
                    rms_y_bpm_new = rms_y_bpm_old;
                    plane = 'xy';
                    continue
                end
            elseif rms_x_bpm_new > rms_x_bpm_old && rms_y_bpm_new < rms_y_bpm_old && ~stop_y
                stop_x = true; stop_y = false;
                machine = lnls_set_kickangle(machine, theta_x_i, ch, 'x');
                plane = 'y';
                % rms_x_bpm_new = rms_x_bpm_old;
            elseif rms_x_bpm_new < rms_x_bpm_old && rms_y_bpm_new > rms_y_bpm_old && ~stop_x
                stop_x = false; stop_y = true;
                machine = lnls_set_kickangle(machine, theta_y_i, cv, 'y');
                plane = 'x';
                % rms_y_bpm_new = rms_y_bpm_old;
            else
                plane = 'xy';
            end
            n_inc = n_inc + 1;
        end 
        machine_cell{j} = machine;
        hund_turns(j) = 1;
        param_cell{j}.orbit = param.orbit;
    end
end
%}
function [theta_x, theta_y] = calc_kicks(r_bpm_turns, m_corr_inv_x, m_corr_inv_y, theta_x_in, theta_y_in, plane)
  fprintf('ORBIT CORRECTION \n');
  x_bpm = r_bpm_turns(1, :);
  y_bpm = r_bpm_turns(2, :);
  
  corr_lim = 300e-6;
  
  if strcmp(plane, 'x')
    theta_x = theta_x_in - m_corr_inv_x * x_bpm';
    over_kick_x = abs(theta_x) > corr_lim;
    if any(over_kick_x)
        warning('Horizontal corrector kick greater than maximum')
        theta_x(over_kick_x) =  sign(theta_x(over_kick_x)) * corr_lim;
    end        
    fprintf('HORIZONTAL CORRECTION \n');
    theta_y = theta_y_in;
  elseif strcmp(plane, 'y')
    theta_y = theta_y_in - m_corr_inv_y * y_bpm';
    over_kick_y = abs(theta_y) > corr_lim;
    if any(over_kick_y)
        warning('Vertical corrector kick greater than maximum')
        theta_y(over_kick_y) =  sign(theta_y(over_kick_y)) * corr_lim;
    end 
    fprintf('VERTICAL CORRECTION \n');
    theta_x = theta_x_in;
  elseif strcmp(plane, 'xy')
    theta_x = theta_x_in - m_corr_inv_x * x_bpm';
    over_kick_x = abs(theta_x) > corr_lim;
    if any(over_kick_x)
        warning('Horizontal corrector kick greater than maximum')
        theta_x(over_kick_x) =  sign(theta_x(over_kick_x)) * corr_lim;
    end        
    theta_y = theta_y_in - m_corr_inv_y * y_bpm';
    over_kick_y = abs(theta_y) > corr_lim;
    if any(over_kick_y)
        warning('Vertical corrector kick greater than maximum')
        theta_y(over_kick_y) =  sign(theta_y(over_kick_y)) * corr_lim;
    end 
    fprintf('HORIZONTAL AND VERTICAL CORRECTION \n');
  end
end
    
