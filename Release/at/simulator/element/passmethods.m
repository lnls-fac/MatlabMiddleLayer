function passmethods(varargin)
%PASSMETHODS returns a list of available AT passmethod functions
passmethoddir = fileparts(mfilename('fullpath'));

fprintf('--- element dir ---\n');
files = dir(passmethoddir);
for i = 1:length(files)
    file = files(i);
    [~, name, ext] = fileparts(file.name);
    if ~isempty(strfind(ext, '.c')) && ~isempty(strfind(name, 'Pass'))
        fprintf('%s\n', name);
    end
end

fprintf('--- element/user dir ---\n');
files = dir(fullfile(passmethoddir,'user'));
for i = 1:length(files)
    file = files(i);
    [~, name, ext] = fileparts(file.name);
    if ~isempty(strfind(ext, '.c')) && ~isempty(strfind(name, 'Pass'))
        fprintf('%s\n', name);
    end
end

