function MD = getBPMPos(MD, flag_TbT)
    BPMIdx = findcells(MD.Ring, 'FamName', 'BPM');
    BPMNum = length(BPMIdx);
    RingLen = length(MD.Ring);
    if isfield(MD.Ring{BPMIdx(1)}, 'Offsets')
        BPMOffset = getcellstruct(MD.Ring, 'Offsets', BPMIdx);
        BPMOffset = cell2mat(BPMOffset)';
    else
        BPMOffset = zeros(2, length(BPMIdx));
    end
    
    if isfield(MD.Ring{BPMIdx(1)}, 'BBAOffsets')
        BBAOffset = getcellstruct(MD.Ring, 'BBAOffsets', BPMIdx);
        BBAOffset = cell2mat(BBAOffset)';
    else
        BBAOffset = zeros(2, length(BPMIdx));
    end
    
    PbP_Error = 0; 
    if flag_TbT
        % Beam Position @ BPMs
        MD.TurnByTurn.BPMPos = NaN(2, BPMNum * MD.Inj.NTurns);
        MD.TurnByTurn.BPMSum = zeros(1, BPMNum * MD.Inj.NTurns);
        if ~isempty(BPMIdx)
            %Calculates the intensity dependent error in the BPM measurement
            for k = 1:MD.Inj.NTurns
                Init = (k-1)*BPMNum + 1;
                End = k*BPMNum;
                PosAtBPMs = MD.RTurns([1,3], :, BPMIdx + (k-1) * RingLen);
                [BPMErr, BPMSum] = SiComm.common.bpm_error_inten(PosAtBPMs, MD.Beam.NPart, MD.Err.sigma_bpm);
                MD.TurnByTurn.BPMSum(:, Init:End) = BPMSum';
                
                if MD.Beam.NPart > 1
                    MD.TurnByTurn.BPMPos(:, Init:End) = squeeze(nanmean(PosAtBPMs, 2));
                else
                    MD.TurnByTurn.BPMPos(:, Init:End) = squeeze(PosAtBPMs);
                end

                MD.TurnByTurn.BPMPos(:, Init:End) = MD.TurnByTurn.BPMPos(:, Init:End) - (BPMOffset + BBAOffset);
                MD.TurnByTurn.BPMPos(:, Init:End) = MD.TurnByTurn.BPMPos(:, Init:End) + PbP_Error * BPMErr;
                if k > MD.Inj.CompletedTurns
                    break
                end
            end
        end
        MD = rmfield(MD, 'RTurns');
    else
        % Beam Position @ BPMs
        if ~isempty(BPMIdx)
            %Calculates the intensity dependent error in the BPM measurement
            point = size(MD.TrackPos, 3);
            BPMIdx = BPMIdx(BPMIdx < point);
            PosAtBPMs = MD.TrackPos([1,3], :, BPMIdx);
            [BPMErr, BPMSum] = SiComm.common.bpm_error_inten(PosAtBPMs, MD.Beam.NPart, MD.Err.sigma_bpm);
            MD.BPMSum = BPMSum';
            if MD.Beam.NPart > 1
                MD.BPMPos = squeeze(nanmean(PosAtBPMs, 2));
            else
                MD.BPMPos = squeeze(PosAtBPMs);
            end

            MD.BPMPos = MD.BPMPos - (BPMOffset + BBAOffset);
            MD.BPMPos = MD.BPMPos + PbP_Error * BPMErr;
        end
    end
end