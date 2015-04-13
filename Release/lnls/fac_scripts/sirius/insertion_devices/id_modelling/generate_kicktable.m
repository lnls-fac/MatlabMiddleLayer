function ID = generate_kicktable(id_mat_file_name)

% cleanup
clc; fclose('all'); close('all');
addpath('epu');

% reads data from ID model mat file
%id_mat_file_name = fullfile('EPU50', 'EPU50_PC - ID.mat');
%id_mat_file_name = fullfile('EPU80','EPU80_PH - ID.mat');
%id_mat_file_name = fullfile('U25','U25 - ID.mat');
%id_mat_file_name = fullfile('U19','U19 - ID.mat');
id_mat_file_name = fullfile('EPU80','EPU80_PV - ID.mat');

if ~exist('id_mat_file_name','var')
    [FileName,PathName,~] = uigetfile('*.mat','Select mat file with ID model','');
    id_mat_file_name = fullfile(PathName,FileName);
end
r = load(id_mat_file_name, 'ID'); ID = r.ID;

% defines grid for kicktable calculation (mm units)
kicktable_grid.symmetric = true; % reflection symmetry on x and y axis (only 1/4 of initial points are calculated)
kicktable_grid.x = 30 * linspace(-1,1,81); 
kicktable_grid.y = (ID.def.physical_gap/2) * linspace(-1,1,17);
%kicktable_grid.x = 30 * linspace(-1,1,3); 
%kicktable_grid.y = (ID.def.physical_gap/2) * linspace(-1,1,3);

% calcs kicktable
ID.kicktables = calc_kicktables(ID.def, ID.model, ID.field, kicktable_grid);

% generates kicktable file
save_kicktables(ID.def, ID.kicktables);

% saves kicktable
save([ID.def.id_label ' - KICKTABLES.mat'], 'ID');

% saves plots to file
save_plots(ID.def.id_label);



function save_plots(label)

% grava figuras
hds = get(0, 'Children');
for i=1:length(hds);
    name = get(hds(i), 'Name');
    if isempty(name), name = ['Fig ' num2str(hds(i))]; end;
    saveas(hds(i), [label ' - ' name '.fig']);
end


function kicktables = calc_kicktables(id_def, id_model, id_field, grid)

mm = 1;



% parametros de calculo de U em cada linha (x,y)
if false
    % calcula o menor numero de pontos em um periodo para que erro < 1% em todo grid (x,y).
    kickmaps.nr_pts_period = calc_nrpts(kickmap, kickmap.id_summary.max_by_pos);
else
    kickmaps.nr_pts_period = 65;
end
y1    = id_field.on_axis_by_max_abs_z;
y2    = y1 + id_def.period;
posx = grid.x;
posy = grid.y;

lnls_create_waitbar('Construindo Funcao Potencial', 0.2, length(posy) * length(posx));
U = zeros(length(posy), length(posx));
counter = 0;
figure; set(gcf, 'Name', 'KICKTABLES-PotU');
plot_flag = false;
for i=1:length(posy)
    for j=1:length(posx)
        if ~grid.symmetric || ((posx(j) >= 0) && (posy(i) >= 0))
            U(i,j) = calc_U(posx(j), posy(i), y1, y2, kickmaps.nr_pts_period, id_model);
            plot_flag = true;
        end
        if grid.symmetric
            U = symmetrize_U_function(U);
        end
        if plot_flag
            plot_U_function(posx, posy, U);
            drawnow;
        end;
        counter = counter + 1;
        lnls_update_waitbar(counter);
    end
end

% interpola tabela de kicks (normalizada pelo quadrado da rigidez magn�tica)
[kickx kicky] = calc_derivatives(-0.5 * id_def.nr_periods * U, posx, posy);
mm_2_m = 1e-3;
kickx = mm_2_m^2 * kickx;
kicky = mm_2_m^2 * kicky;

