function sirius_init
%SIRIUSINIT - MML initialization file for the VUV ring at sirius3
% 
%  See also setoperationalmode

% 2012-07-10 Modificado para sirius3_lattice_e025 - Afonso


setao([]);
setad([]);

% Base on the location of this file
[SIRIUS_ROOT, ~, ~] = fileparts(mfilename('fullpath'));

AD.Directory.ExcDataDir  = '/home/fac_files/siriusdb/excitation_curves';

%AD.Directory.ExcDataDir = [SIRIUS_ROOT, filesep, 'excitation_curves'];
AD.Directory.LatticesDef = [SIRIUS_ROOT, filesep, 'lattices_def'];
setad(AD);

% Add additional directories with SIRIUS_V03 specific stuff.
%MMLROOT = getmmlroot('IgnoreTheAD');
%addpath(fullfile(MMLROOT,'machine','SIRIUS_V03','StorageRing','scripts'), '-begin');


%% dipoles

AO.b1.FamilyName  = 'b1';
AO.b1.MemberOf    = {'PlotFamily'; 'b1'; 'BEND'; 'Magnet';};
AO.b1.DeviceList  = getDeviceList(10,4);
AO.b1.ElementList = (1:size(AO.b1.DeviceList,1))';
AO.b1.Status      = ones(size(AO.b1.DeviceList,1),1);
AO.b1.Position    = [];
AO.b1.ExcitationCurves = sirius_getexcdata(repmat('sima-b1',size(AO.b1.DeviceList,1),1)); 

AO.b1.Monitor.MemberOf = {};
AO.b1.Monitor.Mode = 'Simulator';
AO.b1.Monitor.DataType = 'Scalar';
AO.b1.Monitor.ChannelNames = repmat(sirius_si_getname(AO.b1.FamilyName, 'Monitor'), size(AO.b1.DeviceList,1),1);
AO.b1.Monitor.HW2PhysicsFcn = @bend2gev;
AO.b1.Monitor.Physics2HWFcn = @gev2bend;
AO.b1.Monitor.Units        = 'Hardware';
AO.b1.Monitor.HWUnits      = 'Ampere';
AO.b1.Monitor.PhysicsUnits = 'GeV';

AO.b1.Setpoint.MemberOf = {'MachineConfig';};
AO.b1.Setpoint.Mode = 'Simulator';
AO.b1.Setpoint.DataType = 'Scalar';
AO.b1.Setpoint.ChannelNames = repmat(sirius_si_getname(AO.b1.FamilyName, 'Setpoint'), size(AO.b1.DeviceList,1),1);
AO.b1.Setpoint.HW2PhysicsFcn = @bend2gev;
AO.b1.Setpoint.Physics2HWFcn = @gev2bend;
AO.b1.Setpoint.Units        = 'Hardware';
AO.b1.Setpoint.HWUnits      = 'Ampere';
AO.b1.Setpoint.PhysicsUnits = 'GeV';
AO.b1.Setpoint.Range        = [0 300];
AO.b1.Setpoint.Tolerance    = .1;
AO.b1.Setpoint.DeltaRespMat = .01;


AO.b2.FamilyName  = 'b2';
AO.b2.MemberOf    = {'PlotFamily'; 'b2'; 'BEND'; 'Magnet';};
AO.b2.DeviceList  = getDeviceList(10,4);
AO.b2.ElementList = (1:size(AO.b2.DeviceList,1))';
AO.b2.Status      = ones(size(AO.b2.DeviceList,1),1);
AO.b2.Position    = [];
AO.b2.ExcitationCurves = sirius_getexcdata(repmat('sima-b2',size(AO.b2.DeviceList,1),1)); 

AO.b2.Monitor.MemberOf = {};
AO.b2.Monitor.Mode = 'Simulator';
AO.b2.Monitor.DataType = 'Scalar';
AO.b2.Monitor.ChannelNames = repmat(sirius_si_getname(AO.b2.FamilyName, 'Monitor'), size(AO.b2.DeviceList,1),1);
AO.b2.Monitor.HW2PhysicsFcn = @bend2gev;
AO.b2.Monitor.Physics2HWFcn = @gev2bend;
AO.b2.Monitor.Units        = 'Hardware';
AO.b2.Monitor.HWUnits      = 'Ampere';
AO.b2.Monitor.PhysicsUnits = 'GeV';

