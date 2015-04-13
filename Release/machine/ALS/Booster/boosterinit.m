function boosterinit(OperationalMode)
%BOOSTERINIT - Initialization function of the ALS booster


% 1. Check SP and AM for all magnets (proper channel names)
%
%


if nargin < 1
    % 1 => 1.9   GeV injection
    % 2 => 1.23  GeV injection
    % 3 => 1.522 GeV injection    
    OperationalMode = 1;
end


% Device lists
TwoPerSectorList   = [];
ThreePerSectorList = [];
FourPerSectorList  = [];
SixPerSectorList   = [];
EightPerSectorList = [];

for Sector = 1:4
    TwoPerSectorList = [TwoPerSectorList;
        Sector 1;
        Sector 2;];

    ThreePerSectorList = [ThreePerSectorList;
        Sector 1;
        Sector 2;
        Sector 3;];
    
    FourPerSectorList = [FourPerSectorList;
        Sector 1;
        Sector 2;
        Sector 3;
        Sector 4;];

    SixPerSectorList = [SixPerSectorList;
        Sector 1;
        Sector 2;
        Sector 3;
        Sector 4;
        Sector 5;
        Sector 6;];

    EightPerSectorList = [EightPerSectorList;
        Sector 1;
        Sector 2;
        Sector 3;
        Sector 4;
        Sector 5;
        Sector 6;
        Sector 7;
        Sector 8;];
end



%%%%%%%%%%%%%%%%
% Build the AO %
%%%%%%%%%%%%%%%%
setao([]);

% BPM
AO.BPMx.FamilyName = 'BPMx';
AO.BPMx.MemberOf   = {'PlotFamily'; 'BPM';'BPMx';};
AO.BPMx.DeviceList = EightPerSectorList;
AO.BPMx.ElementList = [1:size(EightPerSectorList,1)]';
AO.BPMx.Status = ones(size(EightPerSectorList,1),1);

AO.BPMx.Monitor.MemberOf = {};
AO.BPMx.Monitor.Mode = 'Simulator';
AO.BPMx.Monitor.DataType = 'Scalar';
AO.BPMx.Monitor.ChannelNames = getname_booster(AO.BPMx.FamilyName, 'Monitor');
%AO.BPMx.Monitor.SpecialFunctionGet = @getx_bts;
AO.BPMx.Monitor.Units = 'Hardware';
AO.BPMx.Monitor.HWUnits          = 'mm';
AO.BPMx.Monitor.PhysicsUnits     = 'Meter';
AO.BPMx.Monitor.HW2PhysicsParams = 1e-3;  % HW [mm], Simulator [Meters]
AO.BPMx.Monitor.Physics2HWParams = 1000;


AO.BPMy.FamilyName  = 'BPMy';
AO.BPMy.MemberOf    = {'PlotFamily'; 'BPM';'BPMy';};
AO.BPMy.DeviceList  = AO.BPMx.DeviceList;
AO.BPMy.ElementList = AO.BPMx.ElementList;
AO.BPMy.Status      = AO.BPMx.Status;

AO.BPMy.Monitor.MemberOf = {};
AO.BPMy.Monitor.Mode = 'Simulator';
AO.BPMy.Monitor.DataType = 'Scalar';
AO.BPMy.Monitor.ChannelNames = getname_booster(AO.BPMy.FamilyName, 'Monitor');
%AO.BPMy.Monitor.SpecialFunctionGet = @gety_bts;
AO.BPMy.Monitor.Units = 'Hardware';
AO.BPMy.Monitor.HWUnits          = 'mm';
AO.BPMy.Monitor.PhysicsUnits     = 'Meter';
AO.BPMy.Monitor.HW2PhysicsParams = 1e-3;  % HW [mm], Simulator [Meters]
AO.BPMy.Monitor.Physics2HWParams = 1000;


% HCM
AO.HCM.FamilyName = 'HCM';
AO.HCM.MemberOf   = {'PlotFamily'; 'MachineConfig'; 'COR'; 'HCM'; 'Magnet'};
AO.HCM.DeviceList = FourPerSectorList;
AO.HCM.ElementList = [1:size(AO.HCM.DeviceList,1)]';
AO.HCM.Status = ones(size(AO.HCM.DeviceList,1),1);

AO.HCM.Monitor.MemberOf = {'PlotFamily';};
AO.HCM.Monitor.Mode = 'Simulator';
AO.HCM.Monitor.DataType = 'Scalar';
AO.HCM.Monitor.ChannelNames = getname_booster(AO.HCM.FamilyName, 'Monitor');
AO.HCM.Monitor.HW2PhysicsFcn = @booster2at;
AO.HCM.Monitor.Physics2HWFcn = @at2booster;
AO.HCM.Monitor.Units = 'Hardware';
AO.HCM.Monitor.HWUnits      = 'Ampere';
AO.HCM.Monitor.PhysicsUnits = 'Radian';

AO.HCM.Setpoint.MemberOf = {'MachineConfig'; 'COR'; 'HCM'; 'Magnet'; 'Setpoint'};
AO.HCM.Setpoint.Mode = 'Simulator';
AO.HCM.Setpoint.DataType = 'Scalar';
AO.HCM.Setpoint.ChannelNames = getname_booster(AO.HCM.FamilyName, 'Setpoint');
AO.HCM.Setpoint.HW2PhysicsFcn = @booster2at;
AO.HCM.Setpoint.Physics2HWFcn = @at2booster;
AO.HCM.Setpoint.Units = 'Hardware';
AO.HCM.Setpoint.HWUnits      = 'Ampere';
AO.HCM.Setpoint.PhysicsUnits = 'Radian';

% AO.HCM.RampRate.MemberOf = {'PlotFamily';'MachineConfig';};
% AO.HCM.RampRate.Mode = 'Simulator';
% AO.HCM.RampRate.DataType = 'Scalar';
% AO.HCM.RampRate.ChannelNames = getname_booster(AO.HCM.FamilyName, 'RampRate');
% AO.HCM.RampRate.HW2PhysicsParams = 1;
% AO.HCM.RampRate.Physics2HWParams = 1;
% AO.HCM.RampRate.Units = 'Hardware';
% AO.HCM.RampRate.HWUnits      = 'Ampere/Second';
% AO.HCM.RampRate.PhysicsUnits = 'Ampere/Second';
% 
% AO.HCM.TimeConstant.MemberOf = {'PlotFamily';};
% AO.HCM.TimeConstant.Mode = 'Simulator';
% AO.HCM.TimeConstant.DataType = 'Scalar';
% AO.HCM.TimeConstant.ChannelNames = getname_booster(AO.HCM.FamilyName, 'TimeConstant');
% AO.HCM.TimeConstant.HW2PhysicsParams = 1;
% AO.HCM.TimeConstant.Physics2HWParams = 1;
% AO.HCM.TimeConstant.Units = 'Hardware';
% AO.HCM.TimeConstant.HWUnits      = 'Second';
% AO.HCM.TimeConstant.PhysicsUnits = 'Second';
% 
% AO.HCM.DAC.MemberOf = {'PlotFamily';};
% AO.HCM.DAC.Mode = 'Simulator';
% AO.HCM.DAC.DataType = 'Scalar';
% AO.HCM.DAC.ChannelNames = getname_booster(AO.HCM.FamilyName, 'DAC');
% AO.HCM.DAC.HW2PhysicsParams = 1;
% AO.HCM.DAC.Physics2HWParams = 1;
% AO.HCM.DAC.Units = 'Hardware';
% AO.HCM.DAC.HWUnits      = 'Ampere';
% AO.HCM.DAC.PhysicsUnits = 'Ampere';

AO.HCM.On.MemberOf = {'PlotFamily';};
AO.HCM.On.Mode = 'Simulator';
AO.HCM.On.DataType = 'Scalar';
AO.HCM.On.ChannelNames = getname_booster(AO.HCM.FamilyName, 'On');
AO.HCM.On.HW2PhysicsParams = 1;
AO.HCM.On.Physics2HWParams = 1;
AO.HCM.On.Units = 'Hardware';
AO.HCM.On.HWUnits      = '';
AO.HCM.On.PhysicsUnits = '';

AO.HCM.OnControl.MemberOf = {'PlotFamily';};
AO.HCM.OnControl.Mode = 'Simulator';
AO.HCM.OnControl.DataType = 'Scalar';
AO.HCM.OnControl.ChannelNames = getname_booster(AO.HCM.FamilyName, 'OnControl');
AO.HCM.OnControl.HW2PhysicsParams = 1;
AO.HCM.OnControl.Physics2HWParams = 1;
AO.HCM.OnControl.Units = 'Hardware';
AO.HCM.OnControl.HWUnits      = '';
AO.HCM.OnControl.PhysicsUnits = '';

AO.HCM.Enable.MemberOf = {'PlotFamily';};
AO.HCM.Enable.Mode = 'Simulator';
AO.HCM.Enable.DataType = 'Scalar';
AO.HCM.Enable.ChannelNames = getname_booster(AO.HCM.FamilyName, 'Enable');
AO.HCM.Enable.HW2PhysicsParams = 1;
AO.HCM.Enable.Physics2HWParams = 1;
AO.HCM.Enable.Units = 'Hardware';
AO.HCM.Enable.HWUnits      = '';
AO.HCM.Enable.PhysicsUnits = '';

