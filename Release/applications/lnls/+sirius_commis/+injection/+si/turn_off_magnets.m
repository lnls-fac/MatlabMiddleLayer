function si_ring_out = turn_off_magnets(si_ring)

    fam = sirius_si_family_data(si_ring);
    si_ring_out = setcellstruct(si_ring, 'PolynomB', fam.SN.ATIndex, 0, 1, 3);
    si_ring_out = setcellstruct(si_ring_out, 'PolynomB', fam.QN.ATIndex, 0, 1, 2);
end
