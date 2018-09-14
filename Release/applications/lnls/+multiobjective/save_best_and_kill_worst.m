function varargout = save_best_and_kill_worst(res, Ncut)
    n = size(res, 2);
    ndom = zeros(n, 1);
    for i=1:n
        dres = res - res(:,i);
        dominate = all(dres < 0);
        ndom(i) = sum(dominate);

        % Even tough the algorithm below only tests half the elements
        % it is still much slower than the one above.
        % I'm still in the search for an algorithm faster than O(N^2)...
%         ind = i+1:n;
%         dres = res(:, ind) - res(:,i);
%         dominate = all(dres<0);
%         ndom(i) = ndom(i) + sum(dominate);
%         dominate = ind(all(dres>0));
%         ndom(dominate) = ndom(dominate) + 1;
    end
    id_keep = find(ndom <= Ncut);
   
    varargout{1} = id_keep;
    if nargout == 2
        varargout{2} = ndom;
    end
end