function [at_model M_fieldmap M_atmodel K_fieldmap K_atmodel] = calibrate_at_model(at_traj, at_model0, fieldmap_track, parms_track, monomials, runge_kutta_flags, calibration)


s_max = at_traj.s(end);

at_model = at_model0;
%monomials_subset = setdiff(monomials, [1]);
monomials_subset = monomials;

% calibrates PolynomB by polynomial fit of the 'fieldmap_track'
best_atmodel = at_model;
atmodel_track = track_through_atmodel(at_model, parms_track, s_max);
dkick = fieldmap_track.out_pts(:,2) - atmodel_track.out_pts(:,2);
min_dkick = sum(dkick.^2);
fprintf('%02i: %f\n', 0, sqrt(sum(dkick.^2))/1e-6);
for i=1:calibration.nrpts_fit
    atmodel_track = track_through_atmodel(at_model, parms_track, s_max);
    dkick = fieldmap_track.out_pts(:,2) - atmodel_track.out_pts(:,2);
    if (sum(dkick.^2) < min_dkick)
        min_dkick = sum(dkick.^2);
        best_atmodel = at_model;
        fprintf('%02i: %f\n', i, sqrt(sum(dkick.^2))/1e-6);
    end
    p = lnls_polyfit(atmodel_track.rx, -dkick, monomials_subset);
    at_model{end}.PolynomB(1+monomials_subset) = at_model{end}.PolynomB(1+monomials_subset) + p' / at_model{end}.Length;
    at_model{end}.K = at_model{end}.PolynomB(2);
end
at_model = best_atmodel;

% calibrates PolynomB to fit both kick curve and transfer matrix
M_fieldmap = calc_tmatrix(at_traj, at_model, 'fieldmap', runge_kutta_flags);
[residue max_residue residue1 residue2 M_atmodel K_fieldmap K_atmodel] = calc_residue(at_traj, at_model, M_fieldmap, parms_track, fieldmap_track);
iter = 0;
fprintf('residue(total) - residue_kickmap, residue_tmatrix (max_residue_tmatrix) %%\n');
fprintf('%05i: %f - %f, %f (%f) \n', iter, residue, residue2, residue1, max_residue);
while (iter < calibration.nrpts_trials)
    iter = iter + 1;
    at_model_new = change_at_model(at_model, calibration);
    [residue_new max_residue residue1 residue2 M_atmodel K_fieldmap K_atmodel] = calc_residue(at_traj, at_model_new, M_fieldmap, parms_track, fieldmap_track);
    if (residue_new < residue)
        at_model = at_model_new;
        residue = residue_new;
        fprintf('%05i: %f - %f, %f (%f) \n', iter, residue, residue2, residue1, max_residue);
    end
end
[residue max_residue residue1 residue2 M_atmodel K_fieldmap K_atmodel] = calc_residue(at_traj, at_model, M_fieldmap, parms_track, fieldmap_track);


% compares calibrated kick curve from AT model with Fieldmap
figure;
x = 1000 * parms_track.rx;
[AX,H1,H2] = plotyy(x,1e6*[K_fieldmap K_atmodel],x,1e6*(K_atmodel - K_fieldmap),'plot');
set(get(AX(1),'Ylabel'),'String','Kick [urad]') 
set(get(AX(2),'Ylabel'),'String','Residue [urad]') 
xlabel('Pos X [mm]');
legend({'Fieldmap','ATModel','Residue'});
title('Calibrated AT Model and Fieldmap kick curve comparison');
set(gcf, 'Name','calibrated_kick_curve');


function [residue max_residue residue1 residue2 M_atmodel K_fieldmap K_atmodel] = calc_residue(at_traj, at_model, M_fieldmap, parms_track, fieldmap_track)

% residue for linear part
[residue1 max_residue M_atmodel] = calc_residue_M(at_traj, at_model, M_fieldmap);

% residue for nonlinear part
atmodel_track = track_through_atmodel(at_model, parms_track, at_traj.s(end));
normalization = sqrt(sum(atmodel_track.out_pts(:,2).^2)/length(atmodel_track.out_pts(:,2)));
K_fieldmap = fieldmap_track.out_pts(:,2);
K_atmodel  = atmodel_track.out_pts(:,2);
dkick = 100 * (K_fieldmap - K_atmodel) ./ normalization;
residue2 = sqrt(sum(dkick.^2)/length(dkick));

% total residue
ws = [1 1];
residue = (ws * [residue1 residue2]') / sum(ws);





function [residue max_residue M_atmodel] = calc_residue_M(at_traj, at_model, M_fieldmap)

M_atmodel = calc_tmatrix(at_traj, at_model, 'atmodel');
dM = 100*(M_atmodel - M_fieldmap) ./ M_fieldmap;
dM = dM(:);
dM = dM((dM ~= NaN) & (dM ~= Inf) & (abs(M_fieldmap(:)) > 0.001));
max_residue = max(abs(dM));
residue = sqrt(sum(dM.^2)/length(dM));


function M = calc_tmatrix(at_traj, at_model, type, runge_kutta_flags)

delta_pos = 1e-6; % [m]
delta_ang = 1e-6; % [rad]

track.rx            = [0 delta_pos];
track.px            = [0 delta_ang];
if strcmpi(type, 'fieldmap')
    rtrack = track_through_fieldmap(at_traj, track, runge_kutta_flags);
end
if strcmpi(type, 'atmodel')
    rtrack = track_through_atmodel(at_model, track, at_traj.s(end));
end
r0 = rtrack.out_pts(1,:);
rx = rtrack.out_pts(2,:) - r0;
rp = rtrack.out_pts(3,:) - r0;
M(:,1) = rx([1 2])/delta_pos;
M(:,2) = rp([1 2])/delta_ang;

function at_model = change_at_model(at_model0, calibration)

% at_model = at_model0;
% n = randi(length(at_model));
% p = at_model{n}.PolynomB(2:end);
% p_new = p .* (1 + calibration.linear_per * 2 * (rand(size(p))-0.5));
% at_model{n}.PolynomB(2:end) = p_new;

at_model = at_model0;
n = randi(length(at_model));
p = at_model{n}.PolynomB(2:end);
p_new = p .* (1 + calibration.perc_change * 2 * (rand(size(p))-0.5));
at_model{n}.PolynomB(2:end) = p_new;
