function change_bend_angles(scale_range, r)

global THERING;

bend_fnames = r.parms.bend_angle.fnames;

% registra angulos iniciais das familias 
bends = [];
for i=1:length(bend_fnames)
    ATIndex = getfamilydata(bend_fnames{i}, 'AT', 'ATIndex');
    bends = [bends ATIndex(:)'];
end
angles0 = getcellstruct(THERING, 'BendingAngle', bends);

% seleciona familias q serao variadas
rp = randperm(length(bend_fnames));
bend_fnames = bend_fnames(rp(1:r.parms.bend_angle.nr_fams));


for i=1:length(bend_fnames)
    fname = bend_fnames{i};
    v1 = gen_rand_vector(1, r);
    scale   = scale_range(1)  + v1 * (scale_range(2)  - scale_range(1));
    ATIndex = getfamilydata(fname, 'AT', 'ATIndex');
    b1_orig  = getcellstruct(THERING, 'BendingAngle', ATIndex);
    b2_orig  = getcellstruct(THERING, 'EntranceAngle', ATIndex);
    b3_orig  = getcellstruct(THERING, 'ExitAngle', ATIndex);
    b1_new  = b1_orig * scale;
    b2_new  = b2_orig * scale;
    b3_new  = b3_orig * scale;
    THERING = setcellstruct(THERING, 'BendingAngle', ATIndex, b1_new);
    THERING = setcellstruct(THERING, 'EntranceAngle', ATIndex, b2_new);
    THERING = setcellstruct(THERING, 'ExitAngle', ATIndex, b3_new);
end

% reajuste angulo dos dipolos
angles1 = getcellstruct(THERING, 'BendingAngle', bends);
angles2 = getcellstruct(THERING, 'EntranceAngle', bends);
angles3 = getcellstruct(THERING, 'ExitAngle', bends);
THERING = setcellstruct(THERING, 'BendingAngle', bends, angles1 * (sum(angles0)/sum(angles1)));
THERING = setcellstruct(THERING, 'EntranceAngle', bends, angles2 * (sum(angles0)/sum(angles1)));
THERING = setcellstruct(THERING, 'ExitAngle', bends, angles3 * (sum(angles0)/sum(angles1)));
