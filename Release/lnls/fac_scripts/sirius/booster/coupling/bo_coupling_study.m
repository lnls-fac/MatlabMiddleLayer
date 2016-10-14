% Lattice version with Skew Quadrupole: BO.E02.04
% 2016/10/14

[booster, tit] = sirius_bo_lattice;

ind_qs = findcells(booster, 'FamName', 'qs');

n = 20;
kqs = linspace(0,0.3,n);
coup = zeros(1,n);

for j=1:n
   PolyB = [0 0 0];
   PolyA = [0 kqs(j) 0];

   for i=ind_qs
      booster{i}.PolynomB = PolyB;
      booster{i}.PolynomA = PolyA;
   end

   [Tilt, Eta, EpsX, EpsY, Ratio, ENV, DP, DL, sigmas] = calccoupling(booster);
   fprintf('%i) Kqs = %g, Ratio = %g \n', j, kqs(j), Ratio);
   coup(j) = Ratio;
end

figure;
plot(kqs,coup,'b-o');
title('Coupling in Booster for 1 QS')
xlabel('Kqs (1/m2)')
ylabel('Emittance ratio')
