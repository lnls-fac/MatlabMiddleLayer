function [fcdata, expout, timestamp] = fcexpinterlock(marker, amplitude, movement, relspeed)

Ts = 320e-6;
nbpm_readings = 50;
amp09h = [17 18];
amp09v = [42 43];

if nargin < 1 || isempty(marker)
    marker = uint32(5);
end

if nargin < 2 || isempty(amplitude)
    amplitude = 0.1;
end

if nargin < 3 || isempty(movement)
    movement = 'angh';
end

if nargin < 4 || isempty(relspeed)
    relspeed = 1;
end

if relspeed < 0.01
    relspeed = 0.01;
elseif relspeed > 1
    relspeed = 1;
end

profiles = zeros(1, nbpm_readings);
if strcmpi(movement, 'angh')
    profiles(amp09h) = [-1 1];
elseif strcmpi(movement, 'angv')
    profiles(amp09v) = [-1 1];
elseif strcmpi(movement, 'posh')
    profiles(amp09h) = [1 1];
elseif strcmpi(movement, 'posv')
    profiles(amp09v) = [1 1];
end

expinfo.excitation = 'ramp';
expinfo.amplitude = amplitude;

expinfo.duration = 10/relspeed;
expinfo.pauselength = 10;
expinfo.mode = 'orb_sum';
expinfo.profiles = profiles;

expinfo.marker = uint32(marker);

[fcdata, expout, timestamp] = fcexp(expinfo);