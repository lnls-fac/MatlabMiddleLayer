function dd = acoplamento(data, sx0, sy0, k0, beta, pp)

global THERING;

[TD, tune] = twissring(THERING, 0, 1:length(THERING));
BETA = cat(1,TD.beta);
rad15g = findcells(THERING, 'FamName', 'RAD15G');
beta_dfx = mean(BETA(rad15g, :));

% calcula otica no ponto do corretor skew
cskew_idx = 9;
dev = elem2dev('A2QS05', cskew_idx);
setpv('A2QS05', 1, dev);
[Tilt, Eta, EpsX, EpsY, EmittanceRatio, ENV, DP, DL, BeamSize] = calccoupling;
len = getleff('A2QS05');
atidx = getfamilydata('A2QS05', 'AT', 'ATIndex');
beta_cskew = BETA(atidx(cskew_idx,2),:);
eta_rad15g = mean(Eta(1,rad15g));
ksl = getpv('A2QS05', 'physics') * len(cskew_idx);

setpv('A2QS05', 0, dev); 


%sigmae = 1*0.076/100;
%sx0    = sqrt((30/1e6)^2 + (eta_rad15g * sigmae)^2);
%sy0    = 30/1e6;
%k0     = 0.01;
%k1 = sqrt(beta_cskew(1) * beta_cskew(2)) * ksl / (2*pi);
%beta   = beta_dfx;
delta  = 0.02966;
%delta  = 0.029;

sx1 = data.dimh_mean/1000;
sy1 = data.dimv_mean/1000;
t = data.angf_mean;

for i=1:length(sx1)
    r = [cos(t(i)) sin(t(i)); -sin(t(i)) cos(t(i))];
    sigx2 = sx1(i)^2 - 0*sx0^2;
    sigy2 = sy1(i)^2 - 0*sy0^2;
    m = inv(r) * [sigx2 0; 0 sigy2] * r - [(sx0)^2 0; 0 (sy0)^2];
    %m = r \ [sigx2 0; 0 sigy2] * r;
    sx(i) = sqrt(m(1,1));
    sy(i) = sqrt(m(2,2));
    an(i) = atan(2*m(1,2)/(m(1,1) - m(2,2)))/2;
end

%tt = sign(t) .* abs(acos(tx ./ sqrt(tx.^2 + ty.^2)));


%sx = sqrt(cos(tt).^2 .* sx1.^2 + sin(tt).^2 .* sy1.^2);
%sy = sqrt(sin(tt).^2 .* sx1.^2 + cos(tt).^2 .* sy1.^2);


%sx = sx1 .* cos(t);
%sy = sy1 ./ cos(t);

current = data.a2qs05;

%ey = ((sy.^2 - sy0^2) / beta(2))/1e-9;
%ex = ((sx.^2 - sx0^2) / beta(1))/1e-9;

ey = sy.^2 / beta(2) / 1e-9;
ex = sx.^2 / beta(1) / 1e-9;

r = ey ./ ex;
%u_meas = 2*r .* (1 + r / 2);
u_meas = 2*r ./ (1 - r);

[u_min idx] = min(u_meas);
i_min = current(idx);

cosf = -sign(i_min) * sqrt(1-u_min/(k0/delta)^2);
k1   = - k0 * cosf / i_min;
fprintf('%f -> %f\n', sqrt(beta_cskew(1) * beta_cskew(2)) * ksl / (2*pi), k1);

k2 = k0^2 + 2*k0*k1*cosf.*current + k1^2*current.^2;
u_teo = k2/delta^2;

dd = sqrt(sum((u_teo - u_meas).^2)/length(u_teo));
fprintf('%20.16f\n', dd);

if pp == 1
    figure;
    hold all;
    plot(current, u_meas, 'r');
    plot(current, u_teo, 'b');
end

