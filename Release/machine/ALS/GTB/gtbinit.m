function gtbinit(OperationalMode)
%GTBINIT


% To-do
% 1. Get the magnet ramprates and figure out how to make runflag work
% 2. Next pulse, gun on/off, other timing?
%    Gun on/off
%    'GTL_____TIMING_NM00'
%    'GTL_____TIMING_BC00'
%
%    Next pulse
%    'GTL_____TIMING_BM01'  % What does this mean?
%    'GTL_____TIMING_BC01'  % Is this auto reset after the pulse happens?
% 3. gtbcontrol - on/off, save/restor, cycle, etc.


if nargin < 1
    % 1 => 50 MeV injection
    OperationalMode = 1;
end


%%%%%%%%%%%%%%%%
% Build the AO %
%%%%%%%%%%%%%%%%
setao([]);

% BPM
AO.BPMx.FamilyName  = 'BPMx';
AO.BPMx.MemberOf    = {'PlotFamily'; 'BPM'; 'BPMx';};
AO.BPMx.DeviceList  = [1 1; 1 2; 2 2; 3 1; 3 2; 3 4; 3 5; 3 6; 3 7;];  % 1 3; 2 1; ???
AO.BPMx.ElementList = (1:size(AO.BPMx.DeviceList,1))';
AO.BPMx.Status      = ones(size(AO.BPMx.DeviceList,1),1);
AO.BPMx.Position    = [];
AO.BPMx.CommonNames = getname_gtb('BPMx', 'CommonNames');

AO.BPMx.Monitor.MemberOf = {'BPM'; 'BPMx'; 'Monitor';};
AO.BPMx.Monitor.Mode = 'Simulator';
AO.BPMx.Monitor.DataType = 'Scalar';
AO.BPMx.Monitor.ChannelNames = getname_gtb(AO.BPMx.FamilyName, 'Monitor');
AO.BPMx.Monitor.HW2PhysicsParams = 1e-3;  % HW [mm], Simulator [Meters]
AO.BPMx.Monitor.Physics2HWParams = 1000;
AO.BPMx.Monitor.Units        = 'Hardware';
AO.BPMx.Monitor.HWUnits          = 'mm';
AO.BPMx.Monitor.PhysicsUnits     = 'Meter';
%AO.BPMx.Monitor.SpecialFunctionGet = @getx_gtb;


AO.BPMy.FamilyName  = 'BPMy';
AO.BPMy.MemberOf    = {'PlotFamily'; 'BPM'; 'BPMy';};
AO.BPMy.DeviceList  = AO.BPMx.DeviceList;
AO.BPMy.ElementList = AO.BPMx.ElementList;
AO.BPMy.Status      = AO.BPMx.Status;
AO.BPMy.Position    = [];
AO.BPMy.CommonNames = getname_gtb('BPMy', 'CommonNames');

AO.BPMy.Monitor.MemberOf = {'BPM'; 'BPMy'; 'Monitor';};
AO.BPMy.Monitor.Mode = 'Simulator';
AO.BPMy.Monitor.DataType = 'Scalar';
AO.BPMy.Monitor.ChannelNames = getname_gtb(AO.BPMy.FamilyName, 'Monitor');
AO.BPMy.Monitor.HW2PhysicsParams = 1e-3;  % HW [mm], Simulator [Meters]
AO.BPMy.Monitor.Physics2HWParams = 1000;
AO.BPMy.Monitor.Units            = 'Hardware';
AO.BPMy.Monitor.HWUnits          = 'mm';
AO.BPMy.Monitor.PhysicsUnits     = 'Meter';
%AO.BPMy.Monitor.SpecialFunctionGet = @gety_gtb;


% HCM
AO.HCM.FamilyName  = 'HCM';
AO.HCM.MemberOf    = {'HCM'; 'Magnet'; 'COR';};
AO.HCM.DeviceList  = [1 1; 1 2; 1 3; 1 4; 2 1; 2 2; 3 1; 3 2; 3 7];
AO.HCM.ElementList = (1:size(AO.HCM.DeviceList,1))';
AO.HCM.Status      = ones(size(AO.HCM.DeviceList,1),1);
AO.HCM.Status(end) = 0;  % LTB HC7 was removed
AO.HCM.Position    = [];
AO.HCM.CommonNames = getname_gtb('HCM', 'CommonNames');

AO.HCM.Monitor.MemberOf = {'HCM'; 'Magnet'; 'COR'; 'Monitor'; 'PlotFamily';};
AO.HCM.Monitor.Mode = 'Simulator';
AO.HCM.Monitor.DataType = 'Scalar';
AO.HCM.Monitor.ChannelNames = getname_gtb(AO.HCM.FamilyName, 'Monitor');
AO.HCM.Monitor.HW2PhysicsFcn = @gtb2at;
AO.HCM.Monitor.Physics2HWFcn = @at2gtb;
AO.HCM.Monitor.Units        = 'Hardware';
AO.HCM.Monitor.HWUnits      = 'Ampere';
AO.HCM.Monitor.PhysicsUnits = 'Radian';
AO.HCM.Monitor.Real2RawFcn = @real2raw_gtb;
AO.HCM.Monitor.Raw2RealFcn = @raw2real_gtb;

AO.HCM.Setpoint.MemberOf = {'HCM'; 'Magnet'; 'COR'; 'MachineConfig'; 'Setpoint'};
AO.HCM.Setpoint.Mode = 'Simulator';
AO.HCM.Setpoint.DataType = 'Scalar';
AO.HCM.Setpoint.ChannelNames = getname_gtb(AO.HCM.FamilyName, 'Setpoint');
AO.HCM.Setpoint.HW2PhysicsFcn = @gtb2at;
AO.HCM.Setpoint.Physics2HWFcn = @at2gtb;
AO.HCM.Setpoint.Units        = 'Hardware';
AO.HCM.Setpoint.HWUnits      = 'Ampere';
AO.HCM.Setpoint.PhysicsUnits = 'Radian';
AO.HCM.Setpoint.Range = [
    -4.0000    4.0000
    -4.0000    4.0000
    -4.0000    4.0000
    -4.0000    4.0000
    -4.0000    4.0000
    -4.0000    4.0000
    -2.9000    2.9000
    -2.9000    2.9000
    -2.9000    2.9000
    ];
AO.HCM.Setpoint.Tolerance  = .5 * ones(length(AO.HCM.ElementList), 1);  % Hardware units
AO.HCM.Setpoint.Tolerance(end) = 100;  % Broken monitor channel
AO.HCM.Setpoint.DeltaRespMat = .5;
AO.HCM.Setpoint.RampRate = 1;
%AO.HCM.Setpoint.RunFlagFcn = @getrunflag_gtb;

% AO.HCM.RampRate.MemberOf = {'HCM'; 'Magnet'; 'COR'; 'PlotFamily'; 'MachineConfig';};
% AO.HCM.RampRate.Mode = 'Simulator';
% AO.HCM.RampRate.DataType = 'Scalar';
% AO.HCM.RampRate.ChannelNames = getname_gtb(AO.HCM.FamilyName, 'RampRate');
% AO.HCM.RampRate.HW2PhysicsParams = 1;
% AO.HCM.RampRate.Physics2HWParams = 1;
% AO.HCM.RampRate.Units        = 'Hardware';
% AO.HCM.RampRate.HWUnits      = 'Ampere/Second';
% AO.HCM.RampRate.PhysicsUnits = 'Ampere/Second';
%
% AO.HCM.TimeConstant.MemberOf = {'HCM'; 'Magnet'; 'COR'; 'PlotFamily';};
% AO.HCM.TimeConstant.Mode = 'Simulator';
% AO.HCM.TimeConstant.DataType = 'Scalar';
% AO.HCM.TimeConstant.ChannelNames = getname_gtb(AO.HCM.FamilyName, 'TimeConstant');
% AO.HCM.TimeConstant.HW2PhysicsParams = 1;
% AO.HCM.TimeConstant.Physics2HWParams = 1;
% AO.HCM.TimeConstant.Units        = 'Hardware';
% AO.HCM.TimeConstant.HWUnits      = 'Second';
% AO.HCM.TimeConstant.PhysicsUnits = 'Second';
%
% AO.HCM.DAC.MemberOf = 'HCM'; 'Magnet'; 'COR'; PlotFamily';};
% AO.HCM.DAC.Mode = 'Simulator';
% AO.HCM.DAC.DataType = 'Scalar';
% AO.HCM.DAC.ChannelNames = getname_gtb(AO.HCM.FamilyName, 'DAC');
% AO.HCM.DAC.HW2PhysicsParams = 1;
% AO.HCM.DAC.Physics2HWParams = 1;
% AO.HCM.DAC.Units        = 'Hardware';
% AO.HCM.DAC.HWUnits      = 'Ampere';
% AO.HCM.DAC.PhysicsUnits = 'Ampere';

AO.HCM.On.MemberOf = {'HCM'; 'Magnet'; 'COR'; 'PlotFamily'; 'Boolean Monitor';};
AO.HCM.On.Mode = 'Simulator';
AO.HCM.On.DataType = 'Scalar';
AO.HCM.On.ChannelNames = getname_gtb(AO.HCM.FamilyName, 'On');
AO.HCM.On.HW2PhysicsParams = 1;
AO.HCM.On.Physics2HWParams = 1;
AO.HCM.On.Units        = 'Hardware';
AO.HCM.On.HWUnits      = '';
AO.HCM.On.PhysicsUnits = '';

AO.HCM.OnControl.MemberOf = {'HCM'; 'Magnet'; 'COR'; 'PlotFamily'; 'Boolean Control';};
AO.HCM.OnControl.Mode = 'Simulator';
AO.HCM.OnControl.DataType = 'Scalar';
AO.HCM.OnControl.ChannelNames = getname_gtb(AO.HCM.FamilyName, 'OnControl');
AO.HCM.OnControl.HW2PhysicsParams = 1;
AO.HCM.OnControl.Physics2HWParams = 1;
AO.HCM.OnControl.Units        = 'Hardware';
AO.HCM.OnControl.HWUnits      = '';
AO.HCM.OnControl.PhysicsUnits = '';
AO.HCM.OnControl.Range = [0 1];

AO.HCM.Reset.MemberOf = {'HCM'; 'Magnet'; 'COR'; 'PlotFamily'; 'Boolean Control';};
AO.HCM.Reset.Mode = 'Simulator';
AO.HCM.Reset.DataType = 'Scalar';
AO.HCM.Reset.ChannelNames = getname_gtb(AO.HCM.FamilyName, 'Reset');
AO.HCM.Reset.HW2PhysicsParams = 1;
AO.HCM.Reset.Physics2HWParams = 1;
AO.HCM.Reset.Units        = 'Hardware';
AO.HCM.Reset.HWUnits      = '';
AO.HCM.Reset.PhysicsUnits = '';
AO.HCM.Reset.Range = [0 1];

