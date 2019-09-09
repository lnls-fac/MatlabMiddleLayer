function MDInjOpt = InjCorrection(MD)
    s = findspos(MD.Ring, 1:length(MD.Ring));
    injkckr = findcells(MD.Ring, 'FamName', 'InjDpKckr');
    bpm = findcells(MD.Ring, 'FamName', 'BPM');
    L_kckr = MD.Ring{injkckr}.Length;
    D = s(bpm(1)) - s(injkckr) - L_kckr/2; % Adjustment to particles reach x=0 at kicker center
    XGoal = tan(-MD.Inj.R0.kckr0) * D;
    
%     MD.Inj.R.offset_x_syst= MD.Inj.R.offset_x_syst + delta(1);
%     MD.Inj.R.offset_xl_syst= MD.Inj.R.offset_xl_syst + delta(2);
%     MD.Inj.R.offset_y_syst= MD.Inj.R.offset_y_syst + delta(3);
%     MD.Inj.R.offset_yl_syst= MD.Inj.R.offset_yl_syst + delta(4);
%     MD.Inj.R.kckr_syst = MD.Inj.R.kckr_syst + delta(5);
    for k = 1:10
        MD = SiComm.injection.si.MultiplePulse(MD, length(MD.Ring), 'plot', 'kickerOFF', 'errorON');

        for PulseIdx = 1:MD.Inj.NPulses
            BPMPbP(PulseIdx, :, :) = MD.PulseByPulse{PulseIdx}.BPMPos;
            SumPbP(PulseIdx, :, :) = MD.PulseByPulse{PulseIdx}.BPMSum;
        end

        r_bpm = squeeze(nanmean(BPMPbP, 1));
        % sum_bpm = squeeze(nanmean(SumPbP, 1));

        DX = r_bpm(1, 1) - XGoal;
        if abs(DX) < 500e-6
            break
        end
        DY = r_bpm(2, 1);

        DXL = - DX/s(bpm(1));
        DYL = - DY/s(bpm(1));

        MD.Inj.R.offset_xl_syst= MD.Inj.R.offset_xl_syst + DXL;
        MD.Inj.R.offset_yl_syst= MD.Inj.R.offset_yl_syst + DYL;
    end
    
    for k = 1:100
        MD = SiComm.injection.si.MultiplePulse(MD, length(MD.Ring), 'plot', 'kickerON', 'errorON');

        for PulseIdx = 1:MD.Inj.NPulses
            BPMPbP(PulseIdx, :, :) = MD.PulseByPulse{PulseIdx}.BPMPos;
            SumPbP(PulseIdx, :, :) = MD.PulseByPulse{PulseIdx}.BPMSum;
        end

        r_bpm = squeeze(nanmean(BPMPbP, 1));
        % sum_bpm = squeeze(nanmean(SumPbP, 1));

        DX = r_bpm(1, 1);
        if abs(DX) < 500e-6
             break
        end
        DY = r_bpm(2, 1);

        DXL = -DX/s(bpm(1));
        DYL = -DY/s(bpm(1));
        
        % DX = r_bpm(1, 1);

        MD.Inj.R.kckr_syst = MD.Inj.R.kckr_syst + DXL;
        MD.Inj.R.offset_yl_syst= MD.Inj.R.offset_yl_syst + DYL;
    end
    
    MDInjOpt = MD;
end