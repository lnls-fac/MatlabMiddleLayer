function delta_bpm = energy_adj_bpms(machine, param, n_part, n_pulse, etax_bpms)
    booster_turns(machine, param, n_part)
    for j = 1:3
        kckr = 'on';
        [~,~,~,~,r_bpm] = bo_pulses(machine, param, n_part, n_pulse, length(machine), kckr, 'plot', 'diag');

        delta_bpm = mean(r_bpm(1,:)) / etax_bpms;

        param.delta_ave = param.delta_ave * (1 + delta_bpm) + delta_bpm;

        booster_turns(machine, param, n_part)
    end
end

