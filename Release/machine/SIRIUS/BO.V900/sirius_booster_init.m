function sirius_booster_init(OperationalMode)

if nargin < 1
    OperationalMode = 1;
end

setao([]);
setad([]);



% Base on the location of this file
[SIRIUS_ROOT, ~, ~] = fileparts(mfilename('fullpath'));
AD.Directory.ExcDataDir = [SIRIUS_ROOT, filesep, 'excitation_curves'];
AD.Directory.LatticesDef = [SIRIUS_ROOT, filesep, 'lattices_def'];
setad(AD);

% Get the device lists (local function)
%[OnePerSector, TwoPerSector, ThreePerSector, FourPerSector, FivePerSector, SixPerSector, EightPerSector, TenPerSector, TwelvePerSector, FifteenPerSector, SixteenPerSector, EighteenPerSector, TwentyFourPerSector] = buildthedevicelists;

% BENDS

AO.b.FamilyName  = 'b';
AO.b.MemberOf    = {'PlotFamily'; 'b'; 'BEND'; 'Magnet';};
AO.b.DeviceList  = getDeviceList(5,10);
AO.b.ElementList = (1:size(AO.b.DeviceList,1))';
AO.b.Status      = ones(size(AO.b.DeviceList,1),1);
AO.b.Position    = [];

AO.b.Monitor.MemberOf = {};
AO.b.Monitor.Mode = 'Simulator';
AO.b.Monitor.DataType = 'Scalar';
AO.b.Monitor.ChannelNames = sirius_booster_getname(AO.b.FamilyName, 'Monitor', AO.b.DeviceList);
AO.b.Monitor.HW2PhysicsParams = 1;
AO.b.Monitor.Physics2HWParams = 1;
AO.b.Monitor.Units        = 'Hardware';
AO.b.Monitor.HWUnits      = 'Ampere';
AO.b.Monitor.PhysicsUnits = 'GeV';

AO.b.Setpoint.MemberOf = {'MachineConfig';};
AO.b.Setpoint.Mode = 'Simulator';
AO.b.Setpoint.DataType = 'Scalar';
AO.b.Setpoint.ChannelNames = sirius_booster_getname(AO.b.FamilyName, 'Setpoint', AO.b.DeviceList);
AO.b.Setpoint.HW2PhysicsParams = 1;
AO.b.Setpoint.Physics2HWParams = 1;
AO.b.Setpoint.Units        = 'Hardware';
AO.b.Setpoint.HWUnits      = 'Ampere';
AO.b.Setpoint.PhysicsUnits = 'GeV';
AO.b.Setpoint.Range        = [0 300];
AO.b.Setpoint.Tolerance    = .1;
AO.b.Setpoint.DeltaRespMat = .01;

% QUADS
AO.qd.FamilyName = 'qd';
AO.qd.MemberOf    = {'PlotFamily'; 'qd'; 'QUAD'; 'Magnet'; 'Tune Corrector'};
AO.qd.DeviceList  = getDeviceList(5,5);
AO.qd.ElementList = (1:size(AO.qd.DeviceList,1))';
AO.qd.Status      = ones(size(AO.qd.DeviceList,1),1);
AO.qd.Position    = [];
AO.qd.Monitor.MemberOf = {};
AO.qd.Monitor.Mode = 'Simulator';
AO.qd.Monitor.DataType = 'Scalar';
AO.qd.Monitor.Units        = 'Hardware';
AO.qd.Monitor.HWUnits      = 'Ampere';
AO.qd.Monitor.PhysicsUnits = 'meter^-2';
AO.qd.Setpoint.MemberOf      = {'MachineConfig'};
AO.qd.Setpoint.Mode          = 'Simulator';
AO.qd.Setpoint.DataType      = 'Scalar';
AO.qd.Setpoint.Units         = 'Hardware';
AO.qd.Setpoint.HWUnits       = 'Ampere';
AO.qd.Setpoint.PhysicsUnits  = 'meter^-2';
AO.qd.Setpoint.Range         = [-5 5];
AO.qd.Setpoint.Tolerance     = 0.002;
AO.qd.Setpoint.DeltaRespMat  = 0.05; 

AO.qf.FamilyName = 'qf';
AO.qf.MemberOf    = {'PlotFamily'; 'qf'; 'QUAD'; 'Magnet'; 'Tune Corrector'};
AO.qf.DeviceList  = getDeviceList(5,10);
AO.qf.ElementList = (1:size(AO.qf.DeviceList,1))';
AO.qf.Status      = ones(size(AO.qf.DeviceList,1),1);
AO.qf.Position    = [];
AO.qf.Monitor.MemberOf = {};
AO.qf.Monitor.Mode = 'Simulator';
AO.qf.Monitor.DataType = 'Scalar';
AO.qf.Monitor.Units        = 'Hardware';
AO.qf.Monitor.HWUnits      = 'Ampere';
AO.qf.Monitor.PhysicsUnits = 'meter^-2';
AO.qf.Setpoint.MemberOf      = {'MachineConfig'};
AO.qf.Setpoint.Mode          = 'Simulator';
AO.qf.Setpoint.DataType      = 'Scalar';
AO.qf.Setpoint.Units         = 'Hardware';
AO.qf.Setpoint.HWUnits       = 'Ampere';
AO.qf.Setpoint.PhysicsUnits  = 'meter^-2';
AO.qf.Setpoint.Range         = [-5 5];
AO.qf.Setpoint.Tolerance     = 0.002;
AO.qf.Setpoint.DeltaRespMat  = 0.05; 

