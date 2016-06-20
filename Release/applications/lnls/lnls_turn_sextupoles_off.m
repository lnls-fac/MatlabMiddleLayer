function the_ring = lnls_turn_sextupoles_off(the_ring0)

the_ring = the_ring0;

% MML-independent code
bends = findcells(the_ring, 'BendingAngle');
quads = setdiff(findcells(the_ring, 'PolynomB'), bends);
sexts = quads(getcellstruct(the_ring, 'PolynomB', quads, 1, 3) ~= 0);
the_ring = setcellstruct(the_ring, 'PolynomB', sexts, 0, 1, 3);

% MML-dependent code
% sextupoles = findmemberof('sext');
% for i=1:length(sextupoles)
%     idx = findcells(the_ring, 'FamName', sextupoles{i});
%     the_ring = setcellstruct(the_ring, 'PolynomB', idx, 0, 1, 3);
% end
