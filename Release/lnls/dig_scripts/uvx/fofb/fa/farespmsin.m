function [M, corr_steps] = farespmsin(fadata, freqs, npts_discard, shift_ref)

if (nargin < 4) || isempty(shift_ref)
    shift_ref = 7;
end

if (nargin < 3) || isempty(npts_discard) || (npts_discard < shift_ref)
    npts_discard = shift_ref;
end

bpmdata = detrend(double(fadata.bpm_readings(npts_discard+1:end,:)),0);
corrdata = detrend(double(fadata.corr_setpoints(npts_discard+1-shift_ref:end-shift_ref,:)),0);
Ts = fadata.period*1e-6;
npts = size(bpmdata,1);

window = flattopwin(npts);
Abpm = fourierseries(bpmdata, 1/Ts, window);
Acorr = fourierseries(corrdata, 1/Ts, window);
PG = sum(window)/npts;

idx = round(npts*Ts*freqs+1);
M  = (Acorr(idx,:)\Abpm(idx,:))';
corr_steps = diag(Acorr(idx,:))/PG;

% Identification of the sign of the matrix elements;
sig = sign(corrdata' * bpmdata)';
M = M.*sig;

%% We also tested this way of getting the signal of the matrix elements, but the results were worse
% angulo = bsxfun(@minus, angbpm(idx,:)', diag(angcorr(idx,:))');
% ind = abs(angulo) < pi/2 | (2*pi-angulo) < pi/2;
% sinal2 = zeros(size(angulo));
% sinal2(ind) = 1;
% sinal2(~ind) = -1;

