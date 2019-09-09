function MDKick = KickAnalysis(KickData, MD)
    urad = 1e6;
    NRandMach = length(KickData); 
    if NRandMach > 1
        fam = sirius_si_family_data(MD{1}.Ring);

        CH = fam.CH.ATIndex;
        CV = fam.CV.ATIndex;
        MDKick = MD;
        HKickRand = zeros(NRandMach, length(CH));
        VKickRand = zeros(NRandMach, length(CV));

        figure;
        hold all;
        for RandMachIdx = 1:NRandMach
            HKick = KickData{RandMachIdx}.HKick;
            VKick = KickData{RandMachIdx}.VKick;
            MDKick{RandMachIdx}.Ring = lnls_set_kickangle(MD{RandMachIdx}.Ring, HKick, CH, 'x');
            MDKick{RandMachIdx}.Ring = lnls_set_kickangle(MD{RandMachIdx}.Ring, VKick, CV, 'y');
            plot(abs(HKick) * urad, '--', 'LineWidth', 1, 'color', [0.5 0.5 1.0])
            plot(-abs(VKick) * urad, '--', 'LineWidth', 1, 'color', [1.0 0.5 0.5])
            HKickRand(RandMachIdx, :) = HKick;
            VKickRand(RandMachIdx, :) = VKick;
        end

        plot(std(HKickRand, 0, 1) * urad, 'LineWidth', 2, 'color', [0 0 1.0])
        plot(-std(VKickRand, 0, 1) * urad, 'LineWidth', 2, 'color', [1.0 0 0])
    else
        fam = sirius_si_family_data(MD.Ring);

        CH = fam.CH.ATIndex;
        CV = fam.CV.ATIndex;
        MDKick = MD;
        HKick = KickData.HKick;
        VKick = KickData.VKick;
        MDKick.Ring = lnls_set_kickangle(MD.Ring, HKick, CH, 'x');
        MDKick.Ring = lnls_set_kickangle(MD.Ring, VKick, CV, 'y');
    end
end

