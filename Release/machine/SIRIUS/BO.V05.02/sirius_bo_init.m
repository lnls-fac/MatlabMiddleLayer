function sirius_bo_init(OperationalMode)

if nargin < 1
    OperationalMode = 1;
end

setao([]);
setad([]);



% Base on the location of this file
[SIRIUS_ROOT, ~, ~] = fileparts(mfilename('fullpath'));
AD.Directory.ExcDataDir  = '/home/fac_files/lnls-sirius/control-system-constants/magnet/excitation-data';
AD.Directory.LatticesDef = [SIRIUS_ROOT, filesep, 'lattices_def'];
setad(AD);

%% DIPOLES

AO.B.FamilyName  = 'B';
AO.B.MemberOf    = {'PlotFamily'; 'B'; 'BEND'; 'Magnet';};
AO.B.DeviceList  = getDeviceList(50,1);
AO.B.ElementList = (1:size(AO.B.DeviceList,1))';
AO.B.Status      = ones(size(AO.B.DeviceList,1),1);
AO.B.Position    = [];
AO.B.ExcitationCurves = sirius_getexcdata(repmat('bo-dipole-b-fam', size(AO.B.DeviceList,1), 1));

AO.B.Monitor.MemberOf      = {};
AO.B.Monitor.Mode          = 'Simulator';
AO.B.Monitor.DataType      = 'Scalar';
AO.B.Monitor.HW2PhysicsFcn = @bend2gev;
AO.B.Monitor.Physics2HWFcn = @gev2bend;
AO.B.Monitor.ChannelNames  = sirius_bo_getname(AO.B.FamilyName, 'Monitor', AO.B.DeviceList);
AO.B.Monitor.Units         = 'Hardware';
AO.B.Monitor.HWUnits       = 'Ampere';
AO.B.Monitor.PhysicsUnits  = 'GeV';

AO.B.ReferenceMonitor.MemberOf = {};
AO.B.ReferenceMonitor.Mode = 'Simulator';
AO.B.ReferenceMonitor.DataType = 'Scalar';
AO.B.ReferenceMonitor.HW2PhysicsFcn = @bend2gev;
AO.B.ReferenceMonitor.Physics2HWFcn = @gev2bend;
AO.B.ReferenceMonitor.ChannelNames  = sirius_bo_getname(AO.B.FamilyName, 'ReferenceMonitor', AO.B.DeviceList);
AO.B.ReferenceMonitor.Units         = 'Hardware';
AO.B.ReferenceMonitor.HWUnits       = 'Ampere';
AO.B.ReferenceMonitor.PhysicsUnits  = 'GeV';

AO.B.Readback.MemberOf      = {};
AO.B.Readback.Mode          = 'Simulator';
AO.B.Readback.DataType      = 'Scalar';
AO.B.Readback.HW2PhysicsFcn = @bend2gev;
AO.B.Readback.Physics2HWFcn = @gev2bend;
AO.B.Readback.ChannelNames  = sirius_bo_getname(AO.B.FamilyName, 'Readback', AO.B.DeviceList);
AO.B.Readback.Units         = 'Hardware';
AO.B.Readback.HWUnits       = 'Ampere';
AO.B.Readback.PhysicsUnits  = 'GeV';

AO.B.Setpoint.MemberOf      = {'MachineConfig';};
AO.B.Setpoint.Mode          = 'Simulator';
AO.B.Setpoint.DataType      = 'Scalar';
AO.B.Setpoint.HW2PhysicsFcn = @bend2gev;
AO.B.Setpoint.Physics2HWFcn = @gev2bend;
AO.B.Setpoint.ChannelNames  = sirius_bo_getname(AO.B.FamilyName, 'Setpoint', AO.B.DeviceList);
AO.B.Setpoint.Units         = 'Hardware';
AO.B.Setpoint.HWUnits       = 'Ampere';
AO.B.Setpoint.PhysicsUnits  = 'GeV';
AO.B.Setpoint.Range         = [0 300];
AO.B.Setpoint.Tolerance     = .1;
AO.B.Setpoint.DeltaRespMat  = .01;


%% QUADRUPOLES

% QD
AO.QD.FamilyName  = 'QD';
AO.QD.MemberOf    = {'PlotFamily'; 'QD'; 'QUAD'; 'Magnet'; 'Tune Corrector'};
AO.QD.DeviceList  = getDeviceList(50,1,2,2);
AO.QD.ElementList = (1:size(AO.QD.DeviceList,1))';
AO.QD.Status      = ones(size(AO.QD.DeviceList,1),1);
AO.QD.Position    = [];
AO.QD.ExcitationCurves = sirius_getexcdata(repmat('bo-quadrupole-qd-fam', size(AO.QD.DeviceList,1), 1));

