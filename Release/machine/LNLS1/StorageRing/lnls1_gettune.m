function [Tune, tout, DataTime, ErrorFlag] = lnls1_gettune(Family, Field, DeviceList, t)
%LNLS1_GETTUNE - Returns storage ring tunes values.
%
%História
%
%2010-09-13: código fonte com comentários iniciais.


tout = [];
DataTime = [];
ErrorFlag = 0;


AD = getad;
rev_freq_harm = AD.LNLS1Params.rev_freq_harm;
reference_rfreq = AD.LNLS1Params.reference_rfreq;
harmonic_number = getharmonicnumber;

reference_revolution_freq = reference_rfreq / harmonic_number;
reference_harmonic_rfreq  = rev_freq_harm * reference_revolution_freq;

ChannelNames = family2channel('TUNE', DeviceList);
rfreq           = 1000*getpv('RF', 'Setpoint');
Freqs           = getpv(ChannelNames);

revolution_freq = rfreq / harmonic_number;
harmonic_rfreq  = rev_freq_harm * revolution_freq;

beta_freqs = (Freqs + reference_harmonic_rfreq - harmonic_rfreq);
Tune = beta_freqs / revolution_freq; 