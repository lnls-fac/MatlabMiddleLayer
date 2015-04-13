function a = mcf(RING, varargin)
%MCF momentum compaction factor
% MCF(RING) calculates momentum compaction factor of RING

if isempty(varargin)
    order = 3; 
else
    order = varargin{1};
end

RING = setcavity('off', RING);
RING = setradiation('off', RING);

RingLength = findspos(RING,length(RING)+1);

dp = linspace(-1e-3,1e-3,11);
dl = zeros(size(dp));
for i=1:length(dp)
    fp = findorbit4(RING,dp(i));
    X0 = [fp;dp(i);0];
    T = ringpass(RING,X0);
    dl(i) = T(6)/RingLength;
end
a = fliplr(polyfit(dp,dl,order)); a = a(2:end);
if isempty(varargin)
    a = a(1);
end;

