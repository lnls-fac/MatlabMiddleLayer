% set_magnet_strengths
if strcmpi(mode,'C')
    if strcmpi(version,'02')
        [path, ~, ~] = fileparts(mfilename('fullpath'));
        cur = pwd;
        cd(fullfile(path,'opt_results/c/'));
        eval('c02');
        cd(cur);
    elseif strcmpi(version,'03')
        [path, ~, ~] = fileparts(mfilename('fullpath'));
        cur = pwd;
        cd(fullfile(path,'opt_results/c/'));
        eval('c03');
        cd(cur);
    elseif strcmpi(version,'04')
        [path, ~, ~] = fileparts(mfilename('fullpath'));
        cur = pwd;
        cd(fullfile(path,'opt_results/c/'));
        eval('c04');
        cd(cur);
    elseif strcmpi(version,'05')
        [path, ~, ~] = fileparts(mfilename('fullpath'));
        cur = pwd;
        cd(fullfile(path,'opt_results/c/'));
        eval('c05');
        cd(cur);
    else
        error('version not implemented');
    end
else
    error('mode not implemented');
end