AO.HCM.Ready.MemberOf = {'PlotFamily';};
AO.HCM.Ready.Mode = 'Simulator';
AO.HCM.Ready.DataType = 'Scalar';
AO.HCM.Ready.ChannelNames = getname_booster(AO.HCM.FamilyName, 'Ready');
AO.HCM.Ready.HW2PhysicsParams = 1;
AO.HCM.Ready.Physics2HWParams = 1;
AO.HCM.Ready.Units = 'Hardware';
AO.HCM.Ready.HWUnits      = '';
AO.HCM.Ready.PhysicsUnits = '';


% VCM
AO.VCM.FamilyName = 'VCM';
AO.VCM.MemberOf   = {'PlotFamily'; 'MachineConfig'; 'COR'; 'VCM'; 'Magnet'};
AO.VCM.DeviceList = FourPerSectorList;
AO.VCM.ElementList = [1:size(AO.VCM.DeviceList,1)]';
AO.VCM.Status = ones(size(AO.VCM.DeviceList,1),1);

AO.VCM.Monitor.MemberOf = {'PlotFamily';};
AO.VCM.Monitor.Mode = 'Simulator';
AO.VCM.Monitor.DataType = 'Scalar';
AO.VCM.Monitor.ChannelNames = getname_booster(AO.VCM.FamilyName, 'Monitor');
AO.VCM.Monitor.HW2PhysicsFcn = @booster2at;
AO.VCM.Monitor.Physics2HWFcn = @at2booster;
AO.VCM.Monitor.Units = 'Hardware';
AO.VCM.Monitor.HWUnits      = 'Ampere';
AO.VCM.Monitor.PhysicsUnits = 'Radian';

AO.VCM.Setpoint.MemberOf = {'MachineConfig'; 'COR'; 'VCM'; 'Magnet'; 'Setpoint'};
AO.VCM.Setpoint.Mode = 'Simulator';
AO.VCM.Setpoint.DataType = 'Scalar';
AO.VCM.Setpoint.ChannelNames = getname_booster(AO.VCM.FamilyName, 'Setpoint');
AO.VCM.Setpoint.HW2PhysicsFcn = @booster2at;
AO.VCM.Setpoint.Physics2HWFcn = @at2booster;
AO.VCM.Setpoint.Units = 'Hardware';
AO.VCM.Setpoint.HWUnits      = 'Ampere';
AO.VCM.Setpoint.PhysicsUnits = 'Radian';

% AO.VCM.RampRate.MemberOf = {'PlotFamily'; 'MachineConfig';};
% AO.VCM.RampRate.Mode = 'Simulator';
% AO.VCM.RampRate.DataType = 'Scalar';
% AO.VCM.RampRate.ChannelNames = getname_booster(AO.VCM.FamilyName, 'RampRate');
% AO.VCM.RampRate.HW2PhysicsParams = 1;
% AO.VCM.RampRate.Physics2HWParams = 1;
% AO.VCM.RampRate.Units = 'Hardware';
% AO.VCM.RampRate.HWUnits      = 'Ampere/Second';
% AO.VCM.RampRate.PhysicsUnits = 'Ampere/Second';
% 
% AO.VCM.TimeConstant.MemberOf = {'PlotFamily'; };
% AO.VCM.TimeConstant.Mode = 'Simulator';
% AO.VCM.TimeConstant.DataType = 'Scalar';
% AO.VCM.TimeConstant.ChannelNames = getname_booster(AO.VCM.FamilyName, 'TimeConstant');
% AO.VCM.TimeConstant.HW2PhysicsParams = 1;
% AO.VCM.TimeConstant.Physics2HWParams = 1;
% AO.VCM.TimeConstant.Units = 'Hardware';
% AO.VCM.TimeConstant.HWUnits      = 'Second';
% AO.VCM.TimeConstant.PhysicsUnits = 'Second';
% 
% AO.VCM.DAC.MemberOf = {'PlotFamily';};
% AO.VCM.DAC.Mode = 'Simulator';
% AO.VCM.DAC.DataType = 'Scalar';
% AO.VCM.DAC.ChannelNames = getname_booster(AO.VCM.FamilyName, 'DAC');
% AO.VCM.DAC.HW2PhysicsParams = 1;
% AO.VCM.DAC.Physics2HWParams = 1;
% AO.VCM.DAC.Units = 'Hardware';
% AO.VCM.DAC.HWUnits      = 'Ampere';
% AO.VCM.DAC.PhysicsUnits = 'Ampere';

AO.VCM.On.MemberOf = {'PlotFamily';};
AO.VCM.On.Mode = 'Simulator';
AO.VCM.On.DataType = 'Scalar';
AO.VCM.On.ChannelNames = getname_booster(AO.VCM.FamilyName, 'On');
AO.VCM.On.HW2PhysicsParams = 1;
AO.VCM.On.Physics2HWParams = 1;
AO.VCM.On.Units = 'Hardware';
AO.VCM.On.HWUnits      = '';
AO.VCM.On.PhysicsUnits = '';

AO.VCM.OnControl.MemberOf = {'PlotFamily';};
AO.VCM.OnControl.Mode = 'Simulator';
AO.VCM.OnControl.DataType = 'Scalar';
AO.VCM.OnControl.ChannelNames = getname_booster(AO.VCM.FamilyName, 'OnControl');
AO.VCM.OnControl.HW2PhysicsParams = 1;
AO.VCM.OnControl.Physics2HWParams = 1;
AO.VCM.OnControl.Units = 'Hardware';
AO.VCM.OnControl.HWUnits      = '';
AO.VCM.OnControl.PhysicsUnits = '';

AO.VCM.Enable.MemberOf = {'PlotFamily';};
AO.VCM.Enable.Mode = 'Simulator';
AO.VCM.Enable.DataType = 'Scalar';
AO.VCM.Enable.ChannelNames = getname_booster(AO.VCM.FamilyName, 'Enable');
AO.VCM.Enable.HW2PhysicsParams = 1;
AO.VCM.Enable.Physics2HWParams = 1;
AO.VCM.Enable.Units = 'Hardware';
AO.VCM.Enable.HWUnits      = '';
AO.VCM.Enable.PhysicsUnits = '';

AO.VCM.Ready.MemberOf = {'PlotFamily';};
AO.VCM.Ready.Mode = 'Simulator';
AO.VCM.Ready.DataType = 'Scalar';
AO.VCM.Ready.ChannelNames = getname_booster(AO.VCM.FamilyName, 'Ready');
AO.VCM.Ready.HW2PhysicsParams = 1;
AO.VCM.Ready.Physics2HWParams = 1;
AO.VCM.Ready.Units = 'Hardware';
AO.VCM.Ready.HWUnits      = 'Second';
AO.VCM.Ready.PhysicsUnits = 'Second';



AO.QF.FamilyName = 'QF';
AO.QF.MemberOf   = {'PlotFamily'; 'MachineConfig'; 'QUAD'; 'Magnet'; 'QF'};
AO.QF.DeviceList = EightPerSectorList;
AO.QF.ElementList = (1:size(AO.QF.DeviceList,1))';
AO.QF.Status = ones(size(AO.QF.DeviceList,1),1);

AO.QF.Monitor.MemberOf = {'PlotFamily';};
AO.QF.Monitor.Mode = 'Simulator';
AO.QF.Monitor.DataType = 'Scalar';
AO.QF.Monitor.ChannelNames = getname_booster(AO.QF.FamilyName, 'Monitor');
AO.QF.Monitor.HW2PhysicsFcn = @booster2at;
AO.QF.Monitor.Physics2HWFcn = @at2booster;
AO.QF.Monitor.Units = 'Hardware';
AO.QF.Monitor.HWUnits      = 'Ampere';
AO.QF.Monitor.PhysicsUnits = '1/Meter^2';

AO.QF.Setpoint.MemberOf = {'MachineConfig';};
AO.QF.Setpoint.Mode = 'Simulator';
AO.QF.Setpoint.DataType = 'Scalar';
AO.QF.Setpoint.ChannelNames = getname_booster(AO.QF.FamilyName, 'Setpoint');
AO.QF.Setpoint.HW2PhysicsFcn = @booster2at;
AO.QF.Setpoint.Physics2HWFcn = @at2booster;
AO.QF.Setpoint.Units = 'Hardware';
AO.QF.Setpoint.HWUnits      = 'Ampere';
AO.QF.Setpoint.PhysicsUnits = '1/Meter^2';

AO.QF.RampTable.MemberOf = {'MachineConfig';};
AO.QF.RampTable.Mode = 'Simulator';
AO.QF.RampTable.DataType = 'Scalar';
AO.QF.RampTable.SpecialFunctionGet = 'getsp_RampTable';
AO.QF.RampTable.SpecialFunctionSet = 'setsp_RampTable';
AO.QF.RampTable.HW2PhysicsFcn = @booster2at;
AO.QF.RampTable.Physics2HWFcn = @at2booster;
AO.QF.RampTable.Units = 'Hardware';
AO.QF.RampTable.HWUnits      = 'Ampere';
AO.QF.RampTable.PhysicsUnits = '1/Meter^2';

