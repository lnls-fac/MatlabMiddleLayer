function aoinit(SubMachineName)
%AOINIT - Initialization function for the Matlab Middle Layer for the NSLS-II storage ring


ModeNumber =1;
OperationalMode = 'Simulator';
setao([]);   %clear previous AcceleratorObjects


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Build MML Family Structure %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%
% BPM %
%%%%%%%
AO.BPMx.FamilyName = 'BPMx';
AO.BPMx.MemberOf   = {'PlotFamily'; 'BPM'; 'Diagnostics'; 'BPMx'; 'HBPM'};
AO.BPMx.DeviceList = [];
AO.BPMx.ElementList = [];
AO.BPMx.Status = [];

AO.BPMx.Monitor.Mode = OperationalMode;
AO.BPMx.Monitor.DataType = 'Scalar';
AO.BPMx.Monitor.ChannelNames  = '';
AO.BPMx.Monitor.Units = 'Hardware';
AO.BPMx.Monitor.HWUnits          = 'mm';
AO.BPMx.Monitor.PhysicsUnits     = 'm';
AO.BPMx.Monitor.HW2PhysicsParams = 1e-3;
AO.BPMx.Monitor.Physics2HWParams = 1e+3;


AO.BPMy.FamilyName = 'BPMy';
AO.BPMy.MemberOf   = {'PlotFamily'; 'BPM'; 'Diagnostics'; 'BPMy'; 'VBPM'};
AO.BPMy.DeviceList = [];
AO.BPMy.ElementList = [];
AO.BPMy.Status = [];

AO.BPMy.Monitor.Mode = OperationalMode;
AO.BPMy.Monitor.DataType = 'Scalar';
AO.BPMy.Monitor.ChannelNames  = '';
AO.BPMy.Monitor.Units = 'Hardware';
AO.BPMy.Monitor.HWUnits          = 'mm';
AO.BPMy.Monitor.PhysicsUnits     = 'm';
AO.BPMy.Monitor.HW2PhysicsParams = 1e-3;
AO.BPMy.Monitor.Physics2HWParams = 1e+3;

%Load data into fields
for i=1:30 % number of superperiods
    for j=1:6 % six correctors per cell
        k=j+6*(i-1);
        AO.BPMx.Monitor.ChannelNames(k,:)  = [ 'r' num2str(i,'%02.2d') 'bpm' num2str(j,'%01.1d') 'x:am'];
        AO.BPMy.Monitor.ChannelNames(k,:)  = [ 'r' num2str(i,'%02.2d') 'bpm' num2str(j,'%01.1d') 'y:am'];
        AO.BPMx.DeviceList(k,:)               = [ i j ];
        AO.BPMy.DeviceList(k,:)               = [ i j ];
        AO.BPMx.ElementList(k,1)              = k;
        AO.BPMy.ElementList(k,1)              = k;
        %if (j==4) || (j==8) || (j==9)
        %    AO.BPMx.Status(k,1) = 0; % no BPMs in center of arc and for IDs
        %    AO.BPMy.Status(k,1) = 0;
        %else
        AO.BPMx.Status(k,1) = 1;
        AO.BPMy.Status(k,1) = 1;
        %end
        AO.BPMx.CommonNames(k,:)           = [ 'r' num2str(i,'%02.2d') 'bpm' num2str(j,'%01.1d') 'x'];
        AO.BPMy.CommonNames(k,:)           = [ 'r' num2str(i,'%02.2d') 'bpm' num2str(j,'%01.1d') 'y'];
    end
end


% Correctors %
AO.HCM.FamilyName             = 'HCM';
AO.HCM.MemberOf               = {'MachineConfig'; 'PlotFamily';  'COR'; 'HCM'; 'Magnet'};
AO.HCM.DeviceList = [];
AO.HCM.ElementList = [];
AO.HCM.Status = [];

AO.HCM.Monitor.Mode           = OperationalMode;
AO.HCM.Monitor.DataType       = 'Scalar';
AO.HCM.Monitor.ChannelNames   = '';
AO.HCM.Monitor.Units          = 'Hardware';
AO.HCM.Monitor.HWUnits        = 'A';
AO.HCM.Monitor.PhysicsUnits   = 'rad';
%AO.HCM.Monitor.HW2PhysicsFcn  = @amp2k;
%AO.HCM.Monitor.Physics2HWFcn  = @k2amp;

AO.HCM.Setpoint.Mode          = OperationalMode;
AO.HCM.Setpoint.DataType      = 'Scalar';
AO.HCM.Setpoint.ChannelNames  = '';
AO.HCM.Setpoint.Units         = 'Hardware';
AO.HCM.Setpoint.HWUnits       = 'A';
AO.HCM.Setpoint.PhysicsUnits  = 'rad';
%AO.HCM.Setpoint.HW2PhysicsFcn = @amp2k;
%AO.HCM.Setpoint.Physics2HWFcn = @k2amp;

AO.VCM.FamilyName             = 'VCM';
AO.VCM.MemberOf               = {'MachineConfig'; 'PlotFamily';  'COR'; 'VCM'; 'Magnet'};
AO.VCM.DeviceList = [];
AO.VCM.ElementList = [];
AO.VCM.Status = [];

AO.VCM.Monitor.Mode           = OperationalMode;
AO.VCM.Monitor.DataType       = 'Scalar';
AO.VCM.Monitor.ChannelNames   = '';
AO.VCM.Monitor.Units          = 'Hardware';
AO.VCM.Monitor.HWUnits        = 'A';
AO.VCM.Monitor.PhysicsUnits   = 'rad';
%AO.VCM.Monitor.HW2PhysicsFcn  = @amp2k;
%AO.VCM.Monitor.Physics2HWFcn  = @k2amp;

AO.VCM.Setpoint.Mode          = OperationalMode;
AO.VCM.Setpoint.DataType      = 'Scalar';
AO.VCM.Setpoint.ChannelNames  = '';
AO.VCM.Setpoint.Units         = 'Hardware';
AO.VCM.Setpoint.HWUnits       = 'A';
AO.VCM.Setpoint.PhysicsUnits  = 'rad';
%AO.VCM.Setpoint.HW2PhysicsFcn = @amp2k;
%AO.VCM.Setpoint.Physics2HWFcn = @k2amp;

CMrange = 10.0;   % [A]
CMgain  = 0.8e-4; % [rad/A]
RMkick  = 2*0.5;  % Kick size for orbit response matrix measurement [A]
CMtol   = 0.010;  % Tolerance [A]

for i=1:30 % number of superperiods
    for j=1:6 % six correctors per cell
        k=j+6*(i-1);
        AO.HCM.Monitor.ChannelNames(k,:)  = sprintf('r%02.2dcm%01.1dx:am',i,j);
        AO.VCM.Monitor.ChannelNames(k,:)  = [ 'r' num2str(i,'%02.2d') 'cm' num2str(j,'%01.1d') 'y:am'];
        AO.HCM.Setpoint.ChannelNames(k,:) = [ 'r' num2str(i,'%02.2d') 'cm' num2str(j,'%01.1d') 'x:sp'];
        AO.VCM.Setpoint.ChannelNames(k,:) = [ 'r' num2str(i,'%02.2d') 'cm' num2str(j,'%01.1d') 'y:sp'];
        AO.HCM.DeviceList(k,:)               = [ i j ];
        AO.VCM.DeviceList(k,:)               = [ i j ];
        AO.HCM.ElementList(k,1)              = k;
        AO.VCM.ElementList(k,1)              = k;
        AO.HCM.Status(k,1) = 1;
        AO.VCM.Status(k,1) = 1;
        AO.HCM.Setpoint.Range(k,:)            = [-CMrange CMrange];
        AO.VCM.Setpoint.Range(k,:)            = [-CMrange CMrange];
        AO.HCM.Setpoint.Tolerance(k,1)        = CMtol;
        AO.VCM.Setpoint.Tolerance(k,1)        = CMtol;
        AO.HCM.Setpoint.DeltaRespMat(k,1)     = RMkick;
        AO.VCM.Setpoint.DeltaRespMat(k,1)     = RMkick;
        AO.HCM.Monitor.HW2PhysicsParams(k,1)  = CMgain;
        AO.VCM.Monitor.HW2PhysicsParams(k,1)  = CMgain;
        AO.HCM.Monitor.Physics2HWParams(k,1)  = 1/CMgain;
        AO.VCM.Monitor.Physics2HWParams(k,1)  = 1/CMgain;
        AO.HCM.Setpoint.HW2PhysicsParams(k,1) = CMgain;
        AO.VCM.Setpoint.HW2PhysicsParams(k,1) = CMgain;
        AO.HCM.Setpoint.Physics2HWParams(k,1) = 1/CMgain;
        AO.VCM.Setpoint.Physics2HWParams(k,1) = 1/CMgain;
        AO.HCM.CommonNames(k,:)           = [ 'r' num2str(i,'%02.2d') 'cm' num2str(j,'%01.1d') 'x'];
        AO.VCM.CommonNames(k,:)           = [ 'r' num2str(i,'%02.2d') 'cm' num2str(j,'%01.1d') 'y'];
    end
