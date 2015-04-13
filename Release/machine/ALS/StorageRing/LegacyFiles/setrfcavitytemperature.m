function  setrfcavitytemperature(T, T2)
% setrfcavitytemperature(T)
%           or
% setrfcavitytemperature(T1, T2)
%
%   T(1,1) = storage ring RF water temperature for cavity #1 (degrees C)
%   T(2,1) = storage ring RF water temperature for cavity #2 (degrees C)
%

scaput('SR03S___C1TEMP_AC00', T(1));
if nargin > 1
   scaput('SR03S___C2TEMP_AC00', T2(1));
else
   scaput('SR03S___C2TEMP_AC00', T(2));
end