AO.b2.Setpoint.MemberOf = {'MachineConfig';};
AO.b2.Setpoint.Mode = 'Simulator';
AO.b2.Setpoint.DataType = 'Scalar';
AO.b2.Setpoint.ChannelNames = repmat(sirius_si_getname(AO.b2.FamilyName, 'Setpoint'), size(AO.b2.DeviceList,1),1);
AO.b2.Setpoint.HW2PhysicsFcn = @bend2gev;
AO.b2.Setpoint.Physics2HWFcn = @gev2bend;
AO.b2.Setpoint.Units        = 'Hardware';
AO.b2.Setpoint.HWUnits      = 'Ampere';
AO.b2.Setpoint.PhysicsUnits = 'GeV';
AO.b2.Setpoint.Range        = [0 300];
AO.b2.Setpoint.Tolerance    = .1;
AO.b2.Setpoint.DeltaRespMat = .01;

AO.bc.FamilyName  = 'bc';
AO.bc.MemberOf    = {'si-bc'; }; 
AO.bc.DeviceList  = getDeviceList(10,2);
AO.bc.ElementList = (1:size(AO.bc.DeviceList,1))';
AO.bc.Status      = ones(size(AO.bc.DeviceList,1),1);
AO.bc.Position    = [];

%% quadrupoles 
AO = get_AO_quads(AO,'qfa', 'q20',2);
AO = get_AO_quads(AO,'qda', 'q14',2);
AO = get_AO_quads(AO,'qfb', 'q30',4);
AO = get_AO_quads(AO,'qdb2','q14',4);
AO = get_AO_quads(AO,'qdb1','q14',4);
AO = get_AO_quads(AO,'qfp', 'q30',2);
AO = get_AO_quads(AO,'qdp2','q14',2);
AO = get_AO_quads(AO,'qdp1','q14',2);
AO = get_AO_quads(AO,'q1',  'q20',8);
AO = get_AO_quads(AO,'q2',  'q20',8);
AO = get_AO_quads(AO,'q3',  'q20',8);
AO = get_AO_quads(AO,'q4',  'q20',8);


%% sextupoles

AO = get_AO_sexts(AO,'sda0', 2);
AO = get_AO_sexts(AO,'sdba0',2);
AO = get_AO_sexts(AO,'sdbp0',2);
AO = get_AO_sexts(AO,'sdp0', 2);
AO = get_AO_sexts(AO,'sda1', 2);
AO = get_AO_sexts(AO,'sdba1',2);
AO = get_AO_sexts(AO,'sdbp1',2);
AO = get_AO_sexts(AO,'sdp1', 2);
AO = get_AO_sexts(AO,'sda2', 2);
AO = get_AO_sexts(AO,'sdba2',2);
AO = get_AO_sexts(AO,'sdbp2',2);
AO = get_AO_sexts(AO,'sdp2', 2);
AO = get_AO_sexts(AO,'sda3', 2);
AO = get_AO_sexts(AO,'sdba3',2);
AO = get_AO_sexts(AO,'sdbp3',2);
AO = get_AO_sexts(AO,'sdp3', 2);
AO = get_AO_sexts(AO,'sfa0', 2);
AO = get_AO_sexts(AO,'sfba0',2);
AO = get_AO_sexts(AO,'sfbp0',2);
AO = get_AO_sexts(AO,'sfp0', 2);
AO = get_AO_sexts(AO,'sfa1', 2);
AO = get_AO_sexts(AO,'sfba1',2);
AO = get_AO_sexts(AO,'sfbp1',2);
AO = get_AO_sexts(AO,'sfp1', 2);
AO = get_AO_sexts(AO,'sfa2', 2);
AO = get_AO_sexts(AO,'sfba2',2);
AO = get_AO_sexts(AO,'sfbp2',2);
AO = get_AO_sexts(AO,'sfp2', 2);


%% correctors

