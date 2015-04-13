function parms = load_config(config, submachine, magnet)

%pathstr = fullfile(lnls_get_root_folder(), 'data','sirius_mml','magnet_modelling', 'CONFIGS', config);
pathstr = fullfile(lnls_get_root_folder(), 'data','sirius',submachine,'magnet_modelling', magnet, config);

addpath(pathstr); 
parms = CONFIG(pathstr);
rmpath(pathstr);
