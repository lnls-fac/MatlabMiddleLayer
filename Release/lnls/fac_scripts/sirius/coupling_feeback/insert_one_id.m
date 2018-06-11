function ring = insert_one_id(ring, idx, polynom_a)
    ele = sextupole('',  0.0, 0.0, 'StrMPoleSymplectic4RadPass');
    ele = buildlat(ele);
    ele = ele{1};
    ele.Energy = ring{1}.Energy;
    for i=idx
        ele.Length = ring{i}.Length;
        ele.FamName = ring{i}.FamName;
        ele.PolynomA(2) = polynom_a;
        ring{i} = ele;
    end
