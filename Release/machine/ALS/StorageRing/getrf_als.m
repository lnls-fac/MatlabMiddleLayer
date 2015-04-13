function [AM, tout, DataTime, ErrorFlag] = getrf_als(Family, Field, DeviceList, varargin)
% [AM, tout, DataTime, ErrorFlag] = getrf_als(Family, Field, DeviceList, t, FreshDataFlag, TimeOutPeriod)
%


[AM, tout, DataTime, ErrorFlag] = getpv('SR01C___FREQB__AM00', varargin{:});


