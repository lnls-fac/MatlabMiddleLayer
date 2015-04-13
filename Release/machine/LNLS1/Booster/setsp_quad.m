function ErrorFlag = setsp_quad(Family, Field, Amps, DeviceList, WaitFlag)

FamiliesChannelNames = lnls1_getname([Family '_Families'], Field, DeviceList);
ShuntsChannelNames   = lnls1_getname([Family '_Shunts'], Field, DeviceList);
quads = dev2elem(Family, DeviceList);
SP_Shunts = getam(ShuntsChannelNames(quads,:));
New_SP_Families = Amps - SP_Shunts;
setsp(FamiliesChannelNames(quads,:), New_SP_Families);

% Add a delay based on the WaitFlag
if WaitFlag > 0
    sleep(WaitFlag);
end

ErrorFlag = 0;