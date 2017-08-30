function sirius_si_init
%SIRIUSINIT - MML initialization file for the VUV ring at sirius3
% 
%  See also setoperationalmode

% 2012-07-10 Modificado para sirius3_lattice_e025 - Afonso

setao([]);
setad([]);

[SIRIUS_ROOT, ~, ~] = fileparts(mfilename('fullpath'));
AD.Directory.ExcDataDir  = '/home/fac_files/lnls-sirius/control-system-constants/magnet/excitation-data';
AD.Directory.LatticesDef = [SIRIUS_ROOT, filesep, 'lattices_def'];
setad(AD);


%% dipoles

AO.B1.FamilyName  = 'B1';
AO.B1.MemberOf    = {'PlotFamily'; 'b1'; 'BEND'; 'Magnet';};
AO.B1.DeviceList  = getDeviceList(10,4);
AO.B1.ElementList = (1:size(AO.B1.DeviceList,1))';
AO.B1.Status      = ones(size(AO.B1.DeviceList,1),1);
AO.B1.Position    = [];
AO.B1.ExcitationCurves = sirius_getexcdata(repmat('si-dipole-b1b2-fam',size(AO.B1.DeviceList,1),1)); 

AO.B1.Monitor.MemberOf = {};
AO.B1.Monitor.Mode = 'Simulator';
AO.B1.Monitor.DataType = 'Scalar';
AO.B1.Monitor.ChannelNames = repmat(sirius_si_getname(AO.B1.FamilyName, 'Monitor'), size(AO.B1.DeviceList,1),1);
AO.B1.Monitor.HW2PhysicsFcn = @bend2gev;
AO.B1.Monitor.Physics2HWFcn = @gev2bend;
AO.B1.Monitor.Units        = 'Hardware';
AO.B1.Monitor.HWUnits      = 'Ampere';
AO.B1.Monitor.PhysicsUnits = 'GeV';

AO.B1.Setpoint.MemberOf = {'MachineConfig';};
AO.B1.Setpoint.Mode = 'Simulator';
AO.B1.Setpoint.DataType = 'Scalar';
AO.B1.Setpoint.ChannelNames = repmat(sirius_si_getname(AO.B1.FamilyName, 'Setpoint'), size(AO.B1.DeviceList,1),1);
AO.B1.Setpoint.HW2PhysicsFcn = @bend2gev;
AO.B1.Setpoint.Physics2HWFcn = @gev2bend;
AO.B1.Setpoint.Units        = 'Hardware';
AO.B1.Setpoint.HWUnits      = 'Ampere';
AO.B1.Setpoint.PhysicsUnits = 'GeV';
AO.B1.Setpoint.Range        = [0 300];
AO.B1.Setpoint.Tolerance    = .1;
AO.B1.Setpoint.DeltaRespMat = .01;


AO.B2.FamilyName  = 'B2';
AO.B2.MemberOf    = {'PlotFamily'; 'B2'; 'BEND'; 'Magnet';};
AO.B2.DeviceList  = getDeviceList(10,4);
AO.B2.ElementList = (1:size(AO.B2.DeviceList,1))';
AO.B2.Status      = ones(size(AO.B2.DeviceList,1),1);
AO.B2.Position    = [];
AO.B2.ExcitationCurves = sirius_getexcdata(repmat('si-dipole-b1b2-fam',size(AO.B2.DeviceList,1),1)); 

AO.B2.Monitor.MemberOf = {};
AO.B2.Monitor.Mode = 'Simulator';
AO.B2.Monitor.DataType = 'Scalar';
AO.B2.Monitor.ChannelNames = repmat(sirius_si_getname(AO.B2.FamilyName, 'Monitor'), size(AO.B2.DeviceList,1),1);
AO.B2.Monitor.HW2PhysicsFcn = @bend2gev;
AO.B2.Monitor.Physics2HWFcn = @gev2bend;
AO.B2.Monitor.Units        = 'Hardware';
AO.B2.Monitor.HWUnits      = 'Ampere';
AO.B2.Monitor.PhysicsUnits = 'GeV';

