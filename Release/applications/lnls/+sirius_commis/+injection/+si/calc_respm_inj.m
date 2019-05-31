function matrix = calc_respm_inj(machine, param, param_errors, n_part)
    fam = sirius_si_family_data(machine);
    dt = 100e-6;
    nbpm = length(fam.BPM.ATIndex);
    matrix = zeros(2*nbpm, 3);

    xl0 = param.offset_xl_syst;
    yl0 = param.offset_yl_syst;
    kckr0 = param.kckr_syst;
    
    param.offset_xl_syst = xl0 + dt/2;
    rtxp = sirius_commis.injection.si.multiple_pulse(machine, param, param_errors, n_part, 1, length(machine), 'on', 'plot', 'diag');
    param.offset_xl_syst = xl0 - dt/2;
    rtxn = sirius_commis.injection.si.multiple_pulse(machine, param, param_errors, n_part, 1, length(machine), 'on', 'plot', 'diag');
    param.offset_xl_syst = xl0;
    
    param.offset_yl_syst = yl0 + dt/2;
    rtyp = sirius_commis.injection.si.multiple_pulse(machine, param, param_errors, n_part, 1, length(machine), 'on', 'plot', 'diag');
    param.offset_yl_syst = yl0 - dt/2;
    rtyn = sirius_commis.injection.si.multiple_pulse(machine, param, param_errors, n_part, 1, length(machine), 'on', 'plot', 'diag');
    param.offset_yl_syst = yl0;
    
    param.kckr_syst = kckr0 + dt/2;
    rtkckrp = sirius_commis.injection.si.multiple_pulse(machine, param, param_errors, n_part, 1, length(machine), 'on', 'plot', 'diag');
    param.kckr_syst = kckr0 - dt/2;
    rtkckrn = sirius_commis.injection.si.multiple_pulse(machine, param, param_errors, n_part, 1, length(machine), 'on', 'plot', 'diag');
    param.kckr_syst = kckr0;
    
    matrix(1:nbpm, 1) = (rtxp.r_bpm(1, :) - rtxn.r_bpm(1, :)) ./ dt;
    matrix(1:nbpm, 2) = (rtyp.r_bpm(1, :) - rtyn.r_bpm(1, :)) ./ dt;
    matrix(1:nbpm, 3) = (rtkckrp.r_bpm(1, :) - - rtkckrn.r_bpm(1, :)) ./ dt;
    matrix(nbpm+1:end, 1) = (rtxp.r_bpm(2, :) - rtxn.r_bpm(2, :)) ./ dt;
    matrix(nbpm+1:end, 2) = (rtyp.r_bpm(2, :) - rtyn.r_bpm(2, :)) ./ dt;
    matrix(nbpm+1:end, 3) = (rtkckrp.r_bpm(2, :) - - rtkckrn.r_bpm(2, :)) ./ dt;
end

