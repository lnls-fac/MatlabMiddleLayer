function [si_ring2, polyA, polyB] = turn_off_sext(si_ring)

fam = sirius_si_family_data(si_ring);
SN = fam.SN.ATIndex;

polyA = getcellstruct(si_ring, 'PolynomA', fam.SN.ATIndex);
polyB = getcellstruct(si_ring, 'PolynomB', fam.SN.ATIndex);

si_ring2 = si_ring;
si_ring2 = setcellstruct(si_ring2, 'PolynomA', SN, repmat({zeros(1, length(polyA{1}))}, length(SN), 1));
si_ring2 = setcellstruct(si_ring2, 'PolynomB', SN, repmat({zeros(1, length(polyB{1}))}, length(SN), 1));
end