end



%%%%%%%%%%%%%%%
% Quadrupoles %
%%%%%%%%%%%%%%%
% Tune correctors
AO.QH1.FamilyName = 'QH1';
AO.QH1.MemberOf = {'MachineConfig'; 'PlotFamily'; 'QUAD'; 'Magnet'; 'Tune Corrector'};
AO.QH1.DeviceList = [];
AO.QH1.ElementList = [];
AO.QH1.Status = [];

AO.QH1.Monitor.Mode           = OperationalMode;
AO.QH1.Monitor.DataType       = 'Scalar';
AO.QH1.Monitor.ChannelNames   = '';
AO.QH1.Monitor.Units          = 'Hardware';
AO.QH1.Monitor.HWUnits        = 'A';
AO.QH1.Monitor.PhysicsUnits   = 'm^-2';
%AO.QH1.Monitor.HW2PhysicsFcn  = @amp2k;
%AO.QH1.Monitor.Physics2HWFcn  = @k2amp;

AO.QH1.Setpoint.Mode          = OperationalMode;
AO.QH1.Setpoint.DataType      = 'Scalar';
AO.QH1.Setpoint.ChannelNames   = '';
AO.QH1.Setpoint.Units         = 'Hardware';
AO.QH1.Setpoint.HWUnits       = 'A';
AO.QH1.Setpoint.PhysicsUnits  = 'm^-2';
%AO.QH1.Setpoint.HW2PhysicsFcn = @amp2k;
%AO.QH1.Setpoint.Physics2HWFcn = @k2amp;

QH1range = 200;
QH1gain = -10.0e-3;  %  m^-2/A

AO.QH1.Monitor.HW2PhysicsParams  = QH1gain;
AO.QH1.Monitor.Physics2HWParams  = 1.0/QH1gain;
AO.QH1.Setpoint.HW2PhysicsParams = QH1gain;
AO.QH1.Setpoint.Physics2HWParams = 1.0/QH1gain;

for i=1:30
    AO.QH1.Monitor.ChannelNames(i,:)  = ['r' num2str(i,'%02.2d') 'qh1' ':am'];
    AO.QH1.Setpoint.ChannelNames(i,:) = ['r' num2str(i,'%02.2d') 'qh1' ':sp'];
    AO.QH1.Status(i,1)                = 1;
    AO.QH1.DeviceList(i,:)            = [ i 1 ];
    AO.QH1.ElementList(i,1)           = i;
    AO.QH1.Setpoint.Range(i,:)        = [0 QH1range];
    AO.QH1.Setpoint.Tolerance(i)    = 0.1;
    AO.QH1.Setpoint.DeltaRespMat(i,1) = 0.01;
    AO.QH1.CommonNames(i,:)           = ['r' num2str(i,'%02.2d') 'qh1' ];
end


AO.QH2.FamilyName = 'QH2';
AO.QH2.MemberOf = {'MachineConfig'; 'PlotFamily'; 'QUAD'; 'Magnet'; 'Tune Corrector'};
AO.QH2.DeviceList = [];
AO.QH2.ElementList = [];
AO.QH2.Status = [];

AO.QH2.Monitor.Mode           = OperationalMode;
AO.QH2.Monitor.DataType       = 'Scalar';
AO.QH2.Monitor.ChannelNames   = '';
AO.QH2.Monitor.Units          = 'Hardware';
AO.QH2.Monitor.HWUnits        = 'A';
AO.QH2.Monitor.PhysicsUnits   = 'm^-2';
%AO.QH2.Monitor.HW2PhysicsFcn  = @amp2k;
%AO.QH2.Monitor.Physics2HWFcn  = @k2amp;

AO.QH2.Setpoint.Mode          = OperationalMode;
AO.QH2.Setpoint.DataType      = 'Scalar';
AO.QH2.Setpoint.ChannelNames   = '';
AO.QH2.Setpoint.Units         = 'Hardware';
AO.QH2.Setpoint.HWUnits       = 'A';
AO.QH2.Setpoint.PhysicsUnits  = 'm^-2';
%AO.QH2.Setpoint.HW2PhysicsFcn = @amp2k;
%AO.QH2.Setpoint.Physics2HWFcn = @k2amp;

QH2range = 200;
QH2gain = 12.0e-3;  %  m^-2/A

AO.QH2.Monitor.HW2PhysicsParams  = QH2gain;
AO.QH2.Monitor.Physics2HWParams  = 1.0/QH2gain;
AO.QH2.Setpoint.HW2PhysicsParams = QH2gain;
AO.QH2.Setpoint.Physics2HWParams = 1.0/QH2gain;

for i=1:30
    AO.QH2.CommonNames(i,:)           = ['r' num2str(i,'%02.2d') 'qh2' ];
    AO.QH2.Monitor.ChannelNames(i,:)  = ['r' num2str(i,'%02.2d') 'qh2' ':am'];
    AO.QH2.Setpoint.ChannelNames(i,:) = ['r' num2str(i,'%02.2d') 'qh2' ':sp'];
    AO.QH2.Status(i,1)                = 1;
    AO.QH2.DeviceList(i,:)            = [ i 1 ];
    AO.QH2.ElementList(i,1)           = i;
    AO.QH2.Setpoint.Range(i,:)        = [0 QH2range];
    AO.QH2.Setpoint.Tolerance(i)    = 0.1;
    AO.QH2.Setpoint.DeltaRespMat(i,1) = 0.01;
end


AO.QH3.FamilyName = 'QH3';
AO.QH3.MemberOf = {'MachineConfig'; 'PlotFamily'; 'QUAD'; 'Magnet'; 'Tune Corrector'};
AO.QH3.DeviceList = [];
AO.QH3.ElementList = [];
AO.QH3.Status = [];

AO.QH3.Monitor.Mode           = OperationalMode;
AO.QH3.Monitor.DataType       = 'Scalar';
AO.QH3.Monitor.ChannelNames   = '';
AO.QH3.Monitor.Units          = 'Hardware';
AO.QH3.Monitor.HWUnits        = 'A';
AO.QH3.Monitor.PhysicsUnits   = 'm^-2';
%AO.QH3.Monitor.HW2PhysicsFcn  = @amp2k;
%AO.QH3.Monitor.Physics2HWFcn  = @k2amp;

AO.QH3.Setpoint.Mode          = OperationalMode;
AO.QH3.Setpoint.DataType      = 'Scalar';
AO.QH3.Setpoint.ChannelNames   = '';
AO.QH3.Setpoint.Units         = 'Hardware';
AO.QH3.Setpoint.HWUnits       = 'A';
AO.QH3.Setpoint.PhysicsUnits  = 'm^-2';
%AO.QH3.Setpoint.HW2PhysicsFcn = @amp2k;
%AO.QH3.Setpoint.Physics2HWFcn = @k2amp;

