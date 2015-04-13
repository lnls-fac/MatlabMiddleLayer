function find_sextupole_configs

min_fitness      = 100;
random_amplitude = 50;

p = init_sextupole_optimization;
if ~isempty(p.configs)
    min_fitness = p.configs{1}.spread.fitness/4;
end

while true
    
    amplitude = 5;
    p = random_sextupole_config(p);
    if p.spread.fitness == 0, continue; end
    fprintf('trying %f ...\n', p.spread.fitness);
    p = optimize_sextupole(p, amplitude);
    if p.spread.fitness < min_fitness, continue; end
    fprintf('optimizing %f ...\n', p.spread.fitness);
    amplitude = amplitude / 5;
    while amplitude > 0.007
        p = optimize_sextupole(p, amplitude);
        amplitude = amplitude / 5;
    end
    fprintf('saving %f ...\n', p.spread.fitness);
    p = save_sextupole_configs(p);
    
end