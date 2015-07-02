% carrega forcas dos imas de acordo com modo de operacao
%%% Initial Conditions

if strcmpi(mode_version,'M0')
        
    %%% Initial Conditions
    IniCond.Dispersion = [0.191; 0.0689; 0; 0];
    IniCond.beta = [6.57, 15.30];
    IniCond.alpha= [-2.155, 2.22];

    %%% Quadrupoles
    qf_01_a_strength =  1.174675433697;
    qf_01_b_strength =  0.785231804523;
    qd_02_strength   = -1.868020422351;
    qf_02_strength   =  1.304209041893;
    qd_03_strength   = -3.005264843388;
    qf_03_strength   =  3.465683477884;
    qd_04_a_strength = -3.309677108863;
    qf_04_strength   =  3.774983925753;
    qd_04_b_strength = -1.342802552122;

else
    error('caso nao implementado');
end
