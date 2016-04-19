function ring = lnls_correct_chrom(ring, fams, chrom)

%indS = cell();
dchrom = zeros(length(fams),2);

for j=1:length(fams)
    indS{j} = findcells(ring,'FamName',fams{j});
    dchrom(j,:) = lnls_calc_dchrom(ring, indS{j});
end

% A = [eye(length(fams)),dchrom;dchrom',zeros(2)];
% 
% B = [zeros(length(fams),1);chrom'-lnls_calc_chrom(ring)'];
% 
% DeltaS = (A\B)';

A = dchrom';
[U,S,V] = svd(A,'econ');

B = (chrom'-lnls_calc_chrom(ring)');

DeltaS = V*inv(S)*U'*B;

for j=1:length(fams)
    strS = getcellstruct(ring,'PolynomB',indS{j},1,3) + DeltaS(j);
    ring = setcellstruct(ring,'PolynomB',indS{j},strS,1,3);
end

function dchrom = lnls_calc_dchrom(ring, ind)

d = 1e-4;

S = getcellstruct(ring,'PolynomB',ind,1,3);

ring = setcellstruct(ring,'PolynomB',ind,S-d,1,3);
chrom1 = lnls_calc_chrom(ring);

ring = setcellstruct(ring,'PolynomB',ind,S+d,1,3);
chrom2 = lnls_calc_chrom(ring);

dchrom = (chrom2 - chrom1)/(2*d);

