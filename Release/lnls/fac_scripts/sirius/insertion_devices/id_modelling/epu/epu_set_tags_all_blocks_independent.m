function epu = epu_set_tags_all_blocks_independent(epu0)

epu = epu0;

idx = 0;
for i=1:length(epu.csd)
    epu.csd(i).tag = idx; idx = idx + 1;
end
for i=1:length(epu.cse)
    epu.cse(i).tag = idx; idx = idx + 1;
end
for i=1:length(epu.cie)
    epu.cie(i).tag = idx; idx = idx + 1;
end
for i=1:length(epu.cid)
    epu.cid(i).tag = idx; idx = idx + 1;
end



    