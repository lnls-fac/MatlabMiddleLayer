% carrega forcas dos imas de acordo com modo de operacao
%%% Initial Conditions

if strcmpi(mode_version,'M1')
        
    %%% Initial Conditions
    IniCond.Dispersion = [0.191; 0.0689; 0; 0];
    IniCond.beta = [6.57, 15.30];
    IniCond.alpha= [-2.155, 2.22];

    %%% Quadrupoles
    qf1a_strength =  1.688528648631;
    qf1b_strength =  1.210772802151;
    qd2_strength  = -3.520376313964;
    qf2_strength  = 2.649990468945;
    qf3_strength  = 3.245755500062;
    qd4a_strength = -3.41825806902;
    qf4_strength  = 4.154549899205;
    qd4b_strength = -1.826959309409;
    
    
elseif strcmp(mode_version,'M2')
    
    %%% Initial Conditions
    IniCond.Dispersion = [0.191; 0.0689; 0; 0];
    IniCond.beta = [6.57, 15.30];
    IniCond.alpha= [-2.155, 2.22];
    
    %%% Quadrupoles
    qf1a_strength = 2.065621057362;
    qf1b_strength = 0.668302253919;
    qd2_strength  = -3.190836498251;
    qf2_strength  = 2.861614166104;
    qf3_strength  = 3.166044768191;
    qd4a_strength = -3.313624597572;
    qf4_strength  = 3.845505089703;
    qd4b_strength = -1.427650250322;
    
else
    error('caso nao implementado');
end
