function init(OperationalMode)
%LNLSINIT - MML initialization file for the VUV ring at sirius3
%  lnlsinit(OperationalMode)
%
%  See also setoperationalmode

% 2013-12-02 Inicio (Ximenes)


setao([]);
setad([]);


% Base on the location of this file
[SIRIUS_ROOT, ~, ~] = fileparts(mfilename('fullpath'));
AD.Directory.ExcDataDir = [SIRIUS_ROOT, filesep, 'excitation_curves'];
setad(AD);


% BENDS

AO.bend.FamilyName  = 'bend';
AO.bend.MemberOf    = {'PlotFamily'; 'bend'; 'BEND'; 'Magnet';};
AO.bend.DeviceList  = getDeviceList(1,2);
AO.bend.ElementList = (1:size(AO.bend.DeviceList,1))';
AO.bend.Status      = ones(size(AO.bend.DeviceList,1),1);
AO.bend.Position    = [];

AO.bend.Monitor.MemberOf = {};
AO.bend.Monitor.Mode = 'Simulator';
AO.bend.Monitor.DataType = 'Scalar';
AO.bend.Monitor.ChannelNames = getname(AO.bend.FamilyName, 'Monitor', AO.bend.DeviceList);
AO.bend.Monitor.HW2PhysicsParams = 1;
AO.bend.Monitor.Physics2HWParams = 1;
AO.bend.Monitor.Units        = 'Hardware';
AO.bend.Monitor.HWUnits      = 'Ampere';
AO.bend.Monitor.PhysicsUnits = 'GeV';

AO.bend.Setpoint.MemberOf = {'MachineConfig';};
AO.bend.Setpoint.Mode = 'Simulator';
AO.bend.Setpoint.DataType = 'Scalar';
AO.bend.Setpoint.ChannelNames = getname(AO.bend.FamilyName, 'Setpoint', AO.bend.DeviceList);
AO.bend.Setpoint.HW2PhysicsParams = 1;
AO.bend.Setpoint.Physics2HWParams = 1;
AO.bend.Setpoint.Units        = 'Hardware';
AO.bend.Setpoint.HWUnits      = 'Ampere';
AO.bend.Setpoint.PhysicsUnits = 'GeV';
AO.bend.Setpoint.Range        = [0 300];
AO.bend.Setpoint.Tolerance    = .1;
AO.bend.Setpoint.DeltaRespMat = .01;


AO.qf1a.FamilyName  = 'qf1a';
AO.qf1a.MemberOf    = {'PlotFamily'; 'qf1a'; 'QUAD'; 'Magnet';};
AO.qf1a.DeviceList  = getDeviceList(1,1);
AO.qf1a.ElementList = (1:size(AO.qf1a.DeviceList,1))';
AO.qf1a.Status      = ones(size(AO.qf1a.DeviceList,1),1);
AO.qf1a.Position    = [];
AO.qf1a.Monitor.MemberOf = {};
AO.qf1a.Monitor.Mode = 'Simulator';
AO.qf1a.Monitor.DataType = 'Scalar';
AO.qf1a.Monitor.Units        = 'Hardware';
AO.qf1a.Monitor.HWUnits      = 'Ampere';
AO.qf1a.Monitor.PhysicsUnits = 'meter^-2';
AO.qf1a.Setpoint.MemberOf      = {'MachineConfig'};
AO.qf1a.Setpoint.Mode          = 'Simulator';
AO.qf1a.Setpoint.DataType      = 'Scalar';
AO.qf1a.Setpoint.ChannelNames = getname(AO.qf1a.FamilyName, 'Setpoint', AO.qf1a.DeviceList);
AO.qf1a.Setpoint.Units         = 'Hardware';
AO.qf1a.Setpoint.HWUnits       = 'Ampere';
AO.qf1a.Setpoint.PhysicsUnits  = 'meter^-2';
AO.qf1a.Setpoint.Range         = [0 225];
AO.qf1a.Setpoint.Tolerance     = 0.2;
AO.qf1a.Setpoint.DeltaRespMat  = 0.5; 


