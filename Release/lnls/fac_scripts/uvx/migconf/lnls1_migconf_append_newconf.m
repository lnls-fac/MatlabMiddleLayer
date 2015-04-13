function r_final = lnls1_migconf_append_newconf(r_init, energy)
% Insere configuração de energia no final de uma rampa do anel.
%
%   Cria migração com nova configuração na energia 'energy'. A nova
% configuração é criada através de extrapolaçao linear e adicionada ao
% final da rampa.
%
% Historico:
%
% 2010-09-16: comentarios iniciais no codigo (Ximenes R. Resende)


r_final = r_init;

c                = r_init.configs{end};
pathstr          = fileparts(c.config_fname);
c.config_fname   = fullfile(pathstr, ['AN' num2str(round(energy)) '_' datestr(now, 'yyyy-mm-dd_HH-MM-SS') '.DB']);
c1               = r_init.configs{end-1};
c2               = r_init.configs{end};
factor           = (energy - c1.energy) / (c2.energy - c1.energy);
interval_finesse = c2.finesse;
c.energy         = energy;
c.rep_rate       = c2.rep_rate;
c.finesse        = factor * interval_finesse;
c2.finesse       = (1-factor) * interval_finesse;
c.vg             = c1.vg + factor * (c2.vg - c1.vg);
c.dt             = c1.dt + factor * (c2.dt - c1.dt);



c.power_supplies.fields = {};
c.power_supplies.values = [];
for j=1:length(c1.power_supplies.fields)
    for k=1:length(c2.power_supplies.fields)
        if strcmpi(c1.power_supplies.fields(j), c2.power_supplies.fields(k))
            c.power_supplies.fields{length(c.power_supplies.fields) + 1} = c1.power_supplies.fields{j};
            c.power_supplies.values(length(c.power_supplies.values) + 1) = c1.power_supplies.values(j) + factor * (c2.power_supplies.values(k) - c1.power_supplies.values(j));
        end
    end
end
r_init.configs{end-1} = c1;
r_init.configs{end}   = c2;
        
r_final.configs = r_init.configs;
r_final.configs{end+1} = c;
    