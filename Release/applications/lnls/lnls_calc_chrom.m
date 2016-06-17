function chrom = lnls_calc_chrom(ring, natural)

d = 1e-8;

if exist('natural','var') && natural > 0
    ind = findcells(ring,'PolynomB');
    ring = setcellstruct(ring,'PolynomB',ind,0,1,3);
end

M44 = findm44(ring, -d);
mux1 = acos((M44(1,1)+M44(2,2))/2);
muy1 = acos((M44(3,3)+M44(4,4))/2);

M44 = findm44(ring, d);
mux2 = acos((M44(1,1)+M44(2,2))/2);
muy2 = acos((M44(3,3)+M44(4,4))/2);

chromx = (mux2 - mux1)/(4*pi*d);
chromy = (muy2 - muy1)/(4*pi*d);

chrom = [chromx, chromy];