AO.QD.Monitor.MemberOf = {};
AO.QD.Monitor.Mode = 'Simulator';
AO.QD.Monitor.DataType = 'Scalar';
AO.QD.Monitor.Units        = 'Hardware';
AO.QD.Monitor.HWUnits      = 'Ampere';
AO.QD.Monitor.PhysicsUnits = 'meter^-2';
AO.QD.Monitor.ChannelNames = sirius_bo_getname(AO.QD.FamilyName, 'Monitor', AO.QD.DeviceList);
AO.QD.Monitor.HW2PhysicsFcn  = @sirius_hw2ph;
AO.QD.Monitor.Physics2HWFcn  = @sirius_ph2hw;

AO.QD.ReferenceMonitor.MemberOf = {};
AO.QD.ReferenceMonitor.Mode = 'Simulator';
AO.QD.ReferenceMonitor.DataType = 'Scalar';
AO.QD.ReferenceMonitor.Units        = 'Hardware';
AO.QD.ReferenceMonitor.HWUnits      = 'Ampere';
AO.QD.ReferenceMonitor.PhysicsUnits = 'meter^-2';
AO.QD.ReferenceMonitor.ChannelNames = sirius_bo_getname(AO.QD.FamilyName, 'ReferenceMonitor', AO.QD.DeviceList);
AO.QD.ReferenceMonitor.HW2PhysicsFcn  = @sirius_hw2ph;
AO.QD.ReferenceMonitor.Physics2HWFcn  = @sirius_ph2hw;

AO.QD.Readback.MemberOf = {};
AO.QD.Readback.Mode = 'Simulator';
AO.QD.Readback.DataType = 'Scalar';
AO.QD.Readback.Units        = 'Hardware';
AO.QD.Readback.HWUnits      = 'Ampere';
AO.QD.Readback.PhysicsUnits = 'meter^-2';
AO.QD.Readback.ChannelNames = sirius_bo_getname(AO.QD.FamilyName, 'Readback', AO.QD.DeviceList);
AO.QD.Readback.HW2PhysicsFcn  = @sirius_hw2ph;
AO.QD.Readback.Physics2HWFcn  = @sirius_ph2hw;

AO.QD.Setpoint.MemberOf      = {'MachineConfig'};
AO.QD.Setpoint.Mode          = 'Simulator';
AO.QD.Setpoint.DataType      = 'Scalar';
AO.QD.Setpoint.Units         = 'Hardware';
AO.QD.Setpoint.HWUnits       = 'Ampere';
AO.QD.Setpoint.PhysicsUnits  = 'meter^-2';
AO.QD.Setpoint.ChannelNames  = sirius_bo_getname(AO.QD.FamilyName, 'Setpoint', AO.QD.DeviceList);
AO.QD.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.QD.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.QD.Setpoint.Range         = [-5 5];
AO.QD.Setpoint.Tolerance     = 0.002;
AO.QD.Setpoint.DeltaRespMat  = 0.05;


% QF
AO.QF.FamilyName = 'QF';
AO.QF.MemberOf    = {'PlotFamily'; 'QF'; 'QUAD'; 'Magnet'; 'Tune Corrector'};
AO.QF.DeviceList  = getDeviceList(50,1);
AO.QF.ElementList = (1:size(AO.QF.DeviceList,1))';
AO.QF.Status      = ones(size(AO.QF.DeviceList,1),1);
AO.QF.Position    = [];
AO.QF.ExcitationCurves = sirius_getexcdata(repmat('bo-quadrupole-qf-fam', size(AO.QF.DeviceList,1), 1));

AO.QF.Monitor.MemberOf = {};
AO.QF.Monitor.Mode = 'Simulator';
AO.QF.Monitor.DataType = 'Scalar';
AO.QF.Monitor.Units        = 'Hardware';
AO.QF.Monitor.HWUnits      = 'Ampere';
AO.QF.Monitor.PhysicsUnits = 'meter^-2';
AO.QF.Monitor.ChannelNames = sirius_bo_getname(AO.QF.FamilyName, 'Monitor', AO.QF.DeviceList);
AO.QF.Monitor.HW2PhysicsFcn  = @sirius_hw2ph;
AO.QF.Monitor.Physics2HWFcn  = @sirius_ph2hw;

AO.QF.ReferenceMonitor.MemberOf = {};
AO.QF.ReferenceMonitor.Mode = 'Simulator';
AO.QF.ReferenceMonitor.DataType = 'Scalar';
AO.QF.ReferenceMonitor.Units        = 'Hardware';
AO.QF.ReferenceMonitor.HWUnits      = 'Ampere';
AO.QF.ReferenceMonitor.PhysicsUnits = 'meter^-2';
AO.QF.ReferenceMonitor.ChannelNames = sirius_bo_getname(AO.QF.FamilyName, 'ReferenceMonitor', AO.QF.DeviceList);
AO.QF.ReferenceMonitor.HW2PhysicsFcn  = @sirius_hw2ph;
AO.QF.ReferenceMonitor.Physics2HWFcn  = @sirius_ph2hw;