QH3range = 200;
QH3gain = -10.0e-3;  %  m^-2/A

AO.QH3.Monitor.HW2PhysicsParams  = QH3gain;
AO.QH3.Monitor.Physics2HWParams  = 1.0/QH3gain;
AO.QH3.Setpoint.HW2PhysicsParams = QH3gain;
AO.QH3.Setpoint.Physics2HWParams = 1.0/QH3gain;

for i=1:30
    AO.QH3.CommonNames(i,:)           = ['r' num2str(i,'%02.2d') 'qh3' ];
    AO.QH3.Monitor.ChannelNames(i,:)  = ['r' num2str(i,'%02.2d') 'qh3' ':am'];
    AO.QH3.Setpoint.ChannelNames(i,:) = ['r' num2str(i,'%02.2d') 'qh3' ':sp'];
    AO.QH3.Status(i,1)                = 1;
    AO.QH3.DeviceList(i,:)            = [ i 1 ];
    AO.QH3.ElementList(i,1)           = i;
    AO.QH3.Setpoint.Range(i,:)        = [0 QH3range];
    AO.QH3.Setpoint.Tolerance(i)    = 0.1;
    AO.QH3.Setpoint.DeltaRespMat(i,1) = 0.01;
end


AO.QL1.FamilyName = 'QL1';
AO.QL1.MemberOf = {'MachineConfig'; 'PlotFamily'; 'QUAD'; 'Magnet'; 'Tune Corrector'};
AO.QL1.DeviceList = [];
AO.QL1.ElementList = [];
AO.QL1.Status = [];

AO.QL1.Monitor.Mode           = OperationalMode;
AO.QL1.Monitor.DataType       = 'Scalar';
AO.QL1.Monitor.ChannelNames   = '';
AO.QL1.Monitor.Units          = 'Hardware';
AO.QL1.Monitor.HWUnits        = 'A';
AO.QL1.Monitor.PhysicsUnits   = 'm^-2';
%AO.QL1.Monitor.HW2PhysicsFcn  = @amp2k;
%AO.QL1.Monitor.Physics2HWFcn  = @k2amp;

AO.QL1.Setpoint.Mode          = OperationalMode;
AO.QL1.Setpoint.DataType      = 'Scalar';
AO.QL1.Setpoint.ChannelNames  = '';
AO.QL1.Setpoint.Units         = 'Hardware';
AO.QL1.Setpoint.HWUnits       = 'A';
AO.QL1.Setpoint.PhysicsUnits  = 'm^-2';
%AO.QL1.Setpoint.HW2PhysicsFcn = @amp2k;
%AO.QL1.Setpoint.Physics2HWFcn = @k2amp;

QL1range = 200;
QL1gain = -10.0e-3;  %  m^-2/A

AO.QL1.Monitor.HW2PhysicsParams  = QL1gain;
AO.QL1.Monitor.Physics2HWParams  = 1.0/QL1gain;
AO.QL1.Setpoint.HW2PhysicsParams = QL1gain;
AO.QL1.Setpoint.Physics2HWParams = 1.0/QL1gain;

for i=1:30
    AO.QL1.CommonNames(i,:)           = ['r' num2str(i,'%02.2d') 'ql1' ];
    AO.QL1.Monitor.ChannelNames(i,:)  = ['r' num2str(i,'%02.2d') 'ql1' ':am'];
    AO.QL1.Setpoint.ChannelNames(i,:) = ['r' num2str(i,'%02.2d') 'ql1' ':sp'];
    AO.QL1.Status(i,1)                = 1;
    AO.QL1.DeviceList(i,:)            = [ i 1 ];
    AO.QL1.ElementList(i,1)           = i;
    AO.QL1.Setpoint.Range(i,:)        = [0 QL1range];
    AO.QL1.Setpoint.Tolerance(i)    = 0.1;
    AO.QL1.Setpoint.DeltaRespMat(i,1) = 0.01;
end



AO.QL2.FamilyName = 'QL2';
AO.QL2.MemberOf = {'MachineConfig'; 'PlotFamily'; 'QUAD'; 'Magnet'; 'Tune Corrector'};
AO.QL2.DeviceList = [];
AO.QL2.ElementList = [];
AO.QL2.Status = [];

AO.QL2.Monitor.Mode           = OperationalMode;
AO.QL2.Monitor.DataType       = 'Scalar';
AO.QL2.Monitor.ChannelNames   = '';
AO.QL2.Monitor.Units          = 'Hardware';
AO.QL2.Monitor.HWUnits        = 'A';
AO.QL2.Monitor.PhysicsUnits   = 'm^-2';
%AO.QL2.Monitor.HW2PhysicsFcn  = @amp2k;
%AO.QL2.Monitor.Physics2HWFcn  = @k2amp;

AO.QL2.Setpoint.Mode          = OperationalMode;
AO.QL2.Setpoint.DataType      = 'Scalar';
AO.QL2.Setpoint.ChannelNames  = '';
AO.QL2.Setpoint.Units         = 'Hardware';
AO.QL2.Setpoint.HWUnits       = 'A';
AO.QL2.Setpoint.PhysicsUnits  = 'm^-2';
%AO.QL2.Setpoint.HW2PhysicsFcn = @amp2k;
%AO.QL2.Setpoint.Physics2HWFcn = @k2amp;

QL2range = 200;
QL2gain = 12.0e-3;  %  m^-2/A

AO.QL2.Monitor.HW2PhysicsParams  = QL2gain;
AO.QL2.Monitor.Physics2HWParams  = 1.0/QL2gain;
AO.QL2.Setpoint.HW2PhysicsParams = QL2gain;
AO.QL2.Setpoint.Physics2HWParams = 1.0/QL2gain;

for i=1:30
    AO.QL2.CommonNames(i,:)           = ['r' num2str(i,'%02.2d') 'ql2' ];
    AO.QL2.Monitor.ChannelNames(i,:)  = ['r' num2str(i,'%02.2d') 'ql2' ':am'];
    AO.QL2.Setpoint.ChannelNames(i,:) = ['r' num2str(i,'%02.2d') 'ql2' ':sp'];
    AO.QL2.Status(i,1)                = 1;
    AO.QL2.DeviceList(i,:)            = [ i 1 ];
    AO.QL2.ElementList(i,1)           = i;
    AO.QL2.Setpoint.Range(i,:)        = [0 QL2range];
    AO.QL2.Setpoint.Tolerance(i)    = 0.1;
    AO.QL2.Setpoint.DeltaRespMat(i,1) = 0.01;
end


AO.QL3.FamilyName = 'QL3';
AO.QL3.MemberOf = {'MachineConfig'; 'PlotFamily'; 'QUAD'; 'Magnet'; 'Tune Corrector'};
AO.QL3.DeviceList = [];
AO.QL3.ElementList = [];
AO.QL3.Status = [];

AO.QL3.Monitor.Mode           = OperationalMode;
AO.QL3.Monitor.DataType       = 'Scalar';
AO.QL3.Monitor.ChannelNames   = '';
AO.QL3.Monitor.Units          = 'Hardware';
AO.QL3.Monitor.HWUnits        = 'A';
AO.QL3.Monitor.PhysicsUnits   = 'm^-2';
%AO.QL3.Monitor.HW2PhysicsFcn  = @amp2k;
%AO.QL3.Monitor.Physics2HWFcn  = @k2amp;

AO.QL3.Setpoint.Mode          = OperationalMode;
AO.QL3.Setpoint.DataType      = 'Scalar';
AO.QL3.Setpoint.ChannelNames  = '';
AO.QL3.Setpoint.Units         = 'Hardware';
AO.QL3.Setpoint.HWUnits       = 'A';
AO.QL3.Setpoint.PhysicsUnits  = 'm^-2';
%AO.QL3.Setpoint.HW2PhysicsFcn = @amp2k;
%AO.QL3.Setpoint.Physics2HWFcn = @k2amp;

