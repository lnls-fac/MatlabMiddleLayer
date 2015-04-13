function r_final = lnls1_migconf_prepend_newconf(r_init, energy)
% Insere configuração de energia no início de uma rampa do anel.
%
%   Cria migração com nova configuração na energia 'energy'. A nova
% configuração é criada através de extrapolaçao linear e adicionada ao
% início da rampa.
%
% Historico:
%
% 2010-09-16: comentarios iniciais no codigo (Ximenes R. Resende)


r_final = r_init;

c              = r_init.configs{1};
pathstr        = fileparts(c.config_fname);
c.config_fname = fullfile(pathstr, ['AN' num2str(round(energy)) '_' datestr(now, 'yyyy-mm-dd_HH-MM-SS') '.DB']);
c1             = r_init.configs{1};
c2             = r_init.configs{2};
factor         = (energy - c1.energy) / (c2.energy - c1.energy);
interval_finesse = c1.finesse;
c.energy       = energy;
c.rep_rate     = c1.rep_rate;
c.finesse      = interval_finesse / 2;
c.vg           = c1.vg + factor * (c2.vg - c1.vg);
c.dt           = c1.dt + factor * (c2.dt - c1.dt);

c1.finesse     = interval_finesse / 2;

c.power_supplies.fields = {};
c.power_supplies.values = [];
for j=1:length(c1.power_supplies.fields)
    for k=1:length(c2.power_supplies.fields)
        if strcmpi(c1.power_supplies.fields(j), c2.power_supplies.fields(k))
            c.power_supplies.fields{end + 1} = c1.power_supplies.fields{j};
            c.power_supplies.values(end + 1) = c1.power_supplies.values(j) + factor * (c2.power_supplies.values(k) - c1.power_supplies.values(j));
        end
    end
end
r_init.configs{1} = c1;
r_init.configs{2} = c2;
        

r_final.configs = {};
r_final.configs{1}= c;
for i=1:length(r_init.configs)
    r_final.configs{end + 1} = r_init.configs{i};
end

    