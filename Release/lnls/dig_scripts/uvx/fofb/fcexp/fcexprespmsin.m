function [fcdata, expout, timestamp] = fcexprespmsin(marker, amplitude)

Ts = 320e-6;

if nargin < 1 || isempty(marker)
    marker = uint32(6);
end

if nargin < 2 || isempty(amplitude)
    amplitude = 0.06;
end

corr_steps = uvxcorrsteps;

expinfo.excitation = 'sine2d';
expinfo.amplitude = amplitude;

expinfo.duration = 1000;
expinfo.pauselength = 10;
expinfo.mode = 'corr_sum';
expinfo.profiles = corr_steps;
expinfo.freqs = 2*Ts*(1./([42:-0.1:(42-4.1)]*Ts)); 

expinfo.marker = uint32(marker);

[fcdata, expout, timestamp] = fcexp(expinfo);
