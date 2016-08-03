% carrega forcas dos imas de acordo com modo de operacao
%%% Initial Conditions

if strcmpi(mode_version,'M1')
        
    %%% Initial Conditions
    IniCond.Dispersion = [0.231; 0.069; 0; 0];
    IniCond.beta = [9.321, 12.881];
    IniCond.alpha= [-2.647, 2.000];

    %%% Quadrupoles
    qf1a_strength =  1.705136451464;
    qf1b_strength =  1.735103626163;
    qd2_strength  = -2.824605948436;
    qf2_strength  = 2.761096350672;
    qf3_strength  = 2.632174016223;
    qd4a_strength = -3.048724560996;
    qf4_strength  = 3.613077989506;
    qd4b_strength = -1.462227938539;
    
    
elseif strcmp(mode_version,'M2')
    
    %%% Initial Conditions
    IniCond.Dispersion = [0.231; 0.069; 0; 0];
    IniCond.beta = [9.321, 12.881];
    IniCond.alpha= [-2.647, 2.000];
    
    %%% Quadrupoles
    qf1a_strength = 1.670591749495;
    qf1b_strength = 2.098894537642;
    qd2_strength  = -2.906928147717;
    qf2_strength  = 2.807119577145;
    qf3_strength  = 2.533790522922;
    qd4a_strength = -2.962464773591;
    qf4_strength  = 3.537426973134;
    qd4b_strength = -1.421186305251;
    
else
    error('caso nao implementado');
end
