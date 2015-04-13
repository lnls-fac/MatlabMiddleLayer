function setquad(QMS, QuadSetpoint, WaitFlag)
%SETQUAD - Set quadrupole setpoint (used by quadcenter)
%
%História
%
%2010-09-13: código fonte com comentários iniciais.
%
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
    setsp(QuadFamily, QuadSetpoint, QuadDev, WaitFlag);
    %Amps = getpv(QuadFamily, 'Setpoint', QuadDev);
    %DeltaAmps = QuadSetpoint - Amps;
    %ShuntDevs = common2dev(dev2common(QuadFamily,QuadDev), 'QUADSHUNT');
    %setsp('QUADSHUNT', DeltaAmps, ShuntDevs, WaitFlag);
end
