function set_sextupole_values(p)

global THERING;

for i=1:length(p.element_idx)
    for j=1:length(p.element_idx{i})
        THERING{p.element_idx{i}(j)}.PolynomB(1,3) = p.values(i);
    end
end
