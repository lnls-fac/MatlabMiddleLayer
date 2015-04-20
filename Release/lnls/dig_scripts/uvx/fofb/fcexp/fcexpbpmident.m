function [fcdata, expout, timestamp] = fcexpbpmident(marker, amplitude, bw, period, profiles)

Ts = 320e-6;
ncorr = 42;

if nargin < 1 || isempty(marker)
    marker = uint32(3);
end

if nargin < 2 || isempty(amplitude)
    amplitude = 0.03;
end

if nargin < 3 || isempty(bw)
    bw = 500;
end

if nargin < 4 || isempty(period)
    period = 93;
end

if nargin < 5 || isempty(selected_corr)
    corr_steps = uvxcorrsteps;
    profiles = [corr_steps(1:18) zeros(1,24); zeros(1,18) corr_steps(19:42)];
end

expinfo.excitation = 'prbs2d';
expinfo.amplitude = amplitude;
expinfo.band = [0 2*Ts*bw];

expinfo.duration = 1000;
expinfo.pauselength = 10;
expinfo.mode = 'corr_sum';
expinfo.profiles = profiles;
expinfo.period = period;

expinfo.marker = uint32(marker);

[fcdata, expout, timestamp] = fcexp(expinfo);
