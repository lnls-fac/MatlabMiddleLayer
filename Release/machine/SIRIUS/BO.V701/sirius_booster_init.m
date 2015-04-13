function sirius_booster_init(OperationalMode)




if nargin < 1
    OperationalMode = 1;
end

setao([]);
setad([]);



% Base on the location of this file
[SIRIUS_ROOT, FileName, ExtentionName] = fileparts(mfilename('fullpath'));
AD.Directory.ExcDataDir = [SIRIUS_ROOT, filesep, 'excitation_curves'];
AD.Directory.LatticesDef = [SIRIUS_ROOT, filesep, 'lattices_def'];
setad(AD);


% Get the device lists (local function)
%[OnePerSector, TwoPerSector, ThreePerSector, FourPerSector, FivePerSector, SixPerSector, EightPerSector, TenPerSector, TwelvePerSector, FifteenPerSector, SixteenPerSector, EighteenPerSector, TwentyFourPerSector] = buildthedevicelists;


% BENDS

AO.B.FamilyName  = 'B';
AO.B.MemberOf    = {'PlotFamily'; 'B'; 'BEND'; 'Magnet';};
AO.B.DeviceList  = getDeviceList(2,25);
AO.B.ElementList = (1:size(AO.B.DeviceList,1))';
AO.B.Status      = ones(size(AO.B.DeviceList,1),1);
AO.B.Position    = [];

AO.B.Monitor.MemberOf = {};
AO.B.Monitor.Mode = 'Simulator';
AO.B.Monitor.DataType = 'Scalar';
AO.B.Monitor.ChannelNames = sirius_booster_getname(AO.B.FamilyName, 'Monitor', AO.B.DeviceList);
AO.B.Monitor.HW2PhysicsParams = 1;
AO.B.Monitor.Physics2HWParams = 1;
AO.B.Monitor.Units        = 'Hardware';
AO.B.Monitor.HWUnits      = 'Ampere';
AO.B.Monitor.PhysicsUnits = 'GeV';

AO.B.Setpoint.MemberOf = {'MachineConfig';};
AO.B.Setpoint.Mode = 'Simulator';
AO.B.Setpoint.DataType = 'Scalar';
AO.B.Setpoint.ChannelNames = sirius_booster_getname(AO.B.FamilyName, 'Setpoint', AO.B.DeviceList);
AO.B.Setpoint.HW2PhysicsParams = 1;
AO.B.Setpoint.Physics2HWParams = 1;
AO.B.Setpoint.Units        = 'Hardware';
AO.B.Setpoint.HWUnits      = 'Ampere';
AO.B.Setpoint.PhysicsUnits = 'GeV';
AO.B.Setpoint.Range        = [0 300];
AO.B.Setpoint.Tolerance    = .1;
AO.B.Setpoint.DeltaRespMat = .01;

% QUADS
AO.QD.FamilyName = 'QD';
AO.QD.MemberOf    = {'PlotFamily'; 'QD'; 'QUAD'; 'Magnet';};
AO.QD.DeviceList  = getDeviceList(2,2);
AO.QD.ElementList = (1:size(AO.QD.DeviceList,1))';
AO.QD.Status      = ones(size(AO.QD.DeviceList,1),1);
AO.QD.Position    = [];
AO.QD.Monitor.MemberOf = {};
AO.QD.Monitor.Mode = 'Simulator';
AO.QD.Monitor.DataType = 'Scalar';
AO.QD.Monitor.Units        = 'Hardware';
AO.QD.Monitor.HWUnits      = 'Ampere';
AO.QD.Monitor.PhysicsUnits = 'meter^-2';
AO.QD.Setpoint.MemberOf      = {'MachineConfig'};
AO.QD.Setpoint.Mode          = 'Simulator';
AO.QD.Setpoint.DataType      = 'Scalar';
AO.QD.Setpoint.Units         = 'Hardware';
AO.QD.Setpoint.HWUnits       = 'Ampere';
AO.QD.Setpoint.PhysicsUnits  = 'meter^-2';
AO.QD.Setpoint.Range         = [0 225];
AO.QD.Setpoint.Tolerance     = 0.2;
AO.QD.Setpoint.DeltaRespMat  = 0.5; 

