function MDBBA = BBAInfo(MD, BBAResults)
    fam = sirius_si_family_data(MD.Ring);
    BPM = fam.BPM.ATIndex;
    QIdx = fam.QN.ATIndex;
    BPMOffset = getcellstruct(MD.Ring, 'Offsets', BPM);
    BPMOffset = cell2mat(BPMOffset)';
    BBAIdx = get_bba_ind(MD.Ring, BPM, QIdx);
    HQOffset = getcellstruct(MD.Ring, 'T2', BBAIdx, 1, 1);
    VQOffset = getcellstruct(MD.Ring, 'T2', BBAIdx, 1, 3);
    QOffset = [HQOffset, VQOffset]';    
    MDBBA = MD;
    
    if ~exist('BBAResults', 'var')
        
        if isfield(MD.Ring{BPM(1)}, 'BBAOffsets')
            BBAOffset = getcellstruct(MD.Ring, 'BBAOffsets', BPM);
            BBAOffset = cell2mat(BBAOffset)';
        else
            BBAOffset = zeros(2, length(BPM));
        end

        for k = 1:length(BPM)
            % QuadBPMOffsetX(k) = BBAResults{k}.QuadraticFit.BPMOffsetX;
            LinBPMOffsetX(k) = BBAOffset(1, k);
            RealBPMOffsetX(k) = QOffset(1, k) - BPMOffset(1, k);
            LinBPMOffsetY(k) = BBAOffset(2, k);
            RealBPMOffsetY(k) = QOffset(2, k) - BPMOffset(1, k);
        end

        figure; % plot(QuadBPMOffsetX * 1e6, '-bo')
        hold all;
        plot(abs(LinBPMOffsetX) * 1e6, '-ro');
        plot(abs(RealBPMOffsetX) * 1e6, '-ko');
        plot(-abs(LinBPMOffsetY) * 1e6, '-ro');
        plot(-abs(RealBPMOffsetY) * 1e6, '-ko');
        % legend('Quadratic', 'Linear', 'Real');
        title('BPMs Offsets comparison BBA x Real');
        ylabel('BPM Offset [um]');
        grid on;

    else      
    
        NData = length(BBAResults);

        for k = 2:NData
            % QuadBPMOffsetX(k) = BBAResults{k}.QuadraticFit.BPMOffsetX;
            LinBPMOffsetX(k) = BBAResults{k}.LinearFit.BPMOffsetX;
            QuadBPMOffsetX(k) = BBAResults{k}.QuadraticFit.BPMOffsetX;
            RealBPMOffsetX(k) = QOffset(1, k) - BPMOffset(1, k);
            LinBPMOffsetY(k) = BBAResults{k}.LinearFit.BPMOffsetY;
            QuadBPMOffsetY(k) = BBAResults{k}.QuadraticFit.BPMOffsetY;
            RealBPMOffsetY(k) = QOffset(2, k) - BPMOffset(1, k);
        end

        figure; plot(abs(QuadBPMOffsetX) * 1e6, '-bo')
        hold all;
        plot(abs(LinBPMOffsetX) * 1e6, '-ro');
        plot(abs(RealBPMOffsetX) * 1e6, '-ko');
        plot(-abs(LinBPMOffsetY) * 1e6, '-ro');
        plot(-abs(QuadBPMOffsetY) * 1e6, '-bo')
        plot(-abs(RealBPMOffsetY) * 1e6, '-ko');
        legend('Quadratic', 'Linear', 'Real');
        title('BPMs Offsets comparison BBA x Real');
        ylabel('BPM Offset [um]');
        grid on;

        for BPMIdx = 1:length(BPM)
           MDBBA.Ring{BPM(BPMIdx)}.BBAOffsets = [0, 0];  
        end

        MaxBBAOffset = 500e-6;
        LinBPMOffsetX(abs(LinBPMOffsetX) > MaxBBAOffset) = 0;
        LinBPMOffsetY(abs(LinBPMOffsetY) > MaxBBAOffset) = 0;
        for k = 2:NData
           MDBBA.Ring{BPM(k)}.BBAOffsets = [LinBPMOffsetX(k), LinBPMOffsetY(k)]; 
        end
    end
    
%     figure; plot(abs(QuadBPMOffsetX - LinBPMOffsetX) * 1e6, '-o')
%     title('Difference between two fitting methods');   
%     ylabel('Difference [um]');
%     grid on;
    
    figure; % plot(abs(QuadBPMOffsetX - RealBPMOffsetX) * 1e6, '-bo')
    hold all;
    plot(abs(LinBPMOffsetX-RealBPMOffsetX) * 1e6, '-ro');
    % plot(-abs(QuadBPMOffsetY - RealBPMOffsetY) * 1e6, '-bo')
    plot(-abs(LinBPMOffsetY-RealBPMOffsetY) * 1e6, '-ro');
    % legend('Quadratic', 'Linear');
    title('Absolute Error');
    ylabel('Offset Error [um]');
    grid on;
end

