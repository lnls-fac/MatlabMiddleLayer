function [r_bpm_turn, data] = turns_orb(machine, param_inj, param_error, fam)


[~, r_bpm_turn] = sirius_commis.first_turns.bo.multiple_pulse_turn(machine, 1, param_inj, param_error, 1000, 1, 5);

x_mean = mean(r_bpm_turn(1, :));
% etax_mean = 0.1309;
% etax_mean_bpm = 0.2200;
delta_mean = x_mean / mean(param_inj.etax_bpms);
param_inj.delta_ave = param_inj.delta_ave * (1 + delta_mean) + delta_mean;

[~, r_bpm_turn] = sirius_commis.first_turns.bo.multiple_pulse_turn(machine, 1, param_inj, param_error, 1000, 1, 5);


for i=1:1
    r_bpm_turn_i = r_bpm_turn;
    
    orb = findorbit4(machine, 0, 1:length(machine));
    figure; 
    plot(orb(1, fam.BPM.ATIndex).*1e3, '-o'); 
    hold on; 
    plot(r_bpm_turn_i(1, :).*1e3, '-o'); 
    legend('CODx@BPM', '5 turns mean X'); 
    xlabel('BPM Number'); 
    ylabel('Orbit [mm]'); 
    figure;
    plot(orb(3, fam.BPM.ATIndex).*1e3, '-o'); 
    hold on; 
    plot(r_bpm_turn_i(2,:).*1e3, '-o'); 
    legend('CODy@BPM', '5 turns mean Y'); 
    xlabel('BPM Number'); 
    ylabel('Orbit [mm]');
    %}
    
    % data.difx(i) = orb(1, fam.BPM.ATIndex) - r_bpm_turn_i(1, :);
    % data.dify(i) = orb(3, fam.BPM.ATIndex) - r_bpm_turn_i(2, :);
    % data.rmsx(i) = rms(orb(1, fam.BPM.ATIndex));
    % data.rmsy(i) = rms(orb(3, fam.BPM.ATIndex));
end