function r = IDSpectrum

[pathstr, tmp, tmp] = fileparts(mfilename('fullpath'));
addpath(fullfile(pathstr, 'scripts'));


% CONSTANTES
% ==========
m       = 1;
mm      = 0.001 * m; % m
mrad    = 0.001; % rad
percent = 0.01;
degree  = pi/180;
mA      = 0.001;
Tesla   = 1.0;

% PARÂMETROS DA REDE E DA ÓTICA
% =============================
Params.VerticalAcceptance     = 1 * 5.77 * mm * mrad;
Params.Spacing                = 0.5  * m;
Params.BeamCurrent            = 500  * mA;
Params.Coupling               = 0.5  * percent;
Params.VaccumChamberThickness = 1.0  * mm;
Params.VaccumChamberTolerance = 0.5  * mm;
Params.PhaseError             = 1.0  * degree;
Params.MaxBr                  = 1.3  * Tesla;

% SELEÇÃO DA TECH DE ID E DO TRECHO DE INSTALAÇÃO
% ===============================================
EBeams  = load_EBeams(Params);
IDTechs = load_ID_Technologies(Params);
EBeam   = EBeams.NSLS2;
IDTech  = IDTechs.IV_PPM;

% PARÂMETROS DO ID
% ================
Period     = 20  * mm;
Length     = 3 * m;
ID = set_ID(EBeam, IDTech, Period, Length);

% CÁLCULO DA RADIAÇÃO
% ===================
Harmonics = [1 3 5 7 9 11 13 15];
EnergyStep = 1;
Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);

% RETORNA ESTRUTURAS COM DADOS
% ============================
r.EBeam = EBeam;
r.IDTech = IDTech;
r.Period = Period;
r.Length = Length;
r.ID     = ID;
r.Spectrum = Spectrum;
r.Harmonics = Harmonics;
r.EnergyStep = EnergyStep;

% CHECA CONSISTÊNCIA DOS PARÂMETROS
% =================================
if Length > EBeam.Length, error('Length > EBeam.Length\n'); end;

% PLOTS
% =====

hs(1) = figure;
figure(hs(1)); hold all;
for i=1:length(Spectrum.Energy)
    semilogy(Spectrum.Energy{i}/1000, Spectrum.Flux{i})
end
xlabel('Energy [keV]');
ylabel('Fluxo');
title(['Brightness - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);
%axis([0.005 0.100 0 1e20]);

return;

hs(1) = figure;
figure(hs(1)); hold all;
for i=1:length(Spectrum.Energy)
    semilogy(Spectrum.Energy{i}/1000, Spectrum.Brightness{i}/1e12)
end
xlabel('Energy [keV]');
ylabel('Brightness [ph/s/0.1%bw/mm^2/mrad^2]');
title(['Brightness - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);
%axis([0.005 0.100 0 1e20]);

%return;

hs(2) = figure;
figure(hs(2)); hold all;
for i=1:length(Spectrum.Energy)
    plot(Spectrum.Energy{i}/1000, Spectrum.B{i})
end
xlabel('Energy [keV]');
ylabel('B [T]');
title(['B Field - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

hs(3) = figure;
figure(hs(3)); hold all;
for i=1:length(Spectrum.Energy)
    plot(Spectrum.Energy{i}/1000, Spectrum.K{i})
end
xlabel('Energy [keV]');
ylabel('K');
title(['K Value - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

hs(4) = figure;
figure(hs(4)); hold all;
for i=1:length(Spectrum.Energy)
    plot(Spectrum.Energy{i}/1000, 1000 * Spectrum.Gap{i})
end
xlabel('Energy [keV]');
ylabel('ID Gap [mm]');
title(['ID Gap - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

hs(5) = figure;
figure(hs(5)); hold all;
for i=1:length(Spectrum.Energy)
    plot(Spectrum.Energy{i}/1000, 1e6 * Spectrum.SigmaX{i})
end
xlabel('Energy [keV]');
ylabel('SigmaX [\mum]');
title(['Photon Horiz. Size - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

hs(6) = figure;
figure(hs(6)); hold all;
for i=1:length(Spectrum.Energy)
    plot(Spectrum.Energy{i}/1000, 1e6* Spectrum.SigmaXl{i})
end
xlabel('Energy [keV]');
ylabel('SigmaXl [\murad]');
title(['Photon Horiz. Divergence - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

hs(7) = figure;
figure(hs(7)); hold all;
for i=1:length(Spectrum.Energy)
    plot(Spectrum.Energy{i}/1000, 1e6 * Spectrum.SigmaY{i})
end
xlabel('Energy [keV]');
ylabel('SigmaY [\mum]');
title(['Photon Vert. Size - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

hs(8) = figure;
figure(hs(8)); hold all;
for i=1:length(Spectrum.Energy)
    plot(Spectrum.Energy{i}/1000, 1e6* Spectrum.SigmaYl{i})
end
xlabel('Energy [keV]');
ylabel('SigmaYl [\murad]');
title(['Photon Vert. Divergence - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

hs(9) = figure;
figure(hs(9)); hold all;
for i=1:length(Spectrum.Energy)
    plot(Spectrum.Energy{i}/1000, Spectrum.Power{i} / 1000)
end
xlabel('Energy [keV]');
ylabel('Power [KWatts]');
title(['Power - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);