% ch
AO.ch.FamilyName  = 'ch';
AO.ch.MemberOf    = {'PlotFamily'; 'COR'; 'ch'; 'Magnet';'hcm';'hcm_slow';};
AO.ch.DeviceList  = getDeviceList(10, 12);
AO.ch.ElementList = (1:size(AO.ch.DeviceList,1))';
AO.ch.Status      = ones(size(AO.ch.DeviceList,1),1);
AO.ch.Position    = [];
AO.ch.ExcitationCurves = sirius_getexcdata(repmat('sima-ch',size(AO.ch.DeviceList,1),1));
AO.ch.Monitor.MemberOf = {'Horizontal'; 'COR'; 'ch'; 'Magnet';};
AO.ch.Monitor.Mode     = 'Simulator';
AO.ch.Monitor.DataType = 'Scalar';
AO.ch.Monitor.ChannelNames = sirius_si_getname(AO.ch.FamilyName, 'Monitor', AO.ch.DeviceList);
AO.ch.Monitor.Units        = 'Physics'; % ?
AO.ch.Monitor.HWUnits      = 'Ampere';
AO.ch.Monitor.PhysicsUnits = 'Radian';
AO.ch.Monitor.HW2PhysicsFcn  = @sirius_hw2ph;
AO.ch.Monitor.Physics2HWFcn  = @sirius_ph2hw;
AO.ch.Setpoint.MemberOf = {'MachineConfig'; 'Horizontal'; 'COR'; 'hcm'; 'Magnet'; 'Setpoint'; 'measbpmresp';};
AO.ch.Setpoint.Mode = 'Simulator';
AO.ch.Setpoint.DataType = 'Scalar';
AO.ch.Setpoint.ChannelNames = sirius_si_getname(AO.ch.FamilyName, 'Setpoint', AO.ch.DeviceList);
AO.ch.Setpoint.Units        = 'Physics';
AO.ch.Setpoint.HWUnits      = 'Ampere';
AO.ch.Setpoint.PhysicsUnits = 'Radian';
AO.ch.Setpoint.HW2PhysicsFcn  = @sirius_hw2ph;
AO.ch.Setpoint.Physics2HWFcn  = @sirius_ph2hw;
AO.ch.Setpoint.Range        = [-10 10];
AO.ch.Setpoint.Tolerance    = 0.00001;
AO.ch.Setpoint.DeltaRespMat =  5e-4; 

% cv
AO.cv.FamilyName  = 'cv';
AO.cv.MemberOf    = {'PlotFamily'; 'COR'; 'cv'; 'Magnet';'vcm';'vcm_slow';};
AO.cv.DeviceList  = getDeviceList(10, 16);
AO.cv.ElementList = (1:size(AO.cv.DeviceList,1))';
AO.cv.Status      = ones(size(AO.cv.DeviceList,1),1);
AO.cv.Position    = [];
AO.cv.ExcitationCurves = sirius_getexcdata(repmat('sima-cv',size(AO.cv.DeviceList,1),1));
AO.cv.Monitor.MemberOf = {'Horizontal'; 'COR'; 'cv'; 'Magnet';};
AO.cv.Monitor.Mode     = 'Simulator';
AO.cv.Monitor.DataType = 'Scalar';
AO.cv.Monitor.ChannelNames = sirius_si_getname(AO.cv.FamilyName, 'Monitor', AO.cv.DeviceList);
AO.cv.Monitor.Units        = 'Physics';
AO.cv.Monitor.HWUnits      = 'Ampere';
AO.cv.Monitor.PhysicsUnits = 'Radian';
AO.cv.Monitor.HW2PhysicsFcn  = @sirius_hw2ph;
AO.cv.Monitor.Physics2HWFcn  = @sirius_ph2hw;
AO.cv.Setpoint.MemberOf = {'MachineConfig'; 'Horizontal'; 'COR'; 'vcm'; 'Magnet'; 'Setpoint'; 'measbpmresp';};
AO.cv.Setpoint.Mode = 'Simulator';
AO.cv.Setpoint.DataType = 'Scalar';
AO.cv.Setpoint.ChannelNames = sirius_si_getname(AO.cv.FamilyName, 'Setpoint', AO.cv.DeviceList);
AO.cv.Setpoint.Units        = 'Physics';
AO.cv.Setpoint.HWUnits      = 'Ampere';
AO.cv.Setpoint.PhysicsUnits = 'Radian';
AO.cv.Setpoint.HW2PhysicsFcn  = @sirius_hw2ph;
AO.cv.Setpoint.Physics2HWFcn  = @sirius_ph2hw;
AO.cv.Setpoint.Range        = [-10 10];
AO.cv.Setpoint.Tolerance    = 0.00001;
AO.cv.Setpoint.DeltaRespMat =  5e-4; 