AO.QF.FamilyName = 'QF';
AO.QF.MemberOf    = {'PlotFamily'; 'QF'; 'QUAD'; 'Magnet';};
AO.QF.DeviceList  = getDeviceList(2,10);
AO.QF.ElementList = (1:size(AO.QF.DeviceList,1))';
AO.QF.Status      = ones(size(AO.QF.DeviceList,1),1);
AO.QF.Position    = [];
AO.QF.Monitor.MemberOf = {};
AO.QF.Monitor.Mode = 'Simulator';
AO.QF.Monitor.DataType = 'Scalar';
AO.QF.Monitor.Units        = 'Hardware';
AO.QF.Monitor.HWUnits      = 'Ampere';
AO.QF.Monitor.PhysicsUnits = 'meter^-2';
AO.QF.Setpoint.MemberOf      = {'MachineConfig'};
AO.QF.Setpoint.Mode          = 'Simulator';
AO.QF.Setpoint.DataType      = 'Scalar';
AO.QF.Setpoint.Units         = 'Hardware';
AO.QF.Setpoint.HWUnits       = 'Ampere';
AO.QF.Setpoint.PhysicsUnits  = 'meter^-2';
AO.QF.Setpoint.Range         = [0 225];
AO.QF.Setpoint.Tolerance     = 0.2;
AO.QF.Setpoint.DeltaRespMat  = 0.5; 

%SEXT
AO.SD.FamilyName = 'SD';
AO.SD.MemberOf    = {'PlotFamily'; 'SD'; 'SEXT'; 'Magnet'};
AO.SD.DeviceList  = getDeviceList(2,2);
AO.SD.ElementList = (1:size(AO.SD.DeviceList,1))';
AO.SD.Status      = ones(size(AO.SD.DeviceList,1),1);
AO.SD.Position    = [];
AO.SD.Monitor.MemberOf = {};
AO.SD.Monitor.Mode = 'Simulator';
AO.SD.Monitor.DataType = 'Scalar';
AO.SD.Monitor.Units        = 'Hardware';
AO.SD.Monitor.HWUnits      = 'Ampere';
AO.SD.Monitor.PhysicsUnits = 'meter^-3';
AO.SD.Setpoint.MemberOf      = {'MachineConfig'};
AO.SD.Setpoint.Mode          = 'Simulator';
AO.SD.Setpoint.DataType      = 'Scalar';
AO.SD.Setpoint.Units         = 'Hardware';
AO.SD.Setpoint.HWUnits       = 'Ampere';
AO.SD.Setpoint.PhysicsUnits  = 'meter^-3';
AO.SD.Setpoint.Range         = [0 225];
AO.SD.Setpoint.Tolerance     = 0.2;
AO.SD.Setpoint.DeltaRespMat  = 0.5; 

AO.SF.FamilyName = 'SF';
AO.SF.MemberOf    = {'PlotFamily'; 'SF'; 'SEXT'; 'Magnet'};
AO.SF.DeviceList  = getDeviceList(2,2);
AO.SF.ElementList = (1:size(AO.SF.DeviceList,1))';
AO.SF.Status      = ones(size(AO.SF.DeviceList,1),1);
AO.SF.Position    = [];
AO.SF.Monitor.MemberOf = {};
AO.SF.Monitor.Mode = 'Simulator';
AO.SF.Monitor.DataType = 'Scalar';
AO.SF.Monitor.Units        = 'Hardware';
AO.SF.Monitor.HWUnits      = 'Ampere';
AO.SF.Monitor.PhysicsUnits = 'meter^-3';
AO.SF.Setpoint.MemberOf      = {'MachineConfig'};
AO.SF.Setpoint.Mode          = 'Simulator';
AO.SF.Setpoint.DataType      = 'Scalar';
AO.SF.Setpoint.Units         = 'Hardware';
AO.SF.Setpoint.HWUnits       = 'Ampere';
AO.SF.Setpoint.PhysicsUnits  = 'meter^-3';
AO.SF.Setpoint.Range         = [0 225];
AO.SF.Setpoint.Tolerance     = 0.2;
AO.SF.Setpoint.DeltaRespMat  = 0.5; 

