function btsinit(OperationalMode)
%BTSINIT


% To do
% 1. units and conversions for the bumps, etc.
% 2. SR bumps?


if nargin < 1
    % 1 => 1.9   GeV injection
    % 2 => 1.23  GeV injection
    % 3 => 1.522 GeV injection    
    OperationalMode = 1;
end


%%%%%%%%%%%%%%%%
% Build the AO %
%%%%%%%%%%%%%%%%
setao([]);
setad([]);


% BPM
AO.BPMx.FamilyName = 'BPMx';
AO.BPMx.MemberOf   = {'PlotFamily'; 'BPM'; 'BPMx';};
AO.BPMx.DeviceList = [1 1; 1 2; 1 3; 1 4; 1 5; 1 6;];
AO.BPMx.ElementList = [1 2 3 4 5 6]';
AO.BPMx.Status = ones(6,1);
AO.BPMx.Position = [];

AO.BPMx.Monitor.MemberOf = {};
AO.BPMx.Monitor.Mode = 'Simulator';
AO.BPMx.Monitor.DataType = 'Scalar';
AO.BPMx.Monitor.ChannelNames = getname_bts(AO.BPMx.FamilyName, 'Monitor');
AO.BPMx.Monitor.HW2PhysicsParams = 1e-3;  % HW [mm], Simulator [Meters]
AO.BPMx.Monitor.Physics2HWParams = 1000;
AO.BPMx.Monitor.Units        = 'Hardware';
AO.BPMx.Monitor.HWUnits          = 'mm';
AO.BPMx.Monitor.PhysicsUnits     = 'Meter';
%AO.BPMx.Monitor.SpecialFunctionGet = @getx_bts;


AO.BPMy.FamilyName  = 'BPMy';
AO.BPMy.MemberOf    = {'PlotFamily'; 'BPM'; 'BPMy';};
AO.BPMy.DeviceList  = AO.BPMx.DeviceList;
AO.BPMy.ElementList = AO.BPMx.ElementList;
AO.BPMy.Status      = AO.BPMx.Status;
AO.BPMy.Position = [];

AO.BPMy.Monitor.MemberOf = {};
AO.BPMy.Monitor.Mode = 'Simulator';
AO.BPMy.Monitor.DataType = 'Scalar';
AO.BPMy.Monitor.ChannelNames = getname_bts(AO.BPMy.FamilyName, 'Monitor');
AO.BPMy.Monitor.HW2PhysicsParams = 1e-3;  % HW [mm], Simulator [Meters]
AO.BPMy.Monitor.Physics2HWParams = 1000;
AO.BPMy.Monitor.Units        = 'Hardware';
AO.BPMy.Monitor.HWUnits          = 'mm';
AO.BPMy.Monitor.PhysicsUnits     = 'Meter';
%AO.BPMy.Monitor.SpecialFunctionGet = @gety_bts;


% HCM
AO.HCM.FamilyName = 'HCM';
AO.HCM.MemberOf   = {'PlotFamily'; 'MachineConfig'; 'COR'; 'HCM'; 'Magnet'};
AO.HCM.DeviceList = [1 1; 1 2; 1 3; 1 4; 1 5; 1 6; 1 7; 1 8; 1 9];
AO.HCM.ElementList = [1 2 3 4 5 6 7 8 9]';
AO.HCM.Status = ones(9,1);
AO.HCM.Position = [];

AO.HCM.Monitor.MemberOf = {'PlotFamily';};
AO.HCM.Monitor.Mode = 'Simulator';
AO.HCM.Monitor.DataType = 'Scalar';
AO.HCM.Monitor.ChannelNames = getname_bts(AO.HCM.FamilyName, 'Monitor');
AO.HCM.Monitor.HW2PhysicsFcn = @bts2at;
AO.HCM.Monitor.Physics2HWFcn = @at2bts;
AO.HCM.Monitor.Units        = 'Hardware';
AO.HCM.Monitor.HWUnits      = 'Ampere';
AO.HCM.Monitor.PhysicsUnits = 'Radian';

AO.HCM.Setpoint.MemberOf = {'MachineConfig'; 'COR'; 'HCM'; 'Magnet'; 'Setpoint'};
AO.HCM.Setpoint.Mode = 'Simulator';
AO.HCM.Setpoint.DataType = 'Scalar';
AO.HCM.Setpoint.ChannelNames = getname_bts(AO.HCM.FamilyName, 'Setpoint');
AO.HCM.Setpoint.HW2PhysicsFcn = @bts2at;
AO.HCM.Setpoint.Physics2HWFcn = @at2bts;
AO.HCM.Setpoint.Units        = 'Hardware';
AO.HCM.Setpoint.HWUnits      = 'Ampere';
AO.HCM.Setpoint.PhysicsUnits = 'Radian';
AO.HCM.Setpoint.Range        = [local_minsp(AO.HCM.FamilyName, AO.HCM.DeviceList) local_maxsp(AO.HCM.FamilyName, AO.HCM.DeviceList)];
AO.HCM.Setpoint.Tolerance    = gettol(AO.HCM.FamilyName) * ones(length(AO.HCM.ElementList), 1);
AO.HCM.Setpoint.DeltaRespMat = 1;  % (hardware units)