QL3range = 200;
QL3gain = -10.0e-3;  %  m^-2/A

AO.QL3.Monitor.HW2PhysicsParams  = QL3gain;
AO.QL3.Monitor.Physics2HWParams  = 1.0/QL3gain;
AO.QL3.Setpoint.HW2PhysicsParams = QL3gain;
AO.QL3.Setpoint.Physics2HWParams = 1.0/QL3gain;

for i=1:30
    AO.QL3.CommonNames(i,:)           = ['r' num2str(i,'%02.2d') 'ql3' ];
    AO.QL3.Monitor.ChannelNames(i,:)  = ['r' num2str(i,'%02.2d') 'ql3' ':am'];
    AO.QL3.Setpoint.ChannelNames(i,:) = ['r' num2str(i,'%02.2d') 'ql3' ':sp'];
    AO.QL3.Status(i,1)                = 1;
    AO.QL3.DeviceList(i,:)            = [ i 1 ];
    AO.QL3.ElementList(i,1)           = i;
    AO.QL3.Setpoint.Range(i,:)        = [0 QL3range];
    AO.QL3.Setpoint.Tolerance(i)    = 0.1;
    AO.QL3.Setpoint.DeltaRespMat(i,1) = 0.01;
end



% Dispersion correctors
AO.QM1.FamilyName = 'QM1';
AO.QM1.MemberOf = {'MachineConfig'; 'PlotFamily'; 'QUAD'; 'Magnet'; 'Dispersion Corrector'};
AO.QM1.DeviceList = [];
AO.QM1.ElementList = [];
AO.QM1.Status = [];

AO.QM1.Monitor.Mode           = OperationalMode;
AO.QM1.Monitor.DataType       = 'Scalar';
AO.QM1.Monitor.ChannelNames   = '';
AO.QM1.Monitor.Units          = 'Hardware';
AO.QM1.Monitor.HWUnits        = 'A';
AO.QM1.Monitor.PhysicsUnits   = 'm^-2';
%AO.QM1.Monitor.HW2PhysicsFcn  = @amp2k;
%AO.QM1.Monitor.Physics2HWFcn  = @k2amp;

AO.QM1.Setpoint.Mode          = OperationalMode;
AO.QM1.Setpoint.DataType      = 'Scalar';
AO.QM1.Setpoint.ChannelNames  = '';
AO.QM1.Setpoint.Units         = 'Hardware';
AO.QM1.Setpoint.HWUnits       = 'A';
AO.QM1.Setpoint.PhysicsUnits  = 'm^-2';
%AO.QM1.Setpoint.HW2PhysicsFcn = @amp2k;
%AO.QM1.Setpoint.Physics2HWFcn = @k2amp;

QM1range = 200;
QM1gain = -10.0e-3;  %  m^-2/A

AO.QM1.Monitor.HW2PhysicsParams  = QM1gain;
AO.QM1.Monitor.Physics2HWParams  = 1.0/QM1gain;
AO.QM1.Setpoint.HW2PhysicsParams = QM1gain;
AO.QM1.Setpoint.Physics2HWParams = 1.0/QM1gain;


for i=1:30
    for j=1:2
        k=j+2*(i-1);
        AO.QM1.CommonNames(k,:)           = [ 'r' num2str(i,'%02.2d') 'qm1-' num2str(j,'%01.1d') ];
        AO.QM1.Monitor.ChannelNames(k,:)  = [ 'r' num2str(i,'%02.2d') 'qm1-' num2str(j,'%01.1d') ':am'];
        AO.QM1.Setpoint.ChannelNames(k,:) = [ 'r' num2str(i,'%02.2d') 'qm1-' num2str(j,'%01.1d') ':sp'];
        AO.QM1.Status(k,1)                = 1;
        AO.QM1.DeviceList(k,:)            = [ i j ];
        AO.QM1.ElementList(k)           = k;

        AO.QM1.Setpoint.Range(k,:)        = [0 QM1range];
        AO.QM1.Setpoint.Tolerance(k)    = 0.1;
        AO.QM1.Setpoint.DeltaRespMat(k,1) = 0.01;
    end
end


AO.QM2.FamilyName = 'QM2';
AO.QM2.MemberOf = {'MachineConfig'; 'PlotFamily'; 'QUAD'; 'Magnet'; 'Dispersion Corrector'};
AO.QM2.DeviceList = [];
AO.QM2.ElementList = [];
AO.QM2.Status = [];

AO.QM2.Monitor.Mode           = OperationalMode;
AO.QM2.Monitor.DataType       = 'Scalar';
AO.QM2.Monitor.ChannelNames   = '';
AO.QM2.Monitor.Units          = 'Hardware';
AO.QM2.Monitor.HWUnits        = 'A';
AO.QM2.Monitor.PhysicsUnits   = 'm^-2';
%AO.QM2.Monitor.HW2PhysicsFcn  = @amp2k;
%AO.QM2.Monitor.Physics2HWFcn  = @k2amp;

AO.QM2.Setpoint.Mode          = OperationalMode;
AO.QM2.Setpoint.DataType      = 'Scalar';
AO.QM2.Setpoint.ChannelNames  = '';
AO.QM2.Setpoint.Units         = 'Hardware';
AO.QM2.Setpoint.HWUnits       = 'A';
AO.QM2.Setpoint.PhysicsUnits  = 'm^-2';
%AO.QM2.Setpoint.HW2PhysicsFcn = @amp2k;
%AO.QM2.Setpoint.Physics2HWFcn = @k2amp;

QM2range = 200;
QM2gain = 12.0e-3;  %  m^-2/A

AO.QM2.Monitor.HW2PhysicsParams  = QM2gain;
AO.QM2.Monitor.Physics2HWParams  = 1.0/QM2gain;
AO.QM2.Setpoint.HW2PhysicsParams = QM2gain;
AO.QM2.Setpoint.Physics2HWParams = 1.0/QM2gain;

for i=1:30
    for j=1:2
        k=j+2*(i-1);
        AO.QM2.CommonNames(k,:)           = [ 'r' num2str(i,'%02.2d') 'qm2-' num2str(j,'%01.1d') ];
        AO.QM2.Monitor.ChannelNames(k,:)  = [ 'r' num2str(i,'%02.2d') 'qm2-' num2str(j,'%01.1d') ':am'];
        AO.QM2.Setpoint.ChannelNames(k,:) = [ 'r' num2str(i,'%02.2d') 'qm2-' num2str(j,'%01.1d') ':sp'];
        AO.QM2.Status(k,1)                = 1;
        AO.QM2.DeviceList(k,:)            = [ i j ];
        AO.QM2.ElementList(k,1)           = k;
        AO.QM2.Setpoint.Range(k,:)        = [0 QM2range];
        AO.QM2.Setpoint.Tolerance(k)    = 0.1;
        AO.QM2.Setpoint.DeltaRespMat(k,1) = 0.01;
    end
end


%%%%%%%%%%%%%%
% Sextupoles %
%%%%%%%%%%%%%%

% Chromaticity correctors
AO.SM1.FamilyName = 'SM1';
AO.SM1.MemberOf = {'MachineConfig'; 'PlotFamily'; 'SEXT'; 'Magnet'; 'Chromaticity Corrector'};
AO.SM1.DeviceList = [];
AO.SM1.ElementList = [];
AO.SM1.Status = [];

AO.SM1.Monitor.Mode           = OperationalMode;
AO.SM1.Monitor.DataType       = 'Scalar';
AO.SM1.Monitor.Units          = 'Hardware';
AO.SM1.Monitor.HWUnits        = 'A';
AO.SM1.Monitor.PhysicsUnits   = 'm^-3';
%AO.SM1.Monitor.HW2PhysicsFcn  = @amp2k;
%AO.SM1.Monitor.Physics2HWFcn  = @k2amp;

