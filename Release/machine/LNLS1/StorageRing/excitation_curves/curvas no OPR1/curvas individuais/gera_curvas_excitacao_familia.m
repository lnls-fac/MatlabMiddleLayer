function r = gera_curvas_excitacao_familia(lista_elementos, nome_familia)

lista_elementos = {'ASD02A.TXT', 'ASD04B.TXT', 'ASD06B.TXT', 'ASD08B.TXT', 'ASD10A.TXT', 'ASD12B.TXT'};
nome_familia = 'A6SD01.TXT';
data = [];
amps = [];
minv = -1000;
maxv = 1e10;
for i=1:length(lista_elementos)
    d{i} = importdata(lista_elementos{i});
    d{i} = d{i}.data;
    minv = max([minv; min(d{i}(:,1))]);
    maxv = min([maxv; max(d{i}(:,1))]);
    amps = unique([amps; d{i}(:,1)]);
end;

pos = find((amps >= minv) .* (amps <= maxv));
amps = amps(pos);
for i=1:length(amps);
    exci(i,1) = 0;
    for j=1:length(d)
        exci(i,1) = exci(i,1) + spline(d{j}(:,1),d{j}(:,2), amps(i));
    end
    exci(i,1) = exci(i,1) / length(d);
end
r(:,1) = amps;
r(:,2) = exci;


dlmwrite(nome_familia, r, 'delimiter', '\t', 'newline', 'pc');