% AO.HCM.RampRate.MemberOf = {'PlotFamily';'MachineConfig';};
% AO.HCM.RampRate.Mode = 'Simulator';
% AO.HCM.RampRate.DataType = 'Scalar';
% AO.HCM.RampRate.ChannelNames = getname_bts(AO.HCM.FamilyName, 'RampRate');
% AO.HCM.RampRate.HW2PhysicsParams = 1;
% AO.HCM.RampRate.Physics2HWParams = 1;
% AO.HCM.RampRate.Units        = 'Hardware';
% AO.HCM.RampRate.HWUnits      = 'Ampere/Second';
% AO.HCM.RampRate.PhysicsUnits = 'Ampere/Second';
% AO.HCM.RampRate.Range        = [0 10000];
% 
% AO.HCM.TimeConstant.MemberOf = {'PlotFamily';};
% AO.HCM.TimeConstant.Mode = 'Simulator';
% AO.HCM.TimeConstant.DataType = 'Scalar';
% AO.HCM.TimeConstant.ChannelNames = getname_bts(AO.HCM.FamilyName, 'TimeConstant');
% AO.HCM.TimeConstant.HW2PhysicsParams = 1;
% AO.HCM.TimeConstant.Physics2HWParams = 1;
% AO.HCM.TimeConstant.Units        = 'Hardware';
% AO.HCM.TimeConstant.HWUnits      = 'Second';
% AO.HCM.TimeConstant.PhysicsUnits = 'Second';
% AO.HCM.TimeConstant.Range        = [0 10000];
% 
% AO.HCM.DAC.MemberOf = {'PlotFamily';};
% AO.HCM.DAC.Mode = 'Simulator';
% AO.HCM.DAC.DataType = 'Scalar';
% AO.HCM.DAC.ChannelNames = getname_bts(AO.HCM.FamilyName, 'DAC');
% AO.HCM.DAC.HW2PhysicsParams = 1;
% AO.HCM.DAC.Physics2HWParams = 1;
% AO.HCM.DAC.Units        = 'Hardware';
% AO.HCM.DAC.HWUnits      = 'Ampere';
% AO.HCM.DAC.PhysicsUnits = 'Ampere';

AO.HCM.On.MemberOf = {'PlotFamily';};
AO.HCM.On.Mode = 'Simulator';
AO.HCM.On.DataType = 'Scalar';
AO.HCM.On.ChannelNames = getname_bts(AO.HCM.FamilyName, 'On');
AO.HCM.On.HW2PhysicsParams = 1;
AO.HCM.On.Physics2HWParams = 1;
AO.HCM.On.Units        = 'Hardware';
AO.HCM.On.HWUnits      = '';
AO.HCM.On.PhysicsUnits = '';

AO.HCM.OnControl.MemberOf = {'PlotFamily';};
AO.HCM.OnControl.Mode = 'Simulator';
AO.HCM.OnControl.DataType = 'Scalar';
AO.HCM.OnControl.ChannelNames = getname_bts(AO.HCM.FamilyName, 'OnControl');
AO.HCM.OnControl.HW2PhysicsParams = 1;
AO.HCM.OnControl.Physics2HWParams = 1;
AO.HCM.OnControl.Units        = 'Hardware';
AO.HCM.OnControl.HWUnits      = '';
AO.HCM.OnControl.PhysicsUnits = '';
AO.HCM.OnControl.SpecialFunctionSet = @setsp_OnControlMagnet;
AO.HCM.OnControl.Range    = [0 1];

AO.HCM.Reset.MemberOf = {'PlotFamily';};
AO.HCM.Reset.Mode = 'Simulator';
AO.HCM.Reset.DataType = 'Scalar';
AO.HCM.Reset.ChannelNames = getname_bts(AO.HCM.FamilyName, 'Reset');
AO.HCM.Reset.HW2PhysicsParams = 1;
AO.HCM.Reset.Physics2HWParams = 1;
AO.HCM.Reset.Units        = 'Hardware';
AO.HCM.Reset.HWUnits      = '';
AO.HCM.Reset.PhysicsUnits = '';
AO.HCM.Reset.Range        = [0 1];

AO.HCM.Ready.MemberOf = {'PlotFamily';};
AO.HCM.Ready.Mode = 'Simulator';
AO.HCM.Ready.DataType = 'Scalar';
AO.HCM.Ready.ChannelNames = getname_bts(AO.HCM.FamilyName, 'Ready');
AO.HCM.Ready.HW2PhysicsParams = 1;
AO.HCM.Ready.Physics2HWParams = 1;
AO.HCM.Ready.Units        = 'Hardware';
AO.HCM.Ready.HWUnits      = '';
AO.HCM.Ready.PhysicsUnits = '';


% VCM
AO.VCM.FamilyName = 'VCM';
AO.VCM.MemberOf   = {'PlotFamily'; 'MachineConfig'; 'COR'; 'VCM'; 'Magnet'};
AO.VCM.DeviceList = [1 1; 1 2; 1 3; 1 4; 1 5; 1 6; 1 7; 1 8; 1 9];
AO.VCM.ElementList = [1 2 3 4 5 6 7 8 9]';
AO.VCM.Status = ones(9,1);
AO.VCM.Position = [];

AO.VCM.Monitor.MemberOf = {'PlotFamily';};
AO.VCM.Monitor.Mode = 'Simulator';
AO.VCM.Monitor.DataType = 'Scalar';
AO.VCM.Monitor.ChannelNames = getname_bts(AO.VCM.FamilyName, 'Monitor');
AO.VCM.Monitor.HW2PhysicsFcn = @bts2at;
AO.VCM.Monitor.Physics2HWFcn = @at2bts;
AO.VCM.Monitor.Units        = 'Hardware';
AO.VCM.Monitor.HWUnits      = 'Ampere';
AO.VCM.Monitor.PhysicsUnits = 'Radian';

AO.VCM.Setpoint.MemberOf = {'MachineConfig'; 'COR'; 'VCM'; 'Magnet'; 'Setpoint'};
AO.VCM.Setpoint.Mode = 'Simulator';
AO.VCM.Setpoint.DataType = 'Scalar';
AO.VCM.Setpoint.ChannelNames = getname_bts(AO.VCM.FamilyName, 'Setpoint');
AO.VCM.Setpoint.HW2PhysicsFcn = @bts2at;
AO.VCM.Setpoint.Physics2HWFcn = @at2bts;
AO.VCM.Setpoint.Units        = 'Hardware';
AO.VCM.Setpoint.HWUnits      = 'Ampere';
AO.VCM.Setpoint.PhysicsUnits = 'Radian';
AO.VCM.Setpoint.Range        = [local_minsp(AO.VCM.FamilyName, AO.VCM.DeviceList) local_maxsp(AO.VCM.FamilyName, AO.VCM.DeviceList)];
AO.VCM.Setpoint.Tolerance    = gettol(AO.VCM.FamilyName) * ones(length(AO.VCM.ElementList), 1);
AO.VCM.Setpoint.DeltaRespMat = 1;  % (hardware units)

