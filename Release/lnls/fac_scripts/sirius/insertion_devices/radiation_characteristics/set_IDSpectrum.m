function Spectrum = set_IDSpectrum(EBeam, ID, Harms, EnergyStep)

Spectrum.Harmonic   = {};
Spectrum.Energy     = {};
Spectrum.K          = {};
Spectrum.B          = {};
Spectrum.Gap        = {};
Spectrum.Lambda     = {};
Spectrum.Emittance  = {};
Spectrum.Flux       = {};
Spectrum.Brightness = {};
Spectrum.SigmaR     = {};
Spectrum.SigmaRl    = {};
Spectrum.SigmaX     = {};  
Spectrum.SigmaXl    = {};
Spectrum.SigmaY     = {};
Spectrum.SigmaYl    = {};
Spectrum.Power      = {};
Spectrum.CoherentFlux = {};
    
Spectrum.EBeam = EBeam;
Spectrum.ID    = ID;

for i=1:length(Harms)
    
    MinEnergy = Harms(i) * calc_E1(EBeam.E, ID.Period, ID.KMax);
    MaxEnergy = Harms(i) * calc_E1(EBeam.E, ID.Period, 0);
    npts = max([2 ceil((MaxEnergy - MinEnergy) / EnergyStep)]);
    Energy = linspace(MinEnergy, MaxEnergy, npts);
    K = calc_K_from_E(EBeam.E, ID.Period, Harms(i), Energy);
    B = calc_B_from_K(K,ID.Period);
    Gap = calc_G_from_B(B, ID.Period, ID.Tech);
    sel = isnan(Gap);
    if length(find(~sel)) < 2, sel = isnan(NaN * Gap); end;
    Energy(sel) = [];
    K(sel) = []; 
    B(sel) = []; 
    Gap(sel) = [];
    Power   = 632.8 * EBeam.E^2 * B.^2 * ID.Length * EBeam.I;
    Lambda  = calc_PhotonLambda_from_K(EBeam.Gamma, ID.Period, K);
    SigmaR  = calc_sigmar(ID.Length, Lambda);
    SigmaRl = calc_sigmarl(ID.Length, Lambda);
    SigmaX  = sqrt(SigmaR.^2 + EBeam.SigmaX.^2);
    SigmaXl = sqrt(SigmaRl.^2 + EBeam.SigmaXl.^2);
    SigmaY  = sqrt(SigmaR.^2 + EBeam.SigmaY.^2);
    SigmaYl = sqrt(SigmaRl.^2 + EBeam.SigmaYl.^2);
    Emittance  = calc_photon_emittance(EBeam,SigmaR,SigmaRl);
    factor     = exp(-(Harms(i) * ID.Tech.PhaseError)^2);
    Flux       = factor * calc_flux(ID.N, EBeam.I, Harms(i), K);
    CoherentFlux = (Lambda / (4*pi)).^2 ./ (Emittance / (2*pi)^2) .* Flux;
    Brightness = Flux ./ Emittance;
   
    Spectrum.Harmonic{end+1}   = Harms(i);
    Spectrum.Energy{end+1}     = Energy;
    Spectrum.K{end+1}          = K;
    Spectrum.B{end+1}          = B;
    Spectrum.SigmaR{end+1}     = SigmaR;
    Spectrum.SigmaRl{end+1}    = SigmaRl;
    Spectrum.SigmaX{end+1}     = SigmaX;
    Spectrum.SigmaXl{end+1}    = SigmaXl;
    Spectrum.SigmaY{end+1}     = SigmaY;
    Spectrum.SigmaYl{end+1}    = SigmaYl;
    Spectrum.Gap{end+1}        = Gap;
    Spectrum.Lambda{end+1}     = Lambda;
    Spectrum.Emittance{end+1}  = Emittance;
    Spectrum.Flux{end+1}       = Flux;
    Spectrum.CoherentFlux{end+1} = CoherentFlux;
    Spectrum.Brightness{end+1} = Brightness;
    Spectrum.Power{end+1}      = Power;
    
end