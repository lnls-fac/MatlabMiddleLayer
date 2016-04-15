function B = lnls_calc_Bfield(ring,size)
   
ind = findcells(ring,'BendingAngle');
angle = getcellstruct(ring,'BendingAngle',ind);
len = getcellstruct(ring,'Length',ind);
rho = len./angle;
B = zeros(size);

B(ind) = 3/0.29979*1./rho;
indM = findcells(ring,'PassMethod','IdentityPass');
B(indM(1:end-1))=B(indM(1:end-1)+1);
