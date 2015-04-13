function print_summary(parms, rk_traj, rk_traj_parms, at_traj, at_model, fieldmap_track, atmodel_track, M_fieldmap, M_atmodel)

fname = fullfile(parms.config_path, 'SUMMARY.txt');
fp  = fopen(fname, 'w');


strfmt = '%-40s';

% --- header ---
fprintf(fp, 'FIELDMAP ANALYSIS\n');
fprintf(fp, '=================\n');
fprintf(fp, strfmt, 'timestamp:'); fprintf(fp, datestr(now)); fprintf(fp, '\n');
fprintf(fp, strfmt, 'magnet type:'); fprintf(fp, parms.magnet_type); fprintf(fp, '\n');
fprintf(fp, strfmt, 'nominal deflection angle:'); fprintf(fp, [num2str(2*parms.nominal_ang * (180/pi), '%11.7f'), ' deg.']); fprintf(fp, '\n');
fprintf(fp, '\n');

% --- beam ---
ebeam = getappdata(0, 'P_CONFIG');
fprintf(fp, 'BEAM PARAMETERS\n\n');
fprintf(fp, strfmt, 'energy:');              fprintf(fp, [num2str(parms.beam.energy), ' GeV']); fprintf(fp, '\n');
fprintf(fp, strfmt, 'relativistic factor:'); fprintf(fp, [num2str(ebeam.gamma), '']); fprintf(fp, '\n');
fprintf(fp, strfmt, 'magnetic Rigidity:');   fprintf(fp, [num2str(ebeam.b_rho), ' T.m']); fprintf(fp, '\n');
fprintf(fp, strfmt, 'current:');             fprintf(fp, [num2str(parms.beam.current*1000), ' mA']); fprintf(fp, '\n');
fprintf(fp, '\n');

% --- fieldmap ---
fmaps = getappdata(0, 'FIELD_MAPS');
fprintf(fp, 'FIELDMAP DATA\n\n');
for i=1:length(fmaps)
    fmap = fmaps{1};
    fprintf(fp, ['--- fieldmap #', num2str(i, '%02i'), ' ---']); fprintf(fp, '\n');
    [~, name, ext] = fileparts(fmap.fname); fname = [name ext];
    fprintf(fp, strfmt, 'filename:');              fprintf(fp, fname); fprintf(fp, '\n');
    fprintf(fp, strfmt, 'physical length:');       fprintf(fp, [num2str(1000*fmap.magnet.length), ' mm']); fprintf(fp, '\n');
    % em virtude a alteracao feita em load_fieldmap também tive que alterar
    % aqui. Fernando-2014-03-05
    if strncmpi(fmap.magnet.label,'dipolo',6)
        fprintf(fp, strfmt, 'magnetic gap:');          fprintf(fp, [num2str(1000*fmap.magnet.gap), ' mm']); fprintf(fp, '\n');
    else
        fprintf(fp, strfmt, 'bore diameter:');          fprintf(fp, [num2str(1000*fmap.magnet.bore), ' mm']); fprintf(fp, '\n');
    end
    fprintf(fp, strfmt, 'horizontal grid (x):');   fprintf(fp, ['[', num2str(1000*min(fmap.data.x)), ',', num2str(1000*max(fmap.data.x)), '] mm, ', num2str(length(fmap.data.x)), ' pts']); fprintf(fp, '\n');
    fprintf(fp, strfmt, 'longitudinal grid (z):'); fprintf(fp, ['[', num2str(1000*min(fmap.data.z)), ',', num2str(1000*max(fmap.data.z)), '] mm, ', num2str(length(fmap.data.z)), ' pts']); fprintf(fp, '\n');
    fprintf(fp, strfmt, 'vertical field By:');     fprintf(fp, ['[', num2str(min(fmap.data.fderivs{1}.by(:)), '%+7.4f'), ',' num2str(max(fmap.data.fderivs{1}.by(:)), '%+7.4f'), '] T']); fprintf(fp, '\n');
    fprintf(fp, strfmt, 'horizontal field Bx:');   fprintf(fp, ['[', num2str(min(fmap.data.fderivs{1}.bx(:)), '%+7.4f'), ',' num2str(max(fmap.data.fderivs{1}.bx(:)), '%+7.4f'), '] T']); fprintf(fp, '\n');
    fprintf(fp, strfmt, 'longitudinal field Bz:'); fprintf(fp, ['[', num2str(min(fmap.data.fderivs{1}.bz(:)), '%+7.4f'), ',' num2str(max(fmap.data.fderivs{1}.bz(:)), '%+7.4f'), '] T']); fprintf(fp, '\n');   
