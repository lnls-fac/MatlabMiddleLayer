function new_ring = lnls_add_misalignmentY(errors, indices, old_ring)
%function new_ring = lnls_add_misalignmentY(errors, indices, old_ring)

new_ring = old_ring;

for i=1:size(indices,1)
    new_error = [0 0 -errors(i) 0 0 0];
    for j=1:size(indices,2)
        idx = indices(i,j);
        if (isfield(new_ring{idx},'T1') == 1); % checa se o campo T1 existe
            new_ring{idx}.T1 = new_ring{idx}.T1 + new_error;
            new_ring{idx}.T2 = new_ring{idx}.T2 - new_error;
        end
    end
end

