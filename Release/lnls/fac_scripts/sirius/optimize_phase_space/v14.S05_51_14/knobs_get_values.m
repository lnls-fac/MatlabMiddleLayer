function values = knobs_get_values(ring, knobs)
values = zeros(length(knobs),1);
for ii=1:length(knobs)
    values(ii) = ring{knobs{ii}(1)}.PolynomB(3);
end