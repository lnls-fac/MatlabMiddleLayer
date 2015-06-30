function ltba_init(OperationalMode)
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


AO.qa1.FamilyName  = 'qa1';
AO.qa1.MemberOf    = {'PlotFamily'; 'qa1'; 'QUAD'; 'Magnet';};
AO.qa1.DeviceList  = getDeviceList(1,1);
AO.qa1.ElementList = (1:size(AO.qa1.DeviceList,1))';
AO.qa1.Status      = ones(size(AO.qa1.DeviceList,1),1);
AO.qa1.Position    = [];
AO.qa1.Monitor.MemberOf = {};
AO.qa1.Monitor.Mode = 'Simulator';
AO.qa1.Monitor.DataType = 'Scalar';
AO.qa1.Monitor.Units        = 'Hardware';
AO.qa1.Monitor.HWUnits      = 'Ampere';
AO.qa1.Monitor.PhysicsUnits = 'meter^-2';
AO.qa1.Setpoint.MemberOf      = {'MachineConfig'};
AO.qa1.Setpoint.Mode          = 'Simulator';
AO.qa1.Setpoint.DataType      = 'Scalar';
AO.qa1.Setpoint.ChannelNames = getname(AO.qa1.FamilyName, 'Setpoint', AO.qa1.DeviceList);
AO.qa1.Setpoint.Units         = 'Hardware';
AO.qa1.Setpoint.HWUnits       = 'Ampere';
AO.qa1.Setpoint.PhysicsUnits  = 'meter^-2';
AO.qa1.Setpoint.Range         = [0 225];
AO.qa1.Setpoint.Tolerance     = 0.2;
AO.qa1.Setpoint.DeltaRespMat  = 0.5; 


AO.qa2.FamilyName  = 'qa2';
AO.qa2.MemberOf    = {'PlotFamily'; 'qa2'; 'QUAD'; 'Magnet';};
AO.qa2.DeviceList  = getDeviceList(1,1);
AO.qa2.ElementList = (1:size(AO.qa2.DeviceList,1))';
AO.qa2.Status      = ones(size(AO.qa2.DeviceList,1),1);
AO.qa2.Position    = [];
AO.qa2.Monitor.MemberOf = {};
AO.qa2.Monitor.Mode = 'Simulator';
AO.qa2.Monitor.DataType = 'Scalar';
AO.qa2.Monitor.Units        = 'Hardware';
AO.qa2.Monitor.HWUnits      = 'Ampere';
AO.qa2.Monitor.PhysicsUnits = 'meter^-2';
AO.qa2.Setpoint.MemberOf      = {'MachineConfig'};
AO.qa2.Setpoint.Mode          = 'Simulator';
AO.qa2.Setpoint.DataType      = 'Scalar';
AO.qa2.Setpoint.ChannelNames = getname(AO.qa2.FamilyName, 'Setpoint', AO.qa2.DeviceList);
AO.qa2.Setpoint.Units         = 'Hardware';
AO.qa2.Setpoint.HWUnits       = 'Ampere';
AO.qa2.Setpoint.PhysicsUnits  = 'meter^-2';
AO.qa2.Setpoint.Range         = [0 225];
AO.qa2.Setpoint.Tolerance     = 0.2;
AO.qa2.Setpoint.DeltaRespMat  = 0.5; 


AO.qb1.FamilyName  = 'qb1';
AO.qb1.MemberOf    = {'PlotFamily'; 'qb1'; 'QUAD'; 'Magnet';};
AO.qb1.DeviceList  = getDeviceList(1,1);
AO.qb1.ElementList = (1:size(AO.qb1.DeviceList,1))';
AO.qb1.Status      = ones(size(AO.qb1.DeviceList,1),1);
AO.qb1.Position    = [];
AO.qb1.Monitor.MemberOf = {};
AO.qb1.Monitor.Mode = 'Simulator';
AO.qb1.Monitor.DataType = 'Scalar';
AO.qb1.Monitor.Units        = 'Hardware';
AO.qb1.Monitor.HWUnits      = 'Ampere';
AO.qb1.Monitor.PhysicsUnits = 'meter^-2';
AO.qb1.Setpoint.MemberOf      = {'MachineConfig'};
AO.qb1.Setpoint.Mode          = 'Simulator';
AO.qb1.Setpoint.DataType      = 'Scalar';
AO.qb1.Setpoint.ChannelNames = getname(AO.qb1.FamilyName, 'Setpoint', AO.qb1.DeviceList);
AO.qb1.Setpoint.Units         = 'Hardware';
AO.qb1.Setpoint.HWUnits       = 'Ampere';
AO.qb1.Setpoint.PhysicsUnits  = 'meter^-2';
AO.qb1.Setpoint.Range         = [0 225];
AO.qb1.Setpoint.Tolerance     = 0.2;
AO.qb1.Setpoint.DeltaRespMat  = 0.5; 


