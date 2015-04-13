function plot_config(p)

for i=1:length(p.configs)
    values(i,:) = p.configs{i}.values;
    fitness(i) = p.configs{i}.spread.fitness;
end

figure;
plot(fitness);

figure
plot(values);
