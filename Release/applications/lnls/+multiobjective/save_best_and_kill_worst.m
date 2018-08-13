function id_keep = save_best_and_kill_worst(res, Ncut)
    ndom = (size(res,2)+1)*ones(size(res,2));
    for i=1:size(res,2)
        dres = res - res(:,i);
        dominate = all(dres < 0);
        ndom(i) = sum(dominate);
    end
    id_keep = find(ndom <= Ncut);
end