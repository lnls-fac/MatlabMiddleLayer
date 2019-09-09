function [RNormalK, DeltaR, fail] = BBALoop(MD, bba_ind, ind_best, dtheta_corr, n_bpm, fam, plane)
    % quad_skew = fam.QS.ATIndex;
    % skew = ismember(bba_ind(n_bpm), quad_skew);

    InitRing = MD.Ring;
    n_points = length(dtheta_corr);
    

    skew = false;
    if strcmp(plane, 'x')
        if skew
            flag_x = false;
        else
            flag_x = true;
        end
    elseif strcmp(plane, 'y')
        if skew
            flag_x = true;
        else
            flag_x = false;
        end
    end

    % if strcmp(method, 'quad')
    %     flag_quad = true;
    % else
    %     flag_quad = false;
    % end

    if flag_x
        corr = fam.CH.ATIndex;
    else
        corr = fam.CV.ATIndex;
    end
    
    bpm = fam.BPM.ATIndex;
    % skew_lim = 0.0667;
    quad_lim1 = 3.72;
    quad_lim2 = 4.54;

    q20 = sort([fam.QDA.ATIndex; fam.QDB1.ATIndex; fam.QDB2.ATIndex; fam.QDP1.ATIndex; fam.QDP2.ATIndex]);

    if ismember(bba_ind(n_bpm), q20)
        quad_lim = quad_lim1;
    else
        quad_lim = quad_lim2;
    end

    if skew
        polyA = getcellstruct(MD.Ring, 'PolynomA', bba_ind(n_bpm), 1, 2);
        polyA_bba = skew_lim;
        if abs(polyA_bba) > skew_lim
            polyA_bba = sign(polyA_bba) * skew_lim;
            warning('Skew Quadrupole Strength greater than maximum');
        end
    else
        polyB = getcellstruct(MD.Ring, 'PolynomB', bba_ind(n_bpm), 1, 2);
        % polyBUp = 1.25 * polyB;
        polyBDown = 0.90 * polyB;
%         if abs(polyBUp) > quad_lim
%             polyBUp = sign(polyBUp) * quad_lim;
%             warning('Quadrupole Strength greater than maximum');
%         end
    end

    bpm_bba = bpm(bpm > bba_ind(n_bpm));
    [~, ind_bpm_bba] = intersect(bpm, bpm_bba);
    fail = false;

    for ii = 1:n_points
        if fail
            return
        end
            if n_bpm > 1
                machine = lnls_set_kickangle(MD.Ring, dtheta_corr(ii), corr(ind_best(n_bpm)), plane);
            end

            if skew
                machineDown = setcellstruct(machine, 'PolynomA', bba_ind(n_bpm), polyADown, 1, 2);
                machineUp = setcellstruct(machine, 'PolynomA', bba_ind(n_bpm), polyAUp, 1, 2);
            else
                machineDown = setcellstruct(machine, 'PolynomB', bba_ind(n_bpm), polyBDown, 1, 2);
                % machineUp = setcellstruct(machine, 'PolynomB', bba_ind(n_bpm), polyBUp, 1, 2);
            end

            MD.Ring = machine;
            MDNormalK = SiComm.injection.si.MultiplePulse(MD, length(MD.Ring), 'plot', 'kickerON', 'errorON');
            MD.Ring = machineDown;
            MDDown = SiComm.injection.si.MultiplePulse(MD, length(MD.Ring), 'plot', 'kickerON', 'errorON');
            MD.Ring = InitRing;

            fprintf('================================================\n');
            fprintf('CORRECTOR CHANGE NUMBER # %i / %i \n', ii, n_points);
            fprintf('================================================\n');
            
            for PulseIdx = 1:MD.Inj.NPulses
                BPMNormalK(PulseIdx, :, :) = MDNormalK.PulseByPulse{PulseIdx}.BPMPos;
                BPMDownK(PulseIdx, :, :) = MDDown.PulseByPulse{PulseIdx}.BPMPos;
            end
            
            BPMNormalK = squeeze(nanmean(BPMNormalK, 1));
            BPMDownK = squeeze(nanmean(BPMDownK, 1));
            
            DeltaR(ii, :, :) = BPMNormalK - BPMDownK;
            RNormalK(ii, :, :) = BPMNormalK;
            
            clear BPMNormalK
            clear BPMDownK
    end
end