% fch
AO.fch.FamilyName  = 'fch';
AO.fch.MemberOf    = {'PlotFamily'; 'COR'; 'fch'; 'Magnet';'hcm';'hcm_fast';};
AO.fch.DeviceList  = getDeviceList(10, 8);
AO.fch.DeviceList([8,15,16,80],:) = []; % subtracts fast correctors from injection and cavity sectors
AO.fch.ElementList = (1:size(AO.fch.DeviceList,1))';
AO.fch.Status      = ones(size(AO.fch.DeviceList,1),1);
AO.fch.Position    = [];
AO.fch.ExcitationCurves = sirius_getexcdata(repmat('sima-ch',size(AO.fch.DeviceList,1),1));
AO.fch.Monitor.MemberOf = {'Horizontal'; 'COR'; 'fch'; 'Magnet';};
AO.fch.Monitor.Mode     = 'Simulator';
AO.fch.Monitor.DataType = 'Scalar';
AO.fch.Monitor.ChannelNames  = sirius_si_getname(AO.fch.FamilyName, 'Monitor', AO.fch.DeviceList);
AO.fch.Monitor.Units         = 'Physics';
AO.fch.Monitor.HWUnits       = 'Ampere';
AO.fch.Monitor.PhysicsUnits  = 'Radian';
AO.fch.Monitor.HW2PhysicsFcn  = @sirius_hw2ph;
AO.fch.Monitor.Physics2HWFcn  = @sirius_ph2hw;
AO.fch.Setpoint.MemberOf     = {'MachineConfig'; 'Horizontal'; 'COR'; 'hcm'; 'Magnet'; 'Setpoint'; 'measbpmresp';};
AO.fch.Setpoint.Mode         = 'Simulator';
AO.fch.Setpoint.DataType     = 'Scalar';
AO.fch.Setpoint.ChannelNames = sirius_si_getname(AO.fch.FamilyName, 'Setpoint', AO.fch.DeviceList);
AO.fch.Setpoint.Units        = 'Physics';
AO.fch.Setpoint.HWUnits      = 'Ampere';
AO.fch.Setpoint.PhysicsUnits = 'Radian';
AO.fch.Setpoint.HW2PhysicsFcn  = @sirius_hw2ph;
AO.fch.Setpoint.Physics2HWFcn  = @sirius_ph2hw;
AO.fch.Setpoint.Range        = [-10 10];
AO.fch.Setpoint.Tolerance    = 0.00001;
AO.fch.Setpoint.DeltaRespMat =  5e-4; 

% fcv
AO.fcv.FamilyName  = 'fcv';
AO.fcv.MemberOf    = {'PlotFamily'; 'COR'; 'fcv'; 'Magnet';'vcm';'vcm_fast';};
AO.fcv.DeviceList  = getDeviceList(10, 8);
AO.fcv.DeviceList([8,15,16,80],:) = []; % subtracts fast correctors from injection and cavity sectors
AO.fcv.ElementList = (1:size(AO.fcv.DeviceList,1))';
AO.fcv.Status      = ones(size(AO.fcv.DeviceList,1),1);
AO.fcv.Position    = [];
AO.fcv.ExcitationCurves = sirius_getexcdata(repmat('sima-cv',size(AO.fcv.DeviceList,1),1));
AO.fcv.Monitor.MemberOf = {'Horizontal'; 'COR'; 'fcv'; 'Magnet';};
AO.fcv.Monitor.Mode     = 'Simulator';
AO.fcv.Monitor.DataType = 'Scalar';
AO.fcv.Monitor.ChannelNames  = sirius_si_getname(AO.fcv.FamilyName, 'Monitor', AO.fcv.DeviceList);
AO.fcv.Monitor.Units        = 'Physics';
AO.fcv.Monitor.HWUnits      = 'Ampere';
AO.fcv.Monitor.PhysicsUnits = 'Radian';
AO.fcv.Monitor.HW2PhysicsFcn  = @sirius_hw2ph;
AO.fcv.Monitor.Physics2HWFcn  = @sirius_ph2hw;
AO.fcv.Setpoint.MemberOf = {'MachineConfig'; 'Horizontal'; 'COR'; 'vcm'; 'Magnet'; 'Setpoint'; 'measbpmresp';};
AO.fcv.Setpoint.Mode = 'Simulator';
AO.fcv.Setpoint.DataType = 'Scalar';
AO.fcv.Setpoint.ChannelNames  = sirius_si_getname(AO.fcv.FamilyName, 'Setpoint', AO.fcv.DeviceList);
AO.fcv.Setpoint.Units        = 'Physics';
AO.fcv.Setpoint.HWUnits      = 'Ampere';
AO.fcv.Setpoint.PhysicsUnits = 'Radian';
AO.fcv.Setpoint.HW2PhysicsFcn  = @sirius_hw2ph;
AO.fcv.Setpoint.Physics2HWFcn  = @sirius_ph2hw;
AO.fcv.Setpoint.Range        = [-10 10];
AO.fcv.Setpoint.Tolerance    = 0.00001;
AO.fcv.Setpoint.DeltaRespMat =  5e-4; 

