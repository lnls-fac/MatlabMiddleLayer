function ring = lnls_correct_chrom(ring, chrom, fams, max_iter, tolerancia)

if ~exist('chrom', 'var'), chrom = [0,0]; end
if ~exist('max_iter', 'var'), max_iter = 10; end
if ~exist('tolerancia', 'var'), tolerancia = 1e-3; end
if ~exist('fams', 'var')
    fams = {'SDA1', 'SDA2', 'SDA3', 'SFA1', 'SFA2', ...
        'SDB1', 'SDB2', 'SDB3', 'SFB1', 'SFB2', ...
        'SDP1', 'SDP2', 'SDP3', 'SFP1', 'SFP2', ...
        };
end

indS = cell(length(fams));
dchrom = zeros(length(fams),2);
% sumDeltaS = zeros(length(fams),1);

for j=1:length(fams)
    indS{j} = findcells(ring,'FamName',fams{j});
end

for count=1:max_iter
    
    for j=1:length(fams)
        dchrom(j,:) = lnls_calc_dchrom(ring, indS{j});
    end
    
    last_chrom = lnls_calc_chrom(ring);
    
    if(norm(chrom-last_chrom) < tolerancia)
        break
    end

%   Using Lagrange-multipliers method. Lagrange multiplayers are given by
%   the last two elements of DeltaS.

%     A = [eye(length(fams)),dchrom;dchrom',zeros(2)];
%     B = [zeros(length(fams),1);chrom'-last_chrom']; % optimize partial
%     norm
%     %B = [-sumDeltaS;chrom'-last_chrom']; % optimize total norm
%     DeltaS = (A\B);
%     sumDeltaS = sumDeltaS + DeltaS(1:length(fams));

    [U,S,V] = svd(dchrom','econ');
    B = (chrom'-last_chrom');
    
    DeltaS = V*(S\U')*B;

    for j=1:length(fams)
        strS = getcellstruct(ring,'PolynomB',indS{j},1,3) + DeltaS(j);
        ring = setcellstruct(ring,'PolynomB',indS{j},strS,1,3);
    end
end


function dchrom = lnls_calc_dchrom(ring, ind)

d = 1e-4;

S = getcellstruct(ring,'PolynomB',ind,1,3);

ring = setcellstruct(ring,'PolynomB',ind,S-d,1,3);
chrom1 = lnls_calc_chrom(ring);

ring = setcellstruct(ring,'PolynomB',ind,S+d,1,3);
chrom2 = lnls_calc_chrom(ring);

dchrom = (chrom2 - chrom1)/(2*d);

