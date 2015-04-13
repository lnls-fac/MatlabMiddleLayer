function at_model = create_at_model(traj, seg, magnet_type, monomials, nominal_ang)


% saves 1mm for 'thin' multipole kick.
seg.s = seg.s * (seg.s(end)-0.001)/seg.s(end);
seg.s = round(1000 * seg.s)/1000; % multiples of 1mm
[seg.by_polynom, ~, ~, seg.stray_integ_multipoles] = calc_model_by_polynom(traj, seg.s);

% gets magnetic rigidity
config = getappdata(0, 'P_CONFIG');
b_rho = -config.b_rho; % sign accounts for electron negative charge

lens          = diff(seg.s);
by_polynom    = seg.by_polynom;
stray_polynom = seg.stray_integ_multipoles;

lnls_setpath_mml_at;
model = [];

if strcmpi(magnet_type, 'dipole')
    
    polynom_a = 0;
    ang_in = 0; ang_out = 0; gap = 0; fint1 = 0; fint2 = 0; 
    pass_method = 'BndMPoleSymplectic4Pass';
    for i=1:length(lens)
        len = lens(i);
        ang = len * by_polynom(i,1) / b_rho;
        polynom_b(1+monomials) = by_polynom(i,:) / b_rho; 
        polynom_b(1) = 0;
        model = [model rbend_sirius('BEND', len, ang, ang_in, ang_out, gap, fint1, fint2, polynom_a, polynom_b, pass_method)];
    end
    polynom_b(1+monomials) = stray_polynom / b_rho; 
    BendingAngle = polynom_b(1); polynom_b(1) = 0;
    %model = [model multipole_sirius('BEND', 0, BendingAngle, polynom_a, polynom_b, 'ThinMPolePass');];
    len = 0.001; % 1mm
    ang_in = 0; ang_out = 0; gap = 0; fint1 = 0; fint2 = 0; 
    pass_method = 'BndMPoleSymplectic4Pass';
    model = [model rbend_sirius('BEND', len, BendingAngle, ang_in, ang_out, gap, fint1, fint2, polynom_a, polynom_b / len, pass_method)];
    
    at_model = buildlat(model);
    at_model = setcellstruct(at_model, 'Energy', 1:length(at_model), config.energy * 1e9);
    
%     angs     = getcellstruct(at_model, 'BendingAngle', 1:length(at_model));
%     lens     = getcellstruct(at_model, 'Length', 1:length(at_model));
%     new_angs = (nominal_ang / sum(angs)) * angs;
%     del_angs = angs - new_angs;
%     at_model = setcellstruct(at_model, 'BendingAngle', 1:length(at_model), new_angs);
%     at_model = setcellstruct(at_model, 'PolynomB', 1:length(at_model), del_angs ./ lens, 1, 1);


elseif strcmpi(magnet_type, 'quadrupole')
    
    polynom_a = 0;
    pass_method = 'StrMPoleSymplectic4Pass';
    for i=1:length(lens)
        len = lens(i);
        polynom_b(1+monomials) = by_polynom(i,:) / b_rho; 
        polynom_b(1) = 0;
        model = [model quadrupole_sirius('QUAD', len, polynom_a, polynom_b, pass_method)];
    end
    polynom_b(1+monomials) = stray_polynom / b_rho; 
    len = 0.001; % 1mm
    pass_method = 'StrMPoleSymplectic4Pass';
    model = [model quadrupole_sirius('SEXT', len, polynom_a, polynom_b / len, pass_method)];
    
    at_model = buildlat(model);
    at_model = setcellstruct(at_model, 'Energy', 1:length(at_model), config.energy * 1e9);
    
elseif strcmpi(magnet_type, 'sextupole')
    
    polynom_a = 0;
    pass_method = 'StrMPoleSymplectic4Pass';
    for i=1:length(lens)
        len = lens(i);
        polynom_b(1+monomials) = by_polynom(i,:) / b_rho; 
        polynom_b(1) = 0;
        model = [model sextupole_sirius('SEXT', len, polynom_a, polynom_b, pass_method)];
    end
    polynom_b(1+monomials) = stray_polynom / b_rho; 
    len = 0.001; % 1mm
    pass_method = 'StrMPoleSymplectic4Pass';
    model = [model sextupole_sirius('SEXT', len, polynom_a, polynom_b / len, pass_method)];
    
    at_model = buildlat(model);
    at_model = setcellstruct(at_model, 'Energy', 1:length(at_model), config.energy * 1e9);

elseif strcmpi(magnet_type, 'corrector')
    
    polynom_a = 0;
    pass_method = 'StrMPoleSymplectic4Pass';
    for i=1:length(lens)
        len = lens(i);
        polynom_b(1+monomials) = by_polynom(i,:) / b_rho; 
        polynom_b(1) = 0;
        model = [model sextupole_sirius('SEXT', len, polynom_a, polynom_b, pass_method)];
    end
    polynom_b(1+monomials) = stray_polynom / b_rho; 
    len = 0.001; % 1mm
    pass_method = 'StrMPoleSymplectic4Pass';
    model = [model sextupole_sirius('SEXT', len, polynom_a, polynom_b / len, pass_method)];
    
    at_model = buildlat(model);
    at_model = setcellstruct(at_model, 'Energy', 1:length(at_model), config.energy * 1e9);
    
end

% normalizes total deflection angle (at thin dipole at end of model)
idx = findcells(at_model, 'BendingAngle');
if isempty(idx), return; end;
org_ang = getcellstruct(at_model, 'BendingAngle', idx);
dif_ang = nominal_ang - sum(org_ang);
at_model{end}.BendingAngle = at_model{end}.BendingAngle + dif_ang;
at_model{end}.PolynomB(1) = at_model{end}.PolynomB(1) - dif_ang / at_model{end}.Length;



        
        
