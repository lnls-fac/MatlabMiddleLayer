function [Data, t, DataTime, ErrorFlag] = getbpmlnls(Family, Field, DeviceList, t)
%GETBPMLNLS - Sets bpm data aquisition, average and point interval parameters
%
%História
%
%2010-09-13: código fonte com comentários iniciais.

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


t = [];
DataTime = [];
ErrorFlag = 0;