AO.qf1b.FamilyName  = 'qf1b';
AO.qf1b.MemberOf    = {'PlotFamily'; 'qf1b'; 'QUAD'; 'Magnet';};
AO.qf1b.DeviceList  = getDeviceList(1,1);
AO.qf1b.ElementList = (1:size(AO.qf1b.DeviceList,1))';
AO.qf1b.Status      = ones(size(AO.qf1b.DeviceList,1),1);
AO.qf1b.Position    = [];
AO.qf1b.Monitor.MemberOf = {};
AO.qf1b.Monitor.Mode = 'Simulator';
AO.qf1b.Monitor.DataType = 'Scalar';
AO.qf1b.Monitor.Units        = 'Hardware';
AO.qf1b.Monitor.HWUnits      = 'Ampere';
AO.qf1b.Monitor.PhysicsUnits = 'meter^-2';
AO.qf1b.Setpoint.MemberOf      = {'MachineConfig'};
AO.qf1b.Setpoint.Mode          = 'Simulator';
AO.qf1b.Setpoint.DataType      = 'Scalar';
AO.qf1b.Setpoint.ChannelNames = getname(AO.qf1b.FamilyName, 'Setpoint', AO.qf1b.DeviceList);
AO.qf1b.Setpoint.Units         = 'Hardware';
AO.qf1b.Setpoint.HWUnits       = 'Ampere';
AO.qf1b.Setpoint.PhysicsUnits  = 'meter^-2';
AO.qf1b.Setpoint.Range         = [0 225];
AO.qf1b.Setpoint.Tolerance     = 0.2;
AO.qf1b.Setpoint.DeltaRespMat  = 0.5; 


AO.qd2.FamilyName  = 'qd2';
AO.qd2.MemberOf    = {'PlotFamily'; 'qd2'; 'QUAD'; 'Magnet';};
AO.qd2.DeviceList  = getDeviceList(1,1);
AO.qd2.ElementList = (1:size(AO.qd2.DeviceList,1))';
AO.qd2.Status      = ones(size(AO.qd2.DeviceList,1),1);
AO.qd2.Position    = [];
AO.qd2.Monitor.MemberOf = {};
AO.qd2.Monitor.Mode = 'Simulator';
AO.qd2.Monitor.DataType = 'Scalar';
AO.qd2.Monitor.Units        = 'Hardware';
AO.qd2.Monitor.HWUnits      = 'Ampere';
AO.qd2.Monitor.PhysicsUnits = 'meter^-2';
AO.qd2.Setpoint.MemberOf      = {'MachineConfig'};
AO.qd2.Setpoint.Mode          = 'Simulator';
AO.qd2.Setpoint.DataType      = 'Scalar';
AO.qd2.Setpoint.ChannelNames = getname(AO.qd2.FamilyName, 'Setpoint', AO.qd2.DeviceList);
AO.qd2.Setpoint.Units         = 'Hardware';
AO.qd2.Setpoint.HWUnits       = 'Ampere';
AO.qd2.Setpoint.PhysicsUnits  = 'meter^-2';
AO.qd2.Setpoint.Range         = [0 225];
AO.qd2.Setpoint.Tolerance     = 0.2;
AO.qd2.Setpoint.DeltaRespMat  = 0.5; 


