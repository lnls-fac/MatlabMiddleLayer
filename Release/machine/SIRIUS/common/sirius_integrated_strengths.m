function sirius_si_integrated_strengths

global THERING;

fams = findmemberof('quad');
for i=1:length(fams)
    q = fams{i};
    idx = getfamilydata(q,'AT','ATIndex');
    len = getcellstruct(THERING, 'Length', idx(1,:));
    k = getcellstruct(THERING, 'PolynomB', idx(1,:), 1, 2);
    kl = sum(len .* k);
    fprintf('%8s: %+020.16f\n', q, kl);
end
    

fams = findmemberof('sext');
for i=1:length(fams)
    q = fams{i};
    idx = getfamilydata(q,'AT','ATIndex');
    len = getcellstruct(THERING, 'Length', idx(1,:));
    k = getcellstruct(THERING, 'PolynomB', idx(1,:), 1, 3);
    kl = sum(len .* k);
    fprintf('%8s: %+020.16f\n', q, kl);
end