end
fprintf(fp, '\n');

% --- real trajectory ---
fprintf(fp, 'RUNGE-KUTTA TRAJECTORY (full model)\n\n');
fprintf(fp, strfmt, 'deflection angle:'); fprintf(fp, [num2str((180/pi)*abs(2*rk_traj.angle_x(end)), '%11.7f'), ' deg.']); fprintf(fp, [' [' num2str(100*(abs(rk_traj.angle_x(end)) - parms.nominal_ang)/parms.nominal_ang, '%+7.3f'), ' %%]']); fprintf(fp, '\n');
fprintf(fp, strfmt, 'irradiated power:'); fprintf(fp, [num2str(2*rk_traj_parms.power/1000, '%7.4f'), ' kW']); fprintf(fp, '\n');
fprintf(fp, strfmt, 'initial [x,y,z,beta_x,beta_y,beta_z]:'); fprintf(fp, '['); fprintf(fp, '%+7.3f ', [1000 1000 1000 1 1 1]' .* parms.init_position); fprintf(fp, '] (mm/n.u.)'); fprintf(fp, '\n');
fprintf(fp, strfmt, 'arclength  s interval:'); fprintf(fp, ['[', num2str(1000*min(rk_traj.s), '%+9.3f'), ', ', num2str(1000*max(rk_traj.s), '%+9.3f'), '] mm']); fprintf(fp, '\n');
fprintf(fp, strfmt, 'horizontal x interval:'); fprintf(fp, ['[', num2str(1000*min(rk_traj.x), '%+9.3f'), ', ', num2str(1000*max(rk_traj.x), '%+9.3f'), '] mm']); fprintf(fp, '\n');
fprintf(fp, strfmt, 'longitudinal z interval:'); fprintf(fp, ['[', num2str(1000*min(rk_traj.z), '%+9.3f'), ', ', num2str(1000*max(rk_traj.z), '%+9.3f'), '] mm']); fprintf(fp, '\n');
[~,ix]=max(abs(rk_traj.bx_field));[~,iy]=max(abs(rk_traj.by_field));[~,iz]=max(abs(rk_traj.bz_field));
fprintf(fp, strfmt, 'max. abs. (Bx,By,Bz):');   fprintf(fp, ['[', num2str(rk_traj.bx_field(ix), '%+7.4f'), ',', num2str(rk_traj.by_field(iy), '%+7.4f'), ',', num2str(rk_traj.bz_field(iz), '%+7.4f'), '] T']); fprintf(fp, '\n');
fprintf(fp, strfmt, 'multipole grid (x):');     fprintf(fp, ['[', num2str(1000*min(parms.perp_grid.points)), ',', num2str(1000*max(parms.perp_grid.points)), '] mm, ', num2str(length(parms.perp_grid.points)), ' pts']); fprintf(fp, '\n');
fprintf(fp, strfmt, 'r0 for tracy coeff:');     fprintf(fp, '%6.3f mm',1000*parms.tracy.r0); fprintf(fp, '\n');
fprintf(fp, strfmt, 'multipoles (polynomB):'); fprintf(fp, '%-10s', '[order]'); fprintf(fp, '%-22s', '[maximum abs. value]'); fprintf(fp, '%-22s', '[integrated value]'); fprintf(fp, '%-22s', '[tracy3 coeffs]'); fprintf(fp, '\n');
for i=1:size(rk_traj.by_polynom,2)
    [~, idx] = max(abs(rk_traj.by_polynom(:,i)));
    x_power = parms.perp_grid.monomials(i);
    pow1 = x_power; pow2 = x_power-1;
    if (pow1 == 0), units1 = 'T'; elseif (pow1 == 1), units1 = 'T/m'; else units1 = ['T/m^' int2str(pow1)]; end;
    if (pow2 == -1), units2 = 'T.m'; elseif (pow2 == 0), units2 = 'T'; elseif (pow2 == 1), units2 = 'T/m'; else units2 = ['T/m^' int2str(pow2)]; end
    fprintf(fp, strfmt, ''); fprintf(fp, '%-10s', num2str(x_power, '%02i')); 
    fprintf(fp, '%-22s', [num2str(rk_traj.by_polynom(idx,i), '%+12.5E'), ' ', units1]);
    fprintf(fp, '%-22s', [num2str(2*rk_traj_parms.integ_by_polynom(i), '%+12.5E'), ' ', units2]);
    fprintf(fp, num2str(rk_traj_parms.tracy_multipoles_polynomB(i), '%+12.5E'));
    fprintf(fp, '\n');
