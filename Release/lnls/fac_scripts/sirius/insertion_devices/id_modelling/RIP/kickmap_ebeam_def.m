function ebeam_def = kickmap_ebeam_def(id_sr_loc)

global THERING;

% unidades
mm  = 1;
GeV = 1;


mode_id = sirius_get_mode_number(id_sr_loc.mode);
setoperationalmode(mode_id);


ins_idx = findcells(THERING, 'FamName', id_sr_loc.straight);
ins_idx = ins_idx(id_sr_loc.straight_nr);



% parametros do feixe e do ponto de instalação
r = calctwiss;
ebeam_def.ebeam_energy        = THERING{ins_idx}.Energy / 1e9; % GeV
ebeam_def.betax               = r.betax(ins_idx);
ebeam_def.betay               = r.betay(ins_idx);
ebeam_def.dynapt_sizex        = id_sr_loc.x_physap;
ebeam_def.dynapt_sizey        = id_sr_loc.y_physap;
