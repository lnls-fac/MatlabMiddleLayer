function hs = analysis_ID_Spectrum

hs = analysis_ID_Spectrum_GENERIC;
%hs = analysis_ID_Spectrum_CARNAUBA;
%hs = analysis_ID_Spectrum_CARNAUBA2;
%hs = analysis_ID_Spectrum_CARNAUBA_14mm();
%hs = analysis_ID_Spectrum_CARNAUBA_16mm();
%hs = analysis_ID_Spectrum_MANACA();
%hs = analysis_ID_Spectrum_INGA();
%hs = analysis_ID_Spectrum_ARAUCARIA();
%hs = analysis_ID_Spectrum_EPU50();
%hs = analysis_ID_Spectrum_U42_MS();
%hs = analysis_ID_Spectrum_SCW60();

function hs = analysis_ID_Spectrum_GENERIC

hs = [];

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
Params.VerticalAcceptance     = 1.0 * mm * mrad;
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
EBeam   = EBeams.MIA;                 % Escolha do trecho
IDTech  = IDTechs.IV_PPM;     % Escolha da Tech de ID.

% IDTech  = IDTechs.SoleilCryo;
% IDTech  = IDTechs.IV_HYB_SmCo;
% IDTech  = IDTechs.IV_OptDesign;

% PARÂMETROS DO ID
% ================
Period     = 18 * mm;
Length     = 4.16 * m;
ID = set_ID(EBeam, IDTech, Period, Length); % cria modelo do ID

% CÁLCULO DA RADIAÇÃO
% ===================
Harmonics = [1 3 5 7 9 11 13 15];
EnergyStep = 1;  % eV
Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);

% A estrutura 'Spectrum' contem as caracteristicas da radiação. Cada campo corresponde a uma curva de um parametro e leva o indice no harmoico.

% --- implementar visualização dos dados em 'Spectrum' a partir daqui....


% CHECKINGS
% =========
if Length > EBeam.Length, error('Length > EBeam.Length\n'); end;


d.Energy = linspace(2064,70000,300); % intervalo em energia para plot de parametros da radiação.
for i=1:length(d.Energy)
    h = 1;
    for j=1:length(Spectrum.Energy)
        brightness1 = interp1(Spectrum.Energy{h}, Spectrum.Brightness{h}, d.Energy(i));
        brightness2 = interp1(Spectrum.Energy{j}, Spectrum.Brightness{j}, d.Energy(i));
        if (brightness2 > brightness1)
            h = j;
        end
    end
    d.Harmonic(i) = h;
    d.K(i) = interp1(Spectrum.Energy{h}, Spectrum.K{h}, d.Energy(i));
    d.B(i) = interp1(Spectrum.Energy{h}, Spectrum.B{h}, d.Energy(i));
    d.Gap(i) = interp1(Spectrum.Energy{h}, Spectrum.Gap{h}, d.Energy(i));
    d.Brightness(i) = interp1(Spectrum.Energy{h}, Spectrum.Brightness{h}, d.Energy(i));
    d.Power(i) = interp1(Spectrum.Energy{h}, Spectrum.Power{h}, d.Energy(i));
end
fprintf('Energy [eV]                        : %f %f\n', d.Energy(1), d.Energy(end));
fprintf('Harmonic                           : %i %i\n', d.Harmonic(1), d.Harmonic(end));
fprintf('K                                  : %f %f\n', d.K(1), d.K(end));
fprintf('Gap [mm]                           : %f %f\n', 1000*d.Gap(1), 1000*d.Gap(end));
fprintf('power [kW]                         : %f %f\n', d.Power(1)/1000, d.Power(end)/1000);
fprintf('Brightness [ph/s/0.1bw/mm^2/mrad^2]: %E %E\n', d.Brightness([1 end]) / 1e12);


% PLOTS
% =====

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

% grava figuras
config_path = pwd;
hds = get(0, 'Children');
for i=1:length(hds);
    name = get(hds(i), 'Name');
    if isempty(name), name = ['Fig ' num2str(hds(i))]; end;
    name = [num2str(length(hds)-i+1, 'Fig %02i - ') name];
    saveas(hds(i), fullfile(config_path, [name '.fig']));
end


function hs = analysis_ID_Spectrum_SCW60(hs0)

m       = 1;
mm      = 0.001 * m; % m
mrad    = 0.001; % rad
percent = 0.01;
degree  = pi/180;
mA      = 0.001;
Tesla   = 1.0;

Params.VerticalAcceptance     = 5.77 * mm * mrad;
Params.Spacing                = 0.3  * m;
Params.BeamCurrent            = 500  * mA;
Params.Coupling               = 0.5  * percent;
Params.VaccumChamberThickness = 1.0  * mm;
Params.VaccumChamberTolerance = 0.5  * mm;
Params.PhaseError             = 1.0  * degree;
Params.MaxBr                  = 6.2104 * Tesla;

EBeams  = load_EBeams(Params);
IDTechs = load_ID_Technologies(Params);

Harmonics = [1 3 5 7 9 11 13 15];
EnergyStep = 1;
EBeam      = EBeams.MS;
IDTech     = IDTechs.PPM;
Period     = 59.19  * mm;
Length     = 0.94704 * m;

ID = set_ID(EBeam, IDTech, Period, Length);
Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);

if exist('hs0', 'var')
    hs = hs0;
