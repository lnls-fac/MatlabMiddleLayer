function flag = lnls_compare_lattices(thering1, thering2)

flag = false;

f1 = whos('thering1');
f2 = whos('thering2');

% size
if any(f1.size ~= f2.size), return; end;

for i=1:length(thering1)
    fnames = fieldnames(thering1{i});
    for j=1:length(fnames)
        v1 = thering1{i}.(fnames{j});
        if ~isfield(thering2{i}, fnames{j}), return; end;
        v2 = thering2{i}.(fnames{j});
        %if ischar(v1) && ~strcmp(v1, v2), return; end;
        if ischar(v1), continue; end;
        if any(v1 ~= v2), return; end;
    end
end

flag = true;
