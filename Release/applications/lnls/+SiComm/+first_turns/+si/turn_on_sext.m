function si_ring2 = turn_on_sext(si_ring, polyA, polyB)

fam = sirius_si_family_data(si_ring);
si_ring2 = si_ring;

SN = fam.SN.ATIndex;

si_ring2 = setcellstruct(si_ring2, 'PolynomA', SN, polyA);
si_ring2 = setcellstruct(si_ring2, 'PolynomB', SN, polyB);
end

