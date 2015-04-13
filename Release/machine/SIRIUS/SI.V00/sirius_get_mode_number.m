function mode = sirius_get_mode_number(mode_label)

if strcmpi(mode_label, {'A'})
    mode = 1;
elseif strcmpi(mode_label, {'B'})
    mode = 2;
end