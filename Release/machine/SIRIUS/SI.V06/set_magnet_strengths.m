% set_magnet_strengths

if strcmpi(mode,'A')
    if strcmpi(version,'00')% old ac20.2
        %%% QUADRUPOLOS
        %  ===========
        
        qfa_strength   =  2.515526;
        qda_strength   = -2.602399;
        qf1_strength   =  2.372377;
        qf2_strength   =  3.351939;
        qf3_strength   =  3.062241;
        qf4_strength   =  2.726014;
        
        % vinculos para o modo AC20
        qdb1_strength  = qda1_strength;
        qfb_strength   = qfa_strength;
        qdb2_strength  = +0.000000000000;
        
        %%% SEXTUPOLOS
        % ==========
        sfa_strength =   27.260886;
        sda_strength =  -53.895434;
        sd1_strength =  -85.452385;
        sf1_strength =  186.287910;
        sd2_strength = -127.382337;
        sd3_strength = -154.506764;
        sf2_strength =  156.861444;
        sd6_strength =  sd1_strength;
        sf4_strength =  sf1_strength;
        sd5_strength =  sd2_strength;
        sd4_strength =  sd3_strength;
        sf3_strength =  sf2_strength;
        
        % vinculos para o modo AC20
        sfb_strength   = sfa_strength;
        sdb_strength   = sda_strength;
    else
        error('version not implemented');
    end
    
elseif strcmpi(mode,'B')
    if strcmpi(version,'00')% old ac10.5
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % quando a Liu mudou do 403 para o 500 ela corrigiu a sintonia e esse
        % passou a ser chamado de ac10.5
        %%% QUADRUPOLOS
        %  ===========
        qfa_strength       =  2.536876;
        qda_strength       = -2.730416;
        qdb2_strength      = -3.961194;
        qfb_strength       =  3.902838;
        qdb1_strength      = -2.966239;
        qf1_strength       =  2.367821;
        qf2_strength       =  3.354286;
        qf3_strength       =  3.080632;
        qf4_strength       =  2.707639;
        %%% SEXTUPOLOS
        %  ==========
        sda_strength       = -115.7829759411277/2;
        sfa_strength       =   49.50386128829739/2;
        sdb_strength       = -214.5386552515188/2;
        sfb_strength       =  133.1252391065637/2;
        
        sd1_strength      = -302.6188062085843/2;
        sf1_strength      =  369.5045185071228/2;
        sd2_strength      = -164.3042864671946/2;
        sd3_strength      = -289.9270429064217/2;
        sf2_strength      =  333.7039740852999/2;
        sd6_strength      = -302.6188062085843/2;
        sf4_strength      =  369.5045185071228/2;
        sd5_strength      = -164.3042864671946/2;
        sd4_strength      = -289.9270429064217/2;
        sf3_strength      =  333.7039740852999/2;
        
    elseif strncmpi(version,'opt_results',11)
        
        [path, ~, ~] = fileparts(mfilename('fullpath'));
        cur = pwd;
        cd(fullfile(path,'opt_results/b/'));
        eval(version(11+2:end));
        cd(cur);
    else
        error('version not implemented');
    end
    
elseif strcmpi(mode,'C')
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
    else
        error('version not implemented');
    end
else
    error('mode not implemented');
end

