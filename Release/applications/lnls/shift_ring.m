function new_ring = shift_ring(ring, first_elem)
    
    elem1 = findcells(ring, 'FamName', first_elem);
    if isempty(elem1)
       error('Ring does not contains input element')
    end
    new_ring = circshift(ring, [0, -(elem1 - 1)]);

end

