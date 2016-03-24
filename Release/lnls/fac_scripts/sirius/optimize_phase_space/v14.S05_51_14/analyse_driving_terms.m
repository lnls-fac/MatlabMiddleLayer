function analyse_driving_terms(ring, drts)

ring = lnls_refine_lattice(ring,0.03,{'BndMPoleSymplectic4Pass','StrMPoleSymplectic4Pass'});
ring = set_num_integ_steps(ring);
twi  = calctwiss(ring);
% twi.mux = twi.mux*(2*pi*49.2)/(twi.mux(end)*5);
DT   = lnls_calc_drive_terms(ring,twi);


figure; ax = axes; hold(ax,'all');
len = length(drts);
lsty = {'-','--',':','-.'};
for i=1:len
    fact = 1;
    drt = drts{i};
    if any(strcmpi(drt(end),{'1','2'})), fact = 1;end
    plot_arrow(ax,DT.(drt)*fact,[i/len,0,(len-i)/len],drt,lsty{1+mod(i-1,length(lsty))});
end
legend(ax,'show','Location','best');



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


function plot_arrow(ax,x,c,name,lsty)

phi = angle(x);
A   = abs(x);

%Define Arrow.
x=A*[0, 1, 1-0.1, 1, 1-0.1]';
y=A*[0, 0, 0.1, 0, -0.1]';
%Rotate Arrow.
x1=x*cos(phi)-y*sin(phi);
y1=x*sin(phi)+y*cos(phi);
%Plot Arrow.
plot(ax,x1,y1,'Color',c,'LineWidth',2,'DisplayName',name,'LineStyle',lsty)


