the_ring = calc_mapa_dipolo;

for i=7:9
    fprintf('d = drift(\''%s\'', %21.15E), \''DriftPass\'');\n', the_ring{i}.FamName, the_ring{i}.Length);
end
for i=10:23
    fprintf('b = rbend_sirius(\''B\'', %21.15E, %+21.15E, 0, 0, 0, 0, 0, [0,0,0,0,0,0,0], [%+21.15E, %+21.15E, %+21.15E, %+21.15E, %+21.15E, %+21.15E, %+21.15E], bend_pass_method);\n', the_ring{i}.Length,the_ring{i}.BendingAngle,the_ring{i}.PolynomB(1),the_ring{i}.PolynomB(2),the_ring{i}.PolynomB(3),the_ring{i}.PolynomB(4),the_ring{i}.PolynomB(5),the_ring{i}.PolynomB(6),the_ring{i}.PolynomB(7))
end
for i=24:26
    fprintf('d = drift(\''%s\'', %21.15E), \''DriftPass\'');\n', the_ring{i}.FamName, the_ring{i}.Length);
end