% HCM
AO.HCM.FamilyName  = 'HCM';
AO.HCM.MemberOf    = {'PlotFamily'; 'COR'; 'HCM'; 'Magnet'};
AO.HCM.DeviceList  = getDeviceList(5,5);
AO.HCM.ElementList = (1:size(AO.HCM.DeviceList,1))';
AO.HCM.Status      = ones(size(AO.HCM.DeviceList,1),1);
AO.HCM.Position    = [];

AO.HCM.Monitor.MemberOf = {'Horizontal'; 'COR'; 'HCM'; 'Magnet';};
AO.HCM.Monitor.Mode = 'Simulator';
AO.HCM.Monitor.DataType = 'Scalar';
AO.HCM.Monitor.Units        = 'Physics';
AO.HCM.Monitor.HWUnits      = 'Ampere';
AO.HCM.Monitor.PhysicsUnits = 'Radian';

AO.HCM.Setpoint.MemberOf = {'MachineConfig'; 'Horizontal'; 'COR'; 'HCM'; 'Magnet'; 'Setpoint'; 'measbpmresp';};
AO.HCM.Setpoint.Mode = 'Simulator';
AO.HCM.Setpoint.DataType = 'Scalar';
AO.HCM.Setpoint.Units        = 'Physics';
AO.HCM.Setpoint.HWUnits      = 'Ampere';
AO.HCM.Setpoint.PhysicsUnits = 'Radian';
AO.HCM.Setpoint.Range        = [-10 10];
AO.HCM.Setpoint.Tolerance    = 0.00001;
AO.HCM.Setpoint.DeltaRespMat = 0.0005; 


% VCM
AO.VCM.FamilyName  = 'VCM';
AO.VCM.MemberOf    = {'PlotFamily'; 'COR'; 'VCM'; 'Magnet'};
AO.VCM.DeviceList  = getDeviceList(5,5);
AO.VCM.ElementList = (1:size(AO.VCM.DeviceList,1))';
AO.VCM.Status      = ones(size(AO.VCM.DeviceList,1),1);
AO.VCM.Position    = [];

AO.VCM.Monitor.MemberOf = {'Vertical'; 'COR'; 'VCM'; 'Magnet';};
AO.VCM.Monitor.Mode = 'Simulator';
AO.VCM.Monitor.DataType = 'Scalar';
AO.VCM.Monitor.Units        = 'Physics';
AO.VCM.Monitor.HWUnits      = 'Ampere';
AO.VCM.Monitor.PhysicsUnits = 'Radian';

AO.VCM.Setpoint.MemberOf = {'MachineConfig'; 'Vertical'; 'COR'; 'VCM'; 'Magnet'; 'Setpoint'; 'measbpmresp';};
AO.VCM.Setpoint.Mode = 'Simulator';
AO.VCM.Setpoint.DataType = 'Scalar';
AO.VCM.Setpoint.Units        = 'Physics';
AO.VCM.Setpoint.HWUnits      = 'Ampere';
AO.VCM.Setpoint.PhysicsUnits = 'Radian';
AO.VCM.Setpoint.Range        = [-10 10];
AO.VCM.Setpoint.Tolerance    = 0.00001;
AO.VCM.Setpoint.DeltaRespMat = 0.0005; 

