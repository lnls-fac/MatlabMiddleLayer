function r = load_sextupole_configs(p)

r = p;

file_name = [r.pathstr filesep 'sextupole_configurations.mat'];
if exist(file_name , 'file')
    load 'sextupole_configurations';
    r.configs = sextupole_configurations;
end

