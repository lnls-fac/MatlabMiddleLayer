function ring = lnls_add_excitation_Kdip(errors, indices, ring)

% if indices is an 2D-array, transform it into a cellarray of vectors;
if isnumeric(indices)
    indices = mat2cell(indices, ones(1, size(indices,1)));
end

for i=1:length(indices)
    indcs = indices{i};
    for idx=indcs
        if isfield(ring{idx}, 'BendingAngle')
            ring{idx}.PolynomB(2) = ring{idx}.PolynomB(2) * (1 + errors(i)); % nao funciona com 'BendLinearPass'
        else
            error('lnls_add_excitation_Kdip: not a dipole!');
        end
    end
end
