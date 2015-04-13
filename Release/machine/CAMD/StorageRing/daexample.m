function daexample

global THERING

ati = atindex(THERING);

% Random gradient errors in all quadrupoles
Qindex = sort([ati.QF ati.QD ati.QFA]);
for i = Qindex
    THERING{i}.PolynomB(2) =  THERING{i}.PolynomB(2)*(1+0.01*randn);
    THERING{i}.K = THERING{i}.PolynomB(2);
end

RollSigma = 0.001; % [mrad]
RandomRoll = 0.001*randn(size(Qindex));
settilt(Qindex, RandomRoll);

% misalign sextupoles
Sindex = sort([ati.SF ati.SD]);
XMA = 0.001*randn(size(Sindex));
YMA = 0.001*randn(size(Sindex));
setshift(Sindex, XMA, YMA);
for i = Sindex
    THERING{i}.PolynomB(3) =  0*THERING{i}.PolynomB(3)*(1+0.01*randn);
end


R = [0.004:0.004:0.2;zeros(3,50);0.03*ones(1,50);zeros(1,50)];
T1 = ringpass(THERING,R,1000);
figure
plot(T1(1,:),T1(2,:),'.')