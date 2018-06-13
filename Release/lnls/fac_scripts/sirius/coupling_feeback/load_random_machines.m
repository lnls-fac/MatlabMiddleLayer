function rand_mach = load_random_machines(fname_random_machines)
    fprintf(['-- loading random machines [', datestr(now), ']\n']);
    % loads random machines
    data = load(fname_random_machines);
    rand_mach = data.machine;
    % calcs coupling parameters
    for i=1:length(rand_mach)
        [rand_mach{i}, ~, ~, ~, ~, ~, ~] = setradiation('On', rand_mach{i});
        rand_mach{i} = setcavity('On', rand_mach{i});
    end