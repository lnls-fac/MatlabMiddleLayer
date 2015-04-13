function [orb, orb_envelope, f] = fofb_orb_by_freq(data, f)

bpm_position = data.orb;

bpm_position_fft = fft(bpm_position);
bpm_position_fft_mag = 2/size(bpm_position,1)*abs(bpm_position_fft);
bpm_position_fft_phase = angle(bpm_position_fft);

bpm_position_fft_mag(1,:) = bpm_position_fft_mag(1,:)/2;

% Sample time (ms)
Ts = data.time(2)-data.time(1);

% Sampling rate (Hz)
Fs = 1000/Ts;

f_fft = linspace(0,Fs,size(bpm_position_fft,1));

mag_by_freq = interp1(f_fft, bpm_position_fft_mag, f,'nearest');

phase_by_freq = interp1(f_fft, bpm_position_fft_phase, f,'nearest');
phase_by_freq = phase_by_freq - repmat(phase_by_freq(:,1), 1, size(phase_by_freq,2));

orb = mag_by_freq.*cos(phase_by_freq);
orb_envelope = mag_by_freq;