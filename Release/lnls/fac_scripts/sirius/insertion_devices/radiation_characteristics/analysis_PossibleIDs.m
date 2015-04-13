function best_results = analysis_PossibleIDs

m       = 1;
mm      = 0.001 * m; % m
mrad    = 0.001; % rad
percent = 0.01;
degree  = pi/180;
mA      = 0.001;
Tesla   = 1.0;

Params.VerticalAcceptance = 5.77 * mm * mrad;
%Params.Spacing     = 0.3 * m;
Params.Spacing     = 0.5 * m;
Params.BeamCurrent = 500 * mA;
Params.Coupling    = 0.5 * percent;
Params.VaccumChamberThickness = 1.0 * mm;
Params.VaccumChamberTolerance = 0.5 * mm;
Params.PhaseError             = 1.0 * degree;
%Params.MaxBr                  = 1.24 * Tesla;
Params.MaxBr                  = 1.3 * Tesla;

EBeams  = load_EBeams(Params);
IDTechs = load_ID_Technologies(Params);

%best_results = select_CARNAUBA(EBeams,IDTechs);
%best_results = select_MANACA(EBeams,IDTechs);
%best_results = select_INGA(EBeams,IDTechs);
%best_results = select_ARAUCARIA(EBeams,IDTechs);
%best_results = select_SIBIPIRUNA(EBeams,IDTechs);
%best_results = select_HARRY(EBeams,IDTechs);
best_results = select_PETROFF(EBeams,IDTechs);


AvgBrightness = zeros(1,length(best_results));
for i=1:length(best_results)
    AvgBrightness(i) = best_results{i}.AvgBrightness;
end
[~, idx] = sort(AvgBrightness);
best_results = best_results(idx);

figure; hold all;
legs = {};
for i=1:length(best_results)
    r = best_results{i};
    plot(r.Energy / 1000, r.Brightness / 1e12);
    label = ['(' num2str(i, '%02i') ') ' r.Spectrum.EBeam.Label ' - ' r.Spectrum.ID.Tech.Label ' - \lambda = ' num2str(r.Spectrum.ID.Period*1000, '%4.2f') ' mm, L = ', num2str(r.Spectrum.ID.Length, '%4.2f')];
    label = strrep(label, '_', '-');
    legs = [legs label];
end
legend(legs);

function BestResults = select_PETROFF(EBeams, IDTechs)

% HARRY

Energy = 5:0.2:100;
Harmonics  = [1 3 5 7 9 11 13 15];
EnergyStep = 0.2;    % eV
BestResults = struct([]);
periods  = (70:10:180) / 1000;
MaxPower = 10 * 1000; % Watts;


%% MS


% MS & PPM
% --------
EBeam    = EBeams.MS;
IDTech   = IDTechs.PPM;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end   
end
BestResults{end+1} = BestResult;

% MS & IV_PPM
% -----------
EBeam    = EBeams.MS;
IDTech   = IDTechs.IV_PPM;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end
end
BestResults{end+1} = BestResult;


% MS & HYB_NdFeB
% --------------
EBeam    = EBeams.MS;   
IDTech   = IDTechs.HYB_NdFeB;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end
end
BestResults{end+1} = BestResult;



% MS & IV_HYB_NdFeB
% -----------------
EBeam    = EBeams.MS;
IDTech   = IDTechs.IV_HYB_NdFeB;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end
end
BestResults{end+1} = BestResult;


% MS & HYB_SmCo
% -------------
EBeam    = EBeams.MS;   
IDTech   = IDTechs.HYB_SmCo;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end
end
BestResults{end+1} = BestResult;


% MS & IV_HYB_SmCo
% ----------------
EBeam    = EBeams.MS;
IDTech   = IDTechs.IV_HYB_SmCo;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end 
end
BestResults{end+1} = BestResult;


%% MM


% MM & PPM
% --------
EBeam    = EBeams.MM;
IDTech   = IDTechs.PPM;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end    
end
BestResults{end+1} = BestResult;

% MM & IV_PPM
% -----------
EBeam    = EBeams.MM;
IDTech   = IDTechs.IV_PPM;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end
end
BestResults{end+1} = BestResult;


% MM & HYB_NdFeB
% --------------
EBeam    = EBeams.MM;   
IDTech   = IDTechs.HYB_NdFeB;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end 
end
BestResults{end+1} = BestResult;


