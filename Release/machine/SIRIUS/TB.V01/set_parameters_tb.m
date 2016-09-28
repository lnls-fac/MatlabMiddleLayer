if strcmp(mode_version,'M1')
    
    %%% Initial Conditions
    IniCond.Dispersion = [0,0,0,0]';
    IniCond.beta = [7, 7];
    IniCond.alpha= [0,0];
    
    %%% Quadrupoles
    q1a_strength      =  3.197471856142;
    q1b_strength      =  -1.57498322484;
    q1c_strength      =  2.16753642533;
    qd2_strength      =  -8.420879613851;
    qf2_strength      =  13.146671512202;
    qd3a_strength      =  -5.003211465479;
    qf3a_strength      =  6.783244529016;
    qf3b_strength      =  2.895212566505;
    qd3b_strength      =  -2.984706731539;
    qf4_strength      =  7.963034094957;
    qd4_strength      =  -2.013774809345;
    qf5_strength      =  11.529185003262;
    qd5_strength      =  -7.084093211983;
  

elseif strcmp(mode_version,'M2')
    
    %%% Initial Conditions
    IniCond.Dispersion = [0,0,0,0]';
    IniCond.beta = [10, 10];
    IniCond.alpha= [0,0];
    
    %%% Quadrupoles
    q1a_strength      =  9.831704524983;
    q1b_strength      =  -4.217071772967;
    q1c_strength      =  -8.283779571728;
    qd2_strength      =  -8.420884154134;
    qf2_strength      =  13.146672851601;
    qd3a_strength      =  -5.786996070251;
    qf3a_strength      =  7.48800218842;
    qf3b_strength      =  3.444273863854;
    qd3b_strength      =  -4.370692899919;
    qf4_strength      =  9.275556378041;
    qd4_strength      =  -3.831727343173;
    qf5_strength      =  11.774551301802;
    qd5_strength      =  -7.239923812237;
    
elseif strcmp(mode_version,'M3')
    
    %%% Initial Conditions
    IniCond.Dispersion = [0,0,0,0]';
    IniCond.beta = [7, 7];
    IniCond.alpha= [-1.0,-1.0];
    
    %%% Quadrupoles
    q1a_strength      =  11.497289971737;
    q1b_strength      =  -4.009053542903;
    q1c_strength      =  -10.05208966219;
    qd2_strength      =  -8.4202421458;
    qf2_strength      =  13.146512110234;
    qd3a_strength      =  -4.742318522445;
    qf3a_strength      =  6.865529327161;
    qf3b_strength      =  3.644627263975;
    qd3b_strength      =  -3.640344975066;
    qf4_strength      =  6.882094963212;
    qd4_strength      =  -0.650373210524;
    qf5_strength      =  11.456881278596;
    qd5_strength      =  -7.183997114808;
    
elseif strcmp(mode_version,'M4')
    
    %%% Initial Conditions
    IniCond.Dispersion = [0,0,0,0]';
    IniCond.beta = [7, 7];
    IniCond.alpha= [1.0,1.0];
    
    %%% Quadrupoles
    q1a_strength      =  3.534340054347;
    q1b_strength      =  -6.58275439308;
    q1c_strength      =  8.590198057857;
    qd2_strength      =  -8.420952075727;
    qf2_strength      =  13.146690356394;
    qd3a_strength      =  -6.698085523725;
    qf3a_strength      =  7.789621927907;
    qf3b_strength      =  2.77064582429;
    qd3b_strength      =  -3.328855564917;
    qf4_strength      =  8.734105391772;
    qd4_strength      =  -3.014211757657;
    qf5_strength      =  11.424069037719;
    qd5_strength      =  -6.740424372291;
    
elseif strcmp(mode_version,'M5')
    
    %%% Initial Conditions
    IniCond.Dispersion = [0,0,0,0]';
    IniCond.beta = [7, 7];
    IniCond.alpha= [1.0,-1.0];
    
    %%% Quadrupoles
    q1a_strength      =  14.330293389213;
    q1b_strength      =  -3.670822362331;
    q1c_strength      =  -14.999984099609;
    qd2_strength      =  -8.420850561756;
    qf2_strength      =  13.146666514846;
    qd3a_strength      =  -5.621149037043;
    qf3a_strength      =  8.967988594169;
    qf3b_strength      =  2.958960220371;
    qd3b_strength      =  -3.210342770435;
    qf4_strength      =  8.311858252882;
    qd4_strength      =  -2.442934101437;
    qf5_strength      =  11.391698651189;
    qd5_strength      =  -6.772341213215;
    
elseif strcmp(mode_version,'M6')
    
    %%% Initial Conditions
    IniCond.Dispersion = [0,0,0,0]';
    IniCond.beta = [7, 7];
    IniCond.alpha= [-1.0,1.0];
    
    %%% Quadrupoles
    q1a_strength      =  10.334311920772;
    q1b_strength      =  -2.542582493248;
    q1c_strength      =  -10.124615533866;
    qd2_strength      =  -8.420886991042;
    qf2_strength      =  13.146673683891;
    qd3a_strength      =  -5.452694879372;
    qf3a_strength      =  7.345924165318;
    qf3b_strength      =  3.605078182875;
    qd3b_strength      =  -4.255957305622;
    qf4_strength      =  8.858246721391;
    qd4_strength      =  -3.243238337219;
    qf5_strength      =  11.728866700839;
    qd5_strength      =  -7.246970930681;
    
else
    error('caso nao implementado');
end