function [TrajCorr, MDFirstTurn] = TrajectoryCorrection(MD, m_corr, NumSingVal)
    
    fam = sirius_si_family_data(MD.Ring);
    ch = fam.CH.ATIndex;
    cv = fam.CV.ATIndex;
    bpm = fam.BPM.ATIndex;
    flag_error = 'errorON';
    
    % Turning off Sextupoles
    MD.Ring = setcellstruct(MD.Ring, 'PolynomB', fam.SN.ATIndex, 0, 1, 3);

    theta_x = lnls_get_kickangle(MD.Ring, ch, 'x')';
    theta_y = lnls_get_kickangle(MD.Ring, cv, 'y')';
    
    MD = SiComm.injection.si.MultiplePulse(MD, length(MD.Ring), 'plot', 'kickerON', flag_error);
    
    for PulseIdx = 1:MD.Inj.NPulses
        BPMPbP(PulseIdx, :, :) = MD.PulseByPulse{PulseIdx}.BPMPos;
        SumPbP(PulseIdx, :, :) = MD.PulseByPulse{PulseIdx}.BPMSum;
    end
    
    r_bpm = squeeze(nanmean(BPMPbP, 1));
    int_bpm = squeeze(nanmean(SumPbP, 1));
    r_bpm = r_bpm(:, 1:length(bpm));
    int_bpm = int_bpm(1:length(bpm));
    
    bestSum = int_bpm(end);
    
    corr_max = 300e-6;
    corr_lim = corr_max*0.25;

    eff_lim = 0.5;
    CorrIdx = 1;
    NIter = 20;
    
    TrajCorr.error = false;
   
    while CorrIdx < NIter % int_bpm(end) < eff_lim
        corr_lim = corr_lim * (1 + CorrIdx);
        if corr_lim >= corr_max
           corr_lim = corr_max; 
        end
        bpm_int_ok = bpm(int_bpm > 0.25);
        [~, ind_ok_bpm] = intersect(bpm, bpm_int_ok);

        bpm_select = zeros(length(bpm), 1);
        bpm_select(ind_ok_bpm) = 1;

        m_corr_ok = m_corr([ind_ok_bpm; length(bpm) + ind_ok_bpm], :);
        [U, S, V] = svd(m_corr_ok, 'econ');
        S_inv = 1 ./ diag(S);
        S_inv(isinf(S_inv)) = 0;
        if NumSingVal > length(S_inv)
            NumSingVal = length(S_inv);
        end
        S_inv(NumSingVal+1:end) = 0;
        % S_inv(1:NumSingVal) = (S_inv(1:NumSingVal).^2 + alpha^2) ./ S_inv(1:NumSingVal);
        S_inv = diag(S_inv);
        m_corr_inv = V * S_inv * U';
        x_bpm = squeeze(r_bpm(1, ind_ok_bpm));
        y_bpm = squeeze(r_bpm(2, ind_ok_bpm));
        new_r_bpm = [x_bpm, y_bpm];
        delta_kick = - m_corr_inv * new_r_bpm';
        theta_x = theta_x + delta_kick(1:length(ch));
        theta_y = theta_y + delta_kick(length(ch)+1:end-1);

        % Particular method that works when there is no coupling, a more
        % generic method of inversion is used in accordance with SOFB

        %{
        m_corr_x_ok = m_corr_x(ind_ok_bpm, :);
        [Ux, Sx, Vx] = svd(m_corr_x_ok, 'econ');
        Sx_inv = 1 ./ diag(Sx);
        Sx_inv(isinf(Sx_inv)) = 0;
        Sx_inv(NumSingVal+1:end) = 0;
        % Sx_inv(Sx_inv > 5 * Sx_inv(1)) = 0;
        Sx_inv = diag(Sx_inv);
        m_corr_inv_x = Vx * Sx_inv * Ux';

        x_bpm = squeeze(r_bpm(1, ind_ok_bpm));
        theta_x =  theta_x - m_corr_inv_x * x_bpm';

        m_corr_y_ok = m_corr_y(ind_ok_bpm, :);
        [Uy, Sy, Vy] = svd(m_corr_y_ok, 'econ');
        Sy_inv = 1 ./ diag(Sy);
        Sy_inv(isinf(Sy_inv)) = 0;
        Sy_inv(NumSingVal+1:end) = 0;
        % Sy_inv(Sy_inv > 5 * Sy_inv(1)) = 0;
        Sy_inv = diag(Sy_inv);
        m_corr_inv_y = Vy * Sy_inv * Uy';

        y_bpm = squeeze(r_bpm(2, ind_ok_bpm));
        theta_y = theta_y - m_corr_inv_y * y_bpm';
        %}

        over_kick_x = abs(theta_x) > corr_lim;
        if any(over_kick_x)
            warning('Horizontal corrector kick greater than maximum')
            theta_x(over_kick_x) =  sign(theta_x(over_kick_x)) * corr_lim;
        end

        over_kick_y = abs(theta_y) > corr_lim;
        if any(over_kick_y)
            warning('Vertical corrector kick greater than maximum')
            theta_y(over_kick_y) =  sign(theta_y(over_kick_y)) * corr_lim;
        end

        MD.Ring = lnls_set_kickangle(MD.Ring, theta_x, ch, 'x');
        MD.Ring = lnls_set_kickangle(MD.Ring, theta_y, cv, 'y');

        MD = SiComm.injection.si.MultiplePulse(MD, length(MD.Ring), 'plot', 'kickerON', flag_error);
        r_bpm = MD.PulseByPulse{1}.BPMPos;
        int_bpm = MD.PulseByPulse{1}.BPMSum;
        r_bpm = r_bpm(:, 1:length(bpm));
        int_bpm = int_bpm(1:length(bpm));
        
        CorrIdx = CorrIdx + 1;
        NumSingVal = NumSingVal + 5;
                
        if int_bpm(end) < bestSum
            theta_x = theta_x - delta_kick(1:length(ch));
            theta_y = theta_y - delta_kick(length(ch)+1:end-1);
            break
        end
        
%         if int_bpm(end) == 1
%             break
%         end
        
        if int_bpm(end) > bestSum
            bestSum = int_bpm(end);
        end            
    end
    
    TrajCorr.HKick = theta_x;
    TrajCorr.VKick = theta_y;
    
    MDFirstTurn = SiComm.injection.si.KickAnalysis(TrajCorr, MD);
    
end

function [param, cod_data, first_cod] = checknan(machine, param, fam, first_cod, cod_data)
    if first_cod
        orbit = findorbit4(machine, 0, 1:length(machine));
        param.orbit = orbit;
        return
    end
    orbit = findorbit4(machine, 0, 1:length(machine));
    param.orbit = orbit;
    cod_nan = sum(isnan(orbit(:))) > 0;
    if ~cod_nan
        theta_x = lnls_get_kickangle(machine, fam.CH.ATIndex, 'x')';
        theta_y = lnls_get_kickangle(machine, fam.CV.ATIndex, 'y')';
        rms_x = nanstd(orbit(1, :));   rms_y = nanstd(orbit(3, :));
        cod_data.kickx = theta_x;   cod_data.kicky = theta_y;
        cod_data.rms_x = rms_x;     cod_data.rms_y = rms_y;
        cod_data.orbit = orbit;
        first_cod = true;
    end
end
