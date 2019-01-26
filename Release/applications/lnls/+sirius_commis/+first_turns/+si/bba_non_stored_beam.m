function machine_out = bba_non_stored_beam(machine_in, param, param_errors, n_part, n_pulse, n_turns, M_acc)

fam = sirius_si_family_data(machine_in);
ch = fam.CH.ATIndex;
cv = fam.CV.ATIndex;
bpm = fam.BPM.ATIndex;

qfa = fam.QFA.ATIndex;
qfb = fam.QFB.ATIndex;
qfp = fam.QFP.ATIndex;
q1 = fam.Q1.ATIndex;
q2 = fam.Q2.ATIndex;
q3 = fam.Q3.ATIndex;
q4 = fam.Q4.ATIndex;

qfs = [qfa; qfb; qfp; q1; q2; q3; q4];

theta_x0 = lnls_get_kickangle(machine_in, ch, 'x')';
theta_y0 = lnls_get_kickangle(machine_in, cv, 'y')';

%{
quads_name_x = {'QFA','QFB','QFP', 'Q1','Q2','Q3','Q4'};
quads_name_y = {'QDA','QDB2','QDB1','QDP2','QDP1'};
fam_idx = findcells(machine_in, 'FamName');
fam_list = getcellstruct(machine_in,'FamName',fam_idx);
quads_ind_x   = ismember(fam_list, quads_name_x);
%}

for j = 1:length(qfs)
    indx = bpm > qfs(j);
    first_bpm = find(indx);
    bpm_quad(j) = first_bpm(1);
end

% mxx = respm.mxx;
% myy = respm.myy;

%[best_corr_x, ind_best_x] = max(abs(mxx), [], 1);

[m_corr_x, ~] = sirius_commis.first_turns.si.trajectory_matrix(fam, M_acc);
[~, ind_best_x] = max(abs(m_corr_x), [], 2);
% [~, ind_best_y] = max(abs(m_corr_y), [], 2);

for i = 1:length(qfs)
    quad = machine_in(qfs(i)); quad = quad{1,1};
    bpm_corr = bpm_quad(i);
    n_corr = ind_best_x(bpm_corr);
    polyB = quad.PolynomB(1, 2);
    % [~, ~, ~, r_bpm] = sirius_commis.injection.si.multiple_pulse(machine_in, param, param_errors, n_part, n_pulse, length(machine_in), 'on', 'diag');
    orbit = findorbit4(machine_in, 0, 1:length(machine_in));
    r_bpm = orbit(1, bpm);
    x_bpm = r_bpm(1, bpm_corr);
    sigma_bpm = nanstd(r_bpm(1,:));
    for ii = 1:20
        dtheta(ii) = (ii-10)*5e-6;% theta_x0(n_corr) * (1 + (ii-6)*1/100);
        machine1 = lnls_set_kickangle(machine_in, dtheta(ii) , ch(n_corr), 'x');
        machine1 = setcellstruct(machine1, 'PolynomB', qfs(i), polyB * 1.01, 1, 2);
        [~, r_bpm1, ~, ~, ~, ~] = sirius_commis.first_turns.si.multiple_pulse_turn(machine1, 1, param, param_errors, n_part, n_pulse, n_turns);
        % [~, ~, ~, r_bpm1] = sirius_commis.injection.si.multiple_pulse(machine1, param, param_errors, n_part, n_pulse, length(machine_in), 'on', 'diag');
        % orbit1 = findorbit4(machine1, 0, 1:length(machine_in));
        % r_bpm1 = orbit1(1, bpm);
        x_bpm1 = r_bpm1(1, bpm_corr);
        sigma_bpm1 = nanstd(r_bpm1(1,:));
        dx1 = x_bpm1 - x_bpm;
        dsigma1 = sigma_bpm1 - sigma_bpm;
        machine2 = setcellstruct(machine1, 'PolynomB', qfs(i), polyB * 0.99, 1, 2);
        [~, r_bpm2, ~, ~, ~, ~] = sirius_commis.first_turns.si.multiple_pulse_turn(machine2, 1, param, param_errors, n_part, n_pulse, n_turns);
        % [~, ~, ~, r_bpm2] = sirius_commis.injection.si.multiple_pulse(machine2, param, param_errors, n_part, n_pulse, length(machine_in), 'on', 'diag');
        % orbit2 = findorbit4(machine2, 0, 1:length(machine_in));
        % r_bpm2 = orbit2(1, bpm);        
        x_bpm2 = r_bpm2(1, bpm_corr);
        sigma_bpm2 = nanstd(r_bpm2(1,:));
        dx2 = x_bpm2 - x_bpm;
        dsigma2 = sigma_bpm2 - sigma_bpm;
        f_merit1(ii) = sum((r_bpm1(1,:) - r_bpm2(1,:)).^2);
        f_merit2(ii) = (dsigma2 - dsigma1)^2;
        f_merit3(ii) = (dx1 - dx2)^2;
    end
    figure; plot(dtheta, f_merit1);
    figure; plot(dtheta, f_merit2);
    figure; plot(dtheta, f_merit3);    
end






%}





end

