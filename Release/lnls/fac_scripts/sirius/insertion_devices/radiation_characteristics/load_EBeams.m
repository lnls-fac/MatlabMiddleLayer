function EBeams = load_EBeams(Params)

global THERING;

if isempty(THERING)
    if exist('THERING.mat', 'file')
        THERING = load('THERING.mat');
    else
        sirius;
    end
end

spacing = Params.Spacing;
vertical_acceptance = Params.VerticalAcceptance;
current = Params.BeamCurrent;
coupling = Params.Coupling;


ats = atsummary;
calctwiss;

% 
% ms = findcells(THERING, 'FamName', 'ms');
% twiss = THERING{ms(1)}.Twiss;
% EBeams.MS.Params    = Params;
% EBeams.MS.Label     = 'ms';
% EBeams.MS.Emittance = ats.naturalEmittance;
% EBeams.MS.SigmaE    = ats.naturalEnergySpread;
% EBeams.MS.Coupling  = coupling;
% EBeams.MS.E         = ats.e0;
% EBeams.MS.I         = current;
% EBeams.MS.AlphaX    = twiss.alpha(1);
% EBeams.MS.AlphaY    = twiss.alpha(2);
% EBeams.MS.BetaX     = twiss.beta(1);
% EBeams.MS.BetaY     = twiss.beta(2);
% EBeams.MS.EtaX      = twiss.Dispersion(1);
% EBeams.MS.EtaXl     = twiss.Dispersion(2);
% EBeams.MS.SigmaX    = sqrt(EBeams.MS.Emittance * EBeams.MS.BetaX + (EBeams.MS.SigmaE * EBeams.MS.EtaX)^2);
% EBeams.MS.SigmaY    = sqrt(EBeams.MS.Emittance * EBeams.MS.BetaY * EBeams.MS.Coupling);
% EBeams.MS.SigmaXl   = sqrt(EBeams.MS.Emittance * ((1 + EBeams.MS.AlphaX^2)/EBeams.MS.BetaX) + (EBeams.MS.SigmaE * EBeams.MS.EtaXl)^2);
% EBeams.MS.SigmaYl   = sqrt(EBeams.MS.Emittance * ((1 + EBeams.MS.AlphaY^2)/EBeams.MS.BetaY) * EBeams.MS.Coupling);
% EBeams.MS.MinGap    = 2*sqrt(twiss.beta(2) * vertical_acceptance);
% idx = ms(1);
% i = idx; while (any(strcmpi(THERING{i}.PassMethod, {'DriftPass', 'IdentityPass'}))), i = i + 1; end;
% EBeams.MS.Length    = 2 * (THERING{i}.Twiss.SPos - THERING{idx}.Twiss.SPos - spacing);
% 
% 
% ms = findcells(THERING, 'FamName', 'mm');
% twiss = THERING{ms(1)}.Twiss;
% EBeams.MM.Label     = 'mm';
% EBeams.MM.Params    = Params;
% EBeams.MM.Emittance = ats.naturalEmittance;
% EBeams.MM.SigmaE    = ats.naturalEnergySpread;
% EBeams.MM.Coupling  = coupling;
% EBeams.MM.E         = ats.e0;
% EBeams.MM.I         = current;
% EBeams.MM.AlphaX    = twiss.alpha(1);
% EBeams.MM.AlphaY    = twiss.alpha(2);
% EBeams.MM.BetaX     = twiss.beta(1);
% EBeams.MM.BetaY     = twiss.beta(2);
% EBeams.MM.EtaX      = twiss.Dispersion(1);
% EBeams.MM.EtaXl     = twiss.Dispersion(2);
% EBeams.MM.SigmaX    = sqrt(EBeams.MM.Emittance * EBeams.MM.BetaX + (EBeams.MM.SigmaE * EBeams.MM.EtaX)^2);
% EBeams.MM.SigmaY    = sqrt(EBeams.MM.Emittance * EBeams.MM.BetaY * EBeams.MM.Coupling);
% EBeams.MM.SigmaXl   = sqrt(EBeams.MM.Emittance * ((1 + EBeams.MM.AlphaX^2)/EBeams.MM.BetaX) + (EBeams.MM.SigmaE * EBeams.MM.EtaXl)^2);
% EBeams.MM.SigmaYl   = sqrt(EBeams.MM.Emittance * ((1 + EBeams.MM.AlphaY^2)/EBeams.MM.BetaY) * EBeams.MM.Coupling);
% EBeams.MM.MinGap    = 2*sqrt(twiss.beta(2) * vertical_acceptance);
% idx = ms(1);
% i = idx; while (any(strcmpi(THERING{i}.PassMethod, {'DriftPass', 'IdentityPass'}))), i = i + 1; end;
% EBeams.MM.Length    = 2 * (THERING{i}.Twiss.SPos - THERING{idx}.Twiss.SPos - spacing);