% BPMx
AO.BPMx.FamilyName  = 'BPMx';
AO.BPMx.MemberOf    = {'PlotFamily'; 'BPM'; 'BPMx'; 'Diagnostics'};
AO.BPMx.DeviceList  = getDeviceList(2,25);
AO.BPMx.ElementList = (1:size(AO.BPMx.DeviceList,1))';
AO.BPMx.Status      = ones(size(AO.BPMx.DeviceList,1),1);
AO.BPMx.Position    = [];
AO.BPMx.Golden      = zeros(length(AO.BPMx.ElementList),1);
AO.BPMx.Offset      = zeros(length(AO.BPMx.ElementList),1);

AO.BPMx.Monitor.MemberOf = {'BPMx'; 'Monitor';};
AO.BPMx.Monitor.Mode = 'Simulator';
AO.BPMx.Monitor.DataType = 'Scalar';
AO.BPMx.Monitor.HW2PhysicsParams = 1e-3;  % HW [mm], Simulator [Meters]
AO.BPMx.Monitor.Physics2HWParams = 1000;
AO.BPMx.Monitor.Units        = 'Hardware';
AO.BPMx.Monitor.HWUnits      = 'mm';
AO.BPMx.Monitor.PhysicsUnits = 'meter';

% BPMy
AO.BPMy.FamilyName  = 'BPMy';
AO.BPMy.MemberOf    = {'PlotFamily'; 'BPM'; 'BPMy'; 'Diagnostics'};
AO.BPMy.DeviceList  = getDeviceList(2,25);
AO.BPMy.ElementList = (1:size(AO.BPMy.DeviceList,1))';
AO.BPMy.Status      = ones(size(AO.BPMy.DeviceList,1),1);
AO.BPMy.Position    = [];
AO.BPMy.Golden      = zeros(length(AO.BPMy.ElementList),1);
AO.BPMy.Offset      = zeros(length(AO.BPMy.ElementList),1);


AO.BPMy.Monitor.MemberOf = {'BPMy'; 'Monitor';};
AO.BPMy.Monitor.Mode = 'Simulator';
AO.BPMy.Monitor.DataType = 'Scalar';
AO.BPMy.Monitor.HW2PhysicsParams = 1e-3;  % HW [mm], Simulator [Meters]
AO.BPMy.Monitor.Physics2HWParams = 1000;
AO.BPMy.Monitor.Units        = 'Hardware';
AO.BPMy.Monitor.HWUnits      = 'mm';
AO.BPMy.Monitor.PhysicsUnits = 'meter';



%%%%%%%%
% Tune %
%%%%%%%%
AO.TUNE.FamilyName = 'TUNE';
AO.TUNE.MemberOf = {'TUNE';};
AO.TUNE.DeviceList = [1 1;1 2;1 3];
AO.TUNE.ElementList = [1;2;3];
AO.TUNE.Status = [1; 1; 0];
AO.TUNE.CommonNames = ['TuneX'; 'TuneY'; 'TuneS'];

AO.TUNE.Monitor.MemberOf   = {'TUNE'};
AO.TUNE.Monitor.Mode = 'Simulator'; 
AO.TUNE.Monitor.DataType = 'Scalar';
AO.TUNE.Monitor.HW2PhysicsParams = 1;
AO.TUNE.Monitor.Physics2HWParams = 1;
AO.TUNE.Monitor.Units        = 'Hardware';
AO.TUNE.Monitor.HWUnits      = 'kHz';
AO.TUNE.Monitor.PhysicsUnits = 'Tune';
AO.TUNE.Monitor.SpecialFunctionGet = @bfreq2tune;


%%%%%%%%%%
%   RF   %
%%%%%%%%%%
AO.RF.FamilyName                = 'RF';
AO.RF.MemberOf                  = {'RF'; 'RFSystem'};
AO.RF.DeviceList                = [ 1 1 ];
AO.RF.ElementList               = 1;
AO.RF.Status                    = 1;
AO.RF.Position                  = 0;

