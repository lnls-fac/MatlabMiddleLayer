function K = calc_K_from_E(BeamEnergy,Period,Harmonic,E)

e0 = 949.6342; % eV
K  = sqrt(2*(e0*BeamEnergy^2./((E/Harmonic) * (Period*100)) - 1));