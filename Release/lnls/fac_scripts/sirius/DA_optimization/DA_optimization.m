clear all
global THERING

% THERING =  repmat(the_ring,1,1);
% THERING =  define_mba5_rede_betx_mais_alto_tr;
% THERING =  define_mba5_rede_emit_026;
THERING =  define_rede15;
% THERING =  define_max_iv;
max_length = 0.15;
THERING =  lnls_refine_lattice(THERING, max_length);

sexts = findcells(THERING,'FamName','SEXT');
% THERING = setcellstruct(THERING,'PolynomB',sexts,0,3);
sext_strength = getcellstruct(THERING,'PolynomB',sexts,3);
sext_length = getcellstruct(THERING,'Length',sexts);
SL = sext_strength.*sext_length;

quads = findcells(THERING,'FamName','QUAD');
quad_strength = getcellstruct(THERING,'PolynomB',quads,2);
quad_length = getcellstruct(THERING,'Length',quads);
QL = quad_strength.*quad_length;

bends = findcells(THERING,'FamName','BEND');
bend_strength = getcellstruct(THERING,'PolynomB',bends,2);
bend_length = getcellstruct(THERING,'Length',bends);
BL = bend_strength.*bend_length;

[TD, tunes, chromaticity] = twissring(THERING, 0, 1:length(THERING)+1, 'chrom', 1e-8);
twiss.beta        = cat(1,TD.beta);
twiss.mu          = cat(1,TD.mu);
twiss.alpha       = cat(1,TD.alpha);
twiss.Dispersion  = [TD.Dispersion]';
twiss.SPos        = cat(1,TD.SPos);

plota =1;
[geom schrom] = sextupolar_1storder_drive_terms(twiss.beta,twiss.Dispersion,twiss.mu,twiss.SPos,plota);
qchrom = quadrupolar_1storder_drive_terms(twiss.beta,twiss.Dispersion,twiss.mu,twiss.SPos);



res.chrom = SL'*schrom(sexts,:) + [QL' BL']*qchrom([quads bends],:);
res.geom  = SL'*geom(sexts,:);

vec_residuo = [res.chrom(:,1:2)/pi 2*real(res.chrom(:,3:5)) 2*real(res.geom(:,1:5))];
% vec_residuo = abs([res.chrom(:,1:2)/pi res.chrom(:,3:5) res.geom(:,1:5)]);

fprintf('\tChromx\t  Chromy\th10002\t  h20001\th00101\t h21000\t   h30000\t  h10110\th10200\t  h10020\n');
disp(vec_residuo);

% sexts = setdiff(1:length(THERING),[quads bends]);

mat = 2*real([geom(sexts,1:5) schrom(sexts,1:5)]');
% mat = abs([geom(:,:) schrom(:,:)]');
[U S V] = svd(mat,'econ');
k = rank(mat);
Si = diag(1./diag(S));
Si(k-2:end,:)=0;


QF = QL'*2*real(qchrom(quads,1:5));
QF = [zeros(5,1); QF'];
SF = U'*QF;
SF = V*Si*SF;


THERING = setcellstruct(THERING,'PolynomB',sexts,SF,3);
res.chrom = SF'*schrom(sexts,:) + [QL' BL']*qchrom([quads bends],:);
res.geom  = SF'*geom(sexts,:);

vec_residuo = [res.chrom(:,1:2)/pi 2*real(res.chrom(:,3:5)) 2*real(res.geom(:,1:5))];
% vec_residuo = abs([res.chrom(:,1:2)/pi res.chrom(:,3:5) res.geom(:,1:5)]);
disp(vec_residuo);

