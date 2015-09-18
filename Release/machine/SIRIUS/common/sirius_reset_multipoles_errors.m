function new_ring = sirius_reset_multipoles_errors(old_ring)

new_ring = old_ring;
indices = findcells(new_ring, 'PolynomB');

for i=1:length(indices)
    
    if isfield(new_ring{indices(i)}, 'NPB')
        new_ring{indices(i)}.PolynomB = new_ring{indices(i)}.NPB;
    end
    
    if isfield(new_ring{indices(i)}, 'NPA')
        new_ring{indices(i)}.PolynomA = new_ring{indices(i)}.NPA;
    end
end

end