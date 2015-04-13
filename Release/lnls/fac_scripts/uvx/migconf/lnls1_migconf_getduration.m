function tempo_total = lnls1_migconf_getduration(r)
% Retorna tempo total da rampa
%
% Historico:
%
% 2010-09-16: comentarios iniciais no codigo (Ximenes R. Resende)

% calcula soma das finesses
finesse_total = 0;
for i=1:length(r.configs)
    finesse_total = finesse_total + r.configs{i}.finesse;
end

tempo_total = 0;
for i=1:length(r.configs)
    npassos = 4 * r.nr_passos * (r.configs{i}.finesse/finesse_total);
    tempo_total = tempo_total + npassos * (1/r.configs{i}.rep_rate);
end