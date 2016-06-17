% carrega forcas dos imas de acordo com modo de operacao
%%% Initial Conditions

if strcmpi(mode_version,'M1')
        
    %%% Initial Conditions
    IniCond.Dispersion = [0.191; 0.0689; 0; 0];
    IniCond.beta = [6.57, 15.30];
    IniCond.alpha= [-2.155, 2.22];

    %%% Quadrupoles
    qf1a_strength =  1.634929446278;
    qf1b_strength =  1.25495452471;
    qd2_strength  = -3.396830092655;
    qf2_strength  = 2.692745244711;
    qf3_strength  = 3.264077845612;
    qd4a_strength = -3.333955924094;
    qf4_strength  = 4.074294731393;
    qd4b_strength = -1.697166344378;
    
    
elseif strcmp(mode_version,'M2')
    
    %%% Initial Conditions
    IniCond.Dispersion = [0.191; 0.0689; 0; 0];
    IniCond.beta = [6.57, 15.30];
    IniCond.alpha= [-2.155, 2.22];
    
    %%% Quadrupoles
    qf1a_strength = 1.755196171812;
    qf1b_strength = 1.495878014832;
    qd2_strength  = -3.411402110189;
    qf2_strength  = 2.707945541335;
    qf3_strength  = 3.151478128207;
    qd4a_strength = -3.205338032459;
    qf4_strength  = 4.047661696086;
    qd4b_strength = -1.766768035901;
    
else
    error('caso nao implementado');
end
