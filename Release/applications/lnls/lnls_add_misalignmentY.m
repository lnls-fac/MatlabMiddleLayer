function ring = lnls_add_misalignmentY(errors, indices, ring)
%function ring = lnls_add_misalignmentY(errors, indices, ring)

% if indices is an 2D-array, transform it into a cellarray of vectors;
if isnumeric(indices)
    indices = mat2cell(indices, ones(1, size(indices,1)));
end

for i=1:length(indices)
    new_error = [0 0 -errors(i) 0 0 0];
    indcs = indices{i};
    for idx=indcs
        if (isfield(ring{idx},'T1') == 1)  % checa se o campo T1 existe
            ring{idx}.T1 = ring{idx}.T1 + new_error;
            ring{idx}.T2 = ring{idx}.T2 - new_error;
        end
    end
end

