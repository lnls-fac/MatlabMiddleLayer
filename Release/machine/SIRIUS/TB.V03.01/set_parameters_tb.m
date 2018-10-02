if strcmp(mode_version,'M1')
    
    %%% Initial Conditions
    IniCond.Dispersion = [0.0, 0.0, 0.0, 0.0]';
    IniCond.beta =  [ 7.0, 7.0]';
    IniCond.alpha = [ 0.0, 0.0]';
    
    %%% Quadrupoles
    qf2L_strength =  3.197471856142;
    qd2L_strength = -1.57498322484;
    qf3L_strength =  2.16753642533;

    qd1_strength      =  -8.420879613851;
    qf1_strength      =  13.146671512202;
    qd2a_strength      =  -5.003211465479;
    qf2a_strength      =  6.783244529016;
    qf2b_strength      =  2.895212566505;
    qd2b_strength      =  -2.984706731539;
    qf3_strength      =  7.963034094957;
    qd3_strength      =  -2.013774809345;
    qf4_strength      =  11.529185003262;
    qd4_strength      =  -7.084093211983;
  

elseif strcmp(mode_version,'M2')
    
    %%% Initial Conditions
    IniCond.Dispersion = [0.0, 0.0, 0.0, 0.0]';
    IniCond.beta =  [ 10.0, 10.0]';
    IniCond.alpha = [ 0.0, 0.0]';
    
    %%% Quadrupoles
    qf2L_strength =  9.831704524983;
    qd2L_strength = -4.217071772967;
    qf3L_strength = -8.283779571728;

    qd1_strength      =  -8.420884154134;
    qf1_strength      =  13.146672851601;
    qd2a_strength      =  -5.786996070251;
    qf2a_strength      =  7.48800218842;
    qf2b_strength      =  3.444273863854;
    qd2b_strength      =  -4.370692899919;
    qf3_strength      =  9.275556378041;
    qd3_strength      =  -3.831727343173;
    qf4_strength      =  11.774551301802;
    qd4_strength      =  -7.239923812237;
    
elseif strcmp(mode_version,'M3')
    
    %%% Initial Conditions
    IniCond.Dispersion = [0.0, 0.0, 0.0, 0.0]';
    IniCond.beta =  [ 7.0, 7.0]';
    IniCond.alpha = [ -1.0, -1.0]';
    
    %%% Quadrupoles
    qf2L_strength =  11.497289971737;
    qd2L_strength =  -4.009053542903;
    qf3L_strength = -10.05208966219;

    qd1_strength      =  -8.4202421458;
    qf1_strength      =  13.146512110234;
    qd2a_strength      =  -4.742318522445;
    qf2a_strength      =  6.865529327161;
    qf2b_strength      =  3.644627263975;
    qd2b_strength      =  -3.640344975066;
    qf3_strength      =  6.882094963212;
    qd3_strength      =  -0.650373210524;
    qf4_strength      =  11.456881278596;
    qd4_strength      =  -7.183997114808;
    
elseif strcmp(mode_version,'M4')
    
    %%% Initial Conditions
    IniCond.Dispersion = [0.0, 0.0, 0.0, 0.0]';
    IniCond.beta =  [ 7.0, 7.0]';
    IniCond.alpha = [ 1.0, 1.0]';
    
    %%% Quadrupoles
    qf2L_strength =  3.534340054347;
    qd2L_strength = -6.58275439308;
    qf3L_strength =  8.590198057857;
    
    qd1_strength      =  -8.420952075727;
    qf1_strength      =  13.146690356394;
    qd2a_strength      =  -6.698085523725;
    qf2a_strength      =  7.789621927907;
    qf2b_strength      =  2.77064582429;
    qd2b_strength      =  -3.328855564917;
    qf3_strength      =  8.734105391772;
    qd3_strength      =  -3.014211757657;
    qf4_strength      =  11.424069037719;
    qd4_strength      =  -6.740424372291;
    
elseif strcmp(mode_version,'M5')
    
    %%% Initial Conditions
    IniCond.Dispersion = [0.0, 0.0, 0.0, 0.0]';
    IniCond.beta =  [ 7.0, 7.0]';
    IniCond.alpha = [ 1.0, -1.0]';
    
    %%% Quadrupoles
    qf2L_strength =  14.330293389213;
    qd2L_strength =  -3.670822362331;
    qf3L_strength = -14.999984099609;
    
    qd1_strength      =  -8.420850561756;
    qf1_strength      =  13.146666514846;
    qd2a_strength      =  -5.621149037043;
    qf2a_strength      =  8.967988594169;
    qf2b_strength      =  2.958960220371;
    qd2b_strength      =  -3.210342770435;
    qf3_strength      =  8.311858252882;
    qd3_strength      =  -2.442934101437;
    qf4_strength      =  11.391698651189;
    qd4_strength      =  -6.772341213215;
    
elseif strcmp(mode_version,'M6')
    
    %%% Initial Conditions
    IniCond.Dispersion = [0.0, 0.0, 0.0, 0.0]';
    IniCond.beta =  [ 7.0, 7.0]';
    IniCond.alpha = [ -1.0, 1.0]';
    
    %%% Quadrupoles
    qf2L_strength =  10.334311920772;
    qd2L_strength =  -2.542582493248;
    qf3L_strength = -10.124615533866;
    
    qd1_strength      =  -8.420886991042;
    qf1_strength      =  13.146673683891;
    qd2a_strength      =  -5.452694879372;
    qf2a_strength      =  7.345924165318;
    qf2b_strength      =  3.605078182875;
    qd2b_strength      =  -4.255957305622;
    qf3_strength      =  8.858246721391;
    qd3_strength      =  -3.243238337219;
    qf4_strength      =  11.728866700839;
    qd4_strength      =  -7.246970930681;
    
else
    error('caso nao implementado');
end