% AO.VCM.RampRate.MemberOf = {'PlotFamily'; 'MachineConfig';};
% AO.VCM.RampRate.Mode = 'Simulator';
% AO.VCM.RampRate.DataType = 'Scalar';
% AO.VCM.RampRate.ChannelNames = getname_bts(AO.VCM.FamilyName, 'RampRate');
% AO.VCM.RampRate.HW2PhysicsParams = 1;
% AO.VCM.RampRate.Physics2HWParams = 1;
% AO.VCM.RampRate.Units        = 'Hardware';
% AO.VCM.RampRate.HWUnits      = 'Ampere/Second';
% AO.VCM.RampRate.PhysicsUnits = 'Ampere/Second';
% AO.VCM.RampRate.Range        = [0 10000];
% 
% AO.VCM.TimeConstant.MemberOf = {'PlotFamily'; };
% AO.VCM.TimeConstant.Mode = 'Simulator';
% AO.VCM.TimeConstant.DataType = 'Scalar';
% AO.VCM.TimeConstant.ChannelNames = getname_bts(AO.VCM.FamilyName, 'TimeConstant');
% AO.VCM.TimeConstant.HW2PhysicsParams = 1;
% AO.VCM.TimeConstant.Physics2HWParams = 1;
% AO.VCM.TimeConstant.Units        = 'Hardware';
% AO.VCM.TimeConstant.HWUnits      = 'Second';
% AO.VCM.TimeConstant.PhysicsUnits = 'Second';
% AO.VCM.TimeConstant.Range        = [0 10000];
% 
% AO.VCM.DAC.MemberOf = {'PlotFamily';};
% AO.VCM.DAC.Mode = 'Simulator';
% AO.VCM.DAC.DataType = 'Scalar';
% AO.VCM.DAC.ChannelNames = getname_bts(AO.VCM.FamilyName, 'DAC');
% AO.VCM.DAC.HW2PhysicsParams = 1;
% AO.VCM.DAC.Physics2HWParams = 1;
% AO.VCM.DAC.Units        = 'Hardware';
% AO.VCM.DAC.HWUnits      = 'Ampere';
% AO.VCM.DAC.PhysicsUnits = 'Ampere';

AO.VCM.On.MemberOf = {'PlotFamily';};
AO.VCM.On.Mode = 'Simulator';
AO.VCM.On.DataType = 'Scalar';
AO.VCM.On.ChannelNames = getname_bts(AO.VCM.FamilyName, 'On');
AO.VCM.On.HW2PhysicsParams = 1;
AO.VCM.On.Physics2HWParams = 1;
AO.VCM.On.Units        = 'Hardware';
AO.VCM.On.HWUnits      = '';
AO.VCM.On.PhysicsUnits = '';

AO.VCM.OnControl.MemberOf = {'PlotFamily';};
AO.VCM.OnControl.Mode = 'Simulator';
AO.VCM.OnControl.DataType = 'Scalar';
AO.VCM.OnControl.ChannelNames = getname_bts(AO.VCM.FamilyName, 'OnControl');
AO.VCM.OnControl.HW2PhysicsParams = 1;
AO.VCM.OnControl.Physics2HWParams = 1;
AO.VCM.OnControl.Units        = 'Hardware';
AO.VCM.OnControl.HWUnits      = '';
AO.VCM.OnControl.PhysicsUnits = '';
AO.VCM.OnControl.Range        = [0 1];
AO.VCM.OnControl.SpecialFunctionSet = @setsp_OnControlMagnet;

AO.VCM.Reset.MemberOf = {'PlotFamily';};
AO.VCM.Reset.Mode = 'Simulator';
AO.VCM.Reset.DataType = 'Scalar';
AO.VCM.Reset.ChannelNames = getname_bts(AO.VCM.FamilyName, 'Reset');
AO.VCM.Reset.HW2PhysicsParams = 1;
AO.VCM.Reset.Physics2HWParams = 1;
AO.VCM.Reset.Units        = 'Hardware';
AO.VCM.Reset.HWUnits      = '';
AO.VCM.Reset.PhysicsUnits = '';
AO.VCM.Reset.Range        = [0 1];

AO.VCM.Ready.MemberOf = {'PlotFamily';};
AO.VCM.Ready.Mode = 'Simulator';
AO.VCM.Ready.DataType = 'Scalar';
AO.VCM.Ready.ChannelNames = getname_bts(AO.VCM.FamilyName, 'Ready');
AO.VCM.Ready.HW2PhysicsParams = 1;
AO.VCM.Ready.Physics2HWParams = 1;
AO.VCM.Ready.Units        = 'Hardware';
AO.VCM.Ready.HWUnits      = 'Second';
AO.VCM.Ready.PhysicsUnits = 'Second';


% Quadrupoles (QF & QD all in one family)
AO.Q.FamilyName = 'Q';
AO.Q.MemberOf   = {'PlotFamily'; 'MachineConfig'; 'QUAD'; 'Magnet'};
AO.Q.DeviceList = [1 1; 2 1;2 2; 3 1; 3 2; 4 1; 5 1; 5 2; 6 1; 6 2; 7 1;];
AO.Q.ElementList = (1:size(AO.Q.DeviceList,1))';
AO.Q.Status = 1;
AO.Q.Position = [];

AO.Q.Monitor.MemberOf = {'PlotFamily';};
AO.Q.Monitor.Mode = 'Simulator';
AO.Q.Monitor.DataType = 'Scalar';
AO.Q.Monitor.ChannelNames = getname_bts(AO.Q.FamilyName, 'Monitor');
AO.Q.Monitor.HW2PhysicsFcn = @bts2at;
AO.Q.Monitor.Physics2HWFcn = @at2bts;
AO.Q.Monitor.Units        = 'Hardware';
AO.Q.Monitor.HWUnits      = 'Ampere';
AO.Q.Monitor.PhysicsUnits = '1/Meter^2';