else
    hs(1) = figure;
    hs(2) = figure;
    hs(3) = figure;
    hs(4) = figure;
    hs(5) = figure;
    hs(6) = figure;
    hs(7) = figure;
    hs(8) = figure;
    hs(9) = figure;
end;

figure(hs(1)); hold all;
for i=1:length(Spectrum.Energy)
    semilogy(Spectrum.Energy{i}/1000, Spectrum.Brightness{i}/1e12)
end
xlabel('Energy [keV]');
ylabel('Brightness [ph/s/0.1%bw/mm^2/mrad^2]');
title(['Brightness - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

figure(hs(2)); hold all;
for i=1:length(Spectrum.Energy)
    plot(Spectrum.Energy{i}/1000, Spectrum.B{i})
end
xlabel('Energy [keV]');
ylabel('B [T]');
title(['B Field - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

figure(hs(3)); hold all;
for i=1:length(Spectrum.Energy)
    plot(Spectrum.Energy{i}/1000, Spectrum.K{i})
end
xlabel('Energy [keV]');
ylabel('K');
title(['K Value - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

figure(hs(4)); hold all;
for i=1:length(Spectrum.Energy)
    plot(Spectrum.Energy{i}/1000, 1000 * Spectrum.Gap{i})
end
xlabel('Energy [keV]');
ylabel('ID Gap [mm]');
title(['ID Gap - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

figure(hs(5)); hold all;
for i=1:length(Spectrum.Energy)
    plot(Spectrum.Energy{i}/1000, 1e6 * Spectrum.SigmaX{i})
end
xlabel('Energy [keV]');
ylabel('SigmaX [\mum]');
title(['Photon Horiz. Size - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

figure(hs(6)); hold all;
for i=1:length(Spectrum.Energy)
    plot(Spectrum.Energy{i}/1000, 1e6* Spectrum.SigmaXl{i})
end
xlabel('Energy [keV]');
ylabel('SigmaXl [\murad]');
title(['Photon Horiz. Divergence - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

figure(hs(7)); hold all;
for i=1:length(Spectrum.Energy)
    plot(Spectrum.Energy{i}/1000, 1e6 * Spectrum.SigmaY{i})
end
xlabel('Energy [keV]');
ylabel('SigmaY [\mum]');
title(['Photon Vert. Size - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

figure(hs(8)); hold all;
for i=1:length(Spectrum.Energy)
    plot(Spectrum.Energy{i}/1000, 1e6* Spectrum.SigmaYl{i})
end
xlabel('Energy [keV]');
ylabel('SigmaYl [\murad]');
title(['Photon Vert. Divergence - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

figure(hs(9)); hold all;
for i=1:length(Spectrum.Energy)
    plot(Spectrum.Energy{i}/1000, Spectrum.Power{i} / 1000)
end
xlabel('Energy [keV]');
ylabel('Power [KWatts]');
title(['Power - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

function hs = analysis_ID_Spectrum_U42_MS(hs0)

m       = 1;
mm      = 0.001 * m; % m
mrad    = 0.001; % rad
percent = 0.01;
degree  = pi/180;
mA      = 0.001;
Tesla   = 1.0;

Params.VerticalAcceptance     = 5.77 * mm * mrad;
Params.Spacing                = 0.3  * m;
Params.BeamCurrent            = 500  * mA;
Params.Coupling               = 0.5  * percent;
Params.VaccumChamberThickness = 1.0  * mm;
Params.VaccumChamberTolerance = 0.5  * mm;
Params.PhaseError             = 1.0  * degree;
Params.MaxBr                  = 1.17 * Tesla;

EBeams  = load_EBeams(Params);
IDTechs = load_ID_Technologies(Params);

Harmonics = [1 3 5 7 9 11 13 15];
EnergyStep = 1;
EBeam      = EBeams.MS;
IDTech     = IDTechs.PPM;
Period     = 42  * mm;
Length     = 1.6 * m;

ID = set_ID(EBeam, IDTech, Period, Length);
Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);

if exist('hs0', 'var')
    hs = hs0;
else
    hs(1) = figure;
    hs(2) = figure;
    hs(3) = figure;
    hs(4) = figure;
    hs(5) = figure;
    hs(6) = figure;
    hs(7) = figure;
    hs(8) = figure;
    hs(9) = figure;
end;

figure(hs(1)); hold all;
for i=1:length(Spectrum.Energy)
    semilogy(Spectrum.Energy{i}/1000, Spectrum.Brightness{i}/1e12)
end
xlabel('Energy [keV]');
ylabel('Brightness [ph/s/0.1%bw/mm^2/mrad^2]');
title(['Brightness - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

figure(hs(2)); hold all;
for i=1:length(Spectrum.Energy)
    plot(Spectrum.Energy{i}/1000, Spectrum.B{i})
end
xlabel('Energy [keV]');
ylabel('B [T]');
title(['B Field - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

figure(hs(3)); hold all;
for i=1:length(Spectrum.Energy)
    plot(Spectrum.Energy{i}/1000, Spectrum.K{i})
end
xlabel('Energy [keV]');
ylabel('K');
title(['K Value - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

figure(hs(4)); hold all;
for i=1:length(Spectrum.Energy)
    plot(Spectrum.Energy{i}/1000, 1000 * Spectrum.Gap{i})
end
xlabel('Energy [keV]');
ylabel('ID Gap [mm]');
title(['ID Gap - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

figure(hs(5)); hold all;
for i=1:length(Spectrum.Energy)
    plot(Spectrum.Energy{i}/1000, 1e6 * Spectrum.SigmaX{i})
end
xlabel('Energy [keV]');
ylabel('SigmaX [\mum]');
title(['Photon Horiz. Size - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

figure(hs(6)); hold all;
for i=1:length(Spectrum.Energy)
    plot(Spectrum.Energy{i}/1000, 1e6* Spectrum.SigmaXl{i})
end
xlabel('Energy [keV]');
ylabel('SigmaXl [\murad]');
title(['Photon Horiz. Divergence - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

figure(hs(7)); hold all;
for i=1:length(Spectrum.Energy)
    plot(Spectrum.Energy{i}/1000, 1e6 * Spectrum.SigmaY{i})
end
xlabel('Energy [keV]');
ylabel('SigmaY [\mum]');
title(['Photon Vert. Size - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

figure(hs(8)); hold all;
for i=1:length(Spectrum.Energy)
    plot(Spectrum.Energy{i}/1000, 1e6* Spectrum.SigmaYl{i})
end
xlabel('Energy [keV]');
ylabel('SigmaYl [\murad]');
title(['Photon Vert. Divergence - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

figure(hs(9)); hold all;
for i=1:length(Spectrum.Energy)
    plot(Spectrum.Energy{i}/1000, Spectrum.Power{i} / 1000)
end
xlabel('Energy [keV]');
ylabel('Power [KWatts]');
title(['Power - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

function hs = analysis_ID_Spectrum_EPU50(hs0)

m       = 1;
mm      = 0.001 * m; % m
mrad    = 0.001; % rad
percent = 0.01;
degree  = pi/180;
mA      = 0.001;
Tesla   = 1.0;

Params.VerticalAcceptance     = 5.77 * mm * mrad;
Params.Spacing                = 0.3  * m;
Params.BeamCurrent            = 500  * mA;
Params.Coupling               = 0.5  * percent;
Params.VaccumChamberThickness = 1.0  * mm;
Params.VaccumChamberTolerance = 0.5  * mm;
Params.PhaseError             = 1.0  * degree;
Params.MaxBr                  = 1.24 * Tesla;

EBeams  = load_EBeams(Params);
IDTechs = load_ID_Technologies(Params);

Harmonics = [1 3 5 7 9 11 13 15];
EnergyStep = 1;
EBeam      = EBeams.MS;
IDTech     = IDTechs.PPM;
Period     = 50  * mm;
Length     = 2.7 * m;

ID = set_ID(EBeam, IDTech, Period, Length);
Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);


if exist('hs0', 'var')
    hs = hs0;
else
    hs(1) = figure;
    hs(2) = figure;
    hs(3) = figure;
    hs(4) = figure;
    hs(5) = figure;
    hs(6) = figure;
    hs(7) = figure;
    hs(8) = figure;
    hs(9) = figure;
end;

figure(hs(1)); hold all;
for i=1:length(Spectrum.Energy)
    semilogy(Spectrum.Energy{i}/1000, Spectrum.Brightness{i}/1e12)
end
xlabel('Energy [keV]');
ylabel('Brightness [ph/s/0.1%bw/mm^2/mrad^2]');
title(['Brightness - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

figure(hs(2)); hold all;
for i=1:length(Spectrum.Energy)
    plot(Spectrum.Energy{i}/1000, Spectrum.B{i})
end
xlabel('Energy [keV]');
ylabel('B [T]');
title(['B Field - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

figure(hs(3)); hold all;
for i=1:length(Spectrum.Energy)
    plot(Spectrum.Energy{i}/1000, Spectrum.K{i})
end
xlabel('Energy [keV]');
ylabel('K');
title(['K Value - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

figure(hs(4)); hold all;
for i=1:length(Spectrum.Energy)
    plot(Spectrum.Energy{i}/1000, 1000 * Spectrum.Gap{i})
end
xlabel('Energy [keV]');
ylabel('ID Gap [mm]');
title(['ID Gap - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

figure(hs(5)); hold all;
for i=1:length(Spectrum.Energy)
    plot(Spectrum.Energy{i}/1000, 1e6 * Spectrum.SigmaX{i})
end
xlabel('Energy [keV]');
ylabel('SigmaX [\mum]');
title(['Photon Horiz. Size - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

figure(hs(6)); hold all;
for i=1:length(Spectrum.Energy)
    plot(Spectrum.Energy{i}/1000, 1e6* Spectrum.SigmaXl{i})
end
xlabel('Energy [keV]');
ylabel('SigmaXl [\murad]');
title(['Photon Horiz. Divergence - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

figure(hs(7)); hold all;
for i=1:length(Spectrum.Energy)
    plot(Spectrum.Energy{i}/1000, 1e6 * Spectrum.SigmaY{i})
end
xlabel('Energy [keV]');
ylabel('SigmaY [\mum]');
title(['Photon Vert. Size - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

figure(hs(8)); hold all;
for i=1:length(Spectrum.Energy)
    plot(Spectrum.Energy{i}/1000, 1e6* Spectrum.SigmaYl{i})
end
xlabel('Energy [keV]');
ylabel('SigmaYl [\murad]');
title(['Photon Vert. Divergence - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

figure(hs(9)); hold all;
for i=1:length(Spectrum.Energy)
    plot(Spectrum.Energy{i}/1000, Spectrum.Power{i} / 1000)
end
xlabel('Energy [keV]');
ylabel('Power [KWatts]');
title(['Power - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

function hs = analysis_ID_Spectrum_ARAUCARIA(hs0)

m       = 1;
mm      = 0.001 * m; % m
mrad    = 0.001; % rad
percent = 0.01;
degree  = pi/180;
mA      = 0.001;
Tesla   = 1.0;

Params.VerticalAcceptance     = 5.77 * mm * mrad;
Params.Spacing                = 0.3  * m;
Params.BeamCurrent            = 500  * mA;
Params.Coupling               = 0.5  * percent;
Params.VaccumChamberThickness = 1.0  * mm;
Params.VaccumChamberTolerance = 0.5  * mm;
Params.PhaseError             = 1.0  * degree;
Params.MaxBr                  = 1.24 * Tesla;

EBeams  = load_EBeams(Params);
IDTechs = load_ID_Technologies(Params);

Harmonics = [1 3 5 7 9 11 13 15];
EnergyStep = 1;
EBeam      = EBeams.ML;
IDTech     = IDTechs.PPM;
Period     = 72 / 1000;
Length     = 8.352;

ID = set_ID(EBeam, IDTech, Period, Length);
Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);


if exist('hs0', 'var')
    hs = hs0;
else
    hs(1) = figure;
    hs(2) = figure;
    hs(3) = figure;
    hs(4) = figure;
    hs(5) = figure;
    hs(6) = figure;
    hs(7) = figure;
    hs(8) = figure;
    hs(9) = figure;
end;

figure(hs(1)); hold all;
for i=1:length(Spectrum.Energy)
    semilogy(Spectrum.Energy{i}/1000, Spectrum.Brightness{i}/1e12)
end
xlabel('Energy [keV]');
ylabel('Brightness [ph/s/0.1%bw/mm^2/mrad^2]');
title(['Brightness - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

figure(hs(2)); hold all;
for i=1:length(Spectrum.Energy)
    plot(Spectrum.Energy{i}/1000, Spectrum.B{i})
end
xlabel('Energy [keV]');
ylabel('B [T]');
title(['B Field - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

figure(hs(3)); hold all;
for i=1:length(Spectrum.Energy)
    plot(Spectrum.Energy{i}/1000, Spectrum.K{i})
end
xlabel('Energy [keV]');
ylabel('K');
title(['K Value - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

figure(hs(4)); hold all;
for i=1:length(Spectrum.Energy)
    plot(Spectrum.Energy{i}/1000, 1000 * Spectrum.Gap{i})
end
xlabel('Energy [keV]');
ylabel('ID Gap [mm]');
title(['ID Gap - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

figure(hs(5)); hold all;
for i=1:length(Spectrum.Energy)
    plot(Spectrum.Energy{i}/1000, 1e6 * Spectrum.SigmaX{i})
end
xlabel('Energy [keV]');
ylabel('SigmaX [\mum]');
title(['Photon Horiz. Size - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

figure(hs(6)); hold all;
for i=1:length(Spectrum.Energy)
    plot(Spectrum.Energy{i}/1000, 1e6* Spectrum.SigmaXl{i})
end
xlabel('Energy [keV]');
ylabel('SigmaXl [\murad]');
title(['Photon Horiz. Divergence - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

figure(hs(7)); hold all;
for i=1:length(Spectrum.Energy)
    plot(Spectrum.Energy{i}/1000, 1e6 * Spectrum.SigmaY{i})
end
xlabel('Energy [keV]');
ylabel('SigmaY [\mum]');
title(['Photon Vert. Size - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

figure(hs(8)); hold all;
for i=1:length(Spectrum.Energy)
    plot(Spectrum.Energy{i}/1000, 1e6* Spectrum.SigmaYl{i})
end
xlabel('Energy [keV]');
ylabel('SigmaYl [\murad]');
title(['Photon Vert. Divergence - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

figure(hs(9)); hold all;
for i=1:length(Spectrum.Energy)
    plot(Spectrum.Energy{i}/1000, Spectrum.Power{i} / 1000)
end
xlabel('Energy [keV]');
ylabel('Power [KWatts]');
title(['Power - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

function hs = analysis_ID_Spectrum_INGA(hs0)

m       = 1;
mm      = 0.001 * m; % m
mrad    = 0.001; % rad
percent = 0.01;
degree  = pi/180;
mA      = 0.001;
Tesla   = 1.0;

Params.VerticalAcceptance     = 5.77 * mm * mrad;
Params.Spacing                = 0.3  * m;
Params.BeamCurrent            = 500  * mA;
Params.Coupling               = 0.5  * percent;
Params.VaccumChamberThickness = 1.0  * mm;
Params.VaccumChamberTolerance = 0.5  * mm;
Params.PhaseError             = 1.0  * degree;
Params.MaxBr                  = 1.24 * Tesla;

EBeams  = load_EBeams(Params);
IDTechs = load_ID_Technologies(Params);

Harmonics = [1 3 5 7 9 11 13 15];
EnergyStep = 1;
EBeam      = EBeams.MS;
IDTech     = IDTechs.IV_PPM;
Period     = 19 / 1000;
Length     = 2.432;

ID = set_ID(EBeam, IDTech, Period, Length);
Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);


if exist('hs0', 'var')
    hs = hs0;
else
    hs(1) = figure;
    hs(2) = figure;
    hs(3) = figure;
    hs(4) = figure;
    hs(5) = figure;
    hs(6) = figure;
    hs(7) = figure;
    hs(8) = figure;
    hs(9) = figure;
end;

figure(hs(1)); hold all;
for i=1:length(Spectrum.Energy)
    semilogy(Spectrum.Energy{i}/1000, Spectrum.Brightness{i}/1e12)
end
xlabel('Energy [keV]');
ylabel('Brightness [ph/s/0.1%bw/mm^2/mrad^2]');
title(['Brightness - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

figure(hs(2)); hold all;
for i=1:length(Spectrum.Energy)
    plot(Spectrum.Energy{i}/1000, Spectrum.B{i})
end
xlabel('Energy [keV]');
ylabel('B [T]');
title(['B Field - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

figure(hs(3)); hold all;
for i=1:length(Spectrum.Energy)
    plot(Spectrum.Energy{i}/1000, Spectrum.K{i})
end
xlabel('Energy [keV]');
ylabel('K');
title(['K Value - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

figure(hs(4)); hold all;
for i=1:length(Spectrum.Energy)
    plot(Spectrum.Energy{i}/1000, 1000 * Spectrum.Gap{i})
end
xlabel('Energy [keV]');
ylabel('ID Gap [mm]');
title(['ID Gap - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

figure(hs(5)); hold all;
for i=1:length(Spectrum.Energy)
    plot(Spectrum.Energy{i}/1000, 1e6 * Spectrum.SigmaX{i})
end
xlabel('Energy [keV]');
ylabel('SigmaX [\mum]');
title(['Photon Horiz. Size - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

figure(hs(6)); hold all;
for i=1:length(Spectrum.Energy)
    plot(Spectrum.Energy{i}/1000, 1e6* Spectrum.SigmaXl{i})
end
xlabel('Energy [keV]');
ylabel('SigmaXl [\murad]');
title(['Photon Horiz. Divergence - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

figure(hs(7)); hold all;
for i=1:length(Spectrum.Energy)
    plot(Spectrum.Energy{i}/1000, 1e6 * Spectrum.SigmaY{i})
end
xlabel('Energy [keV]');
ylabel('SigmaY [\mum]');
title(['Photon Vert. Size - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

figure(hs(8)); hold all;
for i=1:length(Spectrum.Energy)
    plot(Spectrum.Energy{i}/1000, 1e6* Spectrum.SigmaYl{i})
end
xlabel('Energy [keV]');
ylabel('SigmaYl [\murad]');
title(['Photon Vert. Divergence - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

figure(hs(9)); hold all;
for i=1:length(Spectrum.Energy)
    plot(Spectrum.Energy{i}/1000, Spectrum.Power{i} / 1000)
end
xlabel('Energy [keV]');
ylabel('Power [KWatts]');
title(['Power - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

function hs = analysis_ID_Spectrum_MANACA(hs0)

m       = 1;
mm      = 0.001 * m; % m
mrad    = 0.001; % rad
percent = 0.01;
degree  = pi/180;
mA      = 0.001;
Tesla   = 1.0;

Params.VerticalAcceptance     = 5.77 * mm * mrad;
Params.Spacing                = 0.3  * m;
Params.BeamCurrent            = 500  * mA;
Params.Coupling               = 0.5  * percent;
Params.VaccumChamberThickness = 1.0  * mm;
Params.VaccumChamberTolerance = 0.5  * mm;
Params.PhaseError             = 1.0  * degree;
Params.MaxBr                  = 1.24 * Tesla;

EBeams  = load_EBeams(Params);
IDTechs = load_ID_Technologies(Params);

Harmonics = [1 3 5 7 9 11 13 15];
EnergyStep = 1;
EBeam      = EBeams.MS;
IDTech     = IDTechs.IV_PPM;
Period     = 24 / 1000;
Length     = 2.8080;

ID = set_ID(EBeam, IDTech, Period, Length);
Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);


if exist('hs0', 'var')
    hs = hs0;
else
    hs(1) = figure;
    hs(2) = figure;
    hs(3) = figure;
    hs(4) = figure;
    hs(5) = figure;
    hs(6) = figure;
    hs(7) = figure;
    hs(8) = figure;
    hs(9) = figure;
end;

figure(hs(1)); hold all;
for i=1:length(Spectrum.Energy)
    semilogy(Spectrum.Energy{i}/1000, Spectrum.Brightness{i}/1e12)
end
xlabel('Energy [keV]');
ylabel('Brightness [ph/s/0.1%bw/mm^2/mrad^2]');
title(['Brightness - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

figure(hs(2)); hold all;
for i=1:length(Spectrum.Energy)
    plot(Spectrum.Energy{i}/1000, Spectrum.B{i})
end
xlabel('Energy [keV]');
ylabel('B [T]');
title(['B Field - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

figure(hs(3)); hold all;
for i=1:length(Spectrum.Energy)
    plot(Spectrum.Energy{i}/1000, Spectrum.K{i})
end
xlabel('Energy [keV]');
ylabel('K');
title(['K Value - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

figure(hs(4)); hold all;
for i=1:length(Spectrum.Energy)
    plot(Spectrum.Energy{i}/1000, 1000 * Spectrum.Gap{i})
end
xlabel('Energy [keV]');
ylabel('ID Gap [mm]');
title(['ID Gap - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

figure(hs(5)); hold all;
for i=1:length(Spectrum.Energy)
    plot(Spectrum.Energy{i}/1000, 1e6 * Spectrum.SigmaX{i})
end
xlabel('Energy [keV]');
ylabel('SigmaX [\mum]');
title(['Photon Horiz. Size - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

figure(hs(6)); hold all;
for i=1:length(Spectrum.Energy)
    plot(Spectrum.Energy{i}/1000, 1e6* Spectrum.SigmaXl{i})
end
xlabel('Energy [keV]');
ylabel('SigmaXl [\murad]');
title(['Photon Horiz. Divergence - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

figure(hs(7)); hold all;
for i=1:length(Spectrum.Energy)
    plot(Spectrum.Energy{i}/1000, 1e6 * Spectrum.SigmaY{i})
end
xlabel('Energy [keV]');
ylabel('SigmaY [\mum]');
title(['Photon Vert. Size - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

figure(hs(8)); hold all;
for i=1:length(Spectrum.Energy)
    plot(Spectrum.Energy{i}/1000, 1e6* Spectrum.SigmaYl{i})
end
xlabel('Energy [keV]');
ylabel('SigmaYl [\murad]');
title(['Photon Vert. Divergence - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

figure(hs(9)); hold all;
for i=1:length(Spectrum.Energy)
    plot(Spectrum.Energy{i}/1000, Spectrum.Power{i} / 1000)
end
xlabel('Energy [keV]');
ylabel('Power [KWatts]');
title(['Power - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

function hs = analysis_ID_Spectrum_CARNAUBA(hs0)

m       = 1;
mm      = 0.001 * m; % m
mrad    = 0.001; % rad
percent = 0.01;
degree  = pi/180;
mA      = 0.001;
Tesla   = 1.0;

Params.VerticalAcceptance     = 5.77 * mm * mrad;
Params.Spacing                = 0.3  * m;
Params.BeamCurrent            = 500  * mA;
Params.Coupling               = 0.5  * percent;
Params.VaccumChamberThickness = 1.0  * mm;
Params.VaccumChamberTolerance = 0.5  * mm;
Params.PhaseError             = 1.0  * degree;
Params.MaxBr                  = 1.24 * Tesla;

EBeams  = load_EBeams(Params);
IDTechs = load_ID_Technologies(Params);

Harmonics = [1 3 5 7 9 11 13 15];
EnergyStep = 1;
EBeam      = EBeams.MS;
IDTech     = IDTechs.IV_PPM;
Period     = 23 / 1000;
Length     = 2.3920;

ID = set_ID(EBeam, IDTech, Period, Length);
Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);

if exist('hs0', 'var')
    plot_spectrum(hs0, Spectrum, hs0);
else
    plot_spectrum(Spectrum);
end

function hs = analysis_ID_Spectrum_CARNAUBA2(hs0)

m       = 1;
mm      = 0.001 * m; % m
mrad    = 0.001; % rad
percent = 0.01;
degree  = pi/180;
mA      = 0.001;
Tesla   = 1.0;

Params.VerticalAcceptance     = 5.77 * mm * mrad;
Params.Spacing                = 0.3  * m;
Params.BeamCurrent            = 500  * mA;
Params.Coupling               = 0.5  * percent;
Params.VaccumChamberThickness = 1.0  * mm;
Params.VaccumChamberTolerance = 0.5  * mm;
Params.PhaseError             = 1.0  * degree;
Params.MaxBr                  = 1.24 * Tesla;

EBeams  = load_EBeams(Params);
IDTechs = load_ID_Technologies(Params);

Harmonics = [1 3 5 7 9 11 13 15];
EnergyStep = 1;
EBeam      = EBeams.ML;
IDTech     = IDTechs.IV_PPM;
Period     = 27 / 1000;
Length     = 6.1560;

ID = set_ID(EBeam, IDTech, Period, Length);
Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);

if exist('hs0', 'var')
    plot_spectrum(hs0, Spectrum, hs0);
else
    plot_spectrum(Spectrum);
end

function hs = analysis_ID_Spectrum_CARNAUBA_14mm(hs0)

m       = 1;
mm      = 0.001 * m; % m
mrad    = 0.001; % rad
percent = 0.01;
degree  = pi/180;
mA      = 0.001;
Tesla   = 1.0;

Params.VerticalAcceptance     = 5.77 * mm * mrad;
Params.Spacing                = 0.3  * m;
Params.BeamCurrent            = 500  * mA;
Params.Coupling               = 0.5  * percent;
Params.VaccumChamberThickness = 1.0  * mm;
Params.VaccumChamberTolerance = 0.5  * mm;
Params.PhaseError             = 1.0  * degree;
Params.MaxBr                  = 1.24 * Tesla;

EBeams = load_EBeams(Params);
IDTechs = load_ID_Technologies(Params);

Harmonics = [1 3 5 7 9 11 13 15];
EnergyStep = 1;
EBeam      = EBeams.MS;
IDTech     = IDTechs.IV_PPM;
Period     = 14 / 1000;
Length     = 2.392;

ID = set_ID(EBeam, IDTech, Period, Length);
Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);


if exist('hs0', 'var')
    hs = hs0;
else
    hs(1) = figure;
    hs(2) = figure;
    hs(3) = figure;
    hs(4) = figure;
    hs(5) = figure;
    hs(6) = figure;
    hs(7) = figure;
    hs(8) = figure;
    hs(9) = figure;
end;

figure(hs(1)); hold all;
for i=1:length(Spectrum.Energy)
    semilogy(Spectrum.Energy{i}/1000, Spectrum.Brightness{i}/1e12)
end
xlabel('Energy [keV]');
ylabel('Brightness [ph/s/0.1%bw/mm^2/mrad^2]');
title(['Brightness - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

figure(hs(2)); hold all;
for i=1:length(Spectrum.Energy)
    plot(Spectrum.Energy{i}/1000, Spectrum.B{i})
end
xlabel('Energy [keV]');
ylabel('B [T]');
title(['B Field - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

figure(hs(3)); hold all;
for i=1:length(Spectrum.Energy)
    plot(Spectrum.Energy{i}/1000, Spectrum.K{i})
end
xlabel('Energy [keV]');
ylabel('K');
title(['K Value - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

figure(hs(4)); hold all;
for i=1:length(Spectrum.Energy)
    plot(Spectrum.Energy{i}/1000, 1000 * Spectrum.Gap{i})
end
xlabel('Energy [keV]');
ylabel('ID Gap [mm]');
title(['ID Gap - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

figure(hs(5)); hold all;
for i=1:length(Spectrum.Energy)
    plot(Spectrum.Energy{i}/1000, 1e6 * Spectrum.SigmaX{i})
end
xlabel('Energy [keV]');
ylabel('SigmaX [\mum]');
title(['Photon Horiz. Size - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

figure(hs(6)); hold all;
for i=1:length(Spectrum.Energy)
    plot(Spectrum.Energy{i}/1000, 1e6* Spectrum.SigmaXl{i})
end
xlabel('Energy [keV]');
ylabel('SigmaXl [\murad]');
title(['Photon Horiz. Divergence - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

figure(hs(7)); hold all;
for i=1:length(Spectrum.Energy)
    plot(Spectrum.Energy{i}/1000, 1e6 * Spectrum.SigmaY{i})
end
xlabel('Energy [keV]');
ylabel('SigmaY [\mum]');
title(['Photon Vert. Size - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

figure(hs(8)); hold all;
for i=1:length(Spectrum.Energy)
    plot(Spectrum.Energy{i}/1000, 1e6* Spectrum.SigmaYl{i})
end
xlabel('Energy [keV]');
ylabel('SigmaYl [\murad]');
title(['Photon Vert. Divergence - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

figure(hs(9)); hold all;
for i=1:length(Spectrum.Energy)
    plot(Spectrum.Energy{i}/1000, Spectrum.Power{i} / 1000)
end
xlabel('Energy [keV]');
ylabel('Power [KWatts]');
title(['Power - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

function hs = analysis_ID_Spectrum_CARNAUBA_16mm(hs0)

m       = 1;
mm      = 0.001 * m; % m
mrad    = 0.001; % rad
percent = 0.01;
degree  = pi/180;
mA      = 0.001;
Tesla   = 1.0;

Params.VerticalAcceptance     = 5.77 * mm * mrad;
Params.Spacing                = 0.3  * m;
Params.BeamCurrent            = 500  * mA;
Params.Coupling               = 0.5  * percent;
Params.VaccumChamberThickness = 1.0  * mm;
Params.VaccumChamberTolerance = 0.5  * mm;
Params.PhaseError             = 1.0  * degree;
Params.MaxBr                  = 1.24 * Tesla;

EBeams = load_EBeams(Params);
IDTechs = load_ID_Technologies(Params);

Harmonics = [1 3 5 7 9 11 13 15];
EnergyStep = 1;
EBeam      = EBeams.MS;
IDTech     = IDTechs.IV_PPM;
Period     = 16 / 1000;
Length     = 2.392;

ID = set_ID(EBeam, IDTech, Period, Length);
Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);


if exist('hs0', 'var')
    hs = hs0;
else
    hs(1) = figure;
    hs(2) = figure;
    hs(3) = figure;
    hs(4) = figure;
    hs(5) = figure;
    hs(6) = figure;
    hs(7) = figure;
    hs(8) = figure;
    hs(9) = figure;
end;

figure(hs(1)); hold all;
for i=1:length(Spectrum.Energy)
    semilogy(Spectrum.Energy{i}/1000, Spectrum.Brightness{i}/1e12)
end
xlabel('Energy [keV]');
ylabel('Brightness [ph/s/0.1%bw/mm^2/mrad^2]');
title(['Brightness - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

figure(hs(2)); hold all;
for i=1:length(Spectrum.Energy)
    plot(Spectrum.Energy{i}/1000, Spectrum.B{i})
end
xlabel('Energy [keV]');
ylabel('B [T]');
title(['B Field - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

figure(hs(3)); hold all;
for i=1:length(Spectrum.Energy)
    plot(Spectrum.Energy{i}/1000, Spectrum.K{i})
end
xlabel('Energy [keV]');
ylabel('K');
title(['K Value - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

figure(hs(4)); hold all;
for i=1:length(Spectrum.Energy)
    plot(Spectrum.Energy{i}/1000, 1000 * Spectrum.Gap{i})
end
xlabel('Energy [keV]');
ylabel('ID Gap [mm]');
title(['ID Gap - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

figure(hs(5)); hold all;
for i=1:length(Spectrum.Energy)
    plot(Spectrum.Energy{i}/1000, 1e6 * Spectrum.SigmaX{i})
end
xlabel('Energy [keV]');
ylabel('SigmaX [\mum]');
title(['Photon Horiz. Size - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

figure(hs(6)); hold all;
for i=1:length(Spectrum.Energy)
    plot(Spectrum.Energy{i}/1000, 1e6* Spectrum.SigmaXl{i})
end
xlabel('Energy [keV]');
ylabel('SigmaXl [\murad]');
title(['Photon Horiz. Divergence - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

figure(hs(7)); hold all;
for i=1:length(Spectrum.Energy)
    plot(Spectrum.Energy{i}/1000, 1e6 * Spectrum.SigmaY{i})
end
xlabel('Energy [keV]');
ylabel('SigmaY [\mum]');
title(['Photon Vert. Size - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

figure(hs(8)); hold all;
for i=1:length(Spectrum.Energy)
    plot(Spectrum.Energy{i}/1000, 1e6* Spectrum.SigmaYl{i})
end
xlabel('Energy [keV]');
ylabel('SigmaYl [\murad]');
title(['Photon Vert. Divergence - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

figure(hs(9)); hold all;
for i=1:length(Spectrum.Energy)
    plot(Spectrum.Energy{i}/1000, Spectrum.Power{i} / 1000)
end
xlabel('Energy [keV]');
ylabel('Power [KWatts]');
title(['Power - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

function plot_spectrum(Spectrum, hs0)

if exist('hs0', 'var')
    hs = hs0;
else
    hs(1) = figure;
    hs(2) = figure;
    hs(3) = figure;
    hs(4) = figure;
    hs(5) = figure;
    hs(6) = figure;
    hs(7) = figure;
    hs(8) = figure;
    hs(9) = figure;
    hs(10) = figure;
end;

figure(hs(1)); hold all;
for i=1:length(Spectrum.Energy)
    semilogy(Spectrum.Energy{i}/1000, Spectrum.Brightness{i}/1e12)
end
xlabel('Energy [keV]');
ylabel('Brightness [ph/s/0.1%bw/mm^2/mrad^2]');
title(['Brightness - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

figure(hs(2)); hold all;
for i=1:length(Spectrum.Energy)
    plot(Spectrum.Energy{i}/1000, Spectrum.B{i})
end
xlabel('Energy [keV]');
ylabel('B [T]');
title(['B Field - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

figure(hs(3)); hold all;
for i=1:length(Spectrum.Energy)
    plot(Spectrum.Energy{i}/1000, Spectrum.K{i})
end
xlabel('Energy [keV]');
ylabel('K');
title(['K Value - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

figure(hs(4)); hold all;
for i=1:length(Spectrum.Energy)
    plot(Spectrum.Energy{i}/1000, 1000 * Spectrum.Gap{i})
end
xlabel('Energy [keV]');
ylabel('ID Gap [mm]');
title(['ID Gap - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

figure(hs(5)); hold all;
for i=1:length(Spectrum.Energy)
    plot(Spectrum.Energy{i}/1000, 1e6 * Spectrum.SigmaX{i})
end
xlabel('Energy [keV]');
ylabel('SigmaX [\mum]');
title(['Photon Horiz. Size - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

figure(hs(6)); hold all;
for i=1:length(Spectrum.Energy)
    plot(Spectrum.Energy{i}/1000, 1e6* Spectrum.SigmaXl{i})
end
xlabel('Energy [keV]');
ylabel('SigmaXl [\murad]');
title(['Photon Horiz. Divergence - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

figure(hs(7)); hold all;
for i=1:length(Spectrum.Energy)
    plot(Spectrum.Energy{i}/1000, 1e6 * Spectrum.SigmaY{i})
end
xlabel('Energy [keV]');
ylabel('SigmaY [\mum]');
title(['Photon Vert. Size - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

figure(hs(8)); hold all;
for i=1:length(Spectrum.Energy)
    plot(Spectrum.Energy{i}/1000, 1e6* Spectrum.SigmaYl{i})
end
xlabel('Energy [keV]');
ylabel('SigmaYl [\murad]');
title(['Photon Vert. Divergence - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

figure(hs(9)); hold all;
for i=1:length(Spectrum.Energy)
    plot(Spectrum.Energy{i}/1000, Spectrum.Power{i} / 1000)
end
xlabel('Energy [keV]');
ylabel('Power [KWatts]');
title(['Power - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);

colors = 'bgrcmyb';
figure(hs(10)); hold all;
for i=1:length(Spectrum.Energy)
    c = 1 + mod(i-1,length(colors));
    plot(Spectrum.Energy{i}/1000, Spectrum.Flux{i}, ['-' colors(c)], 'LineWidth', 2);
    plot(Spectrum.Energy{i}/1000, Spectrum.CoherentFlux{i}, ['--' colors(c)], 'LineWidth', 2);
end
xlabel('Energy [keV]');
ylabel('Flux [ph/s/0.1%bw]');
title(['Total and Coherent Flux - ' Spectrum.EBeam.Label ' - ' strrep(Spectrum.ID.Tech.Label, '_', '-') ' - \lambda = ' num2str(1000*Spectrum.ID.Period, '%5.1f mm') ' - L = ' num2str(Spectrum.ID.Length, '%4.2f m')]);