ms = findcells(THERING, 'FamName', 'mia');
twiss = THERING{ms(1)}.Twiss;
EBeams.MIA.Label     = 'mia';
EBeams.MIA.Params    = Params;
EBeams.MIA.Emittance = ats.naturalEmittance;
EBeams.MIA.SigmaE    = ats.naturalEnergySpread;
EBeams.MIA.Coupling  = coupling;
EBeams.MIA.E         = ats.e0;
EBeams.MIA.I         = current;
EBeams.MIA.AlphaX    = twiss.alpha(1);
EBeams.MIA.AlphaY    = twiss.alpha(2);
EBeams.MIA.BetaX     = twiss.beta(1);
EBeams.MIA.BetaY     = twiss.beta(2);
EBeams.MIA.EtaX      = twiss.Dispersion(1);
EBeams.MIA.EtaXl     = twiss.Dispersion(2);
EBeams.MIA.SigmaX    = sqrt(EBeams.MIA.Emittance * EBeams.MIA.BetaX + (EBeams.MIA.SigmaE * EBeams.MIA.EtaX)^2);
EBeams.MIA.SigmaY    = sqrt(EBeams.MIA.Emittance * EBeams.MIA.BetaY * EBeams.MIA.Coupling);
EBeams.MIA.SigmaXl   = sqrt(EBeams.MIA.Emittance * ((1 + EBeams.MIA.AlphaX^2)/EBeams.MIA.BetaX) + (EBeams.MIA.SigmaE * EBeams.MIA.EtaXl)^2);
EBeams.MIA.SigmaYl   = sqrt(EBeams.MIA.Emittance * ((1 + EBeams.MIA.AlphaY^2)/EBeams.MIA.BetaY) * EBeams.MIA.Coupling);
EBeams.MIA.MinGap    = 2*sqrt(twiss.beta(2) * vertical_acceptance);
idx = ms(1);
i = idx; while (any(strcmpi(THERING{i}.PassMethod, {'DriftPass', 'IdentityPass'}))), i = i + 1; end;
EBeams.MIA.Length    = 2 * (THERING{i}.Twiss.SPos - THERING{idx}.Twiss.SPos - spacing);

ms = findcells(THERING, 'FamName', 'mc');
twiss = THERING{ms(1)}.Twiss;
EBeams.MC.Label     = 'mc';
EBeams.MC.Params    = Params;
EBeams.MC.Emittance = ats.naturalEmittance;
EBeams.MC.SigmaE    = ats.naturalEnergySpread;
EBeams.MC.Coupling  = coupling;
EBeams.MC.E         = ats.e0;
EBeams.MC.I         = current;
EBeams.MC.AlphaX    = twiss.alpha(1);
EBeams.MC.AlphaY    = twiss.alpha(2);
EBeams.MC.BetaX     = twiss.beta(1);
EBeams.MC.BetaY     = twiss.beta(2);
EBeams.MC.EtaX      = twiss.Dispersion(1);
EBeams.MC.EtaXl     = twiss.Dispersion(2);
EBeams.MC.SigmaX    = sqrt(EBeams.MC.Emittance * EBeams.MC.BetaX + (EBeams.MC.SigmaE * EBeams.MC.EtaX)^2);
EBeams.MC.SigmaY    = sqrt(EBeams.MC.Emittance * EBeams.MC.BetaY * EBeams.MC.Coupling);
EBeams.MC.SigmaXl   = sqrt(EBeams.MC.Emittance * ((1 + EBeams.MC.AlphaX^2)/EBeams.MC.BetaX) + (EBeams.MC.SigmaE * EBeams.MC.EtaXl)^2);
EBeams.MC.SigmaYl   = sqrt(EBeams.MC.Emittance * ((1 + EBeams.MC.AlphaY^2)/EBeams.MC.BetaY) * EBeams.MC.Coupling);
EBeams.MC.MinGap    = 2*sqrt(twiss.beta(2) * vertical_acceptance);


EBeams.NSLS2.Label     = 'NSLS2';
EBeams.NSLS2.Params    = Params;
EBeams.NSLS2.Emittance = 0.55e-9;
EBeams.NSLS2.SigmaE    = 0.05 / 100;
EBeams.NSLS2.Coupling  = coupling;
EBeams.NSLS2.E         = ats.e0;
EBeams.NSLS2.I         = current;
EBeams.NSLS2.AlphaX    = 0;
EBeams.NSLS2.AlphaY    = 0;
EBeams.NSLS2.BetaX     = 2;
EBeams.NSLS2.BetaY     = 1;
EBeams.NSLS2.EtaX      = 0;
EBeams.NSLS2.EtaXl     = 0;
EBeams.NSLS2.SigmaX    = sqrt(EBeams.NSLS2.Emittance * EBeams.NSLS2.BetaX + (EBeams.NSLS2.SigmaE * EBeams.NSLS2.EtaX)^2);
EBeams.NSLS2.SigmaY    = sqrt(EBeams.NSLS2.Emittance * EBeams.NSLS2.BetaY * EBeams.NSLS2.Coupling);
EBeams.NSLS2.SigmaXl   = sqrt(EBeams.NSLS2.Emittance * ((1 + EBeams.NSLS2.AlphaX^2)/EBeams.NSLS2.BetaX) + (EBeams.NSLS2.SigmaE * EBeams.NSLS2.EtaXl)^2);
EBeams.NSLS2.SigmaYl   = sqrt(EBeams.NSLS2.Emittance * ((1 + EBeams.NSLS2.AlphaY^2)/EBeams.NSLS2.BetaY) * EBeams.NSLS2.Coupling);
EBeams.NSLS2.MinGap    = 2*sqrt(twiss.beta(2) * vertical_acceptance);
EBeams.NSLS2.Length    = 10;




% Calcula fator Gamma
fnames = fieldnames(EBeams);
for i=1:length(fnames)
    [beta EBeams.(fnames{i}).Gamma b_rho] = lnls_beta_gamma(EBeams.(fnames{i}).E);
end