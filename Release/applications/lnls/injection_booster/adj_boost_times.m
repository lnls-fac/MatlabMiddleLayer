function adj_boost_times(bo_ring, n_part, n_pulse, n_times)

[param, machine] = bo_injection_adjustment(bo_ring, n_part, n_pulse, 'yes');

for j = 1:n_times-1
    [param, machine] = bo_injection_adjustment(machine, n_part, n_pulse, 'no', param);
end