% qs
AO.qs.FamilyName  = 'qs';
AO.qs.MemberOf    = {'PlotFamily'; 'COR'; 'qs'; 'Magnet'; 'SkewQuad'};
AO.qs.DeviceList  = getDeviceList(10, 8);
AO.qs.ElementList = (1:size(AO.qs.DeviceList,1))';
AO.qs.Status      = ones(size(AO.qs.DeviceList,1),1);
AO.qs.Position    = [];
AO.qs.ExcitationCurves = sirius_getexcdata(repmat('sima-qs',size(AO.qs.DeviceList,1),1));
AO.qs.Monitor.MemberOf = {'Horizontal'; 'COR'; 'qs'; 'Magnet';};
AO.qs.Monitor.ChannelNames = sirius_si_getname(AO.qs.FamilyName, 'Monitor', AO.qs.DeviceList);
AO.qs.Monitor.Mode     = 'Simulator';
AO.qs.Monitor.DataType = 'Scalar';
AO.qs.Monitor.Units        = 'Physics';
AO.qs.Monitor.HWUnits      = 'Ampere';
AO.qs.Monitor.PhysicsUnits = 'Radian';
AO.qs.Monitor.HW2PhysicsFcn  = @sirius_hw2ph;
AO.qs.Monitor.Physics2HWFcn  = @sirius_ph2hw;
AO.qs.Setpoint.MemberOf = {'MachineConfig'; 'Horizontal'; 'COR'; 'Magnet'; 'Setpoint'; 'measbpmresp';};
AO.qs.Setpoint.Mode = 'Simulator';
AO.qs.Setpoint.DataType = 'Scalar';
AO.qs.Setpoint.ChannelNames = sirius_si_getname(AO.qs.FamilyName, 'Setpoint', AO.qs.DeviceList);
AO.qs.Setpoint.Units        = 'Physics';
AO.qs.Setpoint.HWUnits      = 'Ampere';
AO.qs.Setpoint.PhysicsUnits = 'Radian';
AO.qs.Setpoint.HW2PhysicsFcn  = @sirius_hw2ph;
AO.qs.Setpoint.Physics2HWFcn  = @sirius_ph2hw;
AO.qs.Setpoint.Range        = [-10 10];
AO.qs.Setpoint.Tolerance    = 0.00001;
AO.qs.Setpoint.DeltaRespMat = 5e-4; 

% bpmx
AO.bpmx.FamilyName  = 'bpmx';
AO.bpmx.MemberOf    = {'PlotFamily'; 'bpm'; 'bpmx'; 'Diagnostics'};
AO.bpmx.DeviceList  = getDeviceList(10, 16);
AO.bpmx.ElementList = (1:size(AO.bpmx.DeviceList,1))';
AO.bpmx.Status      = ones(size(AO.bpmx.DeviceList,1),1);
AO.bpmx.Position    = [];
AO.bpmx.Golden      = zeros(length(AO.bpmx.ElementList),1);
AO.bpmx.Offset      = zeros(length(AO.bpmx.ElementList),1);

AO.bpmx.Monitor.MemberOf = {'bpmx'; 'Monitor';};
AO.bpmx.Monitor.ChannelNames = sirius_si_getname(AO.bpmx.FamilyName, 'Monitor', AO.bpmx.DeviceList);
AO.bpmx.Monitor.Mode = 'Simulator';
AO.bpmx.Monitor.DataType = 'Scalar';
AO.bpmx.Monitor.HW2PhysicsParams = 1e-6;  % HW [mm], Simulator [Meters]
AO.bpmx.Monitor.Physics2HWParams = 1e6;
AO.bpmx.Monitor.Units        = 'Hardware';
AO.bpmx.Monitor.HWUnits      = 'um';
AO.bpmx.Monitor.PhysicsUnits = 'meter';


