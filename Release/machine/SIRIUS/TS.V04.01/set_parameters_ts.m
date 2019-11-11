% carrega forcas dos imas de acordo com modo de operacao
%%% Initial Conditions
IniCond.Dispersion = [0.231; 0.069; 0; 0];
IniCond.beta = [9.321, 12.881];
IniCond.alpha= [-2.647, 2.000];

if strcmpi(mode_version,'M1')
    %%% Quadrupoles
    %%% Alphas and Dispersion Matches, Betax Max = 40m
    qf1ah_strength = 1.247810891477;
    qf1bh_strength = 2.269454982012;
    qd2h_strength  = -3.095390628668;
    qf2h_strength  = 2.478673710387;
    qf3h_strength  = 2.48378256297;
    qd4ah_strength = -2.570893964278;
    qf4h_strength  = 3.549734282477;
    qd4bh_strength = -2.209083568757;

    ejeseptg_kxl_strength = 0;
    ejeseptg_kyl_strength = 0;
    ejeseptg_ksxl_strength = 0;
    ejeseptg_ksyl_strength = 0;

    ejeseptf_kxl_strength = 0;
    ejeseptf_kyl_strength = 0;
    ejeseptf_ksxl_strength = 0;
    ejeseptf_ksyl_strength = 0;

    injseptg_kxl_strength = 0;
    injseptg_kyl_strength = 0;
    injseptg_ksxl_strength = 0;
    injseptg_ksyl_strength = 0;

    injseptf_kxl_strength = 0;
    injseptf_kyl_strength = 0;
    injseptf_ksxl_strength = 0;
    injseptf_ksyl_strength = 0;
elseif strcmp(mode_version,'M2')
    %%% Mismatched NLK
    %%% Quadrupoles
    qf1ah_strength = 1.563599428323;
    qf1bh_strength = 2.303150061796;
    qd2h_strength  = -2.95822108328;
    qf2h_strength  = 2.815338463764;
    qf3h_strength  = 2.433331684549;
    qd4ah_strength = -2.295731518617;
    qf4h_strength  = 3.413868033048;
    qd4bh_strength = -2.230138095518;

    ejeseptg_kxl_strength = 0;
    ejeseptg_kyl_strength = 0;
    ejeseptg_ksxl_strength = 0;
    ejeseptg_ksyl_strength = 0;

    ejeseptf_kxl_strength = 0;
    ejeseptf_kyl_strength = 0;
    ejeseptf_ksxl_strength = 0;
    ejeseptf_ksyl_strength = 0;

    injseptg_kxl_strength = 0;
    injseptg_kyl_strength = 0;
    injseptg_ksxl_strength = 0;
    injseptg_ksyl_strength = 0;

    injseptf_kxl_strength = 0;
    injseptf_kyl_strength = 0;
    injseptf_ksxl_strength = 0;
    injseptf_ksyl_strength = 0;
elseif strcmp(mode_version,'M3')
    %%% Matched optics, betax_max=100m
    qf1ah_strength = 0.801090058058;
    qf1bh_strength = 2.83641570018;
    qd2h_strength  = -3.025223032377;
    qf2h_strength  = 1.753256050021;
    qf3h_strength  = 2.353655122791;
    qd4ah_strength = -2.670345064247;
    qf4h_strength  = 3.530990934212;
    qd4bh_strength = -2.073377200462;

    ejeseptg_kxl_strength = 0;
    ejeseptg_kyl_strength = 0;
    ejeseptg_ksxl_strength = 0;
    ejeseptg_ksyl_strength = 0;

    ejeseptf_kxl_strength = 0;
    ejeseptf_kyl_strength = 0;
    ejeseptf_ksxl_strength = 0;
    ejeseptf_ksyl_strength = 0;

    injseptg_kxl_strength = 0;
    injseptg_kyl_strength = 0;
    injseptg_ksxl_strength = 0;
    injseptg_ksyl_strength = 0;

    injseptf_kxl_strength = 0;
    injseptf_kyl_strength = 0;
    injseptf_ksxl_strength = 0;
    injseptf_ksyl_strength = 0;
else
    error('caso nao implementado');
end