AO.QF.Readback.MemberOf = {};
AO.QF.Readback.Mode = 'Simulator';
AO.QF.Readback.DataType = 'Scalar';
AO.QF.Readback.Units        = 'Hardware';
AO.QF.Readback.HWUnits      = 'Ampere';
AO.QF.Readback.PhysicsUnits = 'meter^-2';
AO.QF.Readback.ChannelNames = sirius_bo_getname(AO.QF.FamilyName, 'Readback', AO.QF.DeviceList);
AO.QF.Readback.HW2PhysicsFcn  = @sirius_hw2ph;
AO.QF.Readback.Physics2HWFcn  = @sirius_ph2hw;

AO.QF.Setpoint.MemberOf      = {'MachineConfig'};
AO.QF.Setpoint.Mode          = 'Simulator';
AO.QF.Setpoint.DataType      = 'Scalar';
AO.QF.Setpoint.Units         = 'Hardware';
AO.QF.Setpoint.HWUnits       = 'Ampere';
AO.QF.Setpoint.PhysicsUnits  = 'meter^-2';
AO.QF.Setpoint.ChannelNames = sirius_bo_getname(AO.QF.FamilyName, 'Setpoint', AO.QF.DeviceList);
AO.QF.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.QF.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.QF.Setpoint.Range         = [-5 5];
AO.QF.Setpoint.Tolerance     = 0.002;
AO.QF.Setpoint.DeltaRespMat  = 0.05;

%% SEXTUPOLES

% SD
AO.SD.FamilyName = 'SD';
AO.SD.MemberOf    = {'PlotFamily'; 'SD'; 'SEXT'; 'Magnet'; 'Chromaticity Corrector'};
AO.SD.DeviceList  = getDeviceList(50,1,3,5);
AO.SD.ElementList = (1:size(AO.SD.DeviceList,1))';
AO.SD.Status      = ones(size(AO.SD.DeviceList,1),1);
AO.SD.Position    = [];
AO.SD.ExcitationCurves = sirius_getexcdata(repmat('bo-sextupole-sd-fam', size(AO.SD.DeviceList,1), 1));

AO.SD.Monitor.MemberOf = {};
AO.SD.Monitor.Mode = 'Simulator';
AO.SD.Monitor.DataType = 'Scalar';
AO.SD.Monitor.Units        = 'Hardware';
AO.SD.Monitor.HWUnits      = 'Ampere';
AO.SD.Monitor.PhysicsUnits = 'meter^-3';
AO.SD.Monitor.ChannelNames = sirius_bo_getname(AO.SD.FamilyName, 'Monitor', AO.SD.DeviceList);
AO.SD.Monitor.HW2PhysicsFcn  = @sirius_hw2ph;
AO.SD.Monitor.Physics2HWFcn  = @sirius_ph2hw;

AO.SD.ReferenceMonitor.MemberOf = {};
AO.SD.ReferenceMonitor.Mode = 'Simulator';
AO.SD.ReferenceMonitor.DataType = 'Scalar';
AO.SD.ReferenceMonitor.Units        = 'Hardware';
AO.SD.ReferenceMonitor.HWUnits      = 'Ampere';
AO.SD.ReferenceMonitor.PhysicsUnits = 'meter^-3';
AO.SD.ReferenceMonitor.ChannelNames = sirius_bo_getname(AO.SD.FamilyName, 'ReferenceMonitor', AO.SD.DeviceList);
AO.SD.ReferenceMonitor.HW2PhysicsFcn  = @sirius_hw2ph;
AO.SD.ReferenceMonitor.Physics2HWFcn  = @sirius_ph2hw;

AO.SD.Readback.MemberOf = {};
AO.SD.Readback.Mode = 'Simulator';
AO.SD.Readback.DataType = 'Scalar';
AO.SD.Readback.Units        = 'Hardware';
AO.SD.Readback.HWUnits      = 'Ampere';
AO.SD.Readback.PhysicsUnits = 'meter^-3';
AO.SD.Readback.ChannelNames = sirius_bo_getname(AO.SD.FamilyName, 'Readback', AO.SD.DeviceList);
AO.SD.Readback.HW2PhysicsFcn  = @sirius_hw2ph;
AO.SD.Readback.Physics2HWFcn  = @sirius_ph2hw;

AO.SD.Setpoint.MemberOf      = {'MachineConfig'};
AO.SD.Setpoint.Mode          = 'Simulator';
AO.SD.Setpoint.DataType      = 'Scalar';
AO.SD.Setpoint.Units         = 'Hardware';
AO.SD.Setpoint.HWUnits       = 'Ampere';
AO.SD.Setpoint.PhysicsUnits  = 'meter^-3';
AO.SD.Setpoint.ChannelNames  = sirius_bo_getname(AO.SD.FamilyName, 'Setpoint', AO.SD.DeviceList);
AO.SD.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.SD.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.SD.Setpoint.Range         = [-500 500];
AO.SD.Setpoint.Tolerance     = 0.05;
AO.SD.Setpoint.DeltaRespMat  = 0.1;


