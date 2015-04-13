function the_ring = lnls_set_ids(old_the_ring, state)

the_ring = old_the_ring;
idx = findcells(the_ring, 'XGrid');
len = getcellstruct(the_ring,'Length',idx);

idx_thin = idx(len==0);
idx_thick = setdiff(idx,idx_thin);

if strcmpi(state, 'off')
    the_ring = setcellstruct(the_ring, 'PassMethod', idx_thin, 'IdentityPass');
    the_ring = setcellstruct(the_ring, 'PassMethod', idx_thick,'DriftPass');
else
    the_ring = setcellstruct(the_ring, 'PassMethod', idx_thin, 'LNLSThinEPUPass');
    the_ring = setcellstruct(the_ring, 'PassMethod', idx_thick,'LNLSThickEPUPass');
end