AO.QF.DVM.MemberOf = {'MachineConfig';};
AO.QF.DVM.Mode = 'Simulator';
AO.QF.DVM.DataType = 'Scalar';
AO.QF.DVM.SpecialFunctionGet = 'getam_DVM';
AO.QF.DVM.HW2PhysicsFcn = @booster2at;
AO.QF.DVM.Physics2HWFcn = @at2booster;
AO.QF.DVM.Units = 'Hardware';
AO.QF.DVM.HWUnits      = 'Ampere';
AO.QF.DVM.PhysicsUnits = '1/Meter^2';

AO.QF.ILCTrim.MemberOf = {'MachineConfig';};
AO.QF.ILCTrim.Mode = 'Simulator';
AO.QF.ILCTrim.DataType = 'Scalar';
AO.QF.ILCTrim.SpecialFunctionGet = 'getsp_ILCTrimQF';
AO.QF.ILCTrim.SpecialFunctionSet = 'setsp_ILCTrimQF';
AO.QF.ILCTrim.HW2PhysicsFcn = @booster2at;
AO.QF.ILCTrim.Physics2HWFcn = @at2booster;
AO.QF.ILCTrim.Units = 'Hardware';
AO.QF.ILCTrim.HWUnits      = 'Ampere';
AO.QF.ILCTrim.PhysicsUnits = '1/Meter^2';

AO.QF.On.MemberOf = {'PlotFamily';};
AO.QF.On.Mode = 'Simulator';
AO.QF.On.DataType = 'Scalar';
AO.QF.On.ChannelNames = getname_booster('QF', 'On');
AO.QF.On.HW2PhysicsParams = 1;
AO.QF.On.Physics2HWParams = 1;
AO.QF.On.Units = 'Hardware';
AO.QF.On.HWUnits      = '';
AO.QF.On.PhysicsUnits = '';

AO.QF.OnControl.MemberOf = {'PlotFamily';};
AO.QF.OnControl.Mode = 'Simulator';
AO.QF.OnControl.DataType = 'Scalar';
AO.QF.OnControl.ChannelNames = getname_booster('QF', 'OnControl');
AO.QF.OnControl.HW2PhysicsParams = 1;
AO.QF.OnControl.Physics2HWParams = 1;
AO.QF.OnControl.Units = 'Hardware';
AO.QF.OnControl.HWUnits      = '';
AO.QF.OnControl.PhysicsUnits = '';

% AO.QF.Enable.MemberOf = {'PlotFamily';};
% AO.QF.Enable.Mode = 'Simulator';
% AO.QF.Enable.DataType = 'Scalar';
% AO.QF.Enable.ChannelNames = getname_booster('QF', 'Enable');
% AO.QF.Enable.HW2PhysicsParams = 1;
% AO.QF.Enable.Physics2HWParams = 1;
% AO.QF.Enable.Units = 'Hardware';
% AO.QF.Enable.HWUnits      = '';
% AO.QF.Enable.PhysicsUnits = '';

AO.QF.Ready.MemberOf = {'PlotFamily';};
AO.QF.Ready.Mode = 'Simulator';
AO.QF.Ready.DataType = 'Scalar';
AO.QF.Ready.ChannelNames = getname_booster('QF', 'Ready');
AO.QF.Ready.HW2PhysicsParams = 1;
AO.QF.Ready.Physics2HWParams = 1;
AO.QF.Ready.Units = 'Hardware';
AO.QF.Ready.HWUnits      = '';
AO.QF.Ready.PhysicsUnits = '';


AO.QD.FamilyName = 'QD';
AO.QD.MemberOf   = {'PlotFamily'; 'MachineConfig'; 'QUAD'; 'Magnet'; 'QD'};
AO.QD.DeviceList = EightPerSectorList;
AO.QD.ElementList = (1:size(AO.QD.DeviceList,1))';
AO.QD.Status = ones(size(AO.QD.DeviceList,1),1);

AO.QD.Monitor.MemberOf = {'PlotFamily';};
AO.QD.Monitor.Mode = 'Simulator';
AO.QD.Monitor.DataType = 'Scalar';
AO.QD.Monitor.ChannelNames = getname_booster(AO.QD.FamilyName, 'Monitor');
AO.QD.Monitor.HW2PhysicsFcn = @booster2at;
AO.QD.Monitor.Physics2HWFcn = @at2booster;
AO.QD.Monitor.Units = 'Hardware';
AO.QD.Monitor.HWUnits      = 'Ampere';
AO.QD.Monitor.PhysicsUnits = '1/Meter^2';

AO.QD.Setpoint.MemberOf = {'MachineConfig';};
AO.QD.Setpoint.Mode = 'Simulator';
AO.QD.Setpoint.DataType = 'Scalar';
AO.QD.Setpoint.ChannelNames = getname_booster(AO.QD.FamilyName, 'Setpoint');
AO.QD.Setpoint.HW2PhysicsFcn = @booster2at;
AO.QD.Setpoint.Physics2HWFcn = @at2booster;
AO.QD.Setpoint.Units = 'Hardware';
AO.QD.Setpoint.HWUnits      = 'Ampere';
AO.QD.Setpoint.PhysicsUnits = '1/Meter^2';

AO.QD.RampTable.MemberOf = {'MachineConfig';};
AO.QD.RampTable.Mode = 'Simulator';
AO.QD.RampTable.DataType = 'Scalar';
AO.QD.RampTable.SpecialFunctionGet = 'getsp_RampTable';
AO.QD.RampTable.SpecialFunctionSet = 'setsp_RampTable';
AO.QD.RampTable.HW2PhysicsFcn = @booster2at;
AO.QD.RampTable.Physics2HWFcn = @at2booster;
AO.QD.RampTable.Units = 'Hardware';
AO.QD.RampTable.HWUnits      = 'Ampere';
AO.QD.RampTable.PhysicsUnits = '1/Meter^2';

AO.QD.DVM.MemberOf = {'MachineConfig';};
AO.QD.DVM.Mode = 'Simulator';
AO.QD.DVM.DataType = 'Scalar';
AO.QD.DVM.SpecialFunctionGet = 'getam_DVM';
AO.QD.DVM.HW2PhysicsFcn = @booster2at;
AO.QD.DVM.Physics2HWFcn = @at2booster;
AO.QD.DVM.Units = 'Hardware';
AO.QD.DVM.HWUnits      = 'Ampere';
AO.QD.DVM.PhysicsUnits = '1/Meter^2';

AO.QD.ILCTrim.MemberOf = {'MachineConfig';};
AO.QD.ILCTrim.Mode = 'Simulator';
AO.QD.ILCTrim.DataType = 'Scalar';
AO.QD.ILCTrim.SpecialFunctionGet = 'getsp_ILCTrimQD';
AO.QD.ILCTrim.SpecialFunctionSet = 'setsp_ILCTrimQD';
AO.QD.ILCTrim.HW2PhysicsFcn = @booster2at;
AO.QD.ILCTrim.Physics2HWFcn = @at2booster;
AO.QD.ILCTrim.Units = 'Hardware';
AO.QD.ILCTrim.HWUnits      = 'Ampere';
AO.QD.ILCTrim.PhysicsUnits = '1/Meter^2';

AO.QD.On.MemberOf = {'PlotFamily';};
AO.QD.On.Mode = 'Simulator';
AO.QD.On.DataType = 'Scalar';
AO.QD.On.ChannelNames = getname_booster('QD', 'On');
AO.QD.On.HW2PhysicsParams = 1;
AO.QD.On.Physics2HWParams = 1;
AO.QD.On.Units = 'Hardware';
AO.QD.On.HWUnits      = '';
AO.QD.On.PhysicsUnits = '';

AO.QD.OnControl.MemberOf = {'PlotFamily';};
AO.QD.OnControl.Mode = 'Simulator';
AO.QD.OnControl.DataType = 'Scalar';
AO.QD.OnControl.ChannelNames = getname_booster('QD', 'OnControl');
AO.QD.OnControl.HW2PhysicsParams = 1;
AO.QD.OnControl.Physics2HWParams = 1;
AO.QD.OnControl.Units = 'Hardware';
AO.QD.OnControl.HWUnits      = '';
AO.QD.OnControl.PhysicsUnits = '';

% AO.QD.Enable.MemberOf = {'PlotFamily';};
% AO.QD.Enable.Mode = 'Simulator';
% AO.QD.Enable.DataType = 'Scalar';
% AO.QD.Enable.ChannelNames = getname_booster('QD', 'Enable');
% AO.QD.Enable.HW2PhysicsParams = 1;
% AO.QD.Enable.Physics2HWParams = 1;
% AO.QD.Enable.Units = 'Hardware';
% AO.QD.Enable.HWUnits      = '';
% AO.QD.Enable.PhysicsUnits = '';

AO.QD.Ready.MemberOf = {'PlotFamily';};
AO.QD.Ready.Mode = 'Simulator';
AO.QD.Ready.DataType = 'Scalar';
AO.QD.Ready.ChannelNames = getname_booster('QD', 'Ready');
AO.QD.Ready.HW2PhysicsParams = 1;
AO.QD.Ready.Physics2HWParams = 1;
AO.QD.Ready.Units = 'Hardware';
AO.QD.Ready.HWUnits      = '';
AO.QD.Ready.PhysicsUnits = '';


