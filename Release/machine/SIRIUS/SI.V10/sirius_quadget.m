function [AM, tout, DataTime, ErrorFlag] = sirius_quadget(FamilyName, Field, DeviceList, t)
%SIRIUS_QUADGET - Combine reading of quadrupole shunts and families power supplies to return values for individual quadrupoles.

% Starting time
t0 = clock;

FamPS   = strcat(FamilyName, '_fam');
ShuntPS = strcat(FamilyName, '_shunt');

FamilyChannelNames = family2channel(FamPS, Field, DeviceList);
ShuntChannelNames  = family2channel(ShuntPS, Field, DeviceList); 

FamilyValues = getpv(FamilyChannelNames);
ShuntValues  = getpv(ShuntChannelNames); 

AM = FamilyValues + ShuntValues;
  
tout = etime(clock, t0);
DataTime = [];
ErrorFlag = 0;