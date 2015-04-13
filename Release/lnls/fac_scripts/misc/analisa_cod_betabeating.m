function analisa_cod_betabeating(varargin)

% % path = '/home/fac_files/data/sirius_tracy/sr/calcs/v500/ac10.5/possible_change/low_2chrom-res374_126_000629/multi.cod.tune.symm.coup.physap/cod_matlab';
% path = '/home/fac_files/data/sirius_tracy/sr/oficial/v500/ac10.5/multi.cod.tune.symm.coup.physap/cod_matlab';
% name = 'CONFIG';
% % data = load(fullfile(path,  [name '_machines_cod_corrected'])); machines = data.machine;
% % the_ring0 = load(fullfile(path,  [name '_the_ring'])); the_ring0 = the_ring0.the_ring;
% data = load(fullfile(path,name)); data = data.r;
% machines = data.machine;
% the_ring0 = data.params.the_ring;
% 
% 
% cod4d = zeros(4,length(machines{1}),length(machines));
% spos = findspos(machines{1},1:length(machines{1}));
% 
% sext_fam = {'sa1','sa2','sb1','sb2','sd1','sd2','sd3','sf1','sf2','bce','bcs'};
% ind_sex = [];
% for ii=1:length(sext_fam)
%     ind_sex = [ind_sex findcells(machines{1},'FamName',sext_fam{ii})];
% end
% ind_sex = sort(ind_sex);
% 
% twiss0 = calctwiss(the_ring0);
% for ii=1:length(machines)
%     the_ring = machines{ii};
%     cod4d(:,:,ii) = findorbit4(the_ring,0,1:length(the_ring));
%     twiss_on(ii) = calctwiss(the_ring);
%     the_ring = setcellstruct(the_ring,'PolynomB',ind_sex,0,1,3);
%     twiss_off(ii) = calctwiss(the_ring);
% end
% 
% figure; h_on = axes; hold(h_on,'on');
% figure; h_off = axes; hold(h_off,'on');
% figure; h_cod = axes; hold(h_cod,'on');
% for i=1:length(machines)
%     betax_on_diff(i,:) = 100*(abs(twiss_on(i).betax - twiss0.betax))./twiss0.betax;
%     betay_on_diff(i,:) = 100*(abs(twiss_on(i).betay - twiss0.betay))./twiss0.betay;
%     betax_off_diff(i,:) = 100*(abs(twiss_off(i).betax - twiss0.betax))./twiss0.betax;
%     betay_off_diff(i,:) = 100*(abs(twiss_off(i).betay - twiss0.betay))./twiss0.betay;
%     data = betax_on_diff(i,:);
%     plot(h_on,twiss_on(i).pos, data, 'Color', [0.7 0.7 1.0]);
%     data = betay_on_diff(i,:);
%     plot(h_on,twiss_off(i).pos, -data, 'Color', [1.0 0.7 0.7]);
%     plot(h_cod,twiss_off(i).pos,-abs(1e6*cod4d(3,:,i)), 'Color', [1.0 0.7 0.7]);
%     plot(h_cod,twiss_off(i).pos, abs(1e6*cod4d(1,:,i)), 'Color', [0.7 0.7 1.0]);
%     data = betax_off_diff(i,:);
%     plot(h_off,twiss_off(i).pos, data, 'Color', [0.7 0.7 1.0]);
%     data = betay_off_diff(i,:);
%     plot(h_off,twiss_off(i).pos, -data, 'Color', [1.0 0.7 0.7]);
% end
% plot(h_on,  twiss0.pos,  std(betax_on_diff), 'Color', [0 0 1.0], 'LineWidth', 2.5);
% plot(h_off, twiss0.pos,  std(betax_off_diff), 'Color', [0 0 1.0], 'LineWidth', 2.5);
% plot(h_on,  twiss0.pos, -std(betay_on_diff), 'Color', [1.0 0 0], 'LineWidth', 2.5);
% plot(h_off, twiss0.pos, -std(betay_off_diff), 'Color', [1.0 0 0], 'LineWidth', 2.5);
% 
% xlabel(h_on,'Pos [m]');
% ylabel(h_on,'\delta\beta [%%]');
% xlabel(h_off,'Pos [m]');
% ylabel(h_off,'\delta\beta [%%]');
% title(h_on,'Sextupoles ON');
% title(h_off,'Sextupoles OFF');
% 
% codx_4d_sex = std(1e6*cod4d(1,:,:),0,3);
% cody_4d_sex = -std(1e6*cod4d(3,:,:),0,3);
% 
% plot(h_cod, spos, [codx_4d_sex; cody_4d_sex]);