AO.Q.Setpoint.MemberOf = {'MachineConfig';};
AO.Q.Setpoint.Mode = 'Simulator';
AO.Q.Setpoint.DataType = 'Scalar';
AO.Q.Setpoint.ChannelNames = getname_bts(AO.Q.FamilyName, 'Setpoint');
AO.Q.Setpoint.HW2PhysicsFcn = @bts2at;
AO.Q.Setpoint.Physics2HWFcn = @at2bts;
AO.Q.Setpoint.Units        = 'Hardware';
AO.Q.Setpoint.HWUnits      = 'Ampere';
AO.Q.Setpoint.PhysicsUnits = '1/Meter^2';
AO.Q.Setpoint.Range        = [local_minsp(AO.Q.FamilyName, AO.Q.DeviceList) local_maxsp(AO.Q.FamilyName, AO.Q.DeviceList)];
AO.Q.Setpoint.Tolerance    = gettol(AO.Q.FamilyName) * ones(length(AO.Q.ElementList), 1);
AO.Q.Setpoint.DeltaRespMat = 1;   % (hardware units)

% AO.Q.RampRate.MemberOf = {'PlotFamily'; 'MachineConfig';};
% AO.Q.RampRate.Mode = 'Simulator';
% AO.Q.RampRate.DataType = 'Scalar';
% AO.Q.RampRate.ChannelNames = getname_bts('Q', 'RampRate');
% AO.Q.RampRate.HW2PhysicsFcn = @bts2at;
% AO.Q.RampRate.Physics2HWFcn = @at2bts;
% AO.Q.RampRate.Units        = 'Hardware';
% AO.Q.RampRate.HWUnits      = 'Ampere/Second';
% AO.Q.RampRate.PhysicsUnits = 'Ampere/Second';
% AO.Q.RampRate.Range        = [0 10000];
% 
% AO.Q.TimeConstant.MemberOf = {'PlotFamily'; 'MachineConfig';};
% AO.Q.TimeConstant.Mode = 'Simulator';
% AO.Q.TimeConstant.DataType = 'Scalar';
% AO.Q.TimeConstant.ChannelNames = getname_bts('Q', 'TimeConstant');
% AO.Q.TimeConstant.HW2PhysicsParams = 1;
% AO.Q.TimeConstant.Physics2HWParams = 1;
% AO.Q.TimeConstant.Units        = 'Hardware';
% AO.Q.TimeConstant.HWUnits      = 'Second';
% AO.Q.TimeConstant.PhysicsUnits = 'Second';
% AO.Q.TimeConstant.Range        = [0 10000];
% 
% AO.Q.DAC.MemberOf = {'PlotFamily';};
% AO.Q.DAC.Mode = 'Simulator';
% AO.Q.DAC.DataType = 'Scalar';
% AO.Q.DAC.ChannelNames = getname_bts('Q', 'DAC');
% AO.Q.DAC.HW2PhysicsParams = 1;
% AO.Q.DAC.Physics2HWParams = 1;
% AO.Q.DAC.Units        = 'Hardware';
% AO.Q.DAC.HWUnits      = 'Ampere';
% AO.Q.DAC.PhysicsUnits = 'Ampere';

AO.Q.On.MemberOf = {'PlotFamily';};
AO.Q.On.Mode = 'Simulator';
AO.Q.On.DataType = 'Scalar';
AO.Q.On.ChannelNames = getname_bts('Q', 'On');
AO.Q.On.HW2PhysicsParams = 1;
AO.Q.On.Physics2HWParams = 1;
AO.Q.On.Units        = 'Hardware';
AO.Q.On.HWUnits      = '';
AO.Q.On.PhysicsUnits = '';

AO.Q.OnControl.MemberOf = {'PlotFamily';};
AO.Q.OnControl.Mode = 'Simulator';
AO.Q.OnControl.DataType = 'Scalar';
AO.Q.OnControl.ChannelNames = getname_bts('Q', 'OnControl');
AO.Q.OnControl.HW2PhysicsParams = 1;
AO.Q.OnControl.Physics2HWParams = 1;
AO.Q.OnControl.Units        = 'Hardware';
AO.Q.OnControl.HWUnits      = '';
AO.Q.OnControl.PhysicsUnits = '';
AO.Q.OnControl.Range        = [0 1];
AO.Q.OnControl.SpecialFunctionSet = @setsp_OnControlMagnet;

AO.Q.Reset.MemberOf = {'PlotFamily';};
AO.Q.Reset.Mode = 'Simulator';
AO.Q.Reset.DataType = 'Scalar';
AO.Q.Reset.ChannelNames = getname_bts('Q', 'Reset');
AO.Q.Reset.HW2PhysicsParams = 1;
AO.Q.Reset.Physics2HWParams = 1;
AO.Q.Reset.Units        = 'Hardware';
AO.Q.Reset.HWUnits      = '';
AO.Q.Reset.PhysicsUnits = '';
AO.Q.Reset.Range        = [0 1];

AO.Q.Ready.MemberOf = {'PlotFamily';};
AO.Q.Ready.Mode = 'Simulator';
AO.Q.Ready.DataType = 'Scalar';
AO.Q.Ready.ChannelNames = getname_bts('Q', 'Ready');
AO.Q.Ready.HW2PhysicsParams = 1;
AO.Q.Ready.Physics2HWParams = 1;
AO.Q.Ready.Units        = 'Hardware';
AO.Q.Ready.HWUnits      = '';
AO.Q.Ready.PhysicsUnits = '';


