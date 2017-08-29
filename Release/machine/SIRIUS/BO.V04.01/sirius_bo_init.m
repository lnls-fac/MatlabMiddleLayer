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

% Get the device lists (local function)
%[OnePerSector, TwoPerSector, ThreePerSector, FourPerSector, FivePerSector, SixPerSector, EightPerSector, TenPerSector, TwelvePerSector, FifteenPerSector, SixteenPerSector, EighteenPerSector, TwentyFourPerSector] = buildthedevicelists;

% BENDS

AO.B.FamilyName  = 'B';
AO.B.MemberOf    = {'PlotFamily'; 'B'; 'BEND'; 'Magnet';};
AO.B.DeviceList  = getDeviceList(5,10);
AO.B.ElementList = (1:size(AO.B.DeviceList,1))';
AO.B.Status      = ones(size(AO.B.DeviceList,1),1);
AO.B.Position    = [];
AO.B.PowerSupplies = ['bend_a'; 'bend_b'];
AO.B.ExcitationCurves            = sirius_getexcdata(repmat('bo-dipole-b-fam', size(AO.B.DeviceList,1), 1));
AO.B.Monitor.MemberOf            = {};
AO.B.Monitor.Mode                = 'Simulator';
AO.B.Monitor.DataType            = 'Scalar';
AO.B.Monitor.SpecialFunctionGet  = @sirius_bo_bendget;
AO.B.Monitor.SpecialFunctionSet  = @sirius_bo_bendset;
AO.B.Monitor.HW2PhysicsFcn       = @bend2gev;
AO.B.Monitor.Physics2HWFcn       = @gev2bend;
AO.B.Monitor.Units               = 'Hardware';
AO.B.Monitor.HWUnits             = 'Ampere';
AO.B.Monitor.PhysicsUnits        = 'GeV';
AO.B.Setpoint.MemberOf           = {'MachineConfig';};
AO.B.Setpoint.Mode               = 'Simulator';
AO.B.Setpoint.DataType           = 'Scalar';
AO.B.Setpoint.SpecialFunctionGet = @sirius_bo_bendget;
AO.B.Setpoint.SpecialFunctionSet = @sirius_bo_bendset;
AO.B.Setpoint.HW2PhysicsFcn      = @bend2gev;
AO.B.Setpoint.Physics2HWFcn      = @gev2bend;
AO.B.Setpoint.Units              = 'Hardware';
AO.B.Setpoint.HWUnits            = 'Ampere';
AO.B.Setpoint.PhysicsUnits       = 'GeV';
AO.B.Setpoint.Range              = [0 300];
AO.B.Setpoint.Tolerance          = .1;
AO.B.Setpoint.DeltaRespMat       = .01;

AO.bend_a.FamilyName            = 'bend_a';
AO.bend_a.MemberOf              = {'BendPS', 'PowerSupply'};
AO.bend_a.DeviceList            = getDeviceList(5,10);
AO.bend_a.ElementList           = (1:size(AO.bend_a.DeviceList,1))';
AO.bend_a.Status                = ones(size(AO.bend_a.DeviceList,1),1);
AO.bend_a.Magnet                = 'B';
AO.bend_a.Monitor.MemberOf      = {};
AO.bend_a.Monitor.Mode          = 'Simulator';
AO.bend_a.Monitor.DataType      = 'Scalar';
AO.bend_a.Monitor.ChannelNames  = repmat(sirius_bo_getname(AO.bend_a.FamilyName, 'Monitor'), size(AO.bend_a.DeviceList, 1), 1);
AO.bend_a.Monitor.Units         = 'Hardware';
AO.bend_a.Monitor.HWUnits       = 'Ampere';
AO.bend_a.Setpoint.MemberOf     = {'MachineConfig'};
AO.bend_a.Setpoint.Mode         = 'Simulator';
AO.bend_a.Setpoint.DataType     = 'Scalar';
AO.bend_a.Setpoint.ChannelNames = repmat(sirius_bo_getname(AO.bend_a.FamilyName, 'Setpoint'), size(AO.bend_a.DeviceList, 1), 1);
AO.bend_a.Setpoint.SpecialFunctionSet = @sirius_bo_bendset;
AO.bend_a.Setpoint.Units        = 'Hardware';
AO.bend_a.Setpoint.HWUnits      = 'Ampere';
AO.bend_a.Setpoint.Range        = [0 300];
AO.bend_a.Setpoint.Tolerance    = .1;
AO.bend_a.Setpoint.DeltaRespMat = .01;

