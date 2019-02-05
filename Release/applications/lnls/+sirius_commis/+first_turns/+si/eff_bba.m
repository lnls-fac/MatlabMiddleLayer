function stat_bba = eff_bba(offset_bba, offset_quad, offset_bpm, n_mach)
   
stat_bba = cell(10, 1);

for j = 1:n_mach
    
    um = 1e6;
    
    offset_bbaj = offset_bba{j} * um;
    offset_quadj = offset_quad{j} * um;
    offset_bpmj = offset_bpm{j} * um;
    
    offset_quad_bba = offset_bbaj - offset_bpmj;
    offset_quad_bba(offset_bbaj == 0) = NaN;
    stat_bba{j}.offset_quad_bba = offset_quad_bba;
    stat_bba{j}.dif_quad_bba = offset_quad_bba - offset_quadj;
    stat_bba{j}.ave_bba_quad = nanmean(stat_bba{j}.dif_quad_bba);
    stat_bba{j}.rms_bba_quad = nanstd(stat_bba{j}.dif_quad_bba);
    initial_dif = abs(offset_bpmj - offset_quadj);
    offset_bpm_new = offset_bpmj - offset_bbaj;
    final_dif = abs(offset_bpm_new - offset_quadj);
    
    final_dif(offset_bbaj == 0) = NaN;
    initial_dif(offset_bbaj == 0) = NaN;
    
    stat_bba{j}.initial_dif = initial_dif;
    stat_bba{j}.final_dif = final_dif;
    stat_bba{j}.ave_initial_dif = nanmean(stat_bba{j}.initial_dif);
    stat_bba{j}.rms_initial_dif = nanstd(stat_bba{j}.initial_dif);
    stat_bba{j}.ave_final_dif = nanmean(stat_bba{j}.final_dif);
    stat_bba{j}.rms_final_dif = nanstd(stat_bba{j}.final_dif);
end
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