% BEND
AO.BEND.FamilyName = 'BEND';
AO.BEND.MemberOf   = {'PlotFamily'; 'MachineConfig'; 'BEND'; 'Magnet'};
AO.BEND.DeviceList = [1 1; 1 2; 1 3; 1 4;];
AO.BEND.ElementList = [1 2 3 4]';
AO.BEND.Status = [1 1 1 1]';
AO.BEND.Position = [];

AO.BEND.Monitor.MemberOf = {'PlotFamily';};
AO.BEND.Monitor.Mode = 'Simulator';
AO.BEND.Monitor.DataType = 'Scalar';
AO.BEND.Monitor.ChannelNames = getname_bts(AO.BEND.FamilyName, 'Monitor');
AO.BEND.Monitor.HW2PhysicsFcn = @bts2at;
AO.BEND.Monitor.Physics2HWFcn = @at2bts;
AO.BEND.Monitor.Units        = 'Hardware';
AO.BEND.Monitor.HWUnits      = 'Ampere';
AO.BEND.Monitor.PhysicsUnits = 'Radian';

AO.BEND.Setpoint.MemberOf = {'MachineConfig';};
AO.BEND.Setpoint.Mode = 'Simulator';
AO.BEND.Setpoint.DataType = 'Scalar';
AO.BEND.Setpoint.ChannelNames = getname_bts(AO.BEND.FamilyName, 'Setpoint');
AO.BEND.Setpoint.HW2PhysicsFcn = @bts2at;
AO.BEND.Setpoint.Physics2HWFcn = @at2bts;
AO.BEND.Setpoint.Units        = 'Hardware';
AO.BEND.Setpoint.HWUnits      = 'Ampere';
AO.BEND.Setpoint.PhysicsUnits = 'Radian';
AO.BEND.Setpoint.Range        = [local_minsp(AO.BEND.FamilyName, AO.BEND.DeviceList) local_maxsp(AO.BEND.FamilyName, AO.BEND.DeviceList)];
AO.BEND.Setpoint.Tolerance    = gettol(AO.BEND.FamilyName) * ones(length(AO.BEND.ElementList), 1);

% AO.BEND.RampRate.MemberOf = {'PlotFamily'; 'MachineConfig';};
% AO.BEND.RampRate.Mode = 'Simulator';
% AO.BEND.RampRate.DataType = 'Scalar';
% AO.BEND.RampRate.ChannelNames = getname_bts(AO.BEND.FamilyName, 'RampRate');
% AO.BEND.RampRate.HW2PhysicsParams = 1;
% AO.BEND.RampRate.Physics2HWParams = 1;
% AO.BEND.RampRate.Units        = 'Hardware';
% AO.BEND.RampRate.HWUnits      = 'Ampere/Second';
% AO.BEND.RampRate.PhysicsUnits = 'Ampere/Second';
% AO.BEND.RampRate.Range        = [0 10000];
% 
% AO.BEND.TimeConstant.MemberOf = {'PlotFamily'; 'MachineConfig';};
% AO.BEND.TimeConstant.Mode = 'Simulator';
% AO.BEND.TimeConstant.DataType = 'Scalar';
% AO.BEND.TimeConstant.ChannelNames = getname_bts(AO.BEND.FamilyName, 'TimeConstant');
% AO.BEND.TimeConstant.HW2PhysicsParams = 1;
% AO.BEND.TimeConstant.Physics2HWParams = 1;
% AO.BEND.TimeConstant.Units        = 'Hardware';
% AO.BEND.TimeConstant.HWUnits      = 'Second';
% AO.BEND.TimeConstant.PhysicsUnits = 'Second';
% AO.BEND.TimeConstant.Range        = [0 10000];
% 
% AO.BEND.DAC.MemberOf = {'PlotFamily';};
% AO.BEND.DAC.Mode = 'Simulator';
% AO.BEND.DAC.DataType = 'Scalar';
% AO.BEND.DAC.ChannelNames = getname_bts(AO.BEND.FamilyName, 'DAC');
% AO.BEND.DAC.HW2PhysicsParams = 1;
% AO.BEND.DAC.Physics2HWParams = 1;
% AO.BEND.DAC.Units        = 'Hardware';
% AO.BEND.DAC.HWUnits      = 'Ampere';
% AO.BEND.DAC.PhysicsUnits = 'Ampere';

AO.BEND.On.MemberOf = {'PlotFamily';};
AO.BEND.On.Mode = 'Simulator';
AO.BEND.On.DataType = 'Scalar';
AO.BEND.On.ChannelNames = getname_bts(AO.BEND.FamilyName, 'On');
AO.BEND.On.HW2PhysicsParams = 1;
AO.BEND.On.Physics2HWParams = 1;
AO.BEND.On.Units        = 'Hardware';
AO.BEND.On.HWUnits      = '';
AO.BEND.On.PhysicsUnits = '';

AO.BEND.OnControl.MemberOf = {'PlotFamily';};
AO.BEND.OnControl.Mode = 'Simulator';
AO.BEND.OnControl.DataType = 'Scalar';
AO.BEND.OnControl.ChannelNames = getname_bts(AO.BEND.FamilyName, 'OnControl');
AO.BEND.OnControl.HW2PhysicsParams = 1;
AO.BEND.OnControl.Physics2HWParams = 1;
AO.BEND.OnControl.Units        = 'Hardware';
AO.BEND.OnControl.HWUnits      = '';
AO.BEND.OnControl.PhysicsUnits = '';
AO.BEND.OnControl.Range        = [0 1];
AO.BEND.OnControl.SpecialFunctionSet = @setsp_OnControlMagnet;

AO.BEND.Reset.MemberOf = {'PlotFamily';};
AO.BEND.Reset.Mode = 'Simulator';
AO.BEND.Reset.DataType = 'Scalar';
AO.BEND.Reset.ChannelNames = getname_bts(AO.BEND.FamilyName, 'Reset');
AO.BEND.Reset.HW2PhysicsParams = 1;
AO.BEND.Reset.Physics2HWParams = 1;
AO.BEND.Reset.Units        = 'Hardware';
AO.BEND.Reset.HWUnits      = '';
AO.BEND.Reset.PhysicsUnits = '';
AO.BEND.Reset.Range        = [0 1];