% SF
AO.SF.FamilyName = 'SF';
AO.SF.MemberOf    = {'PlotFamily'; 'SF'; 'SEXT'; 'Magnet'; 'Chromaticity Corrector'};
AO.SF.DeviceList  = getDeviceList(50,1,2,2);
AO.SF.ElementList = (1:size(AO.SF.DeviceList,1))';
AO.SF.Status      = ones(size(AO.SF.DeviceList,1),1);
AO.SF.Position    = [];
AO.SF.ExcitationCurves = sirius_getexcdata(repmat('bo-sextupole-sf-fam', size(AO.SF.DeviceList,1), 1));

AO.SF.Monitor.MemberOf = {};
AO.SF.Monitor.Mode = 'Simulator';
AO.SF.Monitor.DataType = 'Scalar';
AO.SF.Monitor.Units        = 'Hardware';
AO.SF.Monitor.HWUnits      = 'Ampere';
AO.SF.Monitor.PhysicsUnits = 'meter^-3';
AO.SF.Monitor.ChannelNames = sirius_bo_getname(AO.SF.FamilyName, 'Monitor', AO.SF.DeviceList);
AO.SF.Monitor.HW2PhysicsFcn  = @sirius_hw2ph;
AO.SF.Monitor.Physics2HWFcn  = @sirius_ph2hw;

AO.SF.ReferenceMonitor.MemberOf = {};
AO.SF.ReferenceMonitor.Mode = 'Simulator';
AO.SF.ReferenceMonitor.DataType = 'Scalar';
AO.SF.ReferenceMonitor.Units        = 'Hardware';
AO.SF.ReferenceMonitor.HWUnits      = 'Ampere';
AO.SF.ReferenceMonitor.PhysicsUnits = 'meter^-3';
AO.SF.ReferenceMonitor.ChannelNames = sirius_bo_getname(AO.SF.FamilyName, 'ReferenceMonitor', AO.SF.DeviceList);
AO.SF.ReferenceMonitor.HW2PhysicsFcn  = @sirius_hw2ph;
AO.SF.ReferenceMonitor.Physics2HWFcn  = @sirius_ph2hw;

AO.SF.Readback.MemberOf = {};
AO.SF.Readback.Mode = 'Simulator';
AO.SF.Readback.DataType = 'Scalar';
AO.SF.Readback.Units        = 'Hardware';
AO.SF.Readback.HWUnits      = 'Ampere';
AO.SF.Readback.PhysicsUnits = 'meter^-3';
AO.SF.Readback.ChannelNames = sirius_bo_getname(AO.SF.FamilyName, 'Readback', AO.SF.DeviceList);
AO.SF.Readback.HW2PhysicsFcn  = @sirius_hw2ph;
AO.SF.Readback.Physics2HWFcn  = @sirius_ph2hw;

AO.SF.Setpoint.MemberOf      = {'MachineConfig'};
AO.SF.Setpoint.Mode          = 'Simulator';
AO.SF.Setpoint.DataType      = 'Scalar';
AO.SF.Setpoint.Units         = 'Hardware';
AO.SF.Setpoint.HWUnits       = 'Ampere';
AO.SF.Setpoint.PhysicsUnits  = 'meter^-3';
AO.SF.Setpoint.ChannelNames  = sirius_bo_getname(AO.SF.FamilyName, 'Setpoint', AO.SF.DeviceList);
AO.SF.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.SF.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.SF.Setpoint.Range         = [-500 500];
AO.SF.Setpoint.Tolerance     = 0.05;
AO.SF.Setpoint.DeltaRespMat  = 0.1;


%% CORRECTORS
% CH
AO.CH.FamilyName  = 'CH';
AO.CH.MemberOf    = {'PlotFamily'; 'COR'; 'CH'; 'Magnet'; 'HCM'};
AO.CH.DeviceList  = getDeviceList(50,1,1,2);
AO.CH.ElementList = (1:size(AO.CH.DeviceList,1))';
AO.CH.Status      = ones(size(AO.CH.DeviceList,1),1);
AO.CH.Position    = [];
AO.CH.ExcitationCurves = sirius_getexcdata(repmat('bo-corrector-ch', size(AO.CH.DeviceList,1), 1));

AO.CH.Monitor.MemberOf = {'Horizontal'; 'COR'; 'CH'; 'Magnet';};
AO.CH.Monitor.Mode = 'Simulator';
AO.CH.Monitor.DataType = 'Scalar';
AO.CH.Monitor.Units        = 'Hardware';
AO.CH.Monitor.HWUnits      = 'Ampere';
AO.CH.Monitor.PhysicsUnits = 'Radian';
AO.CH.Monitor.ChannelNames = sirius_bo_getname(AO.CH.FamilyName, 'Monitor', AO.CH.DeviceList) ;
AO.CH.Monitor.HW2PhysicsFcn  = @sirius_hw2ph;
AO.CH.Monitor.Physics2HWFcn  = @sirius_ph2hw;

