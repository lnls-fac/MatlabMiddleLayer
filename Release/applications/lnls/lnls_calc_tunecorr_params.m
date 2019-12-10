function [M, nomKLs] = lnls_calc_tunecorr_params(acc)

if acc == 'SI'
    sirius
    global THERING
    famdata = sirius_si_family_data(THERING);
    quad_fams = {'QFA', 'QFB', 'QFP', 'QDA', 'QDB1', 'QDB2', 'QDP1', 'QDP2'};
elseif acc == 'BO'
    sirius('BO')
    global THERING
    famdata = sirius_bo_family_data(THERING);
    quad_fams = {'QF', 'QD'};
end

deltaKL = 0.01; % entire magnet

M = zeros(2, length(quad_fams));
for i=1:length(quad_fams)
    
    fam = quad_fams{i};
    famd = famdata.(fam);
    nsplits = size(famd.ATIndex, 2);
    ind = famd.ATIndex(:);
    L = THERING{ind(1)}.Length;
    deltaKLSplit = deltaKL/nsplits;
    
    K = getcellstruct(THERING, 'PolynomB', ind, 1, 2);
    
    T2 = setcellstruct(THERING, 'PolynomB', ind, K + (deltaKLSplit/2)/L, 1, 2);
    twissP = calctwiss(T2);
    T2 = setcellstruct(THERING, 'PolynomB', ind, K - (deltaKLSplit/2)/L, 1, 2);
    twissN = calctwiss(T2);
    M(:,i) = [twissP.mux(end) - twissN.mux(end), twissP.muy(end) - twissN.muy(end)] / 2 / pi / deltaKL;

end

cells = struct;
Ks = struct;
Ls = struct;
nrsegs = struct;
nomKLs = struct;
for i=1:length(quad_fams)
    fam = quad_fams{i};
    famd = famdata.(fam);
    ids = findcells(THERING, 'FamName', fam);
    nrs = famd.nr_segs;
    K = getcellstruct(THERING, 'PolynomB', ids, 1, 2);
    L = 0;
    for j=1:nrs
        L = L + THERING{ids(j)}.Length;
    end
    cells.(fam) = ids;
    Ks.(fam) = K;
    Ls.(fam) = L;
    nrsegs.(fam) = nrs;
    nomKLs.(fam) = K(1)*L(1);
end

% Test Matrix (1)
disp('Teste 1: deltas de 0.0001 nos KLs')
dKL = 0.0001*ones(1, length(quad_fams));
dTune1 = M * dKL';

T2 = THERING;
for i=1:length(quad_fams)
    fam = quad_fams{i};
    T2 = setcellstruct(...
        T2, 'PolynomB', cells.(fam), ...
        Ks.(fam) + (dKL(i)/nrsegs.(fam))/(Ls.(fam)/nrsegs.(fam)), 1, 2);
end

twiss0 = calctwiss(THERING);
twiss2 = calctwiss(T2);
erro_deltTuneX = dTune1(1) - (twiss2.mux(end) - twiss0.mux(end))/2/pi
erro_deltTuneX = dTune1(2) - (twiss2.muy(end) - twiss0.muy(end))/2/pi

% Test Matrix (2)
disp('Teste 2: deltas de (0.01; -0.01) de sintonia')
dTune1 = [0.01; -0.01];
[U,S,V] = svd(M,'econ');
pseudoinvM = V*(S\U');
dKL = pseudoinvM * dTune1;

T2 = THERING;
for i=1:length(quad_fams)
    fam = quad_fams{i};
    T2 = setcellstruct(...
        T2, 'PolynomB', cells.(fam), ...
        Ks.(fam) + (dKL(i)/nrsegs.(fam))/(Ls.(fam)/nrsegs.(fam)), 1, 2);
end

twiss0 = calctwiss(THERING);
twiss2 = calctwiss(T2);
erro_deltTuneX = dTune1(1) - (twiss2.mux(end) - twiss0.mux(end))/2/pi
erro_deltTuneX = dTune1(2) - (twiss2.muy(end) - twiss0.muy(end))/2/pi







