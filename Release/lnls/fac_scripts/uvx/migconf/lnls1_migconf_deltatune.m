function c2 = lnls1_migconf_deltatune(c1, delta_tune)
% Ajusta sinotnias em uma configuração de rampa
%
% Historico:
%
% 2010-09-16: comentários iniciais no código (Ximenes R. Resende)

qf_power_supplies = unique(family2channel('QF'), 'rows');
qd_power_supplies = unique(family2channel('QD'), 'rows');
tune_matrix = gettuneresp('physics');
delta_force = inv(tune_matrix) * delta_tune(:);

%delta_force_per_channelname = delta_force ./ [ size(qf_power_supplies,1); size(qd_power_supplies,2) ];
delta_force_per_channelname = delta_force;

c2 = c1;

for i=1:size(qf_power_supplies,1)
    ps = strrep(qf_power_supplies(i,:), '_AM', '');
    for j=1:length(c2.power_supplies.fields)
        if strcmpi(c2.power_supplies.fields{j}, ps)
            c2.power_supplies.values(j) = c2.power_supplies.values(j) + delta_force_per_channelname(1);
        end
    end
end

for i=1:size(qd_power_supplies,1)
    ps = strrep(qd_power_supplies(i,:), '_AM', '');
    for j=1:length(c2.power_supplies.fields)
        if strcmpi(c2.power_supplies.fields{j}, ps)
            c2.power_supplies.values(j) = c2.power_supplies.values(j) + delta_force_per_channelname(2);
        end
    end
end