AO.SF.FamilyName = 'SF';
AO.SF.MemberOf   = {'PlotFamily'; 'MachineConfig'; 'SEXT'; 'Magnet'; 'SF'};
AO.SF.DeviceList = TwoPerSectorList;
AO.SF.ElementList = (1:size(AO.SF.DeviceList,1))';
AO.SF.Status = ones(size(AO.SF.DeviceList,1),1);

AO.SF.Monitor.MemberOf = {'PlotFamily';};
AO.SF.Monitor.Mode = 'Simulator';
AO.SF.Monitor.DataType = 'Scalar';
AO.SF.Monitor.ChannelNames = getname_booster(AO.SF.FamilyName, 'Monitor');
AO.SF.Monitor.HW2PhysicsFcn = @booster2at;
AO.SF.Monitor.Physics2HWFcn = @at2booster;
AO.SF.Monitor.Units = 'Hardware';
AO.SF.Monitor.HWUnits      = 'Ampere';
AO.SF.Monitor.PhysicsUnits = '1/Meter^2';

AO.SF.Setpoint.MemberOf = {'MachineConfig';};
AO.SF.Setpoint.Mode = 'Simulator';
AO.SF.Setpoint.DataType = 'Scalar';
AO.SF.Setpoint.ChannelNames = getname_booster(AO.SF.FamilyName, 'Setpoint');
AO.SF.Setpoint.HW2PhysicsFcn = @booster2at;
AO.SF.Setpoint.Physics2HWFcn = @at2booster;
AO.SF.Setpoint.Units = 'Hardware';
AO.SF.Setpoint.HWUnits      = 'Ampere';
AO.SF.Setpoint.PhysicsUnits = '1/Meter^2';

% AO.SF.RampRate.MemberOf = {'PlotFamily'; 'MachineConfig';};
% AO.SF.RampRate.Mode = 'Simulator';
% AO.SF.RampRate.DataType = 'Scalar';
% AO.SF.RampRate.ChannelNames = getname_booster('SF', 'RampRate');
% AO.SF.RampRate.HW2PhysicsFcn = @booster2at;
% AO.SF.RampRate.Physics2HWFcn = @at2booster;
% AO.SF.RampRate.Units = 'Hardware';
% AO.SF.RampRate.HWUnits      = 'Ampere/Second';
% AO.SF.RampRate.PhysicsUnits = 'Ampere/Second';
% 
% AO.SF.TimeConstant.MemberOf = {'PlotFamily'; 'MachineConfig';};
% AO.SF.TimeConstant.Mode = 'Simulator';
% AO.SF.TimeConstant.DataType = 'Scalar';
% AO.SF.TimeConstant.ChannelNames = getname_booster('SF', 'TimeConstant');
% AO.SF.TimeConstant.HW2PhysicsParams = 1;
% AO.SF.TimeConstant.Physics2HWParams = 1;
% AO.SF.TimeConstant.Units = 'Hardware';
% AO.SF.TimeConstant.HWUnits      = 'Second';
% AO.SF.TimeConstant.PhysicsUnits = 'Second';
% 
% AO.SF.DAC.MemberOf = {'PlotFamily';};
% AO.SF.DAC.Mode = 'Simulator';
% AO.SF.DAC.DataType = 'Scalar';
% AO.SF.DAC.ChannelNames = getname_booster('SF', 'DAC');
% AO.SF.DAC.HW2PhysicsParams = 1;
% AO.SF.DAC.Physics2HWParams = 1;
% AO.SF.DAC.Units = 'Hardware';
% AO.SF.DAC.HWUnits      = 'Ampere';
% AO.SF.DAC.PhysicsUnits = 'Ampere';


AO.SF.On.MemberOf = {'PlotFamily';};
AO.SF.On.Mode = 'Simulator';
AO.SF.On.DataType = 'Scalar';
AO.SF.On.ChannelNames = getname_booster('SF', 'On');
AO.SF.On.HW2PhysicsParams = 1;
AO.SF.On.Physics2HWParams = 1;
AO.SF.On.Units = 'Hardware';
AO.SF.On.HWUnits      = '';
AO.SF.On.PhysicsUnits = '';

AO.SF.OnControl.MemberOf = {'PlotFamily';};
AO.SF.OnControl.Mode = 'Simulator';
AO.SF.OnControl.DataType = 'Scalar';
AO.SF.OnControl.ChannelNames = getname_booster('SF', 'OnControl');
AO.SF.OnControl.HW2PhysicsParams = 1;
AO.SF.OnControl.Physics2HWParams = 1;
AO.SF.OnControl.Units = 'Hardware';
AO.SF.OnControl.HWUnits      = '';
AO.SF.OnControl.PhysicsUnits = '';

AO.SF.EnableDAC.MemberOf = {'PlotFamily';};
AO.SF.EnableDAC.Mode = 'Simulator';
AO.SF.EnableDAC.DataType = 'Scalar';
AO.SF.EnableDAC.ChannelNames = getname_booster('SF', 'EnableDAC');
AO.SF.EnableDAC.HW2PhysicsParams = 1;
AO.SF.EnableDAC.Physics2HWParams = 1;
AO.SF.EnableDAC.Units = 'Hardware';
AO.SF.EnableDAC.HWUnits      = '';
AO.SF.EnableDAC.PhysicsUnits = '';

AO.SF.EnableRamp.MemberOf = {'PlotFamily';};
AO.SF.EnableRamp.Mode = 'Simulator';
AO.SF.EnableRamp.DataType = 'Scalar';
AO.SF.EnableRamp.ChannelNames = getname_booster('SF', 'EnableRamp');
AO.SF.EnableRamp.HW2PhysicsParams = 1;
AO.SF.EnableRamp.Physics2HWParams = 1;
AO.SF.EnableRamp.Units = 'Hardware';
AO.SF.EnableRamp.HWUnits      = '';
AO.SF.EnableRamp.PhysicsUnits = '';

AO.SF.Gain.MemberOf = {'PlotFamily';};
AO.SF.Gain.Mode = 'Simulator';
AO.SF.Gain.DataType = 'Scalar';
AO.SF.Gain.ChannelNames = getname_booster('SF', 'Gain');
AO.SF.Gain.HW2PhysicsParams = 1;
AO.SF.Gain.Physics2HWParams = 1;
AO.SF.Gain.Units = 'Hardware';
AO.SF.Gain.HWUnits      = '';
AO.SF.Gain.PhysicsUnits = '';

% AO.SF.Offset.MemberOf = {'PlotFamily';};
% AO.SF.Offset.Mode = 'Simulator';
% AO.SF.Offset.DataType = 'Scalar';
% AO.SF.Offset.ChannelNames = getname_booster('SF', 'Offset');
% AO.SF.Offset.HW2PhysicsParams = 1;
% AO.SF.Offset.Physics2HWParams = 1;
% AO.SF.Offset.Units = 'Hardware';
% AO.SF.Offset.HWUnits      = '';
% AO.SF.Offset.PhysicsUnits = '';

AO.SF.Ready.MemberOf = {'PlotFamily';};
AO.SF.Ready.Mode = 'Simulator';
AO.SF.Ready.DataType = 'Scalar';
AO.SF.Ready.ChannelNames = getname_booster('SF', 'Ready');
AO.SF.Ready.HW2PhysicsParams = 1;
AO.SF.Ready.Physics2HWParams = 1;
AO.SF.Ready.Units = 'Hardware';
AO.SF.Ready.HWUnits      = '';
AO.SF.Ready.PhysicsUnits = '';


AO.SD.FamilyName = 'SD';
AO.SD.MemberOf   = {'PlotFamily'; 'MachineConfig'; 'SEXT'; 'Magnet'; 'SD'};
AO.SD.DeviceList = ThreePerSectorList;
AO.SD.ElementList = (1:size(AO.SD.DeviceList,1))';
AO.SD.Status = ones(size(AO.SD.DeviceList,1),1);

AO.SD.Monitor.MemberOf = {'PlotFamily';};
AO.SD.Monitor.Mode = 'Simulator';
AO.SD.Monitor.DataType = 'Scalar';
AO.SD.Monitor.ChannelNames = getname_booster(AO.SD.FamilyName, 'Monitor');
AO.SD.Monitor.HW2PhysicsFcn = @booster2at;
AO.SD.Monitor.Physics2HWFcn = @at2booster;
AO.SD.Monitor.Units = 'Hardware';
AO.SD.Monitor.HWUnits      = 'Ampere';
AO.SD.Monitor.PhysicsUnits = '1/Meter^2';

AO.SD.Setpoint.MemberOf = {'MachineConfig';};
AO.SD.Setpoint.Mode = 'Simulator';
AO.SD.Setpoint.DataType = 'Scalar';
AO.SD.Setpoint.ChannelNames = getname_booster(AO.SD.FamilyName, 'Setpoint');
AO.SD.Setpoint.HW2PhysicsFcn = @booster2at;
AO.SD.Setpoint.Physics2HWFcn = @at2booster;
AO.SD.Setpoint.Units = 'Hardware';
AO.SD.Setpoint.HWUnits      = 'Ampere';
AO.SD.Setpoint.PhysicsUnits = '1/Meter^2';