AO.BEND.Ready.MemberOf = {'PlotFamily';};
AO.BEND.Ready.Mode = 'Simulator';
AO.BEND.Ready.DataType = 'Scalar';
AO.BEND.Ready.ChannelNames = getname_bts(AO.BEND.FamilyName, 'Ready');
AO.BEND.Ready.HW2PhysicsParams = 1;
AO.BEND.Ready.Physics2HWParams = 1;
AO.BEND.Ready.Units        = 'Hardware';
AO.BEND.Ready.HWUnits      = '';
AO.BEND.Ready.PhysicsUnits = '';


%%%%%%%%%%%%%%%%%%%%%
% Injection Magnets %
%%%%%%%%%%%%%%%%%%%%%

% BR Extration Kicker
AO.Kicker.FamilyName = 'Kicker';
AO.Kicker.MemberOf = {'Kicker';};
AO.Kicker.DeviceList = [1 1];
AO.Kicker.ElementList = 1;
AO.Kicker.Status = 1;
AO.Kicker.Position = [];
AO.Kicker.CommonNames = 'BRExtrationKicker';

AO.Kicker.Setpoint.MemberOf = {'Kicker'; 'MachineConfig'; 'PlotFamily';};
AO.Kicker.Setpoint.Mode = 'Simulator';
AO.Kicker.Setpoint.DataType = 'Scalar';
AO.Kicker.Setpoint.ChannelNames = 'BR2_____KE_____AC00';
AO.Kicker.Setpoint.HW2PhysicsParams = 1;  % Nominal hardware 95.1708;
AO.Kicker.Setpoint.Physics2HWParams = 1 ./ AO.Kicker.Setpoint.HW2PhysicsParams;
AO.Kicker.Setpoint.Units        = 'Hardware';
AO.Kicker.Setpoint.HWUnits      = '';
AO.Kicker.Setpoint.PhysicsUnits = '';


% BR Bump Magnets
AO.BRBump.FamilyName = 'BRBump';
AO.BRBump.MemberOf = {'Bump Magnet'; 'PlotFamily';};
AO.BRBump.DeviceList = [1 1;1 2;1 3;];
AO.BRBump.ElementList = [1 2 3]';
AO.BRBump.Status = [1 1 1]';
AO.BRBump.Position = [];
AO.BRBump.CommonNames = [
    'BRBumpMagnet1'
    'BRBumpMagnet2'
    'BRBumpMagnet3'
    ];

AO.BRBump.Monitor.MemberOf = {'Bump Magnet';};
AO.BRBump.Monitor.Mode = 'Simulator';
AO.BRBump.Monitor.DataType = 'Scalar';
AO.BRBump.Monitor.ChannelNames = ['BR2_____BUMP1__AC00';'BR2_____BUMP2__AC01';'BR2_____BUMP3__AC00'];
AO.BRBump.Monitor.HW2PhysicsParams = [1;1;1];
AO.BRBump.Monitor.Physics2HWParams = 1./AO.BRBump.Monitor.HW2PhysicsParams;
AO.BRBump.Monitor.Units        = 'Hardware';
AO.BRBump.Monitor.HWUnits      = 'Volts';
AO.BRBump.Monitor.PhysicsUnits = 'Radian';

AO.BRBump.Setpoint.MemberOf = {'Bump Magnet'; 'MachineConfig';};
AO.BRBump.Setpoint.Mode = 'Simulator';
AO.BRBump.Setpoint.DataType = 'Scalar';
AO.BRBump.Setpoint.ChannelNames = ['BR2_____BUMP1__AC00';'BR2_____BUMP2__AC01';'BR2_____BUMP3__AC00'];
AO.BRBump.Setpoint.HW2PhysicsParams = AO.BRBump.Monitor.HW2PhysicsParams;
AO.BRBump.Setpoint.Physics2HWParams = AO.BRBump.Monitor.Physics2HWParams;
AO.BRBump.Setpoint.Units        = 'Hardware';
AO.BRBump.Setpoint.HWUnits      = 'Volts';
AO.BRBump.Setpoint.PhysicsUnits = 'Radian';


% SR Bump Magnets
AO.SRBump.FamilyName = 'SRBump';
AO.SRBump.MemberOf = {'Bump Magnet'; 'PlotFamily';};
AO.SRBump.DeviceList = [12 1;12 2;1 3;1 4];
AO.SRBump.ElementList = [1 2 3 4]';
AO.SRBump.Status = [1 1 1 1]';
AO.SRBump.Position = [];
AO.SRBump.CommonNames = [
    'SRBumpMagnet1'
    'SRBumpMagnet2'
    'SRBumpMagnet3'
    'SRBumpMagnet4'
    ];

AO.SRBump.Monitor.MemberOf = {'Bump Magnet';};
AO.SRBump.Monitor.Mode = 'Simulator';
AO.SRBump.Monitor.DataType = 'Scalar';
AO.SRBump.Monitor.ChannelNames = ['SR01S___BUMP1__AC00'; 'SR01S___BUMP2__AC00'; 'SR01S___BUMP3__AC00'; 'SR01S___BUMP4__AC00';];
AO.SRBump.Monitor.HW2PhysicsParams = 1;
AO.SRBump.Monitor.Physics2HWParams = 1;
AO.SRBump.Monitor.Units        = 'Hardware';
AO.SRBump.Monitor.HWUnits      = 'Volts';
AO.SRBump.Monitor.PhysicsUnits = 'Radian';

