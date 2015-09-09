function [AM, tout, DataTime, ErrorFlag] = sirius_quadget(FamilyName, Field, DeviceList, t)
%SIRIUS_QUADGET - Combine reading of quadrupole shunts and families power supplies to return values for individual quadrupoles.

% Starting time
t0 = clock;

Family = strcat(FamilyName, '_fam');
Shunt  = strcat(FamilyName, '_shunt');

FamilyChannelNames = family2channel(Family, Field, DeviceList);
ShuntChannelNames  = family2channel(Shunt, Field, DeviceList); 

FamilyValues = getpv(FamilyChannelNames);
ShuntValues  = getpv(ShuntChannelNames); 

AM = FamilyValues;
AM = AM + ShuntValues;
  
tout = etime(clock, t0);
DataTime = [];
ErrorFlag = 0;