AO.B2.Setpoint.MemberOf = {'MachineConfig';};
AO.B2.Setpoint.Mode = 'Simulator';
AO.B2.Setpoint.DataType = 'Scalar';
AO.B2.Setpoint.ChannelNames = repmat(sirius_si_getname(AO.B2.FamilyName, 'Setpoint'), size(AO.B2.DeviceList,1),1);
AO.B2.Setpoint.HW2PhysicsFcn = @bend2gev;
AO.B2.Setpoint.Physics2HWFcn = @gev2bend;
AO.B2.Setpoint.Units        = 'Hardware';
AO.B2.Setpoint.HWUnits      = 'Ampere';
AO.B2.Setpoint.PhysicsUnits = 'GeV';
AO.B2.Setpoint.Range        = [0 300];
AO.B2.Setpoint.Tolerance    = .1;
AO.B2.Setpoint.DeltaRespMat = .01;

AO.BC.FamilyName  = 'BC';
AO.BC.MemberOf    = {'SI-BC'; 'BC';};
AO.BC.DeviceList  = getDeviceList(10,2);
AO.BC.ElementList = (1:size(AO.BC.DeviceList,1))';
AO.BC.Status      = ones(size(AO.BC.DeviceList,1),1);
AO.BC.Position    = [];


%% quadrupoles 
AO = get_AO_quads(AO,'QFA', 'q20-fam', 2);
AO = get_AO_quads(AO,'QDA', 'q14-fam', 2);
AO = get_AO_quads(AO,'QFB', 'q30-fam', 4);
AO = get_AO_quads(AO,'QDB2','q14-fam', 4);
AO = get_AO_quads(AO,'QDB1','q14-fam', 4);
AO = get_AO_quads(AO,'QFP', 'q30-fam', 2);
AO = get_AO_quads(AO,'QDP2','q14-fam', 2);
AO = get_AO_quads(AO,'QDP1','q14-fam', 2);
AO = get_AO_quads(AO,'Q1',  'q20-fam', 8);
AO = get_AO_quads(AO,'Q2',  'q20-fam', 8);
AO = get_AO_quads(AO,'Q3',  'q20-fam', 8);
AO = get_AO_quads(AO,'Q4',  'q20-fam', 8);


%% sextupoles

AO = get_AO_sexts(AO,'SDA0',2);
AO = get_AO_sexts(AO,'SDB0',4);
AO = get_AO_sexts(AO,'SDP0',2);
AO = get_AO_sexts(AO,'SDA1',2);
AO = get_AO_sexts(AO,'SDB1',4);
AO = get_AO_sexts(AO,'SDP1',2);
AO = get_AO_sexts(AO,'SDA2',2);
AO = get_AO_sexts(AO,'SDB2',4);
AO = get_AO_sexts(AO,'SDP2',2);
AO = get_AO_sexts(AO,'SDA3',2);
AO = get_AO_sexts(AO,'SDB3',4);
AO = get_AO_sexts(AO,'SDP3',2);
AO = get_AO_sexts(AO,'SFA0',2);
AO = get_AO_sexts(AO,'SFB0',4);
AO = get_AO_sexts(AO,'SFP0',2);
AO = get_AO_sexts(AO,'SFA1',2);
AO = get_AO_sexts(AO,'SFB1',4);
AO = get_AO_sexts(AO,'SFP1',2);
AO = get_AO_sexts(AO,'SFA2',2);
AO = get_AO_sexts(AO,'SFB2',4);
AO = get_AO_sexts(AO,'SFP2',2);


%% correctors

