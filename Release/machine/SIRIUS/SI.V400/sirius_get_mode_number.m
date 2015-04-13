function mode = sirius_get_mode_number(mode_label)

if strcmpi(mode_label, {'AC10'})
    mode = 1;
elseif strcmpi(mode_label, {'AC20'})
    mode = 2;
end