AO.HCM.Ready.MemberOf = {'HCM'; 'Magnet'; 'COR'; 'PlotFamily'; 'Boolean Monitor';};
AO.HCM.Ready.Mode = 'Simulator';
AO.HCM.Ready.DataType = 'Scalar';
AO.HCM.Ready.ChannelNames = getname_gtb(AO.HCM.FamilyName, 'Ready');
AO.HCM.Ready.HW2PhysicsParams = 1;
AO.HCM.Ready.Physics2HWParams = 1;
AO.HCM.Ready.Units        = 'Hardware';
AO.HCM.Ready.HWUnits      = '';
AO.HCM.Ready.PhysicsUnits = '';

AO.HCM.Local.MemberOf = {'HCM'; 'Magnet'; 'COR'; 'PlotFamily';};
AO.HCM.Local.Mode = 'Simulator';
AO.HCM.Local.DataType = 'Scalar';
AO.HCM.Local.ChannelNames = getname_gtb(AO.HCM.FamilyName, 'LOCAL');
AO.HCM.Local.HW2PhysicsParams = 1;
AO.HCM.Local.Physics2HWParams = 1;
AO.HCM.Local.Units        = 'Hardware';
AO.HCM.Local.HWUnits      = '';
AO.HCM.Local.PhysicsUnits = '';

AO.HCM.Computer.MemberOf = {'HCM'; 'Magnet'; 'COR'; 'PlotFamily';};
AO.HCM.Computer.Mode = 'Simulator';
AO.HCM.Computer.DataType = 'Scalar';
AO.HCM.Computer.ChannelNames = getname_gtb(AO.HCM.FamilyName, 'COMPUTER');
AO.HCM.Computer.HW2PhysicsParams = 1;
AO.HCM.Computer.Physics2HWParams = 1;
AO.HCM.Computer.Units        = 'Hardware';
AO.HCM.Computer.HWUnits      = '';
AO.HCM.Computer.PhysicsUnits = '';

AO.HCM.Interlock.MemberOf = {'HCM'; 'Magnet'; 'COR'; 'PlotFamily';};
AO.HCM.Interlock.Mode = 'Simulator';
AO.HCM.Interlock.DataType = 'Scalar';
AO.HCM.Interlock.ChannelNames = getname_gtb(AO.HCM.FamilyName, 'EXT_INTLK_OK');
AO.HCM.Interlock.HW2PhysicsParams = 1;
AO.HCM.Interlock.Physics2HWParams = 1;
AO.HCM.Interlock.Units        = 'Hardware';
AO.HCM.Interlock.HWUnits      = '';
AO.HCM.Interlock.PhysicsUnits = '';

AO.HCM.PS_THERM_OK.MemberOf = {'HCM'; 'Magnet'; 'COR'; 'PlotFamily'; 'Boolean Monitor';};
AO.HCM.PS_THERM_OK.Mode = 'Simulator';
AO.HCM.PS_THERM_OK.DataType = 'Scalar';
AO.HCM.PS_THERM_OK.ChannelNames = getname_gtb(AO.HCM.FamilyName, 'PS_THERM_OK');
AO.HCM.PS_THERM_OK.HW2PhysicsParams = 1;
AO.HCM.PS_THERM_OK.Physics2HWParams = 1;
AO.HCM.PS_THERM_OK.Units        = 'Hardware';
AO.HCM.PS_THERM_OK.HWUnits      = '';
AO.HCM.PS_THERM_OK.PhysicsUnits = '';

AO.HCM.DC_24V_OK.MemberOf = {'HCM'; 'Magnet'; 'COR'; 'PlotFamily'; 'Boolean Monitor';};
AO.HCM.DC_24V_OK.Mode = 'Simulator';
AO.HCM.DC_24V_OK.DataType = 'Scalar';
AO.HCM.DC_24V_OK.ChannelNames = getname_gtb(AO.HCM.FamilyName, 'DC_24V_OK');
AO.HCM.DC_24V_OK.HW2PhysicsParams = 1;
AO.HCM.DC_24V_OK.Physics2HWParams = 1;
AO.HCM.DC_24V_OK.Units        = 'Hardware';
AO.HCM.DC_24V_OK.HWUnits      = '';
AO.HCM.DC_24V_OK.PhysicsUnits = '';

AO.HCM.AC_120V_OK.MemberOf = {'HCM'; 'Magnet'; 'COR'; 'PlotFamily'; 'Boolean Monitor';};
AO.HCM.AC_120V_OK.Mode = 'Simulator';
AO.HCM.AC_120V_OK.DataType = 'Scalar';
AO.HCM.AC_120V_OK.ChannelNames = getname_gtb(AO.HCM.FamilyName, 'AC_120V_OK');
AO.HCM.AC_120V_OK.HW2PhysicsParams = 1;
AO.HCM.AC_120V_OK.Physics2HWParams = 1;
AO.HCM.AC_120V_OK.Units        = 'Hardware';
AO.HCM.AC_120V_OK.HWUnits      = '';
AO.HCM.AC_120V_OK.PhysicsUnits = '';


% VCM
AO.VCM.FamilyName  = 'VCM';
AO.VCM.MemberOf    = {'VCM'; 'Magnet'; 'COR';};
AO.VCM.DeviceList  = [1 1; 1 2; 1 3; 1 4; 2 1; 2 2; 3 1; 3 2; 3 3; 3 4; 3 5; 3 6; 3 7;];
AO.VCM.ElementList = (1:size(AO.VCM.DeviceList,1))';
AO.VCM.Status      = ones(size(AO.VCM.DeviceList,1),1);
AO.VCM.Position    = [];
AO.VCM.CommonNames = getname_gtb('VCM', 'CommonNames');

AO.VCM.Monitor.MemberOf = {'VCM'; 'Magnet'; 'COR'; 'Monitor'; 'PlotFamily';};
AO.VCM.Monitor.Mode = 'Simulator';
AO.VCM.Monitor.DataType = 'Scalar';
AO.VCM.Monitor.ChannelNames = getname_gtb(AO.VCM.FamilyName, 'Monitor');
AO.VCM.Monitor.HW2PhysicsFcn = @gtb2at;
AO.VCM.Monitor.Physics2HWFcn = @at2gtb;
AO.VCM.Monitor.Units        = 'Hardware';
AO.VCM.Monitor.HWUnits      = 'Ampere';
AO.VCM.Monitor.PhysicsUnits = 'Radian';
AO.VCM.Monitor.Real2RawFcn = @real2raw_gtb;
AO.VCM.Monitor.Raw2RealFcn = @raw2real_gtb;

AO.VCM.Setpoint.MemberOf = {'VCM'; 'Magnet'; 'COR'; 'MachineConfig'; 'Setpoint'};
AO.VCM.Setpoint.Mode = 'Simulator';
AO.VCM.Setpoint.DataType = 'Scalar';
AO.VCM.Setpoint.ChannelNames = getname_gtb(AO.VCM.FamilyName, 'Setpoint');
AO.VCM.Setpoint.HW2PhysicsFcn = @gtb2at;
AO.VCM.Setpoint.Physics2HWFcn = @at2gtb;
AO.VCM.Setpoint.Units        = 'Hardware';
AO.VCM.Setpoint.HWUnits      = 'Ampere';
AO.VCM.Setpoint.PhysicsUnits = 'Radian';
AO.VCM.Setpoint.Range = [
    -4.0000    4.0000
    -4.0000    4.0000
    -4.0000    4.0000
    -4.0000    4.0000
    -4.0000    4.0000
    -4.0000    4.0000
    -2.9000    2.9000
    -2.9000    2.9000
    -2.9000    2.9000
    -2.9000    2.9000
    -2.9000    2.9000
    -2.9000    2.9000
    -2.9000    2.9000
    ];
AO.VCM.Setpoint.Tolerance  = .5 * ones(length(AO.VCM.ElementList), 1);  % Hardware units
AO.VCM.Setpoint.DeltaRespMat = .5;
AO.VCM.Setpoint.RampRate = 1;
%AO.VCM.Setpoint.RunFlagFcn = @getrunflag_gtb;

% AO.VCM.RampRate.MemberOf = {'VCM'; 'Magnet'; 'COR'; 'PlotFamily'; 'MachineConfig';};
% AO.VCM.RampRate.Mode = 'Simulator';
% AO.VCM.RampRate.DataType = 'Scalar';
% AO.VCM.RampRate.ChannelNames = getname_gtb(AO.VCM.FamilyName, 'RampRate');
% AO.VCM.RampRate.HW2PhysicsParams = 1;
% AO.VCM.RampRate.Physics2HWParams = 1;
% AO.VCM.RampRate.Units        = 'Hardware';
% AO.VCM.RampRate.HWUnits      = 'Ampere/Second';
% AO.VCM.RampRate.PhysicsUnits = 'Ampere/Second';
%
% AO.VCM.TimeConstant.MemberOf = {'VCM'; 'Magnet'; 'COR'; 'PlotFamily'; };
% AO.VCM.TimeConstant.Mode = 'Simulator';
% AO.VCM.TimeConstant.DataType = 'Scalar';
% AO.VCM.TimeConstant.ChannelNames = getname_gtb(AO.VCM.FamilyName, 'TimeConstant');
% AO.VCM.TimeConstant.HW2PhysicsParams = 1;
% AO.VCM.TimeConstant.Physics2HWParams = 1;
% AO.VCM.TimeConstant.Units        = 'Hardware';
% AO.VCM.TimeConstant.HWUnits      = 'Second';
% AO.VCM.TimeConstant.PhysicsUnits = 'Second';
%
% AO.VCM.DAC.MemberOf = {'VCM'; 'Magnet'; 'COR'; 'PlotFamily';};
% AO.VCM.DAC.Mode = 'Simulator';
% AO.VCM.DAC.DataType = 'Scalar';
% AO.VCM.DAC.ChannelNames = getname_gtb(AO.VCM.FamilyName, 'DAC');
% AO.VCM.DAC.HW2PhysicsParams = 1;
% AO.VCM.DAC.Physics2HWParams = 1;
% AO.VCM.DAC.Units        = 'Hardware';
% AO.VCM.DAC.HWUnits      = 'Ampere';
% AO.VCM.DAC.PhysicsUnits = 'Ampere';

AO.VCM.On.MemberOf = {'VCM'; 'Magnet'; 'COR'; 'PlotFamily'; 'Boolean Monitor';};
AO.VCM.On.Mode = 'Simulator';
AO.VCM.On.DataType = 'Scalar';
AO.VCM.On.ChannelNames = getname_gtb(AO.VCM.FamilyName, 'On');
AO.VCM.On.HW2PhysicsParams = 1;
AO.VCM.On.Physics2HWParams = 1;
AO.VCM.On.Units        = 'Hardware';
AO.VCM.On.HWUnits      = '';
AO.VCM.On.PhysicsUnits = '';

