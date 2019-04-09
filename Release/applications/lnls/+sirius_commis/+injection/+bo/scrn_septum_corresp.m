function [dthetax, dthetay] = scrn_septum_corresp(machine, dxf, dyf, scrn)
    s = findspos(machine, 1:length(machine));

    qf = findcells(machine, 'FamName', 'QF');
    qf_struct = machine(qf(1));
    qf_struct = qf_struct{1};
    
    K_QF = qf_struct.PolynomB;
    K_QF = K_QF(2);
    L_QF = qf_struct.Length; % It corresponds to half quadrupole length

    KL_QF =  2 * K_QF * L_QF;

    mqf = findcells(machine, 'FamName', 'mQF');

    d1 = s(mqf(1));
    d2 = s(scrn) - d1;

    % Drift from the end inj sept to the center of QF, then apply QF, and one
    % more drift from the center of QF to the first screen (relation
    % between x_scrn and x'_septum

    factor_x = d1 + d2 - d1 * d2 / KL_QF;
    factor_y = d1 + d2 + d1 * d2 / KL_QF;

    dthetax = dxf / factor_x;
    dthetay = dyf / factor_y;
    
end