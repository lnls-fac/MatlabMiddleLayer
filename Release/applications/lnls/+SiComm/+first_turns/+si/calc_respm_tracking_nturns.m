function M = calc_respm_tracking_nturns(fam, n_turns, si_ring)

if ~exist('si_ring', 'var')
    si_ring = sirius_si_lattice();
    inj_sept = findcells(si_ring, 'FamName', 'InjSeptF');
    si_ring = circshift(si_ring, [0, -(inj_sept - 1)]);
end

% inj_kckr = findcells(bo_ring, 'FamName', 'InjKckr');

% fam = sirius_bo_family_data(bo_ring);

si_ring = setcellstruct(si_ring, 'PolynomB', fam.SN.ATIndex, 0, 1, 3);

delta_kick_x = 300e-6/20;
delta_kick_y = 150e-6/20;
% x0 = -30e-3;
% x0l = 14.3e-3;
% theta_kckr = -19.3e-3;
% R_in = [x0; x0l; 0; 0; 0; 0];
R_in = [0; 0; 0; 0; 0; 0];
n_bpm = length(fam.BPM.ATIndex);
n_ch = length(fam.CH.ATIndex);
n_cv = length(fam.CV.ATIndex);
M = zeros(2 * n_bpm * n_turns, n_ch + n_cv + 1);
% bo_ring = lnls_set_kickangle(bo_ring, theta_kckr, inj_kckr, 'x');
len_ring = length(si_ring);
n_bpm_turns = n_bpm * n_turns;

bpm_idx = [1:1:n_bpm_turns];
bpm_idx2 = reshape(bpm_idx, n_bpm, n_turns);

for i = 1:n_ch
    
    si_ring_plus = lnls_set_kickangle(si_ring, delta_kick_x/2, fam.CH.ATIndex(i), 'x');
    si_ring_minus = lnls_set_kickangle(si_ring, - delta_kick_x/2, fam.CH.ATIndex(i), 'x');
    R_out_plus = linepass(si_ring_plus, R_in, 1:len_ring + 1);
    R_out_minus = linepass(si_ring_minus, R_in, 1:len_ring + 1);
    Delta_R = (R_out_plus - R_out_minus);
    ix = bpm_idx2(1, 1); fx = bpm_idx2(end, 1);
    iy = ix + n_bpm_turns; fy = fx + n_bpm_turns;
    M(ix:fx, i) = Delta_R(1, fam.BPM.ATIndex) ./ delta_kick_x;
    M(iy:fy, i) = Delta_R(3, fam.BPM.ATIndex) ./ delta_kick_x;
    
    for turn_idx = 2:n_turns
       R_in_plus = R_out_plus(:, end);
       R_in_minus = R_out_minus(:, end);
       R_out_plus = linepass(si_ring_plus, R_in_plus, 1:len_ring + 1);
       R_out_minus = linepass(si_ring_minus, R_in_minus, 1:len_ring + 1);
       Delta_R = (R_out_plus - R_out_minus);
       ix = bpm_idx2(1, turn_idx); fx = bpm_idx2(end, turn_idx);
       iy = ix + n_bpm_turns; fy = fx + n_bpm_turns;
       M(ix:fx, i) = Delta_R(1, fam.BPM.ATIndex) ./ delta_kick_x;
       M(iy:fy, i) = Delta_R(3, fam.BPM.ATIndex) ./ delta_kick_x;
    end
end

for j = 1:n_cv
    
    si_ring_plus = lnls_set_kickangle(si_ring, delta_kick_y/2, fam.CV.ATIndex(j), 'y');
    si_ring_minus = lnls_set_kickangle(si_ring, - delta_kick_y/2, fam.CV.ATIndex(j), 'y');
    R_out_plus = linepass(si_ring_plus, R_in, 1:len_ring + 1);
    R_out_minus = linepass(si_ring_minus, R_in, 1:len_ring + 1);
    Delta_R = (R_out_plus - R_out_minus);
    ix = bpm_idx2(1, 1); fx = bpm_idx2(end, 1);
    iy = ix + n_bpm_turns; fy = fx + n_bpm_turns;
    M(ix:fx, n_ch + j) = Delta_R(1, fam.BPM.ATIndex) ./ delta_kick_y;
    M(iy:fy, n_ch + j) = Delta_R(3, fam.BPM.ATIndex) ./ delta_kick_y;
    
    for turn_idx = 2:n_turns
       R_in_plus = R_out_plus(:, end);
       R_in_minus = R_out_minus(:, end);
       R_out_plus = linepass(si_ring_plus, R_in_plus, 1:len_ring + 1);
       R_out_minus = linepass(si_ring_minus, R_in_minus, 1:len_ring + 1);
       Delta_R = (R_out_plus - R_out_minus);
       ix = bpm_idx2(1, turn_idx); fx = bpm_idx2(end, turn_idx);
       iy = ix + n_bpm_turns; fy = fx + n_bpm_turns;
       M(ix:fx, n_ch + j) = Delta_R(1, fam.BPM.ATIndex) ./ delta_kick_y;
       M(iy:fy, n_ch + j) = Delta_R(3, fam.BPM.ATIndex) ./ delta_kick_y;
    end
end
