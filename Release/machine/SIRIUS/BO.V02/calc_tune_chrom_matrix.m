% calculate matrices for tune and chromaticity correction.

delta_q = 1e-3;
delta_s = 1e-2;

bo = sirius_bo_lattice();
[~,nom_tune,nom_chrom] = twissring(bo,0,1:length(bo),'chrom');

qf = findcells(bo,'FamName','qf');
qd = findcells(bo,'FamName','qd');
qf_stren = getcellstruct(bo,'PolynomB',qf,1,2);
qd_stren = getcellstruct(bo,'PolynomB',qd,1,2);
qf_len = getcellstruct(bo,'Length',qf(1))*2; % the model is segmented
qd_len = getcellstruct(bo,'Length',qd(1));


Mt = zeros(2,2);

bo = setcellstruct(bo,'PolynomB',qf,qf_stren+delta_q/2,1,2);
[~,tune_pos] = twissring(bo,0,1:length(bo));
bo = setcellstruct(bo,'PolynomB',qf,qf_stren-delta_q/2,1,2);
[~,tune_neg] = twissring(bo,0,1:length(bo));
bo = setcellstruct(bo,'PolynomB',qf,qf_stren,1,2);
Mt(:,1) = (tune_pos-tune_neg)/(delta_q*qf_len);


bo = setcellstruct(bo,'PolynomB',qd,qd_stren+delta_q/2,1,2);
[~,tune_pos] = twissring(bo,0,1:length(bo));
bo = setcellstruct(bo,'PolynomB',qd,qd_stren-delta_q/2,1,2);
[~,tune_neg] = twissring(bo,0,1:length(bo));
bo = setcellstruct(bo,'PolynomB',qd,qd_stren,1,2);
Mt(:,2) = (tune_pos-tune_neg)/(delta_q*qd_len);


sf = findcells(bo,'FamName','sf');
sd = findcells(bo,'FamName','sd');
sf_stren = getcellstruct(bo,'PolynomB',sf,1,3);
sd_stren = getcellstruct(bo,'PolynomB',sd,1,3);
sf_len = getcellstruct(bo,'Length',sf(1));
sd_len = getcellstruct(bo,'Length',sd(1));


Mc = zeros(2,2);

bo = setcellstruct(bo,'PolynomB',sf,sf_stren+delta_s/2,1,3);
[~,~,chrom_pos] = twissring(bo,0,1:length(bo),'chrom');
bo = setcellstruct(bo,'PolynomB',sf,sf_stren-delta_s/2,1,3);
[~,~,chrom_neg] = twissring(bo,0,1:length(bo),'chrom');
bo = setcellstruct(bo,'PolynomB',sf,sf_stren,1,3);
Mc(:,1) = (chrom_pos-chrom_neg)/(delta_s*sf_len);


bo = setcellstruct(bo,'PolynomB',sd,sd_stren+delta_s/2,1,3);
[~,~,chrom_pos] = twissring(bo,0,1:length(bo),'chrom');
bo = setcellstruct(bo,'PolynomB',sd,sd_stren-delta_s/2,1,3);
[~,~,chrom_neg] = twissring(bo,0,1:length(bo),'chrom');
bo = setcellstruct(bo,'PolynomB',sd,sd_stren,1,3);
Mc(:,2) = (chrom_pos-chrom_neg)/(delta_s*sd_len);