AO.RF.Monitor.MemberOf          = {};
AO.RF.Monitor.Mode              = 'Simulator';
AO.RF.Monitor.DataType          = 'Scalar';
AO.RF.Monitor.HW2PhysicsParams  = 1e+6;
AO.RF.Monitor.Physics2HWParams  = 1e-6;
AO.RF.Monitor.Units             = 'Hardware';
AO.RF.Monitor.HWUnits           = 'MHz';
AO.RF.Monitor.PhysicsUnits      = 'Hz';

AO.RF.Setpoint.MemberOf         = {'MachineConfig';};
AO.RF.Setpoint.Mode             = 'Simulator';
AO.RF.Setpoint.DataType         = 'Scalar';
AO.RF.Setpoint.HW2PhysicsParams = 1e+6;
AO.RF.Setpoint.Physics2HWParams = 1e-6;
AO.RF.Setpoint.Units            = 'Hardware';
AO.RF.Setpoint.HWUnits          = 'MHz';
AO.RF.Setpoint.PhysicsUnits     = 'Hz';
AO.RF.Setpoint.Range            = [400.0 600.0];
AO.RF.Setpoint.Tolerance        = 1.0;

AO.RF.VoltageCtrl.MemberOf          = {};
AO.RF.VoltageCtrl.Mode              = 'Simulator';
AO.RF.VoltageCtrl.DataType          = 'Scalar';
AO.RF.VoltageCtrl.ChannelNames      = '';
AO.RF.VoltageCtrl.HW2PhysicsParams  = 1;
AO.RF.VoltageCtrl.Physics2HWParams  = 1;
AO.RF.VoltageCtrl.Units             = 'Hardware';
AO.RF.VoltageCtrl.HWUnits           = 'Volts';
AO.RF.VoltageCtrl.PhysicsUnits      = 'Volts';

AO.RF.Voltage.MemberOf          = {};
AO.RF.Voltage.Mode              = 'Simulator';
AO.RF.Voltage.DataType          = 'Scalar';
AO.RF.Voltage.ChannelNames      = '';
AO.RF.Voltage.HW2PhysicsParams  = 1;
AO.RF.Voltage.Physics2HWParams  = 1;
AO.RF.Voltage.Units             = 'Hardware';
AO.RF.Voltage.HWUnits           = 'Volts';
AO.RF.Voltage.PhysicsUnits      = 'Volts';

AO.RF.Power.MemberOf          = {};
AO.RF.Power.Mode              = 'Simulator';
AO.RF.Power.DataType          = 'Scalar';
AO.RF.Power.ChannelNames      = '';          % ???
AO.RF.Power.HW2PhysicsParams  = 1;         
AO.RF.Power.Physics2HWParams  = 1;
AO.RF.Power.Units             = 'Hardware';
AO.RF.Power.HWUnits           = 'MWatts';           
AO.RF.Power.PhysicsUnits      = 'MWatts';
AO.RF.Power.Range             = [-inf inf];  % ???  
AO.RF.Power.Tolerance         = inf;  % ???  

AO.RF.Phase.MemberOf          = {'RF'; 'Phase'};
AO.RF.Phase.Mode              = 'Simulator';
AO.RF.Phase.DataType          = 'Scalar';
AO.RF.Phase.ChannelNames      = 'SRF1:STN:PHASE:CALC';    % ???  
AO.RF.Phase.Units             = 'Hardware';
AO.RF.Phase.HW2PhysicsParams  = 1; 
AO.RF.Phase.Physics2HWParams  = 1;
AO.RF.Phase.HWUnits           = 'Degrees';  
AO.RF.Phase.PhysicsUnits      = 'Degrees';