% AO.SD.RampRate.MemberOf = {'PlotFamily'; 'MachineConfig';};
% AO.SD.RampRate.Mode = 'Simulator';
% AO.SD.RampRate.DataType = 'Scalar';
% AO.SD.RampRate.ChannelNames = getname_booster('SD', 'RampRate');
% AO.SD.RampRate.HW2PhysicsFcn = @booster2at;
% AO.SD.RampRate.Physics2HWFcn = @at2booster;
% AO.SD.RampRate.Units = 'Hardware';
% AO.SD.RampRate.HWUnits      = 'Ampere/Second';
% AO.SD.RampRate.PhysicsUnits = 'Ampere/Second';
% 
% AO.SD.TimeConstant.MemberOf = {'PlotFamily'; 'MachineConfig';};
% AO.SD.TimeConstant.Mode = 'Simulator';
% AO.SD.TimeConstant.DataType = 'Scalar';
% AO.SD.TimeConstant.ChannelNames = getname_booster('SD', 'TimeConstant');
% AO.SD.TimeConstant.HW2PhysicsParams = 1;
% AO.SD.TimeConstant.Physics2HWParams = 1;
% AO.SD.TimeConstant.Units = 'Hardware';
% AO.SD.TimeConstant.HWUnits      = 'Second';
% AO.SD.TimeConstant.PhysicsUnits = 'Second';
% 
% AO.SD.DAC.MemberOf = {'PlotFamily';};
% AO.SD.DAC.Mode = 'Simulator';
% AO.SD.DAC.DataType = 'Scalar';
% AO.SD.DAC.ChannelNames = getname_booster('SD', 'DAC');
% AO.SD.DAC.HW2PhysicsParams = 1;
% AO.SD.DAC.Physics2HWParams = 1;
% AO.SD.DAC.Units = 'Hardware';
% AO.SD.DAC.HWUnits      = 'Ampere';
% AO.SD.DAC.PhysicsUnits = 'Ampere';

AO.SD.On.MemberOf = {'PlotFamily';};
AO.SD.On.Mode = 'Simulator';
AO.SD.On.DataType = 'Scalar';
AO.SD.On.ChannelNames = getname_booster('SD', 'On');
AO.SD.On.HW2PhysicsParams = 1;
AO.SD.On.Physics2HWParams = 1;
AO.SD.On.Units = 'Hardware';
AO.SD.On.HWUnits      = '';
AO.SD.On.PhysicsUnits = '';

AO.SD.OnControl.MemberOf = {'PlotFamily';};
AO.SD.OnControl.Mode = 'Simulator';
AO.SD.OnControl.DataType = 'Scalar';
AO.SD.OnControl.ChannelNames = getname_booster('SD', 'OnControl');
AO.SD.OnControl.HW2PhysicsParams = 1;
AO.SD.OnControl.Physics2HWParams = 1;
AO.SD.OnControl.Units = 'Hardware';
AO.SD.OnControl.HWUnits      = '';
AO.SD.OnControl.PhysicsUnits = '';

AO.SD.EnableDAC.MemberOf = {'PlotFamily';};
AO.SD.EnableDAC.Mode = 'Simulator';
AO.SD.EnableDAC.DataType = 'Scalar';
AO.SD.EnableDAC.ChannelNames = getname_booster('SD', 'EnableDAC');
AO.SD.EnableDAC.HW2PhysicsParams = 1;
AO.SD.EnableDAC.Physics2HWParams = 1;
AO.SD.EnableDAC.Units = 'Hardware';
AO.SD.EnableDAC.HWUnits      = '';
AO.SD.EnableDAC.PhysicsUnits = '';

AO.SD.EnableRamp.MemberOf = {'PlotFamily';};
AO.SD.EnableRamp.Mode = 'Simulator';
AO.SD.EnableRamp.DataType = 'Scalar';
AO.SD.EnableRamp.ChannelNames = getname_booster('SD', 'EnableRamp');
AO.SD.EnableRamp.HW2PhysicsParams = 1;
AO.SD.EnableRamp.Physics2HWParams = 1;
AO.SD.EnableRamp.Units = 'Hardware';
AO.SD.EnableRamp.HWUnits      = '';
AO.SD.EnableRamp.PhysicsUnits = '';

AO.SD.Gain.MemberOf = {'PlotFamily';};
AO.SD.Gain.Mode = 'Simulator';
AO.SD.Gain.DataType = 'Scalar';
AO.SD.Gain.ChannelNames = getname_booster('SD', 'Gain');
AO.SD.Gain.HW2PhysicsParams = 1;
AO.SD.Gain.Physics2HWParams = 1;
AO.SD.Gain.Units = 'Hardware';
AO.SD.Gain.HWUnits      = '';
AO.SD.Gain.PhysicsUnits = '';

% AO.SD.Offset.MemberOf = {'PlotFamily';};
% AO.SD.Offset.Mode = 'Simulator';
% AO.SD.Offset.DataType = 'Scalar';
% AO.SD.Offset.ChannelNames = getname_booster('SD', 'Offset');
% AO.SD.Offset.HW2PhysicsParams = 1;
% AO.SD.Offset.Physics2HWParams = 1;
% AO.SD.Offset.Units = 'Hardware';
% AO.SD.Offset.HWUnits      = '';
% AO.SD.Offset.PhysicsUnits = '';

AO.SD.Ready.MemberOf = {'PlotFamily';};
AO.SD.Ready.Mode = 'Simulator';
AO.SD.Ready.DataType = 'Scalar';
AO.SD.Ready.ChannelNames = getname_booster('SD', 'Ready');
AO.SD.Ready.HW2PhysicsParams = 1;
AO.SD.Ready.Physics2HWParams = 1;
AO.SD.Ready.Units = 'Hardware';
AO.SD.Ready.HWUnits      = '';
AO.SD.Ready.PhysicsUnits = '';



AO.BEND.FamilyName = 'BEND';
AO.BEND.MemberOf   = {'PlotFamily'; 'MachineConfig'; 'BEND'; 'Magnet'};
AO.BEND.DeviceList = SixPerSectorList;
AO.BEND.ElementList = (1:size(AO.BEND.DeviceList,1))';
AO.BEND.Status = ones(size(AO.BEND.DeviceList,1),1);

AO.BEND.Monitor.MemberOf = {'PlotFamily';};
AO.BEND.Monitor.Mode = 'Simulator';
AO.BEND.Monitor.DataType = 'Scalar';
AO.BEND.Monitor.ChannelNames = getname_booster(AO.BEND.FamilyName, 'Monitor');
AO.BEND.Monitor.HW2PhysicsFcn = @booster2at;
AO.BEND.Monitor.Physics2HWFcn = @at2booster;
AO.BEND.Monitor.Units = 'Hardware';
AO.BEND.Monitor.HWUnits = 'Ampere';
AO.BEND.Monitor.PhysicsUnits = 'Radian';

AO.BEND.Setpoint.MemberOf = {'MachineConfig';};
AO.BEND.Setpoint.Mode = 'Simulator';
AO.BEND.Setpoint.DataType = 'Scalar';
AO.BEND.Setpoint.ChannelNames = getname_booster(AO.BEND.FamilyName, 'Setpoint');
AO.BEND.Setpoint.HW2PhysicsFcn = @booster2at;
AO.BEND.Setpoint.Physics2HWFcn = @at2booster;
AO.BEND.Setpoint.Units = 'Hardware';
AO.BEND.Setpoint.HWUnits = 'Ampere';
AO.BEND.Setpoint.PhysicsUnits = 'Radian';

AO.BEND.DVM.MemberOf = {'MachineConfig';};
AO.BEND.DVM.Mode = 'Simulator';
AO.BEND.DVM.DataType = 'Scalar';
AO.BEND.DVM.SpecialFunctionGet = 'getam_DVM';
AO.BEND.DVM.HW2PhysicsFcn = @booster2at;
AO.BEND.DVM.Physics2HWFcn = @at2booster;
AO.BEND.DVM.Units = 'Hardware';
AO.BEND.DVM.HWUnits      = 'Ampere';
AO.BEND.DVM.PhysicsUnits = 'Radian';

AO.BEND.On.MemberOf = {'PlotFamily';};
AO.BEND.On.Mode = 'Simulator';
AO.BEND.On.DataType = 'Scalar';
AO.BEND.On.ChannelNames = getname_booster(AO.BEND.FamilyName, 'On');
AO.BEND.On.HW2PhysicsParams = 1;
AO.BEND.On.Physics2HWParams = 1;
AO.BEND.On.Units = 'Hardware';
AO.BEND.On.HWUnits      = '';
AO.BEND.On.PhysicsUnits = '';

AO.BEND.OnControl.MemberOf = {'PlotFamily';};
AO.BEND.OnControl.Mode = 'Simulator';
AO.BEND.OnControl.DataType = 'Scalar';
AO.BEND.OnControl.ChannelNames = getname_booster(AO.BEND.FamilyName, 'OnControl');
AO.BEND.OnControl.HW2PhysicsParams = 1;
AO.BEND.OnControl.Physics2HWParams = 1;
AO.BEND.OnControl.Units = 'Hardware';
AO.BEND.OnControl.HWUnits      = '';
AO.BEND.OnControl.PhysicsUnits = '';

