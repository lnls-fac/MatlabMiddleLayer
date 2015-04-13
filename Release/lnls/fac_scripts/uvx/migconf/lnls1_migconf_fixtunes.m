function r = lnls1_migconf_fixtunes(r0, rampa)
% Corrige sintonias em todas configuração de uma rampa
%
% Esta função corrige as sintonias na rampa de forma a linearizar a
% variação entre as configs de baixa e de alta energia.
%
% Historico:
%
% 2010-09-16: comentarios iniciais no codigo (Ximenes R. Resende)

tunes1 = rampa.sintonia(:,1);
tunes2 = rampa.sintonia(:,end);
energy1 = 1000*rampa.energia(1);
energy2 = 1000*rampa.energia(end);
r = r0;

for i=1:length(r.configs)
    [e idx] = min(abs(1000*rampa.energia - r.configs{i}.energy));
    meas_tunes = rampa.sintonia(:,idx);
    corr_tunes = tunes1 + (r.configs{i}.energy - energy1) * (tunes2 - tunes1) / (energy2 - energy1);
    delt_tunes = corr_tunes - meas_tunes;
    r.configs{i} = lnls1_migconf_deltatune(r.configs{i}, delt_tunes);
end