% bpmy
AO.bpmy.FamilyName  = 'bpmy';
AO.bpmy.MemberOf    = {'PlotFamily'; 'bpm'; 'bpmy'; 'Diagnostics'};
AO.bpmy.DeviceList  = getDeviceList(10, 16);
AO.bpmy.ElementList = (1:size(AO.bpmy.DeviceList,1))';
AO.bpmy.Status      = ones(size(AO.bpmy.DeviceList,1),1);
AO.bpmy.Position    = [];
AO.bpmy.Golden      = zeros(length(AO.bpmy.ElementList),1);
AO.bpmy.Offset      = zeros(length(AO.bpmy.ElementList),1);

AO.bpmy.Monitor.MemberOf = {'bpmy'; 'Monitor';};
AO.bpmy.Monitor.ChannelNames = sirius_si_getname(AO.bpmy.FamilyName, 'Monitor', AO.bpmy.DeviceList);
AO.bpmy.Monitor.Mode = 'Simulator';
AO.bpmy.Monitor.DataType = 'Scalar';
AO.bpmy.Monitor.HW2PhysicsParams = 1e-6;  % HW [mm], Simulator [Meters]
AO.bpmy.Monitor.Physics2HWParams = 1e6;
AO.bpmy.Monitor.Units        = 'Hardware';
AO.bpmy.Monitor.HWUnits      = 'um';
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
AO.TUNE.Monitor.ChannelNames = sirius_si_getname(AO.TUNE.FamilyName, 'Monitor');
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
AO.RF.FamilyName                = 'RF';
AO.RF.MemberOf                  = {'RF'; 'RFSystem'};
AO.RF.DeviceList                = [ 1 1 ]; % ??
AO.RF.ElementList               = 1;
AO.RF.Status                    = 1;
AO.RF.Position                  = 0;

AO.RF.Monitor.MemberOf          = {};
AO.RF.Monitor.ChannelNames      = sirius_si_getname(AO.RF.FamilyName, 'Monitor');
AO.RF.Monitor.Mode              = 'Simulator';
AO.RF.Monitor.DataType          = 'Scalar';
% AO.RF.Monitor.HW2PhysicsParams  = 1e+6;
% AO.RF.Monitor.Physics2HWParams  = 1e-6;
AO.RF.Monitor.Units             = 'Hardware';
AO.RF.Monitor.HWUnits           = 'Hz';
AO.RF.Monitor.PhysicsUnits      = 'Hz';

AO.RF.Setpoint.MemberOf         = {'MachineConfig';};
AO.RF.Setpoint.ChannelNames      = sirius_si_getname(AO.RF.FamilyName, 'Setpoint');
AO.RF.Setpoint.Mode             = 'Simulator';
AO.RF.Setpoint.DataType         = 'Scalar';
% AO.RF.Setpoint.HW2PhysicsParams = 1e+6;
% AO.RF.Setpoint.Physics2HWParams = 1e-6;
AO.RF.Setpoint.Units            = 'Hardware';
AO.RF.Setpoint.HWUnits          = 'Hz';
AO.RF.Setpoint.PhysicsUnits     = 'Hz';
AO.RF.Setpoint.Range            = [-inf inf];
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
AO.DCCT.DeviceList               = [13, 1; 14, 1];
AO.DCCT.ElementList              = [1; 2];
AO.DCCT.Status                   = 1;
AO.DCCT.Position                 = [];

AO.DCCT.Monitor.MemberOf         = {};
AO.DCCT.Monitor.Mode             = 'Simulator';
AO.DCCT.Monitor.DataType         = 'Scalar';
AO.DCCT.Monitor.ChannelNames     = [];    
AO.DCCT.Monitor.HW2PhysicsParams = 1;    
AO.DCCT.Monitor.Physics2HWParams = 1;
AO.DCCT.Monitor.Units            = 'Hardware';
AO.DCCT.Monitor.HWUnits          = 'Ampere';     
AO.DCCT.Monitor.PhysicsUnits     = 'Ampere';
AO.DCCT.Monitor.ChannelNames     = repmat(sirius_si_getname(AO.DCCT.FamilyName, 'Monitor'), size(AO.DCCT.DeviceList,1), 1); 

% The operational mode sets the path, filenames, and other important parameters
% Run setoperationalmode after most of the AO is built so that the Units and Mode fields
% can be set in setoperationalmode
setao(AO);
%setoperationalmode(OperationalMode);

%sirius_comm_connect_inputdlg;



function A = get_AO_quads(A,fam,type,num_el_arc)

fam_shunt = [fam,'_shunt'];
fam_fam = [fam,'_fam'];

