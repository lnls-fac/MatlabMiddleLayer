n_iter = 10000;
qf_pass = 0.01;
qd_pass = 0.001;
b_pass = 25;

sirius_commis.common.initializations();

fit_only_quads_10mil = sirius_commis.common.find_machine(bo_ring_bm, qf_pass, qd_pass, 0, n_iter, respm_medida_edit, [], 1, 0, 0, 0);
fit_only_qf_10mil = sirius_commis.common.find_machine(bo_ring_bm, qf_pass, 0, 0, n_iter, respm_medida_edit, [], 1, 0, 0, 0);
fit_qf_dip_10mil = sirius_commis.common.find_machine(bo_ring_bm, qf_pass, 0, b_pass, n_iter, respm_medida_edit, [], 1, 1, 0, 0);
fit_quad_dip_10mil = sirius_commis.common.find_machine(bo_ring_bm, qf_pass, qd_pass, b_pass, n_iter, respm_medida_edit, [], 1, 1, 0, 0);