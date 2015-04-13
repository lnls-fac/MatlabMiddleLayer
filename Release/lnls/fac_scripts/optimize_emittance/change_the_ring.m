function change_the_ring(r)

global THERING;

% implementa mudanças
change_drift_lengths(r.parms.drift_length.scale_range, r.parms.drift_length.scale_offset, r);
change_quad_strengths(r.parms.quad_strength.scale_range, r.parms.quad_strength.offset_range, r);
change_quad_lengths(r.parms.quad_length.scale_range, r.parms.quad_length.offset_range, r);
%change_bend_angles(r.parms.bend_angle.scale_range, r);
%change_bend_lengths(r.parms.bend_length.scale_range, r.parms.bend_length.offset_range, r);
%change_bend_Ks(r.parms.bend_k.scale_range, r.parms.bend_k.offset_range, r)

% reajusta perímetro do anel se necessário
perimeter = findspos(THERING, length(THERING)+1);
lengths_orig = getcellstruct(THERING, 'Length',1:length(THERING));
if (perimeter < r.constraints.perimeter.min)
    THERING = setcellstruct(THERING, 'Length', 1:length(THERING, (r.constraints.perimeter.min / perimeter) * lengths_orig));
elseif (perimeter > r.constraints.perimeter.max)
    THERING = setcellstruct(THERING, 'Length', 1:length(THERING, (r.constraints.perimeter.max / perimeter) * lengths_orig));
end
perimeter = findspos(THERING, length(THERING)+1);


% ajusta freq cav RF para novo perímetro do anel
const = lnls_constants;
e0 = getenergy('Model');
gamma = e0 / (const.E0/1000);
beta = sqrt(1 - 1/gamma);
revFreq = const.c*beta / perimeter;
rf_idx = getfamilydata('RF','AT','ATIndex');
HarmNumber = THERING{rf_idx(1)}.HarmNumber;
THERING = setcellstruct(THERING, 'Frequency', rf_idx, HarmNumber * revFreq);

return;

fprintf('simetrizando...\n');
best = NaN;
best_THERING = THERING;
for i=1:5
    try
        sr = sirius_symmetrize_simulation_optics('LowEmittance');
    catch
        break;
    end
    r1 = sum(sr.Residue1.^2);
    r2 = sum(sr.Residue2.^2);
    if isnan(best), best = r1; end;
    fprintf('%f -> %f\n', r1, r2);
    if r2 <= 0, break; end;
    if ~(best < r2)
        best = r2;
        best_THERING = THERING;
    end
    if (best < 0.01), break; end;
end
THERING = best_THERING;

