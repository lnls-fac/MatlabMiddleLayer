function [AM, tout, DataTime, ErrorFlag] = lnls1getepu(FamilyName, Field, DeviceList, t)


tout = [];
DataTime = [];
ErrorFlag = 0;

gap1 = getam('AON11_GAP1_AM');
gap2 = getam('AON11_GAP2_AM');
AM = mean([gap1 gap2]);