AO.CH.ReferenceMonitor.MemberOf = {};
AO.CH.ReferenceMonitor.Mode = 'Simulator';
AO.CH.ReferenceMonitor.DataType = 'Scalar';
AO.CH.ReferenceMonitor.Units        = 'Hardware';
AO.CH.ReferenceMonitor.HWUnits      = 'Ampere';
AO.CH.ReferenceMonitor.PhysicsUnits = 'Radian';
AO.CH.ReferenceMonitor.ChannelNames = sirius_bo_getname(AO.CH.FamilyName, 'ReferenceMonitor', AO.CH.DeviceList) ;
AO.CH.ReferenceMonitor.HW2PhysicsFcn  = @sirius_hw2ph;
AO.CH.ReferenceMonitor.Physics2HWFcn  = @sirius_ph2hw;

AO.CH.Readback.MemberOf = {};
AO.CH.Readback.Mode = 'Simulator';
AO.CH.Readback.DataType = 'Scalar';
AO.CH.Readback.Units        = 'Hardware';
AO.CH.Readback.HWUnits      = 'Ampere';
AO.CH.Readback.PhysicsUnits = 'Radian';
AO.CH.Readback.ChannelNames = sirius_bo_getname(AO.CH.FamilyName, 'Readback', AO.CH.DeviceList) ;
AO.CH.Readback.HW2PhysicsFcn  = @sirius_hw2ph;
AO.CH.Readback.Physics2HWFcn  = @sirius_ph2hw;

AO.CH.Setpoint.MemberOf = {'MachineConfig'; 'Horizontal'; 'COR'; 'CH'; 'Magnet'; 'Setpoint'; 'measbpmresp';};
AO.CH.Setpoint.Mode = 'Simulator';
AO.CH.Setpoint.DataType = 'Scalar';
AO.CH.Setpoint.Units        = 'Hardware';
AO.CH.Setpoint.HWUnits      = 'Ampere';
AO.CH.Setpoint.PhysicsUnits = 'Radian';
AO.CH.Setpoint.ChannelNames = sirius_bo_getname(AO.CH.FamilyName, 'Setpoint', AO.CH.DeviceList);
AO.CH.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.CH.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.CH.Setpoint.Range        = [-10 10];
AO.CH.Setpoint.Tolerance    = 0.00001;
AO.CH.Setpoint.DeltaRespMat = 0.0005;


% CV
AO.CV.FamilyName  = 'CV';
AO.CV.MemberOf    = {'PlotFamily'; 'COR'; 'CV'; 'Magnet'; 'VCM'};
AO.CV.DeviceList  = getDeviceList(50,1,1,2);
AO.CV.ElementList = (1:size(AO.CV.DeviceList,1))';
AO.CV.Status      = ones(size(AO.CV.DeviceList,1),1);
AO.CV.Position    = [];
AO.CV.ExcitationCurves = sirius_getexcdata(repmat('bo-corrector-cv', size(AO.CV.DeviceList,1), 1));

AO.CV.Monitor.MemberOf = {'Vertical'; 'COR'; 'CV'; 'Magnet';};
AO.CV.Monitor.Mode = 'Simulator';
AO.CV.Monitor.DataType = 'Scalar';
AO.CV.Monitor.Units        = 'Hardware';
AO.CV.Monitor.HWUnits      = 'Ampere';
AO.CV.Monitor.PhysicsUnits = 'Radian';
AO.CV.Monitor.ChannelNames = sirius_bo_getname(AO.CV.FamilyName, 'Monitor', AO.CV.DeviceList) ;
AO.CV.Monitor.HW2PhysicsFcn  = @sirius_hw2ph;
AO.CV.Monitor.Physics2HWFcn  = @sirius_ph2hw;

AO.CV.ReferenceMonitor.MemberOf = {};
AO.CV.ReferenceMonitor.Mode = 'Simulator';
AO.CV.ReferenceMonitor.DataType = 'Scalar';
AO.CV.ReferenceMonitor.Units        = 'Hardware';
AO.CV.ReferenceMonitor.HWUnits      = 'Ampere';
AO.CV.ReferenceMonitor.PhysicsUnits = 'Radian';
AO.CV.ReferenceMonitor.ChannelNames = sirius_bo_getname(AO.CV.FamilyName, 'ReferenceMonitor', AO.CV.DeviceList) ;
AO.CV.ReferenceMonitor.HW2PhysicsFcn  = @sirius_hw2ph;
AO.CV.ReferenceMonitor.Physics2HWFcn  = @sirius_ph2hw;

AO.CV.Readback.MemberOf = {};
AO.CV.Readback.Mode = 'Simulator';
AO.CV.Readback.DataType = 'Scalar';
AO.CV.Readback.Units        = 'Hardware';
AO.CV.Readback.HWUnits      = 'Ampere';
AO.CV.Readback.PhysicsUnits = 'Radian';
AO.CV.Readback.ChannelNames = sirius_bo_getname(AO.CV.FamilyName, 'Readback', AO.CV.DeviceList) ;
AO.CV.Readback.HW2PhysicsFcn  = @sirius_hw2ph;
AO.CV.Readback.Physics2HWFcn  = @sirius_ph2hw;

