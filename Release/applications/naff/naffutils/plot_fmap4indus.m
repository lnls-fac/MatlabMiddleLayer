function plot_fmap4indus(file)
%  PLOT_FMAP - Plots frequency map
%  plot_fmap('fmap.out')
%
%  INPUTS
%  1. file - filename for plotting frequency maps (output file from Tracy
%  II)
%
%  See also naffgui, plot_fmapdp

% Written by Laurent S. Nadolski, SOLEIL, 03/04
% Modifications for R14 compatibility, June'05

%% grille par defaut
set(0,'DefaultAxesXgrid','on');
set(0,'DefaultAxesZgrid','on');

if nargin <1
  help (mfilename)
  file ='fmap.out';
end

try
    [header data] = hdrload(file);
catch
    error('Error while opening filename %s ',file)
end

%% dimensions en mm
x = data(:,1)*1e3;
z = data(:,2)*1e3;
%% ajoute partie entiere
fx = 9 + abs(data(:,3));
fz = 6 + abs(data(:,4));

%% cas si diffusion
if size(data,2) == 6
    diffusion = 1;
    dfx = data(:,5);
    dfz = data(:,6);
else
    clear data
    diffusion = 0
end

% select stable particles
indx=(fx~=18.0);

%%% carte en frequence N&B
figure; 
subplot(2,1,1)
plot(fx,fz,'.','MarkerSize',0.5); hold on;
xlabel('\nu_x', 'interpreter', 'Tex'); ylabel('\nu_z', 'interpreter', 'Tex')
%axis([18.10 18.30 10.60 10.80])

subplot(2,1,2)
plot(x(indx),z(indx),'.','MarkerSize',0.5); hold on
xlabel('x(mm)'); ylabel('z(mm)');

pwd0 = pwd;
[pathName DirName] = fileparts (pwd0);
addlabel(0,0, DirName);

% Get Matlab version
v = ver('matlab');

%% cas diffusion
if diffusion    
    figure;  clf
    xgrid = [];  dfxgrid = []; fxgrid = []; 
    zgrid = [];  dfzgrid = []; fzgrid = [];
    
    %% calcul automayique la taille des donnees
    nz = sum(x==x(1));
    nx = size(x,1)/nz;
    
    xgrid = reshape(x,nz,nx);
    zgrid = reshape(z,nz,nx);
    fxgrid = reshape(fx,nz,nx);
    fzgrid = reshape(fz,nz,nx);
    dfxgrid = reshape(dfx,nz,nx);
    dfzgrid = reshape(dfz,nz,nx);
    
    %% Diffusion computation and get rid of log of zero
    temp = sqrt(dfxgrid.*dfxgrid+dfzgrid.*dfzgrid);
    nonzero = (temp ~= 0);
    diffu = NaN*ones(size(temp));
    diffu(nonzero) = log10(temp(nonzero));
    clear nonzero temp;
    diffumax = -2; diffumin = -10;
    diffu(diffu< diffumin) = diffumin; % very stable
    diffu(diffu> diffumax) = diffumax; %chaotic

    h1=subplot(2,1,1);
    %% frequency map   
    if strcmp(v.Release,'(R13SP1)')  
        h=mesh(fxgrid,fzgrid,diffu,'LineStyle','.','MarkerSize',5.0,'FaceColor','none');
    else % For Release R14 and later
        h=mesh(fxgrid,fzgrid,diffu,'Marker','.','MarkerSize',5.0,'FaceColor','none','LineStyle','none');
    end
    
    caxis([-10 -2]); % Echelle absolue
    view(2); hold on;
    axis([9.28 9.33 6.12 6.15])
    %axis([18.195 18.27 10.26 10.32])
    %axis([18.195 18.22 10.28 10.32]) % modif mat oct 09 0.2 0.3
    %axis([18.15 18.22 10.28 10.36]) % modif mat oct 09 0.202 0.317
    shading flat
    xlabel('\nu_x', 'interpreter', 'Tex');  ylabel('\nu_z', 'interpreter', 'Tex');
    %% colorbar position
    
    h2=subplot(2,1,2);
    %% dynamic aperture
    pcolor(xgrid,zgrid,diffu); hold on;
    if xgrid(end) > 0
        xaxis([0 25])
    else
        xaxis([-25 0])
    end
    caxis([-10 -2]); % Echelle absolue
    shading flat;
    xlabel('x(mm)'); ylabel('z(mm)');
    
    
    %% colorbar position
    hp=colorbar('location', 'EastOutside');
    p1 = get(h1,'position'); p2 = get(h2,'position'); p0 = get(hp,'position');
    set(hp,'position',[p1(1) + 1.03*p1(3) p0(2)  0.03 p1(4)*2.4]);
    pwd0 = pwd;
    [pathName DirName] = fileparts (pwd0); 
    addlabel(0,0, DirName);
end
