function [Data, t, DataTime, ErrorFlag] = getbpmlnls(Family, Field, DeviceList, t)

if nargin < 1
    error('Must have at least 1 input (Family, Data Structure, or Channel Name).');
end

[N,T] = getbpmaverages; 

ChannelNames = lnls1_getname(Family, Field, DeviceList);
Data = zeros(size(ChannelNames,1),N);
for i=1:N
    Data(:,i) = getam(ChannelNames); 
    sleep(T);
end
Data = median(Data,2);

%DeviceListTotal = family2dev(Family,0);
%DeviceList = family2dev(Family);
%iGood = findrowindex(DeviceList, DeviceListTotal);
%Data = Data(iGood);

t = [];
DataTime = [];
ErrorFlag = 0;