AO.VCM.OnControl.MemberOf = {'VCM'; 'Magnet'; 'COR'; 'PlotFamily'; 'Boolean Control';};
AO.VCM.OnControl.Mode = 'Simulator';
AO.VCM.OnControl.DataType = 'Scalar';
AO.VCM.OnControl.ChannelNames = getname_gtb(AO.VCM.FamilyName, 'OnControl');
AO.VCM.OnControl.HW2PhysicsParams = 1;
AO.VCM.OnControl.Physics2HWParams = 1;
AO.VCM.OnControl.Units        = 'Hardware';
AO.VCM.OnControl.HWUnits      = '';
AO.VCM.OnControl.PhysicsUnits = '';
AO.VCM.OnControl.Range = [0 1];

AO.VCM.Reset.MemberOf = {'VCM'; 'Magnet'; 'COR'; 'PlotFamily'; 'Boolean Control';};
AO.VCM.Reset.Mode = 'Simulator';
AO.VCM.Reset.DataType = 'Scalar';
AO.VCM.Reset.ChannelNames = getname_gtb(AO.VCM.FamilyName, 'Reset');
AO.VCM.Reset.HW2PhysicsParams = 1;
AO.VCM.Reset.Physics2HWParams = 1;
AO.VCM.Reset.Units        = 'Hardware';
AO.VCM.Reset.HWUnits      = '';
AO.VCM.Reset.PhysicsUnits = '';
AO.VCM.Reset.Range = [0 1];

AO.VCM.Ready.MemberOf = {'VCM'; 'Magnet'; 'COR'; 'PlotFamily'; 'Boolean Monitor';};
AO.VCM.Ready.Mode = 'Simulator';
AO.VCM.Ready.DataType = 'Scalar';
AO.VCM.Ready.ChannelNames = getname_gtb(AO.VCM.FamilyName, 'Ready');
AO.VCM.Ready.HW2PhysicsParams = 1;
AO.VCM.Ready.Physics2HWParams = 1;
AO.VCM.Ready.Units        = 'Hardware';
AO.VCM.Ready.HWUnits      = 'Second';
AO.VCM.Ready.PhysicsUnits = 'Second';



AO.Q.FamilyName = 'Q';
AO.Q.MemberOf   = {'QUAD';  'Magnet';};
AO.Q.DeviceList = [1 1; 1 2; 1 3; 3 1; 3 2; 3 3; 3 4; 3 5; 3 6; 3 7; 3 8; 3 9; 3 10;];
%                   Just the LTB [1 1; 1 2; 1 3; 2 1; 3 1; 3 2; 4 1; 4 2; 5 1; 6  1;];
AO.Q.ElementList = (1:size(AO.Q.DeviceList,1))';
AO.Q.Status = ones(size(AO.Q.DeviceList,1),1);
AO.Q.Position = [];
AO.Q.CommonNames = getname_gtb('Q', 'CommonNames');

AO.Q.Monitor.MemberOf = {'QUAD'; 'Magnet'; 'PlotFamily'; 'Monitor';};
AO.Q.Monitor.Mode = 'Simulator';
AO.Q.Monitor.DataType = 'Scalar';
AO.Q.Monitor.ChannelNames = getname_gtb(AO.Q.FamilyName, 'Monitor');
AO.Q.Monitor.HW2PhysicsFcn = @gtb2at;
AO.Q.Monitor.Physics2HWFcn = @at2gtb;
AO.Q.Monitor.Units        = 'Hardware';
AO.Q.Monitor.HWUnits      = 'Ampere';
AO.Q.Monitor.PhysicsUnits = '1/Meter^2';
AO.Q.Monitor.Real2RawFcn = @real2raw_gtb;
AO.Q.Monitor.Raw2RealFcn = @raw2real_gtb;

AO.Q.Setpoint.MemberOf = {'QUAD'; 'Magnet'; 'MachineConfig'; 'Setpoint';};
AO.Q.Setpoint.Mode = 'Simulator';
AO.Q.Setpoint.DataType = 'Scalar';
AO.Q.Setpoint.ChannelNames = getname_gtb(AO.Q.FamilyName, 'Setpoint');
AO.Q.Setpoint.HW2PhysicsFcn = @gtb2at;
AO.Q.Setpoint.Physics2HWFcn = @at2gtb;
AO.Q.Setpoint.Units        = 'Hardware';
AO.Q.Setpoint.HWUnits      = 'Ampere';
AO.Q.Setpoint.PhysicsUnits = '1/Meter^2';
AO.Q.Setpoint.Range = [
    0   10.0000
    0   10.0000
    0   10.0000
    0    8.0000  % Was -.5 ???
    0    8.0000
    0    8.0000
    0    8.0000
    0    8.0000
    0    8.0000
    0    8.0000
    0    8.0000
    0    8.0000
    0    8.0000
    ];
AO.Q.Setpoint.Tolerance = 1 * ones(length(AO.Q.ElementList), 1);  % Hardware units
AO.Q.Setpoint.DeltaRespMat = .5;
AO.Q.Setpoint.RampRate = .15;
%AO.Q.Setpoint.RunFlagFcn = @getrunflag_gtb;

% AO.Q.RampRate.MemberOf = {'QUAD'; 'Magnet'; 'PlotFamily'; 'MachineConfig';};
% AO.Q.RampRate.Mode = 'Simulator';
% AO.Q.RampRate.DataType = 'Scalar';
% AO.Q.RampRate.ChannelNames = getname_gtb('Q', 'RampRate');
% AO.Q.RampRate.HW2PhysicsFcn = @gtb2at;
% AO.Q.RampRate.Physics2HWFcn = @at2gtb;
% AO.Q.RampRate.Units        = 'Hardware';
% AO.Q.RampRate.HWUnits      = 'Ampere/Second';
% AO.Q.RampRate.PhysicsUnits = 'Ampere/Second';
%
% AO.Q.TimeConstant.MemberOf = {'QUAD'; 'Magnet'; 'PlotFamily'; 'MachineConfig';};
% AO.Q.TimeConstant.Mode = 'Simulator';
% AO.Q.TimeConstant.DataType = 'Scalar';
% AO.Q.TimeConstant.ChannelNames = getname_gtb('Q', 'TimeConstant');
% AO.Q.TimeConstant.HW2PhysicsParams = 1;
% AO.Q.TimeConstant.Physics2HWParams = 1;
% AO.Q.TimeConstant.Units        = 'Hardware';
% AO.Q.TimeConstant.HWUnits      = 'Second';
% AO.Q.TimeConstant.PhysicsUnits = 'Second';
%
% AO.Q.DAC.MemberOf = {'QUAD'; 'Magnet'; 'PlotFamily';};
% AO.Q.DAC.Mode = 'Simulator';
% AO.Q.DAC.DataType = 'Scalar';
% AO.Q.DAC.ChannelNames = getname_gtb('Q', 'DAC');
% AO.Q.DAC.HW2PhysicsParams = 1;
% AO.Q.DAC.Physics2HWParams = 1;
% AO.Q.DAC.Units        = 'Hardware';
% AO.Q.DAC.HWUnits      = 'Ampere';
% AO.Q.DAC.PhysicsUnits = 'Ampere';

AO.Q.On.MemberOf = {'QUAD'; 'Magnet'; 'PlotFamily'; 'Boolean Monitor';};
AO.Q.On.Mode = 'Simulator';
AO.Q.On.DataType = 'Scalar';
AO.Q.On.ChannelNames = getname_gtb('Q', 'On');
AO.Q.On.HW2PhysicsParams = 1;
AO.Q.On.Physics2HWParams = 1;
AO.Q.On.Units        = 'Hardware';
AO.Q.On.HWUnits      = '';
AO.Q.On.PhysicsUnits = '';

AO.Q.OnControl.MemberOf = {'QUAD'; 'Magnet'; 'PlotFamily'; 'Boolean Control';};
AO.Q.OnControl.Mode = 'Simulator';
AO.Q.OnControl.DataType = 'Scalar';
AO.Q.OnControl.ChannelNames = getname_gtb('Q', 'OnControl');
AO.Q.OnControl.HW2PhysicsParams = 1;
AO.Q.OnControl.Physics2HWParams = 1;
AO.Q.OnControl.Units        = 'Hardware';
AO.Q.OnControl.HWUnits      = '';
AO.Q.OnControl.PhysicsUnits = '';
AO.Q.OnControl.Range = [0 1];

AO.Q.Reset.MemberOf = {'QUAD'; 'Magnet'; 'PlotFamily'; 'Boolean Control';};
AO.Q.Reset.Mode = 'Simulator';
AO.Q.Reset.DataType = 'Scalar';
AO.Q.Reset.ChannelNames = getname_gtb('Q', 'Reset');
AO.Q.Reset.HW2PhysicsParams = 1;
AO.Q.Reset.Physics2HWParams = 1;
AO.Q.Reset.Units        = 'Hardware';
AO.Q.Reset.HWUnits      = '';
AO.Q.Reset.PhysicsUnits = '';
AO.Q.Reset.Range = [0 1];

AO.Q.Ready.MemberOf = {'QUAD'; 'Magnet'; 'PlotFamily'; 'Boolean Monitor';};
AO.Q.Ready.Mode = 'Simulator';
AO.Q.Ready.DataType = 'Scalar';
AO.Q.Ready.ChannelNames = getname_gtb('Q', 'Ready');
AO.Q.Ready.HW2PhysicsParams = 1;
AO.Q.Ready.Physics2HWParams = 1;
AO.Q.Ready.Units        = 'Hardware';
AO.Q.Ready.HWUnits      = '';
AO.Q.Ready.PhysicsUnits = '';



AO.BEND.FamilyName = 'BEND';
AO.BEND.MemberOf   = {'BEND'; 'Magnet'};
AO.BEND.DeviceList = [3 1; 3 2; 3 3; 3 4;];
AO.BEND.ElementList = (1:size(AO.BEND.DeviceList,1))';
AO.BEND.Status = ones(size(AO.BEND.DeviceList,1),1);
AO.BEND.Position = [];
AO.BEND.CommonNames = getname_gtb('BEND', 'CommonNames');

AO.BEND.Monitor.MemberOf = {'BEND'; 'Magnet'; 'PlotFamily'; 'Monitor';};
AO.BEND.Monitor.Mode = 'Simulator';
AO.BEND.Monitor.DataType = 'Scalar';
AO.BEND.Monitor.ChannelNames = getname_gtb(AO.BEND.FamilyName, 'Monitor');
AO.BEND.Monitor.HW2PhysicsFcn = @gtb2at;
AO.BEND.Monitor.Physics2HWFcn = @at2gtb;
AO.BEND.Monitor.Units        = 'Hardware';
AO.BEND.Monitor.HWUnits      = 'Ampere';
AO.BEND.Monitor.PhysicsUnits = 'Radian';
AO.BEND.Monitor.Real2RawFcn = @real2raw_gtb;
AO.BEND.Monitor.Raw2RealFcn = @raw2real_gtb;