AO.SM1.Setpoint.Mode          = OperationalMode;
AO.SM1.Setpoint.DataType      = 'Scalar';
AO.SM1.Setpoint.Units         = 'Hardware';
AO.SM1.Setpoint.HWUnits       = 'A';
AO.SM1.Setpoint.PhysicsUnits  = 'm^-3';
%AO.SM1.Setpoint.HW2PhysicsFcn = @amp2k;
%AO.SM1.Setpoint.Physics2HWFcn = @k2amp;

SM1range = 200;
SM1gain = -20.0e-3;  %  m^-3/A

AO.SM1.Monitor.HW2PhysicsParams  = SM1gain;
AO.SM1.Monitor.Physics2HWParams  = 1.0/SM1gain;
AO.SM1.Setpoint.HW2PhysicsParams = SM1gain;
AO.SM1.Setpoint.Physics2HWParams = 1.0/SM1gain;

for i=1:30
    for j=1:2
        k=j+2*(i-1);
        l=floor(i/6)+1;
        AO.SM1.CommonNames(k,:)           = [ 'r' num2str(i,'%02.2d') 'sm1-' num2str(j,'%01.1d')];
        %sextupoles are fed in series for each pentant
        AO.SM1.Monitor.ChannelNames(k,:)  = [ 'r' num2str(l,'%02.2d') 'sm1' ':am'];
        AO.SM1.Setpoint.ChannelNames(k,:) = [ 'r' num2str(l,'%02.2d') 'sm1' ':sp'];
        AO.SM1.Status(k,1)                = 1;
        AO.SM1.DeviceList(k,:)            = [ i j ];
        AO.SM1.ElementList(k,1)           = k;

        AO.SM1.Setpoint.Range(k,:)        = [0 SM1range];
        AO.SM1.Setpoint.Tolerance(k)    = 0.1;
        AO.SM1.Setpoint.DeltaRespMat(k,1) = 0.01;
    end
end


AO.SM2.FamilyName = 'SM2';
AO.SM2.MemberOf = {'MachineConfig'; 'PlotFamily'; 'SEXT'; 'Magnet'; 'Chromaticity Corrector'};
AO.SM2.DeviceList = [];
AO.SM2.ElementList = [];
AO.SM2.Status = [];

AO.SM2.Monitor.Mode           = OperationalMode;
AO.SM2.Monitor.DataType       = 'Scalar';
AO.SM2.Monitor.Units          = 'Hardware';
AO.SM2.Monitor.HWUnits        = 'A';
AO.SM2.Monitor.PhysicsUnits   = 'm^-3';
%AO.SM2.Monitor.HW2PhysicsFcn  = @amp2k;
%AO.SM2.Monitor.Physics2HWFcn  = @k2amp;

AO.SM2.Setpoint.Mode          = OperationalMode;
AO.SM2.Setpoint.DataType      = 'Scalar';
AO.SM2.Setpoint.Units         = 'Hardware';
AO.SM2.Setpoint.HWUnits       = 'A';
AO.SM2.Setpoint.PhysicsUnits  = 'm^-3';
%AO.SM2.Setpoint.HW2PhysicsFcn = @amp2k;
%AO.SM2.Setpoint.Physics2HWFcn = @k2amp;

SM2range = 200;
SM2gain = 20.0e-3;  %  m^-3/A

AO.SM2.Monitor.HW2PhysicsParams  = SM2gain;
AO.SM2.Monitor.Physics2HWParams  = 1.0/SM2gain;
AO.SM2.Setpoint.HW2PhysicsParams = SM2gain;
AO.SM2.Setpoint.Physics2HWParams = 1.0/SM2gain;

for i=1:30
    l=floor(i/6)+1;
    AO.SM2.CommonNames(i,:)           = [ 'r' num2str(i,'%02.2d') 'sm2' ];
    %sextupoles are fed in series for each pentant
    AO.SM2.Monitor.ChannelNames(i,:)  = [ 'r' num2str(l,'%01.1d') 'sm2' ':am'];
    AO.SM2.Setpoint.ChannelNames(i,:) = [ 'r' num2str(l,'%01.1d') 'sm2' ':sp'];
    AO.SM2.Status(i,1)                = 1;
    AO.SM2.DeviceList(i,:)            = [ i 1 ];
    AO.SM2.ElementList(i,1)           = i;
    AO.SM2.Setpoint.Range(i,:)        = [0 SM2range];
    AO.SM2.Setpoint.Tolerance(i)      = 0.1;
    AO.SM2.Setpoint.DeltaRespMat(i,1)   = 0.01;
end


% Harmonic sextupoles
AO.SH1.FamilyName = 'SH1';
AO.SH1.MemberOf = {'MachineConfig'; 'PlotFamily'; 'SEXT'; 'Magnet'; 'Harmonic Sextupole'};
AO.SH1.DeviceList = [];
AO.SH1.ElementList = [];
AO.SH1.Status = [];

AO.SH1.Monitor.Mode           = OperationalMode;
AO.SH1.Monitor.DataType       = 'Scalar';
AO.SH1.Monitor.Units          = 'Hardware';
AO.SH1.Monitor.HWUnits        = 'A';
AO.SH1.Monitor.PhysicsUnits   = 'm^-3';
%AO.SH1.Monitor.HW2PhysicsFcn  = @amp2k;
%AO.SH1.Monitor.Physics2HWFcn  = @k2amp;

AO.SH1.Setpoint.Mode          = OperationalMode;
AO.SH1.Setpoint.DataType      = 'Scalar';
AO.SH1.Setpoint.Units         = 'Hardware';
AO.SH1.Setpoint.HWUnits       = 'A';
AO.SH1.Setpoint.PhysicsUnits  = 'm^-3';
%AO.SH1.Setpoint.HW2PhysicsFcn = @amp2k;
%AO.SH1.Setpoint.Physics2HWFcn = @k2amp;

SH1range = 200;
SH1gain = -20.0e-3;  %  m^-3/A

AO.SH1.Monitor.HW2PhysicsParams  = SH1gain;
AO.SH1.Monitor.Physics2HWParams  = 1.0/SH1gain;
AO.SH1.Setpoint.HW2PhysicsParams = SH1gain;
AO.SH1.Setpoint.Physics2HWParams = 1.0/SH1gain;

for i=1:30
    l=floor(i/6)+1;
    AO.SH1.CommonNames(i,:)           = [ 'r' num2str(i,'%02.2d') 'sh1' ];
    %sextupoles are fed in series for each pentant
    AO.SH1.Monitor.ChannelNames(i,:)  = [ 'r' num2str(l,'%01.1d') 'sh1' ':am'];
    AO.SH1.Setpoint.ChannelNames(i,:) = [ 'r' num2str(l,'%01.1d') 'sh1' ':sp'];
    AO.SH1.Status(i,1)                = 1;
    AO.SH1.DeviceList(i,:)            = [ i 1 ];
    AO.SH1.ElementList(i,1)           = i;
    AO.SH1.Setpoint.Range(i,:)        = [-SH1range SH1range];
    AO.SH1.Setpoint.Tolerance(i)    = 0.1;
    AO.SH1.Setpoint.DeltaRespMat(i,1) = 0.01;
end


AO.SH2.FamilyName = 'SH2';
AO.SH2.MemberOf = {'MachineConfig'; 'PlotFamily'; 'SEXT'; 'Magnet'; 'Harmonic Sextupole'};
AO.SH2.DeviceList = [];
AO.SH2.ElementList = [];
AO.SH2.Status = [];

AO.SH2.Monitor.Mode           = OperationalMode;
AO.SH2.Monitor.DataType       = 'Scalar';
AO.SH2.Monitor.Units          = 'Hardware';
AO.SH2.Monitor.HWUnits        = 'A';
AO.SH2.Monitor.PhysicsUnits   = 'm^-3';
%AO.SH2.Monitor.HW2PhysicsFcn  = @amp2k;
%AO.SH2.Monitor.Physics2HWFcn  = @k2amp;

