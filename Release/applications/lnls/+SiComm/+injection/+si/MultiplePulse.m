function MD = MultiplePulse(MD, point, flag_plot, flag_kckr, flag_error)
% SiComm.common.initializations();
flag_TbT = false;
    for j=1:MD.Inj.NPulses
        MDPbP = SiComm.injection.si.SinglePulse(MD, point, flag_kckr, flag_error);
        
        if isfield(MDPbP, 'TurnByTurn')
            flag_TbT = true;
        end
        
        if ~mod(j, 10)
            fprintf('. %i pulses \n', j);
        else
            fprintf('.');
        end
        
        if flag_TbT
            MD.PulseByPulse{j}.BPMPos = MDPbP.TurnByTurn.BPMPos;
            MD.PulseByPulse{j}.BPMSum = MDPbP.TurnByTurn.BPMSum;
            MD.PulseByPulse{j}.Efficiency = MDPbP.TurnByTurn.Efficiency;
            MD.PulseByPulse{j}.CompletedTurns = MDPbP.Inj.CompletedTurns;
        else
            MD.PulseByPulse{j}.BPMPos = MDPbP.BPMPos;
            MD.PulseByPulse{j}.BPMSum = MDPbP.BPMSum;
            MD.PulseByPulse{j}.Efficiency = MDPbP.Efficiency;
        end
        
        if strcmp(flag_plot, 'plot')
            if flag_TbT
                LRing = length(MD.Ring);
                RingExtend = cell(1, LRing * MD.Inj.NTurns);
                for k = 1:MD.Inj.NTurns
                   RingExtend(1+(k-1)*LRing:k*LRing) = MD.Ring;
                end
                COD4D = repmat(MD.COD4D, 1, MD.Inj.NTurns);
                SiComm.common.plot_bpms(RingExtend, COD4D, MDPbP.TurnByTurn.BPMPos, MDPbP.TurnByTurn.BPMSum);
            else
                SiComm.common.plot_bpms(MD.Ring, MD.COD4D, MDPbP.BPMPos, MDPbP.BPMSum);
            end
        end
    end
end

% function plot_si_turn(machine, r_final)
%     VChamb = cell2mat(getcellstruct(machine, 'VChamber', 1:size(r_final, 3)))';
%     s = findspos(machine, 1:size(r_final, 3));
%     xx = squeeze(nanmean(r_final(1, :, :), 2));
%     sxx = squeeze(nanstd(r_final(1, :, :), 0, 2));
%     yy = squeeze(nanmean(r_final(2, :, :), 2));
%     syy = squeeze(nanstd(r_final(2, :, :), 0, 2));
%     gcf();
%     ax1a = subplottight(2,1,1, 'vspace', 0.05);
%     ax2a = subplottight(2,1,2, 'vspace', 0.05);
%     mm = 1e3;
%     hold(ax1a, 'off');
%     plot(ax1a, s, mm*(xx+3*sxx)', 'b --');
%     hold(ax1a, 'on');
%     plot(ax1a, s, mm*(xx-3*sxx)', 'b --');
%     plot(ax1a, s, mm*(xx)', '.-r', 'linewidth', 3);
%     plot(ax1a, s, mm*VChamb(1,:),'k');
%     plot(ax1a, s, -mm*VChamb(1,:),'k');
%     grid(ax1a, 'on');
%     ylim(ax1a, [-mm*VChamb(1,1), mm*VChamb(1,1)]);
%     xlim(ax1a, [0, s(end)]);
%     hold(ax2a, 'off');
%     plot(ax2a, s, mm*(yy+3*syy)', 'r --');
%     hold(ax2a, 'on');
%     plot(ax2a, s, mm*(yy-3*syy)', 'r --');
%     plot(ax2a, s, mm*(yy)', '.-b', 'linewidth', 3);
%     plot(ax2a, s, mm*VChamb(2,:),'k');
%     plot(ax2a, s, -mm*VChamb(2,:),'k');
%     grid(ax2a, 'on');
% %     plot(ax, s, orbit(1, :) * mm, '.-k', 'linewidth', 2);
% %     plot(ax, s, orbit(3, :) * mm, '.-k', 'linewidth', 2);
%     ylim(ax2a, [-mm*VChamb(2,1), mm*VChamb(2,1)]);
%     xlim(ax2a, [0, s(end)]);
%     drawnow;
% end
