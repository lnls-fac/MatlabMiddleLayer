function ring = knobs_set_values(ring,knobs,values)
for ii=1:length(knobs)
    ring = setcellstruct(ring,'PolynomB',knobs{ii},values(ii),1,3);
end