function new_ring = shift_ring(ring, first_elem)
    
    elem1 = findcells(ring, 'FamName', first_elem);
    new_ring = circshift(ring, [0, -(elem1 - 1)]);

end