% ch
AO.CH.FamilyName  = 'CH';
AO.CH.MemberOf    = {'PlotFamily'; 'COR'; 'CH'; 'Magnet';'hcm';'hcm_slow';};
AO.CH.DeviceList  = getDeviceList(10, 12);
AO.CH.ElementList = (1:size(AO.CH.DeviceList,1))';
AO.CH.Status      = ones(size(AO.CH.DeviceList,1),1);
AO.CH.Position    = [];
AO.CH.ExcitationCurves = sirius_getexcdata(repmat('si-sextupole-s15-ch',size(AO.CH.DeviceList,1),1));
AO.CH.Monitor.MemberOf = {'Horizontal'; 'COR'; 'CH'; 'Magnet';};
AO.CH.Monitor.Mode     = 'Simulator';
AO.CH.Monitor.DataType = 'Scalar';
AO.CH.Monitor.ChannelNames = sirius_si_getname(AO.CH.FamilyName, 'Monitor', AO.CH.DeviceList);
AO.CH.Monitor.Units        = 'Physics'; % ?
AO.CH.Monitor.HWUnits      = 'Ampere';
AO.CH.Monitor.PhysicsUnits = 'Radian';
AO.CH.Monitor.HW2PhysicsFcn  = @sirius_hw2ph;
AO.CH.Monitor.Physics2HWFcn  = @sirius_ph2hw;
AO.CH.Setpoint.MemberOf = {'MachineConfig'; 'Horizontal'; 'COR'; 'hcm'; 'Magnet'; 'Setpoint'; 'measBPMresp';};
AO.CH.Setpoint.Mode = 'Simulator';
AO.CH.Setpoint.DataType = 'Scalar';
AO.CH.Setpoint.ChannelNames = sirius_si_getname(AO.CH.FamilyName, 'Setpoint', AO.CH.DeviceList);
AO.CH.Setpoint.Units        = 'Physics';
AO.CH.Setpoint.HWUnits      = 'Ampere';
AO.CH.Setpoint.PhysicsUnits = 'Radian';
AO.CH.Setpoint.HW2PhysicsFcn  = @sirius_hw2ph;
AO.CH.Setpoint.Physics2HWFcn  = @sirius_ph2hw;
AO.CH.Setpoint.Range        = [-10 10];
AO.CH.Setpoint.Tolerance    = 0.00001;
AO.CH.Setpoint.DeltaRespMat =  5e-4; 

% CV
AO.CV.FamilyName  = 'CV';
AO.CV.MemberOf    = {'PlotFamily'; 'COR'; 'CV'; 'Magnet';'vcm';'vcm_slow';};
AO.CV.DeviceList  = getDeviceList(10, 16);
AO.CV.ElementList = (1:size(AO.CV.DeviceList,1))';
AO.CV.Status      = ones(size(AO.CV.DeviceList,1),1);
AO.CV.Position    = [];
AO.CV.ExcitationCurves = sirius_getexcdata(repmat('si-sextupole-s15-cv',size(AO.CV.DeviceList,1),1));
AO.CV.Monitor.MemberOf = {'Horizontal'; 'COR'; 'CV'; 'Magnet';};
AO.CV.Monitor.Mode     = 'Simulator';
AO.CV.Monitor.DataType = 'Scalar';
AO.CV.Monitor.ChannelNames = sirius_si_getname(AO.CV.FamilyName, 'Monitor', AO.CV.DeviceList);
AO.CV.Monitor.Units        = 'Physics';
AO.CV.Monitor.HWUnits      = 'Ampere';
AO.CV.Monitor.PhysicsUnits = 'Radian';
AO.CV.Monitor.HW2PhysicsFcn  = @sirius_hw2ph;
AO.CV.Monitor.Physics2HWFcn  = @sirius_ph2hw;
AO.CV.Setpoint.MemberOf = {'MachineConfig'; 'Horizontal'; 'COR'; 'vcm'; 'Magnet'; 'Setpoint'; 'measBPMresp';};
AO.CV.Setpoint.Mode = 'Simulator';
AO.CV.Setpoint.DataType = 'Scalar';
AO.CV.Setpoint.ChannelNames = sirius_si_getname(AO.CV.FamilyName, 'Setpoint', AO.CV.DeviceList);
AO.CV.Setpoint.Units        = 'Physics';
AO.CV.Setpoint.HWUnits      = 'Ampere';
AO.CV.Setpoint.PhysicsUnits = 'Radian';
AO.CV.Setpoint.HW2PhysicsFcn  = @sirius_hw2ph;
AO.CV.Setpoint.Physics2HWFcn  = @sirius_ph2hw;
AO.CV.Setpoint.Range        = [-10 10];
AO.CV.Setpoint.Tolerance    = 0.00001;
AO.CV.Setpoint.DeltaRespMat =  5e-4; 