%SEXT
AO.sd.FamilyName = 'sd';
AO.sd.MemberOf    = {'PlotFamily'; 'sd'; 'SEXT'; 'Magnet'; 'Chromaticity Corrector'};
AO.sd.DeviceList  = getDeviceList(5,2);
AO.sd.ElementList = (1:size(AO.sd.DeviceList,1))';
AO.sd.Status      = ones(size(AO.sd.DeviceList,1),1);
AO.sd.Position    = [];
AO.sd.Monitor.MemberOf = {};
AO.sd.Monitor.Mode = 'Simulator';
AO.sd.Monitor.DataType = 'Scalar';
AO.sd.Monitor.Units        = 'Hardware';
AO.sd.Monitor.HWUnits      = 'Ampere';
AO.sd.Monitor.PhysicsUnits = 'meter^-3';
AO.sd.Setpoint.MemberOf      = {'MachineConfig'};
AO.sd.Setpoint.Mode          = 'Simulator';
AO.sd.Setpoint.DataType      = 'Scalar';
AO.sd.Setpoint.Units         = 'Hardware';
AO.sd.Setpoint.HWUnits       = 'Ampere';
AO.sd.Setpoint.PhysicsUnits  = 'meter^-3';
AO.sd.Setpoint.Range         = [-500 500];
AO.sd.Setpoint.Tolerance     = 0.05;
AO.sd.Setpoint.DeltaRespMat  = 0.1; 

AO.sf.FamilyName = 'sf';
AO.sf.MemberOf    = {'PlotFamily'; 'sf'; 'SEXT'; 'Magnet'; 'Chromaticity Corrector'};
AO.sf.DeviceList  = getDeviceList(5,5);
AO.sf.ElementList = (1:size(AO.sf.DeviceList,1))';
AO.sf.Status      = ones(size(AO.sf.DeviceList,1),1);
AO.sf.Position    = [];
AO.sf.Monitor.MemberOf = {};
AO.sf.Monitor.Mode = 'Simulator';
AO.sf.Monitor.DataType = 'Scalar';
AO.sf.Monitor.Units        = 'Hardware';
AO.sf.Monitor.HWUnits      = 'Ampere';
AO.sf.Monitor.PhysicsUnits = 'meter^-3';
AO.sf.Setpoint.MemberOf      = {'MachineConfig'};
AO.sf.Setpoint.Mode          = 'Simulator';
AO.sf.Setpoint.DataType      = 'Scalar';
AO.sf.Setpoint.Units         = 'Hardware';
AO.sf.Setpoint.HWUnits       = 'Ampere';
AO.sf.Setpoint.PhysicsUnits  = 'meter^-3';
AO.sf.Setpoint.Range         = [-500 500];
AO.sf.Setpoint.Tolerance     = 0.05;
AO.sf.Setpoint.DeltaRespMat  = 0.1; 

% HCM
AO.hcm.FamilyName  = 'hcm';
AO.hcm.MemberOf    = {'PlotFamily'; 'COR'; 'hcm'; 'Magnet'};
AO.hcm.DeviceList  = getDeviceList(5,5);
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


% VCM
AO.vcm.FamilyName  = 'vcm';
AO.vcm.MemberOf    = {'PlotFamily'; 'COR'; 'vcm'; 'Magnet'};
AO.vcm.DeviceList  = getDeviceList(5,5);
AO.vcm.ElementList = (1:size(AO.vcm.DeviceList,1))';
AO.vcm.Status      = ones(size(AO.vcm.DeviceList,1),1);
AO.vcm.Position    = [];

AO.vcm.Monitor.MemberOf = {'Vertical'; 'COR'; 'vcm'; 'Magnet';};
AO.vcm.Monitor.Mode = 'Simulator';
AO.vcm.Monitor.DataType = 'Scalar';
AO.vcm.Monitor.Units        = 'Physics';
AO.vcm.Monitor.HWUnits      = 'Ampere';
AO.vcm.Monitor.PhysicsUnits = 'Radian';

AO.vcm.Setpoint.MemberOf = {'MachineConfig'; 'Vertical'; 'COR'; 'vcm'; 'Magnet'; 'Setpoint'; 'measbpmresp';};
AO.vcm.Setpoint.Mode = 'Simulator';
AO.vcm.Setpoint.DataType = 'Scalar';
AO.vcm.Setpoint.Units        = 'Physics';
AO.vcm.Setpoint.HWUnits      = 'Ampere';
AO.vcm.Setpoint.PhysicsUnits = 'Radian';
AO.vcm.Setpoint.Range        = [-10 10];
AO.vcm.Setpoint.Tolerance    = 0.00001;
AO.vcm.Setpoint.DeltaRespMat = 0.0005; 

% BPMx
AO.bpmx.FamilyName  = 'bpmx';
AO.bpmx.MemberOf    = {'PlotFamily'; 'BPM'; 'bpmx'; 'Diagnostics'};
AO.bpmx.DeviceList  = getDeviceList(5,10);
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

% BPMy
AO.bpmy.FamilyName  = 'bpmy';
AO.bpmy.MemberOf    = {'PlotFamily'; 'BPM'; 'bpmy'; 'Diagnostics'};
AO.bpmy.DeviceList  = getDeviceList(5,10);
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


 
function DList = getDeviceList(NSector,NDevices)

DList = [];
DL = ones(NDevices,2);
DL(:,2) = (1:NDevices)';
for i=1:NSector
    DL(:,1) = i;
    DList = [DList; DL];
end