AO.BEND.Setpoint.MemberOf = {'BEND'; 'Magnet'; 'MachineConfig'; 'Setpoint';};
AO.BEND.Setpoint.Mode = 'Simulator';
AO.BEND.Setpoint.DataType = 'Scalar';
AO.BEND.Setpoint.ChannelNames = getname_gtb(AO.BEND.FamilyName, 'Setpoint');
AO.BEND.Setpoint.HW2PhysicsFcn = @gtb2at;
AO.BEND.Setpoint.Physics2HWFcn = @at2gtb;
AO.BEND.Setpoint.Units        = 'Hardware';
AO.BEND.Setpoint.HWUnits      = 'Ampere';
AO.BEND.Setpoint.PhysicsUnits = 'Radian';
AO.BEND.Setpoint.Range = [
    0  220.0000
    0  220.0000
    0  250.0000
    0   10.0000
    ];
% In database
% AO.BEND.Setpoint.Range = [
%   -220.0000  220.0000
%     -2.2000  220.0000
%     -2.2000  250.0000
%     -1.0000   10.0000
%     ];
AO.BEND.Setpoint.Tolerance = [2 2 250 .5]';  % Hardware units (power outage damaged LTB,B2 AM)
AO.BEND.Setpoint.RampRate = [2 2 2 .1]';
%AO.BEND.Setpoint.RunFlagFcn = @getrunflag_gtb;

% AO.BEND.RampRate.MemberOf = {'BEND'; 'Magnet'; 'PlotFamily'; 'MachineConfig';};
% AO.BEND.RampRate.Mode = 'Simulator';
% AO.BEND.RampRate.DataType = 'Scalar';
% AO.BEND.RampRate.ChannelNames = getname_gtb(AO.BEND.FamilyName, 'RampRate');
% AO.BEND.RampRate.HW2PhysicsParams = 1;
% AO.BEND.RampRate.Physics2HWParams = 1;
% AO.BEND.RampRate.Units        = 'Hardware';
% AO.BEND.RampRate.HWUnits      = 'Ampere/Second';
% AO.BEND.RampRate.PhysicsUnits = 'Ampere/Second';
%
% AO.BEND.TimeConstant.MemberOf = {'BEND'; 'Magnet'; 'PlotFamily'; 'MachineConfig';};
% AO.BEND.TimeConstant.Mode = 'Simulator';
% AO.BEND.TimeConstant.DataType = 'Scalar';
% AO.BEND.TimeConstant.ChannelNames = getname_gtb(AO.BEND.FamilyName, 'TimeConstant');
% AO.BEND.TimeConstant.HW2PhysicsParams = 1;
% AO.BEND.TimeConstant.Physics2HWParams = 1;
% AO.BEND.TimeConstant.Units        = 'Hardware';
% AO.BEND.TimeConstant.HWUnits      = 'Second';
% AO.BEND.TimeConstant.PhysicsUnits = 'Second';
%
% AO.BEND.DAC.MemberOf = {'BEND'; 'Magnet'; 'PlotFamily';};
% AO.BEND.DAC.Mode = 'Simulator';
% AO.BEND.DAC.DataType = 'Scalar';
% AO.BEND.DAC.ChannelNames = getname_gtb(AO.BEND.FamilyName, 'DAC');
% AO.BEND.DAC.HW2PhysicsParams = 1;
% AO.BEND.DAC.Physics2HWParams = 1;
% AO.BEND.DAC.Units        = 'Hardware';
% AO.BEND.DAC.HWUnits      = 'Ampere';
% AO.BEND.DAC.PhysicsUnits = 'Ampere';

AO.BEND.On.MemberOf = {'BEND'; 'Magnet'; 'PlotFamily'; 'Boolean Monitor';};
AO.BEND.On.Mode = 'Simulator';
AO.BEND.On.DataType = 'Scalar';
AO.BEND.On.ChannelNames = getname_gtb(AO.BEND.FamilyName, 'On');
AO.BEND.On.HW2PhysicsParams = 1;
AO.BEND.On.Physics2HWParams = 1;
AO.BEND.On.Units        = 'Hardware';
AO.BEND.On.HWUnits      = '';
AO.BEND.On.PhysicsUnits = '';

AO.BEND.OnControl.MemberOf = {'BEND'; 'Magnet'; 'PlotFamily'; 'Boolean Control';};
AO.BEND.OnControl.Mode = 'Simulator';
AO.BEND.OnControl.DataType = 'Scalar';
AO.BEND.OnControl.ChannelNames = getname_gtb(AO.BEND.FamilyName, 'OnControl');
AO.BEND.OnControl.HW2PhysicsParams = 1;
AO.BEND.OnControl.Physics2HWParams = 1;
AO.BEND.OnControl.Units        = 'Hardware';
AO.BEND.OnControl.HWUnits      = '';
AO.BEND.OnControl.PhysicsUnits = '';
AO.BEND.OnControl.Range = [0 1];

AO.BEND.Reset.MemberOf = {'BEND'; 'Magnet'; 'PlotFamily'; 'Boolean Control';};
AO.BEND.Reset.Mode = 'Simulator';
AO.BEND.Reset.DataType = 'Scalar';
AO.BEND.Reset.ChannelNames = getname_gtb(AO.BEND.FamilyName, 'Reset');
AO.BEND.Reset.HW2PhysicsParams = 1;
AO.BEND.Reset.Physics2HWParams = 1;
AO.BEND.Reset.Units        = 'Hardware';
AO.BEND.Reset.HWUnits      = '';
AO.BEND.Reset.PhysicsUnits = '';
AO.BEND.Reset.Range = [0 1];

AO.BEND.Ready.MemberOf = {'BEND'; 'Magnet'; 'PlotFamily'; 'Boolean Monitor';};
AO.BEND.Ready.Mode = 'Simulator';
AO.BEND.Ready.DataType = 'Scalar';
AO.BEND.Ready.ChannelNames = getname_gtb(AO.BEND.FamilyName, 'Ready');
AO.BEND.Ready.HW2PhysicsParams = 1;
AO.BEND.Ready.Physics2HWParams = 1;
AO.BEND.Ready.Units        = 'Hardware';
AO.BEND.Ready.HWUnits      = '';
AO.BEND.Ready.PhysicsUnits = '';

AO.BEND.CtrlPower.MemberOf = {'BEND'; 'Magnet'; 'PlotFamily'; 'Boolean Monitor';};
AO.BEND.CtrlPower.Mode = 'Simulator';
AO.BEND.CtrlPower.DataType = 'Scalar';
AO.BEND.CtrlPower.ChannelNames = getname_gtb(AO.BEND.FamilyName, 'CtrlPower');
AO.BEND.CtrlPower.HW2PhysicsParams = 1;
AO.BEND.CtrlPower.Physics2HWParams = 1;
AO.BEND.CtrlPower.Units        = 'Hardware';
AO.BEND.CtrlPower.HWUnits      = '';
AO.BEND.CtrlPower.PhysicsUnits = '';

AO.BEND.OverTemperature.MemberOf = {'BEND'; 'Magnet'; 'PlotFamily'; 'Boolean Monitor';};
AO.BEND.OverTemperature.Mode = 'Simulator';
AO.BEND.OverTemperature.DataType = 'Scalar';
AO.BEND.OverTemperature.ChannelNames = getname_gtb(AO.BEND.FamilyName, 'OverTemperature');
AO.BEND.OverTemperature.HW2PhysicsParams = 1;
AO.BEND.OverTemperature.Physics2HWParams = 1;
AO.BEND.OverTemperature.Units        = 'Hardware';
AO.BEND.OverTemperature.HWUnits      = '';
AO.BEND.OverTemperature.PhysicsUnits = '';



AO.DCCT.FamilyName = 'DCCT';
AO.DCCT.MemberOf = {'DCCT';};
AO.DCCT.DeviceList = [1 1;1 2];
AO.DCCT.ElementList = [1;2];
AO.DCCT.Status = [1;1;];
AO.DCCT.Position = [0;35];  % ???

AO.DCCT.MemberOf = {'DCCT'; 'Monitor';};
AO.DCCT.Monitor.Mode = 'Simulator';
AO.DCCT.Monitor.DataType = 'Scalar';
AO.DCCT.Monitor.ChannelNames = ['LTB_____ICT01__AM02'; 'BR2_____ICT01__AM03'];
AO.DCCT.Monitor.HW2PhysicsParams = 1;
AO.DCCT.Monitor.Physics2HWParams = 1;
AO.DCCT.Monitor.Units        = 'Hardware';
AO.DCCT.Monitor.HWUnits      = 'mAmps';
AO.DCCT.Monitor.PhysicsUnits = 'mAmps';
%AO.DCCT.Monitor.SpecialFunctionGet = 'getdcct_gtb';

% Other ICTs
% 'BTS_____ICT01__AM00'
% 'BTS_____ICT02__AM01'

% Waveforms ICTs
% 'BTS_____ICT2___AT00'
% 'BR1_____ICT1___AT00'


AO.Timing.FamilyName = 'Timing';
AO.Timing.MemberOf = {'Timing';};
AO.Timing.DeviceList = [1 1; 1 2; 1 3; 1 4; 1 5;];
AO.Timing.ElementList = (1:5)';
AO.Timing.Status = ones(size(AO.Timing.DeviceList,1),1);
AO.Timing.Position = [0 1 2 3 4]';
AO.Timing.CommonNames = [
'Linac Tigger Delay '   
'Linac Rate         '
'Gun Rate           '
'Gun Width          '
'Kicker Tigger Delay'   
];

AO.Timing.MemberOf = {'Timing'; 'Monitor';};
AO.Timing.Monitor.Mode = 'Simulator';
AO.Timing.Monitor.DataType = 'Scalar';
AO.Timing.Monitor.ChannelNames = [
    'GTL_____TIMING_AM03'
    'GTL_____TIMING_AM01'
    'GTL_____TIMING_AM00'
    'GTL_____TIMING_AM02'
    'GTL_____TIMING_AM04'
    ];
AO.Timing.Monitor.HW2PhysicsParams = 1;
AO.Timing.Monitor.Physics2HWParams = 1;
AO.Timing.Monitor.Units        = 'Hardware';
AO.Timing.Monitor.HWUnits      = '';
AO.Timing.Monitor.PhysicsUnits = '';

AO.Timing.MemberOf = {'Timing'; 'MachineConfig'; 'Setpoint';};
AO.Timing.Setpoint.Mode = 'Simulator';
AO.Timing.Setpoint.DataType = 'Scalar';
AO.Timing.Setpoint.ChannelNames = [
    'GTL_____TIMING_AC03'
    'GTL_____TIMING_AC01'
    'GTL_____TIMING_AC00'
    'GTL_____TIMING_AC02'
    'GTL_____TIMING_AC04'
    ];
AO.Timing.Setpoint.HW2PhysicsParams = 1;
AO.Timing.Setpoint.Physics2HWParams = 1;
AO.Timing.Setpoint.Units        = 'Hardware';
AO.Timing.Setpoint.HWUnits      = '';
AO.Timing.Setpoint.PhysicsUnits = '';



% TV
AO.TV.FamilyName = 'TV';
AO.TV.MemberOf = {'PlotFamily'; 'TV';};
AO.TV.DeviceList = [1 1; 1 2; 2 1; 2 2; 3 1; 3 2; 3 4; 3 5; 3 6;];  %3 3;
AO.TV.ElementList = (1:size(AO.TV.DeviceList,1))';
AO.TV.Status = ones(size(AO.TV.DeviceList,1),1);
AO.TV.Position = (1:size(AO.TV.DeviceList,1))';
AO.TV.CommonNames = getname_gtb('TV', 'CommonNames');

