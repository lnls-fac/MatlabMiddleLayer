function expmap = fcexpprocextend(expmap, npts_before, npts_after)

filenpts = 100e3;

for i=1:length(expmap)
    expmap(i).idx = (expmap(i).idx(1)-npts_before):(expmap(i).idx(end)+npts_after);
end

for i=1:length(expmap)
    add_files = ceil(expmap(i).idx(end)/filenpts) - length(expmap(i).filesidx);
    expmap(i).filesidx = [expmap(i).filesidx (expmap(i).filesidx(1)+(1:add_files))];
end

for i=1:length(expmap)
    if expmap(i).idx(1) < 1
        add_files = ceil((1 - expmap(i).idx(1))/filenpts) - length(expmap(i).filesidx);
        expmap(i).idx = expmap(i).idx + filenpts*add_files;
        expmap(i).filesidx = [expmap(i).filesidx(1)-(1:add_files) expmap(i).filesidx];
    end
end