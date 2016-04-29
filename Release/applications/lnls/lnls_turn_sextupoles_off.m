function the_ring = lnls_turn_sextupoles_off(the_ring0)

the_ring = the_ring0;
sextupoles = findmemberof('sext');
for i=1:length(sextupoles)
    idx = findcells(the_ring, 'FamName', sextupoles{i});
    the_ring = setcellstruct(the_ring, 'PolynomB', idx, 0, 1, 3);
end