AO.RF.PhaseCtrl.MemberOf      = {'RF; Phase'; 'Control'};  % 'MachineConfig';
AO.RF.PhaseCtrl.Mode              = 'Simulator';
AO.RF.PhaseCtrl.DataType          = 'Scalar';
AO.RF.PhaseCtrl.ChannelNames      = 'SRF1:STN:PHASE';    % ???     
AO.RF.PhaseCtrl.Units             = 'Hardware';
AO.RF.PhaseCtrl.HW2PhysicsParams  = 1;         
AO.RF.PhaseCtrl.Physics2HWParams  = 1;
AO.RF.PhaseCtrl.HWUnits           = 'Degrees';  
AO.RF.PhaseCtrl.PhysicsUnits      = 'Degrees'; 
AO.RF.PhaseCtrl.Range             = [-200 200];    % ??? 
AO.RF.PhaseCtrl.Tolerance         = 10;    % ??? 



%%%%%%%%%%%%%%
%    DCCT    %
%%%%%%%%%%%%%%
AO.DCCT.FamilyName               = 'DCCT';
AO.DCCT.MemberOf                 = {'Diagnostics'; 'DCCT'};
AO.DCCT.DeviceList               = [1 1];
AO.DCCT.ElementList              = 1;
AO.DCCT.Status                   = 1;
AO.DCCT.Position                 = 23.2555;

AO.DCCT.Monitor.MemberOf         = {};
AO.DCCT.Monitor.Mode             = 'Simulator';
AO.DCCT.Monitor.DataType         = 'Scalar';
AO.DCCT.Monitor.ChannelNames     = 'AMC03';    
AO.DCCT.Monitor.HW2PhysicsParams = 1;    
AO.DCCT.Monitor.Physics2HWParams = 1;
AO.DCCT.Monitor.Units            = 'Hardware';
AO.DCCT.Monitor.HWUnits          = 'Ampere';     
AO.DCCT.Monitor.PhysicsUnits     = 'Ampere';






% The operational mode sets the path, filenames, and other important parameters
% Run setoperationalmode after most of the AO is built so that the Units and Mode fields
% can be set in setoperationalmode
setao(AO);
% setoperationalmode(OperationalMode);





% Convert the response matrix delta to hardware units (if it's not already)
% 'NoEnergyScaling' is needed so that the QMF is not read to get the energy (this is a setup file)  

%AO = getao;
%AO.HCM.Setpoint.DeltaRespMat  = physics2hw('HCM', 'Setpoint', AO.HCM.Setpoint.DeltaRespMat, AO.HCM.DeviceList, 'NoEnergyScaling');
%AO.VCM.Setpoint.DeltaRespMat  = physics2hw('VCM', 'Setpoint', AO.VCM.Setpoint.DeltaRespMat, AO.VCM.DeviceList, 'NoEnergyScaling');
%AO.QF.Setpoint.DeltaRespMat   = physics2hw('QF',  'Setpoint', AO.QF.Setpoint.DeltaRespMat,  AO.QF.DeviceList,  'NoEnergyScaling');
%AO.QD.Setpoint.DeltaRespMat   = physics2hw('QD',  'Setpoint', AO.QD.Setpoint.DeltaRespMat,  AO.QD.DeviceList,  'NoEnergyScaling');
%AO.QFC.Setpoint.DeltaRespMat  = physics2hw('QFC', 'Setpoint', AO.QFC.Setpoint.DeltaRespMat, AO.QFC.DeviceList, 'NoEnergyScaling');
%AO.SF.Setpoint.DeltaRespMat   = physics2hw('SF',  'Setpoint', AO.SF.Setpoint.DeltaRespMat,  AO.SF.DeviceList,  'NoEnergyScaling');
%AO.SD.Setpoint.DeltaRespMat   = physics2hw('SD',  'Setpoint', AO.SD.Setpoint.DeltaRespMat,  AO.SD.DeviceList,  'NoEnergyScaling');
%setao(AO);

%sirius_comm_connect_inputdlg;
 
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

