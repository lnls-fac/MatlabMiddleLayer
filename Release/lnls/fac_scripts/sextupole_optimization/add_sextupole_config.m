function r = add_sextupole_config(p)

r = p;
if r.spread.fitness > 0, r.configs{length(r.configs) + 1} = rmfield(p, 'configs'); end
sextupole_configurations = r.configs;

for i=1:length(sextupole_configurations)
    fitness(i) = sextupole_configurations{i}.spread.fitness;
end
if exist('fitness', 'var')
    [fitness m n] = unique(fitness);
    sextupole_configurations = sextupole_configurations(m);
    [fitness m] = sort(fitness, 'descend');
    r.configs = sextupole_configurations(m);
end



%save 'sextupole_configurations' sextupole_configurations