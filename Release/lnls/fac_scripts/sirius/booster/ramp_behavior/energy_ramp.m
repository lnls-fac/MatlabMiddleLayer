function [gamat dgamatdt] = energy_ramp(gamainf, gama0, freq, dt)

gamat = (gamainf + gama0)/2 + (gamainf-gama0)/2*cos(2*pi*freq*dt - pi);
dgamatdt = -(gamainf-gama0)/2*2*pi*freq*sin(2*pi*freq*dt - pi);