if strcmp(mode_version,'M1')
    % Initial Conditions from Linac measured parameters on 30/08/2019
    % Linac second quadrupole triplet set to same values used during
    % measurements
    % (Sem tripleto)
    % QD4 freed to be focusing in fitting.
    IniCond.Dispersion = [0.0, 0.0, 0.0, 0.0]';
    IniCond.beta =  [ 1.45401, 2.47656]';
    IniCond.alpha = [ -1.57249, 0.527312]';

    %%% Quadrupoles
    qf2L_strength = 12.37;
    qd2L_strength = -14.85;
    qf3L_strength = 6.3387;

    qd1_strength = -8.8224;
    qf1_strength = 13.3361;
    qd2a_strength = -10.8698;
    qf2a_strength = 13.8136;
    qf2b_strength = 6.9037;
    qd2b_strength = -6.3496;
    qf3_strength = 13.4901;
    qd3_strength = -10.8577;
    qf4_strength = 8.1889;
    qd4_strength = 0.6693;

    injsept_kxl_strength = -0.39475202;
    injsept_kyl_strength = +0.35823882;
    injsept_ksxl_strength = -0.04944937;
    injsept_ksyl_strength = -0.00393883;

elseif strcmp(mode_version,'M2')
    % Initial Conditions from Linac measured parameters on 30/08/2019
    % Linac second quadrupole triplet set to same values used during
    % measurements
    % (Sem tripleto)
    IniCond.Dispersion = [0.0, 0.0, 0.0, 0.0]';
    IniCond.beta =  [ 1.45401, 2.47656]';
    IniCond.alpha = [ -1.57249, 0.527312]';

    %%% Quadrupoles
    qf2L_strength = 12.37;
    qd2L_strength = -14.85;
    qf3L_strength = 6.342735948415;

    qd1_strength = -8.822330690694;
    qf1_strength = 13.336079810152;
    qd2a_strength = -11.779088961602;
    qf2a_strength = 14.331275527616;
    qf2b_strength = 8.958478776817;
    qd2b_strength = -8.99233133968;
    qf3_strength = 11.263508962434;
    qd3_strength = -6.891349798498;
    qf4_strength = 9.84840688362;
    qd4_strength = -3.114739958144;

    injsept_kxl_strength = -0.3;
    injsept_kyl_strength = +0.3;
    injsept_ksxl_strength = 0.0;
    injsept_ksyl_strength = 0.0;

elseif strcmp(mode_version,'M3')
    % Initial Conditions from Linac measured parameters on 16/07/2019
    % Linac second quadrupole triplet set to same values used during
    % measurements
    % (Sem tripleto)
    IniCond.Dispersion = [0.0, 0.0, 0.0, 0.0]';
    IniCond.beta =  [2.71462, 4.69925]';
    IniCond.alpha = [-2.34174, 1.04009]';

    %%% Quadrupoles
    qf2L_strength =  12.37;
    qd2L_strength = -14.85;
    qf3L_strength =  5.713160289024;

    qd1_strength = -8.821809143987;
    qf1_strength = 13.335946597802;
    qd2a_strength = -11.859318300947;
    qf2a_strength = 14.532892396682;
    qf2b_strength = 8.647545577362;
    qd2b_strength = -8.836916532517;
    qf3_strength = 10.020651462368;
    qd3_strength = -4.974049498621;
    qf4_strength = 11.168208453391;
    qd4_strength = -6.191738912262;

    injsept_kxl_strength = 0.0;
    injsept_kyl_strength = 0.0;
    injsept_ksxl_strength = 0.0;
    injsept_ksyl_strength = 0.0;

elseif strcmp(mode_version,'M4')
    % Initial Conditions from Linac measured parameters on 16/07/2019
    % Linac second quadrupole triplet set to same values used during
    % measurements
    % (Sem tripleto)
    %%% Initial Conditions
    IniCond.Dispersion = [0.0, 0.0, 0.0, 0.0]';
    IniCond.beta =  [2.71462, 4.69925]';
    IniCond.alpha = [-2.34174, 1.04009]';


    %%% Quadrupoles
    qf2L_strength =  11.78860;
    qd2L_strength = -14.298290;
    qf3L_strength = 4.801910;

    qd1_strength = -8.822256368219;
    qf1_strength = 13.336060990905;
    qd2a_strength = -9.382785447106;
    qf2a_strength = 12.670391768958;
    qf2b_strength = 7.994238513566;
    qd2b_strength = -7.118805773505;
    qf3_strength = 10.328752039153;
    qd3_strength = -5.519539215470;
    qf4_strength = 11.635406805193;
    qd4_strength = -6.936225524796;

    injsept_kxl_strength = 0.0;
    injsept_kyl_strength = 0.0;
    injsept_ksxl_strength = 0.0;
    injsept_ksyl_strength = 0.0;
else
    error('Invalid TB optics mode');
end
