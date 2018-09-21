function varargout = save_best_and_kill_worst(res, Ncut, cube)
    if ~exist('cube', 'var')
        cube = inf*ones(size(res, 1), 1);
    end

    n = size(res, 2);
    I = 1:n;
    if ~all(isinf(cube))
        I = I(all(res <= cube, 1));
    end
    ndom = n*ones(n, 1);
    ndom(I) = 0;
    for i=I
        dres = res(:, I) - res(:, i);
        dominate = all(dres < 0);
        ndom(i) = sum(dominate);

        % Even tough the algorithm below only tests half the elements
        % it is still much slower than the one above due to MATLAB's
        % vectorializations.
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