AO.SRBump.Setpoint.MemberOf = {'Bump Magnet'; 'MachineConfig';};
AO.SRBump.Setpoint.Mode = 'Simulator';
AO.SRBump.Setpoint.DataType = 'Scalar';
AO.SRBump.Setpoint.ChannelNames = ['SR01S___BUMP1__AC00'; 'SR01S___BUMP2__AC00'; 'SR01S___BUMP3__AC00'; 'SR01S___BUMP4__AC00';];
AO.SRBump.Setpoint.HW2PhysicsParams = AO.SRBump.Monitor.HW2PhysicsParams;
AO.SRBump.Setpoint.Physics2HWParams = AO.SRBump.Monitor.Physics2HWParams;
AO.SRBump.Setpoint.Units        = 'Hardware';
AO.SRBump.Setpoint.HWUnits      = 'Volts';
AO.SRBump.Setpoint.PhysicsUnits = 'Radian';


% Thin & Thick Septum
AO.Septum.FamilyName = 'Septum';
AO.Septum.MemberOf = {'Septum'; 'PlotFamily';};
AO.Septum.DeviceList = [1 1;1 2;2 1;2 2];
AO.Septum.ElementList = [1;2;3;4];
AO.Septum.Status = [1;1;1;1];
AO.Septum.Position = [];
AO.Septum.CommonNames = [
    'BRThinSeptum '
    'BRThickSeptum'
    'SRThickSeptum'
    'SRThinSeptum '
    ];

AO.Septum.Monitor.MemberOf = {'Septum';};
AO.Septum.Monitor.Mode = 'Simulator';
AO.Septum.Monitor.DataType = 'Scalar';
AO.Septum.Monitor.ChannelNames = [
    'BR2_____SEN____AM00';
    'BR2_____SEK____AM01';
    'SR01S___SEK____AM02';  % or 01???
    'SR01S___SEN____AM00';];
AO.Septum.Monitor.HW2PhysicsParams = [
     2.00*pi/180 / 1296.9
    10.00*pi/180 / 3908.9
    10.07*pi/180 / 3723.5
     2.00*pi/180 / 1819.8];
AO.Septum.Monitor.Physics2HWParams = 1./AO.Septum.Monitor.HW2PhysicsParams;
AO.Septum.Monitor.Units        = 'Hardware';
AO.Septum.Monitor.HWUnits      = 'Volts';
AO.Septum.Monitor.PhysicsUnits = 'Radian';

AO.Septum.Setpoint.MemberOf = {'Septum'; 'MachineConfig';};
AO.Septum.Setpoint.Mode = 'Simulator';
AO.Septum.Setpoint.DataType = 'Scalar';
AO.Septum.Setpoint.ChannelNames = [
    'BR2_____SEN____AC00';
    'BR2_____SEK____AC01';
    'SR01S___SEK____AC01';
    'SR01S___SEN____AC00';];
AO.Septum.Setpoint.HW2PhysicsParams = AO.Septum.Monitor.HW2PhysicsParams;
AO.Septum.Setpoint.Physics2HWParams = AO.Septum.Monitor.Physics2HWParams;
AO.Septum.Setpoint.Units        = 'Hardware';
AO.Septum.Setpoint.HWUnits      = 'Volts';
AO.Septum.Setpoint.PhysicsUnits = 'Radian';



% AO.DCCT.FamilyName = 'DCCT';
% AO.DCCT.MemberOf = {};
% AO.DCCT.DeviceList = [1 1];
% AO.DCCT.ElementList = [1];
% AO.DCCT.Status = 1;
% AO.DCCT.Position = [];
%
% AO.DCCT.Monitor.Mode = 'Simulator';
% AO.DCCT.Monitor.DataType = 'Scalar';
% AO.DCCT.Monitor.ChannelNames = '';
% AO.DCCT.Monitor.HW2PhysicsParams = 1;
% AO.DCCT.Monitor.Physics2HWParams = 1;
% AO.DCCT.Monitor.Units        = 'Hardware';
% AO.DCCT.Monitor.HWUnits      = 'mAmps';
% AO.DCCT.Monitor.PhysicsUnits = 'mAmps';
% %AO.DCCT.Monitor.SpecialFunctionGet = 'getdcct_bts';


% Energy (soft family for energy ramping)
% AO.GeV.FamilyName = 'GeV';
% AO.GeV.MemberOf = {};
% AO.GeV.Status = 1;
% AO.GeV.DeviceList = [1 1];
% AO.GeV.ElementList = [1];
% 
% AO.GeV.Monitor.Mode = 'Simulator';
% AO.GeV.Monitor.DataType = 'Scalar';
% AO.GeV.Monitor.ChannelNames = '';
% AO.GeV.Monitor.HW2PhysicsParams = 1;
% AO.GeV.Monitor.Physics2HWParams = 1;
% AO.GeV.Monitor.Units        = 'Hardware';
% AO.GeV.Monitor.HWUnits      = 'GeV';
% AO.GeV.Monitor.PhysicsUnits = 'GeV';
% AO.GeV.Monitor.SpecialFunctionGet = 'getenergy_als';  %'bend2gev';
% 
% AO.GeV.Setpoint.Mode = 'Simulator';
% AO.GeV.Setpoint.DataType = 'Scalar';
% AO.GeV.Setpoint.ChannelNames = '';
% AO.GeV.Setpoint.HW2PhysicsParams = 1;
% AO.GeV.Setpoint.Physics2HWParams = 1;
% AO.GeV.Setpoint.Units        = 'Hardware';
% AO.GeV.Setpoint.HWUnits      = 'GeV';
% AO.GeV.Setpoint.PhysicsUnits = 'GeV';
% AO.GeV.Setpoint.SpecialFunctionGet = 'getenergy_als';
% AO.GeV.Setpoint.SpecialFunctionSet = 'setenergy_als';


% TV
AO.TV.FamilyName = 'TV';
AO.TV.MemberOf   = {'PlotFamily'; 'TV';};
AO.TV.DeviceList = [1 1; 1 2; 1 3; 1 4; 1 5; 1 6;];
AO.TV.ElementList = [1 2 3 4 5 6]';
AO.TV.Status = ones(6,1);
AO.TV.Position = [];

