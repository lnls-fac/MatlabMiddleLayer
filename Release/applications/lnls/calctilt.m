function Tilt = calctilt(RadiationElemIndex)
% Calculates tilt of the AT model
%
%  Tilt = calctilt
%
%  OUTPUTS
%  1. Tilt - Tilts of the emittance ellipse [radian]
%
%  Written by James Safranek
%             X. Resende


global THERING



%ati = atindex(THERING);
%L0 = findspos(THERING, length(THERING)+1);

% HarmNumber = 936;
% THERING{ati.RF}.Frequency = HarmNumber*C0/L0;
% THERING{ati.RF}.PassMethod = 'CavityPass';
% for i = ati.RF
%     THERING{i}.Frequency = THERING{i}.HarmNumber*C0/L0;
%     THERING{i}.PassMethod = 'CavityPass';
% end


[PassMethod, ATIndex, FamName, PassMethodOld, ATIndexOld, FamNameOld] = setradiation('On');

CavityState = getcavity;
setcavity('On');



%RadiationElemIndex(find(isnan(RadiationElemIndex))) = [];

[ENV, DP, DL] = ohmienvelope(THERING, RadiationElemIndex, 1:length(THERING)+1);

Tilt = cat(2, ENV.Tilt);


% The the passmethods back
setpassmethod(ATIndexOld, PassMethodOld);
setcavity(CavityState);