AO.TV.Monitor.MemberOf = {'PlotFamily';  'Monitor';};
AO.TV.Monitor.Mode = 'Simulator';
AO.TV.Monitor.DataType = 'Scalar';
AO.TV.Monitor.ChannelNames = getname_gtb(AO.TV.FamilyName, 'Monitor');
AO.TV.Monitor.HW2PhysicsParams = 1;
AO.TV.Monitor.Physics2HWParams = 1;
AO.TV.Monitor.Units        = 'Hardware';
AO.TV.Monitor.HWUnits      = '';
AO.TV.Monitor.PhysicsUnits = '';

AO.TV.Setpoint.MemberOf = {'TV'; 'Setpoint'};
AO.TV.Setpoint.Mode = 'Simulator';
AO.TV.Setpoint.DataType = 'Scalar';
AO.TV.Setpoint.ChannelNames = getname_gtb(AO.TV.FamilyName, 'Setpoint');
AO.TV.Setpoint.HW2PhysicsParams = 1;
AO.TV.Setpoint.Physics2HWParams = 1;
AO.TV.Setpoint.Units        = 'Hardware';
AO.TV.Setpoint.HWUnits      = '';
AO.TV.Setpoint.PhysicsUnits = '';
AO.TV.Setpoint.Range = [0 1];
AO.TV.Setpoint.Tolerance = .5 * ones(length(AO.TV.ElementList), 1);  % Hardware units
AO.TV.Setpoint.SpecialFunctionGet = @gettv_gtb;
AO.TV.Setpoint.SpecialFunctionSet = @settv_gtb;

AO.TV.In.MemberOf = {'PlotFamily'; 'Boolean Monitor';};
AO.TV.In.Mode = 'Simulator';
AO.TV.In.DataType = 'Scalar';
AO.TV.In.ChannelNames = getname_gtb(AO.TV.FamilyName, 'In');
AO.TV.In.HW2PhysicsParams = 1;
AO.TV.In.Physics2HWParams = 1;
AO.TV.In.Units        = 'Hardware';
AO.TV.In.HWUnits      = '';
AO.TV.In.PhysicsUnits = '';

AO.TV.Out.MemberOf = {'PlotFamily'; 'Boolean Monitor';};
AO.TV.Out.Mode = 'Simulator';
AO.TV.Out.DataType = 'Scalar';
AO.TV.Out.ChannelNames = getname_gtb(AO.TV.FamilyName, 'Out');
AO.TV.Out.HW2PhysicsParams = 1;
AO.TV.Out.Physics2HWParams = 1;
AO.TV.Out.Units        = 'Hardware';
AO.TV.Out.HWUnits      = '';
AO.TV.Out.PhysicsUnits = '';

AO.TV.InControl.MemberOf = {'PlotFamily'; 'Boolean Control';};
AO.TV.InControl.Mode = 'Simulator';
AO.TV.InControl.DataType = 'Scalar';
AO.TV.InControl.ChannelNames = getname_gtb(AO.TV.FamilyName, 'InControl');
AO.TV.InControl.HW2PhysicsParams = 1;
AO.TV.InControl.Physics2HWParams = 1;
AO.TV.InControl.Units        = 'Hardware';
AO.TV.InControl.HWUnits      = '';
AO.TV.InControl.PhysicsUnits = '';
AO.TV.InControl.Range = [0 1];

AO.TV.Lamp.MemberOf = {'PlotFamily'; 'Boolean Monitor';};
AO.TV.Lamp.Mode = 'Simulator';
AO.TV.Lamp.DataType = 'Scalar';
AO.TV.Lamp.ChannelNames = getname_gtb(AO.TV.FamilyName, 'Lamp');
AO.TV.Lamp.HW2PhysicsParams = 1;
AO.TV.Lamp.Physics2HWParams = 1;
AO.TV.Lamp.Units        = 'Hardware';
AO.TV.Lamp.HWUnits      = '';
AO.TV.Lamp.PhysicsUnits = '';
AO.TV.Lamp.Range = [0 1]; % ???


% VVR
AO.VVR.FamilyName  = 'VVR';
AO.VVR.MemberOf    = {'VVR'; 'Vacuum';};
AO.VVR.DeviceList  = [1 1; 2 1; 3 1; 3 2;];
AO.VVR.ElementList = (1:size(AO.VVR.DeviceList,1))';
AO.VVR.Status      = ones(size(AO.VVR.DeviceList,1),1);
AO.VVR.Position    = [1 2 3 4]';
AO.VVR.CommonNames = getname_gtb('VVR', 'CommonNames');

AO.VVR.OpenControl.MemberOf = {'VVR'; 'Vacuum'; 'Boolean Control'; 'MachineConfig'; 'PlotFamily';};
AO.VVR.OpenControl.Mode = 'Simulator';
AO.VVR.OpenControl.DataType = 'Scalar';
AO.VVR.OpenControl.ChannelNames = getname_gtb(AO.VVR.FamilyName, 'OpenControl');
AO.VVR.OpenControl.HW2PhysicsParams = 1;
AO.VVR.OpenControl.Physics2HWParams = 1;
AO.VVR.OpenControl.Units        = 'Hardware';
AO.VVR.OpenControl.HWUnits      = '';
AO.VVR.OpenControl.PhysicsUnits = '';
AO.VVR.OpenControl.Range = [0 1];

AO.VVR.Open.MemberOf = {'VVR'; 'Vacuum'; 'Boolean Monitor'; 'PlotFamily';};
AO.VVR.Open.Mode = 'Simulator';
AO.VVR.Open.DataType = 'Scalar';
AO.VVR.Open.ChannelNames = getname_gtb(AO.VVR.FamilyName, 'Open');
AO.VVR.Open.HW2PhysicsParams = 1;
AO.VVR.Open.Physics2HWParams = 1;
AO.VVR.Open.Units        = 'Hardware';
AO.VVR.Open.HWUnits      = '';
AO.VVR.Open.PhysicsUnits = '';

AO.VVR.Closed.MemberOf = {'VVR'; 'Vacuum'; 'PlotFamily'; 'Boolean Monitor';};
AO.VVR.Closed.Mode = 'Simulator';
AO.VVR.Closed.DataType = 'Scalar';
AO.VVR.Closed.ChannelNames = getname_gtb(AO.VVR.FamilyName, 'Closed');
AO.VVR.Closed.HW2PhysicsParams = 1;
AO.VVR.Closed.Physics2HWParams = 1;
AO.VVR.Closed.Units        = 'Hardware';
AO.VVR.Closed.HWUnits      = '';
AO.VVR.Closed.PhysicsUnits = '';

AO.VVR.UpStream.MemberOf = {'VVR'; 'Vacuum'; 'PlotFamily'; 'Boolean Monitor';};
AO.VVR.UpStream.Mode = 'Simulator';
AO.VVR.UpStream.DataType = 'Scalar';
AO.VVR.UpStream.ChannelNames = getname_gtb(AO.VVR.FamilyName, 'UpStream');
AO.VVR.UpStream.HW2PhysicsParams = 1;
AO.VVR.UpStream.Physics2HWParams = 1;
AO.VVR.UpStream.Units        = 'Hardware';
AO.VVR.UpStream.HWUnits      = '';
AO.VVR.UpStream.PhysicsUnits = '';

AO.VVR.DownStream.MemberOf = {'VVR'; 'Vacuum'; 'Boolean Monitor'; 'PlotFamily';};
AO.VVR.DownStream.Mode = 'Simulator';
AO.VVR.DownStream.DataType = 'Scalar';
AO.VVR.DownStream.ChannelNames = getname_gtb(AO.VVR.FamilyName, 'DownStream');
AO.VVR.DownStream.HW2PhysicsParams = 1;
AO.VVR.DownStream.Physics2HWParams = 1;
AO.VVR.DownStream.Units        = 'Hardware';
AO.VVR.DownStream.HWUnits      = '';
AO.VVR.DownStream.PhysicsUnits = '';

AO.VVR.Ready.MemberOf = {'VVR'; 'Vacuum'; 'Boolean Monitor'; 'PlotFamily';};
AO.VVR.Ready.Mode = 'Simulator';
AO.VVR.Ready.DataType = 'Scalar';
AO.VVR.Ready.ChannelNames = getname_gtb(AO.VVR.FamilyName, 'Ready');
AO.VVR.Ready.HW2PhysicsParams = 1;
AO.VVR.Ready.Physics2HWParams = 1;
AO.VVR.Ready.Units        = 'Hardware';
AO.VVR.Ready.HWUnits      = '';
AO.VVR.Ready.PhysicsUnits = '';

AO.VVR.Interlock.MemberOf = {'VVR'; 'Vacuum'; 'Boolean Monitor'; 'PlotFamily';};
AO.VVR.Interlock.Mode = 'Simulator';
AO.VVR.Interlock.DataType = 'Scalar';
AO.VVR.Interlock.ChannelNames = getname_gtb(AO.VVR.FamilyName, 'Interlock');
AO.VVR.Interlock.HW2PhysicsParams = 1;
AO.VVR.Interlock.Physics2HWParams = 1;
AO.VVR.Interlock.Units        = 'Hardware';
AO.VVR.Interlock.HWUnits      = '';
AO.VVR.Interlock.PhysicsUnits = '';

AO.VVR.Local.MemberOf = {'VVR'; 'Vacuum'; 'Boolean Monitor'; 'PlotFamily';};
AO.VVR.Local.Mode = 'Simulator';
AO.VVR.Local.DataType = 'Scalar';
AO.VVR.Local.ChannelNames = getname_gtb(AO.VVR.FamilyName, 'Local');
AO.VVR.Local.HW2PhysicsParams = 1;
AO.VVR.Local.Physics2HWParams = 1;
AO.VVR.Local.Units        = 'Hardware';
AO.VVR.Local.HWUnits      = '';
AO.VVR.Local.PhysicsUnits = '';

AO.VVR.DC_24V_OK.MemberOf = {'VVR'; 'Vacuum'; 'Boolean Monitor'; 'PlotFamily';};
AO.VVR.DC_24V_OK.Mode = 'Simulator';
AO.VVR.DC_24V_OK.DataType = 'Scalar';
AO.VVR.DC_24V_OK.ChannelNames = getname_gtb(AO.VVR.FamilyName, 'DC_24V_OK');
AO.VVR.DC_24V_OK.HW2PhysicsParams = 1;
AO.VVR.DC_24V_OK.Physics2HWParams = 1;
AO.VVR.DC_24V_OK.Units        = 'Hardware';
AO.VVR.DC_24V_OK.HWUnits      = '';
AO.VVR.DC_24V_OK.PhysicsUnits = '';

