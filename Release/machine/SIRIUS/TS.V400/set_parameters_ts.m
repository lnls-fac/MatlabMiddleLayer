% carrega forcas dos imas de acordo com modo de operacao
%%% Initial Conditions

if strcmpi(mode_version,'M0')
        
    %%% Initial Conditions
    IniCond.Dispersion = [0.191; 0.0689; 0; 0];
    IniCond.beta = [6.57, 15.30];
    IniCond.alpha= [-2.155, 2.22];

    %%% Quadrupoles
    qa1_strength      = 0.933780311192;
    qa2_strength      = -0.30421250462;
    qb1_strength      = -0.707859600647;
    qc1_strength      = 1.071226504299;
    qc2_strength      = 1.343420521969;
    qd1_strength      = -1.309590153205;
    qd2_strength      = 1.783674677944;
    qd3_strength      = 1.599191256076;
    qd4_strength      = -1.383646957188;
    
else
    error('caso nao implementado');
end
