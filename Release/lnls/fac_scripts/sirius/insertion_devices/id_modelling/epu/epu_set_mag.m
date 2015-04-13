function epu = epu_set_mag(epu0, tags, mags)

epu = epu0;

for i=1:length(tags)
    blocks = epu_get_blocks_with_tag(epu, tags(i));
    for j=1:length(blocks.csd)
        epu.csd(blocks.csd(j)).mag = mags(:,i);
    end;
    for j=1:length(blocks.cse)
        epu.cse(blocks.cse(j)).mag = mags(:,i);
    end;
    for j=1:length(blocks.cie)
        epu.cie(blocks.cie(j)).mag = mags(:,i);
    end;
    for j=1:length(blocks.cid)
        epu.cid(blocks.cid(j)).mag = mags(:,i);
    end;
end