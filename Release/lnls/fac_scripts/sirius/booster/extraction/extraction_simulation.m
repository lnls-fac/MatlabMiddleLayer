function [sposB outB sposTL outTL] = extraction_simulation(synchrotron, transfer_line, param, err)


%% First, lets track through the booster!!!!!!

%first, we define the leakage field from the extraction septum:
seb_tl_ind = findcells(transfer_line,'FamName','seb');
seb_ang = transfer_line{seb_tl_ind(1)}.BendingAngle;
seb_len = transfer_line{seb_tl_ind(1)}.Length;
seb_polb= transfer_line{seb_tl_ind(1)}.PolynomB(1);
seb_dang = param.ltba.seb_dang/length(seb_tl_ind)/seb_len;
seb_Tang = (seb_ang + (seb_polb + seb_dang)*seb_len)*length(seb_tl_ind);
seb_ind = findcells(synchrotron,'FamName','SEPT_EX');
seb = corrector('SEPT_EX', synchrotron{seb_ind(1)}.Length, ...
    [seb_Tang*(1+err.seb)*param.boo.seb_leak 0]/length(seb_ind), 'CorrectorPass');
seb = buildlat(seb);
synchrotron_sep = synchrotron;
synchrotron_sep(seb_ind) = seb;
orb = findorbit4(synchrotron_sep, 0);

% Now, lets generate the particles:

%particles' initial position:
Rin = param.Rin + [orb;0;0];

%bunch tracking or single particle?:
cutoff = param.cutoff;
n_part= param.n_part;
if n_part>1
    ini_ind = findcells(synchrotron,'FamName','INICIO');
    twi = calctwiss(synchrotron);
    twiss(1) = twi.betax(ini_ind);   twiss(3) = twi.betay(ini_ind);
    twiss(2) = twi.alphax(ini_ind);  twiss(4) = twi.alphay(ini_ind);
    twiss(5) = twi.etax(ini_ind);    twiss(7) = twi.etay(ini_ind);
    twiss(6) = twi.etaxl(ini_ind);   twiss(8) = twi.etayl(ini_ind);
     
    % and generate the bunch.
    bun = lnls_generate_bunch(param.emitx,param.emity,param.sigmae,...
                              param.sigmas,twiss,n_part,cutoff);
   
    % Rin = repmat(Rin,1,n_part) + bun;
    Rin = bsxfun(@plus,Rin,bun);
end

% Now, lets pick the section of the ring from the beginning to the septum:
extraction_section = synchrotron(1:(seb_ind(1)-1));

% turn on the kicker
kick_ind = findcells(extraction_section,'FamName','KICK_EX');
kick_ang = param.boo.kick_ang*(1+err.boo_kick);
kick_ex = corrector('KICK_EX', extraction_section{kick_ind(1)}.Length, [kick_ang 0], 'CorrectorPass');
kick_ex = buildlat(kick_ex);
extraction_section(kick_ind) = kick_ex;

% Track through it:
Rout = linepass(extraction_section,Rin,1:length(extraction_section)+1);

% And define the outputs;
sposB = findspos(extraction_section,1:length(extraction_section)+1);
outB.x_max = max(reshape(Rout(1,:),n_part,length(sposB)),[],1);
outB.x_min = min(reshape(Rout(1,:),n_part,length(sposB)),[],1);
outB.x_ave = mean(reshape(Rout(1,:),n_part,length(sposB)),1);
outB.y_max = max(reshape(Rout(3,:),n_part,length(sposB)),[],1);
outB.y_min = min(reshape(Rout(3,:),n_part,length(sposB)),[],1);
outB.y_ave = mean(reshape(Rout(3,:),n_part,length(sposB)),1);


%% Now, we deal with the Transport Line!!!!!

%First, we define the transfer_line's incoming beam:
RinTL  = Rout(:,(end-n_part+1):end);
x_seb = param.ltba.seb_x; %septum position
xp_seb = param.ltba.seb_xp; %septum angle
RinTL = bsxfun(@plus,-[x_seb;xp_seb;0;0;0;0],RinTL);
RinTL(1,:) = RinTL(1,:)*cos(xp_seb) - RinTL(6,:)*sin(xp_seb);
RinTL(6,:) = RinTL(6,:)*cos(xp_seb) + RinTL(1,:)*sin(xp_seb);



% We must set the septa parameters:
%extraction
seb_err = err.seb*seb_ang/seb_len;
seb_polb= (seb_dang + seb_polb)*(1+err.seb) + seb_err;
transfer_line = setcellstruct(transfer_line,'PolynomB',seb_tl_ind,seb_polb, 1);

%thick
seg_tl_ind = findcells(transfer_line,'FamName','seg');
seg_ang = transfer_line{seg_tl_ind(1)}.BendingAngle;
seg_len = transfer_line{seg_tl_ind(1)}.Length;
seg_polb= transfer_line{seg_tl_ind(1)}.PolynomB(1);
seg_dang = param.ltba.seg_dang/length(seg_tl_ind)/seg_len;
seg_err = err.seg*seg_ang/seg_len;
seg_polb= (seg_dang + seg_polb)*(1+err.seg) + seg_err;
transfer_line = setcellstruct(transfer_line,'PolynomB',seg_tl_ind,seg_polb, 1);


%thin
sef_tl_ind = findcells(transfer_line,'FamName','sef');
sef_ang = transfer_line{sef_tl_ind(1)}.BendingAngle;
sef_len = transfer_line{sef_tl_ind(1)}.Length;
sef_polb= transfer_line{sef_tl_ind(1)}.PolynomB(1);
sef_dang = param.ltba.sef_dang/length(sef_tl_ind)/sef_len;
sef_err = err.sef*sef_ang/sef_len;
sef_polb= (sef_dang + sef_polb)*(1+err.sef) + sef_err;
transfer_line = setcellstruct(transfer_line,'PolynomB',sef_tl_ind,sef_polb, 1);


% Now, Track through transfer line:
Rout = linepass(transfer_line,RinTL,1:length(transfer_line)+1);

% And define the outputs;
sposTL = findspos(transfer_line,1:length(transfer_line)+1);
outTL.Rin = RinTL;
outTL.Rout = Rout(:,(end-n_part+1):end);
outTL.x_max = max(reshape(Rout(1,:),n_part,length(sposTL)),[],1);
outTL.x_min = min(reshape(Rout(1,:),n_part,length(sposTL)),[],1);
outTL.x_ave = mean(reshape(Rout(1,:),n_part,length(sposTL)),1);
outTL.y_max = max(reshape(Rout(3,:),n_part,length(sposTL)),[],1);
outTL.y_min = min(reshape(Rout(3,:),n_part,length(sposTL)),[],1);
outTL.y_ave = mean(reshape(Rout(3,:),n_part,length(sposTL)),1);

