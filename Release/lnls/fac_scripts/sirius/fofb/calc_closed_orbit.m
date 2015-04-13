function orb = calc_closed_orbit(the_ring, flags)

if any(strcmpi(flags, 'cod6d'))
    orb = findorbit6(the_ring, 1:length(the_ring));
else
    orb = findorbit4(the_ring, 0, 1:length(the_ring));
end
