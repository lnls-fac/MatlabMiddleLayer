function saves_at_model(config_path, at_model)

% saves Matlab file with at_model
fname = fullfile(config_path, 'ATMODEL.mat');
save(fname, 'at_model');
