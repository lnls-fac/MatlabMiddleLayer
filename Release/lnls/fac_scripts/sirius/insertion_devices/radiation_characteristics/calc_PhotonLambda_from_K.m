function PhotonLambda = calc_PhotonLambda_from_K(RelGamma, Period, K)

PhotonLambda = Period * (1 + K.^2/2) / (2*RelGamma^2);