A.(fam).FamilyName = fam;
A.(fam).MemberOf    = {'PlotFamily'; fam; 'QUAD'; 'Magnet';type;'Tune Corrector'};
A.(fam).DeviceList  = getDeviceList(5, num_el_arc);
A.(fam).ElementList = (1:size(A.(fam).DeviceList,1))';
A.(fam).Status      = ones(size(A.(fam).DeviceList,1),1);
A.(fam).Position    = [];
A.(fam).FamilyPS    = fam_fam;
A.(fam).ShuntPS     = fam_shunt;
A.(fam).ExcitationCurves = sirius_getexcdata(repmat(['sima-',type],size(A.(fam).DeviceList,1),1)); 
A.(fam).Monitor.MemberOf      = {};
A.(fam).Monitor.Mode          = 'Simulator';
A.(fam).Monitor.DataType      = 'Scalar';
A.(fam).Monitor.Units         = 'Hardware';
A.(fam).Monitor.HWUnits       = 'Ampere';
A.(fam).Monitor.PhysicsUnits  = 'meter^-2';
A.(fam).Monitor.SpecialFunctionGet = @sirius_si_quadget;
A.(fam).Monitor.SpecialFunctionSet = @sirius_si_quadset;
A.(fam).Monitor.HW2PhysicsFcn  = @sirius_hw2ph;
A.(fam).Monitor.Physics2HWFcn  = @sirius_ph2hw;
A.(fam).Setpoint.MemberOf     = {'MachineConfig'};
A.(fam).Setpoint.Mode         = 'Simulator';
A.(fam).Setpoint.DataType     = 'Scalar';
A.(fam).Setpoint.Units        = 'Hardware';
A.(fam).Setpoint.HWUnits      = 'Ampere';
A.(fam).Setpoint.PhysicsUnits = 'meter^-2';
A.(fam).Setpoint.SpecialFunctionGet = @sirius_si_quadget;
A.(fam).Setpoint.SpecialFunctionSet = @sirius_si_quadset;
A.(fam).Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
A.(fam).Setpoint.Physics2HWFcn = @sirius_ph2hw;
A.(fam).Setpoint.Range        = [0 225];
A.(fam).Setpoint.Tolerance    = 0.2;
A.(fam).Setpoint.DeltaRespMat = 0.5; 

A.(fam_shunt).FamilyName = fam_shunt;
A.(fam_shunt).MemberOf    = {'PlotFamily'; fam_shunt;'PowerSupply'};
A.(fam_shunt).DeviceList  = getDeviceList(5, num_el_arc);
A.(fam_shunt).ElementList = (1:size(A.(fam_shunt).DeviceList,1))';
A.(fam_shunt).Status      = ones(size(A.(fam_shunt).DeviceList,1),1);
A.(fam_shunt).Position    = [];
A.(fam_shunt).Monitor.MemberOf      = {};
A.(fam_shunt).Monitor.Mode          = 'Simulator';
A.(fam_shunt).Monitor.DataType      = 'Scalar';
A.(fam_shunt).Monitor.ChannelNames  = sirius_si_getname(A.(fam).FamilyName, 'Monitor', A.(fam).DeviceList);
A.(fam_shunt).Monitor.Units         = 'Hardware';
A.(fam_shunt).Monitor.HWUnits       = 'Ampere';
A.(fam_shunt).Setpoint.MemberOf     = {'MachineConfig'};
A.(fam_shunt).Setpoint.Mode         = 'Simulator';
A.(fam_shunt).Setpoint.DataType     = 'Scalar';
A.(fam_shunt).Setpoint.ChannelNames = sirius_si_getname(A.(fam).FamilyName, 'Setpoint', A.(fam).DeviceList);
A.(fam_shunt).Setpoint.Units        = 'Hardware';
A.(fam_shunt).Setpoint.HWUnits      = 'Ampere';
A.(fam_shunt).Setpoint.Range        = [0 225];
A.(fam_shunt).Setpoint.Tolerance    = 0.2;
A.(fam_shunt).Setpoint.DeltaRespMat = 0.5; 

