function plot_fmapdp(file)
% Plot frequency map
% eg:
% plot_fmapdp('fmapdp.out')
%
% Laurent S. Nadolski, SOLEIL, 03/04

%% grille par defaut
set(0,'DefaultAxesXgrid','on');
set(0,'DefaultAxesYgrid','on');

if nargin <1
  help (mfilename)
  file ='fmapdp.out';
end

try
    [dp x fx fz dfx dfz] = textread(file,'%f %f %f %f %f %f','headerlines',3);
catch
    error('Error while opening filename %s',file)
end

%% ajoute parties entieres
fx=18+abs(fx);
fz=10+abs(fz);
%% energie en %
dp = dp*1e2;
%% position en mm
x = abs(x)*1e3;
            
% select stable particles
indx=(fx~=18.0);

%% carte N&B
figure(6); clf;
subplot(2,1,1)
plot(fx,fz,'.','MarkerSize',0.5)
xlabel('\nu_x'); ylabel('\nu_z')
%axis([18.15 18.27 10.265 10.32])

subplot(2,1,2)
plot(dp(indx),x(indx),'.','MarkerSize',0.5); hold on
plot([-6 6],[25 25],'r-.')
plot([-6 -6],[0 26],'k--')
plot([6 6],[0 26],'k--')
plot([4 4],[0 26],'k--')
ind_amplitude6D
xlabel('\delta (%)'); ylabel('x(mm)')
axis([-6.2 6.2 0 26])
%addlabel(0,0,datestr(now))