AO.qf2.FamilyName  = 'qf2';
AO.qf2.MemberOf    = {'PlotFamily'; 'qf2'; 'QUAD'; 'Magnet';};
AO.qf2.DeviceList  = getDeviceList(1,1);
AO.qf2.ElementList = (1:size(AO.qf2.DeviceList,1))';
AO.qf2.Status      = ones(size(AO.qf2.DeviceList,1),1);
AO.qf2.Position    = [];
AO.qf2.Monitor.MemberOf = {};
AO.qf2.Monitor.Mode = 'Simulator';
AO.qf2.Monitor.DataType = 'Scalar';
AO.qf2.Monitor.Units        = 'Hardware';
AO.qf2.Monitor.HWUnits      = 'Ampere';
AO.qf2.Monitor.PhysicsUnits = 'meter^-2';
AO.qf2.Setpoint.MemberOf      = {'MachineConfig'};
AO.qf2.Setpoint.Mode          = 'Simulator';
AO.qf2.Setpoint.DataType      = 'Scalar';
AO.qf2.Setpoint.ChannelNames = getname(AO.qf2.FamilyName, 'Setpoint', AO.qf2.DeviceList);
AO.qf2.Setpoint.Units         = 'Hardware';
AO.qf2.Setpoint.HWUnits       = 'Ampere';
AO.qf2.Setpoint.PhysicsUnits  = 'meter^-2';
AO.qf2.Setpoint.Range         = [0 225];
AO.qf2.Setpoint.Tolerance     = 0.2;
AO.qf2.Setpoint.DeltaRespMat  = 0.5; 

AO.qd3.FamilyName  = 'qd3';
AO.qd3.MemberOf    = {'PlotFamily'; 'qd3'; 'QUAD'; 'Magnet';};
AO.qd3.DeviceList  = getDeviceList(1,1);
AO.qd3.ElementList = (1:size(AO.qd3.DeviceList,1))';
AO.qd3.Status      = ones(size(AO.qd3.DeviceList,1),1);
AO.qd3.Position    = [];
AO.qd3.Monitor.MemberOf = {};
AO.qd3.Monitor.Mode = 'Simulator';
AO.qd3.Monitor.DataType = 'Scalar';
AO.qd3.Monitor.Units        = 'Hardware';
AO.qd3.Monitor.HWUnits      = 'Ampere';
AO.qd3.Monitor.PhysicsUnits = 'meter^-2';
AO.qd3.Setpoint.MemberOf      = {'MachineConfig'};
AO.qd3.Setpoint.Mode          = 'Simulator';
AO.qd3.Setpoint.DataType      = 'Scalar';
AO.qd3.Setpoint.ChannelNames = getname(AO.qd3.FamilyName, 'Setpoint', AO.qd3.DeviceList);
AO.qd3.Setpoint.Units         = 'Hardware';
AO.qd3.Setpoint.HWUnits       = 'Ampere';
AO.qd3.Setpoint.PhysicsUnits  = 'meter^-2';
AO.qd3.Setpoint.Range         = [0 225];
AO.qd3.Setpoint.Tolerance     = 0.2;
AO.qd3.Setpoint.DeltaRespMat  = 0.5; 


AO.qf3.FamilyName  = 'qf3';
AO.qf3.MemberOf    = {'PlotFamily'; 'qf3'; 'QUAD'; 'Magnet';};
AO.qf3.DeviceList  = getDeviceList(1,1);
AO.qf3.ElementList = (1:size(AO.qf3.DeviceList,1))';
AO.qf3.Status      = ones(size(AO.qf3.DeviceList,1),1);
AO.qf3.Position    = [];
AO.qf3.Monitor.MemberOf = {};
AO.qf3.Monitor.Mode = 'Simulator';
AO.qf3.Monitor.DataType = 'Scalar';
AO.qf3.Monitor.Units        = 'Hardware';
AO.qf3.Monitor.HWUnits      = 'Ampere';
AO.qf3.Monitor.PhysicsUnits = 'meter^-2';
AO.qf3.Setpoint.MemberOf      = {'MachineConfig'};
AO.qf3.Setpoint.Mode          = 'Simulator';
AO.qf3.Setpoint.DataType      = 'Scalar';
AO.qf3.Setpoint.ChannelNames = getname(AO.qf3.FamilyName, 'Setpoint', AO.qf3.DeviceList);
AO.qf3.Setpoint.Units         = 'Hardware';
AO.qf3.Setpoint.HWUnits       = 'Ampere';
AO.qf3.Setpoint.PhysicsUnits  = 'meter^-2';
AO.qf3.Setpoint.Range         = [0 225];
AO.qf3.Setpoint.Tolerance     = 0.2;
AO.qf3.Setpoint.DeltaRespMat  = 0.5; 


