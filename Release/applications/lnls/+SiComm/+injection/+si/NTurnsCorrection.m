function MDNTurns = NTurnsCorrection(MD, m_corr, NumSingVal)

    fam = sirius_si_family_data(MD.Ring);
    CH = fam.CH.ATIndex;
    CV = fam.CV.ATIndex;
    BPMIdx = fam.BPM.ATIndex;
    flag_error = 'errorON';
    
    TurnIdx = zeros(1, MD.Inj.NTurns);
    for k = 1:MD.Inj.NTurns
        TurnIdx(k) = (k-1)*length(MD.Ring); 
    end
    bpm = bsxfun(@plus, BPMIdx, TurnIdx);
    bpm = reshape(bpm, 1, []);
    
    theta_x = lnls_get_kickangle(MD.Ring, CH, 'x')';
    theta_y = lnls_get_kickangle(MD.Ring, CV, 'y')';
    n_bpm = length(bpm);
    MD = SiComm.injection.si.MultiplePulse(MD, length(MD.Ring), 'plot', 'kickerON', flag_error);

    corr_lim = 300e-6;

    for PulseIdx = 1:MD.Inj.NPulses
        BPMPbP(PulseIdx, :, :) = MD.PulseByPulse{PulseIdx}.BPMPos;
        SumPbP(PulseIdx, :, :) = MD.PulseByPulse{PulseIdx}.BPMSum;
    end
    
    r_bpm = squeeze(nanmean(BPMPbP, 1));
    int_bpm = squeeze(nanmean(SumPbP, 1));
    
    bestSum = int_bpm(end);
    
    corr_max = 300e-6;
    corr_lim = corr_max/10;

    eff_lim = 0.5;
    CorrIdx = 1;
    NIter = 50;
    
    TrajCorr.error = false;
   
    while CorrIdx < NIter % int_bpm(end) < eff_lim
        corr_lim = corr_lim * (1 + 0.05);
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
        theta_x = theta_x + delta_kick(1:length(CH));
        theta_y = theta_y + delta_kick(length(CH)+1:end-1);

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

        MD.Ring = lnls_set_kickangle(MD.Ring, theta_x, CH, 'x');
        MD.Ring = lnls_set_kickangle(MD.Ring, theta_y, CV, 'y');

        MD = SiComm.injection.si.MultiplePulse(MD, length(MD.Ring), 'plot', 'kickerON', flag_error);
        r_bpm = MD.PulseByPulse{1}.BPMPos;
        int_bpm = MD.PulseByPulse{1}.BPMSum;
        
        CorrIdx = CorrIdx + 1;
        NumSingVal = NumSingVal + 1;
    end
    
    TrajCorr.HKick = theta_x;
    TrajCorr.VKick = theta_y;
end

% function [param, cod_data, first_cod] = CHecknan(maCHine, param, fam, first_cod, cod_data)
%         if first_cod
%             orbit = findorbit4(maCHine, 0, 1:length(maCHine));
%             param.orbit = orbit;
%             return
%         end
%         orbit = findorbit4(maCHine, 0, 1:length(maCHine));
%         param.orbit = orbit;
%         cod_nan = sum(isnan(orbit(:))) > 0;
%         if ~cod_nan
%             theta_x = lnls_get_kickangle(maCHine, fam.CH.ATIndex, 'x')';
%             theta_y = lnls_get_kickangle(maCHine, fam.CV.ATIndex, 'y')';
%             rms_x = nanstd(orbit(1, :));   rms_y = nanstd(orbit(3, :));
%             cod_data.kickx = theta_x;   cod_data.kicky = theta_y;
%             cod_data.rms_x = rms_x;     cod_data.rms_y = rms_y;
%             cod_data.orbit = orbit;
%             first_cod = true;
%         end
% end