AO.bend_b.FamilyName            = 'bend_b';
AO.bend_b.MemberOf              = {'BendPS', 'PowerSupply'};
AO.bend_b.DeviceList            = getDeviceList(5,10);
AO.bend_b.ElementList           = (1:size(AO.bend_b.DeviceList,1))';
AO.bend_b.Status                = ones(size(AO.bend_b.DeviceList,1),1);
AO.bend_b.Magnet                = 'B';
AO.bend_b.Monitor.MemberOf      = {};
AO.bend_b.Monitor.Mode          = 'Simulator';
AO.bend_b.Monitor.DataType      = 'Scalar';
AO.bend_b.Monitor.ChannelNames  = repmat(sirius_bo_getname(AO.bend_b.FamilyName, 'Monitor'), size(AO.bend_b.DeviceList, 1), 1);
AO.bend_b.Monitor.Units         = 'Hardware';
AO.bend_b.Monitor.HWUnits       = 'Ampere';
AO.bend_b.Setpoint.MemberOf     = {'MachineConfig'};
AO.bend_b.Setpoint.Mode         = 'Simulator';
AO.bend_b.Setpoint.DataType     = 'Scalar';
AO.bend_b.Setpoint.ChannelNames = repmat(sirius_bo_getname(AO.bend_b.FamilyName, 'Setpoint'), size(AO.bend_b.DeviceList, 1), 1);
AO.bend_b.Setpoint.SpecialFunctionSet = @sirius_bo_bendset;
AO.bend_b.Setpoint.Units        = 'Hardware';
AO.bend_b.Setpoint.HWUnits      = 'Ampere';
AO.bend_b.Setpoint.Range        = [0 300];
AO.bend_b.Setpoint.Tolerance    = .1;
AO.bend_b.Setpoint.DeltaRespMat = .01;

% QUADS
AO.QD.FamilyName  = 'QD';
AO.QD.MemberOf    = {'PlotFamily'; 'QD'; 'QUAD'; 'Magnet'; 'Tune Corrector'};
AO.QD.DeviceList  = getDeviceList(5,5);
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
AO.QD.Monitor.ChannelNames = repmat(sirius_bo_getname('QD_fam', 'Monitor'), size(AO.QD.DeviceList,1), 1);
AO.QD.Monitor.HW2PhysicsFcn  = @sirius_hw2ph;
AO.QD.Monitor.Physics2HWFcn  = @sirius_ph2hw;
AO.QD.Setpoint.MemberOf      = {'MachineConfig'};
AO.QD.Setpoint.Mode          = 'Simulator';
AO.QD.Setpoint.DataType      = 'Scalar';
AO.QD.Setpoint.Units         = 'Hardware';
AO.QD.Setpoint.HWUnits       = 'Ampere';
AO.QD.Setpoint.PhysicsUnits  = 'meter^-2';
AO.QD.Setpoint.ChannelNames  = repmat(sirius_bo_getname('QD_fam', 'Setpoint'), size(AO.QD.DeviceList,1), 1);
AO.QD.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.QD.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.QD.Setpoint.Range         = [-5 5];
AO.QD.Setpoint.Tolerance     = 0.002;
AO.QD.Setpoint.DeltaRespMat  = 0.05;

