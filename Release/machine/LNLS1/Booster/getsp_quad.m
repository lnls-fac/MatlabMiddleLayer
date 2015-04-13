function [Amps, t, DataTime, ErrorFlag] = getsp_quad(Family, Field, DeviceList, t)

if nargin < 1
    error('Must have at least 1 input (Family, Data Structure, or Channel Name).');
end


FamiliesChannelNames = lnls1_getname([Family '_Families'], Field, DeviceList);
ShuntsChannelNames   = lnls1_getname([Family '_Shunts'], Field, DeviceList);
quads = dev2elem(Family, DeviceList);
SP_Families = getam(FamiliesChannelNames(quads,:)); 
SP_Shunts = getam(ShuntsChannelNames(quads,:));
Amps = SP_Families + SP_Shunts;
t = [];
DataTime = [];
ErrorFlag = 0;


