function indcs = remove_repeated(indcs)
    [~, I] = unique(indcs', 'rows', 'stable');
    indcs = indcs(:,I);
end