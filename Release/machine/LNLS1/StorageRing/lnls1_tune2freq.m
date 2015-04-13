function Freqs = lnls1_tune2freq(Tune, RFreq)
%LNLS1_TUNE2FREQ - Converts tunes values to betatron frequencies
%
%História
%
%2010-09-13: código fonte com comentários iniciais.

AD = getad;
rev_freq_harm = AD.LNLS1Params.rev_freq_harm;
reference_rfreq = AD.LNLS1Params.reference_rfreq;
harmonic_number = getharmonicnumber;


reference_revolution_freq = reference_rfreq / harmonic_number;
reference_harmonic_rfreq  = rev_freq_harm * reference_revolution_freq;

revolution_freq = RFreq / harmonic_number;
harmonic_rfreq  = rev_freq_harm * revolution_freq;

Freqs = Tune * revolution_freq + harmonic_rfreq - reference_harmonic_rfreq;
