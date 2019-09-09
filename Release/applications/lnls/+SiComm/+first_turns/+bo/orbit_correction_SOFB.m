function [machine_cell, hund_turns, count_turns, num_svd] = orbit_correction_SOFB(machine, n_mach, param, param_errors, svd_min, n_part, n_pulse, several_turns)
    sirius_commis.common.initializations();

    if n_mach == 1
        machine_cell = {machine};
        param_cell = {param};
        param_err_cell = {param_errors};
    elseif n_mach > 1
        machine_cell = machine;
        param_cell = param;
        param_err_cell = param_errors;
    end
    
%   cavity_ind = findcells(machine, 'Frequency');    
%   f_rf0 = cavity.Frequency;
%   error = 5e-6; % THIS ERROR CORRESPONDS TO A BOOSTER LENGTH ERROR OF 2.5mm
%   df_erro = error * f_rf0;
    
%   machine{cavity_ind}.Frequency = 499653094.937151;
%   machine{cavity_ind}.PhaseLag = 2.28479465715621;
    
    hund_turns = zeros(n_mach, 1);
    count_turns = cell(n_mach, 1);
    num_svd = ones(n_mach, 1) * svd_min;
    corrected = true;

    fam = sirius_bo_family_data(machine_cell{1});
    ch = fam.CH.ATIndex;
    cv = fam.CV.ATIndex;
    bpm = fam.BPM.ATIndex;
    tw = 0.1;

    for j = 1:n_mach
        fprintf('======================= \n');
        fprintf('Machine number %i \n', j);
        fprintf('======================= \n');

        param_cell{j}.orbit = findorbit4(machine_cell{j}, 0, 1:size(machine_cell{j}, 2));

        machine = machine_cell{j};
        param = param_cell{j};
        param_errors = param_err_cell{j};
        % param_errors.sigma_bpm = 3e-3;
        
        machine = setcavity('off', machine);
        machine = setradiation('off', machine);
        machine = setcellstruct(machine, 'PolynomB', fam.SD.ATIndex, 0, 1, 3);
        machine = setcellstruct(machine, 'PolynomB', fam.SF.ATIndex, 0, 1, 3);
        
        orbit0 = findorbit4(machine, 0, 1:size(machine, 2));
        param.orbit = orbit0;

        theta_x = lnls_get_kickangle(machine, ch, 'x')';
        theta_y = lnls_get_kickangle(machine, cv, 'y')';
        r_bpm = [orbit0(1, bpm); orbit0(3, bpm)];

        % [count_turns{j}, r_bpm, int_bpm, ~, fm_i] = sirius_commis.first_turns.bo.multiple_pulse_turn(machine, 1, param, param_errors, n_part, n_pulse, several_turns);
        % min_turns_0 = min(count_turns{j});
        
        % sirius_commis.common.plot_bpms(machine, param.orbit, r_bpm, int_bpm);
                
        % if min(int_bpm) == 0
        %    corrected = false;
        %    continue
        %end
        
        % if count_turns{j} == several_turns
        %     continue
        % end

        n_correction = 1;
        orbitf = orbit0;

        % min_turns_f = min_turns_0;
        ind = 0;
        x_bpm = squeeze(r_bpm(1, :));
        y_bpm = squeeze(r_bpm(2, :));
        rms_x_bpm_old = nanstd(x_bpm);
        rms_y_bpm_old = nanstd(y_bpm);
        rms_x_bpm_new = rms_x_bpm_old;
        rms_y_bpm_new = rms_y_bpm_old;
        ratio_x = 0;
        ratio_y = 0;
        conv = 95;
        
        turn_inc = 1;
        % fm_f = fm_i;
        n = 1;

        while true % fm_f >= fm_i % min_turns_f < turn_inc * several_turns || ratio_x < conv || ratio_y < conv
            turn_inc = turn_inc + 1;
            % fm_i = fm_f;
            ind = num_svd(j);
            
            if rms_x_bpm_new <= rms_x_bpm_old && rms_y_bpm_new <= rms_y_bpm_old
                plane = 'xy';
            elseif rms_x_bpm_new < rms_x_bpm_old && rms_y_bpm_new > rms_y_bpm_old
                plane = 'x';
                if ratio_x > conv
                 %   break
                end
            elseif rms_x_bpm_new > rms_x_bpm_old && rms_y_bpm_new < rms_y_bpm_old
                if ratio_y > conv
                   % break
                end
                plane = 'y';
            else
                ind = 0;
                corrected = false;
                %break
            end
            
            rms_x_bpm_old = rms_x_bpm_new;
            rms_y_bpm_old = rms_y_bpm_new;
            
            [delta_ch, delta_cv] = calc_kicks(r_bpm, ind, tw);
            
            theta_x = theta_x + delta_ch;
            machine_n = lnls_set_kickangle(machine, theta_x, ch, 'x');
            theta_y = theta_y + delta_cv;
            machine_n = lnls_set_kickangle(machine_n, theta_y, cv, 'y');
            
            % [count_turns{j}, r_bpm, int_bpm, ~, fm_f] = sirius_commis.first_turns.bo.multiple_pulse_turn(machine_n, 1, param, param_errors, n_part, n_pulse, n*several_turns);
            orbitf = findorbit4(machine_n, 0, 1:size(machine, 2));
            r_bpm = [orbitf(1, bpm); orbitf(3, bpm)];
            
            min_turns_0 = min(count_turns{j});
            x_bpm = squeeze(r_bpm(1, :));
            y_bpm = squeeze(r_bpm(2, :));
            
            if count_turns{j} == several_turns
            %    break
            end
            
            % calc_kicks(r_bpm, ind, tw);
            
            rms_x_bpm_new = std(x_bpm);
            rms_y_bpm_new = std(y_bpm);

            %if min_turns_0 < min_turns_f
            %    num_svd(j) = num_svd(j) - 1;
            %    turn_inc = turn_inc - 1;
            %    if num_svd(j) < 0
            %        num_svd(j) = 0;
            %    end
            %else
                % num_svd(j) = num_svd(j) + 2;
                machine = machine_n;
            %end

            % if min(int_bpm) == 0
            %     corrected = false;
            %     break
            % end
           
            % sirius_commis.common.plot_bpms(machine, orbitf, r_bpm, int_bpm);
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
            
            n = n+2;
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

