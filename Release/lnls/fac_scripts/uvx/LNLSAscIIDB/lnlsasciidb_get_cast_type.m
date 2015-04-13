function r = lnlsasciidb_get_cast_type(data, varargin)

def_parms = lnlsasciidb_load_default_parameters;

idx1 = get_value_type_index(data);
if ~isempty(varargin)
    idx2 = get_value_type_index(varargin{1});
    r = def_parms.value_types{min([idx1 idx2])};
else
    r = def_parms.value_types{idx1};
end
   
function r = get_value_type_index(data0)

def_parms = lnlsasciidb_load_default_parameters;
r = class(data0);
for i=1:length(def_parms.value_types)
    data1 = cast(data0, def_parms.value_types{i});
    data2 = cast(data1, class(data0));
    diffe = data0 - data2;
    if all(diffe == 0)
        r = i;
    else
        break;
    end
end