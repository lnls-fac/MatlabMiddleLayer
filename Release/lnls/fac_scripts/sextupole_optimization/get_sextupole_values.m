function r = get_sextupole_values(p)

global THERING;

r = [];
for i=1:length(p.element_idx)
    r = [r THERING{p.element_idx{i}(1)}.PolynomB(1,3)];
end

