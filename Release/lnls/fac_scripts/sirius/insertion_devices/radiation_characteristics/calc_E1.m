function e = calc_E1(BeamEnergy,Period,K)

e0 = 949.6342; % eV
e  = e0 * BeamEnergy^2 ./ ((Period*100) * (1 + K.^2/2));