AO.BEND.Enable.MemberOf = {'PlotFamily';};
AO.BEND.Enable.Mode = 'Simulator';
AO.BEND.Enable.DataType = 'Scalar';
AO.BEND.Enable.ChannelNames = getname_booster(AO.BEND.FamilyName, 'Enable');
AO.BEND.Enable.HW2PhysicsParams = 1;
AO.BEND.Enable.Physics2HWParams = 1;
AO.BEND.Enable.Units = 'Hardware';
AO.BEND.Enable.HWUnits      = '';
AO.BEND.Enable.PhysicsUnits = '';

AO.BEND.Ready.MemberOf = {'PlotFamily';};
AO.BEND.Ready.Mode = 'Simulator';
AO.BEND.Ready.DataType = 'Scalar';
AO.BEND.Ready.ChannelNames = getname_booster(AO.BEND.FamilyName, 'Ready');
AO.BEND.Ready.HW2PhysicsParams = 1;
AO.BEND.Ready.Physics2HWParams = 1;
AO.BEND.Ready.Units = 'Hardware';
AO.BEND.Ready.HWUnits      = '';
AO.BEND.Ready.PhysicsUnits = '';



% RF
% RF power in the SP/AM
AO.RF.FamilyName = 'RF';
AO.RF.MemberOf   = {'MachineConfig'; 'PlotFamily'; 'RF'};
AO.RF.Status = 1;
AO.RF.DeviceList = [1 1];
AO.RF.ElementList = 1;

AO.RF.Monitor.MemberOf   = {'PlotFamily'; 'RF'};
AO.RF.Monitor.Mode = 'Simulator';  
AO.RF.Monitor.DataType = 'Scalar';
AO.RF.Monitor.ChannelNames = 'BR4_____RFCONT_AM01';
AO.RF.Monitor.HW2PhysicsParams = 1;
AO.RF.Monitor.Physics2HWParams = 1;
AO.RF.Monitor.Units = 'Hardware';
AO.RF.Monitor.HWUnits       = '';
AO.RF.Monitor.PhysicsUnits  = '';

AO.RF.Setpoint.MemberOf = {'PlotFamily'; 'RF'};
AO.RF.Setpoint.MemberOf   = {'PlotFamily'; 'RF'};
AO.RF.Setpoint.Mode = 'Simulator';     
AO.RF.Setpoint.DataType = 'Scalar';
AO.RF.Setpoint.ChannelNames = 'BR4_____RFCONT_AC01';
AO.RF.Setpoint.HW2PhysicsParams = 1;
AO.RF.Setpoint.Physics2HWParams = 1;
AO.RF.Setpoint.Units = 'Hardware';
AO.RF.Setpoint.HWUnits       = 'DAC Volts'; % 'kW';
AO.RF.Setpoint.PhysicsUnits  = 'DAC Volts';
AO.RF.Setpoint.Range = [0 6.6];
AO.RF.Setpoint.Tolerance = Inf;

AO.RF.PhaseControl.MemberOf = {'PlotFamily'; 'RF'};
AO.RF.PhaseControl.Mode = 'Simulator';     
AO.RF.PhaseControl.DataType = 'Scalar';
AO.RF.PhaseControl.ChannelNames = 'BR4_____PHSCON_AC00';
AO.RF.PhaseControl.HW2PhysicsParams = 1;
AO.RF.PhaseControl.Physics2HWParams = 1;
AO.RF.PhaseControl.Units = 'Hardware';
AO.RF.PhaseControl.HWUnits       = 'Degrees';
AO.RF.PhaseControl.PhysicsUnits  = 'Degrees';
AO.RF.PhaseControl.Range = [0 360];
AO.RF.PhaseControl.Tolerance = .2;

AO.RF.Phase.MemberOf = {'PlotFamily'; 'RF'};
AO.RF.Phase.Mode = 'Simulator';     
AO.RF.Phase.DataType = 'Scalar';
AO.RF.Phase.ChannelNames = 'BR4_____PHSCON_AM00';
AO.RF.Phase.HW2PhysicsParams = 1;
AO.RF.Phase.Physics2HWParams = 1;
AO.RF.Phase.Units = 'Hardware';
AO.RF.Phase.HWUnits       = 'Degrees';
AO.RF.Phase.PhysicsUnits  = 'Degrees';

AO.RF.PhaseError.MemberOf = {'PlotFamily'; 'RF'};
AO.RF.PhaseError.Mode = 'Simulator';     
AO.RF.PhaseError.DataType = 'Scalar';
AO.RF.PhaseError.ChannelNames = 'BR4_____TUNERR_AM02';
AO.RF.PhaseError.HW2PhysicsParams = 1;
AO.RF.PhaseError.Physics2HWParams = 1;
AO.RF.PhaseError.Units = 'Hardware';
AO.RF.PhaseError.HWUnits       = 'Degrees';
AO.RF.PhaseError.PhysicsUnits  = 'Degrees';

AO.RF.CircForwardPower.MemberOf = {'PlotFamily'; 'RF'};
AO.RF.CircForwardPower.Mode = 'Simulator';     
AO.RF.CircForwardPower.DataType = 'Scalar';
AO.RF.CircForwardPower.ChannelNames = 'BR4_____CLDFWD_AM00';
AO.RF.CircForwardPower.HW2PhysicsParams = 1;
AO.RF.CircForwardPower.Physics2HWParams = 1;
AO.RF.CircForwardPower.Units = 'Hardware';
AO.RF.CircForwardPower.HWUnits       = 'kW';
AO.RF.CircForwardPower.PhysicsUnits  = 'kW';

AO.RF.WaveGuideForwardPower.MemberOf = {'PlotFamily'; 'RF'};
AO.RF.WaveGuideForwardPower.Mode = 'Simulator';     
AO.RF.WaveGuideForwardPower.DataType = 'Scalar';
AO.RF.WaveGuideForwardPower.ChannelNames = 'BR4_____WGFWD__AM02';
AO.RF.WaveGuideForwardPower.HW2PhysicsParams = 1;
AO.RF.WaveGuideForwardPower.Physics2HWParams = 1;
AO.RF.WaveGuideForwardPower.Units = 'Hardware';
AO.RF.WaveGuideForwardPower.HWUnits       = 'kW';
AO.RF.WaveGuideForwardPower.PhysicsUnits  = 'kW';

AO.RF.WaveGuideReversePower.MemberOf = {'PlotFamily'; 'RF'};
AO.RF.WaveGuideReversePower.Mode = 'Simulator';     
AO.RF.WaveGuideReversePower.DataType = 'Scalar';
AO.RF.WaveGuideReversePower.ChannelNames = 'BR4_____WGREV__AM01';
AO.RF.WaveGuideReversePower.HW2PhysicsParams = 1;
AO.RF.WaveGuideReversePower.Physics2HWParams = 1;
AO.RF.WaveGuideReversePower.Units = 'Hardware';
AO.RF.WaveGuideReversePower.HWUnits       = 'kW';
AO.RF.WaveGuideReversePower.PhysicsUnits  = 'kW';

AO.RF.TunerPosition.MemberOf = {'PlotFamily'; 'RF'};
AO.RF.TunerPosition.Mode = 'Simulator';     
AO.RF.TunerPosition.DataType = 'Scalar';
AO.RF.TunerPosition.ChannelNames = 'BR4_____TUNPOS_AM00';
AO.RF.TunerPosition.HW2PhysicsParams = 1;
AO.RF.TunerPosition.Physics2HWParams = 1;
AO.RF.TunerPosition.Units = 'Hardware';
AO.RF.TunerPosition.HWUnits       = 'CM';
AO.RF.TunerPosition.PhysicsUnits  = 'CM';

AO.RF.CavityTemperatureControl.MemberOf = {'PlotFamily'; 'RF'};
AO.RF.CavityTemperatureControl.Mode = 'Simulator';     
AO.RF.CavityTemperatureControl.DataType = 'Scalar';
AO.RF.CavityTemperatureControl.ChannelNames = 'BR4_____CAVTMP_AC03';
AO.RF.CavityTemperatureControl.HW2PhysicsParams = 1;
AO.RF.CavityTemperatureControl.Physics2HWParams = 1;
AO.RF.CavityTemperatureControl.Units = 'Hardware';
AO.RF.CavityTemperatureControl.HWUnits       = 'C';
AO.RF.CavityTemperatureControl.PhysicsUnits  = 'C';

AO.RF.CavityTemperature.MemberOf = {'PlotFamily'; 'RF'};
AO.RF.CavityTemperature.Mode = 'Simulator';     
AO.RF.CavityTemperature.DataType = 'Scalar';
AO.RF.CavityTemperature.ChannelNames = 'BR4_____CAVTMP_AM03';
AO.RF.CavityTemperature.HW2PhysicsParams = 1;
AO.RF.CavityTemperature.Physics2HWParams = 1;
AO.RF.CavityTemperature.Units = 'Hardware';
AO.RF.CavityTemperature.HWUnits       = 'C';
AO.RF.CavityTemperature.PhysicsUnits  = 'C';

AO.RF.LCWTemperature.MemberOf = {'PlotFamily'; 'RF'};
AO.RF.LCWTemperature.Mode = 'Simulator';     
AO.RF.LCWTemperature.DataType = 'Scalar';
AO.RF.LCWTemperature.ChannelNames = 'BR4_____LCWTMP_AM03';
AO.RF.LCWTemperature.HW2PhysicsParams = 1;
AO.RF.LCWTemperature.Physics2HWParams = 1;
AO.RF.LCWTemperature.Units = 'Hardware';
AO.RF.LCWTemperature.HWUnits       = 'C';
AO.RF.LCWTemperature.PhysicsUnits  = 'C';

