function r = fit_calc_cod_from_magnets(r0)

global THERING

r = r0;

THERING = r.the_ring;
families = fieldnames(r.meas_data);

if any(strcmpi(r.flags, '4d'))
    o1   = findorbit4(THERING, 0, 1:length(THERING));
else
    o1   = findorbit6(THERING, 1:length(THERING));
end
    
for i=1:length(families)
    family = families{i};
    dK     = r.meas_data.(family).dK;
    steppv(family, 'Physics', dK);
    if any(strcmpi(r.flags, '4d'))
        o2   = findorbit4(THERING, 0, 1:length(THERING));
    else
        o2   = findorbit6(THERING, 1:length(THERING));
    end
    steppv(family, 'Physics', -dK);
    cod  = o2 - o1;
    calc_data.(family).codx = cod(1,r.parms.bpms)';
    calc_data.(family).cody = cod(3,r.parms.bpms)';
end

r.calc_data = calc_data;