% MM & IV_HYB_NdFeB
% -----------------
EBeam    = EBeams.MM;
IDTech   = IDTechs.IV_HYB_NdFeB;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end
end
BestResults{end+1} = BestResult;


% MM & HYB_SmCo
% -------------
EBeam    = EBeams.MM;   
IDTech   = IDTechs.HYB_SmCo;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end    
end
BestResults{end+1} = BestResult;


% MM & IV_HYB_SmCo
% ----------------
EBeam    = EBeams.MM;
IDTech   = IDTechs.IV_HYB_SmCo;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end
end
BestResults{end+1} = BestResult;



%% ML


% ML & PPM
% --------
EBeam    = EBeams.ML;
IDTech   = IDTechs.PPM;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end    
end
BestResults{end+1} = BestResult;

% ML & IV_PPM
% -----------
EBeam    = EBeams.ML;
IDTech   = IDTechs.IV_PPM;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end
end
BestResults{end+1} = BestResult;


% ML & HYB_NdFeB
% --------------
EBeam    = EBeams.ML;   
IDTech   = IDTechs.HYB_NdFeB;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end
end
BestResults{end+1} = BestResult;


% ML & IV_HYB_NdFeB
% -----------------
EBeam    = EBeams.ML;
IDTech   = IDTechs.IV_HYB_NdFeB;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end   
end
BestResults{end+1} = BestResult;


% ML & HYB_SmCo
% -------------
EBeam    = EBeams.ML;   
IDTech   = IDTechs.HYB_SmCo;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end
end
BestResults{end+1} = BestResult;


% ML & IV_HYB_SmCo
% ----------------
EBeam    = EBeams.ML;
IDTech   = IDTechs.IV_HYB_SmCo;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end
end
BestResults{end+1} = BestResult;



function BestResults = select_HARRY(EBeams, IDTechs)

% HARRY

Energy = 5:0.2:100;
Harmonics  = [1 3 5 7 9 11 13 15];
EnergyStep = 0.2;    % eV
BestResults = struct([]);
periods  = (70:10:180) / 1000;
MaxPower = 10 * 1000; % Watts;


%% MS


% MS & PPM
% --------
EBeam    = EBeams.MS;
IDTech   = IDTechs.PPM;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end   
end
BestResults{end+1} = BestResult;

% MS & IV_PPM
% -----------
EBeam    = EBeams.MS;
IDTech   = IDTechs.IV_PPM;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end
end
BestResults{end+1} = BestResult;


% MS & HYB_NdFeB
% --------------
EBeam    = EBeams.MS;   
IDTech   = IDTechs.HYB_NdFeB;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end
end
BestResults{end+1} = BestResult;



% MS & IV_HYB_NdFeB
% -----------------
EBeam    = EBeams.MS;
IDTech   = IDTechs.IV_HYB_NdFeB;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end
end
BestResults{end+1} = BestResult;


% MS & HYB_SmCo
% -------------
EBeam    = EBeams.MS;   
IDTech   = IDTechs.HYB_SmCo;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end
end
BestResults{end+1} = BestResult;


% MS & IV_HYB_SmCo
% ----------------
EBeam    = EBeams.MS;
IDTech   = IDTechs.IV_HYB_SmCo;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end 
end
BestResults{end+1} = BestResult;


%% MM


% MM & PPM
% --------
EBeam    = EBeams.MM;
IDTech   = IDTechs.PPM;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end    
end
BestResults{end+1} = BestResult;

% MM & IV_PPM
% -----------
EBeam    = EBeams.MM;
IDTech   = IDTechs.IV_PPM;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end
end
BestResults{end+1} = BestResult;


% MM & HYB_NdFeB
% --------------
EBeam    = EBeams.MM;   
IDTech   = IDTechs.HYB_NdFeB;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end 
end
BestResults{end+1} = BestResult;


% MM & IV_HYB_NdFeB
% -----------------
EBeam    = EBeams.MM;
IDTech   = IDTechs.IV_HYB_NdFeB;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end
end
BestResults{end+1} = BestResult;


% MM & HYB_SmCo
% -------------
EBeam    = EBeams.MM;   
IDTech   = IDTechs.HYB_SmCo;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end    
end
BestResults{end+1} = BestResult;


