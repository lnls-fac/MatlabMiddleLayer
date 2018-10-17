if strcmp(mode_version,'M1')
    
    %%% Initial Conditions from Linac measured parameters
    IniCond.Dispersion = [0.0, 0.0, 0.0, 0.0]';
    IniCond.beta =  [ 7.46, 16.86]';
    IniCond.alpha = [ -0.50, 13.30]';
    
    %%% Quadrupoles
    qf2L_strength     =  4.952541416674;
    qd2L_strength     = -2.118904041299;
    qf3L_strength     =  1.910188227337;

    qd1_strength      = -8.822291640536;
    qf1_strength      = 13.33606849342;
    qd2a_strength     = -9.379077431495;
    qf2a_strength     = 11.227046604434;
    qf2b_strength     =  3.469836865301;
    qd2b_strength     = -4.850764599732;
    qf3_strength      =  9.27727582087;
    qd3_strength      = -3.985859160514;
    qf4_strength      = 11.479952189069;
    qd4_strength      = -6.876402358085;

elseif strcmp(mode_version,'M2')
    
    %%% Initial Conditions
    IniCond.Dispersion = [0.0, 0.0, 0.0, 0.0]';
    IniCond.beta =  [ 10.0, 10.0]';
    IniCond.alpha = [ 0.0, 0.0]';
    
    %%% Quadrupoles
    qf2L_strength     = 4.18478853946 ;
    qd2L_strength     = -3.771441137844;
    qf3L_strength     = 0.11370289059;

    qd1_strength      = -8.822291815908;
    qf1_strength      = 13.336068473115;
    qd2a_strength     = -8.824964866651;
    qf2a_strength     = 12.009488451446;
    qf2b_strength     =  7.697183737381;
    qd2b_strength     = -6.561781447069;
    qf3_strength      = 10.427436884006;
    qd3_strength      = -5.708542016046;
    qf4_strength      = 11.838583437399;
    qd4_strength      = -7.274915332856;
    
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