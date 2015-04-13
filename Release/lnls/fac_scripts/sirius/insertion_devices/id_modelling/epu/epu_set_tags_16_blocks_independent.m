function epu = epu_set_tags_16_blocks_independent(epu0)

epu = epu0;

% independent types
BLOCKS_CSD = [[0 0 1];[0 0 -1];[0 1 0];[0 -1 0]]';
BLOCKS_CSE = [[0 0 1];[0 0 -1];[0 1 0];[0 -1 0]]';
BLOCKS_CIE = [[0 0 1];[0 0 -1];[0 1 0];[0 -1 0]]';
BLOCKS_CID = [[0 0 1];[0 0 -1];[0 1 0];[0 -1 0]]';
% associated tags
TAGS_CSD = [0 1 2 3];
TAGS_CSE = [4 5 6 7];
TAGS_CIE = [8 9 10 11];
TAGS_CID = [12 13 14 15];


for i=1:length(epu.csd)
    idx = get_block_type(epu.csd(i).mag, BLOCKS_CSD);
    epu.csd(i).tag = TAGS_CSD(idx);
end
for i=1:length(epu.cse)
    idx = get_block_type(epu.cse(i).mag, BLOCKS_CSE);
    epu.cse(i).tag = TAGS_CSE(idx);
end
for i=1:length(epu.cie)
    idx = get_block_type(epu.cie(i).mag, BLOCKS_CIE);
    epu.cie(i).tag = TAGS_CIE(idx);
end
for i=1:length(epu.cid)
    idx = get_block_type(epu.cid(i).mag, BLOCKS_CID);
    epu.cid(i).tag = TAGS_CID(idx);
end

function idx = get_block_type(mag, BLOCKS)

dmag = BLOCKS - repmat(mag, 1, size(BLOCKS,2));
vnorm = sum(dmag.^2);
[~, idx] = min(vnorm);


    