AO.SH2.Setpoint.Mode          = OperationalMode;
AO.SH2.Setpoint.DataType      = 'Scalar';
AO.SH2.Setpoint.Units         = 'Hardware';
AO.SH2.Setpoint.HWUnits       = 'A';
AO.SH2.Setpoint.PhysicsUnits  = 'm^-3';
%AO.SH2.Setpoint.HW2PhysicsFcn = @amp2k;
%AO.SH2.Setpoint.Physics2HWFcn = @k2amp;

SH2range = 200;
SH2gain = 20.0e-3;  %  m^-3/A

AO.SH2.Monitor.HW2PhysicsParams  = SH2gain;
AO.SH2.Monitor.Physics2HWParams  = 1.0/SH2gain;
AO.SH2.Setpoint.HW2PhysicsParams = SH2gain;
AO.SH2.Setpoint.Physics2HWParams = 1.0/SH2gain;

for i=1:30
    l=floor(i/6)+1;
    AO.SH2.CommonNames(i,:)           = [ 'r' num2str(i,'%02.2d') 'sh2' ];
    %sextupoles are fed in series for each pentant
    AO.SH2.Monitor.ChannelNames(i,:)  = [ 'r' num2str(l,'%01.1d') 'sh2' ':am'];
    AO.SH2.Setpoint.ChannelNames(i,:) = [ 'r' num2str(l,'%01.1d') 'sh2' ':sp'];
    AO.SH2.Status(i,1)                = 1;
    AO.SH2.DeviceList(i,:)            = [ i 1 ];
    AO.SH2.ElementList(i,1)           = i;
    AO.SH2.Setpoint.Range(i,:)        = [-SH2range SH2range];
    AO.SH2.Setpoint.Tolerance(i)    = 0.1;
    AO.SH2.Setpoint.DeltaRespMat(i,1) = 0.01;
end



AO.SH3.FamilyName = 'SH3';
AO.SH3.MemberOf = {'MachineConfig'; 'PlotFamily'; 'SEXT'; 'Magnet'; 'Harmonic Sextupole'};
AO.SH3.DeviceList = [];
AO.SH3.ElementList = [];
AO.SH3.Status = [];

AO.SH3.Monitor.Mode           = OperationalMode;
AO.SH3.Monitor.DataType       = 'Scalar';
AO.SH3.Monitor.Units          = 'Hardware';
AO.SH3.Monitor.HWUnits        = 'A';
AO.SH3.Monitor.PhysicsUnits   = 'm^-3';
%AO.SH3.Monitor.HW2PhysicsFcn  = @amp2k;
%AO.SH3.Monitor.Physics2HWFcn  = @k2amp;

AO.SH3.Setpoint.Mode          = OperationalMode;
AO.SH3.Setpoint.DataType      = 'Scalar';
AO.SH3.Setpoint.Units         = 'Hardware';
AO.SH3.Setpoint.HWUnits       = 'A';
AO.SH3.Setpoint.PhysicsUnits  = 'm^-3';
%AO.SH3.Setpoint.HW2PhysicsFcn = @amp2k;
%AO.SH3.Setpoint.Physics2HWFcn = @k2amp;

SH3range = 200;
SH3gain = -20.0e-3;  %  m^-3/A

AO.SH3.Monitor.HW2PhysicsParams  = SH3gain;
AO.SH3.Monitor.Physics2HWParams  = 1.0/SH3gain;
AO.SH3.Setpoint.HW2PhysicsParams = SH3gain;
AO.SH3.Setpoint.Physics2HWParams = 1.0/SH3gain;

for i=1:30
    l=floor(i/6)+1;
    AO.SH3.CommonNames(i,:)           = [ 'r' num2str(i,'%02.2d') 'sh3' ];
    %sextupoles are fed in series for each pentant
    AO.SH3.Monitor.ChannelNames(i,:)  = [ 'r' num2str(l,'%01.1d') 'sh3' ':am'];
    AO.SH3.Setpoint.ChannelNames(i,:) = [ 'r' num2str(l,'%01.1d') 'sh3' ':sp'];
    AO.SH3.Status(i,1)                = 1;
    AO.SH3.DeviceList(i,:)            = [ i 1 ];
    AO.SH3.ElementList(i,1)           = i;
    AO.SH3.Setpoint.Range(i,:)        = [-SH3range SH3range];
    AO.SH3.Setpoint.Tolerance(i)    = 0.1;
    AO.SH3.Setpoint.DeltaRespMat(i,1) = 0.01;
end



AO.SH4.FamilyName = 'SH4';
AO.SH4.MemberOf = {'MachineConfig'; 'PlotFamily'; 'SEXT'; 'Magnet'; 'Harmonic Sextupole'};
AO.SH4.DeviceList = [];
AO.SH4.ElementList = [];
AO.SH4.Status = [];

AO.SH4.Monitor.Mode           = OperationalMode;
AO.SH4.Monitor.DataType       = 'Scalar';
AO.SH4.Monitor.Units          = 'Hardware';
AO.SH4.Monitor.HWUnits        = 'A';
AO.SH4.Monitor.PhysicsUnits   = 'm^-3';
%AO.SH4.Monitor.HW2PhysicsFcn  = @amp2k;
%AO.SH4.Monitor.Physics2HWFcn  = @k2amp;

AO.SH4.Setpoint.Mode          = OperationalMode;
AO.SH4.Setpoint.DataType      = 'Scalar';
AO.SH4.Setpoint.Units         = 'Hardware';
AO.SH4.Setpoint.HWUnits       = 'A';
AO.SH4.Setpoint.PhysicsUnits  = 'm^-3';
%AO.SH4.Setpoint.HW2PhysicsFcn = @amp2k;
%AO.SH4.Setpoint.Physics2HWFcn = @k2amp;

SH4range = 200;
SH4gain = 20.0e-3;  %  m^-3/A

AO.SH4.Monitor.HW2PhysicsParams  = SH4gain;
AO.SH4.Monitor.Physics2HWParams  = 1.0/SH4gain;
AO.SH4.Setpoint.HW2PhysicsParams = SH4gain;
AO.SH4.Setpoint.Physics2HWParams = 1.0/SH4gain;

for i=1:30
    l=floor(i/6)+1;
    AO.SH4.CommonNames(i,:)           = [ 'r' num2str(i,'%02.2d') 'sh4' ];
    %sextupoles are fed in series for each pentant
    AO.SH4.Monitor.ChannelNames(i,:)  = [ 'r' num2str(l,'%01.1d') 'sh4' ':am'];
    AO.SH4.Setpoint.ChannelNames(i,:) = [ 'r' num2str(l,'%01.1d') 'sh4' ':sp'];
    AO.SH4.Status(i,1)                = 1;
    AO.SH4.DeviceList(i,:)            = [ i 1 ];
    AO.SH4.ElementList(i,1)           = i;
    AO.SH4.Setpoint.Range(i,:)        = [-SH4range SH4range];
    AO.SH4.Setpoint.Tolerance(i)    = 0.1;
    AO.SH4.Setpoint.DeltaRespMat(i,1) = 0.01;
end



AO.SL1.FamilyName = 'SL1';
AO.SL1.MemberOf = {'MachineConfig'; 'PlotFamily'; 'SEXT'; 'Magnet'; 'Harmonic Sextupole'};
AO.SL1.DeviceList = [];
AO.SL1.ElementList = [];
AO.SL1.Status = [];

AO.SL1.Monitor.Mode           = OperationalMode;
AO.SL1.Monitor.DataType       = 'Scalar';
AO.SL1.Monitor.Units          = 'Hardware';
AO.SL1.Monitor.HWUnits        = 'A';
AO.SL1.Monitor.PhysicsUnits   = 'm^-3';
%AO.SL1.Monitor.HW2PhysicsFcn  = @amp2k;
%AO.SL1.Monitor.Physics2HWFcn  = @k2amp;