AO.qd4a.FamilyName  = 'qd4a';
AO.qd4a.MemberOf    = {'PlotFamily'; 'qd4a'; 'QUAD'; 'Magnet';};
AO.qd4a.DeviceList  = getDeviceList(1,1);
AO.qd4a.ElementList = (1:size(AO.qd4a.DeviceList,1))';
AO.qd4a.Status      = ones(size(AO.qd4a.DeviceList,1),1);
AO.qd4a.Position    = [];
AO.qd4a.Monitor.MemberOf = {};
AO.qd4a.Monitor.Mode = 'Simulator';
AO.qd4a.Monitor.DataType = 'Scalar';
AO.qd4a.Monitor.Units        = 'Hardware';
AO.qd4a.Monitor.HWUnits      = 'Ampere';
AO.qd4a.Monitor.PhysicsUnits = 'meter^-2';
AO.qd4a.Setpoint.MemberOf      = {'MachineConfig'};
AO.qd4a.Setpoint.Mode          = 'Simulator';
AO.qd4a.Setpoint.DataType      = 'Scalar';
AO.qd4a.Setpoint.ChannelNames = getname(AO.qd4a.FamilyName, 'Setpoint', AO.qd4a.DeviceList);
AO.qd4a.Setpoint.Units         = 'Hardware';
AO.qd4a.Setpoint.HWUnits       = 'Ampere';
AO.qd4a.Setpoint.PhysicsUnits  = 'meter^-2';
AO.qd4a.Setpoint.Range         = [0 225];
AO.qd4a.Setpoint.Tolerance     = 0.2;
AO.qd4a.Setpoint.DeltaRespMat  = 0.5; 


AO.qf4.FamilyName  = 'qf4';
AO.qf4.MemberOf    = {'PlotFamily'; 'qf4'; 'QUAD'; 'Magnet';};
AO.qf4.DeviceList  = getDeviceList(1,1);
AO.qf4.ElementList = (1:size(AO.qf4.DeviceList,1))';
AO.qf4.Status      = ones(size(AO.qf4.DeviceList,1),1);
AO.qf4.Position    = [];
AO.qf4.Monitor.MemberOf = {};
AO.qf4.Monitor.Mode = 'Simulator';
AO.qf4.Monitor.DataType = 'Scalar';
AO.qf4.Monitor.Units        = 'Hardware';
AO.qf4.Monitor.HWUnits      = 'Ampere';
AO.qf4.Monitor.PhysicsUnits = 'meter^-2';
AO.qf4.Setpoint.MemberOf      = {'MachineConfig'};
AO.qf4.Setpoint.Mode          = 'Simulator';
AO.qf4.Setpoint.DataType      = 'Scalar';
AO.qf4.Setpoint.ChannelNames = getname(AO.qf4.FamilyName, 'Setpoint', AO.qf4.DeviceList);
AO.qf4.Setpoint.Units         = 'Hardware';
AO.qf4.Setpoint.HWUnits       = 'Ampere';
AO.qf4.Setpoint.PhysicsUnits  = 'meter^-2';
AO.qf4.Setpoint.Range         = [0 225];
AO.qf4.Setpoint.Tolerance     = 0.2;
AO.qf4.Setpoint.DeltaRespMat  = 0.5; 

