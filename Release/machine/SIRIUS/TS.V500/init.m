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


AO.qf01a.FamilyName  = 'qf01a';
AO.qf01a.MemberOf    = {'PlotFamily'; 'qf01a'; 'QUAD'; 'Magnet';};
AO.qf01a.DeviceList  = getDeviceList(1,1);
AO.qf01a.ElementList = (1:size(AO.qf01a.DeviceList,1))';
AO.qf01a.Status      = ones(size(AO.qf01a.DeviceList,1),1);
AO.qf01a.Position    = [];
AO.qf01a.Monitor.MemberOf = {};
AO.qf01a.Monitor.Mode = 'Simulator';
AO.qf01a.Monitor.DataType = 'Scalar';
AO.qf01a.Monitor.Units        = 'Hardware';
AO.qf01a.Monitor.HWUnits      = 'Ampere';
AO.qf01a.Monitor.PhysicsUnits = 'meter^-2';
AO.qf01a.Setpoint.MemberOf      = {'MachineConfig'};
AO.qf01a.Setpoint.Mode          = 'Simulator';
AO.qf01a.Setpoint.DataType      = 'Scalar';
AO.qf01a.Setpoint.ChannelNames = getname(AO.qf01a.FamilyName, 'Setpoint', AO.qf01a.DeviceList);
AO.qf01a.Setpoint.Units         = 'Hardware';
AO.qf01a.Setpoint.HWUnits       = 'Ampere';
AO.qf01a.Setpoint.PhysicsUnits  = 'meter^-2';
AO.qf01a.Setpoint.Range         = [0 225];
AO.qf01a.Setpoint.Tolerance     = 0.2;
AO.qf01a.Setpoint.DeltaRespMat  = 0.5; 


AO.qf01b.FamilyName  = 'qf01b';
AO.qf01b.MemberOf    = {'PlotFamily'; 'qf01b'; 'QUAD'; 'Magnet';};
AO.qf01b.DeviceList  = getDeviceList(1,1);
AO.qf01b.ElementList = (1:size(AO.qf01b.DeviceList,1))';
AO.qf01b.Status      = ones(size(AO.qf01b.DeviceList,1),1);
AO.qf01b.Position    = [];
AO.qf01b.Monitor.MemberOf = {};
AO.qf01b.Monitor.Mode = 'Simulator';
AO.qf01b.Monitor.DataType = 'Scalar';
AO.qf01b.Monitor.Units        = 'Hardware';
AO.qf01b.Monitor.HWUnits      = 'Ampere';
AO.qf01b.Monitor.PhysicsUnits = 'meter^-2';
AO.qf01b.Setpoint.MemberOf      = {'MachineConfig'};
AO.qf01b.Setpoint.Mode          = 'Simulator';
AO.qf01b.Setpoint.DataType      = 'Scalar';
AO.qf01b.Setpoint.ChannelNames = getname(AO.qf01b.FamilyName, 'Setpoint', AO.qf01b.DeviceList);
AO.qf01b.Setpoint.Units         = 'Hardware';
AO.qf01b.Setpoint.HWUnits       = 'Ampere';
AO.qf01b.Setpoint.PhysicsUnits  = 'meter^-2';
AO.qf01b.Setpoint.Range         = [0 225];
AO.qf01b.Setpoint.Tolerance     = 0.2;
AO.qf01b.Setpoint.DeltaRespMat  = 0.5; 


AO.qd02.FamilyName  = 'qd02';
AO.qd02.MemberOf    = {'PlotFamily'; 'qd02'; 'QUAD'; 'Magnet';};
AO.qd02.DeviceList  = getDeviceList(1,1);
AO.qd02.ElementList = (1:size(AO.qd02.DeviceList,1))';
AO.qd02.Status      = ones(size(AO.qd02.DeviceList,1),1);
AO.qd02.Position    = [];
AO.qd02.Monitor.MemberOf = {};
AO.qd02.Monitor.Mode = 'Simulator';
AO.qd02.Monitor.DataType = 'Scalar';
AO.qd02.Monitor.Units        = 'Hardware';
AO.qd02.Monitor.HWUnits      = 'Ampere';
AO.qd02.Monitor.PhysicsUnits = 'meter^-2';
AO.qd02.Setpoint.MemberOf      = {'MachineConfig'};
AO.qd02.Setpoint.Mode          = 'Simulator';
AO.qd02.Setpoint.DataType      = 'Scalar';
AO.qd02.Setpoint.ChannelNames = getname(AO.qd02.FamilyName, 'Setpoint', AO.qd02.DeviceList);
AO.qd02.Setpoint.Units         = 'Hardware';
AO.qd02.Setpoint.HWUnits       = 'Ampere';
AO.qd02.Setpoint.PhysicsUnits  = 'meter^-2';
AO.qd02.Setpoint.Range         = [0 225];
AO.qd02.Setpoint.Tolerance     = 0.2;
AO.qd02.Setpoint.DeltaRespMat  = 0.5; 


