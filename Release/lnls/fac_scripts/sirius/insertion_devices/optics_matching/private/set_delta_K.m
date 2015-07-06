function the_ring = set_delta_K(the_ring, knobs, dK)

for i=1:length(dK)
    K = getcellstruct(the_ring, 'PolynomB', knobs{i}, 1, 2);
    newK = K + dK(i);
    the_ring = setcellstruct(the_ring, 'PolynomB', knobs{i}, newK, 1, 2);
end