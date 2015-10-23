% set_magnet_strengths
if strcmpi(mode,'C')
    if strcmpi(version,'01')
        [path, ~, ~] = fileparts(mfilename('fullpath'));
        cur = pwd;
        cd(fullfile(path,'opt_results/c/'));
        eval('c01');
        cd(cur);
    else
        error('version not implemented');
    end
elseif strcmpi(mode, 'bc_model3')
    [path, ~, ~] = fileparts(mfilename('fullpath'));
    cur = pwd;
    cd(fullfile(path,'opt_results/'));
    eval('bc_model3');
    cd(cur);
else
    error('mode not implemented');
end

