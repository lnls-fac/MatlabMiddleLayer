function optimize_emittance(varargin)

global THERING;

THERING = getappdata(0, 'THERING');
if ~isempty(varargin) || isempty(THERING)
    sirius;
    setcavity('on');
    setradiation('on');
end



FamNames = atindex(THERING);
fnames = fieldnames(FamNames);

DriftFamNames = struct;
for i=1:length(fnames)
    pmethods = getcellstruct(THERING, 'PassMethod', FamNames.(fnames{i}));
    if strcmpi(pmethods{1}, 'DriftPass')
        DriftFamNames.(fnames{i}) = FamNames.(fnames{i});
    end
end

r.parms.drift_length.fnames        = DriftFamNames;
r.parms.drift_length.scale_range   = 1 + [-0.5 0.5]/100;
r.parms.drift_length.scale_offset  = [0 0];
r.parms.drift_length.nr_fams       = 2;

r.parms.quad_strength.fnames       = findmemberof('QUAD');
r.parms.quad_strength.scale_range  = 1 + [-0.5 0.5]/100;
r.parms.quad_strength.offset_range = [0 0];
r.parms.quad_strength.nr_fams      = 2;

r.parms.quad_length.fnames       = findmemberof('QUAD');
r.parms.quad_length.scale_range  = 1 + [-0.5 0.5]/100;
r.parms.quad_length.offset_range = [0 0];
r.parms.quad_length.nr_fams      = 2;

r.parms.bend_angle.fnames          = {'BO', 'BI'};
r.parms.bend_angle.scale_range     = 1 + [-0.5 0.5]/100;
r.parms.bend_angle.scale_offset    = [0 0];
r.parms.bend_angle.nr_fams         = 1;

r.parms.bend_length.fnames          = {'BO', 'BI'};
r.parms.bend_length.scale_range     = 1 + [-0.5 0.5]/100;
r.parms.bend_length.offset_range    = [-0.010 0.010];
r.parms.bend_length.nr_fams         = 2;

r.parms.bend_k.fnames          = {'BO', 'BI'};
r.parms.bend_k.scale_range     = 1 + [-0.5 0.5]/100;
r.parms.bend_k.offset_range    = [-0.010 0.010];
r.parms.bend_k.nr_fams         = 2;

r.constraints.perimeter.min = 300;
r.constraints.perimeter.max = 500;
r.constraints.beta.max_betax = 25;
r.constraints.beta.max_betay = 40;
r.constraints.eta.max = 10;
r.constraints.eta.max_at_straight_center = 0.13;
r.constraints.K.max   = 3.0;
r.constraints.bendK.max = 0.3;

[isvalid old_optics] = calc_new_optics(r);
fprintf('%f %f (***)\n',old_optics.naturalEmittance * 1e9, old_optics.asymmetry);

while true
    sleep(0);
    drawnow;
    THERING0 = THERING;
    change_the_ring(r);
    [isvalid new_optics] = calc_new_optics(r);
    if ~isvalid || (new_optics.naturalEmittance > old_optics.naturalEmittance)
        THERING = THERING0;
        if isvalid
            fprintf('%f %f (%f %f)\n',new_optics.naturalEmittance * 1e9, new_optics.asymmetry, old_optics.naturalEmittance * 1e9, old_optics.asymmetry);
        end
    else
        try
            THERING_bef = THERING;
            sr = sirius_symmetrize_simulation_optics('LowEmittance');
            if sum(sr.Residue2.^2)>sum(sr.Residue1.^2)
                THERING = THERING_bef;
            end
            [isvalid new_optics] = calc_new_optics(r);
        catch
            isvalid = false;
        end
        if ~isvalid || (new_optics.naturalEmittance > old_optics.naturalEmittance)
            THERING = THERING0;
            continue;
        end;
        
        %close('all');
        %atsummary;
        %figure; plotbeta;
        %figure; plottwiss;
        old_optics = new_optics;
        fprintf('%f %f (***)\n',old_optics.naturalEmittance * 1e9, old_optics.asymmetry);
        setappdata(0, 'THERING', THERING);
    end
end