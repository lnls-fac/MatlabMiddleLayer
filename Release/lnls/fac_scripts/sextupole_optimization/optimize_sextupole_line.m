function r = optimize_sextupole_line(p, index, delta, nr_pts)

r = p;

r.delta = delta;
if ~isfield(r, 'spread')
    r.spread = calc_tune_spread(r);
end


h = figure;


value0 = r.values(index);
values = linspace(p.values(index), p.values(index)+delta, nr_pts);
for i=1:length(values)

    r.values(index) = values(i);
    r.spread        = calc_tune_spread(r);
    spread(i)       = r.spread;
    fitness(i)      = spread(i).fitness;
   
    set(0,'CurrentFigure',h);
    scatter(values(1:i), fitness);
    
    pause(0);
    drawnow;

end
    
[fitness m] = sort(fitness, 'descend');
r.values(index) = values(m(1));
r.spread = spread(m(1));

fprintf('idx:%i,  delta:%f,  fitness:%f', index, delta, r.spread.fitness);
if value0 ~= values(m(1)), fprintf(' (improved)'); end
fprintf('\n');

    







