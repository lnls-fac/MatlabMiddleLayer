function sigma = calc_photon_emittance(EBeam,SigmaR,SigmaRl)

% J. Clarke, pg. 76 e 77

Sx  = sqrt(EBeam.SigmaX.^2 + SigmaR.^2);
Sy  = sqrt(EBeam.SigmaY.^2 + SigmaR.^2);
Sxl = sqrt(EBeam.SigmaXl.^2 + SigmaRl.^2);
Syl = sqrt(EBeam.SigmaYl.^2 + SigmaRl.^2);
sigma = 4 * pi^2 * Sx .* Sy .* Sxl .* Syl;