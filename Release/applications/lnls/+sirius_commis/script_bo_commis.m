
sirius('BO');
bo_ring_bm = sirius_bo_lattice();
bo_ring_bm = sirius_commis.common.shift_ring(bo_ring_bm, 'InjSept');
fam = sirius_bo_family_data(bo_ring_bm);

respm_traj = sirius_commis.first_turns.bo.calc_respm_tracking(bo_ring_bm, fam);
[rand_machines_bo, param_init] = sirius_commis.injection.bo.set_machine(bo_ring_bm, 20);

scrn_error = [0.036, 0.018, 0.018; 1.703, 0.803, 1.004].*1e-3;
[pinj_noalgn, perr_noalgn] = sirius_commis.injection.bo.multiple_adj_loop(rand_machines_bo, 20, 5000, 1, param_init, scrn_error);
[pinj_algn, perr_algn] = sirius_commis.injection.bo.multiple_adj_loop(rand_machines_bo, 20, 5000, 1, param_init, scrn_error.*0);

ft_noalgn = sirius_commis.first_turns.bo.check_first_turn_SOFB(rand_machines_bo, 20, pinj_noalgn, perr_noalgn, 1000, 1, 20, 1, zeros(1, 20), 2);
ft_algn = sirius_commis.first_turns.bo.check_first_turn_SOFB(rand_machines_bo, 20, pinj_algn, perr_algn, 1000, 1, 20, 1, zeros(1, 20), 2);

% AT THIS POINT A CHANGE IN RESP MATRIX IS NEEDED TO SET 5 TURNS MATRIX

for i = 1:20
    fprintf('Machine # %i \n', i);
    [fivet_noalgn{i}, ct5_noalgn{i}] = sirius_commis.first_turns.bo.closes_orbit_SOFB(rand_machines_bo{i}, pinj_noalgn{i}, perr_noalgn{i}, 1000, 1, 2, 5);
    [fivet_algn{i}, ct5_algn{i}] = sirius_commis.first_turns.bo.closes_orbit_SOFB(rand_machines_bo{i}, pinj_algn{i}, perr_algn{i}, 1000, 1, 2, 5);
end

for i = 1:20
   ft_noalgn_machine{i} = ft_noalgn{i}.machine;
   ft_algn_machine{i} = ft_algn{i}.machine;
end

% AT THIS POINT A CHANGE IN RESP MATRIX IS NEEDED TO SET CLOSED ORBIT

[cod_noalgn_ft, ~, cturns_noalgn_ft] = sirius_commis.first_turns.bo.orbit_correction_SOFB(ft_noalgn_machine, 20, pinj_noalgn, perr_noalgn, 5, 1000, 1, 50);
[cod_algn_ft, ~, cturns_algn_ft] = sirius_commis.first_turns.bo.orbit_correction_SOFB(ft_algn_machine, 20, pinj_algn, perr_algn, 5, 1000, 1, 50);
[cod_noalgn_fivet, ~, cturns_noalgn_fivet] = sirius_commis.first_turns.bo.orbit_correction_SOFB(fivet_noalgn, 20, pinj_noalgn, perr_noalgn, 5, 1000, 1, 50);
[cod_algn_fivet, ~, cturns_algn_fivet] = sirius_commis.first_turns.bo.orbit_correction_SOFB(fivet_algn, 20, pinj_algn, perr_algn, 5, 1000, 1, 50);

save inj_and_ft_sofb.mat