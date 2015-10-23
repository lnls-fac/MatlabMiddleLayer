function [fcdata, expout, timestamp] = fcexprespm(marker, amplitude)

if nargin < 1 || isempty(marker)
    marker = uint32(1);
end

if nargin < 2 || isempty(amplitude)
    amplitude = 0.1;
end

acv = [19, 22, 23, 26, 27, 30, 31, 34, 35, 38, 39, 42];
alv = [20 21 24 25 28 29 32 33 36 37 40 41];
corr_steps = ones(1,42);
corr_steps(acv) = 1.00281;
corr_steps(alv) = 2.83146;

expinfo.excitation = 'step';
expinfo.amplitude = amplitude;

expinfo.duration = 100;
expinfo.pauselength = 10;
expinfo.mode = 'corr_sum';
expinfo.profiles = diag(corr_steps);

expinfo.marker = uint32(marker);

[fcdata, expout, timestamp] = fcexp(expinfo);