% MM & IV_HYB_SmCo
% ----------------
EBeam    = EBeams.MM;
IDTech   = IDTechs.IV_HYB_SmCo;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end
end
BestResults{end+1} = BestResult;



%% ML


% ML & PPM
% --------
EBeam    = EBeams.ML;
IDTech   = IDTechs.PPM;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end    
end
BestResults{end+1} = BestResult;

% ML & IV_PPM
% -----------
EBeam    = EBeams.ML;
IDTech   = IDTechs.IV_PPM;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end
end
BestResults{end+1} = BestResult;


% ML & HYB_NdFeB
% --------------
EBeam    = EBeams.ML;   
IDTech   = IDTechs.HYB_NdFeB;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end
end
BestResults{end+1} = BestResult;


% ML & IV_HYB_NdFeB
% -----------------
EBeam    = EBeams.ML;
IDTech   = IDTechs.IV_HYB_NdFeB;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end   
end
BestResults{end+1} = BestResult;


% ML & HYB_SmCo
% -------------
EBeam    = EBeams.ML;   
IDTech   = IDTechs.HYB_SmCo;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end
end
BestResults{end+1} = BestResult;


% ML & IV_HYB_SmCo
% ----------------
EBeam    = EBeams.ML;
IDTech   = IDTechs.IV_HYB_SmCo;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end
end
BestResults{end+1} = BestResult;

function BestResults = select_SIBIPIRUNA(EBeams, IDTechs)
% SIBIPIRUNA

Energy = 200:1:2200;
Harmonics  = [1 3 5 7 9 11 13 15];
EnergyStep = 1.0;    % eV
BestResults = struct([]);
periods  = (30:1:200) / 1000;
MaxPower = 2 * 1000; % Watts;


%% MS


% MS & PPM
% --------
EBeam    = EBeams.MS;
IDTech   = IDTechs.PPM;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end   
end
BestResults{end+1} = BestResult;

% MS & IV_PPM
% -----------
EBeam    = EBeams.MS;
IDTech   = IDTechs.IV_PPM;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end
end
BestResults{end+1} = BestResult;


% MS & HYB_NdFeB
% --------------
EBeam    = EBeams.MS;   
IDTech   = IDTechs.HYB_NdFeB;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end
end
BestResults{end+1} = BestResult;



% MS & IV_HYB_NdFeB
% -----------------
EBeam    = EBeams.MS;
IDTech   = IDTechs.IV_HYB_NdFeB;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end
end
BestResults{end+1} = BestResult;


% MS & HYB_SmCo
% -------------
EBeam    = EBeams.MS;   
IDTech   = IDTechs.HYB_SmCo;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end
end
BestResults{end+1} = BestResult;


% MS & IV_HYB_SmCo
% ----------------
EBeam    = EBeams.MS;
IDTech   = IDTechs.IV_HYB_SmCo;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end 
end
BestResults{end+1} = BestResult;


%% MM


% MM & PPM
% --------
EBeam    = EBeams.MM;
IDTech   = IDTechs.PPM;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end    
end
BestResults{end+1} = BestResult;

% MM & IV_PPM
% -----------
EBeam    = EBeams.MM;
IDTech   = IDTechs.IV_PPM;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end
end
BestResults{end+1} = BestResult;


% MM & HYB_NdFeB
% --------------
EBeam    = EBeams.MM;   
IDTech   = IDTechs.HYB_NdFeB;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end 
end
BestResults{end+1} = BestResult;


% MM & IV_HYB_NdFeB
% -----------------
EBeam    = EBeams.MM;
IDTech   = IDTechs.IV_HYB_NdFeB;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end
end
BestResults{end+1} = BestResult;


% MM & HYB_SmCo
% -------------
EBeam    = EBeams.MM;   
IDTech   = IDTechs.HYB_SmCo;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end    
end
BestResults{end+1} = BestResult;


% MM & IV_HYB_SmCo
% ----------------
EBeam    = EBeams.MM;
IDTech   = IDTechs.IV_HYB_SmCo;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end
end
BestResults{end+1} = BestResult;



%% ML


% ML & PPM
% --------
EBeam    = EBeams.ML;
IDTech   = IDTechs.PPM;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end    
end
BestResults{end+1} = BestResult;