AO.SL1.Setpoint.Mode          = OperationalMode;
AO.SL1.Setpoint.DataType      = 'Scalar';
AO.SL1.Setpoint.Units         = 'Hardware';
AO.SL1.Setpoint.HWUnits       = 'A';
AO.SL1.Setpoint.PhysicsUnits  = 'm^-3';
%AO.SL1.Setpoint.HW2PhysicsFcn = @amp2k;
%AO.SL1.Setpoint.Physics2HWFcn = @k2amp;

SL1range = 200;
SL1gain = -20.0e-3;  %  m^-3/A

AO.SL1.Monitor.HW2PhysicsParams  = SL1gain;
AO.SL1.Monitor.Physics2HWParams  = 1.0/SL1gain;
AO.SL1.Setpoint.HW2PhysicsParams = SL1gain;
AO.SL1.Setpoint.Physics2HWParams = 1.0/SL1gain;

for i=1:30
    l=floor(i/6)+1;
    AO.SL1.CommonNames(i,:)           = [ 'r' num2str(i,'%02.2d') 'sl1' ];
    %sextupoles are fed in series for each pentant
    AO.SL1.Monitor.ChannelNames(i,:)  = [ 'r' num2str(l,'%01.1d') 'sl1' ':am'];
    AO.SL1.Setpoint.ChannelNames(i,:) = [ 'r' num2str(l,'%01.1d') 'sl1' ':sp'];
    AO.SL1.Status(i,1)                = 1;
    AO.SL1.DeviceList(i,:)            = [ i 1 ];
    AO.SL1.ElementList(i,1)           = i;
    AO.SL1.Setpoint.Range(i,:)        = [-SL1range SL1range];
    AO.SL1.Setpoint.Tolerance(i)    = 0.1;
    AO.SL1.Setpoint.DeltaRespMat(i,1) = 0.01;
end



AO.SL2.FamilyName = 'SL2';
AO.SL2.MemberOf = {'MachineConfig'; 'PlotFamily'; 'SEXT'; 'Magnet'; 'Harmonic Sextupole'};
AO.SL2.DeviceList = [];
AO.SL2.ElementList = [];
AO.SL2.Status = [];

AO.SL2.Monitor.Mode           = OperationalMode;
AO.SL2.Monitor.DataType       = 'Scalar';
AO.SL2.Monitor.Units          = 'Hardware';
AO.SL2.Monitor.HWUnits        = 'A';
AO.SL2.Monitor.PhysicsUnits   = 'm^-3';
%AO.SL2.Monitor.HW2PhysicsFcn  = @amp2k;
%AO.SL2.Monitor.Physics2HWFcn  = @k2amp;

AO.SL2.Setpoint.Mode          = OperationalMode;
AO.SL2.Setpoint.DataType      = 'Scalar';
AO.SL2.Setpoint.Units         = 'Hardware';
AO.SL2.Setpoint.HWUnits       = 'A';
AO.SL2.Setpoint.PhysicsUnits  = 'm^-3';
%AO.SL2.Setpoint.HW2PhysicsFcn = @amp2k;
%AO.SL2.Setpoint.Physics2HWFcn = @k2amp;

SL2range = 200;
SL2gain = 20.0e-3;  %  m^-3/A

AO.SL2.Monitor.HW2PhysicsParams  = SL2gain;
AO.SL2.Monitor.Physics2HWParams  = 1.0/SL2gain;
AO.SL2.Setpoint.HW2PhysicsParams = SL2gain;
AO.SL2.Setpoint.Physics2HWParams = 1.0/SL2gain;

for i=1:30
    l=floor(i/6)+1;
    AO.SL2.CommonNames(i,:)           = [ 'r' num2str(i,'%02.2d') 'sl2' ];
    %sextupoles are fed in series for each pentant
    AO.SL2.Monitor.ChannelNames(i,:)  = [ 'r' num2str(l,'%01.1d') 'sl2' ':am'];
    AO.SL2.Setpoint.ChannelNames(i,:) = [ 'r' num2str(l,'%01.1d') 'sl2' ':sp'];
    AO.SL2.Status(i,1)                = 1;
    AO.SL2.DeviceList(i,:)            = [ i 1 ];
    AO.SL2.ElementList(i,1)           = i;
    AO.SL2.Setpoint.Range(i,:)        = [-SL2range SL2range];
    AO.SL2.Setpoint.Tolerance(i)    = 0.1;
    AO.SL2.Setpoint.DeltaRespMat(i,1) = 0.01;
end


AO.SL3.FamilyName = 'SL3';
AO.SL3.MemberOf = {'MachineConfig'; 'PlotFamily'; 'SEXT'; 'Magnet'; 'Harmonic Sextupole'};
AO.SL3.DeviceList = [];
AO.SL3.ElementList = [];
AO.SL3.Status = [];

AO.SL3.Monitor.Mode           = OperationalMode;
AO.SL3.Monitor.DataType       = 'Scalar';
AO.SL3.Monitor.Units          = 'Hardware';
AO.SL3.Monitor.HWUnits        = 'A';
AO.SL3.Monitor.PhysicsUnits   = 'm^-3';
%AO.SL3.Monitor.HW2PhysicsFcn  = @amp2k;
%AO.SL3.Monitor.Physics2HWFcn  = @k2amp;

AO.SL3.Setpoint.Mode          = OperationalMode;
AO.SL3.Setpoint.DataType      = 'Scalar';
AO.SL3.Setpoint.Units         = 'Hardware';
AO.SL3.Setpoint.HWUnits       = 'A';
AO.SL3.Setpoint.PhysicsUnits  = 'm^-3';
%AO.SL3.Setpoint.HW2PhysicsFcn = @amp2k;
%AO.SL3.Setpoint.Physics2HWFcn = @k2amp;

SL3range = 200;
SL3gain = -20.0e-3;  %  m^-3/A

AO.SL3.Monitor.HW2PhysicsParams  = SL3gain;
AO.SL3.Monitor.Physics2HWParams  = 1.0/SL3gain;
AO.SL3.Setpoint.HW2PhysicsParams = SL3gain;
AO.SL3.Setpoint.Physics2HWParams = 1.0/SL3gain;

for i=1:30
    l=floor(i/6)+1;
    AO.SL3.CommonNames(i,:)           = [ 'r' num2str(i,'%02.2d') 'sl3' ];
    %sextupoles are fed in series for each pentant
    AO.SL3.Monitor.ChannelNames(i,:)  = [ 'r' num2str(l,'%01.1d') 'sl3' ':am'];
    AO.SL3.Setpoint.ChannelNames(i,:) = [ 'r' num2str(l,'%01.1d') 'sl3' ':sp'];
    AO.SL3.Status(i,1)                = 1;
    AO.SL3.DeviceList(i,:)            = [ i 1 ];
    AO.SL3.ElementList(i,1)           = i;
    AO.SL3.Setpoint.Range(i,:)        = [-SL3range SL3range];
    AO.SL3.Setpoint.Tolerance(i)    = 0.1;
    AO.SL3.Setpoint.DeltaRespMat(i,1) = 0.01;
end



% Skew Quadrupoles
AO.SQ.FamilyName             = 'SQ';
AO.SQ.MemberOf               = {'MachineConfig'; 'PlotFamily';  'SKEWQUAD'; 'Magnet'};
AO.SQ.DeviceList = [];
AO.SQ.ElementList = [];
AO.SQ.Status = [];

