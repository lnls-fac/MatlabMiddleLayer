function [AM, tout, DataTime, ErrorFlag] = lnls1_quadget(FamilyName, Field, DeviceList, t)
%LNLS1_QUADGET - Combine reading of quadrupole shunts and families supplies to return values for individual quadrupoles.
%
%História
%
%2010-09-13: código fonte com comentários iniciais.

% Starting time
t0 = clock;

CommonNames  = family2common(FamilyName, DeviceList);
FamilyChannelNames = family2channel(FamilyName, Field, DeviceList);
[ShuntDeviceList, ShuntFamilyName, ErrorFlag] = common2dev(CommonNames, 'QUADSHUNT');

FamilyValues = getpv(FamilyChannelNames);
ShuntValues  = getpv(ShuntFamilyName, Field, ShuntDeviceList); 
ShuntOnOff   = getpv(ShuntFamilyName, 'OnOffSP', ShuntDeviceList); 

shunts_on = find(~(ShuntOnOff == 0));
AM = FamilyValues;
AM(shunts_on) = AM(shunts_on) + ShuntValues(shunts_on);
  
tout = etime(clock, t0);
DataTime = [];
ErrorFlag = 0;