% ML & IV_PPM
% -----------
EBeam    = EBeams.ML;
IDTech   = IDTechs.IV_PPM;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end
end
BestResults{end+1} = BestResult;


% ML & HYB_NdFeB
% --------------
EBeam    = EBeams.ML;   
IDTech   = IDTechs.HYB_NdFeB;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end
end
BestResults{end+1} = BestResult;


% ML & IV_HYB_NdFeB
% -----------------
EBeam    = EBeams.ML;
IDTech   = IDTechs.IV_HYB_NdFeB;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end   
end
BestResults{end+1} = BestResult;


% ML & HYB_SmCo
% -------------
EBeam    = EBeams.ML;   
IDTech   = IDTechs.HYB_SmCo;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end
end
BestResults{end+1} = BestResult;


% ML & IV_HYB_SmCo
% ----------------
EBeam    = EBeams.ML;
IDTech   = IDTechs.IV_HYB_SmCo;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end
end
BestResults{end+1} = BestResult;

function BestResults = select_ARAUCARIA(EBeams, IDTechs)
% ARAUCARIA

Energy = 50:1:2000;
Harmonics  = [1 3 5 7 9 11 13 15];
EnergyStep = 1.0;    % eV
BestResults = struct([]);
periods  = (10:1:200) / 1000;



%% MS


% MS & PPM
% --------
EBeam    = EBeams.MS;
IDTech   = IDTechs.PPM;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end   
end
BestResults{end+1} = BestResult;

% MS & IV_PPM
% -----------
EBeam    = EBeams.MS;
IDTech   = IDTechs.IV_PPM;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end
end
BestResults{end+1} = BestResult;


% MS & HYB_NdFeB
% --------------
EBeam    = EBeams.MS;   
IDTech   = IDTechs.HYB_NdFeB;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end
end
BestResults{end+1} = BestResult;



% MS & IV_HYB_NdFeB
% -----------------
EBeam    = EBeams.MS;
IDTech   = IDTechs.IV_HYB_NdFeB;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end
end
BestResults{end+1} = BestResult;


% MS & HYB_SmCo
% -------------
EBeam    = EBeams.MS;   
IDTech   = IDTechs.HYB_SmCo;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end
end
BestResults{end+1} = BestResult;


% MS & IV_HYB_SmCo
% ----------------
EBeam    = EBeams.MS;
IDTech   = IDTechs.IV_HYB_SmCo;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end 
end
BestResults{end+1} = BestResult;


%% MM


% MM & PPM
% --------
EBeam    = EBeams.MM;
IDTech   = IDTechs.PPM;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end    
end
BestResults{end+1} = BestResult;

% MM & IV_PPM
% -----------
EBeam    = EBeams.MM;
IDTech   = IDTechs.IV_PPM;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end
end
BestResults{end+1} = BestResult;


% MM & HYB_NdFeB
% --------------
EBeam    = EBeams.MM;   
IDTech   = IDTechs.HYB_NdFeB;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end 
end
BestResults{end+1} = BestResult;


% MM & IV_HYB_NdFeB
% -----------------
EBeam    = EBeams.MM;
IDTech   = IDTechs.IV_HYB_NdFeB;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end
end
BestResults{end+1} = BestResult;


% MM & HYB_SmCo
% -------------
EBeam    = EBeams.MM;   
IDTech   = IDTechs.HYB_SmCo;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end    
end
BestResults{end+1} = BestResult;


% MM & IV_HYB_SmCo
% ----------------
EBeam    = EBeams.MM;
IDTech   = IDTechs.IV_HYB_SmCo;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end
end
BestResults{end+1} = BestResult;



%% ML


% ML & PPM
% --------
EBeam    = EBeams.ML;
IDTech   = IDTechs.PPM;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end    
end
BestResults{end+1} = BestResult;

% ML & IV_PPM
% -----------
EBeam    = EBeams.ML;
IDTech   = IDTechs.IV_PPM;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end
end
BestResults{end+1} = BestResult;


% ML & HYB_NdFeB
% --------------
EBeam    = EBeams.ML;   
IDTech   = IDTechs.HYB_NdFeB;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end
end
BestResults{end+1} = BestResult;


% ML & IV_HYB_NdFeB
% -----------------
EBeam    = EBeams.ML;
IDTech   = IDTechs.IV_HYB_NdFeB;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end   
end
BestResults{end+1} = BestResult;