AO.VVR.Air.MemberOf = {'VVR'; 'Vacuum'; 'Boolean Monitor'; 'PlotFamily';};
AO.VVR.Air.Mode = 'Simulator';
AO.VVR.Air.DataType = 'Scalar';
AO.VVR.Air.ChannelNames = getname_gtb(AO.VVR.FamilyName, 'Air');
AO.VVR.Air.HW2PhysicsParams = 1;
AO.VVR.Air.Physics2HWParams = 1;
AO.VVR.Air.Units        = 'Hardware';
AO.VVR.Air.HWUnits      = '';
AO.VVR.Air.PhysicsUnits = '';

AO.VVR.Cathode.MemberOf = {'VVR'; 'Vacuum'; 'Boolean Monitor'; 'PlotFamily';};
AO.VVR.Cathode.Mode = 'Simulator';
AO.VVR.Cathode.DataType = 'Scalar';
AO.VVR.Cathode.ChannelNames = getname_gtb(AO.VVR.FamilyName, 'Cathode');
AO.VVR.Cathode.HW2PhysicsParams = 1;
AO.VVR.Cathode.Physics2HWParams = 1;
AO.VVR.Cathode.Units        = 'Hardware';
AO.VVR.Cathode.HWUnits      = '';
AO.VVR.Cathode.PhysicsUnits = '';


% EG
AO.EG.FamilyName = 'EG';
AO.EG.MemberOf = {'EG';};
AO.EG.DeviceList = [1 1; 1 2; 1 3; 1 4; 1 5; 1 6; 1 7; 1 8];
AO.EG.ElementList = (1:size(AO.EG.DeviceList,1))';
AO.EG.Status = ones(size(AO.EG.DeviceList,1),1);
AO.EG.Position = (1:size(AO.EG.DeviceList,1))';
AO.EG.CommonNames = [
    'EG_BIAS  '
    'EG_WBIAS '
    'EG_Phase '
    'EG_PULSER'
    'EG_HEATER'
    'EG_HV    '
    'EG_HV_I  '
    'EG_Temp  '
    ];

AO.EG.Monitor.MemberOf = {'EG'; 'Monitor';};
AO.EG.Monitor.Mode = 'Simulator';
AO.EG.Monitor.DataType = 'Scalar';
AO.EG.Monitor.ChannelNames = [
    'EG______BIAS___AM01'
    'EG______WBIAS__AM01'
    'EG______PHASE__AM02'
    'EG______PULSER_AM02'
    'EG______HTR____AM00'
    'EG______HV_____AM00'	% LI0147_TS1_4
    'EG______HV_I___AM01'	% LI0147_TS1_7
    'EG______HSTEMP_AM03'
    ];
AO.EG.Monitor.HW2PhysicsParams = 1;
AO.EG.Monitor.Physics2HWParams = 1;
AO.EG.Monitor.Units        = 'Hardware';
AO.EG.Monitor.HWUnits      = '';
AO.EG.Monitor.PhysicsUnits = '';

AO.EG.Setpoint.MemberOf = {'EG'; 'Setpoint'; 'MachineConfig';};
AO.EG.Setpoint.Mode = 'Simulator';
AO.EG.Setpoint.DataType = 'Scalar';
AO.EG.Setpoint.ChannelNames = [
    'EG______BIAS___AC01'
    'EG______WBIAS__AC01'
    'EG______PHASE__AC02'
    'EG______PULSER_AC02'
    'EG______HTR____AC00'
    'EG______HV_____AC00'	%LI0130_P65_C
    '                   '
    '                   '
    ];
AO.EG.Setpoint.HW2PhysicsParams = 1;
AO.EG.Setpoint.Physics2HWParams = 1;
AO.EG.Setpoint.Units        = 'Hardware';
AO.EG.Setpoint.HWUnits      = '';
AO.EG.Setpoint.PhysicsUnits = '';
AO.EG.Setpoint.Range = [-Inf Inf];
AO.EG.Setpoint.Tolerance = ones(length(AO.EG.ElementList), 1);  % Hardware units



% GTL
AO.GTL.FamilyName = 'GTL';
AO.GTL.MemberOf = {'GTL';};
AO.GTL.DeviceList = [1 1; 1 2; 1 3; 1 4; 1 5; 1 6;];
AO.GTL.ElementList = (1:size(AO.GTL.DeviceList,1))';
AO.GTL.Status = ones(size(AO.GTL.DeviceList,1),1);
AO.GTL.Position = (1:size(AO.GTL.DeviceList,1))';
AO.GTL.CommonNames = [
    'GTL_CH1_ADC_+     '
    'GTL_CH2_ADC_+     '
    'GTL_SHB1_125MHZ_HV'
    'GTL_SHB1_PHASE    '
    'GTL_SHB2_500MHZ_HV'
    'GTL_SHB2_PHASE    '
    ];

AO.GTL.Monitor.MemberOf = {'GTL'; 'Monitor'; 'PlotFamily';};
AO.GTL.Monitor.Mode = 'Simulator';
AO.GTL.Monitor.DataType = 'Scalar';
AO.GTL.Monitor.ChannelNames = [
    'GTL_____BC1____AM00' % CH1_ADC_+
    'GTL_____BC2____AM01' % CH2_ADC_+
    'GTL_____SHB1_HVAM01' % 125MHZ HV MON.
    'GTL_____SHB1_PHAM00' % PHASE MONITOR
    'GTL_____SHB2_HVAM01' % 500MHZ HV MON.
    'GTL_____SHB2_PHAM00' % PHASE MONITOR
    ];
AO.GTL.Monitor.HW2PhysicsParams = 1;
AO.GTL.Monitor.Physics2HWParams = 1;
AO.GTL.Monitor.Units        = 'Hardware';
AO.GTL.Monitor.HWUnits      = '';
AO.GTL.Monitor.PhysicsUnits = '';

AO.GTL.Setpoint.MemberOf = {'GTL'; 'MachineConfig'; 'Setpoint';};
AO.GTL.Setpoint.Mode = 'Simulator';
AO.GTL.Setpoint.DataType = 'Scalar';
AO.GTL.Setpoint.ChannelNames = [
    'GTL_____BC1____AC00' % CH1_DAC_+
    'GTL_____BC2____AC01' % CH2_DAC_+
    'GTL_____SHB1_HVAC01' % 125MHZ HV REF.
    'GTL_____SHB1_PHAC00' % PHASE REFERENCE
    'GTL_____SHB2_HVAC01' % 500MHZ HV REF.
    'GTL_____SHB2_PHAC00' % PHASE REFERENCE
    ];
AO.GTL.Setpoint.HW2PhysicsParams = 1;
AO.GTL.Setpoint.Physics2HWParams = 1;
AO.GTL.Setpoint.Units        = 'Hardware';
AO.GTL.Setpoint.HWUnits      = '';
AO.GTL.Setpoint.PhysicsUnits = '';
AO.GTL.Setpoint.Range = [-Inf Inf];
AO.GTL.Setpoint.Tolerance = ones(length(AO.GTL.ElementList), 1);  % Hardware units

AO.GTL.BC.MemberOf = {'GTL'; 'Boolean Control';};
AO.GTL.BC.Mode = 'Simulator';
AO.GTL.BC.DataType = 'Scalar';
AO.GTL.BC.ChannelNames = [
    '                   '
    '                   '
    'GTL_____SHB1_HVBC23' % HV ON/OFF
    'GTL_____SHB1_PHBC22' % PULSING ON/OFF
    'GTL_____SHB2_HVBC23' % HV ON/OFF
    'GTL_____SHB2_PHBC22' % PULSING ON/OFF
    ];
AO.GTL.BC.HW2PhysicsParams = 1;
AO.GTL.BC.Physics2HWParams = 1;
AO.GTL.BC.Units        = 'Hardware';
AO.GTL.BC.HWUnits      = '';
AO.GTL.BC.PhysicsUnits = '';
AO.GTL.BC.Range = [-Inf Inf];
AO.GTL.BC.Tolerance = ones(length(AO.GTL.ElementList), 1);  % Hardware units



AO.SOL.FamilyName = 'SOL';
AO.SOL.MemberOf = {'Solenoid';};
AO.SOL.DeviceList = [1 1; 1 2; 1 3; 2 1; 2 2; 2 3; 2 4];
AO.SOL.ElementList = (1:size(AO.SOL.DeviceList,1))';
AO.SOL.Status = ones(size(AO.SOL.DeviceList,1),1);
AO.SOL.Position = (1:size(AO.SOL.DeviceList,1))';
AO.SOL.CommonNames = [
    'GTL_SOL1'
    'GTL_SOL2'
    'GTL_SOL3'
    'LN_SOL1 '
    'LN_SOL2 '
    'LN_SOL3 '
    'LN_SOL4 '
    ];

AO.SOL.Monitor.MemberOf = {'SOL'; 'Monitor'; 'PlotFamily';};
AO.SOL.Monitor.Mode = 'Simulator';
AO.SOL.Monitor.DataType = 'Scalar';
AO.SOL.Monitor.ChannelNames = [
    'GTL_____SOL1___AM00'	% B
    'GTL_____SOL2___AM01'	% G
    'GTL_____SOL3___AM02'	% L
    'LN______SOL1___AM00'	% B
    'LN______SOL2___AM01'	% G
    'LN______SOL3___AM02'	% B
    'LN______SOL4___AM03'	% B
    ];
AO.SOL.Monitor.HW2PhysicsParams = 1;
AO.SOL.Monitor.Physics2HWParams = 1;
AO.SOL.Monitor.Units        = 'Hardware';
AO.SOL.Monitor.HWUnits      = '';
AO.SOL.Monitor.PhysicsUnits = '';

AO.SOL.Setpoint.MemberOf = {'SOL'; 'MachineConfig'; 'Setpoint'};
AO.SOL.Setpoint.Mode = 'Simulator';
AO.SOL.Setpoint.DataType = 'Scalar';
AO.SOL.Setpoint.ChannelNames = [
    'GTL_____SOL1___AC00'	% A
    'GTL_____SOL2___AC01'	% F
    'GTL_____SOL3___AC02'	% K
    'LN______SOL1___AC00'	% A
    'LN______SOL2___AC01'	% F
    'LN______SOL3___AC02'	% A
    'LN______SOL4___AC03'	% A
    ];
AO.SOL.Setpoint.HW2PhysicsParams = 1;
AO.SOL.Setpoint.Physics2HWParams = 1;
AO.SOL.Setpoint.Units        = 'Hardware';
AO.SOL.Setpoint.HWUnits      = '';
AO.SOL.Setpoint.PhysicsUnits = '';
AO.SOL.Setpoint.Range = [0 1];
AO.SOL.Setpoint.Tolerance = ones(length(AO.SOL.ElementList), 1);  % Hardware units

AO.SOL.OnControl.MemberOf = {'SOL'; 'OnControl'; 'Boolean Control'; 'PlotFamily';};
AO.SOL.OnControl.Mode = 'Simulator';
AO.SOL.OnControl.DataType = 'Scalar';
AO.SOL.OnControl.ChannelNames = [
    'GTL_____SOL1___BC23'	% C
    'GTL_____SOL2___BC22'	% H
    'GTL_____SOL3___BC21'	% M
    'LN______SOL1___BC23'	% C
    'LN______SOL2___BC22'	% G
    'LN______SOL3___BC21'	% C
    'LN______SOL4___BC20'	% C
    ];