AO.qd4b.FamilyName  = 'qd4b';
AO.qd4b.MemberOf    = {'PlotFamily'; 'qd4b'; 'QUAD'; 'Magnet';};
AO.qd4b.DeviceList  = getDeviceList(1,1);
AO.qd4b.ElementList = (1:size(AO.qd4b.DeviceList,1))';
AO.qd4b.Status      = ones(size(AO.qd4b.DeviceList,1),1);
AO.qd4b.Position    = [];
AO.qd4b.Monitor.MemberOf = {};
AO.qd4b.Monitor.Mode = 'Simulator';
AO.qd4b.Monitor.DataType = 'Scalar';
AO.qd4b.Monitor.Units        = 'Hardware';
AO.qd4b.Monitor.HWUnits      = 'Ampere';
AO.qd4b.Monitor.PhysicsUnits = 'meter^-2';
AO.qd4b.Setpoint.MemberOf      = {'MachineConfig'};
AO.qd4b.Setpoint.Mode          = 'Simulator';
AO.qd4b.Setpoint.DataType      = 'Scalar';
AO.qd4b.Setpoint.ChannelNames = getname(AO.qd4b.FamilyName, 'Setpoint', AO.qd4b.DeviceList);
AO.qd4b.Setpoint.Units         = 'Hardware';
AO.qd4b.Setpoint.HWUnits       = 'Ampere';
AO.qd4b.Setpoint.PhysicsUnits  = 'meter^-2';
AO.qd4b.Setpoint.Range         = [0 225];
AO.qd4b.Setpoint.Tolerance     = 0.2;
AO.qd4b.Setpoint.DeltaRespMat  = 0.5;  


%%%%%%%%%%%%%%%%%%%%%
% Corrector Magnets %
%%%%%%%%%%%%%%%%%%%%%

% hcm
AO.hcm.FamilyName  = 'hcm';
AO.hcm.MemberOf    = {'PlotFamily'; 'COR'; 'hcm'; 'Magnet'};
AO.hcm.DeviceList  = getDeviceList(1,4);
AO.hcm.ElementList = (1:size(AO.hcm.DeviceList,1))';
AO.hcm.Status      = ones(size(AO.hcm.DeviceList,1),1);
AO.hcm.Position    = [];

AO.hcm.Monitor.MemberOf = {'Horizontal'; 'COR'; 'hcm'; 'Magnet';};
AO.hcm.Monitor.Mode = 'Simulator';
AO.hcm.Monitor.DataType = 'Scalar';
AO.hcm.Monitor.Units        = 'Physics';
AO.hcm.Monitor.HWUnits      = 'Ampere';
AO.hcm.Monitor.PhysicsUnits = 'Radian';

AO.hcm.Setpoint.MemberOf = {'MachineConfig'; 'Horizontal'; 'COR'; 'hcm'; 'Magnet'; 'Setpoint'; 'measbpmresp';};
AO.hcm.Setpoint.Mode = 'Simulator';
AO.hcm.Setpoint.DataType = 'Scalar';
AO.hcm.Setpoint.Units        = 'Physics';
AO.hcm.Setpoint.HWUnits      = 'Ampere';
AO.hcm.Setpoint.PhysicsUnits = 'Radian';
AO.hcm.Setpoint.Range        = [-10 10];
AO.hcm.Setpoint.Tolerance    = 0.00001;
AO.hcm.Setpoint.DeltaRespMat = 0.0005; 

% vcm
AO.vcm.FamilyName  = 'vcm';
AO.vcm.MemberOf    = {'PlotFamily'; 'COR'; 'vcm'; 'Magnet'};
AO.vcm.DeviceList  = getDeviceList(1,5);
AO.vcm.ElementList = (1:size(AO.vcm.DeviceList,1))';
AO.vcm.Status      = ones(size(AO.vcm.DeviceList,1),1);
AO.vcm.Position    = [];
AO.vcm.Monitor.MemberOf = {'Vertical'; 'COR'; 'vcm'; 'Magnet';};
AO.vcm.Monitor.Mode = 'Simulator';
AO.vcm.Monitor.DataType = 'Scalar';
AO.vcm.Monitor.Units        = 'Physics';
AO.vcm.Monitor.HWUnits      = 'Ampere';
AO.vcm.Monitor.PhysicsUnits = 'Radian';