AO.CV.Setpoint.MemberOf = {'MachineConfig'; 'Vertical'; 'COR'; 'CV'; 'Magnet'; 'Setpoint'; 'measbpmresp';};
AO.CV.Setpoint.Mode = 'Simulator';
AO.CV.Setpoint.DataType = 'Scalar';
AO.CV.Setpoint.Units        = 'Hardware';
AO.CV.Setpoint.HWUnits      = 'Ampere';
AO.CV.Setpoint.PhysicsUnits = 'Radian';
AO.CV.Setpoint.ChannelNames = sirius_bo_getname(AO.CV.FamilyName, 'Setpoint', AO.CV.DeviceList);
AO.CV.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.CV.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.CV.Setpoint.Range        = [-10 10];
AO.CV.Setpoint.Tolerance    = 0.00001;
AO.CV.Setpoint.DeltaRespMat = 0.0005;


% QS
AO.QS.FamilyName = 'QS';
AO.QS.MemberOf    = {'PlotFamily'; 'QS'; 'SkewQUAD'; 'Magnet'; 'Coupling Corrector'};
AO.QS.DeviceList  = [2, 1];
AO.QS.ElementList = (1:size(AO.QS.DeviceList,1))';
AO.QS.Status      = ones(size(AO.QS.DeviceList,1),1);
AO.QS.Position    = [];
AO.QS.ExcitationCurves = sirius_getexcdata(repmat('bo-quadrupole-qs', size(AO.QS.DeviceList,1), 1));

AO.QS.Monitor.MemberOf = {};
AO.QS.Monitor.Mode = 'Simulator';
AO.QS.Monitor.DataType = 'Scalar';
AO.QS.Monitor.Units        = 'Hardware';
AO.QS.Monitor.HWUnits      = 'Ampere';
AO.QS.Monitor.PhysicsUnits = 'meter^-2';
AO.QS.Monitor.ChannelNames = sirius_bo_getname(AO.QS.FamilyName, 'Monitor', AO.QS.DeviceList);
AO.QS.Monitor.HW2PhysicsFcn  = @sirius_hw2ph;
AO.QS.Monitor.Physics2HWFcn  = @sirius_ph2hw;

AO.QS.ReferenceMonitor.MemberOf = {};
AO.QS.ReferenceMonitor.Mode = 'Simulator';
AO.QS.ReferenceMonitor.DataType = 'Scalar';
AO.QS.ReferenceMonitor.Units        = 'Hardware';
AO.QS.ReferenceMonitor.HWUnits      = 'Ampere';
AO.QS.ReferenceMonitor.PhysicsUnits = 'meter^-2';
AO.QS.ReferenceMonitor.ChannelNames = sirius_bo_getname(AO.QS.FamilyName, 'ReferenceMonitor', AO.QS.DeviceList);
AO.QS.ReferenceMonitor.HW2PhysicsFcn  = @sirius_hw2ph;
AO.QS.ReferenceMonitor.Physics2HWFcn  = @sirius_ph2hw;

AO.QS.Readback.MemberOf = {};
AO.QS.Readback.Mode = 'Simulator';
AO.QS.Readback.DataType = 'Scalar';
AO.QS.Readback.Units        = 'Hardware';
AO.QS.Readback.HWUnits      = 'Ampere';
AO.QS.Readback.PhysicsUnits = 'meter^-2';
AO.QS.Readback.ChannelNames = sirius_bo_getname(AO.QS.FamilyName, 'Readback', AO.QS.DeviceList);
AO.QS.Readback.HW2PhysicsFcn  = @sirius_hw2ph;
AO.QS.Readback.Physics2HWFcn  = @sirius_ph2hw;

AO.QS.Setpoint.MemberOf      = {'MachineConfig'};
AO.QS.Setpoint.Mode          = 'Simulator';
AO.QS.Setpoint.DataType      = 'Scalar';
AO.QS.Setpoint.Units         = 'Hardware';
AO.QS.Setpoint.HWUnits       = 'Ampere';
AO.QS.Setpoint.PhysicsUnits  = 'meter^-2';
AO.QS.Setpoint.ChannelNames  = sirius_bo_getname(AO.QS.FamilyName, 'Setpoint', AO.QS.DeviceList);
AO.QS.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.QS.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.QS.Setpoint.Range         = [-5 5];
AO.QS.Setpoint.Tolerance     = 0.002;
AO.QS.Setpoint.DeltaRespMat  = 0.05;

%% MONITORS

% BPMx
AO.BPMx.FamilyName  = 'BPMx';
AO.BPMx.MemberOf    = {'PlotFamily'; 'BPM'; 'BPMx'; 'Diagnostics'};
AO.BPMx.DeviceList  = getDeviceList(50,1);
AO.BPMx.ElementList = (1:size(AO.BPMx.DeviceList,1))';
AO.BPMx.Status      = ones(size(AO.BPMx.DeviceList,1),1);
AO.BPMx.Position    = [];
AO.BPMx.Golden      = zeros(length(AO.BPMx.ElementList),1);
AO.BPMx.Offset      = zeros(length(AO.BPMx.ElementList),1);