% FCH
AO.FCH.FamilyName  = 'FCH';
AO.FCH.MemberOf    = {'PlotFamily'; 'COR'; 'FCH'; 'Magnet';'hcm';'hcm_fast';};
AO.FCH.DeviceList  = getDeviceList(10, 8);
AO.FCH.DeviceList([8,15,16,80],:) = []; % subtracts fast correctors from injection and cavity sectors
AO.FCH.ElementList = (1:size(AO.FCH.DeviceList,1))';
AO.FCH.Status      = ones(size(AO.FCH.DeviceList,1),1);
AO.FCH.Position    = [];
AO.FCH.ExcitationCurves = sirius_getexcdata(repmat('si-corrector-fch',size(AO.FCH.DeviceList,1),1));
AO.FCH.Monitor.MemberOf = {'Horizontal'; 'COR'; 'FCH'; 'Magnet';};
AO.FCH.Monitor.Mode     = 'Simulator';
AO.FCH.Monitor.DataType = 'Scalar';
AO.FCH.Monitor.ChannelNames  = sirius_si_getname(AO.FCH.FamilyName, 'Monitor', AO.FCH.DeviceList);
AO.FCH.Monitor.Units         = 'Physics';
AO.FCH.Monitor.HWUnits       = 'Ampere';
AO.FCH.Monitor.PhysicsUnits  = 'Radian';
AO.FCH.Monitor.HW2PhysicsFcn  = @sirius_hw2ph;
AO.FCH.Monitor.Physics2HWFcn  = @sirius_ph2hw;
AO.FCH.Setpoint.MemberOf     = {'MachineConfig'; 'Horizontal'; 'COR'; 'hcm'; 'Magnet'; 'Setpoint'; 'measBPMresp';};
AO.FCH.Setpoint.Mode         = 'Simulator';
AO.FCH.Setpoint.DataType     = 'Scalar';
AO.FCH.Setpoint.ChannelNames = sirius_si_getname(AO.FCH.FamilyName, 'Setpoint', AO.FCH.DeviceList);
AO.FCH.Setpoint.Units        = 'Physics';
AO.FCH.Setpoint.HWUnits      = 'Ampere';
AO.FCH.Setpoint.PhysicsUnits = 'Radian';
AO.FCH.Setpoint.HW2PhysicsFcn  = @sirius_hw2ph;
AO.FCH.Setpoint.Physics2HWFcn  = @sirius_ph2hw;
AO.FCH.Setpoint.Range        = [-10 10];
AO.FCH.Setpoint.Tolerance    = 0.00001;
AO.FCH.Setpoint.DeltaRespMat =  5e-4; 

% FCV
AO.FCV.FamilyName  = 'FCV';
AO.FCV.MemberOf    = {'PlotFamily'; 'COR'; 'FCV'; 'Magnet';'vcm';'vcm_fast';};
AO.FCV.DeviceList  = getDeviceList(10, 8);
AO.FCV.DeviceList([8,15,16,80],:) = []; % subtracts fast correctors from injection and cavity sectors
AO.FCV.ElementList = (1:size(AO.FCV.DeviceList,1))';
AO.FCV.Status      = ones(size(AO.FCV.DeviceList,1),1);
AO.FCV.Position    = [];
AO.FCV.ExcitationCurves = sirius_getexcdata(repmat('si-corrector-fcv',size(AO.FCV.DeviceList,1),1));
AO.FCV.Monitor.MemberOf = {'Horizontal'; 'COR'; 'FCV'; 'Magnet';};
AO.FCV.Monitor.Mode     = 'Simulator';
AO.FCV.Monitor.DataType = 'Scalar';
AO.FCV.Monitor.ChannelNames  = sirius_si_getname(AO.FCV.FamilyName, 'Monitor', AO.FCV.DeviceList);
AO.FCV.Monitor.Units        = 'Physics';
AO.FCV.Monitor.HWUnits      = 'Ampere';
AO.FCV.Monitor.PhysicsUnits = 'Radian';
AO.FCV.Monitor.HW2PhysicsFcn  = @sirius_hw2ph;
AO.FCV.Monitor.Physics2HWFcn  = @sirius_ph2hw;
AO.FCV.Setpoint.MemberOf = {'MachineConfig'; 'Horizontal'; 'COR'; 'vcm'; 'Magnet'; 'Setpoint'; 'measBPMresp';};
AO.FCV.Setpoint.Mode = 'Simulator';
AO.FCV.Setpoint.DataType = 'Scalar';
AO.FCV.Setpoint.ChannelNames  = sirius_si_getname(AO.FCV.FamilyName, 'Setpoint', AO.FCV.DeviceList);
AO.FCV.Setpoint.Units        = 'Physics';
AO.FCV.Setpoint.HWUnits      = 'Ampere';
AO.FCV.Setpoint.PhysicsUnits = 'Radian';
AO.FCV.Setpoint.HW2PhysicsFcn  = @sirius_hw2ph;
AO.FCV.Setpoint.Physics2HWFcn  = @sirius_ph2hw;
AO.FCV.Setpoint.Range        = [-10 10];
AO.FCV.Setpoint.Tolerance    = 0.00001;
AO.FCV.Setpoint.DeltaRespMat =  5e-4; 

