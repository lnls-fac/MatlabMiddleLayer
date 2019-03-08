function [stat_bba, mach_bba, data_bpm] = eff_bba(offset_bba, offset_quad, offset_bpm, n_mach)

stat_bba = cell(n_mach, 1);
data_bpm = cell(n_mach, 1);
um = 1e6;

for j = 1:n_mach
    
    offset_bbaj = offset_bba{j} * um;
    % derro(offset_bbaj == 0 ) = 0;
    % offset_bbaj = offset_bbaj + derro;
    offset_quadj = offset_quad{j} * um;
    offset_bpmj = offset_bpm{j} * um;
    dcrs = zeros(length(offset_bpmj(:, 1)), length(offset_bpmj(1, :)));
    
    %{
    bpms_indx = find(offset_bbaj(:, 1) ~= 0);
    for lx = 1:length(bpms_indx)
       if ismember(bpms_indx(lx), eliminate.x)
           offset_bbaj(bpms_indx(lx), 1) = 0;
        end
    end
    
    bpms_indy = find(offset_bbaj(:, 2) ~= 0);
    for ly = 1:length(bpms_indy)
        if ismember(bpms_indy(ly), eliminate.y)
            offset_bbaj(bpms_indy(ly), 2) = 0;
        end
    end
    %}
    
    % bpms_indx = find(offset_bbaj(:, 1) ~= 0);
    % bpms_indy = find(offset_bbaj(:, 2) ~= 0);

    offset_quadj(offset_bbaj == 0) = NaN;
    % rms = nanstd(offset_bbaj);
    % offset_bbaj(abs(offset_bbaj) > rms(1)) = 0;
    % offset_bbaj(abs(offset_bbaj) < rms(1)) = 0;
    initial_bba = offset_quadj - offset_bpmj;
    new_offset = offset_bpmj + offset_bbaj;
    final_bba = offset_quadj - new_offset;
    dcrs(abs(final_bba) <= abs(initial_bba)) = 1;
    data_bpm{j}.good_bpm_x = find(dcrs(:, 1));
    data_bpm{j}.good_bpm_y = find(dcrs(:, 2));
    dcrs(offset_bbaj == 0) = NaN;
    data_bpm{j}.fail_x = find(dcrs(:, 1) == 0 & offset_bbaj(:, 1) ~= 0);
    data_bpm{j}.fail_y = find(dcrs(:, 2) == 0 & offset_bbaj(:, 2) ~= 0);
    v_dcrs = abs(final_bba) - abs(initial_bba);
    v_dcrs(offset_bbaj == 0) = NaN;
    erro_percent = abs((new_offset - offset_quadj) ./ offset_quadj) * 100;
   
    % dcrs(isnan(dcrs)) = 0;
    % offset_bbaj(~dcrs) = NaN;
    % initial_dif = offset_quadj - offset_bpmj;
    % new_offset = offset_bpmj + offset_bbaj;
    % final_dif = offset_quadj - new_offset;
    
    final_bba(isnan(offset_bbaj)) = NaN;
    initial_bba(isnan(offset_bbaj)) = NaN;
    
    stat_bba{j}.initial_dif = initial_bba;
    stat_bba{j}.final_dif = final_bba;
    stat_bba{j}.ave_initial_dif = nanmean(stat_bba{j}.initial_dif);
    stat_bba{j}.rms_initial_dif = nanstd(stat_bba{j}.initial_dif);
    stat_bba{j}.ave_final_dif = nanmean(stat_bba{j}.final_dif);
    stat_bba{j}.rms_final_dif = nanstd(stat_bba{j}.final_dif);
    stat_bba{j}.bba_ok = dcrs;
    stat_bba{j}.decrease_value = v_dcrs;
    stat_bba{j}.erro_percent = erro_percent;
end

for k = 1:size(offset_bbaj, 1)
    for j = 1:n_mach
        bba_mach_init(j, :) = stat_bba{j}.initial_dif(k, :);
        bba_mach_final(j, :) = stat_bba{j}.final_dif(k, :);
    end
    init_dif_mach(k, :) = nanstd(bba_mach_init, 1);
    final_dif_mach(k, :) = nanstd(bba_mach_final, 1);
end

mach_bba.init_dif_mach = init_dif_mach;
mach_bba.final_dif_mach = final_dif_mach;
% decrease = init_dif_mach < final_dif_mach;
mach_bba.init_dif_rms = nanmean(init_dif_mach, 1);
mach_bba.final_dif_rms = nanmean(final_dif_mach, 1);

    % goal_bba = offset_quad - offset_bpm;
    % goal_bba(offset_bba == 0) = NaN;
    % stat_bba.goal_bba = goal_bba;
    % stat_bba.dif_bba = offset_bba - goal_bba;
    % stat_bba.agrx = sirius_commis.common.prox_percent(offset_bba(:, 1), goal_bba(:, 1));
    % stat_bba.agry = sirius_commis.common.prox_percent(offset_bba(:, 2), goal_bba(:, 2));
    % stat_bba.rms_bba = nanstd(stat_bba.goal_bba);
    % stat_bba.ave_bba = nanmean(stat_bba.goal_bba);
    % stat_bba.offset_bba = offset_bba;
    % stat_bba.offset_bpm_new = offset_bpm + offset_bba;
    % stat_bba.dif_bpm_quad = offset_quad - stat_bba.offset_bpm_new;
    % stat_bba.dif_bpm_quad(offset_bba == 0) = NaN;
    % stat_bba.rms_bpm_quad = nanstd(stat_bba.dif_bpm_quad);
    % stat_bba.ave_bpm_quad = nanmean(stat_bba.dif_bpm_quad);
end