AO.SOL.OnControl.HW2PhysicsParams = 1;
AO.SOL.OnControl.Physics2HWParams = 1;
AO.SOL.OnControl.Units        = 'Hardware';
AO.SOL.OnControl.HWUnits      = '';
AO.SOL.OnControl.PhysicsUnits = '';
AO.SOL.OnControl.Range = [-Inf Inf];
AO.SOL.OnControl.Tolerance = ones(length(AO.SOL.ElementList), 1);  % Hardware units

AO.SOL.On.MemberOf = {'SOL'; 'On'; 'Boolean Monitor'; 'PlotFamily';};
AO.SOL.On.Mode = 'Simulator';
AO.SOL.On.DataType = 'Scalar';
AO.SOL.On.ChannelNames = [
    'GTL_____SOL1___BM14' %	E
    'GTL_____SOL2___BM13' %	I
    'GTL_____SOL3___BM11' %	N
    'LN______SOL1___BM14' %	E
    'LN______SOL2___BM12' %	H
    'LN______SOL3___BM11' %	D
    'LN______SOL4___BM08' %	E
    ];
AO.SOL.On.HW2PhysicsParams = 1;
AO.SOL.On.Physics2HWParams = 1;
AO.SOL.On.Units        = 'Hardware';
AO.SOL.On.HWUnits      = '';
AO.SOL.On.PhysicsUnits = '';

AO.SOL.On2.MemberOf = {'SOL'; 'On2'; 'Boolean Monitor'; 'PlotFamily';};
AO.SOL.On2.Mode = 'Simulator';
AO.SOL.On2.DataType = 'Scalar';
AO.SOL.On2.ChannelNames = [
    'GTL_____SOL1___BM15' %	D
    'GTL_____SOL2___BM12' %	J
    'GTL_____SOL3___BM10' %	O
    'LN______SOL1___BM15' %	D
    'LN______SOL2___BM13' %	H
    'LN______SOL3___BM10' %	E
    'LN______SOL4___BM09' %	D
    ];
AO.SOL.On2.HW2PhysicsParams = 1;
AO.SOL.On2.Physics2HWParams = 1;
AO.SOL.On2.Units        = 'Hardware';
AO.SOL.On2.HWUnits      = '';
AO.SOL.On2.PhysicsUnits = '';

% 'LN______SOLIN1_BC19	% LN SOL MD1 INTLK
% 'LN______SOLIN2_BC18	% LN SOL MD2 INTLK


AO.AS.FamilyName = 'AS';
AO.AS.MemberOf = {'AS';};
AO.AS.DeviceList = [1 1; 1 2; 1 3; 2 1; 2 2; 2 3; 2 4];
AO.AS.ElementList = (1:size(AO.AS.DeviceList,1))';
AO.AS.Status = ones(size(AO.AS.DeviceList,1),1);
AO.AS.Position = (1:size(AO.AS.DeviceList,1))';
AO.AS.CommonNames = [
    'AS1_LOOP_PHASE  '
    'AS1_PAD_PHASE   '
    'AS1_PAD_PH_ERROR'
    'AS2_LOOP_PHASE  '
    'AS2_PAD_PHASE   '
    'AS2_PAD_PH_ERROR'
    'AS2_PHASE       '
    ];

AO.AS.Monitor.MemberOf = {'AS'; 'Monitor'; };
AO.AS.Monitor.Mode = 'Simulator';
AO.AS.Monitor.DataType = 'Scalar';
AO.AS.Monitor.ChannelNames = [
    'LN______AS1LCT_AM01' % AS1 LOOP PHASE
    'LN______AS1PPH_AM02' % AS1 PAD PHASE
    'LN______AS1PER_AM03' % AS1 PAD PH ERROR
    'LN______AS2LCT_AM01' % AS2 LOOP PHASE
    'LN______AS2PPH_AM02' % AS2 PAD PHASE
    'LN______AS2PER_AM03' % AS2 PAD PH ERROR
    'LN______AS2_PH_AM00' % AS2 PHASE
    ];
AO.AS.Monitor.HW2PhysicsParams = 1;
AO.AS.Monitor.Physics2HWParams = 1;
AO.AS.Monitor.Units        = 'Hardware';
AO.AS.Monitor.HWUnits      = '';
AO.AS.Monitor.PhysicsUnits = '';

AO.AS.Setpoint.MemberOf = {'AS'; 'MachineConfig'; 'Setpoint';};
AO.AS.Setpoint.Mode = 'Simulator';
AO.AS.Setpoint.DataType = 'Scalar';
AO.AS.Setpoint.ChannelNames = [
    'LN______AS1LCT_AC01' % AS1 LOOP PHASE
    'LN______AS1PPH_AC02' % AS1 PAD PHASE
    '                   '
    'LN______AS2LCT_AC01' % AS2 LOOP PHASE
    'LN______AS2PPH_AC02' % AS2 PAD PHASE
    '                   '
    'LN______AS2_PH_AC00' % AS2 PHASE       % Tuned by ops
    ];
AO.AS.Setpoint.HW2PhysicsParams = 1;
AO.AS.Setpoint.Physics2HWParams = 1;
AO.AS.Setpoint.Units        = 'Hardware';
AO.AS.Setpoint.HWUnits      = '';
AO.AS.Setpoint.PhysicsUnits = '';
AO.AS.Setpoint.Range = [0 1];
AO.AS.Setpoint.Tolerance = ones(length(AO.AS.ElementList), 1);  % Hardware units


AO.AS.LoopControl.MemberOf = {'AS'; 'MachineConfig'; 'LoopControl'; 'Boolean Control';};
AO.AS.LoopControl.Mode = 'Simulator';
AO.AS.LoopControl.DataType = 'Scalar';
AO.AS.LoopControl.ChannelNames = [
    'LN______AS1LCT_BC23' % AS1 COMP/LOCAL LOOP
    'LN______AS1LOP_BC22' % AS1 LOOP OPN/CLS
    '                   '
    'LN______AS2LCT_BC23' % AS2 COMP/LOCAL LOOP
    'LN______AS2LOP_BC22' % AS2 LOOP OPN/CLS
    '                   '
    '                   '
    ];
AO.AS.LoopControl.HW2PhysicsParams = 1;
AO.AS.LoopControl.Physics2HWParams = 1;
AO.AS.LoopControl.Units        = 'Hardware';
AO.AS.LoopControl.HWUnits      = '';
AO.AS.LoopControl.PhysicsUnits = '';
AO.AS.LoopControl.Range = [0 1];
AO.AS.LoopControl.Tolerance = .5 * ones(length(AO.AS.ElementList), 1);  % Hardware units


% IP, IG families



% Extra Monitors
NameCell = {
   %'EG______MO_____AM00', 'Freq Reference'
    'EG______EXTOSC_BM05', 'Ext Osc Sel'
    'EG______HQOSC__BM07', 'MQ MO Sel'
    
    'EG______AUX____BM12', 'EN_GTL_VVR1+INM1'
    'EG______AUX____BM13', 'RF_TEST_BM'
    'EG______AUX____BM15', 'AUX_RDY'
    'EG______AUX____BM11', 'HV_TEST_LOC_BM'
    'EG______AUX____BM09', 'AUX_LOC_CNTL_BM'
    'EG______AUX____BM14', 'AUX_ON_BM'
    'EG______AUX____BM10', 'GUN_OPERATNL_BM1'
    
    'EG______HTR____BM01', 'HTR_LOC_CNTL_BM'
    'EG______HTR____BM08', 'HEATER_RDY'
    'EG______HTR____BM07', 'HTR_ON_BM1'
    'EG______HTR____BM06', 'K_AIR_BM'
    'EG______HTR____BM02', 'HV_TEST_OFF_BM'
    'EG______HTR____BM03', 'RF_TEST_OFF'
    'EG______HTR____BM04', 'GTL_IP1(B)_BM1'
    'EG______HTR____BM05', 'EG_IP1_BM'
    
    'EG______HV_____BM12', 'HTR_OFF_BM'
    'EG______HV_____BM02', 'HV_LOC_CNTL_BM'
    'EG______HV_____BM10', 'GTL_IP1(B)_BM2'
    'EG______HV_____BM11', 'GTL_VVR1_CLSD_BM'
    'EG______HV_____BM13', 'HV_TEST_BM'
    'EG______HV_____BM09', 'GUN_OPERATNL_BM2'
    'EG______HV_____BM14', 'HV_ON_BM'
    'EG______HV_____BM08', 'HTR_ON_BM2'
    'EG______HV_____BM06', 'GTL(IP1C+IG1)BM2'
    'EG______HV_____BM03', 'P_SAFETY_2_BM'
    'EG______HV_____BM04', 'P_SAFETY_1_BM'
    'EG______HV_____BM05', 'HV_ENCLOSURE_BM'
    'EG______HV_____BM07', 'GTL_VVR1_OPEN_BM'
    'EG______HV_____BM15', 'HV_RDY_BM1'
    
    'EG______MO_CENTBM15', 'CENTER REF FOR V'
    'EG______MO_COMPBM13', 'COMP REF FOR VCX'
    'EG______MO_EXT_BM10', 'MO IN EXT. POSIT'
    'EG______MO_LOC_BM14', 'MO IN LOCAL REF'
    'EG______MO_NORMBM11', 'MO IN NORM POSIT'
    'EG______MO_OK__BM09', 'MO DRV LEVEL OK'
    'EG______MO_SWP_BM12', 'MO IN SWEEP POSI'
    'EG______MQOSC__BM06', 'Ext Osc Sel'
    
    'GTL_____TIME2__BM17', 'RNP READY'
    'GTL_____TIME2__BM16', 'NOT RAMP'
    'GTL_____TIME2__BM18', 'LOCAL/REMOTE SW'
    
    'LN______AS1LCT_BM06', 'AS1 COMP LOOP MON'
    'LN______AS1LCT_BM07', 'AS1 COMP LOOP RDY'
    'LN______AS1LCT_BM12', 'AS1 COMP LOOP ON'
    'LN______AS1LCT_BM13', 'AS1 LOCAL LOOP MON'
    'LN______AS1LOP_BM04', 'AS1 LOOP OPN/CLS MON'
    'LN______AS1LOP_BM05', 'AS1 LOOP RDY'
    'LN______AS1LOP_BM10', 'AS1 LOOP CLOSED'
    'LN______AS1LOP_BM11', 'AS1 LOOP OPEN'
    'LN______AS1PPH_BM08', 'AS1 PAD PH READY'
    'LN______AS1PPH_BM09', 'AS1 PAD PH IN LOCAL'
    
    'LN______AS2LCT_BM06', 'AS2 COMP LOOP MON'
    'LN______AS2LCT_BM07', 'AS2 COMP LOOP RDY'
    'LN______AS2LCT_BM12', 'AS2 COMP LOOP ON'
    'LN______AS2LCT_BM13', 'AS2 LOCAL LOOP MON'
    'LN______AS2LOP_BM04', 'AS2 LOOP OPN/CLS MON'
    'LN______AS2LOP_BM05', 'AS2 LOOP RDY'
    'LN______AS2LOP_BM10', 'AS2 LOOP CLOSED'
    'LN______AS2LOP_BM11', 'AS2 LOOP OPEN'
    'LN______AS2PPH_BM08', 'AS2 PAD PH READY'
    'LN______AS2PPH_BM09', 'AS2 PAD PH IN LOCAL'
    
    'LN______AS2_PH_BM14', 'AS2 PHASE RDY'
    'LN______AS2_PH_BM15', 'AS2 PH IN LOCAL'
    
    'LTB_____HALL1__AM00', 'Mag Field'
    };