% ML & HYB_SmCo
% -------------
EBeam    = EBeams.ML;   
IDTech   = IDTechs.HYB_SmCo;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end
end
BestResults{end+1} = BestResult;


% ML & IV_HYB_SmCo
% ----------------
EBeam    = EBeams.ML;
IDTech   = IDTechs.IV_HYB_SmCo;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end
end
BestResults{end+1} = BestResult;


function BestResults = select_INGA(EBeams, IDTechs)
% MANACÁ - CARNAÚBA - Cristalografia de microcristais de proteínas

Energy = 8900:1:9100;
Harmonics  = [1 3 5 7 9 11 13 15];
EnergyStep = 1.0;    % eV
BestResults = struct([]);
periods  = (10:1:200) / 1000;



%% MS


% MS & PPM
% --------
EBeam    = EBeams.MS;
IDTech   = IDTechs.PPM;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end   
end
BestResults{end+1} = BestResult;

% MS & IV_PPM
% -----------
EBeam    = EBeams.MS;
IDTech   = IDTechs.IV_PPM;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end
end
BestResults{end+1} = BestResult;


% MS & HYB_NdFeB
% --------------
EBeam    = EBeams.MS;   
IDTech   = IDTechs.HYB_NdFeB;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end
end
BestResults{end+1} = BestResult;



% MS & IV_HYB_NdFeB
% -----------------
EBeam    = EBeams.MS;
IDTech   = IDTechs.IV_HYB_NdFeB;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end
end
BestResults{end+1} = BestResult;


% MS & HYB_SmCo
% -------------
EBeam    = EBeams.MS;   
IDTech   = IDTechs.HYB_SmCo;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end
end
BestResults{end+1} = BestResult;


% MS & IV_HYB_SmCo
% ----------------
EBeam    = EBeams.MS;
IDTech   = IDTechs.IV_HYB_SmCo;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end 
end
BestResults{end+1} = BestResult;


%% MM


% MM & PPM
% --------
EBeam    = EBeams.MM;
IDTech   = IDTechs.PPM;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end    
end
BestResults{end+1} = BestResult;

% MM & IV_PPM
% -----------
EBeam    = EBeams.MM;
IDTech   = IDTechs.IV_PPM;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end
end
BestResults{end+1} = BestResult;


% MM & HYB_NdFeB
% --------------
EBeam    = EBeams.MM;   
IDTech   = IDTechs.HYB_NdFeB;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end 
end
BestResults{end+1} = BestResult;


% MM & IV_HYB_NdFeB
% -----------------
EBeam    = EBeams.MM;
IDTech   = IDTechs.IV_HYB_NdFeB;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end
end
BestResults{end+1} = BestResult;


% MM & HYB_SmCo
% -------------
EBeam    = EBeams.MM;   
IDTech   = IDTechs.HYB_SmCo;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end    
end
BestResults{end+1} = BestResult;


% MM & IV_HYB_SmCo
% ----------------
EBeam    = EBeams.MM;
IDTech   = IDTechs.IV_HYB_SmCo;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end
end
BestResults{end+1} = BestResult;



%% ML


% ML & PPM
% --------
EBeam    = EBeams.ML;
IDTech   = IDTechs.PPM;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end    
end
BestResults{end+1} = BestResult;

% ML & IV_PPM
% -----------
EBeam    = EBeams.ML;
IDTech   = IDTechs.IV_PPM;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end
end
BestResults{end+1} = BestResult;


% ML & HYB_NdFeB
% --------------
EBeam    = EBeams.ML;   
IDTech   = IDTechs.HYB_NdFeB;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end
end
BestResults{end+1} = BestResult;


% ML & IV_HYB_NdFeB
% -----------------
EBeam    = EBeams.ML;
IDTech   = IDTechs.IV_HYB_NdFeB;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end   
end
BestResults{end+1} = BestResult;


% ML & HYB_SmCo
% -------------
EBeam    = EBeams.ML;   
IDTech   = IDTechs.HYB_SmCo;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end
end
BestResults{end+1} = BestResult;


% ML & IV_HYB_SmCo
% ----------------
EBeam    = EBeams.ML;
IDTech   = IDTechs.IV_HYB_SmCo;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end
end
BestResults{end+1} = BestResult;

