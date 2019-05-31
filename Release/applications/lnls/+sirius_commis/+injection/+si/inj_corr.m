function [param_out, machine] = inj_corr(machine, param, param_errors, n_part, n_pulse, minj)
    fam = sirius_si_family_data(machine);
    nch = length(fam.CH.ATIndex(:));
    ncv = length(fam.CV.ATIndex(:));
    r = sirius_commis.injection.si.multiple_pulse(machine, param, param_errors, n_part, n_pulse, length(machine), 'on', 'plot', 'diag');
    r_bpm = r.r_bpm;
    sum_bpm = r.sum_bpm;
    ind = sum_bpm == 1;
    n_bpm_old = sum(ind);
    n_bpm_new = n_bpm_old;
    
    rmsx_old = nanstd(r_bpm(1, :));
    rmsy_old = nanstd(r_bpm(2, :));
    rmsx_new = rmsx_old; rmsy_new = rmsy_old;
    
    [U, S, V] = svd(minj, 'econ');
    S_inv = 1 ./ diag(S);
    S_inv(isinf(S_inv)) = 0;
    S_inv = diag(S_inv);
    % S_inv(280+1:end) = 0;
    minj_inv = V * S_inv * U';
    
    theta_x = lnls_get_kickangle(machine, fam.CH.ATIndex(:), 'x');
    theta_y = lnls_get_kickangle(machine, fam.CV.ATIndex(:), 'y');
    corr_lim = 300e-6;
    rms_reduc = true;

    while n_bpm_new >= n_bpm_old || rms_reduc % rmsx_new <= rmsx_old && rmsy_new <= rmsy_old
        n_bpm_old = n_bpm_new;
        rmsx_old = rmsx_new;
        rmsy_old = rmsy_new;
        r_bpm(:, ~ind) = 0;
        xbpm = squeeze(r_bpm(1, :));
        ybpm = squeeze(r_bpm(2, :));
        new_r = [xbpm, ybpm]';
        new_r(isnan(new_r)) = 0;
        delta = - minj_inv * new_r;

        delta_xl = delta(1);
        delta_yl = delta(2);
        delta_kckr = delta(3);
        delta_thetax = delta(4:nch+3);
        delta_thetay = delta(nch + 4:end - 1);
        
        theta_x = theta_x + delta_thetax';
        theta_y = theta_y + delta_thetay';
       
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
        
        machine = lnls_set_kickangle(machine, theta_x, fam.CH.ATIndex(:), 'x');
        machine = lnls_set_kickangle(machine, theta_y, fam.CV.ATIndex(:), 'y');

        param.offset_xl_syst= param.offset_xl_syst + delta_xl;
        param.offset_yl_syst= param.offset_yl_syst + delta_yl;
        param.kckr_syst = param.kckr_syst + delta_kckr;
        r = sirius_commis.injection.si.multiple_pulse(machine, param, param_errors, n_part, n_pulse, length(machine), 'on', 'plot', 'diag');
        r_bpm = r.r_bpm;
        rmsx_new = nanstd(r_bpm(1, :));
        rmsy_new = nanstd(r_bpm(2, :));
        sum_bpm = r.sum_bpm;
        ind = sum_bpm == 1;
        n_bpm_new = sum(ind);
        ind = sum_bpm == 1;
        
        if n_bpm_new == n_bpm_old
            if rmsx_new < rmsx_old || rmsy_new < rmsy_old
                rms_reduc = true;
            else
                rms_reduc = false;
            end
        elseif n_bpm_new < n_bpm_old
            rms_reduc = false;
        end
            
        % ind = ind(1:3);
        % minj = sirius_commis.injection.si.calc_respm_inj(machine, param, param_errors, n_part);
    end
    
    theta_x = theta_x - delta_thetax';
    theta_y = theta_y - delta_thetay';
    machine = lnls_set_kickangle(machine, theta_x, fam.CH.ATIndex(:), 'x');
    machine = lnls_set_kickangle(machine, theta_y, fam.CV.ATIndex(:), 'y');
    
    param.offset_xl_syst= param.offset_xl_syst - delta_xl;
    param.offset_yl_syst= param.offset_yl_syst - delta_yl;
    param.kckr_syst = param.kckr_syst - delta_kckr;
    param_out = param;
   
    
end

