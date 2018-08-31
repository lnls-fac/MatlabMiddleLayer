function r_final = sirius_booster_injection(machine, param, n_part)
%
% -->> ring: ring model
% -->> param: struct with the following parameters:
%      - twiss functions in the point of injection: betax0, betay0, alphax0,
%        alphay0, etax0, etay0, etaxl0, etayl0
%      - kckr: angle of injection kicker
%      - offset_x and offset_xl are the nominal values to correct injection
%      - beam parameters: emitx, emity, energy spread and bunch length
%      - cutoff: value to cutoff of distributions to generate initial bunch
%      - sigma_bpm: precision of BPM measurements at 1nC single-pass (2mm)
%      - sigma_scrn: precision of screen
% -->> n_part: number of particles
%
% NOTE: once the function sirius_bo_lattice_errors_analysis() is updated,
% this function must be checked too.

    % Setting the nominal kick of the injection kicker
    sept = findcells(machine, 'FamName', 'InjSept');
    machine = circshift(machine, [0, - (sept - 1)]);

    injkckr = findcells(machine, 'FamName', 'InjKckr');
    machine = lnls_set_kickangle(machine, param.kckr, injkckr, 'x');
    
    offsets = [param.offset_x; param.offset_xl; 0; 0; 0; 0];
    offsets = repmat(offsets, 1, n_part);
       
    twi.betax = param.betax0; twi.alphax = param.alphax0;
    twi.betay = param.betay0; twi.alphay = param.alphay0;
    twi.etax = param.etax0;   twi.etaxl = param.etaxl0;
    twi.etay = param.etay0;   twi.etayl = param.etayl0;
    
    r_init = lnls_generate_bunch(param.emitx, param.emity, param.sigmae, param.sigmaz, twi, n_part, param.cutoff);
    r_init = r_init + offsets;

    r_final = linepass(machine, r_init, 1:length(machine));
    r_final = reshape(r_final, 6, n_part, length(machine));
end