end
fprintf(fp, strfmt, 'multipoles (polynomA):'); fprintf(fp, '%-10s', '[order]'); fprintf(fp, '%-22s', '[maximum abs. value]'); fprintf(fp, '%-22s', '[integrated value]'); fprintf(fp, '%-22s', '[tracy3 coeffs]'); fprintf(fp, '\n');
for i=1:size(rk_traj.bx_polynom,2)
    [~, idx] = max(abs(rk_traj.bx_polynom(:,i)));
    x_power = parms.perp_grid.monomials(i);
    pow1 = x_power; pow2 = x_power-1;
    if (pow1 == 0), units1 = 'T'; elseif (pow1 == 1), units1 = 'T/m'; else units1 = ['T/m^' int2str(pow1)]; end;
    if (pow2 == -1), units2 = 'T.m'; elseif (pow2 == 0), units2 = 'T'; elseif (pow2 == 1), units2 = 'T/m'; else units2 = ['T/m^' int2str(pow2)]; end
    fprintf(fp, strfmt, ''); fprintf(fp, '%-10s', num2str(x_power, '%02i')); 
    fprintf(fp, '%-22s', [num2str(rk_traj.bx_polynom(idx,i), '%+12.5E'), ' ', units1]);
    fprintf(fp, '%-22s', [num2str(2*rk_traj_parms.integ_bx_polynom(i), '%+12.5E'), ' ', units2]);
    fprintf(fp, num2str(rk_traj_parms.tracy_multipoles_polynomA(i), '%+12.5E'));
    fprintf(fp, '\n');
end
fprintf(fp, '\n');

%% --- transfer matrix ---
fprintf(fp, 'TRANSFER MATRIX: AT MODEL vs RUNGE-KUTTA-REF-TRAJ (half model)\n\n');
fprintf(fp, 'determinant (Runge-Kutta): %+17.15f\n', det(M_fieldmap));
fprintf(fp, '%-10s', 'element'); fprintf(fp, '%-22s', '[runge-kutta]'); fprintf(fp, '%-22s', '[at-model]'); fprintf(fp, '%-22s', '[error %]'); fprintf(fp, '\n');
fprintf(fp, '%-10s', 'M11');     fprintf(fp, '%-22s', num2str(M_fieldmap(1,1), '%+9.6f'));  fprintf(fp, '%-22s', num2str(M_atmodel(1,1), '%+9.6f')); fprintf(fp, '%-22s', num2str(100*(M_atmodel(1,1) - M_fieldmap(1,1))/M_fieldmap(1,1), '%+9.6f')); fprintf(fp, '\n');
fprintf(fp, '%-10s', 'M12');     fprintf(fp, '%-22s', num2str(M_fieldmap(1,2), '%+9.6f'));  fprintf(fp, '%-22s', num2str(M_atmodel(1,2), '%+9.6f')); fprintf(fp, '%-22s', num2str(100*(M_atmodel(1,2) - M_fieldmap(1,2))/M_fieldmap(1,2), '%+9.6f')); fprintf(fp, '\n');
fprintf(fp, '%-10s', 'M21');     fprintf(fp, '%-22s', num2str(M_fieldmap(2,1), '%+9.6f'));  fprintf(fp, '%-22s', num2str(M_atmodel(2,1), '%+9.6f')); fprintf(fp, '%-22s', num2str(100*(M_atmodel(2,1) - M_fieldmap(2,1))/M_fieldmap(2,1), '%+9.6f')); fprintf(fp, '\n');
fprintf(fp, '%-10s', 'M22');     fprintf(fp, '%-22s', num2str(M_fieldmap(2,2), '%+9.6f'));  fprintf(fp, '%-22s', num2str(M_atmodel(2,2), '%+9.6f')); fprintf(fp, '%-22s', num2str(100*(M_atmodel(2,2) - M_fieldmap(2,2))/M_fieldmap(2,2), '%+9.6f')); fprintf(fp, '\n');
xi  = fieldmap_track.in_pts(:,1)';
pxf = fieldmap_track.out_pts(:,2)';
kick_coeffs_rk = lnls_polyfit(xi,pxf,parms.perp_grid.monomials);
xi  = atmodel_track.in_pts(:,1)';
pxf = atmodel_track.out_pts(:,2)';
kick_coeffs_at = lnls_polyfit(xi,pxf,parms.perp_grid.monomials);
fprintf(fp, '%-10s', 'T211');     fprintf(fp, '%-22s', num2str(kick_coeffs_rk(3), '%+9.6f'));  fprintf(fp, '%-22s', num2str(kick_coeffs_at(3), '%+9.6f')); fprintf(fp, '%-22s', num2str(100*(kick_coeffs_at(3) - kick_coeffs_rk(3))/kick_coeffs_rk(3), '%+9.6f')); fprintf(fp, '\n');

