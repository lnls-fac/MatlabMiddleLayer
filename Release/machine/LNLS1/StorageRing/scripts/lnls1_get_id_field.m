function field = lnls1_get_id_field(id)

global THERING;

idx = findcells(THERING, 'FamName', id);
field = unique(getcellstruct(THERING, 'Field', idx));