AO.SQ.Monitor.Mode           = OperationalMode;
AO.SQ.Monitor.DataType       = 'Scalar';
AO.SQ.Monitor.Units          = 'Hardware';
AO.SQ.Monitor.HWUnits        = 'A';
AO.SQ.Monitor.PhysicsUnits   = 'm^-1';
%AO.SQ.Monitor.HW2PhysicsFcn  = @amp2k;
%AO.Sq.Monitor.Physics2HWFcn  = @k2amp;
AO.SQ.Setpoint.Mode          = OperationalMode;
AO.SQ.Setpoint.DataType      = 'Scalar';
AO.SQ.Setpoint.Units         = 'Hardware';
AO.SQ.Setpoint.HWUnits       = 'A';
AO.SQ.Setpoint.PhysicsUnits  = 'rad';
%AO.SQ.Setpoint.HW2PhysicsFcn = @amp2k;
%AO.SQ.Setpoint.Physics2HWFcn = @k2amp;

SQrange = 10.0;   % [A]
SQgain  = 0.8e-4; % [m^-1/A]
SQtol   = 0.010;  % Tolerance [A]

for k=1:30 % skew quadrupoles are only in high beta sections
    i=2*floor(k/2)+1;
    j=mod(k,2)+1;
    AO.SQ.CommonNames(k,:)            = [ 'r' num2str(i,'%02.2d') 'sq' num2str(j,'%01.1d')];
    AO.SQ.Monitor.ChannelNames(k,:)   = [ 'r' num2str(i,'%02.2d') 'sq' num2str(j,'%01.1d') ':am'];
    AO.SQ.Setpoint.ChannelNames(k,:)  = [ 'r' num2str(i,'%02.2d') 'sq' num2str(j,'%01.1d') ':sp'];
    AO.SQ.Status(k,1) = 1;
    AO.SQ.DeviceList(k,:)                = [ i j ];
    AO.SQ.ElementList(k,1)               = k;
    AO.SQ.Setpoint.Range(k,:)            = [-SQrange SQrange];
    AO.SQ.Setpoint.Tolerance(k,1)        = SQtol;
    AO.SQ.Monitor.HW2PhysicsParams(k,1)  = SQgain;
    AO.SQ.Monitor.Physics2HWParams(k,1)  = 1/SQgain;
    AO.SQ.Setpoint.HW2PhysicsParams(k,1) = SQgain;
    AO.SQ.Setpoint.Physics2HWParams(k,1) = 1/SQgain;
end


% Dipoles
AO.BEND.FamilyName = 'BEND';
AO.BEND.MemberOf = {'MachineConfig'; 'BEND'; 'PlotFamily'; 'Magnet';};
AO.BEND.DeviceList = [];
AO.BEND.ElementList = [];
AO.BEND.Status = [];

AO.BEND.Monitor.Mode           = OperationalMode;
AO.BEND.Monitor.DataType       = 'Scalar';
AO.BEND.Monitor.Units          = 'Hardware';
AO.BEND.Monitor.HWUnits        = 'A';
AO.BEND.Monitor.PhysicsUnits   = 'rad';
%AO.BEND.Monitor.HW2PhysicsFcn  = @amp2k;
%AO.BEND.Monitor.Physics2HWFcn  = @k2amp;

AO.BEND.Setpoint.Mode          = OperationalMode;
AO.BEND.Setpoint.DataType      = 'Scalar';
AO.BEND.Setpoint.Units         = 'Hardware';
AO.BEND.Setpoint.HWUnits       = 'A';
AO.BEND.Setpoint.PhysicsUnits  = 'rad';
%AO.BEND.Setpoint.HW2PhysicsFcn = @amp2k;
%AO.BEND.Setpoint.Physics2HWFcn = @k2amp;


BENDGain = 2*pi/60/950;  %  rad/A
AO.BEND.Monitor.HW2PhysicsParams  = BENDGain;
AO.BEND.Monitor.Physics2HWParams  = 1.0/BENDGain;
AO.BEND.Setpoint.HW2PhysicsParams = BENDGain;
AO.BEND.Setpoint.Physics2HWParams = 1.0/BENDGain;
AO.BEND.Setpoint.Range        = [0 1000];
AO.BEND.Setpoint.Tolerance    = 0.05;
AO.BEND.Setpoint.DeltaRespMat = 0.1;
for i=1:30
    for j=1:2
        k=j+2*(i-1);
        AO.BEND.CommonNames(k,:)           = ['r' num2str(i,'%02.2d') 'dip' num2str(j,'%01.1d')];
        AO.BEND.Monitor.ChannelNames(k,:)  = 'rdip:am';
        AO.BEND.Setpoint.ChannelNames(k,:) = 'rdip:sp';
        AO.BEND.Status(k,1)                = 1;
        AO.BEND.DeviceList(k,:)            = [ i j ];
        AO.BEND.ElementList(k,1)           = k;
    end
end



% RF
AO.RF.FamilyName = 'RF';
AO.RF.MemberOf   = {'MachineConfig'; 'RF'};
AO.RF.DeviceList = [1 1];
AO.RF.ElementList = 1;
AO.RF.Status = 1;
AO.RF.Position = 0;

AO.RF.Monitor.Mode = 'Simulator';
AO.RF.Monitor.DataType = 'Scalar';
AO.RF.Monitor.ChannelNames = 'RF:am';
AO.RF.Monitor.HW2PhysicsParams = 1e6;
AO.RF.Monitor.Physics2HWParams = 1/1e6;
AO.RF.Monitor.Units = 'Hardware';
AO.RF.Monitor.HWUnits       = 'MHz';
AO.RF.Monitor.PhysicsUnits  = 'Hz';

AO.RF.Setpoint.Mode = OperationalMode;
AO.RF.Setpoint.DataType = 'Scalar';
AO.RF.Setpoint.ChannelNames = 'RF:sp';
AO.RF.Setpoint.HW2PhysicsParams = 1e6;
AO.RF.Setpoint.Physics2HWParams = 1/1e6;
AO.RF.Setpoint.Units = 'Hardware';
AO.RF.Setpoint.HWUnits      = 'MHz';
AO.RF.Setpoint.PhysicsUnits = 'Hz';
AO.RF.Setpoint.Range = [499 501];
AO.RF.Setpoint.Tolerance = eps;


% Tune
AO.TUNE.FamilyName = 'TUNE';
AO.TUNE.MemberOf   = {'TUNE'};
AO.TUNE.DeviceList = [1 1;1 2;1 3];
AO.TUNE.ElementList = [1;2;3];
AO.TUNE.Status = [1;1;0];
AO.TUNE.Position = 0;

AO.TUNE.Monitor.Mode = OperationalMode;
AO.TUNE.Monitor.DataType = 'Scalar';
AO.TUNE.Monitor.ChannelNames =[ 'rtuneX', 'rtuneY' , ''];
AO.TUNE.Monitor.HW2PhysicsParams = 1;
AO.TUNE.Monitor.Physics2HWParams = 1;
AO.TUNE.Monitor.Units = 'Hardware';
AO.TUNE.Monitor.HWUnits = 'Tune';
AO.TUNE.Monitor.PhysicsUnits = 'Tune';


% DCCT
AO.DCCT.FamilyName = 'DCCT';
AO.DCCT.MemberOf = {'DCCT'; 'Diagnostics'};
AO.DCCT.DeviceList = [1 1];
AO.DCCT.ElementList = 1;
AO.DCCT.Status = 1;
AO.DCCT.Position = 0;

AO.DCCT.Monitor.Mode = OperationalMode;
AO.DCCT.Monitor.DataType = 'Scalar';
AO.DCCT.Monitor.ChannelNames = 'rcurr';
AO.DCCT.Monitor.HW2PhysicsParams = 0.001;
AO.DCCT.Monitor.Physics2HWParams = 1000;
AO.DCCT.Monitor.Units = 'Hardware';
AO.DCCT.Monitor.HWUnits = 'mA';
AO.DCCT.Monitor.PhysicsUnits = 'A';


% The operational mode sets the path, filenames, and other important parameters
% Run setoperationalmode after most of the AO is built so that the Units and Mode fields
% can be set in setoperationalmode
setao(AO);
setoperationalmode(ModeNumber);
%AO = getao;