AO.BPMx.Monitor.MemberOf = {'BPMx'; 'Monitor';};
AO.BPMx.Monitor.Mode = 'Simulator';
AO.BPMx.Monitor.DataType = 'Scalar';
AO.BPMx.Monitor.HW2PhysicsParams = 1e-9;  % HW [nm], Simulator [Meters]
AO.BPMx.Monitor.Physics2HWParams = 1e9;
AO.BPMx.Monitor.Units        = 'Hardware';
AO.BPMx.Monitor.HWUnits      = 'um';
AO.BPMx.Monitor.PhysicsUnits = 'meter';
AO.BPMx.Monitor.ChannelNames = sirius_bo_getname(AO.BPMx.FamilyName, 'Monitor', AO.BPMx.DeviceList) ;

% BPMy
AO.BPMy.FamilyName  = 'BPMy';
AO.BPMy.MemberOf    = {'PlotFamily'; 'BPM'; 'BPMy'; 'Diagnostics'};
AO.BPMy.DeviceList  = getDeviceList(50,1);
AO.BPMy.ElementList = (1:size(AO.BPMy.DeviceList,1))';
AO.BPMy.Status      = ones(size(AO.BPMy.DeviceList,1),1);
AO.BPMy.Position    = [];
AO.BPMy.Golden      = zeros(length(AO.BPMy.ElementList),1);
AO.BPMy.Offset      = zeros(length(AO.BPMy.ElementList),1);

AO.BPMy.Monitor.MemberOf = {'BPMy'; 'Monitor';};
AO.BPMy.Monitor.Mode = 'Simulator';
AO.BPMy.Monitor.DataType = 'Scalar';
AO.BPMy.Monitor.HW2PhysicsParams = 1e-9;  % HW [nm], Simulator [Meters]
AO.BPMy.Monitor.Physics2HWParams = 1e9;
AO.BPMy.Monitor.Units        = 'Hardware';
AO.BPMy.Monitor.HWUnits      = 'nm';
AO.BPMy.Monitor.PhysicsUnits = 'meter';
AO.BPMy.Monitor.ChannelNames = sirius_bo_getname(AO.BPMy.FamilyName, 'Monitor', AO.BPMy.DeviceList) ;


%%%%%%%%
% Tune %
%%%%%%%%
AO.TUNE.FamilyName = 'TUNE';
AO.TUNE.MemberOf = {'TUNE';};
AO.TUNE.DeviceList = [4 1; 4 2];
AO.TUNE.ElementList = [1;2];
AO.TUNE.Status = [1; 1];
AO.TUNE.CommonNames = ['TuneX'; 'TuneY'];

AO.TUNE.Monitor.MemberOf   = {'TUNE'};
AO.TUNE.Monitor.ChannelNames = sirius_bo_getname(AO.TUNE.FamilyName, 'Monitor', AO.TUNE.DeviceList);
AO.TUNE.Monitor.Mode = 'Simulator';
AO.TUNE.Monitor.DataType = 'Scalar';
AO.TUNE.Monitor.HW2PhysicsParams = 1;
AO.TUNE.Monitor.Physics2HWParams = 1;
AO.TUNE.Monitor.Units        = 'Hardware';
AO.TUNE.Monitor.HWUnits      = 'Tune';
AO.TUNE.Monitor.PhysicsUnits = 'Tune';


%%%%%%%%
%  RF  %
%%%%%%%%
AO.RF.FamilyName                = 'RF';
AO.RF.MemberOf                  = {'P5Cav';'RF'; 'RFSystem'};
AO.RF.DeviceList                = [5 1];
AO.RF.ElementList               = 1;
AO.RF.Status                    = 1;
AO.RF.Position                  = [];

AO.RF.Monitor.MemberOf          = {};
AO.RF.Monitor.Mode              = 'Simulator';
AO.RF.Monitor.DataType          = 'Scalar';
AO.RF.Monitor.HW2PhysicsParams  = 1e+6;
AO.RF.Monitor.Physics2HWParams  = 1e-6;
AO.RF.Monitor.Units             = 'Hardware';
AO.RF.Monitor.HWUnits           = 'MHz';
AO.RF.Monitor.PhysicsUnits      = 'Hz';
AO.RF.Monitor.ChannelNames      = sirius_bo_getname(AO.RF.FamilyName, 'Monitor', AO.RF.DeviceList) ;

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
AO.RF.Setpoint.ChannelNames     = sirius_bo_getname(AO.RF.FamilyName, 'Setpoint', AO.RF.DeviceList) ;

AO.RF.VoltageMonitor.MemberOf         = {};
AO.RF.VoltageMonitor.Mode             = 'Simulator';
AO.RF.VoltageMonitor.DataType         = 'Scalar';
AO.RF.VoltageMonitor.ChannelNames     = sirius_bo_getname(AO.RF.FamilyName, 'VoltageMonitor', AO.RF.DeviceList);
AO.RF.VoltageMonitor.HW2PhysicsParams = 1e+6;
AO.RF.VoltageMonitor.Physics2HWParams = 1e-6;
AO.RF.VoltageMonitor.Units            = 'Hardware';
AO.RF.VoltageMonitor.HWUnits          = 'MV';
AO.RF.VoltageMonitor.PhysicsUnits     = 'Volts';