AO.QF.FamilyName = 'QF';
AO.QF.MemberOf    = {'PlotFamily'; 'QF'; 'QUAD'; 'Magnet'; 'Tune Corrector'};
AO.QF.DeviceList  = getDeviceList(5,10);
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
AO.QF.Monitor.ChannelNames = repmat(sirius_bo_getname('QF_fam', 'Monitor'), size(AO.QF.DeviceList,1), 1);
AO.QF.Monitor.HW2PhysicsFcn  = @sirius_hw2ph;
AO.QF.Monitor.Physics2HWFcn  = @sirius_ph2hw;
AO.QF.Setpoint.MemberOf      = {'MachineConfig'};
AO.QF.Setpoint.Mode          = 'Simulator';
AO.QF.Setpoint.DataType      = 'Scalar';
AO.QF.Setpoint.Units         = 'Hardware';
AO.QF.Setpoint.HWUnits       = 'Ampere';
AO.QF.Setpoint.PhysicsUnits  = 'meter^-2';
AO.QF.Setpoint.ChannelNames = repmat(sirius_bo_getname('QF_fam', 'Setpoint'), size(AO.QF.DeviceList,1), 1);
AO.QF.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.QF.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.QF.Setpoint.Range         = [-5 5];
AO.QF.Setpoint.Tolerance     = 0.002;
AO.QF.Setpoint.DeltaRespMat  = 0.05;

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
AO.QS.Monitor.ChannelNames = repmat(sirius_bo_getname('QS_fam', 'Monitor'), size(AO.QS.DeviceList,1), 1);
AO.QS.Monitor.HW2PhysicsFcn  = @sirius_hw2ph;
AO.QS.Monitor.Physics2HWFcn  = @sirius_ph2hw;
AO.QS.Setpoint.MemberOf      = {'MachineConfig'};
AO.QS.Setpoint.Mode          = 'Simulator';
AO.QS.Setpoint.DataType      = 'Scalar';
AO.QS.Setpoint.Units         = 'Hardware';
AO.QS.Setpoint.HWUnits       = 'Ampere';
AO.QS.Setpoint.PhysicsUnits  = 'meter^-2';
AO.QS.Setpoint.ChannelNames = repmat(sirius_bo_getname('QS_fam', 'Setpoint'), size(AO.QS.DeviceList,1), 1);
AO.QS.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.QS.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.QS.Setpoint.Range         = [-5 5];
AO.QS.Setpoint.Tolerance     = 0.002;
AO.QS.Setpoint.DeltaRespMat  = 0.05;

%SEXT
AO.SD.FamilyName = 'SD';
AO.SD.MemberOf    = {'PlotFamily'; 'SD'; 'SEXT'; 'Magnet'; 'Chromaticity Corrector'};
AO.SD.DeviceList  = getDeviceList(5,2);
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
AO.SD.Monitor.ChannelNames = repmat(sirius_bo_getname('SD_fam', 'Monitor'), size(AO.SD.DeviceList,1), 1);
AO.SD.Monitor.HW2PhysicsFcn  = @sirius_hw2ph;
AO.SD.Monitor.Physics2HWFcn  = @sirius_ph2hw;
AO.SD.Setpoint.MemberOf      = {'MachineConfig'};
AO.SD.Setpoint.Mode          = 'Simulator';
AO.SD.Setpoint.DataType      = 'Scalar';
AO.SD.Setpoint.Units         = 'Hardware';
AO.SD.Setpoint.HWUnits       = 'Ampere';
AO.SD.Setpoint.PhysicsUnits  = 'meter^-3';
AO.SD.Setpoint.ChannelNames  = repmat(sirius_bo_getname('SD_fam', 'Setpoint'), size(AO.SD.DeviceList,1), 1);
AO.SD.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.SD.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.SD.Setpoint.Range         = [-500 500];
AO.SD.Setpoint.Tolerance     = 0.05;
AO.SD.Setpoint.DeltaRespMat  = 0.1;

AO.SF.FamilyName = 'SF';
AO.SF.MemberOf    = {'PlotFamily'; 'SF'; 'SEXT'; 'Magnet'; 'Chromaticity Corrector'};
AO.SF.DeviceList  = getDeviceList(5,5);
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
AO.SF.Monitor.ChannelNames = repmat(sirius_bo_getname('SF_fam', 'Monitor'), size(AO.SF.DeviceList,1), 1);
AO.SF.Monitor.HW2PhysicsFcn  = @sirius_hw2ph;
AO.SF.Monitor.Physics2HWFcn  = @sirius_ph2hw;
AO.SF.Setpoint.MemberOf      = {'MachineConfig'};
AO.SF.Setpoint.Mode          = 'Simulator';
AO.SF.Setpoint.DataType      = 'Scalar';
AO.SF.Setpoint.Units         = 'Hardware';
AO.SF.Setpoint.HWUnits       = 'Ampere';
AO.SF.Setpoint.PhysicsUnits  = 'meter^-3';
AO.SF.Setpoint.ChannelNames = repmat(sirius_bo_getname('SF_fam', 'Setpoint'), size(AO.SF.DeviceList,1), 1);
AO.SF.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.SF.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.SF.Setpoint.Range         = [-500 500];
AO.SF.Setpoint.Tolerance     = 0.05;
AO.SF.Setpoint.DeltaRespMat  = 0.1;

