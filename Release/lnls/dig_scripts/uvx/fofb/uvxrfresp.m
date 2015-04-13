function uvxrfresp

frf = getrf;

setrf(frf-deltarf/2);   pause(3);
setrf(frf+deltarf/2);   pause(3);
setrf(frf);             pause(0.1);
