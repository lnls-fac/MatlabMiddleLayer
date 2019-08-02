if strcmp(mode_version,'M1')
    
    %%% Initial Conditions from Linac measured parameters on 16/07/2019 
    %%% Linac second quadrupole triplet set to same values used during measurements
    %%% (Sem tripleto)
    IniCond.Dispersion = [0.0, 0.0, 0.0, 0.0]';
    IniCond.beta =  [ 2.71462, 4.69925]';
    IniCond.alpha = [ -2.34174, 1.04009]';
    
    %%% Quadrupoles
    qf2L_strength     =  12.37;
    qd2L_strength     = -14.85;
    qf3L_strength     =  5.713160289024;

    qd1_strength      = -8.821809143987;
    qf1_strength      = 13.335946597802;
    qd2a_strength     = -11.859318300947;
    qf2a_strength     = 14.532892396682;
    qf2b_strength     = 8.647545577362;
    qd2b_strength     = -8.836916532517;
    qf3_strength      = 10.020651462368;
    qd3_strength      = -4.974049498621;
    qf4_strength      = 11.168208453391;
    qd4_strength      = -6.191738912262;

elseif strcmp(mode_version,'M2')
    
    %%% Initial Conditions from Linac measured parameters on 16/07/2019
    %%% Linac second quadrupole triplet is used to match the LBT optics
    %%% (Sem tripleto)
    IniCond.Dispersion = [0.0, 0.0, 0.0, 0.0]';
    IniCond.beta =  [ 2.71462, 4.69925]';
    IniCond.alpha = [ -2.34174, 1.04009]';
    
    %%% Quadrupoles
    qf2L_strength     = 11.78860;
    qd2L_strength     = -14.298290;
    qf3L_strength     = 4.801910;

    qd1_strength      = -8.822256368219;
    qf1_strength      = 13.336060990905;
    qd2a_strength     = -9.382785447106;
    qf2a_strength     = 12.670391768958;
    qf2b_strength     =  7.994238513566;
    qd2b_strength     = -7.118805773505;
    qf3_strength      = 10.328752039153;
    qd3_strength      = -5.519539215470;
    qf4_strength      = 11.635406805193;
    qd4_strength      = -6.936225524796;
    
elseif strcmp(mode_version,'M3')
    
    %%% Initial Conditions
    IniCond.Dispersion = [0.0, 0.0, 0.0, 0.0]';
    IniCond.beta =  [ 7.0, 7.0]';
    IniCond.alpha = [ -1.0, -1.0]';
    
    %%% Quadrupoles
    qf2L_strength     =  4.041196327091;
    qd2L_strength     = -0.650383961873;
    qf3L_strength     = -5.281412558677;

    qd1_strength      = -8.822291491517;
    qf1_strength      = 13.336068415592;
    qd2a_strength     = -9.526087059234;
    qf2a_strength     = 12.508106877516;
    qf2b_strength     = 10.147197913448;
    qd2b_strength     = -9.233538836854;
    qf3_strength      = 10.61411980277;
    qd3_strength      = -5.991431546489;
    qf4_strength      = 11.854633649452;
    qd4_strength      = -7.265597342644;
 
elseif strcmp(mode_version,'M4')
    
    %%% Initial Conditions
    IniCond.Dispersion = [0.0, 0.0, 0.0, 0.0]';
    IniCond.beta =  [ 7.0, 7.0]';
    IniCond.alpha = [ 1.0, 1.0]';
    
    %%% Quadrupoles
    qf2L_strength     =  3.31553030565;
    qd2L_strength     = -3.298430735342;
    qf3L_strength     =  0.325346363503;

    qd1_strength      = -8.822281498524;
    qf1_strength      = 13.336065603976;
    qd2a_strength     = -9.016549707329;
    qf2a_strength     = 12.826318785391;
    qf2b_strength     =  8.040189594896;
    qd2b_strength     = -7.646098584338;
    qf3_strength      = 10.253461277416;
    qd3_strength      = -5.361705635217;
    qf4_strength      = 11.408003594895;
    qd4_strength      = -6.555793655328;
    
elseif strcmp(mode_version,'M5')
    
    %%% Initial Conditions
    IniCond.Dispersion = [0.0, 0.0, 0.0, 0.0]';
    IniCond.beta =  [ 7.0, 7.0]';
    IniCond.alpha = [ 1.0, -1.0]';
    
    %%% Quadrupoles
    qf2L_strength     = 3.847021491694;
    qd2L_strength     = -4.051995180352;
    qf3L_strength     = 0.173551608926;

    qd1_strength      =  -8.822291329455;
    qf1_strength      =  13.336068348432;
    qd2a_strength     = -10.064438360091;
    qf2a_strength     =  12.780558711588;
    qf2b_strength     =   7.459194473981;
    qd2b_strength     =  -7.65447912228;
    qf3_strength      =  12.554046391048;
    qd3_strength      =  -9.104860074805;
    qf4_strength      =  11.834034056244;
    qd4_strength      =  -6.835374207679;

elseif strcmp(mode_version,'M6')
    
    %%% Initial Conditions
    IniCond.Dispersion = [0.0, 0.0, 0.0, 0.0]';
    IniCond.beta =  [ 7.0, 7.0]';
    IniCond.alpha = [ -1.0, 1.0]';
    
    %%% Quadrupoles
    qf2L_strength     = 4.782319763405;
    qd2L_strength     = -3.290324589514;
    qf3L_strength     = -1.477243207812;

    qd1_strength      = -8.822291674213;
    qf1_strength      = 13.336067285289;
    qd2a_strength     = -8.572270653354;
    qf2a_strength     = 12.10255272008;
    qf2b_strength     =  9.030339176282;
    qd2b_strength     = -7.933720735927;
    qf3_strength      = 10.172566417695;
    qd3_strength      = -5.325646205442;
    qf4_strength      = 11.806095745404;
    qd4_strength      = -7.269145836899;
    
else
    error('caso nao implementado');
end
