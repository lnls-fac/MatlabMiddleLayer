function set_kick_septum(kick, np, plane, bo_data)
close all
ring = bo_data.machine;
% param = bo_data.nominal_parameters;
param = bo_data.parameters{1};
param_errors = bo_data.errors{1};

ring = shift_ring(ring, 'InjSept');
fam = sirius_bo_family_data(ring);
ring = setcavity('off', ring);
ring = setradiation('on', ring);

len = length(ring);
ring_kick_sept = ring;
local = len;
ring_kick_sept{local} = ring{fam.CH.ATIndex(1)};
ring_kick_sept{local}.Length = ring{local}.Length;

if np > 1
    kick_lin = linspace(0, kick, np);
else
    kick_lin = kick;
end
figure;
for k = 1:np
    if strcmp(plane, 'xy')
        ring_kick_sept = lnls_set_kickangle(ring_kick_sept, kick_lin(k), local, 'x');
        ring_kick_sept = lnls_set_kickangle(ring_kick_sept, kick_lin(k), local, 'y');
    else
        ring_kick_sept = lnls_set_kickangle(ring_kick_sept, kick_lin(k), local, plane);
    end

    spos = findspos(ring, 1:len+1);
    cod_kick = findorbit4(ring_kick_sept, 0, 1:len+1);
    % figure;
    % plot(spos, cod_kick(1, :) * 1e3, '-bo');
    % hold on;
    % plot(spos, cod_kick(3, :) * 1e3, '-ro');
    % legend('X', 'Y');

    r_particles_out = sirius_commis.first_turns.bo.multiple_pulse_turn(ring_kick_sept, 1, param, param_errors, 100, 1, 500);
    bpm_pos = r_particles_out{1}.r_bpm_tbt_pbp_mean;
    sum_bpm = r_particles_out{1}.sum_bpm_tbt_pbp;
    bpms_idx = fam.BPM.ATIndex;
    
    txt = ['Kick = ', num2str(kick_lin(k)*1e6), ' urad'];
    if np > 1
        plot(squeeze(sum_bpm(1, :, :, end).*100), 'LineWidth', 3, 'DisplayName', txt, 'Color', [(k-np)/(1-np), 0, (k - 1)/(np -1)]);
    else
        plot(squeeze(sum_bpm(1, :, :, end).*100), 'LineWidth', 3, 'DisplayName', txt);
    end
    hold on;
    % figure;
    % plot(spos(bpms_idx), (bpm_pos(1, :)-cod_kick(1, bpms_idx)) * 1e3, 'b');
    % legend('X');
    % figure;
    % plot(spos(bpms_idx), (bpm_pos(2, :)-cod_kick(2, bpms_idx)) * 1e3, 'r');
    % legend('Y');
end
ylim([0,100])
xlabel('Number of Turns')
ylabel('Intensity [%]')
legend show
grid on
end