function BestResults = select_CARNAUBA(EBeams, IDTechs)
% CARNAÚBA - Nano-difração de raios-X

Energy = 5000:1:30000;
Harmonics  = [1 3 5 7 9 11 13 15];
EnergyStep = 1.0;    % eV
BestResults = struct([]);
periods  = (10:1:100) / 1000;



%% MS


% MS & PPM
% --------
EBeam    = EBeams.MS;
IDTech   = IDTechs.PPM;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end   
end
BestResults{end+1} = BestResult;

% MS & IV_PPM
% -----------
EBeam    = EBeams.MS;
IDTech   = IDTechs.IV_PPM;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end
end
BestResults{end+1} = BestResult;


% MS & HYB_NdFeB
% --------------
EBeam    = EBeams.MS;   
IDTech   = IDTechs.HYB_NdFeB;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end
end
BestResults{end+1} = BestResult;



% MS & IV_HYB_NdFeB
% -----------------
EBeam    = EBeams.MS;
IDTech   = IDTechs.IV_HYB_NdFeB;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end
end
BestResults{end+1} = BestResult;


% MS & HYB_SmCo
% -------------
EBeam    = EBeams.MS;   
IDTech   = IDTechs.HYB_SmCo;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end
end
BestResults{end+1} = BestResult;


% MS & IV_HYB_SmCo
% ----------------
EBeam    = EBeams.MS;
IDTech   = IDTechs.IV_HYB_SmCo;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end 
end
BestResults{end+1} = BestResult;


%% MM


% MM & PPM
% --------
EBeam    = EBeams.MM;
IDTech   = IDTechs.PPM;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end    
end
BestResults{end+1} = BestResult;

% MM & IV_PPM
% -----------
EBeam    = EBeams.MM;
IDTech   = IDTechs.IV_PPM;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end
end
BestResults{end+1} = BestResult;


% MM & HYB_NdFeB
% --------------
EBeam    = EBeams.MM;   
IDTech   = IDTechs.HYB_NdFeB;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end 
end
BestResults{end+1} = BestResult;


% MM & IV_HYB_NdFeB
% -----------------
EBeam    = EBeams.MM;
IDTech   = IDTechs.IV_HYB_NdFeB;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end
end
BestResults{end+1} = BestResult;


% MM & HYB_SmCo
% -------------
EBeam    = EBeams.MM;   
IDTech   = IDTechs.HYB_SmCo;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end    
end
BestResults{end+1} = BestResult;


% MM & IV_HYB_SmCo
% ----------------
EBeam    = EBeams.MM;
IDTech   = IDTechs.IV_HYB_SmCo;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end
end
BestResults{end+1} = BestResult;



%% ML


% ML & PPM
% --------
EBeam    = EBeams.ML;
IDTech   = IDTechs.PPM;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end    
end
BestResults{end+1} = BestResult;

% ML & IV_PPM
% -----------
EBeam    = EBeams.ML;
IDTech   = IDTechs.IV_PPM;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end
end
BestResults{end+1} = BestResult;


% ML & HYB_NdFeB
% --------------
EBeam    = EBeams.ML;   
IDTech   = IDTechs.HYB_NdFeB;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end
end
BestResults{end+1} = BestResult;


% ML & IV_HYB_NdFeB
% -----------------
EBeam    = EBeams.ML;
IDTech   = IDTechs.IV_HYB_NdFeB;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end   
end
BestResults{end+1} = BestResult;


% ML & HYB_SmCo
% -------------
EBeam    = EBeams.ML;   
IDTech   = IDTechs.HYB_SmCo;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end
end
BestResults{end+1} = BestResult;


% ML & IV_HYB_SmCo
% ----------------
EBeam    = EBeams.ML;
IDTech   = IDTechs.IV_HYB_SmCo;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end
end
BestResults{end+1} = BestResult;

function BestResults = select_MANACA(EBeams, IDTechs)
% MANACÁ - CARNAÚBA - Cristalografia de microcristais de proteínas

Energy = 5000:1:20000;
Harmonics  = [1 3 5 7 9 11 13 15];
EnergyStep = 1.0;    % eV
BestResults = struct([]);
periods  = (10:1:100) / 1000;



%% MS


% MS & PPM
% --------
EBeam    = EBeams.MS;
IDTech   = IDTechs.PPM;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end   
end
BestResults{end+1} = BestResult;

