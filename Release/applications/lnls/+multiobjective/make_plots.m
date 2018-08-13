function make_plots(re, resid_ref)
    if ~exist('resid_ref', 'var')
        resid_ref = struct();
    end
    sz = size(re.G001.res,1);
    if sz == 2
        make_plots_2d(re, resid_ref);
    elseif sz == 3
        make_plots_3d(re, resid_ref);
    else
        error('Not implemented yet.');
    end

end

function make_plots_2d(re, resid_ref)
    fn=fieldnames(re);
    len = length(fn);

    figure('Position', [100, 10, 1500, 1500]);
    ax = subplottight(1, 1, 1);
    set(ax, 'Box', 'on', 'FontSize', 16, ...
        'XGrid', 'on', 'YGrid', 'on', 'NextPlot', 'add');
    ls = [];
    for ii=len-1:-1:1
        r = re.(fn{ii}).res;
        c = [ii/len, sin(pi*ii/len), 1-1/len];
        l = scatter(ax, r(1,:), r(2,:), 50, c, 'filled');
        if ii ==1 || ii==len-1 || ~mod(ii,30)
            l.DisplayName = fn{ii};
            ls = [ls, l];
        end
    end
    fs = fieldnames(resid_ref);
    mks = 'o^vds><';
    for i=1:length(fs)
        m = fs{i};
        mk = mks(mod(i-1, length(mks))+1);
        res = resid_ref.(m);
        l = scatter(ax, res(1,1), res(2,1), 180, [mk,'k'], 'filled');
        l.DisplayName = m;
        ls = [ls, l];
    end
    legend(ls, 'Location', 'best');
    xlabel(ax, 'Horizontal Beta Beating', 'FontSize', 16);
    ylabel(ax, 'Vertical Beta Beating', 'FontSize', 16);
end

function make_plots_3d(re, resid_ref)
    fn=fieldnames(re);
    len = length(fn);

    figure('Position', [100, 10, 1500, 1500]);
    axs(1) = subplottight(2, 2, 1);
    axs(2) = subplottight(2, 2, 2);
    axind = {[1,3], [2,3]};
    axlab = {{'beta beat LE', 'dist'}, {'beta beat HE', 'dist'}};
    rs = [];
    for i=1:length(axs)
        ax = axs(i);
        id1 = axind{i}(1);
        id2 = axind{i}(2);
        xlab = axlab{i}{1};
        ylab = axlab{i}{2};
        set(ax, 'Box', 'on', 'FontSize', 16, ...
            'XGrid', 'on', 'YGrid', 'on', 'NextPlot', 'add');
        ls = [];
        for ii=len-1:-1:1
            r = re.(fn{ii}).res;
            if i==1
                rs = [rs, r];
            end
            c = [ii/len, sin(pi*ii/len), 1-1/len];
            l = scatter(ax, r(id1,:), r(id2,:), 8, c, 'filled');
            if ii ==1 || ii==len-1 || ~mod(ii,30)
                l.DisplayName = fn{ii};
                ls = [ls, l];
            end
        end
        fs = fieldnames(resid_ref);
        mks = 'o^vds><';
        for iii=1:length(fs)
            m = fs{iii};
            mk = mks(mod(iii-1, length(mks))+1);
            res = resid_ref.(m);
            l = scatter(ax, res(id1,1), res(id1,1), 180, [mk,'k'], 'filled');
            l.DisplayName = m;
            ls = [ls, l];
        end
        legend(ls, 'Location', 'best');
        xlabel(ax, xlab, 'FontSize', 16);
        ylabel(ax, ylab, 'FontSize', 16);
    end


    ax = subplottight(2, 2, [3,4]);
    set(ax, 'Box', 'on', 'FontSize', 16, ...
            'XGrid', 'on', 'YGrid', 'on', 'NextPlot', 'add');
    [~,I] = sort(rs(3,:),'descend');
    rs = rs(:,I);
    maxr3 = rs(3,1);
    minr3 = rs(3,end);
    nr3 = (rs(3,:)' - minr3)/(maxr3-minr3);
    divs = [1, 0.8, 0.6, 0.4, 0.2, 0];
    for i=1:length(divs)-1
        ind = find(nr3 <= divs(i) & nr3 > divs(i+1));
        C = repmat([divs(i), 0, 1-divs(i)], length(ind), 1);
        l = scatter(ax, rs(1,ind)', rs(2,ind)', 80, C, 'filled');
        l.DisplayName = sprintf('<%5d', rs(3,ind(1)));
    end
    fs = fieldnames(resid_ref);
    mks = 'o^vds><';
    for iii=1:length(fs)
        m = fs{iii};
        mk = mks(mod(iii-1, length(mks))+1);
        res = resid_ref.(m);
        l = scatter(ax, res(1,1), res(2,1), 180, [mk,'k'], 'filled');
        l.DisplayName = m;
    end
    xlabel(ax, 'beta beat LE', 'FontSize', 16);
    ylabel(ax, 'beta beat HE', 'FontSize', 16);
    legend(ax, 'Location', 'best');
end

function h = subplottight(n,m,i)
    [c,r] = ind2sub([m n], i);
    xi = (c(1)-1)/m;
    yi = 1 - r(1)/n;
    xf = c(end)/m;
    yf = 1 - (r(end)-1)/n;
    lb = 0.05;
    rb = 0.02;
    ub = 0.02;
    bb = 0.05;
    hs = 0.08;
    vs = 0.08;
    if c(1) == 1
        xi = xi + lb;
    else
        xi = xi + hs/2;
    end
    if r(1) == 1
        yf = yf - ub;
    else
        yf = yf - vs/2;
    end
    if c(end) == m
        xf = xf - rb;
    else
        xf = xf - hs/2;
    end
    if r(end) == n
        yi = yi + bb;
    else
        yi = yi + vs/2;
    end
    ax = subplot('Position', [xi, yi, (xf-xi), (yf-yi)]);
    if(nargout > 0)
      h = ax;
    end
end
