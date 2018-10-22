function n_v = phase_space_caract(machine, n_turns, n_points)

machine = setcavity('on', machine);
machine = setradiation('on', machine);

energy_max = 2e-2;
phase_max = 2*0.6;

energy_pass = -linspace(-energy_max, energy_max, n_points);
phase_pass = linspace(-phase_max, phase_max, n_points);
n_v = zeros(n_points, n_points);
% color = zeros(n_points, n_points);

for k = 1:n_points
    phase = phase_pass(k);
    for j = 1:n_points
        energy = energy_pass(j);
        n_v(j, k) = comp(machine, energy, phase, n_turns, k);
    end
end

ind1 = n_v < n_turns / 4;
ind2 = n_turns / 4 < n_v &  n_v < n_turns / 2;
ind3 = n_turns / 2 < n_v & n_v < 3 * n_turns / 4;
ind4 = n_v > 3 * n_turns / 4;


end

function n_voltas = comp(machine, energy, phase, n_turns, j)
    VChamb = cell2mat(getcellstruct(machine, 'VChamber', 1:length(machine)))';
    VChamb = VChamb([1, 2], 1);

    r_i = [0; 0; 0; 0; energy; phase];
    if j == 1
        r_f = ringpass(machine, r_i, n_turns);
    else
        r_f = ringpass(machine, r_i, n_turns, 'reuse');
    end
    r_f_xy = squeeze(r_f([1,3], :));

    ind = abs(r_f_xy) > VChamb;
    ind = repmat(ind, 3, 1);
    r_f(ind) = NaN;

    n_voltas = sum(~isnan(r_f(1,:)));
end
