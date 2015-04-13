function r = optimize_sextupole_direction(p, index, delta)

r = p;

r.delta = abs(delta);
if ~isfield(r, 'spread')
    r.spread = calc_tune_spread(r);
end

improved = false;
max_not_found = true;
while max_not_found
    
    old_value       = r.values(index);
    old_spread      = r.spread;
    r.values(index) = r.values(index) + r.delta;
    spread          = calc_tune_spread(r);
    
    if spread.fitness > r.spread.fitness
        r.spread = spread;
        improved = true;
    elseif spread.fitness <= r.spread.fitness
        r.values(index) = old_value;
        r.spread        = old_spread;
        if (r.delta < 0)
            max_not_found = false;
            r.delta = abs(r.delta);
        else
            r.delta = - r.delta;
        end
    end
    
end

fprintf('idx:%i,  delta:%f,  fitness:%f', index, delta, r.spread.fitness);
if improved, fprintf(' (improved)'); end
fprintf('\n');

    







