% carrega forcas dos imas de acordo com modo de operacao
%%% Initial Conditions

if strcmpi(mode_version,'M1')
        
    %%% Initial Conditions
    IniCond.Dispersion = [0.191; 0.0689; 0; 0];
    IniCond.beta = [6.57, 15.30];
    IniCond.alpha= [-2.155, 2.22];

    %%% Quadrupoles
    qf1a_strength =  1.684808484818;
    qf1b_strength =  1.219399690114;
    qd2_strength  = -3.517025640126;
    qf2_strength  = 3.759461988653;
    qf3_strength  = 3.244614087865;
    qd4a_strength = -3.426138552933;
    qf4_strength  = 4.154311086289;
    qd4b_strength = -1.823603239212;
    
elseif strcmp(mode_version,'M2')
    
    %%% Initial Conditions
    IniCond.Dispersion = [0.191; 0.0689; 0; 0];
    IniCond.beta = [6.57, 15.30];
    IniCond.alpha= [-2.155, 2.22];
    
    %%% Quadrupoles
    qf1a_strength = 2.051930439004;
    qf1b_strength = 0.702915272007;
    qd2_strength  = -3.147510154395;
    qf2_strength  = 4.023324888575;
    qf3_strength  = 3.164477543535;
    qd4a_strength = -3.30415436161;
    qf4_strength  = 3.852123122977;
    qd4b_strength = -1.436723284084;
    
else
    error('caso nao implementado');
end