% HCM
AO.CH.FamilyName  = 'CH';
AO.CH.MemberOf    = {'PlotFamily'; 'COR'; 'CH'; 'Magnet'; 'HCM'};
AO.CH.DeviceList  = getDeviceList(5,5);
AO.CH.ElementList = (1:size(AO.CH.DeviceList,1))';
AO.CH.Status      = ones(size(AO.CH.DeviceList,1),1);
AO.CH.Position    = [];
AO.CH.ExcitationCurves = sirius_getexcdata(repmat('bo-corrector-ch', size(AO.CH.DeviceList,1), 1));
AO.CH.Monitor.MemberOf = {'Horizontal'; 'COR'; 'CH'; 'Magnet';};
AO.CH.Monitor.Mode = 'Simulator';
AO.CH.Monitor.DataType = 'Scalar';
AO.CH.Monitor.Units        = 'Physics';
AO.CH.Monitor.HWUnits      = 'Ampere';
AO.CH.Monitor.PhysicsUnits = 'Radian';
AO.CH.Monitor.ChannelNames = sirius_bo_getname(AO.CH.FamilyName, 'Monitor', AO.CH.DeviceList) ;
AO.CH.Monitor.HW2PhysicsFcn  = @sirius_hw2ph;
AO.CH.Monitor.Physics2HWFcn  = @sirius_ph2hw;
AO.CH.Setpoint.MemberOf = {'MaCHineConfig'; 'Horizontal'; 'COR'; 'CH'; 'Magnet'; 'Setpoint'; 'measbpmresp';};
AO.CH.Setpoint.Mode = 'Simulator';
AO.CH.Setpoint.DataType = 'Scalar';
AO.CH.Setpoint.Units        = 'Physics';
AO.CH.Setpoint.HWUnits      = 'Ampere';
AO.CH.Setpoint.PhysicsUnits = 'Radian';
AO.CH.Setpoint.ChannelNames = sirius_bo_getname(AO.CH.FamilyName, 'Setpoint', AO.CH.DeviceList);
AO.CH.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.CH.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.CH.Setpoint.Range        = [-10 10];
AO.CH.Setpoint.Tolerance    = 0.00001;
AO.CH.Setpoint.DeltaRespMat = 0.0005;