AO.qf02.FamilyName  = 'qf02';
AO.qf02.MemberOf    = {'PlotFamily'; 'qf02'; 'QUAD'; 'Magnet';};
AO.qf02.DeviceList  = getDeviceList(1,1);
AO.qf02.ElementList = (1:size(AO.qf02.DeviceList,1))';
AO.qf02.Status      = ones(size(AO.qf02.DeviceList,1),1);
AO.qf02.Position    = [];
AO.qf02.Monitor.MemberOf = {};
AO.qf02.Monitor.Mode = 'Simulator';
AO.qf02.Monitor.DataType = 'Scalar';
AO.qf02.Monitor.Units        = 'Hardware';
AO.qf02.Monitor.HWUnits      = 'Ampere';
AO.qf02.Monitor.PhysicsUnits = 'meter^-2';
AO.qf02.Setpoint.MemberOf      = {'MachineConfig'};
AO.qf02.Setpoint.Mode          = 'Simulator';
AO.qf02.Setpoint.DataType      = 'Scalar';
AO.qf02.Setpoint.ChannelNames = getname(AO.qf02.FamilyName, 'Setpoint', AO.qf02.DeviceList);
AO.qf02.Setpoint.Units         = 'Hardware';
AO.qf02.Setpoint.HWUnits       = 'Ampere';
AO.qf02.Setpoint.PhysicsUnits  = 'meter^-2';
AO.qf02.Setpoint.Range         = [0 225];
AO.qf02.Setpoint.Tolerance     = 0.2;
AO.qf02.Setpoint.DeltaRespMat  = 0.5; 

AO.qd03.FamilyName  = 'qd03';
AO.qd03.MemberOf    = {'PlotFamily'; 'qd03'; 'QUAD'; 'Magnet';};
AO.qd03.DeviceList  = getDeviceList(1,1);
AO.qd03.ElementList = (1:size(AO.qd03.DeviceList,1))';
AO.qd03.Status      = ones(size(AO.qd03.DeviceList,1),1);
AO.qd03.Position    = [];
AO.qd03.Monitor.MemberOf = {};
AO.qd03.Monitor.Mode = 'Simulator';
AO.qd03.Monitor.DataType = 'Scalar';
AO.qd03.Monitor.Units        = 'Hardware';
AO.qd03.Monitor.HWUnits      = 'Ampere';
AO.qd03.Monitor.PhysicsUnits = 'meter^-2';
AO.qd03.Setpoint.MemberOf      = {'MachineConfig'};
AO.qd03.Setpoint.Mode          = 'Simulator';
AO.qd03.Setpoint.DataType      = 'Scalar';
AO.qd03.Setpoint.ChannelNames = getname(AO.qd03.FamilyName, 'Setpoint', AO.qd03.DeviceList);
AO.qd03.Setpoint.Units         = 'Hardware';
AO.qd03.Setpoint.HWUnits       = 'Ampere';
AO.qd03.Setpoint.PhysicsUnits  = 'meter^-2';
AO.qd03.Setpoint.Range         = [0 225];
AO.qd03.Setpoint.Tolerance     = 0.2;
AO.qd03.Setpoint.DeltaRespMat  = 0.5; 


AO.qf03.FamilyName  = 'qf03';
AO.qf03.MemberOf    = {'PlotFamily'; 'qf03'; 'QUAD'; 'Magnet';};
AO.qf03.DeviceList  = getDeviceList(1,1);
AO.qf03.ElementList = (1:size(AO.qf03.DeviceList,1))';
AO.qf03.Status      = ones(size(AO.qf03.DeviceList,1),1);
AO.qf03.Position    = [];
AO.qf03.Monitor.MemberOf = {};
AO.qf03.Monitor.Mode = 'Simulator';
AO.qf03.Monitor.DataType = 'Scalar';
AO.qf03.Monitor.Units        = 'Hardware';
AO.qf03.Monitor.HWUnits      = 'Ampere';
AO.qf03.Monitor.PhysicsUnits = 'meter^-2';
AO.qf03.Setpoint.MemberOf      = {'MachineConfig'};
AO.qf03.Setpoint.Mode          = 'Simulator';
AO.qf03.Setpoint.DataType      = 'Scalar';
AO.qf03.Setpoint.ChannelNames = getname(AO.qf03.FamilyName, 'Setpoint', AO.qf03.DeviceList);
AO.qf03.Setpoint.Units         = 'Hardware';
AO.qf03.Setpoint.HWUnits       = 'Ampere';
AO.qf03.Setpoint.PhysicsUnits  = 'meter^-2';
AO.qf03.Setpoint.Range         = [0 225];
AO.qf03.Setpoint.Tolerance     = 0.2;
AO.qf03.Setpoint.DeltaRespMat  = 0.5; 


