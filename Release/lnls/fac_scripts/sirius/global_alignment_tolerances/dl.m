global THERING;

bc = findcells(THERING, 'FamName', 'BC');
bi = findcells(THERING, 'FamName', 'BI');
bo = findcells(THERING, 'FamName', 'BO');

len_bc = getcellstruct(THERING, 'Length', bc);
len_bi = getcellstruct(THERING, 'Length', bi);
len_bo = getcellstruct(THERING, 'Length', bo);

ang_bc = getcellstruct(THERING, 'BendingAngle', bc);
ang_bi = getcellstruct(THERING, 'BendingAngle', bi);
ang_bo = getcellstruct(THERING, 'BendingAngle', bo);

rho_bc = len_bc ./ ang_bc;
rho_bi = len_bi ./ ang_bi;
rho_bo = len_bo ./ ang_bo;

dl_bc = sum(sqrt(1+0.01./rho_bc) .* len_bc) - sum(len_bc);
dl_bi = sum(sqrt(1+0.01./rho_bi) .* len_bi) - sum(len_bi);
dl_bo = sum(sqrt(1+0.01./rho_bo) .* len_bo) - sum(len_bo);

dl_tot = dl_bc + dl_bi + dl_bo;



