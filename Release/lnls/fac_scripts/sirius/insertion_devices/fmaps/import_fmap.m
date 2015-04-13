function r = import_fmap(folder_name)

diffrange = [-10 -2];
nux0 = 24;
nuy0 = 13;


if ~exist('folder_name', 'var')
    folder_name = uigetdir('Selecione diretório com dados de tracking');
    %[FileName,PathName] = uigetfile('*.out','Select FMAP file');
    if ~ischar(folder_name), return; end;
    %file_name = fullfile(PathName, FileName);
else
    %file_name = fullfile(file_name, 'fmap.out');
end


% XY Dynamical Aperture
% ---------------------

data = importdata(fullfile(folder_name, 'fmap.out'), ' ', 3);
fmap = data.data;

x   = unique(fmap(:,1));
y   = unique(fmap(:,2));
nux  = reshape(fmap(:,3), length(y), []);
nuy  = reshape(fmap(:,4), length(y), []);
dnux = reshape(fmap(:,5), length(y), []);
dnuy = reshape(fmap(:,6), length(y), []);
dnu  = log10(sqrt(dnux.^2 + dnuy.^2));

figure;
[X,Y] = meshgrid(x,flipud(y));
surf(1000*X,1000*Y,dnu);
view([0 0 1]);
shading flat;
colorbar;
caxis(diffrange);
xlabel('PosX [mm]');
ylabel('PosY [mm]');
title('XY DA');

figure;
scatter(nux0 + nux(:), nuy0 + nuy(:), 10, dnu(:));
caxis(diffrange);

r.fmap = fmap;
r.x = X;
r.y = Y;
r.nux = nux;
r.nuy = nuy;
r.dnux = dnux;
r.dnuy = dnuy;
r.dnu = dnu;


% EX Dynamical Aperture
% ---------------------

data = importdata(fullfile(folder_name, 'fmapdp.out'), ' ', 3);
fmapdp = data.data;

%ordena os dados para pcolor funcionar corretamente.
[tmp, ind] = sort(fmapdp(:,2));
fmapdp = fmapdp(ind,:);
[tmp, ind] = sort(fmapdp(:,1));
fmapdp = fmapdp(ind,:);


e   = unique(fmapdp(:,1));
x   = unique(fmapdp(:,2));
nux  = reshape(fmapdp(:,3), length(x), []);
nuy  = reshape(fmapdp(:,4), length(x), []);
dnux = reshape(fmapdp(:,5), length(x), []);
dnuy = reshape(fmapdp(:,6), length(x), []);
dnu  = log10(sqrt(dnux.^2 + dnuy.^2));

figure;
[E,X] = meshgrid(e,flipud(x));
surf(100*E,1000*X,dnu);
view([0 0 1]);
shading flat;
colorbar;
caxis(diffrange);
xlabel('\delta\epsilon [mm]');
ylabel('PosX [mm]');
title('EX DA');

figure;
scatter(nux0 + nux(:), nuy0 + nuy(:), 10, dnu(:));
caxis(diffrange);

r.fmapdp = fmapdp;
