function idx = get_elements_indices_from_selection(the_ring, family_name, selection)

idxall   = findcells(the_ring, 'FamName', family_name);  
symmetry = length(idxall) / length(selection);
idx      = idxall(repmat(selection, 1, symmetry) == 1);