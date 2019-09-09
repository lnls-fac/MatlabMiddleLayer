function machine = vchamber_injection(machine)
    %Values of vacuum chamber radius in horizontal plane at the end of
    %injection septum and the initial point of injection kicker
    xcv_sep = 41.86e-3;
    xcv_kckr = 30.14e-3;

    sept = findcells(machine, 'FamName','InjSept');
    injkckr = findcells(machine, 'FamName','InjKckr');
    s = findspos(machine, 1:length(machine));
    xcv = (xcv_kckr - xcv_sep) / (s(injkckr) - s(1)) * s(1:injkckr)  + xcv_sep;

    % Vacuum chamber inside the inj. kicker set as the same as initial point
    xcv = [xcv, xcv(end)];
    machine = setcellstruct(machine, 'VChamber', 1:injkckr+1, xcv, 1, 1);
end