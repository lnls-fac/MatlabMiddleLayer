% carrega forcas dos imas de acordo com modo de operacao
%%% Initial Conditions
IniCond.Dispersion = [0.21135; 0.06939; 0; 0];
IniCond.beta = [7.906, 11.841];
IniCond.alpha= [-2.4231, 1.8796];

if strcmpi(mode_version,'M1')
    % Unmatched optics at dipolar kicker (betax_max = 40m)
    qf1ah_strength = 1.814573972458;
    qf1bh_strength = 2.097583535652;
    qd2h_strength  = -2.872960628905;
    qf2h_strength  = 2.804180421441;
    qf3h_strength  = 2.55050231931;
    qd4ah_strength = -2.358451356072;
    qf4h_strength  = 3.388995991451;
    qd4bh_strength = -2.209843757138;

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
