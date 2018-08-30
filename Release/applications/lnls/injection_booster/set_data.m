sirius('BO');
bo_at = atsummary();
bo_ring = bo_at.the_ring;
sept = findcells(bo_ring, 'FamName', 'InjSept');
bo_ring = circshift(bo_ring, [0, - (sept - 1)]);
bo_twiss = calctwiss(bo_ring);

param.betax0 = bo_twiss.betax(1);
param.betay0 = bo_twiss.betay(1);
param.alphax0 = bo_twiss.alphax(1);
param.alphay0 = bo_twiss.alphay(1);
param.etax0 = bo_twiss.etax(1);
param.etay0 = bo_twiss.etay(1);
param.etaxl0 = bo_twiss.etaxl(1);
param.etayl0 = bo_twiss.etayl(1);

param.kckr = -19.34e-3;

param.offset_x = -30e-3;
param.offset_xl = 14.3e-3;

param.emitx = 170e-9;
param.emity = param.emitx;
param.sigmae = 0.5e-2;
param.sigmaz = 0.5e-3;

param.cutoff = 3;

param.sigma_bpm = 2e-3;
param.sigma_scrn = 0.5e-3;