function [bba_data1, bba_data2] = bba_loop(machine, n_mach, param, param_errors, n_part, n_pulse, M_acc, n_points, plane, data_bpm)

    if ~exist('data_bpm', 'var')
        data_bpm.good_bpm_x = [1:1:160]';
        data_bpm.good_bpm_y = [1:1:160]';
    end

    bba_data1 = sirius_commis.first_turns.si.bba_non_stored_beam(machine, n_mach, param, param_errors, n_part, n_pulse, M_acc, n_points, plane, data_bpm);
    
    % data_input1.off = bba_data1.off_bba;
    data_input1.off_theta1 = bba_data1.off_theta1;
    data_input1.off_theta2 = bba_data1.off_theta2;
    data_input1.factor = 3;
    data_input1.m_resp = bba_data1.m_resp;

    bba_data2 = sirius_commis.first_turns.si.bba_non_stored_beam(machine, n_mach, param, param_errors, n_part, n_pulse, M_acc, n_points, plane, data_bpm, data_input1);
    
    % data_input2.off = bba_data2.off_bba;
    % data_input2.off_theta = bba_data2.off_theta;
    % data_input2.factor = 4;
    % data_input2.m_resp = bba_data2.m_resp;

    % bba_data3 = sirius_commis.first_turns.si.bba_non_stored_beam(machine, n_mach, param, param_errors, n_part, n_pulse, M_acc, twiss, n_points, plane, data_input2);
    %{
    off_bba = bba_data2.off_bba;
    off_bba = off_bba{1};
    bpm_bba = find(off_bba(:, 1) ~= 0);
    off_theta = bba_data2.off_theta;
    off_theta = off_theta{1};
    theta_bba = off_theta(bpm_bba, 1);
    fam = sirius_si_family_data(machine);
    for i = 1:length(bpm_bba)
        machine_kick = lnls_set_kickangle(machine, theta_bba(i), fam.CH.ATIndex(bpm_bba(i)), 'x');
        [~, ~, ~, r_bpm, ~] = sirius_commis.injection.si.multiple_pulse(machine_kick, param, param_errors, n_part, n_pulse, length(machine), 'on', 'diag');
        offset(i) = r_bpm(1, bpm_bba(i));
    end
    %}
end

