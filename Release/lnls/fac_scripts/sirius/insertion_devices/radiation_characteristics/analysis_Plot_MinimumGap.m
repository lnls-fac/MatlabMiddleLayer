function analysis_Plot_MinimumGap

m       = 1;
mm      = 0.001 * m; % m
mrad    = 0.001; % rad
percent = 0.01;
degree  = pi/180;
mA      = 0.001;
Tesla   = 1;

Params.VerticalAcceptance = 5.77 * mm * mrad;
Params.Spacing     = 0.3 * m;
Params.BeamCurrent = 500 * mA;
Params.Coupling    = 0.5 * percent;
Params.VaccumChamberThickness = 1.0 * mm;
Params.VaccumChamberTolerance = 0.5 * mm;
Params.PhaseError             = 1.0 * degree;
Params.MaxBr                  = 1.24 * Tesla;


EBeams = load_EBeams(Params);
IDTechs = load_ID_Technologies(Params);

plot_minimum_gap(EBeams, IDTechs);


function plot_minimum_gap(EBeams, IDTechs)




figure; hold all;
labels = {};

EBeam = EBeams.MS;
IDTech = IDTechs.PPM;
lengths = linspace(0.1, EBeam.Length, 500);
gaps = zeros(1,length(lengths));
for i=1:length(lengths)
    ID = set_ID2(EBeam, IDTech, NaN, lengths(i));
    gaps(1,i) = ID.MinGap;
end
plot(lengths, 1000 * gaps);
labels{end+1} = 'OutVac @ MS';

EBeam = EBeams.MM;
IDTech = IDTechs.PPM;
lengths = linspace(0.1, EBeam.Length, 500);
gaps = zeros(1,length(lengths));
for i=1:length(lengths)
    ID = set_ID2(EBeam, IDTech, NaN, lengths(i));
    gaps(1,i) = ID.MinGap;
end
plot(lengths, 1000 * gaps);
labels{end+1} = 'OutVac @ MM';

EBeam = EBeams.ML;
IDTech = IDTechs.PPM;
lengths = linspace(0.1, EBeam.Length, 500);
gaps = zeros(1,length(lengths));
for i=1:length(lengths)
    ID = set_ID2(EBeam, IDTech, NaN, lengths(i));
    gaps(1,i) = ID.MinGap;
end
plot(lengths, 1000 * gaps);
labels{end+1} = 'OutVac @ ML';



EBeam = EBeams.MS;
IDTech = IDTechs.IV_PPM;
lengths = linspace(0.1, EBeam.Length, 500);
gaps = zeros(1,length(lengths));
for i=1:length(lengths)
    ID = set_ID2(EBeam, IDTech, NaN, lengths(i));
    gaps(1,i) = ID.MinGap;
end
plot(lengths, 1000 * gaps);
labels{end+1} = 'InVac @ MS';

EBeam = EBeams.MM;
IDTech = IDTechs.IV_PPM;
lengths = linspace(0.1, EBeam.Length, 500);
gaps = zeros(1,length(lengths));
for i=1:length(lengths)
    ID = set_ID2(EBeam, IDTech, NaN, lengths(i));
    gaps(1,i) = ID.MinGap;
end
plot(lengths, 1000 * gaps);
labels{end+1} = 'InVac @ MM';

EBeam = EBeams.ML;
IDTech = IDTechs.IV_PPM;
lengths = linspace(0.1, EBeam.Length, 500);
gaps = zeros(1,length(lengths));
for i=1:length(lengths)
    ID = set_ID2(EBeam, IDTech, NaN, lengths(i));
    gaps(1,i) = ID.MinGap;
end
plot(lengths, 1000 * gaps);
labels{end+1} = 'InVac @ ML';

legend(labels);


function ID = set_ID2(EBeam, IDTech, Period, Length)

ID.Period     = Period;
ID.Length     = Length;
ID.N          = ID.Length / ID.Period;
ID.MinGap     = 2 * (IDTech.ChamberThickness + IDTech.ChamberTolerance) + EBeam.MinGap * sqrt(1+(ID.Length/2/EBeam.BetaY)^2);
ID.Tech       = IDTech;