AO.vcm.Setpoint.MemberOf = {'MachineConfig'; 'Horizontal'; 'COR'; 'vcm'; 'Magnet'; 'Setpoint'; 'measbpmresp';};
AO.vcm.Setpoint.Mode = 'Simulator';
AO.vcm.Setpoint.DataType = 'Scalar';
AO.vcm.Setpoint.Units        = 'Physics';
AO.vcm.Setpoint.HWUnits      = 'Ampere';
AO.vcm.Setpoint.PhysicsUnits = 'Radian';
AO.vcm.Setpoint.Range        = [-10 10];
AO.vcm.Setpoint.Tolerance    = 0.00001;
AO.vcm.Setpoint.DeltaRespMat = 0.0005; 


% bpmx
AO.bpmx.FamilyName  = 'bpmx';
AO.bpmx.MemberOf    = {'PlotFamily'; 'BPM'; 'bpmx'; 'Diagnostics'};
AO.bpmx.DeviceList  = getDeviceList(1,5);
AO.bpmx.ElementList = (1:size(AO.bpmx.DeviceList,1))';
AO.bpmx.Status      = ones(size(AO.bpmx.DeviceList,1),1);
AO.bpmx.Position    = [];
AO.bpmx.Golden      = zeros(length(AO.bpmx.ElementList),1);
AO.bpmx.Offset      = zeros(length(AO.bpmx.ElementList),1);

AO.bpmx.Monitor.MemberOf = {'bpmx'; 'Monitor';};
AO.bpmx.Monitor.Mode = 'Simulator';
AO.bpmx.Monitor.DataType = 'Scalar';
AO.bpmx.Monitor.HW2PhysicsParams = 1e-3;  % HW [mm], Simulator [Meters]
AO.bpmx.Monitor.Physics2HWParams = 1000;
AO.bpmx.Monitor.Units        = 'Hardware';
AO.bpmx.Monitor.HWUnits      = 'mm';
AO.bpmx.Monitor.PhysicsUnits = 'meter';

% bpmy
AO.bpmy.FamilyName  = 'bpmy';
AO.bpmy.MemberOf    = {'PlotFamily'; 'BPM'; 'bpmy'; 'Diagnostics'};
AO.bpmy.DeviceList  = getDeviceList(1,5);
AO.bpmy.ElementList = (1:size(AO.bpmy.DeviceList,1))';
AO.bpmy.Status      = ones(size(AO.bpmy.DeviceList,1),1);
AO.bpmy.Position    = [];
AO.bpmy.Golden      = zeros(length(AO.bpmy.ElementList),1);
AO.bpmy.Offset      = zeros(length(AO.bpmy.ElementList),1);

AO.bpmy.Monitor.MemberOf = {'bpmy'; 'Monitor';};
AO.bpmy.Monitor.Mode = 'Simulator';
AO.bpmy.Monitor.DataType = 'Scalar';
AO.bpmy.Monitor.HW2PhysicsParams = 1e-3;  % HW [mm], Simulator [Meters]
AO.bpmy.Monitor.Physics2HWParams = 1000;
AO.bpmy.Monitor.Units        = 'Hardware';
AO.bpmy.Monitor.HWUnits      = 'mm';
AO.bpmy.Monitor.PhysicsUnits = 'meter';



% The operational mode sets the path, filenames, and other important parameters
% Run setoperationalmode after most of the AO is built so that the Units and Mode fields
% can be set in setoperationalmode
setao(AO);
%setoperationalmode(OperationalMode);

 
function DList = getDeviceList(NSector,NDevices)

DList = [];
DL = ones(NDevices,2);
DL(:,2) = (1:NDevices)';
for i=1:NSector
    DL(:,1) = i;
    DList = [DList; DL];
end

