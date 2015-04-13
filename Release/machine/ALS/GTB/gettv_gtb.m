function [AM, tout, DataTime, ErrorFlag] = gettv_ltb(Family, Field, DeviceList, varargin)
% [AM, tout, DataTime, ErrorFlag] = gettv_ltb(Family, Field, DeviceList, t, FreshDataFlag, TimeOutPeriod)
%

ChannelName = family2channel(Family, Field, DeviceList);
[AM, tout, DataTime, ErrorFlag] = getpv(ChannelName, varargin{:});


