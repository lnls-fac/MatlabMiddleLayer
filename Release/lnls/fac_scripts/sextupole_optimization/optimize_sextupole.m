function r = optimize_sextupole(p, step)

r = p;
count = 0;
while count < r.nr_parms
    for i=1:r.nr_parms
        count = count + 1;
        value1 = r.values(i);
        r = optimize_sextupole_direction(r, i, step);
        value2 = r.values(i);
        if (value2 ~= value1), count = 0; end
        if count == r.nr_parms, break; end
    end
end