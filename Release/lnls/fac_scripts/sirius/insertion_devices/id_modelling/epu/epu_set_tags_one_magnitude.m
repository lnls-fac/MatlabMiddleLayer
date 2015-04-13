function epu = epu_set_tags_one_magnitude(epu0)

epu = epu0;

% independent types
BLOCKS = [[0 0 1];[0 0 -1];[0 1 0];[0 -1 0]]';
% associated tags
TAGS = [0 1 2 3];


for i=1:length(epu.csd)
    idx = get_block_type(epu.csd(i).mag, BLOCKS);
    epu.csd(i).tag = TAGS(idx);
end
for i=1:length(epu.cse)
    idx = get_block_type(epu.cse(i).mag, BLOCKS);
    epu.cse(i).tag = TAGS(idx);
end
for i=1:length(epu.cie)
    idx = get_block_type(epu.cie(i).mag, BLOCKS);
    epu.cie(i).tag = TAGS(idx);
end
for i=1:length(epu.cid)
    idx = get_block_type(epu.cid(i).mag, BLOCKS);
    epu.cid(i).tag = TAGS(idx);
end

function idx = get_block_type(mag, BLOCKS)

dmag = BLOCKS - repmat(mag, 1, size(BLOCKS,2));
vnorm = sum(dmag.^2);
[~, idx] = min(vnorm);


    