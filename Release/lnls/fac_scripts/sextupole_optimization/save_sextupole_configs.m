function r = save_sextupole_configs(p)

r = p;

file_name = [r.pathstr filesep 'sextupole_configurations.mat'];
if exist(file_name , 'file')
    load 'sextupole_configurations';
else
    sextupole_configurations = {};
end
   
for i=1:length(sextupole_configurations)
    r.configs{length(r.configs) + 1} = sextupole_configurations{i};
end

r = add_sextupole_config(r);
sextupole_configurations = r.configs;
if ~isempty(sextupole_configurations), save(file_name,'sextupole_configurations'); end
