function [x, unit] = good_unit(x, base_unit)

prefixes = {'y', 'z', 'a', 'f', 'p', 'n', 'µ', 'm', '', 'k', 'M', 'G', 'T', 'P', 'E', 'Z', 'Y'};

unit_counter = 9;

if (abs(x) < 1) && (abs(x) >= 1e-24)
    while (abs(x) < 1)
        x = x*1e3;
        unit_counter = unit_counter-1;
    end
elseif (abs(x) >= 1e3) && (abs(x) < 1e24)
    while (abs(x) >= 1e3)
        x = x*1e-3;
        unit_counter = unit_counter+1;
    end
end

if x == 0
    unit = '';
else
    unit = [prefixes{unit_counter} base_unit];
end