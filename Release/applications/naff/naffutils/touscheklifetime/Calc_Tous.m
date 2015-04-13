%function [Tous,Tousp,Tousn]=Calc_Tous(file,linlat,sigmas)
%Calc_Tous - Compute Touschek liftetime based on the energy acceptance
%computed by Tracy2
%
%  Integration method : Simpson (choix de BETA)
%  NB : A modifier si variation rapide de la duree de vie.
%
%  External function used: C(xi) standard function
%
%  INPUTS
%    file   : output format from tracy (soleil.out)
%    linlat : optics file (linlat.out)
%    sigmas : bunch length (m)
%
%  OUTPUTS
%    T(h)  : Total Touschek lifetime
%    Tp(h) : Touschek lifetime delta >0
%    Tn(h) : Touschek lifetime delta <0
%
%  Ajouter le choix du courant I0
%
%  Example
%[T, Tp, Tn]=Calc_Tous('soleil.out','linlat.out')

%
%% Written by Laurent S. Nadolski, SOLEIL 2003

function [Tous,Tousp,Tousn]=Calc_Tous(file,linlat,sigmas)

if nargin <1
    help Calc_Tous
    return;
end

% Lecture des fonction optiques
% name     s    alphax  betax   nux   etax   etapx  alphay  betay   nuy   etay   etapy
%         [m]            [m]           [m]                   [m]           [m]
try
    [dummy s ax bx mux etax etaxp az bz muz etaz etazp] = ...
        textread(linlat,'%s %f %f %f %f %f %f %f %f %f %f %f','headerlines',4);
catch
    errmsg = lasterr;
    if strfind(errmsg, 'File not found.');
        error('Input file %s not found \n Abort \n',linlat);
    else
        error('Unknown error %s \n', errmsg)
    end
end

ex = 2.0E-9;   %Emittance H
ez = ex*0.005;  %Emittance V
se = 1.016E-3; %Dispersion en energie
gx = (1+ax.^2)./bx; %Gammax

sx = sqrt(bx*ex+(se*etax).^2);  %Taille  H
sxp= sqrt(gx*ex+(se*etaxp).^2); %Divergence H
sz = sqrt(bz*ez+(se*etaz).^2);  %Taille V

[dummy sd acen lost nom] = textread(file,'%d %f %f %f %s','headerlines',3);
Nb_pts=length(sd)/2;
s=sd(1:Nb_pts);
acen_p=acen(1:Nb_pts); acen_n=acen(Nb_pts+1:end);


if nargin <3
    ss = 9.0E-3;  %sigma_s en mm
    fprintf('Default value for bunch length: sigma_s= %f m\n',ss)
else
    ss =sigmas;
end

V     = 8*pi*sqrt(pi).*sx.*sz.*ss; %Volume du paquet
E     = 2.739;        % Energy
Gamma = 5382.57324;    % Facteur de Lorentz
c     = 2.99792458E8;    % Vitesse de la lumiere
re    = 2.81794092E-15;  % Rayon classique de l'electron
I0    = 1.0E-3;      % Courant par paquet
Qe    = 1.6022E-19;  % Charge de l'electron
L     = 354.097;     % Circonference de l'anneau
N     = I0/c*L/Qe;   % Nombre d'electrons par paquet

% Duree de vie Touschek inverse

%Duree de vie locale positive et negative en heures
%xi_p=(acen_p./Gamma./sxp)^2;
%xi_n=(acen_n./Gamma./sxp)^2;
FF = sqrt(pi)*re*re*c*N*3600;
Tinvp = zeros(1,Nb_pts);
Tinvn = zeros(1,Nb_pts);

for i=1:Nb_pts, % loop because of Cxi function
    Tinvp(i) = (FF*Cxi((acen_p(i)/Gamma/sxp(i))^2)/sxp(i) ...
        /Gamma^3/acen_p(i)^2/V(i));
    Tinvn(i) = (FF*Cxi((acen_n(i)/Gamma/sxp(i))^2)/sxp(i) ...
        /Gamma^3/acen_n(i)^2/V(i));
end

% Duree de vie moyenne locale
Tinv = (Tinvp+Tinvn)/2;

Tp=1./Tinvp;
Tn=1./Tinvn;
T =1./Tinv;

% Integration : methode de Simpson
s1=[0 ; s]; s2=[s ; 0]; ds=s2-s1;
Tousp=1/sum(1./Tp.*ds(1:end-1)')*s(end);
Tousn=1/sum(1./Tn.*ds(1:end-1)')*s(end);

Tous=2/(1/Tousp+1/Tousn);

% lecture du fichier de structure
%struc=dlmread('structure');

figure(80)
subplot(2,1,1)
plot(s,Tp,'.-');
grid on
xlabel('s (m)')
ylabel('Tp (h)')

subplot(2,1,2)
plot(s,Tn,'.-');
grid on
xlabel('s (m)')
ylabel('Tn (h)')


% lecture du fichier de structure

files=fullfile(fileparts(which('naffgui')),'structure');
struc=dlmread(files);

% symetrie artificielle
acen=acen*100;
%%
figure(81)
clf
%plot([sd(1:Nb_pts); 2*sd(Nb_pts)-sd(Nb_pts:-1:1)],[acen(1:Nb_pts) ; acen(Nb_pts:-1:1)],'b.-');
plot(sd(1:Nb_pts),acen(1:Nb_pts),'b.-');
hold on
%plot([sd(Nb_pts+1:end); 2*sd(end)-sd(end:-1:1+Nb_pts)],[acen(Nb_pts+1:end) ; acen(end:-1:Nb_pts+1)],'b.-');
plot(sd(Nb_pts+1:end),acen(Nb_pts+1:end),'b.-');
%plot(struc(:,1),struc(:,2)/2,'k-')
drawlattice
axis([0 getcircumference/4 -5 5])
grid on
title('SIRIUS')
xlabel('s (m)')
ylabel('Acceptance en energie \epsilon (%)')

