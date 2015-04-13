% set_magnet_strengths

if strcmpi(mode,'A')
    if strcmpi(version,'00')% old ac20.2
        %%% QUADRUPOLOS
        %  ===========
        
        qaf_strength   = 2.515526;
        qad_strength   = -2.602399;
        qf1_strength   = 2.372377;
        qf2_strength   = 3.351939;
        qf3_strength   = 3.062241;
        qf4_strength   = 2.726014;
        
        % vinculos para o modo AC20
        qbd1_strength  = qad_strength;
        qbf_strength   = qaf_strength;
        qbd2_strength  = +0.000000000000;
        
        %%% SEXTUPOLOS
        % ==========
        sa2_strength   =   27.260886;
        sa1_strength   =  -53.895434;
        sd1a_strength  =  -85.452385;
        sf1a_strength  =  186.287910;
        sd2a_strength  = -127.382337;
        sd3a_strength  = -154.506764;
        sf2a_strength  =  156.861444;
        sd1b_strength  =  sd1a_strength;
        sf1b_strength  =  sf1a_strength;
        sd2b_strength  =  sd2a_strength;
        sd3b_strength  =  sd3a_strength;
        sf2b_strength  =  sf2a_strength;
        
        % v???nculos para o modo AC20
        sb1_strength   = sa1_strength;
        sb2_strength   = sa2_strength;
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
        qaf_strength       =  2.536876;
        qad_strength       = -2.730416;
        qbd2_strength      = -3.961194;
        qbf_strength       =  3.902838;
        qbd1_strength      = -2.966239;
        qf1_strength       =  2.367821;
        qf2_strength       =  3.354286;
        qf3_strength       =  3.080632;
        qf4_strength       =  2.707639;
        %%% SEXTUPOLOS
        %  ==========
        sa1_strength       = -115.7829759411277/2;
        sa2_strength       =   49.50386128829739/2;
        sb1_strength       = -214.5386552515188/2;
        sb2_strength       =  133.1252391065637/2;
        sd1a_strength      = -302.6188062085843/2;
        sf1a_strength      =  369.5045185071228/2;
        sd2a_strength      = -164.3042864671946/2;
        sd3a_strength      = -289.9270429064217/2;
        sf2a_strength      =  333.7039740852999/2;
        sd1b_strength      = -302.6188062085843/2;
        sf1b_strength      =  369.5045185071228/2;
        sd2b_strength      = -164.3042864671946/2;
        sd3b_strength      = -289.9270429064217/2;
        sf2b_strength      =  333.7039740852999/2;
        
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
    if strcmpi(version,'00')
        [path, ~, ~] = fileparts(mfilename('fullpath'));
        cur = pwd;
        cd(fullfile(path,'opt_results/c/mantemV500/'));
        eval('firstRun_000556');
        cd(cur);
    
    elseif strncmpi(version, 'opt_results_elegant',19)
        
        [path, ~, ~] = fileparts(mfilename('fullpath'));
        cur = pwd;
        cd(fullfile(path,'opt_results/c/attempts/mantemV500/'));
        eval(version(19+2:end));
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