fprintf(fp, '\n');


%% --- transfer maps ---
fprintf(fp, 'TRANSFER MAPS: AT MODEL vs RUNGE-KUTTA (half-model)\n\n');
fprintf(fp, strfmt, 'horizontal grid (x):');   fprintf(fp, ['[', num2str(1000*min(parms.track.rx)), ',', num2str(1000*max(parms.track.rx)), '] mm, ', num2str(length(parms.track.rx)), ' pts']); fprintf(fp, '\n');
fprintf(fp, strfmt, 'angular grid (px):');   fprintf(fp, ['[', num2str(1000*min(parms.track.px)), ',', num2str(1000*max(parms.track.px)), '] mm, ', num2str(length(parms.track.px)), ' pts']); fprintf(fp, '\n');
fprintf(fp, strfmt, 'max. abs. delta x:'); fprintf(fp, [num2str(1e6*(max(abs(fieldmap_track.out_pts(:,1) - atmodel_track.out_pts(:,1)))), '%6.2f'), ' um']); fprintf(fp, '\n');
fprintf(fp, strfmt, 'max. abs. delta px:'); fprintf(fp, [num2str(1e6*(max(abs(fieldmap_track.out_pts(:,2) - atmodel_track.out_pts(:,2)))), '%6.2f'), ' urad']); fprintf(fp, '\n');
fprintf(fp, strfmt, 'max. abs. delta dl:'); fprintf(fp, [num2str(1e3*(max(abs(fieldmap_track.out_pts(:,6) - atmodel_track.out_pts(:,6)))), '%6.2f'), ' mm']); fprintf(fp, '\n');
fprintf(fp, strfmt, 'fitted multipoles:'); fprintf(fp, '%-10s', '[order]'); fprintf(fp, '%-22s', '[runge-kutta]'); fprintf(fp, '%-22s', '[at-model]'); fprintf(fp, '%-22s', '[error %]'); fprintf(fp, '\n');
x = fieldmap_track.rx;
rk_data = fieldmap_track.out_pts(:,2); rk_p = lnls_polyfit(x, rk_data, parms.perp_grid.monomials);
at_data = atmodel_track.out_pts(:,2); at_p = lnls_polyfit(x, at_data, parms.perp_grid.monomials);
for i=1:size(rk_traj.by_polynom,2)
    x_power = parms.perp_grid.monomials(i);
    if (x_power == 0), units1 = ''; elseif (x_power == 1), units1 = '1/m'; else units1 = ['1/m^' int2str(x_power)]; end;
    fprintf(fp, strfmt, ''); fprintf(fp, '%-10s', num2str(x_power, '%02i')); 
    fprintf(fp, '%-22s', [num2str(rk_p(i), '%+12.5E'), ' ', units1]);
    fprintf(fp, '%-22s', [num2str(at_p(i), '%+12.5E'), ' ', units1]);
    fprintf(fp, num2str(100*(at_p(i) - rk_p(i))/rk_p(i), '%+8.3f'));
%     if (i == 1), fprintf(fp, '--'); else
%         fprintf(fp, num2str(100*(at_p(i) - rk_p(i))/rk_p(i), '%+8.3f'));
%     end
    fprintf(fp, '\n');
end
fprintf(fp, '\n');


%% --- AT model ---
fprintf(fp, 'AT MODEL SEGMENTATION (half model)\n\n');
order = []; for i=1:length(at_model), polB = at_model{i}.PolynomB; order = union(order, find(polB ~= 0) - 1); end
fprintf(fp,'LENGTH[m] ANGLE[rad]        (n Bn)... \n');
for i=1:length(at_model)
    fprintf(fp, '%-10s', num2str(at_model{i}.Length, '%5.3f'));
    if isfield(at_model{i}, 'BendingAngle'), ang = at_model{i}.BendingAngle; else ang = 0; end;
    fprintf(fp, '%+17.10E ', ang);
    polB = at_model{i}.PolynomB;
    for j=order
        fprintf(fp, '% 02i %+17.10E   ', j, polB(j+1));
    end
    fprintf(fp, '\n');
end
fprintf(fp, '\n');

fclose(fp);
