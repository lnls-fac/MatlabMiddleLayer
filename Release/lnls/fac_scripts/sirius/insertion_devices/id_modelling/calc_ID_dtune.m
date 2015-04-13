function calc_ID_dtune(id_mat_file_name, ebeam_def)



% cleanup
clc; fclose('all'); close('all');


% reads data from ID model mat file
%id_mat_file_name = fullfile('EPU50', 'EPU50_PH - KICKTABLES.mat');
if ~exist('id_mat_file_name','var')
    [FileName,PathName,~] = uigetfile('*.mat','Select mat file with ID model','');
    id_mat_file_name = fullfile(PathName,FileName);
end
r = load(id_mat_file_name, 'ID'); ID = r.ID;
if ~exist('ebeam_def')
    ebeam_def.energy = 3; % [GeV]
    ebeam_def.betax = 16.5; % [m] - % AC20_2 / mia
    ebeam_def.betay = 3.9;  % [m] - % AC20_2 / mia
    %ebeam_def.betax = 16.5; % [m] - % AC20_2 / mib
    %ebeam_def.betay = 3.9;  % [m] - % AC20_2 / mib
end

% turns diary mode on
diary off;
diary_fname = [ID.def.id_label ' - DTUNE-SUMMARY.txt'];
if exist(diary_fname, 'file'), delete(diary_fname); end;
diary(diary_fname);

fprintf('ID    : %s\n', ID.def.id_label);
fprintf('Energy: %5.2f GeV\n', ebeam_def.energy);
fprintf('BetaX : %5.2f m\n',   ebeam_def.betax);
fprintf('BetaY : %5.2f m\n',   ebeam_def.betay);
mm_2_m = 1e-3;

posx = ID.kicktables.posx;
posy = ID.kicktables.posy;

[eb_beta eb_gamma eb_brho] = lnls_beta_gamma(ebeam_def.energy);

[dkickx_dx dkickx_dy] = calc_derivatives(ID.kicktables.kickx, mm_2_m * posx, mm_2_m * posy);
[dkicky_dx dkicky_dy] = calc_derivatives(ID.kicktables.kicky, mm_2_m * posx, mm_2_m * posy);
KxL = -dkickx_dx / eb_brho^2;
KyL = -dkicky_dy / eb_brho^2;
id_length = ID.def.period * ID.def.nr_periods / 1000; % mm -> m
dmux = KxL * ebeam_def.betax * (1 + id_length^2/12/ebeam_def.betax^2) / 4 / pi;
dmuy = KyL * ebeam_def.betay * (1 + id_length^2/12/ebeam_def.betay^2) / 4 / pi;

x = linspace(min(posx),max(posx),500);
y = interp1(posx, dmux((end+1)/2,:), x, 'spline');
figure; set(gcf, 'Name', 'DTUNE-X_PosX'); plot(x, y); 
xlabel('Pos X [mm]');
ylabel('dTuneX @ y = 0 mm');

x = linspace(min(posx),max(posx),500);
y = interp1(posx, dmuy((end+1)/2,:), x, 'spline');
figure; set(gcf, 'Name', 'DTUNE-Y_PosX'); plot(x, y);
xlabel('Pos X [mm]');
ylabel('dTuneY @ y = 0 mm');

x = linspace(min(posy),max(posy),500);
y = interp1(posy, dmux(:,(end+1)/2), x, 'spline');
figure; set(gcf, 'Name', 'DTUNE-X_PosY'); plot(x, y); 
xlabel('Pos Y [mm]');
ylabel('dTuneX @ x = 0 mm');

x = linspace(min(posy),max(posy),500);
y = interp1(posy, dmuy(:,(end+1)/2), x, 'spline');
figure; set(gcf, 'Name', 'DTUNE-Y_PosY'); plot(x, y); 
xlabel('Pos Y [mm]');
ylabel('dTuneY @ x = 0 mm');

fprintf('dtunex: %+9.6f\n', dmux((end+1)/2, (end+1)/2));
fprintf('dtuney: %+9.6f\n', dmuy((end+1)/2, (end+1)/2));

ID.ebeam_dtune.KxL = KxL;
ID.ebeam_dtune.KyL = KyL;
ID.ebeam_dtune.dmux = dmux;
ID.ebeam_dtune.dmuy = dmuy;
ID.ebeam_dtune.ebeam_def = ebeam_def;

% saves kicktable
save([ID.def.id_label ' - DTUNE.mat'], 'ID');

% saves plots to file
save_plots(ID.def.id_label);

% finalizations
diary off;


function save_plots(label)

% grava figuras
hds = get(0, 'Children');
for i=1:length(hds);
    name = get(hds(i), 'Name');
    if isempty(name), name = ['Fig ' num2str(hds(i))]; end;
    saveas(hds(i), [label ' - ' name '.fig']);
end



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