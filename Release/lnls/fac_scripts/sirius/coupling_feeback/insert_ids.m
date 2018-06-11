function rand_mach = insert_ids(rand_mach, data)
    fprintf(['-- inserting IDs into random machines [', datestr(now), ']\n']);

    for i=1:length(rand_mach)
        for j=1:length(data.idx)
           rand_mach{i} = insert_one_id(rand_mach{i}, data.idx(j,:), data.polynom_a(i, j));
        end
    end