AO.RF.CircTemperature.MemberOf = {'PlotFamily'; 'RF'};
AO.RF.CircTemperature.Mode = 'Simulator';     
AO.RF.CircTemperature.DataType = 'Scalar';
AO.RF.CircTemperature.ChannelNames = 'BR4_____CIRTMP_AM03';
AO.RF.CircTemperature.HW2PhysicsParams = 1;
AO.RF.CircTemperature.Physics2HWParams = 1;
AO.RF.CircTemperature.Units = 'Hardware';
AO.RF.CircTemperature.HWUnits       = 'C';
AO.RF.CircTemperature.PhysicsUnits  = 'C';

AO.RF.Monitor.MemberOf = {'PlotFamily'; 'RF'};
AO.RF.CircLoadTemperature.Mode = 'Simulator';     
AO.RF.CircLoadTemperature.DataType = 'Scalar';
AO.RF.CircLoadTemperature.ChannelNames = 'BR4_____CLDTMP_AM03';
AO.RF.CircLoadTemperature.HW2PhysicsParams = 1;
AO.RF.CircLoadTemperature.Physics2HWParams = 1;
AO.RF.CircLoadTemperature.Units = 'Hardware';
AO.RF.CircLoadTemperature.HWUnits       = 'C';
AO.RF.CircLoadTemperature.PhysicsUnits  = 'C';

AO.RF.CircLoadFlow.MemberOf = {'PlotFamily'; 'RF'};
AO.RF.CircLoadFlow.Mode = 'Simulator';     
AO.RF.CircLoadFlow.DataType = 'Scalar';
AO.RF.CircLoadFlow.ChannelNames = 'BR4_____CLDFLW_AM01';
AO.RF.CircLoadFlow.HW2PhysicsParams = 1;
AO.RF.CircLoadFlow.Physics2HWParams = 1;
AO.RF.CircLoadFlow.Units = 'Hardware';
AO.RF.CircLoadFlow.HWUnits       = 'gpm';
AO.RF.CircLoadFlow.PhysicsUnits  = 'gpm';

AO.RF.CircFlow.MemberOf = {'PlotFamily'; 'RF'};
AO.RF.CircFlow.Mode = 'Simulator';     
AO.RF.CircFlow.DataType = 'Scalar';
AO.RF.CircFlow.ChannelNames = 'BR4_____CIRFLW_AM02';
AO.RF.CircFlow.HW2PhysicsParams = 1;
AO.RF.CircFlow.Physics2HWParams = 1;
AO.RF.CircFlow.Units = 'Hardware';
AO.RF.CircFlow.HWUnits       = 'gpm';
AO.RF.CircFlow.PhysicsUnits  = 'gpm';

AO.RF.SwitchLoadFlow.MemberOf = {'PlotFamily'; 'RF'};
AO.RF.SwitchLoadFlow.Mode = 'Simulator';     
AO.RF.SwitchLoadFlow.DataType = 'Scalar';
AO.RF.SwitchLoadFlow.ChannelNames = 'BR4_____SLDFLW_AM00';
AO.RF.SwitchLoadFlow.HW2PhysicsParams = 1;
AO.RF.SwitchLoadFlow.Physics2HWParams = 1;
AO.RF.SwitchLoadFlow.Units = 'Hardware';
AO.RF.SwitchLoadFlow.HWUnits       = 'gpm';
AO.RF.SwitchLoadFlow.PhysicsUnits  = 'gpm';

AO.RF.CavityFlow.MemberOf = {'PlotFamily'; 'RF'};
AO.RF.CavityFlow.Mode = 'Simulator';     
AO.RF.CavityFlow.DataType = 'Scalar';
AO.RF.CavityFlow.ChannelNames = 'BR4_____CAVFLW_AM00';
AO.RF.CavityFlow.HW2PhysicsParams = 1;
AO.RF.CavityFlow.Physics2HWParams = 1;
AO.RF.CavityFlow.Units = 'Hardware';
AO.RF.CavityFlow.HWUnits       = 'gpm';
AO.RF.CavityFlow.PhysicsUnits  = 'gpm';

AO.RF.WindowFlow.MemberOf = {'PlotFamily'; 'RF'};
AO.RF.WindowFlow.Mode = 'Simulator';     
AO.RF.WindowFlow.DataType = 'Scalar';
AO.RF.WindowFlow.ChannelNames = 'BR4_____WINFLW_AM01';
AO.RF.WindowFlow.HW2PhysicsParams = 1;
AO.RF.WindowFlow.Physics2HWParams = 1;
AO.RF.WindowFlow.Units = 'Hardware';
AO.RF.WindowFlow.HWUnits       = 'gpm';
AO.RF.WindowFlow.PhysicsUnits  = 'gpm';

AO.RF.CavityTunerFlow.MemberOf = {'PlotFamily'; 'RF'};
AO.RF.CavityTunerFlow.Mode = 'Simulator';     
AO.RF.CavityTunerFlow.DataType = 'Scalar';
AO.RF.CavityTunerFlow.ChannelNames = 'BR4_____TUNFLW_AM02';
AO.RF.CavityTunerFlow.HW2PhysicsParams = 1;
AO.RF.CavityTunerFlow.Physics2HWParams = 1;
AO.RF.CavityTunerFlow.Units = 'Hardware';
AO.RF.CavityTunerFlow.HWUnits       = 'gpm';
AO.RF.CavityTunerFlow.PhysicsUnits  = 'gpm';

AO.RF.Position = 0;


% AO.DCCT.FamilyName = 'DCCT';
% AO.DCCT.MemberOf = {};
% AO.DCCT.DeviceList = [1 1];
% AO.DCCT.ElementList = [1];
% AO.DCCT.Status = 1;
%
% AO.DCCT.Monitor.Mode = 'Simulator';
% AO.DCCT.Monitor.DataType = 'Scalar';
% AO.DCCT.Monitor.ChannelNames = '';
% %AO.DCCT.Monitor.SpecialFunctionGet = 'getdcct_bts';
% AO.DCCT.Monitor.HW2PhysicsParams = 1;
% AO.DCCT.Monitor.Physics2HWParams = 1;
% AO.DCCT.Monitor.Units = 'Hardware';
% AO.DCCT.Monitor.HWUnits = 'mAmps';
% AO.DCCT.Monitor.PhysicsUnits = 'mAmps';


% % This is a soft family for energy ramping
% AO.GeV.FamilyName = 'GeV';
% AO.GeV.MemberOf = {};
% AO.GeV.Status = 1;
% AO.GeV.DeviceList = [1 1];
% AO.GeV.ElementList = [1];
% 
% AO.GeV.Monitor.Mode = 'Simulator';
% AO.GeV.Monitor.DataType = 'Scalar';
% AO.GeV.Monitor.ChannelNames = '';
% AO.GeV.Monitor.SpecialFunctionGet = 'getenergy_als';  %'bend2gev';
% AO.GeV.Monitor.HW2PhysicsParams = 1;
% AO.GeV.Monitor.Physics2HWParams = 1;
% AO.GeV.Monitor.Units = 'Hardware';
% AO.GeV.Monitor.HWUnits      = 'GeV';
% AO.GeV.Monitor.PhysicsUnits = 'GeV';
% 
% AO.GeV.Setpoint.Mode = 'Simulator';
% AO.GeV.Setpoint.DataType = 'Scalar';
% AO.GeV.Setpoint.ChannelNames = '';
% AO.GeV.Setpoint.SpecialFunctionGet = 'getenergy_als';
% AO.GeV.Setpoint.SpecialFunctionSet = 'setenergy_als';
% AO.GeV.Setpoint.HW2PhysicsParams = 1;
% AO.GeV.Setpoint.Physics2HWParams = 1;
% AO.GeV.Setpoint.Units = 'Hardware';
% AO.GeV.Setpoint.HWUnits      = 'GeV';
% AO.GeV.Setpoint.PhysicsUnits = 'GeV';


