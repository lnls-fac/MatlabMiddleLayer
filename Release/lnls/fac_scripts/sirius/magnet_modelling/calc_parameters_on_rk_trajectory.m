function r = calc_parameters_on_rk_trajectory(trajectory, beam_config, magnet_type, tracy_r0, monomials)

% calcs total power irradiated [unit: watt]
if isfield(beam_config, 'current')
    b2 = sum(([trajectory.bx_field trajectory.by_field trajectory.bz_field].^2),2);
    bm = (b2(1:end-1) + b2(2:end))/2;
    b2int = sum(bm .* diff(trajectory.s));
    r.power = 1265.5 * beam_config.energy^2 * beam_config.current * b2int; 
else
    r.power = 0;
end

% calcs integrals of multipoles (simplest trap. rule) POLYNOM_B
v1 = trajectory.by_polynom(1:end-1,:);
v2 = trajectory.by_polynom(2:end,:);
vm = 0.5 * (v1 + v2);
ds = diff(trajectory.s);
r.integ_by_polynom = ds' * vm;

% calcs integrals of multipoles (simplest trap. rule) POLYNOM_A
v1 = trajectory.bx_polynom(1:end-1,:);
v2 = trajectory.bx_polynom(2:end,:);
vm = 0.5 * (v1 + v2);
ds = diff(trajectory.s);
r.integ_bx_polynom = ds' * vm;


% calcs TracyIII multipole coefficients
if any(strcmpi(magnet_type, {'dipole','corrector'}))
    main_power = 0;
elseif strcmpi(magnet_type, 'quadrupole')
    main_power = 1;
elseif strcmpi(magnet_type, 'sextupole')
    main_power = 2;
end

idx = find(main_power == monomials, 1); if isempty(idx), error('main multipole not in monomial list'); end
main_multipole = r.integ_by_polynom(idx) * (tracy_r0 ^ main_power);

for i=1:length(r.integ_by_polynom)
    power = monomials(i);
    r.tracy_multipoles_polynomB(i) = r.integ_by_polynom(i) * (tracy_r0 ^ power) / main_multipole;
end

for i=1:length(r.integ_bx_polynom)
    power = monomials(i);
    r.tracy_multipoles_polynomA(i) = r.integ_bx_polynom(i) * (tracy_r0 ^ power) / main_multipole;
end

