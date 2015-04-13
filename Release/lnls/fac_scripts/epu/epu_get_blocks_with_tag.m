function blocks = epu_get_blocks_with_tag(epu, tag)

 blocks.csd = find([epu.csd(:).tag] == tag); 
 blocks.cse = find([epu.cse(:).tag] == tag); 
 blocks.cie = find([epu.cie(:).tag] == tag); 
 blocks.cid = find([epu.cid(:).tag] == tag); 
 

