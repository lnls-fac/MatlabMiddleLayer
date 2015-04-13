% carrega forcas dos imas de acordo com modo de operacao
%%% Initial Conditions

if strcmpi(mode_version,'M0')
        
    %%% Initial Conditions
    IniCond.Dispersion = [0.191; 0.0689; 0; 0];
    IniCond.beta = [6.57, 15.30];
    IniCond.alpha= [-2.155, 2.22];

    %%% Quadrupoles
    qa1_strength      = 0.843487;
    qa2_strength      = 1.009714;
    qb1_strength      = -0.328651;
    qb2_strength      = 2.190787;
    qc1_strength      = -1.879466;
    qc2_strength      = 1.805734;
    qc3_strength      = 1.805734;
    qc4_strength      = -1.328187;
    
else
    error('caso nao implementado');
end