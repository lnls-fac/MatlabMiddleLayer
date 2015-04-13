function r_final = lnls1_migconf_insert_newconf(r_init, energy)
% Insere configuração de energia em uma rampa do anel.
%
%   Cria migração com nova configuração na energia 'energy'. A nova
% configuração é criada através de interpolando linear e sua energia não
% deve ser menor que a da primeira ou maior que a da última. Os parâmetros não
% contínuos na nova config são ajustados usando-se a config imediatamente
% posterior.
%
% Historico:
%
% 2010-09-16: comentarios iniciais no codigo (Ximenes R. Resende)


r_final = r_init;

% constrói lista de índices onde a nova config será inserida
idx_list = [];
for i=1:length(r_init.configs)
    if (r_init.configs{i}.energy <= energy) && (r_init.configs{i+1}.energy >= energy)
        idx_list = [idx_list i];
    end
end


counter = 1;
r_final.configs = {};

for i=1:length(r_init.configs)
    
    r_final.configs{length(r_final.configs) + 1} = r_init.configs{i};
             
    if (counter <= length(idx_list)) && (i == idx_list(counter))
    
        c = r_init.configs{i+1};
        pathstr = fileparts(c.config_fname);
        c.config_fname = fullfile(pathstr, ['AN' num2str(round(energy)) '_' datestr(now, 'yyyy-mm-dd_HH-MM-SS') '.DB']);
        idx = idx_list(counter);        
        c1     = r_init.configs{idx};
        c2     = r_init.configs{idx+1};
        factor = (energy - c1.energy) / (c2.energy - c1.energy);
    
        interval_finesse      = c2.finesse;
        
        c.energy              = energy;
        c.rep_rate            = c2.rep_rate;
        c.finesse             = factor * interval_finesse;
        c.vg                  = c1.vg + factor * (c2.vg - c1.vg);
        c.dt                  = c1.dt + factor * (c2.dt - c1.dt);
        
        c.optics_mode         = c1.optics_mode;
        c.response_matrix     = c1.response_matrix;
        c.response_matrix_dir = c1.response_matrix_dir;
        c.orbit               = c1.orbit;
        c.orbit_fname         = c1.orbit_fname;
        c.orbit_dir           = c1.orbit_dir;
        c.corrector_set       = c1.corrector_set;
    
        c2.finesse            = (1-factor) * interval_finesse;
           
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
        
        r_final.configs{length(r_final.configs) + 1} = c;
        counter = counter + 1;
        
        r_init.configs{idx} = c1;
        r_init.configs{idx+1} = c2;
        
    end
     
    
end

    