AO.TV.Monitor.MemberOf   = {'PlotFamily'; };
AO.TV.Monitor.Mode = 'Simulator';
AO.TV.Monitor.DataType = 'Scalar';
AO.TV.Monitor.ChannelNames = getname_bts(AO.TV.FamilyName, 'Monitor');
AO.TV.Monitor.HW2PhysicsParams = 1;
AO.TV.Monitor.Physics2HWParams = 1;
AO.TV.Monitor.Units        = 'Hardware';
AO.TV.Monitor.HWUnits      = '';
AO.TV.Monitor.PhysicsUnits = '';

AO.TV.Setpoint.MemberOf   = {'TV'};
AO.TV.Setpoint.Mode = 'Simulator';
AO.TV.Setpoint.DataType = 'Scalar';
AO.TV.Setpoint.ChannelNames = getname_bts(AO.TV.FamilyName, 'Setpoint');
AO.TV.Setpoint.HW2PhysicsParams = 1;
AO.TV.Setpoint.Physics2HWParams = 1;
AO.TV.Setpoint.Units        = 'Hardware';
AO.TV.Setpoint.HWUnits      = '';
AO.TV.Setpoint.PhysicsUnits = '';
AO.TV.Setpoint.Range        = [0 1];
AO.TV.Setpoint.Tolerance    = gettol(AO.TV.FamilyName) * ones(length(AO.TV.ElementList), 1);
AO.TV.Setpoint.SpecialFunctionGet = @gettv_bts;
AO.TV.Setpoint.SpecialFunctionSet = @settv_bts;

AO.TV.In.MemberOf   = {'PlotFamily'; };
AO.TV.In.Mode = 'Simulator';
AO.TV.In.DataType = 'Scalar';
AO.TV.In.ChannelNames = getname_bts(AO.TV.FamilyName, 'In');
AO.TV.In.HW2PhysicsParams = 1;
AO.TV.In.Physics2HWParams = 1;
AO.TV.In.Units        = 'Hardware';
AO.TV.In.HWUnits      = '';
AO.TV.In.PhysicsUnits = '';

AO.TV.Out.MemberOf   = {'PlotFamily'; };
AO.TV.Out.Mode = 'Simulator';
AO.TV.Out.DataType = 'Scalar';
AO.TV.Out.ChannelNames = getname_bts(AO.TV.FamilyName, 'Out');
AO.TV.Out.HW2PhysicsParams = 1;
AO.TV.Out.Physics2HWParams = 1;
AO.TV.Out.Units        = 'Hardware';
AO.TV.Out.HWUnits      = '';
AO.TV.Out.PhysicsUnits = '';

AO.TV.InControl.MemberOf   = {'PlotFamily'; };
AO.TV.InControl.Mode = 'Simulator';
AO.TV.InControl.DataType = 'Scalar';
AO.TV.InControl.ChannelNames = getname_bts(AO.TV.FamilyName, 'InControl');
AO.TV.InControl.HW2PhysicsParams = 1;
AO.TV.InControl.Physics2HWParams = 1;
AO.TV.InControl.Units        = 'Hardware';
AO.TV.InControl.HWUnits      = '';
AO.TV.InControl.PhysicsUnits = '';
AO.TV.InControl.Range        = [0 1];

AO.TV.Lamp.MemberOf   = {'PlotFamily'; };
AO.TV.Lamp.Mode = 'Simulator';
AO.TV.Lamp.DataType = 'Scalar';
AO.TV.Lamp.ChannelNames = getname_bts(AO.TV.FamilyName, 'Lamp');
AO.TV.Lamp.HW2PhysicsParams = 1;
AO.TV.Lamp.Physics2HWParams = 1;
AO.TV.Lamp.Units        = 'Hardware';
AO.TV.Lamp.HWUnits      = '';
AO.TV.Lamp.PhysicsUnits = '';
AO.TV.Lamp.Range        = [0 1];



% The operational mode sets the path, filenames, AT model, and other important parameters.
% Run setoperationalmode after most of the AO is built so that the Units and Mode fields
% can be set in setoperationalmode.
setao(AO);
setoperationalmode(OperationalMode);
AO = getao;




function [Amps] = local_minsp(Family, List)

for i = 1:size(List,1)
    if strcmp(Family,'HCM')
        Amps(i,1) = -6;
    elseif strcmp(Family,'VCM')
        Amps(i,1) = -6;
    elseif strcmp(Family,'Q')
        Amps(i,1) = 0;
    elseif strcmp(Family,'BEND')
        Amps(i,1) = 0;
    else
        fprintf('   Minimum setpoint unknown for %s family, hence set to Inf.\n', Family);
        Amps(i,1) = -Inf;
    end
end


function [Amps] = local_maxsp(Family, List)

for i = 1:size(List,1)
    if strcmp(Family,'HCM')
        Amps(i,1) = 6;
    elseif strcmp(Family,'VCM')
        Amps(i,1) = 6;
    elseif strcmp(Family,'Q')
        Amps(i,1) = 130;

        %if all(List(i,:) == [1 1])
        %    Amps(i,1) = 50;
        %elseif all(List(i,:) == [2 1])
        %    Amps(i,1) = 50;
        %elseif all(List(i,:) == [2 2])
        %    Amps(i,1) = 50;
        %end
    elseif strcmp(Family,'BEND')
        Amps(i,1) = 1000;
    elseif strcmp(Family,'TV')
        Amps(i,1) = .1;
    else
        fprintf('   Maximum setpoint unknown for %s family, hence set to Inf.\n', Family);
        Amps(i,1) = Inf;
    end
end


function tol = gettol(Family)
%  tol = gettol(Family)
%  tolerance on the SP-AM for that family

if strcmp(Family,'HCM')
    tol = 0.1;
elseif strcmp(Family,'VCM')
    tol = 0.1;
elseif strcmp(Family,'Q')
    tol = 0.6;
elseif strcmp(Family,'BEND')
    tol = 10;
else
    fprintf('   Tolerance unknown for %s family, hence set to zero.\n', Family);
    tol = 0;
end


