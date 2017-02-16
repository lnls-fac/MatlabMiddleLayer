function field = lnls1_get_id_field(id, thering)
if nargin < 2
    global THERING;
    thering = THERING;
end
try
    idx = findcells(thering, 'FamName', id);
    field = unique(getcellstruct(thering, 'Field', idx));
catch
    field = 0;
end