% path = '/home/fac_files/data/sirius_tracy/sr/calcs/v500/ac10.5/possible_change/low_2chrom-res374_126_000629/multi.cod.tune.symm.coup.physap/cod_matlab';
path = '/home/fac_files/data/sirius_tracy/sr/oficial/v500/ac10.5/multi.cod.tune.symm.coup.physap/cod_matlab';
name = 'CONFIG';
data = load(fullfile(path,  [name '_machines_cod_corrected'])); machine_cod = data.machine;
data = load(fullfile(path,  [name '_machines_cod_symm_corrected'])); machine_cod_symm = data.machine;
the_ring0 = load(fullfile(path,name)); 
the_ring0 = the_ring0.r.params.the_ring;


twiss0 = calctwiss(the_ring0);
for ii=1:length(machine_cod)
    twiss_cod(ii) = calctwiss(machine_cod{ii});
    twiss_cod_symm(ii) = calctwiss(machine_cod_symm{ii});
end

figure; h_cod = axes; hold(h_cod,'on');
figure; h_cod_symm = axes; hold(h_cod_symm,'on');
for i=1:length(machine_cod)
    betax_on_diff(i,:) = 100*(abs(twiss_cod(i).betax - twiss0.betax))./twiss0.betax;
    betay_on_diff(i,:) = 100*(abs(twiss_cod(i).betay - twiss0.betay))./twiss0.betay;
    betax_off_diff(i,:) = 100*(abs(twiss_cod_symm(i).betax - twiss0.betax))./twiss0.betax;
    betay_off_diff(i,:) = 100*(abs(twiss_cod_symm(i).betay - twiss0.betay))./twiss0.betay;
    data = betax_on_diff(i,:);
    plot(h_cod,twiss_cod(i).pos, data, 'Color', [0.7 0.7 1.0]);
    data = betay_on_diff(i,:);
    plot(h_cod,twiss_cod_symm(i).pos, -data, 'Color', [1.0 0.7 0.7]);
    data = betax_off_diff(i,:);
    plot(h_cod_symm,twiss_cod_symm(i).pos, data, 'Color', [0.7 0.7 1.0]);
    data = betay_off_diff(i,:);
    plot(h_cod_symm,twiss_cod_symm(i).pos, -data, 'Color', [1.0 0.7 0.7]);
end
plot(h_cod,  twiss0.pos,  std(betax_on_diff), 'Color', [0 0 1.0], 'LineWidth', 2.5);
plot(h_cod_symm, twiss0.pos,  std(betax_off_diff), 'Color', [0 0 1.0], 'LineWidth', 2.5);
plot(h_cod,  twiss0.pos, -std(betay_on_diff), 'Color', [1.0 0 0], 'LineWidth', 2.5);
plot(h_cod_symm, twiss0.pos, -std(betay_off_diff), 'Color', [1.0 0 0], 'LineWidth', 2.5);

xlabel(h_cod,'Pos [m]');
ylabel(h_cod,'\delta\beta [%%]');
xlabel(h_cod_symm,'Pos [m]');
ylabel(h_cod_symm,'\delta\beta [%%]');
title(h_cod,'Before symmetrization');
title(h_cod_symm,'After symmetrization');


