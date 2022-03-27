function [M, nomSLs, nomChrom] = lnls_calc_chromcorr_params(acc)

if acc == 'SI'
    sirius
    global THERING
    famdata = sirius_si_family_data(THERING);
    sext_fams = {'SFA1', 'SFA2', 'SDA1', 'SDA2', 'SDA3', ...
                 'SFB1', 'SFB2', 'SDB1', 'SDB2', 'SDB3', ...
                 'SFP1', 'SFP2', 'SDP1', 'SDP2', 'SDP3'};
elseif acc == 'BO'
    sirius('BO')
    global THERING
    famdata = sirius_bo_family_data(THERING);
    sext_fams = {'SF', 'SD'};
end

deltaSL = 0.01; % entire magnet
         
M = zeros(2, length(sext_fams));
for i=1:length(sext_fams)
    
    fam = sext_fams{i};
    famd = famdata.(fam);
    nsplits = size(famd.ATIndex, 2);
    ind = famd.ATIndex(:);
    L = THERING{ind(1)}.Length;
    deltaSLSplit = deltaSL/nsplits;
    
    S = getcellstruct(THERING, 'PolynomB', ind, 1, 3);
    
    T2 = setcellstruct(THERING, 'PolynomB', ind, S + (deltaSLSplit/2)/L, 1, 3);
    twissP = calctwiss(T2, 'ddp', 1e-6);
    T2 = setcellstruct(THERING, 'PolynomB', ind, S - (deltaSLSplit/2)/L, 1, 3);
    twissN = calctwiss(T2, 'ddp', 1e-6);
    M(:,i) = [twissP.chromx - twissN.chromx, twissP.chromy - twissN.chromy] / deltaSL;

end

cells = struct;
Ss = struct;
Ls = struct;
nrsegs = struct;
nomSLs = struct;
for i=1:length(sext_fams)
    fam = sext_fams{i};
    famd = famdata.(fam);
    ids = findcells(THERING, 'FamName', fam);
    nrs = famd.nr_segs;
    S = getcellstruct(THERING, 'PolynomB', ids, 1, 3);
    L = 0;
    for j=1:nrs
        L = L + THERING{ids(j)}.Length;
    end
    cells.(fam) = ids;
    Ss.(fam) = S;
    Ls.(fam) = L;
    nrsegs.(fam) = nrs;
    nomSLs.(fam) = S(1)*L(1);
end

% Test Matrix (1)
disp('Teste 1: deltas de 0.0001 nos SLs')
dSL = 0.0001*ones(1, length(sext_fams));
dChrom1 = M * dSL';

T2 = THERING;
for i=1:length(sext_fams)
    fam = sext_fams{i};
    T2 = setcellstruct(...
        T2, 'PolynomB', cells.(fam), ...
        Ss.(fam) + (dSL(i)/nrsegs.(fam))/(Ls.(fam)/nrsegs.(fam)), 1, 3);
end

twiss0 = calctwiss(THERING, 'ddp', 1e-6);
twiss2 = calctwiss(T2, 'ddp', 1e-6);
% figure(1); plot(twiss2.cox - twiss0.cox)
% figure(2); plot(twiss2.coy - twiss0.coy)

erro_chromx = (twiss2.chromx - twiss0.chromx) - dChrom1(1)
erro_chromy = (twiss2.chromy - twiss0.chromy) - dChrom1(2)

% Test Matrix (2)
disp('Teste 2: deltas de (0.5, 0.5) de chromaticidade')
dChrom1 = [0.5; 0.5];
[U,S,V] = svd(M,'econ');
pseudoinvM = V*(S\U');
dSL = pseudoinvM * dChrom1;

T2 = THERING;
for i=1:length(sext_fams)
    fam = sext_fams{i};
    T2 = setcellstruct(...
        T2, 'PolynomB', cells.(fam), ...
        Ss.(fam) + (dSL(i)/nrsegs.(fam))/(Ls.(fam)/nrsegs.(fam)), 1, 3);
end

twiss0 = calctwiss(THERING, 'ddp', 1e-6);
twiss2 = calctwiss(T2, 'ddp', 1e-6);
% figure(1); plot(twiss2.cox - twiss0.cox)
% figure(2); plot(twiss2.coy - twiss0.coy)

erro_chromx = 100*((twiss2.chromx - twiss0.chromx) - dChrom1(1))/dChrom1(1)
erro_chromy = 100*((twiss2.chromy - twiss0.chromy) - dChrom1(2))/dChrom1(2)

% Nominal chromaticity
ats = atsummary;
nomChrom = ats.chromaticity;