% plots kicktables
figure; set(gcf, 'Name', 'KICKTABLES-KickX_vs_X'); plot(posx, (1e6/100.0) * kickx');
leg = {};
for i=1:length(posy)
    leg = [leg num2str(posy(i), 'y = %+7.3f mm')];
end
legend(leg);
xlabel('PosX [mm]');
ylabel('X Kick @ 3 GeV [urad]');

figure; set(gcf, 'Name', 'KICKTABLES-KickY_vs_X'); plot(posx, (1e6/100.0) * kicky');
leg = {};
for i=1:length(posy)
    leg = [leg num2str(posy(i), 'y = %+7.3f mm')];
end
legend(leg);
xlabel('PosX [mm]');
ylabel('Y Kick @ 3 GeV [urad]');

figure; set(gcf, 'Name', 'KICKTABLES-KickX_vs_Y'); plot(posy, (1e6/100.0) * kickx');
leg = {};
for i=1:length(posx)
    leg = [leg num2str(posx(i), 'x = %+7.3f mm')];
end
legend(leg);
xlabel('PosY [mm]');
ylabel('X Kick @ 3 GeV [urad]');

figure; set(gcf, 'Name', 'KICKTABLES-KickY_vs_Y'); plot(posy, (1e6/100.0) * kicky');
leg = {};
for i=1:length(posx)
    leg = [leg num2str(posx(i), 'x = %+7.3f mm')];
end
legend(leg);
xlabel('PosY [mm]');
ylabel('Y Kick @ 3 GeV [urad]');

%figure; set(gcf, 'Name', 'KICKTABLES-KickX'); plot_U_function(posx, posy, kickx); title('KickX [T^2.m^2]');
%figure; set(gcf, 'Name', 'KICKTABLES-KickY'); plot_U_function(posx, posy, kicky); title('KickY [T^2.m^2]');

kicktables.posx = posx;
kicktables.posy = posy;
kicktables.U = U;
kicktables.kickx = kickx;
kicktables.kicky = kicky;

function plot_U_function(posx, posy, U)

[X,Y] = meshgrid(posx, posy);
[C,h] = contourf(X,Y,U,16);
colorbar;
xlabel('Pos X [mm]');
ylabel('Pos Y [mm]');
title('Kick Potential U [T^2.mm^3]');
return

set(h,'ShowText','on','TextStep',get(h,'LevelStep')*2)
[X,Y] = meshgrid(posx, posy);
[C,h] = contour(X,Y,U);
set(h,'ShowText','on','TextStep',get(h,'LevelStep')*2)
% handle=clabel(C,h,'fontsize',12);
% for a=1:length(handle)
%     s = get(handle(a),'String'); % get string
%     s = str2num(s); % convert in to number
%     s = sprintf('%4.0f',s); % format as you need
%     set(handle(a),'String',s); % place it back in the figure
% end

colormap cool
xlabel('Pos X [mm]');
ylabel('Pos Y [mm]');
title('Kick Potential U [T^2.mm^3]');

function U = symmetrize_U_function(U0)

U_dr = U0((end+1)/2:end,(end+1)/2:end);
U_dl = fliplr(U_dr(:,2:end));
U_d  = [U_dl U_dr];
U_u  = flipud(U_d(2:end,:));
Ut   = [U_u; U_d];
U = Ut;
     
function U = calc_U(x,y,z1,z2,npts,model)

posy1 = linspace(z1,z2,npts);
posy = posy1;
pos  = zeros(3,length(posy));
pos(1,:) = x;
pos(2,:) = posy; 
pos(3,:) = y;
field = epu_field(model, pos); 
bx1 = field(1,:);
b = 0.5*(bx1(1:end-1) + bx1(2:end));
ibx1 = [0 cumsum(b)] * (posy(2) - posy(1));
by1 = field(3,:);
b = 0.5*(by1(1:end-1) + by1(2:end));
iby1 = [0 cumsum(b)] * (posy(2) - posy(1));
phi  = (ibx1.^2 + iby1.^2);
U = sum(0.5 * (phi(1:end-1) + phi(2:end)) .* diff(posy));

function [dfdx dfdz] = calc_derivatives(f, posx, posz)

dfdx = zeros(length(posz), length(posx));
for i=1:length(posz)
    x = posx;
    y = f(i,:);
    xp = x + [0.2*diff(x) 0];
    xn = x - [0 0.2*diff(x)];
    fp = interp1(x, y, xp, 'cubic');
    fn = interp1(x, y, xn, 'cubic');
    dx = xp - xn;
    dfdx(i,:) = (fp - fn) ./ dx;
end

dfdz  = zeros(length(posz), length(posx));
for i=1:length(posx)
    x = posz;
    y = f(:,i)';
    xp = x + [0.2*diff(x) 0];
    xn = x - [0 0.2*diff(x)];
    fp = interp1(x, y, xp, 'cubic');
    fn = interp1(x, y, xn, 'cubic');
    dx = xp - xn;
    dfdz(:,i) = ((fp - fn) ./ dx)';
end

function save_kicktables(id_def, kickmaps)

dpsi_dx = kickmaps.kickx;
dpsi_dy = kickmaps.kicky;
posx    = kickmaps.posx;
posy    = kickmaps.posy;

sep_char = ' ';
% gera arquivo com mapa de kicks
fp = fopen([id_def.id_label '_kicktable.txt'], 'w');
fprintf(fp, ['# ' id_def.id_label ' KICKMAP \r\n']);
fprintf(fp, ['# Author: Ximenes R. Resende @ LNLS, Date: ' datestr(now) '\r\n']);
fprintf(fp,  '# ID Length [m]\r\n');
fprintf(fp,  '%6.4f\r\n', id_def.period * id_def.nr_periods / 1000);
fprintf(fp,  '# Number of Horizontal Points\r\n');
fprintf(fp,  '%i \r\n', size(dpsi_dx,2));
fprintf(fp,  '# Number of Vertical Points\r\n');
fprintf(fp,  '%i \r\n', size(dpsi_dx,1));

fprintf(fp,  '# Horizontal KickTable in T2m2\r\n');
fprintf(fp,  'START\r\n');
fprintf(fp, '%11s', ''); fprintf(fp, sep_char);
for i=1:length(posx)
    fprintf(fp, '%+11.8f', posx(i)/1000); fprintf(fp, sep_char);
end
fprintf(fp, '\r\n');
for i=length(posy):-1:1
    fprintf(fp, '%+11.8f', posy(i)/1000); fprintf(fp, sep_char);
    for j=1:length(posx)
        fprintf(fp, '%+6.3E', dpsi_dx(i,j)); fprintf(fp, sep_char);
    end
    fprintf(fp, '\r\n');
end

fprintf(fp,  '# Vertical KickTable in T2m2\r\n');
fprintf(fp,  'START\r\n');
fprintf(fp, '%11s', ''); fprintf(fp, sep_char);
for i=1:length(posx)
    fprintf(fp, '%+11.8f', posx(i)/1000); fprintf(fp, sep_char);
end
fprintf(fp, '\r\n');
for i=length(posy):-1:1
    fprintf(fp, '%+11.8f', posy(i)/1000); fprintf(fp, sep_char);
    for j=1:length(posx)
        fprintf(fp, '%+6.3E', dpsi_dy(i,j)); fprintf(fp, sep_char);
    end
    fprintf(fp, '\r\n');
end

fclose(fp);

function nr_pts = calc_nrpts(kickmap, max_by_pos)

params = kickmap.Params;

level = 0.01;
npts  = 17;
z1    = max_by_pos;
z2    = max_by_pos + params.period;

x    = 0;
y    = 0;
iphi1 = calc_iphi(x,y,z1,z2,npts,kickmap);
fprintf('%i %f\n', npts, iphi1);
not_converged = true;
while not_converged
    npts = 2*(npts - 1) + 1;
    iphi2 = calc_iphi(x,y,z1,z2,2*(npts-1)+1,kickmap);
    if (abs(iphi2-iphi1)/iphi1 < level), not_converged = false; end
    iphi1 = iphi2;
    %fprintf('%i %f\n', npts, iphi1);
end
npts = (npts - 1)/2 + 1;


x    = max(abs([params.kicktable_lim_sup_x params.kicktable_lim_inf_x]));
y    = 0;
iphi1 = calc_iphi(x,y,z1,z2,npts,kickmap);
fprintf('%i %f\n', npts, iphi1);
not_converged = true;
while not_converged
    npts = 2*(npts - 1) + 1;
    iphi2 = calc_iphi(x,y,z1,z2,2*(npts-1)+1,kickmap);
    if (abs(iphi2-iphi1)/iphi1 < level), not_converged = false; end
    iphi1 = iphi2;
    fprintf('%i %f\n', npts, iphi1);
end
npts = (npts - 1)/2 + 1;

x    = max(abs([params.kicktable_lim_sup_x params.kicktable_lim_inf_x]));
y    = max(abs([params.kicktable_lim_sup_z params.kicktable_lim_inf_z]));
iphi1 = calc_iphi(x,y,z1,z2,npts,kickmap);
fprintf('%i %f\n', npts, iphi1);
not_converged = true;
while not_converged
    npts = 2*(npts - 1) + 1;
    iphi2 = calc_iphi(x,y,z1,z2,2*(npts-1)+1,kickmap);
    if (abs(iphi2-iphi1)/iphi1 < level), not_converged = false; end
    iphi1 = iphi2;
    %fprintf('%i %f\n', npts, iphi1);
end
npts = (npts - 1)/2 + 1;

x    = 0;
y    = max(abs([params.kicktable_lim_sup_z params.kicktable_lim_inf_z]));
iphi1 = calc_iphi(x,y,z1,z2,npts,kickmap);
fprintf('%i %f\n', npts, iphi1);
not_converged = true;
while not_converged
    npts = 2*(npts - 1) + 1;
    iphi2 = calc_iphi(x,y,z1,z2,2*(npts-1)+1,kickmap);
    if (abs(iphi2-iphi1)/iphi1 < level), not_converged = false; end
    iphi1 = iphi2;
    %fprintf('%i %f\n', npts, iphi1);
end
npts = (npts - 1)/2 + 1;

x    = max(abs([params.kicktable_lim_sup_x params.kicktable_lim_inf_x]))/2;
y    = max(abs([params.kicktable_lim_sup_z params.kicktable_lim_inf_z]))/2;
iphi1 = calc_iphi(x,y,z1,z2,npts,kickmap);
fprintf('%i %f\n', npts, iphi1);
not_converged = true;
while not_converged
    npts = 2*(npts - 1) + 1;
    iphi2 = calc_iphi(x,y,z1,z2,2*(npts-1)+1,kickmap);
    if (abs(iphi2-iphi1)/iphi1 < level), not_converged = false; end
    iphi1 = iphi2;
    %fprintf('%i %f\n', npts, iphi1);
end
npts = (npts - 1)/2 + 1;

nr_pts = npts;
