function BBAResults = BBASinglePass(MD, m_corr)
    mili = 1e-3; micro = 1e-6;
    
    fam = sirius_si_family_data(MD.Ring);
    bpm = fam.BPM.ATIndex;
    quad = fam.QN.ATIndex;
    sext = fam.SN.ATIndex;
    % TURN OFF SEXTUPOLES
    MD.Ring = setcellstruct(MD.Ring, 'PolynomB', sext, 0, 1, 3);
    ch = fam.CH.ATIndex;
    cv = fam.CV.ATIndex;
    bba_ind = get_bba_ind(MD.Ring, bpm, quad);

    m_corr_x = m_corr(1:length(bpm), 1:length(ch));
    m_corr_y = m_corr(length(bpm)+1: end, length(ch)+1:end-1);

    % m_corr_x_sort = sort(abs(m_corr_x), 2, 'descend');
    % m_corr_y_sort = sort(abs(m_corr_y), 2, 'descend');

    [~ , ind_best_x] = max(abs(m_corr_x), [], 2);
    [~ , ind_best_y] = max(abs(m_corr_y), [], 2);
    
    DeltaBPM = 2 * mili;
    NPoints = 11;
    DeltaKickX = 200e-6;
    DeltaKickY = 100e-6;
    BPMBegin = 2;
    BPMEnd = 159;
    
    %%%%% HORIZONTAL %%%%%
    for BPMi = BPMBegin:BPMEnd
        % DeltaKick = DeltaBPM / m_corr_x(BPMi, ind_best_x(BPMi));
        HKick0 = lnls_get_kickangle(MD.Ring, ch(ind_best_x(BPMi)), 'x');
        ThetaMin = -DeltaKickX;
        ThetaMax = +DeltaKickX;
        DeltaKick1{BPMi} = HKick0 + linspace(ThetaMin, ThetaMax, NPoints);
        [RNormalKX, DeltaRX] = SiComm.injection.si.BBALoop(MD, bba_ind, ind_best_x, DeltaKick1{BPMi}, BPMi, fam, 'x');
        BBAResultsX{BPMi} = SiComm.injection.si.BBAAnalysis(RNormalKX, DeltaRX, BPMi, 'x', 'plot');       
    end
    
    %%%%% VERTICAL %%%%%
    for BPMi = BPMBegin:BPMEnd
        % DeltaKick = DeltaBPM / m_corr_x(BPMi, ind_best_x(BPMi));
        VKick0 = lnls_get_kickangle(MD.Ring, cv(ind_best_y(BPMi)), 'y');
        ThetaMin = -DeltaKickY;
        ThetaMax = +DeltaKickY;
        DeltaKick1{BPMi} = VKick0 + linspace(ThetaMin, ThetaMax, NPoints);
        [RNormalKY, DeltaRY] = SiComm.injection.si.BBALoop(MD, bba_ind, ind_best_y, DeltaKick1{BPMi}, BPMi, fam, 'y');
        BBAResultsY{BPMi} = SiComm.injection.si.BBAAnalysis(RNormalKY, DeltaRY, BPMi, 'y', 'plot');       
    end
    BBAResults = BBAResultsX;
    
    for BPMi = BPMBegin:BPMEnd
        BBAResults{BPMi}.QuadraticFit.BPMOffsetY = BBAResultsY{BPMi}.QuadraticFit.BPMOffsetY;
        BBAResults{BPMi}.QuadraticFit.ErrorY = BBAResultsY{BPMi}.QuadraticFit.ErrorY;

        BBAResults{BPMi}.LinearFit.BPMOffsetY = BBAResultsY{BPMi}.LinearFit.BPMOffsetY;
        BBAResults{BPMi}.LinearFit.ErrorY = BBAResultsY{BPMi}.LinearFit.ErrorY;
    end
    
%     for BPMi = 2:12
%         % DeltaKick = DeltaBPM / m_corr_x(BPMi, ind_best_x(BPMi));
%         GrtIdx = find(RNormalK(:, 1, BPMi) < BBAResults{BPMi}.QuadraticFit.BPMOffsetX);
%         dtheta_corr = DeltaKick1{BPMi};
%         if ~isempty(GrtIdx)
%            if GrtIdx(end) == NPoints
%                ThetaMid = dtheta_corr(end);
%            else
%                ThetaMid = (dtheta_corr(GrtIdx(end)+1) + dtheta_corr(GrtIdx(end)))/2;
%            end
%         else
%             ThetaMid = dtheta_corr(1);
%         end
%                 
%         ThetaMin = -MaxDeltaKick;
%         ThetaMax = +MaxDeltaKick;
%         DeltaKick2 = ThetaMid + linspace(ThetaMin, ThetaMax, 2*NPoints+1);
%         [RNormalK_run2, DeltaR] = SiComm.injection.si.BBALoop(MD, bba_ind, ind_best_x, DeltaKick2, BPMi, fam, 'x');
%         BBAResults{BPMi} = SiComm.injection.si.BBAAnalysis(RNormalK_run2, DeltaR, BPMi, 'x', 'plot');       
%    end
    
end
