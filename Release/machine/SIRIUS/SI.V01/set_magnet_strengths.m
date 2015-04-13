% set_magnet_strengths

if strcmpi(mode,'C')
    if strcmpi(version,'00')
        [path, ~, ~] = fileparts(mfilename('fullpath'));
        cur = pwd;
        cd(fullfile(path,'opt_results/c/mantemV500/'));
        eval('firstRun_000556');
        cd(cur);
    
    elseif strncmpi(version, 'opt_results_mad',15)
        
        [path, ~, ~] = fileparts(mfilename('fullpath'));
        cur = pwd;
        cd(fullfile(path,'opt_results/c/mantemV500/'));
        eval(version(15+2:end));
        cd(cur);
    else
        error('version not implemented');
    end
else
    error('mode not implemented');
end

