function ErrorFlag = sirius_quadset(FamilyName, Field, AM, DeviceList, WaitFlag)
%SIRIUS_QUADGET - Decompose values of magnet excitation of individual quadrupoles into families and shunts power supply values.
%
%Hist�ria
%
%2015-09-09

FamPS   = strcat(FamilyName, '_fam');
ShuntPS = strcat(FamilyName, '_shunt');

AM = AM(:);

newFamValues   = mean(AM);
newShuntValues = AM - newFamValues;

setpv(FamPS, Field, newFamValue);
setpv(ShuntPS, Field, newShuntValues, DeviceList);

if ~isempty(WaitFlag) && WaitFlag>0,  pause(WaitFlag); end

return;
