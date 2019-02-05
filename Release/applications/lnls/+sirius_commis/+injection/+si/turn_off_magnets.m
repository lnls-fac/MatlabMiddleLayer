function [si_ring2] = turn_off_magnets(si_ring)

fam = sirius_si_family_data(si_ring);
si_ring2 = si_ring;

% paSN = getcellstruct(si_ring2, 'PolynomA', fam.SN.ATIndex);
%paQN = getcellstruct(si_ring2, 'PolynomA', fam.QN.ATIndex);
%pbSN = getcellstruct(si_ring2, 'PolynomB', fam.SN.ATIndex);
%pbQN = getcellstruct(si_ring2, 'PolynomB', fam.QN.ATIndex);

% paSN = si_ring{fam.SN.ATIndex}.PolynomA;
% paSN = si_ring{fam.SN.ATIndex}.PolynomB;

for i = 1:length(fam.SN.ATIndex)
    paSN = si_ring{fam.SN.ATIndex(i)}.PolynomA;
    pbSN = si_ring{fam.SN.ATIndex(i)}.PolynomB;
    si_ring2 = setcellstruct(si_ring2, 'PolynomA', fam.SN.ATIndex(i), {0*paSN});
    si_ring2 = setcellstruct(si_ring2, 'PolynomB', fam.SN.ATIndex(i), {0*pbSN});
end
for ii = 1:length(fam.QN.ATIndex)
    paQN = si_ring{fam.QN.ATIndex(ii)}.PolynomA;
    pbQN = si_ring{fam.QN.ATIndex(ii)}.PolynomB;
    si_ring2 = setcellstruct(si_ring2, 'PolynomA', fam.QN.ATIndex(ii), {0*paQN});
    si_ring2 = setcellstruct(si_ring2, 'PolynomB', fam.QN.ATIndex(ii), {0*pbQN});
end

%{
SFA0 = fam.SFA0.ATIndex(1);
QFA = fam.QFA.ATIndex(1);
SDA0 = fam.SDA0.ATIndex(1);
QDA = fam.QDA.ATIndex(1);
SDA1 = fam.SDA1.ATIndex(1);
Q1 = fam.Q1.ATIndex(1);

pbSFA0 = getcellstruct(si_ring2, 'PolynomB', SFA0);
pbQFA =  getcellstruct(si_ring2, 'PolynomB', QFA);
pbSDA0 = getcellstruct(si_ring2, 'PolynomB', SDA0);
pbQDA =  getcellstruct(si_ring2, 'PolynomB', QDA);
pbSDA1 = getcellstruct(si_ring2, 'PolynomB', SDA1);
pbQ1 =   getcellstruct(si_ring2, 'PolynomB', Q1);

paSFA0 = getcellstruct(si_ring2, 'PolynomA', SFA0);
paQFA =  getcellstruct(si_ring2, 'PolynomA', QFA);
paSDA0 = getcellstruct(si_ring2, 'PolynomA', SDA0);
paQDA =  getcellstruct(si_ring2, 'PolynomA', QDA);
paSDA1 = getcellstruct(si_ring2, 'PolynomA', SDA1);
paQ1 =   getcellstruct(si_ring2, 'PolynomA', Q1);

si_ring2 = setcellstruct(si_ring2, 'PolynomB', SFA0, {zeros(1, length(pbSFA0{1}))});
si_ring2 = setcellstruct(si_ring2, 'PolynomB', QFA, {zeros(1, length(pbQFA{1}))});
si_ring2 = setcellstruct(si_ring2, 'PolynomB', SDA0, {zeros(1, length(pbSDA0{1}))});
si_ring2 = setcellstruct(si_ring2, 'PolynomB', QDA, {zeros(1, length(pbQDA{1}))});
si_ring2 = setcellstruct(si_ring2, 'PolynomB', SDA1, {zeros(1, length(pbSDA1{1}))});
si_ring2 = setcellstruct(si_ring2, 'PolynomB', Q1, {zeros(1, length(pbQ1{1}))});

si_ring2 = setcellstruct(si_ring2, 'PolynomA', SFA0, {zeros(1, length(paSFA0{1}))});
si_ring2 = setcellstruct(si_ring2, 'PolynomA', QFA, {zeros(1, length(paQFA{1}))});
si_ring2 = setcellstruct(si_ring2, 'PolynomA', SDA0, {zeros(1, length(paSDA0{1}))});
si_ring2 = setcellstruct(si_ring2, 'PolynomA', QDA, {zeros(1, length(paQDA{1}))});
si_ring2 = setcellstruct(si_ring2, 'PolynomA', SDA1, {zeros(1, length(paSDA1{1}))});
si_ring2 = setcellstruct(si_ring2, 'PolynomA', Q1, {zeros(1, length(paQ1{1}))});
%}

% si_twiss = calctwiss(si_ring2);
%{
param.twiss.betax0 = si_twiss.betax(1);
param.twiss.betay0 = si_twiss.betay(1);
param.twiss.alphax0 = si_twiss.alphax(1);
param.twiss.alphay0 = si_twiss.alphay(1);
param.twiss.etax0 = si_twiss.etax(1);
param.twiss.etay0 = si_twiss.etay(1);
param.twiss.etaxl0 = si_twiss.etaxl(1);
param.twiss.etayl0 = si_twiss.etayl(1);

for j = 1:100
bpms = fam.BPM.ATIndex;
delta = j*1e-8;
r_init_n = [0; 0; 0; 0; -delta; 0];
r_final_n = linepass(si_ring2, r_init_n, 1:length(si_ring2) + 1);
r_init_p = [0; 0; 0; 0; +delta; 0];
r_final_p = linepass(si_ring2, r_init_p, 1:length(si_ring2) + 1);
x_n = r_final_n(1, bpms);
x_p = r_final_p(1, bpms);
etax_bpms(j, :) = (x_p - x_n) ./ 2 ./ delta;
end
etax = squeeze(mean(etax_bpms, 1));
%}
end

