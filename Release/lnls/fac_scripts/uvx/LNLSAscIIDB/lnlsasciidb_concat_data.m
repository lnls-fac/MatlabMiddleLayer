function r = lnlsasciidb_concat_data(data1, data2)

% downcasts data value type if possible
if isfloat(data1), data1_have_NaN = any(isnan(data1)); else data1_have_NaN = false; end;
if isfloat(data2), data2_have_NaN = any(isnan(data1)); else data2_have_NaN = false; end;
if ~data1_have_NaN && ~data2_have_NaN
    value_type = lnlsasciidb_get_cast_type(data1, data2);
    data1 = cast(data1, value_type);
    data2 = cast(data2, value_type);
elseif data1_have_NaN || data2_have_NaN
    data1 = cast(data1, 'double');
    data2 = cast(data2, 'double');
end
r = [data1(:); data2(:)];