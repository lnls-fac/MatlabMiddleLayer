% set_magnet_strengths
if strcmpi(mode,'C')
    if strcmpi(version,'01')
        [path, ~, ~] = fileparts(mfilename('fullpath'));
        cur = pwd;
        cd(fullfile(path,'opt_results/c/'));
        eval('c01');
        cd(cur);
    elseif strcmpi(version,'02')
        [path, ~, ~] = fileparts(mfilename('fullpath'));
        cur = pwd;
        cd(fullfile(path,'opt_results/c/'));
        eval('c02');
        cd(cur);
    elseif strcmpi(version,'02-BC5')
        [path, ~, ~] = fileparts(mfilename('fullpath'));
        cur = pwd;
        cd(fullfile(path,'opt_results/'));
        eval('bc_model5');
        cd(cur); 
    else
        error('version not implemented');
    end
else
    error('mode not implemented');
end

