function tags = epu_get_tags_list(epu)

csd_tags = [epu.csd(:).tag];
cse_tags = [epu.cse(:).tag];
cie_tags = [epu.cie(:).tag];
cid_tags = [epu.cid(:).tag];

tags = unique([csd_tags cse_tags cie_tags cid_tags]);