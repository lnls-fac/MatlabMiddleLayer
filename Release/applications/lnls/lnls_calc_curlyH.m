function curH = lnls_calc_curlyH(ring,twi)

de = 0;
if ~exist('twi','var'), twi = calctwiss(ring,de);end

gammax = (twi.alphax.^ 2 + 1)./twi.betax;
curH = twi.betax.*twi.etaxl.^2 + ...
       2*twi.alphax.*twi.etax.*twi.etaxl + ...
       gammax.* twi.etax.^2; 
   
ind = findcells(ring,'BendingAngle');
angle = getcellstruct(ring,'BendingAngle',ind);
len = getcellstruct(ring,'Length',ind);
rho = len./angle;
G = zeros(size(twi.pos));

G(ind) = 1./rho;
indM = findcells(ring,'PassMethod','IdentityPass');
G(indM(1:end-1))=G(indM(1:end-1)+1);
