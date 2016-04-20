function analyse_driving_terms()

% folder = '../v14.S05_49_14/moga_results/run2/RUN0491/';
folder = 'moga_results/run2/RUN1999/';

r = load([folder,'multi.cod.tune.coup/cod_matlab/CONFIG_machines_cod_corrected_tune.mat']);
machine = r.machine;
DT  = struct();
for i = 1:length(machine)
    ring = lnls_refine_lattice(machine{i},0.03,{'BndMPoleSymplectic4Pass','StrMPoleSymplectic4Pass'});
    ring = set_num_integ_steps(ring);
    if i==1, DT = lnls_calc_drive_terms(ring); else DT(i) = lnls_calc_drive_terms(ring);end
end

fiel = fieldnames(DT);
Rav = zeros(1,length(fiel)); Iav = Rav; Rsd = Rav; Isd = Rav;
for i=1:length(fiel)
    dr = cat(1,DT.(fiel{i}));
    Rav(i) = mean(real(dr));
    Iav(i) = mean(imag(dr));
    Rsd(i) = std(real(dr));
    Isd(i) = std(imag(dr));
    fprintf('%7s = %9.4f %9.4fi   %9.4f %9.4fi\n',fiel{i},Rav(i),Iav(i),Rsd(i),Isd(i));
end

cur_dir = pwd;
cd(folder);
a = dir;
for ii=1:length(a),
    if strncmpi('run_00',a(ii).name,6)
        f = str2func(a(ii).name(1:end-2));
    end
end
si = local_si5_lattice('C','03',f);
cd(cur_dir);
si = lnls_refine_lattice(si,0.03,{'BndMPoleSymplectic4Pass','StrMPoleSymplectic4Pass'});
DT = lnls_calc_drive_terms(si);

figure; errorbar(Rav,Rsd,'.'); hold on; plot(real(struct2array(DT)));
set(gca(),'XTick',1:length(Rav),'XTickLabel',fiel);

figure; errorbar(Iav,Isd,'.'); hold on; plot(imag(struct2array(DT)));
set(gca(),'XTick',1:length(Rav),'XTickLabel',fiel);



% function analyse_driving_terms(ring, drts)
% 
% ring = lnls_refine_lattice(ring,0.03,{'BndMPoleSymplectic4Pass','StrMPoleSymplectic4Pass'});
% ring = set_num_integ_steps(ring);
% twi  = calctwiss(ring);
% % twi.mux = twi.mux*(2*pi*49.2)/(twi.mux(end)*5);
% DT   = lnls_calc_drive_terms(ring,twi);
% 
% 
% figure; ax = axes; hold(ax,'all');
% len = length(drts);
% lsty = {'-','--',':','-.'};
% for i=1:len
%     fact = 1;
%     drt = drts{i};
%     if any(strcmpi(drt(end),{'1','2'})), fact = 1;end
%     plot_arrow(ax,DT.(drt)*fact,[i/len,0,(len-i)/len],drt,lsty{1+mod(i-1,length(lsty))});
% end
% legend(ax,'show','Location','best');



% function analyse_driving_terms(ring, drt, fams)
% 
% ring = lnls_refine_lattice(ring,0.03,{'BndMPoleSymplectic4Pass','StrMPoleSymplectic4Pass'});
% ring = set_num_integ_steps(ring);
% twi = calctwiss(ring);
% [DT,S,Q] = lnls_calc_drive_terms(ring,twi);
% Dt    = [];
% indcs = [];
% if isfield(S,drt), Dt = [Dt,S.(drt)];indcs = [indcs,S.indcs];end
% if isfield(Q,drt), Dt = [Dt,Q.(drt)];indcs = [indcs,Q.indcs];end
% 
% figure; ax = axes; hold(ax,'all');
% len = length(fams);
% for i=1:len
%     fam  = fams{i};
%     ind  = findcells(ring,'FamName',fam);
%     ind2 = ismember(indcs,ind);
%     dr   = sum(Dt(ind2));
%     plot_arrow(dr,[i/len,0,(len-i)/len],fam);
% end


% function plot_arrow(ax,x,c,name,lsty)
% 
% phi = angle(x);
% A   = abs(x);
% 
% %Define Arrow.
% x=A*[0, 1, 1-0.1, 1, 1-0.1]';
% y=A*[0, 0, 0.1, 0, -0.1]';
% %Rotate Arrow.
% x1=x*cos(phi)-y*sin(phi);
% y1=x*sin(phi)+y*cos(phi);
% %Plot Arrow.
% plot(ax,x1,y1,'Color',c,'LineWidth',2,'DisplayName',name,'LineStyle',lsty)