% MS & IV_PPM
% -----------
EBeam    = EBeams.MS;
IDTech   = IDTechs.IV_PPM;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end
end
BestResults{end+1} = BestResult;


% MS & HYB_NdFeB
% --------------
EBeam    = EBeams.MS;   
IDTech   = IDTechs.HYB_NdFeB;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end
end
BestResults{end+1} = BestResult;



% MS & IV_HYB_NdFeB
% -----------------
EBeam    = EBeams.MS;
IDTech   = IDTechs.IV_HYB_NdFeB;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end
end
BestResults{end+1} = BestResult;


% MS & HYB_SmCo
% -------------
EBeam    = EBeams.MS;   
IDTech   = IDTechs.HYB_SmCo;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end
end
BestResults{end+1} = BestResult;


% MS & IV_HYB_SmCo
% ----------------
EBeam    = EBeams.MS;
IDTech   = IDTechs.IV_HYB_SmCo;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end 
end
BestResults{end+1} = BestResult;


%% MM


% MM & PPM
% --------
EBeam    = EBeams.MM;
IDTech   = IDTechs.PPM;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end    
end
BestResults{end+1} = BestResult;

% MM & IV_PPM
% -----------
EBeam    = EBeams.MM;
IDTech   = IDTechs.IV_PPM;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end
end
BestResults{end+1} = BestResult;


% MM & HYB_NdFeB
% --------------
EBeam    = EBeams.MM;   
IDTech   = IDTechs.HYB_NdFeB;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end 
end
BestResults{end+1} = BestResult;


% MM & IV_HYB_NdFeB
% -----------------
EBeam    = EBeams.MM;
IDTech   = IDTechs.IV_HYB_NdFeB;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end
end
BestResults{end+1} = BestResult;


% MM & HYB_SmCo
% -------------
EBeam    = EBeams.MM;   
IDTech   = IDTechs.HYB_SmCo;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end    
end
BestResults{end+1} = BestResult;


% MM & IV_HYB_SmCo
% ----------------
EBeam    = EBeams.MM;
IDTech   = IDTechs.IV_HYB_SmCo;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end
end
BestResults{end+1} = BestResult;



%% ML


% ML & PPM
% --------
EBeam    = EBeams.ML;
IDTech   = IDTechs.PPM;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end    
end
BestResults{end+1} = BestResult;

% ML & IV_PPM
% -----------
EBeam    = EBeams.ML;
IDTech   = IDTechs.IV_PPM;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end
end
BestResults{end+1} = BestResult;


% ML & HYB_NdFeB
% --------------
EBeam    = EBeams.ML;   
IDTech   = IDTechs.HYB_NdFeB;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end
end
BestResults{end+1} = BestResult;


% ML & IV_HYB_NdFeB
% -----------------
EBeam    = EBeams.ML;
IDTech   = IDTechs.IV_HYB_NdFeB;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end   
end
BestResults{end+1} = BestResult;


% ML & HYB_SmCo
% -------------
EBeam    = EBeams.ML;   
IDTech   = IDTechs.HYB_SmCo;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end
end
BestResults{end+1} = BestResult;


% ML & IV_HYB_SmCo
% ----------------
EBeam    = EBeams.ML;
IDTech   = IDTechs.IV_HYB_SmCo;
BestResult = {};
fprintf([EBeam.Label ' - ' IDTech.Label '\n']);
for i=1:length(periods)
    lengths = 10*periods(i) : periods(i) : EBeam.Length;
    for j=1:length(lengths)
        ID       = set_ID(EBeam, IDTech, periods(i), lengths(j));
        Spectrum = set_IDSpectrum(EBeam, ID, Harmonics, EnergyStep);
        Results  = SpectrumSummary(Spectrum, Energy);
        if any(Results.Brightness == 0), continue; end;
        if isempty(BestResult) || ((Results.CmpBrightness > BestResult.CmpBrightness) && (max(Spectrum.Power{1}) < MaxPower))
            BestResult = Results;
            fprintf('%06.2f [mm] %4.2f [m]: %E ph/s/0.1/mm^2/mrad^2\n', 1000*periods(i), lengths(j), BestResult.AvgBrightness / 1e12);
        end
    end
end
BestResults{end+1} = BestResult;