AO.qd04a.FamilyName  = 'qd04a';
AO.qd04a.MemberOf    = {'PlotFamily'; 'qd04a'; 'QUAD'; 'Magnet';};
AO.qd04a.DeviceList  = getDeviceList(1,1);
AO.qd04a.ElementList = (1:size(AO.qd04a.DeviceList,1))';
AO.qd04a.Status      = ones(size(AO.qd04a.DeviceList,1),1);
AO.qd04a.Position    = [];
AO.qd04a.Monitor.MemberOf = {};
AO.qd04a.Monitor.Mode = 'Simulator';
AO.qd04a.Monitor.DataType = 'Scalar';
AO.qd04a.Monitor.Units        = 'Hardware';
AO.qd04a.Monitor.HWUnits      = 'Ampere';
AO.qd04a.Monitor.PhysicsUnits = 'meter^-2';
AO.qd04a.Setpoint.MemberOf      = {'MachineConfig'};
AO.qd04a.Setpoint.Mode          = 'Simulator';
AO.qd04a.Setpoint.DataType      = 'Scalar';
AO.qd04a.Setpoint.ChannelNames = getname(AO.qd04a.FamilyName, 'Setpoint', AO.qd04a.DeviceList);
AO.qd04a.Setpoint.Units         = 'Hardware';
AO.qd04a.Setpoint.HWUnits       = 'Ampere';
AO.qd04a.Setpoint.PhysicsUnits  = 'meter^-2';
AO.qd04a.Setpoint.Range         = [0 225];
AO.qd04a.Setpoint.Tolerance     = 0.2;
AO.qd04a.Setpoint.DeltaRespMat  = 0.5; 


AO.qf04.FamilyName  = 'qf04';
AO.qf04.MemberOf    = {'PlotFamily'; 'qf04'; 'QUAD'; 'Magnet';};
AO.qf04.DeviceList  = getDeviceList(1,1);
AO.qf04.ElementList = (1:size(AO.qf04.DeviceList,1))';
AO.qf04.Status      = ones(size(AO.qf04.DeviceList,1),1);
AO.qf04.Position    = [];
AO.qf04.Monitor.MemberOf = {};
AO.qf04.Monitor.Mode = 'Simulator';
AO.qf04.Monitor.DataType = 'Scalar';
AO.qf04.Monitor.Units        = 'Hardware';
AO.qf04.Monitor.HWUnits      = 'Ampere';
AO.qf04.Monitor.PhysicsUnits = 'meter^-2';
AO.qf04.Setpoint.MemberOf      = {'MachineConfig'};
AO.qf04.Setpoint.Mode          = 'Simulator';
AO.qf04.Setpoint.DataType      = 'Scalar';
AO.qf04.Setpoint.ChannelNames = getname(AO.qf04.FamilyName, 'Setpoint', AO.qf04.DeviceList);
AO.qf04.Setpoint.Units         = 'Hardware';
AO.qf04.Setpoint.HWUnits       = 'Ampere';
AO.qf04.Setpoint.PhysicsUnits  = 'meter^-2';
AO.qf04.Setpoint.Range         = [0 225];
AO.qf04.Setpoint.Tolerance     = 0.2;
AO.qf04.Setpoint.DeltaRespMat  = 0.5; 

AO.qd04b.FamilyName  = 'qd04b';
AO.qd04b.MemberOf    = {'PlotFamily'; 'qd04b'; 'QUAD'; 'Magnet';};
AO.qd04b.DeviceList  = getDeviceList(1,1);
AO.qd04b.ElementList = (1:size(AO.qd04b.DeviceList,1))';
AO.qd04b.Status      = ones(size(AO.qd04b.DeviceList,1),1);
AO.qd04b.Position    = [];
AO.qd04b.Monitor.MemberOf = {};
AO.qd04b.Monitor.Mode = 'Simulator';
AO.qd04b.Monitor.DataType = 'Scalar';
AO.qd04b.Monitor.Units        = 'Hardware';
AO.qd04b.Monitor.HWUnits      = 'Ampere';
AO.qd04b.Monitor.PhysicsUnits = 'meter^-2';
AO.qd04b.Setpoint.MemberOf      = {'MachineConfig'};
AO.qd04b.Setpoint.Mode          = 'Simulator';
AO.qd04b.Setpoint.DataType      = 'Scalar';
AO.qd04b.Setpoint.ChannelNames = getname(AO.qd04b.FamilyName, 'Setpoint', AO.qd04b.DeviceList);
AO.qd04b.Setpoint.Units         = 'Hardware';
AO.qd04b.Setpoint.HWUnits       = 'Ampere';
AO.qd04b.Setpoint.PhysicsUnits  = 'meter^-2';
AO.qd04b.Setpoint.Range         = [0 225];
AO.qd04b.Setpoint.Tolerance     = 0.2;
AO.qd04b.Setpoint.DeltaRespMat  = 0.5;  


%%%%%%%%%%%%%%%%%%%%%
% Corrector Magnets %
%%%%%%%%%%%%%%%%%%%%%

% hcm
AO.hcm.FamilyName  = 'hcm';
AO.hcm.MemberOf    = {'PlotFamily'; 'COR'; 'hcm'; 'Magnet'};
AO.hcm.DeviceList  = getDeviceList(1,5);
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
