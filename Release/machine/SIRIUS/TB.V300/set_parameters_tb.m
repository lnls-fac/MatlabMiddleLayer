if strcmp(mode_version,'M0')
    
    %%% Initial Conditions
    IniCond.Dispersion = [0,0,0,0]';
    IniCond.beta = [7, 7];
    IniCond.alpha= [0,0];
    
    %%% Quadrupoles
    qa1_strength      = -2.21152972152;
    qa2_strength      = 2.436565597315;
    qa3_strength      = 2.944664976927;
    qb1_strength      = -7.994863622645;
    qb2_strength      = 12.470831578209;
    qc1_strength      = 9.135708323003;
    qc2_strength      = -6.89731166729;
    qc3_strength      = 0.651478914626;
    qd1_strength      = -1.562924213148;
    qd2_strength      = 9.280897878126;
    qe1_strength      = -7.113882274148;
    qe2_strength      = 7.354940993661;
    
elseif strcmp(mode_version,'M1')
    
    %%% Initial Conditions
    IniCond.Dispersion = [0,0,0,0]';
    IniCond.beta = [10, 10];
    IniCond.alpha= [0,0];
    
    %%% Quadrupoles
    qa1_strength      = -1.894796410344;
    qa2_strength      = 2.591332064725;
    qa3_strength      = 1.954509705257;
    qb1_strength      = -7.994296065915;
    qb2_strength      = 12.47072026715;
    qc1_strength      = 9.00295217375;
    qc2_strength      = -6.548501985294;
    qc3_strength      = 0.028042146561;
    qd1_strength      = -1.464554145277;
    qd2_strength      = 9.279984374252;
    qe1_strength      = -7.216396927507;
    qe2_strength      = 7.415421268623;
        
elseif strcmp(mode_version,'M2')
    
    %%% Initial Conditions
    IniCond.Dispersion = [0,0,0,0]';
    IniCond.beta = [7, 7];
    IniCond.alpha= [-1.0,-1.0];
    
    %%% Quadrupoles
    qa1_strength      = -9.237971344315;
    qa2_strength      = 10.859445894858;
    qa3_strength      = 0.121741152796E-2;
    qb1_strength      = -7.995882349279;
    qb2_strength      = 12.471030478658;
    qc1_strength      = 8.09488048577;
    qc2_strength      = -5.287854389627;
    qc3_strength      = 1.676368208983;
    qd1_strength      = -5.621181826558;
    qd2_strength      = 10.473421516841;
    qe1_strength      = -10.44952748814;
    qe2_strength      = 7.15474631186;
    
else
    error('caso nao implementado');
end