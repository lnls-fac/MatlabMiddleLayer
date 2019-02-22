function root_folder = lnls_get_root_folder()

if strcmpi(computer, 'PCWIN') || strcmpi(computer, 'PCWIN64')
    if exist(['C:' filesep 'Arq'], 'file')
        root_folder = ['C:' filesep 'Arq' filesep 'fac'];
    else
        root_folder = ['D:' filesep 'Arq' filesep 'fac'];
    end
else
    if exist('/home/facs/repos','dir')
        root_folder = '/home/facs/repos';
    elseif exist('/home/fac_files/code','dir')
        root_folder = '/home/fac_files/code';
    else
        root_folder = '/Users/fac_files/lnls-fac';
    end
end