% % TV
% AO.TV.FamilyName = 'TV';
% AO.TV.MemberOf   = {'PlotFamily'; 'TV';};
% AO.TV.DeviceList = [1 1; 1 2; 4 1];
% AO.TV.ElementList = [1 2 3]';
% AO.TV.Status = ones(3,1);
% 
% AO.TV.Monitor.MemberOf   = {'PlotFamily'; };
% AO.TV.Monitor.Mode = 'Simulator';
% AO.TV.Monitor.DataType = 'Scalar';
% AO.TV.Monitor.ChannelNames = getname_booster(AO.TV.FamilyName, 'Monitor');
% AO.TV.Monitor.Units = 'Hardware';
% AO.TV.Monitor.HWUnits          = '';
% AO.TV.Monitor.PhysicsUnits     = '';
% AO.TV.Monitor.HW2PhysicsParams = 1;
% AO.TV.Monitor.Physics2HWParams = 1;
% 
% AO.TV.Setpoint.MemberOf   = {'TV'};
% AO.TV.Setpoint.Mode = 'Simulator';
% AO.TV.Setpoint.DataType = 'Scalar';
% AO.TV.Setpoint.ChannelNames = getname_booster(AO.TV.FamilyName, 'Setpoint');
% AO.TV.Setpoint.SpecialFunctionGet = @gettv_bts;
% AO.TV.Setpoint.SpecialFunctionSet = @settv_bts;
% AO.TV.Setpoint.Units = 'Hardware';
% AO.TV.Setpoint.HWUnits          = '';
% AO.TV.Setpoint.PhysicsUnits     = '';
% AO.TV.Setpoint.HW2PhysicsParams = 1;
% AO.TV.Setpoint.Physics2HWParams = 1;
% 
% AO.TV.In.MemberOf   = {'PlotFamily'; };
% AO.TV.In.Mode = 'Simulator';
% AO.TV.In.DataType = 'Scalar';
% AO.TV.In.ChannelNames = getname_booster(AO.TV.FamilyName, 'In');
% AO.TV.In.Units = 'Hardware';
% AO.TV.In.HWUnits          = '';
% AO.TV.In.PhysicsUnits     = '';
% AO.TV.In.HW2PhysicsParams = 1;
% AO.TV.In.Physics2HWParams = 1;
% 
% AO.TV.Out.MemberOf   = {'PlotFamily'; };
% AO.TV.Out.Mode = 'Simulator';
% AO.TV.Out.DataType = 'Scalar';
% AO.TV.Out.ChannelNames = getname_booster(AO.TV.FamilyName, 'Out');
% AO.TV.Out.Units = 'Hardware';
% AO.TV.Out.HWUnits          = '';
% AO.TV.Out.PhysicsUnits     = '';
% AO.TV.Out.HW2PhysicsParams = 1;
% AO.TV.Out.Physics2HWParams = 1;
% 
% AO.TV.InControl.MemberOf   = {'PlotFamily'; };
% AO.TV.InControl.Mode = 'Simulator';
% AO.TV.InControl.DataType = 'Scalar';
% AO.TV.InControl.ChannelNames = getname_booster(AO.TV.FamilyName, 'InControl');
% AO.TV.InControl.Units = 'Hardware';
% AO.TV.InControl.HWUnits          = '';
% AO.TV.InControl.PhysicsUnits     = '';
% AO.TV.InControl.HW2PhysicsParams = 1;
% AO.TV.InControl.Physics2HWParams = 1;
% 
% AO.TV.Lamp.MemberOf   = {'PlotFamily'; };
% AO.TV.Lamp.Mode = 'Simulator';
% AO.TV.Lamp.DataType = 'Scalar';
% AO.TV.Lamp.ChannelNames = getname_booster(AO.TV.FamilyName, 'Lamp');
% AO.TV.Lamp.Units = 'Hardware';
% AO.TV.Lamp.HWUnits          = '';
% AO.TV.Lamp.PhysicsUnits     = '';
% AO.TV.Lamp.HW2PhysicsParams = 1;
% AO.TV.Lamp.Physics2HWParams = 1;


% Save the AO so that family2dev will work
setao(AO);


%%%%%%%%%%%%%
% Get Range %
%%%%%%%%%%%%%
AO.HCM.Setpoint.Range     = [local_minsp(AO.HCM.FamilyName, AO.HCM.DeviceList) local_maxsp(AO.HCM.FamilyName, AO.HCM.DeviceList)];
AO.HCM.OnControl.Range    = [0 1];
AO.HCM.Enable.Range        = [0 1];
%AO.HCM.RampRate.Range     = [0 10000];
%AO.HCM.TimeConstant.Range = [0 10000];

AO.VCM.Setpoint.Range     = [local_minsp(AO.VCM.FamilyName, AO.VCM.DeviceList) local_maxsp(AO.VCM.FamilyName, AO.VCM.DeviceList)];
AO.VCM.OnControl.Range    = [0 1];
AO.VCM.Enable.Range        = [0 1];
%AO.VCM.RampRate.Range     = [0 10000];
%AO.VCM.TimeConstant.Range = [0 10000];

AO.QF.Setpoint.Range     = [local_minsp(AO.QF.FamilyName, AO.QF.DeviceList) local_maxsp(AO.QF.FamilyName, AO.QF.DeviceList)];
AO.QF.OnControl.Range    = [0 1];
AO.QF.Enable.Range        = [0 1];
%AO.QF.RampRate.Range     = [0 10000];
%AO.QF.TimeConstant.Range = [0 10000];
 
AO.QD.Setpoint.Range     = [local_minsp(AO.QD.FamilyName, AO.QD.DeviceList) local_maxsp(AO.QD.FamilyName, AO.QD.DeviceList)];
AO.QD.OnControl.Range    = [0 1];
AO.QD.Enable.Range        = [0 1];
%AO.QD.RampRate.Range     = [0 10000];
%AO.QD.TimeConstant.Range = [0 10000];

AO.SF.Setpoint.Range     = [local_minsp(AO.SF.FamilyName, AO.SF.DeviceList) local_maxsp(AO.SF.FamilyName, AO.SF.DeviceList)];
AO.SF.OnControl.Range    = [0 1];
AO.SF.Enable.Range        = [0 1];
%AO.SF.RampRate.Range     = [0 10000];
%AO.SF.TimeConstant.Range = [0 10000];

AO.SD.Setpoint.Range     = [local_minsp(AO.SD.FamilyName, AO.SD.DeviceList) local_maxsp(AO.SD.FamilyName, AO.SD.DeviceList)];
AO.SD.OnControl.Range    = [0 1];
AO.SD.Enable.Range        = [0 1];
%AO.SD.RampRate.Range     = [0 10000];
%AO.SD.TimeConstant.Range = [0 10000];

AO.BEND.Setpoint.Range     = [local_minsp(AO.BEND.FamilyName, AO.BEND.DeviceList) local_maxsp(AO.BEND.FamilyName, AO.BEND.DeviceList)];
AO.BEND.OnControl.Range    = [0 1];
AO.BEND.Enable.Range        = [0 1];
%AO.BEND.RampRate.Range     = [0 10000];
%AO.BEND.TimeConstant.Range = [0 10000];

%AO.TV.Setpoint.Range  = [0 1];
%AO.TV.InControl.Range = [0 1];
%AO.TV.Lamp.Range = [0 1];



% The operational mode sets the path, filenames, and other important parameters
% Run setoperationalmode after most of the AO is built so that the Units and Mode fields
% can be set in setoperationalmode
setao(AO);
setoperationalmode(OperationalMode);
AO = getao;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Response Matrix Kick Size (hardware units) %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
AO.HCM.Setpoint.DeltaRespMat = .5e-3;
AO.VCM.Setpoint.DeltaRespMat = .5e-3;
AO.QF.Setpoint.DeltaRespMat   = 1e-5;
AO.QD.Setpoint.DeltaRespMat   = 1e-5;
AO.SF.Setpoint.DeltaRespMat   = 1e-5;
AO.SD.Setpoint.DeltaRespMat   = 1e-5;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tolerance (hardware units) %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
AO.HCM.Setpoint.Tolerance  = gettol(AO.HCM.FamilyName)  * ones(length(AO.HCM.ElementList),  1);
AO.VCM.Setpoint.Tolerance  = gettol(AO.VCM.FamilyName)  * ones(length(AO.VCM.ElementList),  1);
AO.QF.Setpoint.Tolerance   = gettol(AO.QF.FamilyName)   * ones(length(AO.QF.ElementList),   1);
AO.QD.Setpoint.Tolerance   = gettol(AO.QD.FamilyName)   * ones(length(AO.QD.ElementList),   1);
AO.SF.Setpoint.Tolerance   = gettol(AO.SF.FamilyName)   * ones(length(AO.SF.ElementList),   1);
AO.SD.Setpoint.Tolerance   = gettol(AO.SD.FamilyName)   * ones(length(AO.SD.ElementList),   1);
AO.BEND.Setpoint.Tolerance = gettol(AO.BEND.FamilyName) * ones(length(AO.BEND.ElementList), 1);
%AO.TV.Setpoint.Tolerance   = gettol(AO.TV.FamilyName)   * ones(length(AO.TV.ElementList),   1);


setao(AO);



function [Amps] = local_minsp(Family, List)

for i = 1:size(List,1)
    if strcmp(Family,'HCM')
        Amps(i,1) = -6;
    elseif strcmp(Family,'VCM')
        Amps(i,1) = -6;
    elseif strcmp(Family,'QF')
        Amps(i,1) = 0;
    elseif strcmp(Family,'QD')
        Amps(i,1) = 0;
    elseif strcmp(Family,'SF')
        Amps(i,1) = 0;
    elseif strcmp(Family,'SD')
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
    elseif strcmp(Family,'QF')
        Amps(i,1) = 130;
    elseif strcmp(Family,'QD')
        Amps(i,1) = 130;
    elseif strcmp(Family,'SF')
        Amps(i,1) = 130;
    elseif strcmp(Family,'SD')
        Amps(i,1) = 130;
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
elseif strcmp(Family,'QF')
    tol = 0.6;
elseif strcmp(Family,'QD')
    tol = 0.6;
elseif strcmp(Family,'SF')
    tol = 0.6;
elseif strcmp(Family,'SD')
    tol = 0.6;
elseif strcmp(Family,'BEND')
    tol = .5;
elseif strcmp(Family,'TV')
    tol = .5;
else
    fprintf('   Tolerance unknown for %s family, hence set to zero.\n', Family);
    tol = 0;
end


