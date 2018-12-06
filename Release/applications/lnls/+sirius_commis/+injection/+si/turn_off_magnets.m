function si_ring2 = turn_off_magnets(si_ring)

fam = sirius_si_family_data(si_ring);
si_ring2 = si_ring;

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
end