% QS
AO.QS.FamilyName  = 'QS';
AO.QS.MemberOf    = {'PlotFamily'; 'COR'; 'QS'; 'Magnet'; 'SkewQuad'};
AO.QS.DeviceList  = getDeviceList(10, 8);
AO.QS.ElementList = (1:size(AO.QS.DeviceList,1))';
AO.QS.Status      = ones(size(AO.QS.DeviceList,1),1);
AO.QS.Position    = [];
AO.QS.ExcitationCurves = sirius_getexcdata(repmat('si-quadrupole-qs',size(AO.QS.DeviceList,1),1));
AO.QS.Monitor.MemberOf = {'Horizontal'; 'COR'; 'QS'; 'Magnet';};
AO.QS.Monitor.ChannelNames = sirius_si_getname(AO.QS.FamilyName, 'Monitor', AO.QS.DeviceList);
AO.QS.Monitor.Mode     = 'Simulator';
AO.QS.Monitor.DataType = 'Scalar';
AO.QS.Monitor.Units        = 'Physics';
AO.QS.Monitor.HWUnits      = 'Ampere';
AO.QS.Monitor.PhysicsUnits = 'Radian';
AO.QS.Monitor.HW2PhysicsFcn  = @sirius_hw2ph;
AO.QS.Monitor.Physics2HWFcn  = @sirius_ph2hw;
AO.QS.Setpoint.MemberOf = {'MachineConfig'; 'Horizontal'; 'COR'; 'Magnet'; 'Setpoint'; 'measBPMresp';};
AO.QS.Setpoint.Mode = 'Simulator';
AO.QS.Setpoint.DataType = 'Scalar';
AO.QS.Setpoint.ChannelNames = sirius_si_getname(AO.QS.FamilyName, 'Setpoint', AO.QS.DeviceList);
AO.QS.Setpoint.Units        = 'Physics';
AO.QS.Setpoint.HWUnits      = 'Ampere';
AO.QS.Setpoint.PhysicsUnits = 'Radian';
AO.QS.Setpoint.HW2PhysicsFcn  = @sirius_hw2ph;
AO.QS.Setpoint.Physics2HWFcn  = @sirius_ph2hw;
AO.QS.Setpoint.Range        = [-10 10];
AO.QS.Setpoint.Tolerance    = 0.00001;
AO.QS.Setpoint.DeltaRespMat = 5e-4; 

% BPMx
AO.BPMx.FamilyName  = 'BPMx';
AO.BPMx.MemberOf    = {'PlotFamily'; 'BPM'; 'BPMx'; 'Diagnostics'};
AO.BPMx.DeviceList  = getDeviceList(10, 16);
AO.BPMx.ElementList = (1:size(AO.BPMx.DeviceList,1))';
AO.BPMx.Status      = ones(size(AO.BPMx.DeviceList,1),1);
AO.BPMx.Position    = [];
AO.BPMx.Golden      = zeros(length(AO.BPMx.ElementList),1);
AO.BPMx.Offset      = zeros(length(AO.BPMx.ElementList),1);

