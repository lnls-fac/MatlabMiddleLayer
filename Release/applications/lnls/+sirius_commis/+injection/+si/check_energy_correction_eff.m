function delta = check_energy_correction_eff(machine, n_mach, n_part, n_pulse, param0, param0_error, turn_off)

delta = zeros(10, 1);
sirius_commis.common.initializations();
for i = 1:10
    param0_error.xl_error_syst = 0;
    param0_error.kckr_error_syst = 0;
    param0_error.delta_error_syst = i * 0.5e-2;
    param0.delta_syst = i*0.5e-2;
    param_adjusted = sirius_commis.injection.si.multiple_adj_loop(machine, n_mach, n_part, n_pulse, param0, param0_error, turn_off);
    delta(i) = param_adjusted.delta_ave * 100;
end

end
