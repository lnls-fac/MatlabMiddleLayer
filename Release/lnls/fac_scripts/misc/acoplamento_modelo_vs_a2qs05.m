function r = acoplamento_modelo_vs_a2qs05

global THERING;

switch2sim;
switch2hardware;

dfx_pos = findcells(THERING, 'FamName', 'RAD15G');
dfx_pos = dfx_pos(1);

forca = linspace(-10,10,21);
for i=1:length(forca)
    setpv('A2QS05', forca(i));
    [Tilt, Eta, EpsX, EpsY, Ratio, ENV, DP, DL, sigmas] = calccoupling;
    sigmax(i) = 1e6 * sigmas(1,dfx_pos);
    sigmay(i) = 1e6 * sigmas(2,dfx_pos);
    angle(i)  = (180 / pi ) * Tilt(dfx_pos);
    ratio(i) = Ratio;
end

r.forca  = forca;
r.sigmax = sigmax;
r.sigmay = sigmay;
r.angle  = angle;
r.ratio = ratio;