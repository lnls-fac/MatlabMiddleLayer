function si_ring2 = turn_off_sext(si_ring)

fam = sirius_si_family_data(si_ring);
si_ring2 = si_ring;

SN = fam.SN.ATIndex;
pbSFA0 = getcellstruct(si_ring2, 'PolynomB', fam.SFA0.ATIndex);
paSFA0 = getcellstruct(si_ring2, 'PolynomA', fam.SFA0.ATIndex);
si_ring2 = setcellstruct(si_ring2, 'PolynomB', SN, repmat({zeros(1, length(pbSFA0{1}))}, length(SN), 1));
si_ring2 = setcellstruct(si_ring2, 'PolynomA', SN, repmat({zeros(1, length(paSFA0{1}))}, length(SN), 1));
end

