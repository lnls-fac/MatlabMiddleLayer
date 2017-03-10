function root_folder = lnls_get_root_folder()

if strcmpi(computer, 'PCWIN') || strcmpi(computer, 'PCWIN64')
    if exist(['C:' filesep 'Arq'], 'file')
        root_folder = ['C:' filesep 'Arq' filesep 'fac_files'];
    else
        root_folder = ['D:' filesep 'Arq' filesep 'fac_files'];
    end
else
    if exist('/home/fac_files/lnls-fac','dir')
        root_folder = '/home/fac_files/lnls-fac';
    elseif exist('/home/fac_files/code','dir')
        root_folder = '/home/fac_files/code';
    else
        root_folder = '/Users/fac_files/code';
    end
end