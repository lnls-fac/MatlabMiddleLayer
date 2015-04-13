function r = lnls1_params
%LNLS1_PARAMS - Global parameters for the accelerators
%
%História
%
%2011-04-30: adicionados parâmetros rev_freq_harm e reference_rfreq usados para interpretar dados do TuneLogger
%2010-09-13: código fonte com comentários iniciais.

r.response_after_corrector_change = 3;
r.response_after_rfrequency_change = 2;
r.response_after_rfrequency_generator_setup_change = 0.5;
r.response_after_orbit_correction_is_turned_on = 2;
r.control_system_update_period = 0.0; 
r.bpm_nr_points_average = 1;
r.rev_freq_harm = 36;
r.reference_rfreq = 476065.68;