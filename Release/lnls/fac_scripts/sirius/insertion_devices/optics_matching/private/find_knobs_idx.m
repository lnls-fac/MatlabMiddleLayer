function knobs_idx = find_knobs_idx(the_ring,knobs)

% builds quads knobs indices cellarray of vectors
famnames = unique(getcellstruct(the_ring, 'FamName',1:length(the_ring)));
knobs_idx = {};
j = 1;
for i=1:length(knobs)
    indcs = strfind(famnames,knobs{i});
    for ii = 1:length(indcs)
        if ~isempty(indcs{ii})
            knobs_idx{j} = findcells(the_ring, 'FamName', famnames{ii});
            j = j+1;
        end
    end
end