AO.BPMx.Monitor.MemberOf = {'BPMx'; 'Monitor';};
AO.BPMx.Monitor.ChannelNames = sirius_si_getname(AO.BPMx.FamilyName, 'Monitor', AO.BPMx.DeviceList);
AO.BPMx.Monitor.Mode = 'Simulator';
AO.BPMx.Monitor.DataType = 'Scalar';
AO.BPMx.Monitor.HW2PhysicsParams = 1e-6;  % HW [mm], Simulator [Meters]
AO.BPMx.Monitor.Physics2HWParams = 1e6;
AO.BPMx.Monitor.Units        = 'Hardware';
AO.BPMx.Monitor.HWUnits      = 'um';
AO.BPMx.Monitor.PhysicsUnits = 'meter';


% BPMy
AO.BPMy.FamilyName  = 'BPMy';
AO.BPMy.MemberOf    = {'PlotFamily'; 'BPM'; 'BPMy'; 'Diagnostics'};
AO.BPMy.DeviceList  = getDeviceList(10, 16);
AO.BPMy.ElementList = (1:size(AO.BPMy.DeviceList,1))';
AO.BPMy.Status      = ones(size(AO.BPMy.DeviceList,1),1);
AO.BPMy.Position    = [];
AO.BPMy.Golden      = zeros(length(AO.BPMy.ElementList),1);
AO.BPMy.Offset      = zeros(length(AO.BPMy.ElementList),1);

AO.BPMy.Monitor.MemberOf = {'BPMy'; 'Monitor';};
AO.BPMy.Monitor.ChannelNames = sirius_si_getname(AO.BPMy.FamilyName, 'Monitor', AO.BPMy.DeviceList);
AO.BPMy.Monitor.Mode = 'Simulator';
AO.BPMy.Monitor.DataType = 'Scalar';
AO.BPMy.Monitor.HW2PhysicsParams = 1e-6;  % HW [mm], Simulator [Meters]
AO.BPMy.Monitor.Physics2HWParams = 1e6;
AO.BPMy.Monitor.Units        = 'Hardware';
AO.BPMy.Monitor.HWUnits      = 'um';
AO.BPMy.Monitor.PhysicsUnits = 'meter';

%%%%%%%%
% Tune %
%%%%%%%%
AO.Tune.FamilyName = 'Tune';
AO.Tune.MemberOf = {'Tune';};
AO.Tune.DeviceList = [1 1;1 2;1 3];
AO.Tune.ElementList = [1;2;3];
AO.Tune.Status = [1; 1; 0];
AO.Tune.CommonNames = ['TuneX'; 'TuneY'; 'TuneS'];

AO.Tune.Monitor.MemberOf   = {'Tune'};
AO.Tune.Monitor.ChannelNames = sirius_si_getname(AO.Tune.FamilyName, 'Monitor');
AO.Tune.Monitor.Mode = 'Simulator'; 
AO.Tune.Monitor.DataType = 'Scalar';
AO.Tune.Monitor.HW2PhysicsParams = 1;
AO.Tune.Monitor.Physics2HWParams = 1;
AO.Tune.Monitor.Units        = 'Hardware';
AO.Tune.Monitor.HWUnits      = 'Tune';
AO.Tune.Monitor.PhysicsUnits = 'Tune';


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
A.(fam).ExcitationCurves = sirius_getexcdata(repmat(['si-quadrupole-',type],size(A.(fam).DeviceList,1),1)); 
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

A.(fam).FamilyName = fam;
A.(fam).MemberOf    = {'PlotFamily'; fam; 'SEXT'; 'Magnet'; 'Chromaticity Corrector'};
A.(fam).DeviceList  = getDeviceList(5, num_el_arc);
A.(fam).ElementList = (1:size(A.(fam).DeviceList,1))';
A.(fam).Status      = ones(size(A.(fam).DeviceList,1),1);
A.(fam).Position    = [];
A.(fam).ExcitationCurves = sirius_getexcdata(repmat('si-sextupole-s15-fam',size(A.(fam).DeviceList,1),1));
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


