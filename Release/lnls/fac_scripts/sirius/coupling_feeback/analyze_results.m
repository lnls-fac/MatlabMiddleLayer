function analyze_results

close all;

%fname = 'SI.V18.01-nominal3p0-ids1p00.mat';
%fname = 'SI.V18.01-nominal3p0-ids0p55.mat';
%fname = 'SI.V18.01-nominal3p0-ids0p15.mat';
fname = 'SI.V18.01-nominal3p0-ids0p08.mat';
%fname = 'SI.V18.01-nominal3p0-ids0p01.mat';

data =load(['study/',fname]); r = data.r;


tilt0 = [];
tilt1 = [];
for i=1:length(r.machines.machine)
    tilt0 = [tilt0; r.machines.coupling{i}.tilt];
    tilt1 = [tilt1; r.machines.coupling_ids{i}.tilt];
end

data = tilt1-tilt0;
c = 180/pi;

idx = r.indices.mia;
dtilt_rms = sqrt(sum(data(:,idx).^2,2)/length(idx));
d = dtilt_rms; 
fprintf('mia: %.2f +/- %.2f\n', c*mean(d), c*std(d));

idx = r.indices.mib;
dtilt_rms = sqrt(sum(data(:,idx).^2,2)/length(idx));
d = dtilt_rms; 
fprintf('mib: %.2f +/- %.2f\n', c*mean(d), c*std(d));

idx = r.indices.mip;
dtilt_rms = sqrt(sum(data(:,idx).^2,2)/length(idx));
d = dtilt_rms; 
fprintf('mip: %.2f +/- %.2f\n', c*mean(d), c*std(d));

idx = r.indices.mic;
dtilt_rms = sqrt(sum(data(:,idx).^2,2)/length(idx));
d = dtilt_rms; 
fprintf('mc : %.2f +/- %.2f\n', c*mean(d), c*std(d));