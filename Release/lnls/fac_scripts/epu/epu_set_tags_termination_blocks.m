function epu = epu_set_tags_termination_blocks(epu0, range)

epu = epu0;

pos = [epu.csd(:).pos epu.cse(:).pos epu.cie(:).pos epu.cid(:).pos];
minmax = [min(pos(2,:)) max(pos(2,:))];

idx = 1;

for i=1:length(epu.csd)
    if any(abs(epu.csd(i).pos(2) - minmax) <= range)
        epu.csd(i).tag = idx; idx = idx + 1;
    else
        epu.csd(i).tag = 0;
    end
end

for i=1:length(epu.cse)
    if any(abs(epu.cse(i).pos(2) - minmax) <= range)
        epu.cse(i).tag = idx; idx = idx + 1;
    else
        epu.cse(i).tag = 0;
    end
end

for i=1:length(epu.cie)
    if any(abs(epu.csd(i).pos(2) - minmax) <= range)
        epu.cie(i).tag = idx; idx = idx + 1;
    else
        epu.cie(i).tag = 0;
    end
end

for i=1:length(epu.cid)
    if any(abs(epu.cid(i).pos(2) - minmax) <= range)
        epu.cid(i).tag = idx; idx = idx + 1;
    else
        epu.cid(i).tag = 0;
    end
end

