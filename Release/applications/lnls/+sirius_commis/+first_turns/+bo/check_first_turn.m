function ft_data = check_first_turn(machine, n_mach, param, param_errors, n_part, n_pulse, n_turns, n_pulse_turns, n0, n_sv, m_corr)
% Increases the intensity of BPMs and adjusts the first turn by changing the
% correctors based on BPMs measurements
%
% INPUTS:
%  - machine: booster ring model with errors
%  - n_mach: number of machines to correct first turn
%  - param: cell of structs with adjusted injection parameters for each
% machine
%  - param_errors: struct with injection parameters errors and
%  measurements errors
%  - n_part: number of particles
%  - n_pulse: number of pulses to average
%  - n_turns: maximum number of turns to achieve after the algorithm
%  converges
%  - n_pulse_turns: number of pulses to check the number of turns
%  - n0: array with n_pulse_turns x n_mach with number of turns that each
%  machine realizes when no first turn correction is applied
%  - n_sv: number of singular values to use in correction
%  - m_corr: first turn trajectory corrector matrix with 2 * #BPMs rows
%  and #CH + #CV + 1 columns
%
% OUTPUTS:
%  - ft_data: first turn data struct with the following properties:
%  * machine: booster ring lattice with corrector kicks applied
%  * n_svd: number of singular values when the algorithm converges

sirius_commis.common.initializations();

if n_mach == 1
    machine_cell = {machine};
    param_cell = {param};
    param_errors_cell = {param_errors};
elseif n_mach > 1
    machine_cell = machine;
    param_cell = param;
    param_errors_cell = param_errors;
end

machine_correct = cell(n_mach, 1);
fam = sirius_bo_family_data(machine_cell{1});
ft_data = cell(n_mach, 1);

for j = 1:n_mach
    fprintf('=================================================\n');
    fprintf('MACHINE NUMBER %i \n', j)
    fprintf('=================================================\n');

    machine = machine_cell{j};
    param = param_cell{j};
    param_errors = param_errors_cell{j};

    machine = setcavity('off', machine);
    machine = setradiation('on', machine);
    machine = setcellstruct(machine, 'PolynomB', fam.SD.ATIndex, 0, 1, 3);
    machine = setcellstruct(machine, 'PolynomB', fam.SF.ATIndex, 0, 1, 3);

    n_min = min(n0(:, j));

    if n_min < n_turns
        ft_data{j} = sirius_commis.first_turns.bo.correct_orbit_bpm_matrix(machine, param, param_errors, m_corr, n_part, n_pulse, n_sv);

        if ~isfield(ft_data{j}, 'param')
            ft_data{j}.param = param;
        end

        machine_correct = ft_data{j}.machine;
        r = sirius_commis.first_turns.bo.multiple_pulse_turn(machine_correct, 1, ft_data{j}.param, param_errors, n_part, n_pulse_turns, n_turns);
    end

    ft_data{j}.n_turns = r.num_of_turns;
    kickx_final = lnls_get_kickangle(machine_correct, fam.CH.ATIndex, 'x');
    kicky_final = lnls_get_kickangle(machine_correct, fam.CV.ATIndex, 'y');
    ft_data{j}.kickx = kickx_final;
    ft_data{j}.kicky = kicky_final;
    orbit_final = findorbit4(machine_correct, 0, 1:length(machine_correct));
    ft_data{j}.orbit = orbit_final;
end