% VCM
AO.CV.FamilyName  = 'CV';
AO.CV.MemberOf    = {'PlotFamily'; 'COR'; 'CV'; 'Magnet'; 'VCM'};
AO.CV.DeviceList  = getDeviceList(5,5);
AO.CV.ElementList = (1:size(AO.CV.DeviceList,1))';
AO.CV.Status      = ones(size(AO.CV.DeviceList,1),1);
AO.CV.Position    = [];
AO.CV.ExcitationCurves = sirius_getexcdata(repmat('bo-corrector-cv', size(AO.CV.DeviceList,1), 1));
AO.CV.Monitor.MemberOf = {'Vertical'; 'COR'; 'CV'; 'Magnet';};
AO.CV.Monitor.Mode = 'Simulator';
AO.CV.Monitor.DataType = 'Scalar';
AO.CV.Monitor.Units        = 'Physics';
AO.CV.Monitor.HWUnits      = 'Ampere';
AO.CV.Monitor.PhysicsUnits = 'Radian';
AO.CV.Monitor.ChannelNames = sirius_bo_getname(AO.CV.FamilyName, 'Monitor', AO.CV.DeviceList) ;
AO.CV.Monitor.HW2PhysicsFcn  = @sirius_hw2ph;
AO.CV.Monitor.Physics2HWFcn  = @sirius_ph2hw;
AO.CV.Setpoint.MemberOf = {'MachineConfig'; 'Vertical'; 'COR'; 'CV'; 'Magnet'; 'Setpoint'; 'measbpmresp';};
AO.CV.Setpoint.Mode = 'Simulator';
AO.CV.Setpoint.DataType = 'Scalar';
AO.CV.Setpoint.Units        = 'Physics';
AO.CV.Setpoint.HWUnits      = 'Ampere';
AO.CV.Setpoint.PhysicsUnits = 'Radian';
AO.CV.Setpoint.ChannelNames = sirius_bo_getname(AO.CV.FamilyName, 'Setpoint', AO.CV.DeviceList);
AO.CV.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.CV.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.CV.Setpoint.Range        = [-10 10];
AO.CV.Setpoint.Tolerance    = 0.00001;
AO.CV.Setpoint.DeltaRespMat = 0.0005;

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
AO.bpmx.Monitor.HW2PhysicsParams = 1e-6;  % HW [mm], Simulator [Meters]
AO.bpmx.Monitor.Physics2HWParams =  1e6;
AO.bpmx.Monitor.Units        = 'Hardware';
AO.bpmx.Monitor.HWUnits      = 'um';
AO.bpmx.Monitor.PhysicsUnits = 'meter';
AO.bpmx.Monitor.ChannelNames = sirius_bo_getname(AO.bpmx.FamilyName, 'Monitor', AO.bpmx.DeviceList) ;

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
AO.bpmy.Monitor.HW2PhysicsParams = 1e-6;  % HW [mm], Simulator [Meters]
AO.bpmy.Monitor.Physics2HWParams =  1e6;
AO.bpmy.Monitor.Units        = 'Hardware';
AO.bpmy.Monitor.HWUnits      = 'um';
AO.bpmy.Monitor.PhysicsUnits = 'meter';
AO.bpmy.Monitor.ChannelNames = sirius_bo_getname(AO.bpmy.FamilyName, 'Monitor', AO.bpmy.DeviceList) ;

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
AO.TUNE.Monitor.ChannelNames = sirius_bo_getname(AO.TUNE.FamilyName, 'Monitor');
AO.TUNE.Monitor.Mode = 'Simulator';
AO.TUNE.Monitor.DataType = 'Scalar';
AO.TUNE.Monitor.HW2PhysicsParams = 1;
AO.TUNE.Monitor.Physics2HWParams = 1;
AO.TUNE.Monitor.Units        = 'Hardware';
AO.TUNE.Monitor.HWUnits      = 'Tune';
AO.TUNE.Monitor.PhysicsUnits = 'Tune';

%%%%%%%%%%
%   RF   %
%%%%%%%%%%
AO.RF.FamilyName                = 'P5Cav';
AO.RF.MemberOf                  = {'P5Cav';'RF'; 'RFSystem'};
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
AO.RF.Monitor.ChannelNames      = sirius_bo_getname(AO.RF.FamilyName, 'Monitor') ;

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
AO.RF.Setpoint.ChannelNames     = sirius_bo_getname(AO.RF.FamilyName, 'Setpoint') ;

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

AO.RF.Phase.MemberOf          = {'P5Cav'; 'RF'; 'Phase'};
AO.RF.Phase.Mode              = 'Simulator';
AO.RF.Phase.DataType          = 'Scalar';
AO.RF.Phase.ChannelNames      = 'SRF1:STN:PHASE:CALC';    % ???
AO.RF.Phase.Units             = 'Hardware';
AO.RF.Phase.HW2PhysicsParams  = 1;
AO.RF.Phase.Physics2HWParams  = 1;
AO.RF.Phase.HWUnits           = 'Degrees';
AO.RF.Phase.PhysicsUnits      = 'Degrees';

AO.RF.PhaseCtrl.MemberOf          = {'P5Cav'; 'RF; Phase'; 'Control'};  % 'MachineConfig';
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
AO.DCCT.Monitor.ChannelNames     = repmat(sirius_bo_getname(AO.DCCT.FamilyName, 'Monitor'), size(AO.DCCT.DeviceList,1), 1);

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