function [OnePerSector, TwoPerSector, ThreePerSector, FourPerSector, FivePerSector, SixPerSector, EightPerSector, TenPerSector, TwelvePerSector, FifteenPerSector, SixteenPerSector, EighteenPerSector, TwentyFourPerSector] = buildthedevicelists

NSector = 4;

OnePerSector=[];
TwoPerSector=[];
ThreePerSector=[];
FourPerSector=[];
FivePerSector=[];
SixPerSector=[];
EightPerSector=[];
TenPerSector=[];
TwelvePerSector=[];
FifteenPerSector=[];
SixteenPerSector=[];
EighteenPerSector=[];
TwentyFourPerSector=[];

for Sector =1:NSector  
    
    OnePerSector = [OnePerSector;
        Sector 1;];
    
    TwoPerSector = [TwoPerSector;
        Sector 1;
        Sector 2;];
    
    ThreePerSector = [ThreePerSector;
        Sector 1;
        Sector 2;
        Sector 3;];

    FourPerSector = [FourPerSector;
        Sector 1;
        Sector 2;
        Sector 3;
        Sector 4;];	
    
    FivePerSector = [FivePerSector;
        Sector 1;
        Sector 2;
        Sector 3;
        Sector 4;
        Sector 5;];	

    SixPerSector = [SixPerSector;
        Sector 1;
        Sector 2;
        Sector 3;
        Sector 4;
        Sector 5;
        Sector 6;];	
    
    EightPerSector = [EightPerSector;
        Sector 1;
        Sector 2;
        Sector 3;
        Sector 4;
        Sector 5;
        Sector 6;
        Sector 7;
        Sector 8;];	
    
   TenPerSector = [TenPerSector;
        Sector 1;
        Sector 2;
        Sector 3;
        Sector 4;
        Sector 5;
        Sector 6;
        Sector 7;
        Sector 8;
        Sector 9;
        Sector 10;];	
    
    TwelvePerSector = [TwelvePerSector;
        Sector 1;
        Sector 2;
        Sector 3;
        Sector 4;
        Sector 5;
        Sector 6;
        Sector 7;
        Sector 8;
        Sector 9;
        Sector 10;
        Sector 11;
        Sector 12;
        ];	
    
     FifteenPerSector = [FifteenPerSector;
        Sector 1;
        Sector 2;
        Sector 3;
        Sector 4;
        Sector 5;
        Sector 6;
        Sector 7;
        Sector 8;
        Sector 9;
        Sector 10;
        Sector 11;
        Sector 12;
        Sector 13;
        Sector 14;
        Sector 15;
        ];
    
    SixteenPerSector = [SixteenPerSector;
        Sector 1;
        Sector 2;
        Sector 3;
        Sector 4;
        Sector 5;
        Sector 6;
        Sector 7;
        Sector 8;
        Sector 9;
        Sector 10;
        Sector 11;
        Sector 12;
        Sector 13;
        Sector 14;
        Sector 15;
        Sector 16;
        ];
    
     EighteenPerSector = [EighteenPerSector;
        Sector 1;
        Sector 2;
        Sector 3;
        Sector 4;
        Sector 5;
        Sector 6;
        Sector 7;
        Sector 8;
        Sector 9;
        Sector 10;
        Sector 11;
        Sector 12;
        Sector 13;
        Sector 14;
        Sector 15;
        Sector 16;
        Sector 17;
        Sector 18;
        ];
     TwentyFourPerSector = [TwentyFourPerSector;
        Sector 1;
        Sector 2;
        Sector 3;
        Sector 4;
        Sector 5;
        Sector 6;
        Sector 7;
        Sector 8;
        Sector 9;
        Sector 10;
        Sector 11;
        Sector 12;
        Sector 13;
        Sector 14;
        Sector 15;
        Sector 16;
        Sector 17;
        Sector 18;
        Sector 19;
        Sector 20;
        Sector 21;
        Sector 22;
        Sector 23;
        Sector 24;
        ];
end
