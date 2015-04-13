function setquad(QMS, QuadSetpoint, WaitFlag)
%SETQUAD - Set quadrupole setpoint (used by quadcenter)
%  setquad(QMS, QuadSetpoint, WaitFlag)
%
%  See also getquad, quadcenter
%  by Ximenes Resende


if nargin < 2
    error('At least 2 inputs required');
end
if nargin < 3
    WaitFlag = -2;
end

QuadFamily = QMS.QuadFamily;
QuadDev    = QMS.QuadDev;

Mode = getfamilydata(QuadFamily,'Setpoint','Mode');

if strcmpi(Mode,'Simulator')
    % Simulator
    setsp(QuadFamily, QuadSetpoint, QuadDev, WaitFlag);
else
    % Online
    FamiliesChannelNames = lnls1_getname([QuadFamily '_Families'], 'Setpoint', QuadDev);
    ShuntsChannelNames   = lnls1_getname([QuadFamily '_Shunts'], 'Setpoint', QuadDev);
    quads = dev2elem(QuadFamily, QuadDev);
    SP_Families = getam(FamiliesChannelNames(quads,:));
    New_SP_Shunts = QuadSetpoint - SP_Families;
    setsp(ShuntsChannelNames(quads,:), New_SP_Shunts, WaitFlag);   
%    setsp(QuadFamily, QuadSetpoint, QuadDev, WaitFlag);
end