AO.RF.VoltageSetpoint.MemberOf         = {};
AO.RF.VoltageSetpoint.Mode             = 'Simulator';
AO.RF.VoltageSetpoint.DataType         = 'Scalar';
AO.RF.VoltageSetpoint.ChannelNames     = sirius_bo_getname(AO.RF.FamilyName, 'VoltageSetpoint', AO.RF.DeviceList);
AO.RF.VoltageSetpoint.HW2PhysicsParams = 1e+6;
AO.RF.VoltageSetpoint.Physics2HWParams = 1e-6;
AO.RF.VoltageSetpoint.Units            = 'Hardware';
AO.RF.VoltageSetpoint.HWUnits          = 'MV';
AO.RF.VoltageSetpoint.PhysicsUnits     = 'Volts';

% AO.RF.Power.MemberOf          = {};
% AO.RF.Power.Mode              = 'Simulator';
% AO.RF.Power.DataType          = 'Scalar';
% AO.RF.Power.ChannelNames      = '';          % ???
% AO.RF.Power.HW2PhysicsParams  = 1;
% AO.RF.Power.Physics2HWParams  = 1;
% AO.RF.Power.Units             = 'Hardware';
% AO.RF.Power.HWUnits           = 'MWatts';
% AO.RF.Power.PhysicsUnits      = 'MWatts';
% AO.RF.Power.Range             = [-inf inf];  % ???
% AO.RF.Power.Tolerance         = inf;  % ???
% 
% AO.RF.Phase.MemberOf          = {'P5Cav'; 'RF'; 'Phase'};
% AO.RF.Phase.Mode              = 'Simulator';
% AO.RF.Phase.DataType          = 'Scalar';
% AO.RF.Phase.ChannelNames      = 'SRF1:STN:PHASE:CALC';    % ???
% AO.RF.Phase.Units             = 'Hardware';
% AO.RF.Phase.HW2PhysicsParams  = 1;
% AO.RF.Phase.Physics2HWParams  = 1;
% AO.RF.Phase.HWUnits           = 'Degrees';
% AO.RF.Phase.PhysicsUnits      = 'Degrees';
% 
% AO.RF.PhaseCtrl.MemberOf          = {'P5Cav'; 'RF; Phase'; 'Control'};  % 'MachineConfig';
% AO.RF.PhaseCtrl.Mode              = 'Simulator';
% AO.RF.PhaseCtrl.DataType          = 'Scalar';
% AO.RF.PhaseCtrl.ChannelNames      = 'SRF1:STN:PHASE';    % ???
% AO.RF.PhaseCtrl.Units             = 'Hardware';
% AO.RF.PhaseCtrl.HW2PhysicsParams  = 1;
% AO.RF.PhaseCtrl.Physics2HWParams  = 1;
% AO.RF.PhaseCtrl.HWUnits           = 'Degrees';
% AO.RF.PhaseCtrl.PhysicsUnits      = 'Degrees';
% AO.RF.PhaseCtrl.Range             = [-200 200];    % ???
% AO.RF.PhaseCtrl.Tolerance         = 10;    % ???


%%%%%%%%%%%%%%
%    DCCT    %
%%%%%%%%%%%%%%

AO.DCCT.FamilyName               = 'DCCT';
AO.DCCT.MemberOf                 = {'Diagnostics'; 'DCCT'};
AO.DCCT.DeviceList               = [35 1];
AO.DCCT.ElementList              = 1;
AO.DCCT.Status                   = 1;
AO.DCCT.Position                 = [];

AO.DCCT.Monitor.MemberOf         = {};
AO.DCCT.Monitor.Mode             = 'Simulator';
AO.DCCT.Monitor.DataType         = 'Scalar';
AO.DCCT.Monitor.ChannelNames     = 'AMC03';
AO.DCCT.Monitor.HW2PhysicsParams = 1e-3;
AO.DCCT.Monitor.Physics2HWParams = 1e3;
AO.DCCT.Monitor.Units            = 'Hardware';
AO.DCCT.Monitor.HWUnits          = 'mA';
AO.DCCT.Monitor.PhysicsUnits     = 'Ampere';
AO.DCCT.Monitor.ChannelNames     = sirius_bo_getname(AO.DCCT.FamilyName, 'Monitor', AO.DCCT.DeviceList);

% The operational mode sets the path, filenames, and other important parameters
% Run setoperationalmode after most of the AO is built so that the Units and Mode fields
% can be set in setoperationalmode
setao(AO);
% setoperationalmode(OperationalMode);

function DList = getDeviceList(NSectorsTotal,NDevicesPerSector, varargin)

if isempty(varargin)
    InitialSector = 1;
    Periodicity = 1;
else
    InitialSector = varargin{1};
    Periodicity = varargin{2};
end

DList = [];
DL = ones(NDevicesPerSector,2);
DL(:,2) = (1:NDevicesPerSector)';
for i=InitialSector:Periodicity:NSectorsTotal
    DL(:,1) = i;
    DList = [DList; DL];
end