A.(fam_fam).FamilyName = fam_fam;
A.(fam_fam).MemberOf    = {'PlotFamily'; fam_fam; 'PowerSupply'};
A.(fam_fam).DeviceList  = getDeviceList(5, num_el_arc);
A.(fam_fam).ElementList = (1:size(A.(fam_fam).DeviceList,1))';
A.(fam_fam).Status      = ones(size(A.(fam_fam).DeviceList,1),1);
A.(fam_fam).Position    = [];
A.(fam_fam).Monitor.MemberOf      = {};
A.(fam_fam).Monitor.Mode          = 'Simulator';
A.(fam_fam).Monitor.DataType      = 'Scalar';
A.(fam_fam).Monitor.ChannelNames  = repmat(sirius_si_getname(A.(fam_fam).FamilyName, 'Monitor'), size(A.(fam_fam).DeviceList,1),1);
A.(fam_fam).Monitor.Units         = 'Hardware';
A.(fam_fam).Monitor.HWUnits       = 'Ampere';
A.(fam_fam).Setpoint.MemberOf     = {'MachineConfig'};
A.(fam_fam).Setpoint.Mode         = 'Simulator';
A.(fam_fam).Setpoint.DataType     = 'Scalar';
A.(fam_fam).Setpoint.ChannelNames = repmat(sirius_si_getname(A.(fam_fam).FamilyName, 'Setpoint'), size(A.(fam_fam).DeviceList,1),1);
A.(fam_fam).Setpoint.Units        = 'Hardware';
A.(fam_fam).Setpoint.HWUnits      = 'Ampere';
A.(fam_fam).Setpoint.Range        = [0 225];
A.(fam_fam).Setpoint.Tolerance    = 0.2;
A.(fam_fam).Setpoint.DeltaRespMat = 0.5;

function A = get_AO_sexts(A,fam,num_el_arc)

type = fam(1:2);
A.(fam).FamilyName = fam;
A.(fam).MemberOf    = {'PlotFamily'; fam; 'SEXT'; 'Magnet'; 'Chromaticity Corrector'};
A.(fam).DeviceList  = getDeviceList(5, num_el_arc);
A.(fam).ElementList = (1:size(A.(fam).DeviceList,1))';
A.(fam).Status      = ones(size(A.(fam).DeviceList,1),1);
A.(fam).Position    = [];
A.(fam).ExcitationCurves = sirius_getexcdata(repmat(['sima-',type],size(A.(fam).DeviceList,1),1));
A.(fam).Monitor.MemberOf = {};
A.(fam).Monitor.Mode = 'Simulator';
A.(fam).Monitor.DataType = 'Scalar';
A.(fam).Monitor.ChannelNames = repmat(sirius_si_getname([fam,'_fam'], 'Monitor'), size(A.(fam).DeviceList,1),1);
A.(fam).Monitor.Units        = 'Hardware';
A.(fam).Monitor.HWUnits      = 'Ampere';
A.(fam).Monitor.PhysicsUnits = 'meter^-3';
A.(fam).Monitor.HW2PhysicsFcn  = @sirius_hw2ph;
A.(fam).Monitor.Physics2HWFcn  = @sirius_ph2hw;
A.(fam).Setpoint.MemberOf      = {'MachineConfig'};
A.(fam).Setpoint.Mode          = 'Simulator';
A.(fam).Setpoint.DataType      = 'Scalar';
A.(fam).Setpoint.ChannelNames = repmat(sirius_si_getname([fam,'_fam'], 'Setpoint'), size(A.(fam).DeviceList,1),1);
A.(fam).Setpoint.Units         = 'Hardware';
A.(fam).Setpoint.HWUnits       = 'Ampere';
A.(fam).Setpoint.PhysicsUnits  = 'meter^-3';
A.(fam).Setpoint.HW2PhysicsFcn  = @sirius_hw2ph;
A.(fam).Setpoint.Physics2HWFcn  = @sirius_ph2hw;
A.(fam).Setpoint.Range         = [0 225];
A.(fam).Setpoint.Tolerance     = 0.2;
A.(fam).Setpoint.DeltaRespMat  = 0.5; 


function DList = getDeviceList(NSector, NDevices, varargin)

if isempty(varargin)
    InitialSector = 1;
    InitialDevice = 1;
else
    InitialSector = varargin{1};
    InitialDevice = varargin{2};
end
    
DList = [];
DL = ones(NDevices,2);
DL(:,2) = (1:NDevices)';
for i=1:NSector
    DL(:,1) = i;
    DList = [DList; DL];
end

idx=1;
for i=1:size(DList,1)
    if DList(i,:) == [InitialSector, InitialDevice]
        break
    end
    idx=idx+1;
end

DList = [DList(idx:size(DList,1), :) ; DList(1:idx-1, :)];