AO.ExtraMonitors.FamilyName = 'ExtraMonitors';
AO.ExtraMonitors.MemberOf = {'ExtraMonitors';};
AO.ExtraMonitors.DeviceList = [ones(size(NameCell,1),1) (1:size(NameCell,1))'];
AO.ExtraMonitors.ElementList = (1:size(AO.ExtraMonitors.DeviceList,1))';
AO.ExtraMonitors.Status = ones(size(AO.ExtraMonitors.DeviceList,1),1);
AO.ExtraMonitors.Position = (1:size(NameCell,1))';
AO.ExtraMonitors.CommonName = str2mat(NameCell(:,2));

AO.ExtraMonitors.Monitor.MemberOf = {'ExtraMonitors'; 'Monitor'; };
AO.ExtraMonitors.Monitor.Mode = 'Simulator';
AO.ExtraMonitors.Monitor.DataType = 'Scalar';
AO.ExtraMonitors.Monitor.ChannelNames = str2mat(NameCell(:,1));
AO.ExtraMonitors.Monitor.HW2PhysicsParams = 1;
AO.ExtraMonitors.Monitor.Physics2HWParams = 1;
AO.ExtraMonitors.Monitor.Units        = 'Hardware';
AO.ExtraMonitors.Monitor.HWUnits      = '';
AO.ExtraMonitors.Monitor.PhysicsUnits = '';


% Extra controls
NameCell = {
    'LN______MD1HV__AC02', 'HV CHARGE REF'
    'LN______MD2HV__AC02', 'HV CHARGE REF'
    'LN______WTRTMP_AC00', 'WATER TEMP'
    'LN______MD1____BC23', 'MOD1 START/STOP'
    'LN______MD1_RF_BC21', 'RF TEST'
    'LN______MD1HV__BC22', 'MD1HV ON/OFF'
    'LN______MD1RST_BC23', 'RESET'
    'LN______MD1TRG_BC21', 'TRIGGER ON/OFF'
    'LN______MD2____BC23', 'MOD2 START/STOP'
    'LN______MD2_RF_BC21', 'RF TEST'
    'LN______MD2HV__BC22', 'MD2 HV ON/OFF'
    'LN______MD2RST_BC23', 'RESET'
    'LN______MD2TRG_BC21', 'TRIGGER ON/OFF'
    'LN______SBUNAT_BC16', 'ATTEN RUN IN/OUT'
    'LN______SBUNAT_BC19', 'ATTEN ON/OFF CNT'
    'LN______SBUNAT_BC18', 'ATTENUATOR SLOW'
    'LN______SBUNAT_BC17', 'ATTENUATOR FAST'
    'LN______SBUNPH_BC21', 'PHASE SHIFT FAST'
    'LN______SBUNPH_BC20', 'IN/OUT CONTROL'
    'LN______SBUNPH_BC22', 'PHASE SHIFT SLOW'
    'LN______SBUNPH_BC23', 'PH SHIFT ON/OFF'
    'LN______WTRHE__BC22', 'H. EXCHGR ON/OFF'
    'LN______WTRHTR_BC21', 'WTR HTR ON/OFF'
    'LN______WTRPMP_BC23', 'WTR PUMP ON/OFF'
    'LN______WTRRST_BC20', 'SYS INTRLK RESET'
    };

AO.ExtraControls.FamilyName = 'ExtraControls';
AO.ExtraControls.MemberOf = {'ExtraControls'; };
AO.ExtraControls.DeviceList = [ones(size(NameCell,1),1) (1:size(NameCell,1))'];
AO.ExtraControls.ElementList = (1:size(AO.ExtraControls.DeviceList,1))';
AO.ExtraControls.Status = ones(size(AO.ExtraControls.DeviceList,1),1);
AO.ExtraControls.Position = (1:size(NameCell,1))';
AO.ExtraControls.CommonName = str2mat(NameCell(:,2));

AO.ExtraControls.Setpoint.MemberOf = {'ExtraControls'; 'Setpoint'};
AO.ExtraControls.Setpoint.Mode = 'Simulator';
AO.ExtraControls.Setpoint.DataType = 'Scalar';
AO.ExtraControls.Setpoint.ChannelNames = str2mat(NameCell(:,1));
AO.ExtraControls.Setpoint.HW2PhysicsParams = 1;
AO.ExtraControls.Setpoint.Physics2HWParams = 1;
AO.ExtraControls.Setpoint.Units        = 'Hardware';
AO.ExtraControls.Setpoint.HWUnits      = '';
AO.ExtraControls.Setpoint.PhysicsUnits = '';
AO.ExtraControls.Setpoint.Range = [-Inf Inf];
AO.ExtraControls.Setpoint.Tolerance = Inf * ones(length(AO.ExtraControls.ElementList), 1);  % Hardware units


% Extra controls that are included in save/restore
NameCell = {
   %'EG______MO_____AC00', 'MO'         % Set by the storage ring
    'EG______HQOSC__BC23', 'HQ MO Sel'  % Is this in the new mini-IOC ???
    'EG______MQOSC__BC22', 'MQ MO Sel'
    'EG______EXTOSC_BC21', 'Ext Osc Sel'
    'EG______HTR____BC22', 'HEATER ON/OFF'
    'EG______HV_____BC23', 'HV ON/OFF'
    'EG______AUX____BC23', 'AUX ON/OFF'
    'LN______MASTPH_AC00', 'LN MASTER PHASE'  % Tuned by ops
    };

AO.ExtraMachineConfig.FamilyName = 'ExtraMachineConfig';
AO.ExtraMachineConfig.MemberOf = {'ExtraMachineConfig'};
AO.ExtraMachineConfig.DeviceList = [ones(size(NameCell,1),1) (1:size(NameCell,1))'];
AO.ExtraMachineConfig.ElementList = (1:size(AO.ExtraMachineConfig.DeviceList,1))';
AO.ExtraMachineConfig.Status = ones(size(AO.ExtraMachineConfig.DeviceList,1),1);
AO.ExtraMachineConfig.Position = (1:size(NameCell,1))';
AO.ExtraMachineConfig.CommonName = str2mat(NameCell(:,2));

AO.ExtraMachineConfig.Setpoint.MemberOf = {'MachineConfig'; 'Setpoint'}; 
AO.ExtraMachineConfig.Setpoint.Mode = 'Simulator';
AO.ExtraMachineConfig.Setpoint.DataType = 'Scalar';
AO.ExtraMachineConfig.Setpoint.ChannelNames = str2mat(NameCell(:,1));
AO.ExtraMachineConfig.Setpoint.HW2PhysicsParams = 1;
AO.ExtraMachineConfig.Setpoint.Physics2HWParams = 1;
AO.ExtraMachineConfig.Setpoint.Units        = 'Hardware';
AO.ExtraMachineConfig.Setpoint.HWUnits      = '';
AO.ExtraMachineConfig.Setpoint.PhysicsUnits = '';
AO.ExtraMachineConfig.Setpoint.Range = [-Inf Inf];
AO.ExtraMachineConfig.Setpoint.Tolerance = Inf * ones(length(AO.ExtraMachineConfig.ElementList), 1);  % Hardware units



% Save the AO so that family2dev will work
setao(AO);


% The operational mode sets the path, filenames, and other important parameters
% Run setoperationalmode after most of the AO is built so that the Units and Mode fields
% can be set in setoperationalmode
setao(AO);
setoperationalmode(OperationalMode);





% AO.NewFamily.FamilyName = 'NewFamily';
% AO.NewFamily.MemberOf = {'NewFamily';};
% AO.NewFamily.DeviceList = [1 1; 1 2; 2 1; 2 2; 3 1; 3 2; 3 3;3 4; 3 5; 3 6;];
% AO.NewFamily.ElementList = (1:size(AO.NewFamily.DeviceList,1))';
% AO.NewFamily.Status = ones(size(AO.NewFamily.DeviceList,1),1);
% AO.NewFamily.Position = (1:size(AO.NewFamily.DeviceList,1))';
% AO.NewFamily.CommonNames = [
%     ];
%
% AO.NewFamily.Monitor.MemberOf = {'NewFamily'; 'Monitor'; };
% AO.NewFamily.Monitor.Mode = 'Simulator';
% AO.NewFamily.Monitor.DataType = 'Scalar';
% AO.NewFamily.Monitor.ChannelNames = [
%     ];
% AO.NewFamily.Monitor.HW2PhysicsParams = 1;
% AO.NewFamily.Monitor.Physics2HWParams = 1;
% AO.NewFamily.Monitor.Units        = 'Hardware';
% AO.NewFamily.Monitor.HWUnits      = '';
% AO.NewFamily.Monitor.PhysicsUnits = '';
%
% AO.NewFamily.Setpoint.MemberOf = {'NewFamily'; 'Setpoint'};
% AO.NewFamily.Setpoint.Mode = 'Simulator';
% AO.NewFamily.Setpoint.DataType = 'Scalar';
% AO.NewFamily.Setpoint.ChannelNames = [
%     ];
% AO.NewFamily.Setpoint.HW2PhysicsParams = 1;
% AO.NewFamily.Setpoint.Physics2HWParams = 1;
% AO.NewFamily.Setpoint.Units        = 'Hardware';
% AO.NewFamily.Setpoint.HWUnits      = '';
% AO.NewFamily.Setpoint.PhysicsUnits = '';
% AO.NewFamily.Setpoint.Range = [0 1];
% AO.NewFamily.Setpoint.Tolerance = ones(length(AO.NewFamily.ElementList), 1);  % Hardware units
%
% AO.NewFamily.BC.MemberOf = {'NewFamily'; 'BC'};
% AO.NewFamily.BC.Mode = 'Simulator';
% AO.NewFamily.BC.DataType = 'Scalar';
% AO.NewFamily.BC.ChannelNames = [
%     ];
% AO.NewFamily.BC.HW2PhysicsParams = 1;
% AO.NewFamily.BC.Physics2HWParams = 1;
% AO.NewFamily.BC.Units        = 'Hardware';
% AO.NewFamily.BC.HWUnits      = '';
% AO.NewFamily.BC.PhysicsUnits = '';
% AO.NewFamily.BC.Range = [-Inf Inf];
% AO.NewFamily.BC.Tolerance = ones(length(AO.NewFamily.ElementList), 1);  % Hardware units


