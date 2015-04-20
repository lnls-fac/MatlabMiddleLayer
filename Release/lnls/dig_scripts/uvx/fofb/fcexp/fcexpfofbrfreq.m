function [fcdata, expout, timestamp] = fcexpfofbrfreq(marker, amplitude, bw, M)

Ts = 320e-6;

nbpm_readings = 50;
ncorr = 42;

if nargin < 1 || isempty(marker)
    marker = uint32(4);
end

if nargin < 2 || isempty(amplitude)
    amplitude = 0.03;
end

if nargin < 3 || isempty(bw)
    bw = 500;
end

if nargin < 4 || isempty(M)
    M = randn(ncorr, nbpm_readings);
	[u,s,v] = svd(M);
    s(s ~= 0) = 1;
    M = u*s*v';
end

expinfo.excitation = 'multisine';
expinfo.amplitude = amplitude;
expinfo.band = [0 2*Ts*bw];
expinfo.sinedata = [100, 10, 1];

expinfo.duration = 100;
expinfo.pauselength = 10;
expinfo.mode = 'orb_sum';
expinfo.profiles = M;
expinfo.period = 10000;

expinfo.marker = marker;

[fcdata, expout, timestamp] = fcexp(expinfo);