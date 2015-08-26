if strcmp(mode_version,'M1')
    
    %%% Initial Conditions
    IniCond.Dispersion = [0,0,0,0]';
    IniCond.beta = [7, 7];
    IniCond.alpha= [0,0];
    
    %%% Quadrupoles
    qa1_strength      =  3.197471856142;
    qa2_strength      =  -1.57498322484;
    qa3_strength      =  2.16753642533;
    qb1_strength      =  -8.420879613851;
    qb2_strength      =  13.146671512202;
    qc1_strength      =  -5.003211465479;
    qc2_strength      =  6.783244529016;
    qc3_strength      =  2.895212566505;
    qc4_strength      =  -2.984706731539;
    qd1_strength      =  7.963034094957;
    qd2_strength      =  -2.013774809345;
    qe1_strength      =  11.529185003262;
    qe2_strength      =  -7.084093211983;
    
elseif strcmp(mode_version,'M2')
    
    %%% Initial Conditions
    IniCond.Dispersion = [0,0,0,0]';
    IniCond.beta = [10, 10];
    IniCond.alpha= [0,0];
    
    %%% Quadrupoles
    qa1_strength      =  9.831704524983;
    qa2_strength      =  -4.217071772967;
    qa3_strength      =  -8.283779571728;
    qb1_strength      =  -8.420884154134;
    qb2_strength      =  13.146672851601;
    qc1_strength      =  -5.786996070251;
    qc2_strength      =  7.48800218842;
    qc3_strength      =  3.444273863854;
    qc4_strength      =  -4.370692899919;
    qd1_strength      =  9.275556378041;
    qd2_strength      =  -3.831727343173;
    qe1_strength      =  11.774551301802;
    qe2_strength      =  -7.239923812237;
    
elseif strcmp(mode_version,'M3')
    
    %%% Initial Conditions
    IniCond.Dispersion = [0,0,0,0]';
    IniCond.beta = [7, 7];
    IniCond.alpha= [-1.0,-1.0];
    
    %%% Quadrupoles
    qa1_strength      =  11.497289971737;
    qa2_strength      =  -4.009053542903;
    qa3_strength      =  -10.05208966219;
    qb1_strength      =  -8.4202421458;
    qb2_strength      =  13.146512110234;
    qc1_strength      =  -4.742318522445;
    qc2_strength      =  6.865529327161;
    qc3_strength      =  3.644627263975;
    qc4_strength      =  -3.640344975066;
    qd1_strength      =  6.882094963212;
    qd2_strength      =  -0.650373210524;
    qe1_strength      =  11.456881278596;
    qe2_strength      =  -7.183997114808;
    
elseif strcmp(mode_version,'M4')
    
    %%% Initial Conditions
    IniCond.Dispersion = [0,0,0,0]';
    IniCond.beta = [7, 7];
    IniCond.alpha= [1.0,1.0];
    
    %%% Quadrupoles
    qa1_strength      =  3.534340054347;
    qa2_strength      =  -6.58275439308;
    qa3_strength      =  8.590198057857;
    qb1_strength      =  -8.420952075727;
    qb2_strength      =  13.146690356394;
    qc1_strength      =  -6.698085523725;
    qc2_strength      =  7.789621927907;
    qc3_strength      =  2.77064582429;
    qc4_strength      =  -3.328855564917;
    qd1_strength      =  8.734105391772;
    qd2_strength      =  -3.014211757657;
    qe1_strength      =  11.424069037719;
    qe2_strength      =  -6.740424372291;
    
elseif strcmp(mode_version,'M5')
    
    %%% Initial Conditions
    IniCond.Dispersion = [0,0,0,0]';
    IniCond.beta = [7, 7];
    IniCond.alpha= [1.0,-1.0];
    
    %%% Quadrupoles
    qa1_strength      =  14.330293389213;
    qa2_strength      =  -3.670822362331;
    qa3_strength      =  -14.999984099609;
    qb1_strength      =  -8.420850561756;
    qb2_strength      =  13.146666514846;
    qc1_strength      =  -5.621149037043;
    qc2_strength      =  8.967988594169;
    qc3_strength      =  2.958960220371;
    qc4_strength      =  -3.210342770435;
    qd1_strength      =  8.311858252882;
    qd2_strength      =  -2.442934101437;
    qe1_strength      =  11.391698651189;
    qe2_strength      =  -6.772341213215;
    
elseif strcmp(mode_version,'M6')
    
    %%% Initial Conditions
    IniCond.Dispersion = [0,0,0,0]';
    IniCond.beta = [7, 7];
    IniCond.alpha= [-1.0,1.0];
    
    %%% Quadrupoles
    qa1_strength      =  10.334311920772;
    qa2_strength      =  -2.542582493248;
    qa3_strength      =  -10.124615533866;
    qb1_strength      =  -8.420886991042;
    qb2_strength      =  13.146673683891;
    qc1_strength      =  -5.452694879372;
    qc2_strength      =  7.345924165318;
    qc3_strength      =  3.605078182875;
    qc4_strength      =  -4.255957305622;
    qd1_strength      =  8.858246721391;
    qd2_strength      =  -3.243238337219;
    qe1_strength      =  11.728866700839;
    qe2_strength      =  -7.246970930681;
    
else
    error('caso nao implementado');
end