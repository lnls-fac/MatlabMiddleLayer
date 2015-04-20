function [fcdata, expout, timestamp] = fcexpcorrident(marker, amplitude, bw, period, selected_corr)

Ts = 320e-6;
ncorr = 42;

if nargin < 1 || isempty(marker)
    marker = uint32(2);
end

if nargin < 2 || isempty(amplitude)
    amplitude = 0.03;
end

if nargin < 3 || isempty(bw)
    bw = 750;
end

if nargin < 4 || isempty(period)
    period = 62;
end

if nargin < 5 || isempty(selected_corr)
    selected_corr = 1:ncorr;
end

profiles = zeros(length(selected_corr), ncorr);

for i=1:length(selected_corr)
    corr_steps = uvxcorrsteps;
    profiles(i, selected_corr(i)) = corr_steps(selected_corr(i));
end

expinfo.excitation = 'prbs';
expinfo.amplitude = amplitude;
expinfo.band = [0 2*Ts*bw];

expinfo.duration = 100;
expinfo.pauselength = 10;
expinfo.mode = 'corr_sum';
expinfo.profiles = profiles;
expinfo.period = period;

expinfo.marker = uint32(marker);

[fcdata, expout, timestamp] = fcexp(expinfo);