AO.qb2.FamilyName  = 'qb2';
AO.qb2.MemberOf    = {'PlotFamily'; 'qb2'; 'QUAD'; 'Magnet';};
AO.qb2.DeviceList  = getDeviceList(1,1);
AO.qb2.ElementList = (1:size(AO.qb2.DeviceList,1))';
AO.qb2.Status      = ones(size(AO.qb2.DeviceList,1),1);
AO.qb2.Position    = [];
AO.qb2.Monitor.MemberOf = {};
AO.qb2.Monitor.Mode = 'Simulator';
AO.qb2.Monitor.DataType = 'Scalar';
AO.qb2.Monitor.Units        = 'Hardware';
AO.qb2.Monitor.HWUnits      = 'Ampere';
AO.qb2.Monitor.PhysicsUnits = 'meter^-2';
AO.qb2.Setpoint.MemberOf      = {'MachineConfig'};
AO.qb2.Setpoint.Mode          = 'Simulator';
AO.qb2.Setpoint.DataType      = 'Scalar';
AO.qb2.Setpoint.ChannelNames = getname(AO.qb2.FamilyName, 'Setpoint', AO.qb2.DeviceList);
AO.qb2.Setpoint.Units         = 'Hardware';
AO.qb2.Setpoint.HWUnits       = 'Ampere';
AO.qb2.Setpoint.PhysicsUnits  = 'meter^-2';
AO.qb2.Setpoint.Range         = [0 225];
AO.qb2.Setpoint.Tolerance     = 0.2;
AO.qb2.Setpoint.DeltaRespMat  = 0.5; 

AO.qc1.FamilyName  = 'qc1';
AO.qc1.MemberOf    = {'PlotFamily'; 'qc1'; 'QUAD'; 'Magnet';};
AO.qc1.DeviceList  = getDeviceList(1,1);
AO.qc1.ElementList = (1:size(AO.qc1.DeviceList,1))';
AO.qc1.Status      = ones(size(AO.qc1.DeviceList,1),1);
AO.qc1.Position    = [];
AO.qc1.Monitor.MemberOf = {};
AO.qc1.Monitor.Mode = 'Simulator';
AO.qc1.Monitor.DataType = 'Scalar';
AO.qc1.Monitor.Units        = 'Hardware';
AO.qc1.Monitor.HWUnits      = 'Ampere';
AO.qc1.Monitor.PhysicsUnits = 'meter^-2';
AO.qc1.Setpoint.MemberOf      = {'MachineConfig'};
AO.qc1.Setpoint.Mode          = 'Simulator';
AO.qc1.Setpoint.DataType      = 'Scalar';
AO.qc1.Setpoint.ChannelNames = getname(AO.qc1.FamilyName, 'Setpoint', AO.qc1.DeviceList);
AO.qc1.Setpoint.Units         = 'Hardware';
AO.qc1.Setpoint.HWUnits       = 'Ampere';
AO.qc1.Setpoint.PhysicsUnits  = 'meter^-2';
AO.qc1.Setpoint.Range         = [0 225];
AO.qc1.Setpoint.Tolerance     = 0.2;
AO.qc1.Setpoint.DeltaRespMat  = 0.5; 


AO.qc2.FamilyName  = 'qc2';
AO.qc2.MemberOf    = {'PlotFamily'; 'qc2'; 'QUAD'; 'Magnet';};
AO.qc2.DeviceList  = getDeviceList(1,1);
AO.qc2.ElementList = (1:size(AO.qc2.DeviceList,1))';
AO.qc2.Status      = ones(size(AO.qc2.DeviceList,1),1);
AO.qc2.Position    = [];
AO.qc2.Monitor.MemberOf = {};
AO.qc2.Monitor.Mode = 'Simulator';
AO.qc2.Monitor.DataType = 'Scalar';
AO.qc2.Monitor.Units        = 'Hardware';
AO.qc2.Monitor.HWUnits      = 'Ampere';
AO.qc2.Monitor.PhysicsUnits = 'meter^-2';
AO.qc2.Setpoint.MemberOf      = {'MachineConfig'};
AO.qc2.Setpoint.Mode          = 'Simulator';
AO.qc2.Setpoint.DataType      = 'Scalar';
AO.qc2.Setpoint.ChannelNames = getname(AO.qc2.FamilyName, 'Setpoint', AO.qc2.DeviceList);
AO.qc2.Setpoint.Units         = 'Hardware';
AO.qc2.Setpoint.HWUnits       = 'Ampere';
AO.qc2.Setpoint.PhysicsUnits  = 'meter^-2';
AO.qc2.Setpoint.Range         = [0 225];
AO.qc2.Setpoint.Tolerance     = 0.2;
AO.qc2.Setpoint.DeltaRespMat  = 0.5; 


AO.qd1.FamilyName  = 'qd1';
AO.qd1.MemberOf    = {'PlotFamily'; 'qd1'; 'QUAD'; 'Magnet';};
AO.qd1.DeviceList  = getDeviceList(1,1);
AO.qd1.ElementList = (1:size(AO.qd1.DeviceList,1))';
AO.qd1.Status      = ones(size(AO.qd1.DeviceList,1),1);
AO.qd1.Position    = [];
AO.qd1.Monitor.MemberOf = {};
AO.qd1.Monitor.Mode = 'Simulator';
AO.qd1.Monitor.DataType = 'Scalar';
AO.qd1.Monitor.Units        = 'Hardware';
AO.qd1.Monitor.HWUnits      = 'Ampere';
AO.qd1.Monitor.PhysicsUnits = 'meter^-2';
AO.qd1.Setpoint.MemberOf      = {'MachineConfig'};
AO.qd1.Setpoint.Mode          = 'Simulator';
AO.qd1.Setpoint.DataType      = 'Scalar';
AO.qd1.Setpoint.ChannelNames = getname(AO.qd1.FamilyName, 'Setpoint', AO.qd1.DeviceList);
AO.qd1.Setpoint.Units         = 'Hardware';
AO.qd1.Setpoint.HWUnits       = 'Ampere';
AO.qd1.Setpoint.PhysicsUnits  = 'meter^-2';
AO.qd1.Setpoint.Range         = [0 225];
AO.qd1.Setpoint.Tolerance     = 0.2;
AO.qd1.Setpoint.DeltaRespMat  = 0.5; 


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
