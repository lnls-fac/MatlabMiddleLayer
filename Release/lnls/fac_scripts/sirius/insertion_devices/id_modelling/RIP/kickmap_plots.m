function kickmap_plots(IDKickMap)

% Perfil longitudinal 
posy = linspace(0, IDKickMap.id_def.period, IDKickMap.kickmaps.nr_pts_period);
posx = zeros(size(posy));
posz = zeros(size(posy));
pos  = [posx; posy; posz];
field = epu_field(IDKickMap.id_model, pos);
[maxv idx] = max(field(3,:));
posy_max = posy(idx);
h = figure; figure(h); plot(posy, field(3,:)); xlabel('Pos Z [mm]'); ylabel('B_y [T]'); set(h, 'Name', [IDKickMap.id_def.id_label '_Longitudinal By Profile']); drawnow; pause(0.1); 

% Perfil Transversal
posx = linspace(0,2*IDKickMap.id_def.block_width,50);
posy = posy_max * ones(size(posx));
posz = zeros(size(posx));
pos  = [posx; posy; posz];
field = epu_field(IDKickMap.id_model, pos);
h = figure; figure(h); plot(posx, field(3,:)); xlabel('Pos X [mm]'); ylabel('B_y [T]'); set(h, 'Name', [IDKickMap.id_def.id_label '_Radial Rolloff of By']); drawnow; pause(0.1); 

if ~isfield(IDKickMap.kickmaps, 'kickx'), return; end;


posx = IDKickMap.kickmaps.posx;
posz = IDKickMap.kickmaps.posy;
dmux = IDKickMap.ebeam_dtune.dmux;
dmuz = IDKickMap.ebeam_dtune.dmuy;

h = figure; hold all;
px = linspace(posx(1),posx(end),200);
xx = interp1(posx, dmux((end+1)/2,:), px, 'spline');
xz = interp1(posx, dmuz((end+1)/2,:), px, 'spline');
pz = linspace(posz(1),posz(end),200);
zx = interp1(posz, dmux(:,(end+1)/2), pz, 'spline');
zz = interp1(posz, dmuz(:,(end+1)/2), pz, 'spline');
plot(px, xx, 'b:');
plot(pz, zx, 'b-');
plot(px, xz, 'r:');
plot(pz, zz, 'r-');
xlabel('Pos [mm]');
ylabel('dTune');
legend({'dtunex(x)','dtunex(y)','dtuney(x)','dtuney(y)'});
set(h, 'Name', [IDKickMap.id_def.id_label '_dTune']); drawnow; pause(0.1); 


h = figure; hold all;
[gx,gz] = meshgrid(posx,posz);
limx = min([IDKickMap.ebeam_def.dynapt_sizex IDKickMap.kickmaps_def.kicktable_lim_sup_x]);
limz = min([IDKickMap.ebeam_def.dynapt_sizey IDKickMap.kickmaps_def.kicktable_lim_sup_y]);
px = linspace(0,limx,10);
pz = linspace(0,limz,10);
xmax = 0;
ymax = 0;
for i=1:length(pz)
    ux = linspace(px(1),px(end),300);
    uy = pz(i) * ones(size(ux));
    x = interp2(gx,gz,dmux, ux, uy, 'spline*');
    y = interp2(gx,gz,dmuz, ux, uy, 'spline*');
    plot(x,y,'r');
    xmax = max([xmax max(abs(x))]);
    ymax = max([ymax max(abs(y))]);
end
for i=1:length(px)
    uy = linspace(pz(1),pz(end),300);
    ux = px(i) * ones(size(uy));
    x = interp2(gx,gz,dmux, ux, uy, 'spline*');
    y = interp2(gx,gz,dmuz, ux, uy, 'spline*');
    plot(x,y,'b');
    xmax = max([xmax max(abs(x))]);
    ymax = max([ymax max(abs(y))]);
end
scatter(dmux((end+1)/2,(end+1)/2), dmuz((end+1)/2,(end+1)/2), 35, [0 0 0], 'filled');
%plot([-xmax xmax], [0 0], 'k');
%plot([0 0], [-ymax ymax], 'k');
xlabel('dTuneX');
ylabel('dTuneY');
set(h, 'Name', [IDKickMap.id_def.id_label '_dTuneDiagram']); drawnow; pause(0.1); 