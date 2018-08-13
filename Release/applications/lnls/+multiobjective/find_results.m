function indcs = find_results(re, res_max, form, res_min)
if ~exist('res_min', 'var')
    res_min = res_max*0;
end
if ~exist('form', 'var')
    form = 'struct';
end

fn = fieldnames(re);
fn = fn(1:end-1);
for i=1:length(fn)
    ge = fn{i};
    res = re.(ge).res;
    isols = find(all(res - res_max(:)<=0 & res - res_min(:)>=0 ));
    for j=isols
        el = sprintf('I%03d', j);
        indcs.([ge, el]) = re.indcs.(ge).(el);
    end
end

if strncmpi(form, 'mat', 3)
    fs = fieldnames(indcs);
    G = zeros(size(indcs.(fs{1}), 1), length(fs));
    for i=1:length(fs)
        G(:,i) = indcs.(fs{i});
    end
    indcs = G;
end