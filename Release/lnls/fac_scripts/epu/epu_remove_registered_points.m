function epu = epu_remove_registered_points(epu0)

if isfield(epu0, 'registered_points')
    epu = rmfield(epu0, 'registered_points');
else
    epu = epu0;
end