function [delta_ch, delta_cv] = calc_kicks(r_bpm, n_sv, tw, bpm_select)   
    v_prefix = getenv('VACA_PREFIX');
    ioc_prefix = [v_prefix, 'BO-Glob:AP-SOFB:'];
    pv_name.delta_kicks_ch = [ioc_prefix, 'DeltaKickCH-Mon'];
    pv_name.delta_kicks_cv = [ioc_prefix, 'DeltaKickCV-Mon'];
    pv_name.bpmx_select = [ioc_prefix, 'BPMXEnblList-SP'];
    pv_name.bpmy_select = [ioc_prefix, 'BPMYEnblList-SP'];
    pv_name.orbx = [ioc_prefix, 'OfflineOrbX-SP'];
    pv_name.orby = [ioc_prefix, 'OfflineOrbY-SP'];
    pv_name.n_sv = [ioc_prefix, 'NrSingValues-SP'];
    pv_name.calc_kicks = [ioc_prefix, 'CalcDelta-Cmd'];
    % ring_size_pv = [ioc_prefix, 'RingSize-SP'];
    % reforbx_pv = [ioc_prefix, 'RefOrbX-SP'];
    % reforby_pv = [ioc_prefix, 'RefOrbY-SP'];

    if exist('bpm_select', 'var')
        setpv(pv_name.bpmx_select, bpm_select');
        sleep(tw);
        setpv(pv_name.bpmy_select, bpm_select');
        sleep(tw);
    else
        bpm_select = ones(size(r_bpm, 2), 1);
        setpv(pv_name.bpmx_select, bpm_select');
        sleep(tw);
        setpv(pv_name.bpmy_select, bpm_select');
        sleep(tw);
    end

    setpv(pv_name.n_sv, n_sv);
    sleep(tw);
    r_bpm(isnan(r_bpm)) = 0;
    x_bpm = r_bpm(1, :)' .* 1e6;
    y_bpm = r_bpm(2, :)' .* 1e6;
    
    setpv(pv_name.orbx, x_bpm');
    setpv(pv_name.orby, y_bpm');
    
    sleep(tw);
    setpv(pv_name.calc_kicks, 1);
    sleep(tw);
    
    delta_ch = getpv(pv_name.delta_kicks_ch)' .* 1e-6;
    delta_cv = getpv(pv_name.delta_kicks_cv)' .* 1e-6;
end