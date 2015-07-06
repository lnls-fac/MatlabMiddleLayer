function rms = calc_rms(residue)
rms = norm(residue)/sqrt(length(residue));