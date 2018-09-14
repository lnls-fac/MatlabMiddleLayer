function indcs = find_results(re, res_max, form, res_min)
    if ~exist('res_min', 'var')
        res_min = res_max*0;
    end
    if ~exist('form', 'var')
        form = 'struct';
    end

    fn = fieldnames(re);
    for i=1:length(fn)
        ge = fn{i};
        res = re.(ge).res;
        isols = find(all(res - res_max(:)<=0 & res - res_min(:)>=0 ));
        for j=isols
            el = sprintf('I%03d', j);
            indcs.([ge, el]) = re.(ge).G(:, j);
        end
    end

    if strncmpi(form, 'mat', 3)
        indcs = struct2array(indcs);
    end
end