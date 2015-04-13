function lnls1_init(OperationalMode)
%LNLSINIT - MML initialization file for the VUV ring at LNLS1
%  lnlsinit(OperationalMode)
%
%  See also setoperationalmode


% NOTES & COMMENTS

% 1. Make sure the BPM and magnes are in the correct location in the AT model 
%    or LOCO will have trouble.  
% 2. Try mmlviewer to view and check the MML setup.
% 3. Try measbpmresp, meastuneresp, measchroresp
%    Compare to the model and maybe copy them to the StorageRingOpsData directory.
%    After LOCO it's often better to use the calibrated model (no noise).
% 4. Try setorbitgui, steptune, stepchro, ...
% 5. To run LOCO
%    1. "Measure" new data
%       >> measlocodata('model');
%    2. Build the LOCO input file
%       >> buildlocoinput
%    3. Run LOCO
%       >> loco
%    4. To set back to the machine see setlocodata (may need some work)
%       >> setlocodata
% 6. lnls1_lattice and updateatindex must always be in sync


% To-Do (if you want to use the MML online):
% 1. lnls1_hw2ph and lnls1_ph2hw need some fine tuning
% 2. bend2gev and gev2bend need some work if you want to run at different energies. 
% 3. Check .Ranges, .Tolerances, and .DeltaRespMat
% 4. run monmags to check the .Tolerance field
% 5. Measurements - monbpm, measbpmresp, measdisp
%    Copy them to the StorageRingOpsData directory using plotfamily.
% 6. Get the DCCT, TUNE families working
% 7. Check the BPM delay and set getbpmaverages accordingly.
%    (Edit and try magstep to test the timing.)
% 8. lnls1_getname needs works!
% 9. lnls1_lattice looks odd for the SF in sector one (split with a drift in the middle)



if nargin < 1
    OperationalMode = 1;
end

setao([]);
setad([]);



% Base on the location of this file
[LNLS1_ROOT, FileName, ExtentionName] = fileparts(mfilename('fullpath'));
AD.Directory.ExcDataDir = [LNLS1_ROOT, filesep, 'excitation_curves'];
AD.Directory.LatticesDef = [LNLS1_ROOT, filesep, 'lattices_def'];
setad(AD);


% Add additional directories with LNLS1 specific stuff.
MMLROOT = getmmlroot('IgnoreTheAD');
fullpathname = fullfile(MMLROOT,'machine', 'LNLS1', 'Booster', 'llcommands');
if exist(fullpathname, 'file'), addpath(fullpathname, '-begin'); end
fullpathname = fullfile(MMLROOT,'machine', 'LNLS1', 'Booster', 'machine_experiments');
if exist(fullpathname, 'file'), addpath(fullpathname, '-begin'); end


% Get the device lists (local function)
[OnePerSector, TwoPerSector, ThreePerSector, FourPerSector, FivePerSector SixPerSector] = buildthedevicelists;



%%%%%%%%%%
%  BEND  %
%%%%%%%%%%

AO.BEND.FamilyName  = 'BEND';
AO.BEND.MemberOf    = {'PlotFamily'; 'BEND'; 'Magnet';};
AO.BEND.DeviceList  = SixPerSector;
AO.BEND.ElementList = (1:size(AO.BEND.DeviceList,1))';
AO.BEND.Status      = ones(size(AO.BEND.DeviceList,1),1);
AO.BEND.Position    = [];
AO.BEND.CommonNames  = ['SDI01'; 'SDI02'; 'SDI03'; 'SDI04'; 'SDI05'; 'SDI06'; 'SDI07'; 'SDI08'; 'SDI09'; 'SDI10'; 'SDI11'; 'SDI12']; 
BendCorrectionFactor = (1.37 / 1.371517170879213);
% integrated field in excitation curves for dipoles are measured on wrong approximate paths 
% (arc of circle till physical magnet bordar + straight section.
% The factor should correct it.
AO.BEND.ExcitationCurves = lnls1_getexcdata(AO.BEND.CommonNames, BendCorrectionFactor);
AO.BEND.Monitor.MemberOf = {};
AO.BEND.Monitor.Mode = 'Simulator';
AO.BEND.Monitor.DataType = 'Scalar';
AO.BEND.Monitor.ChannelNames = lnls1_getname('BEND', 'Monitor', AO.BEND.DeviceList);
AO.BEND.Monitor.HW2PhysicsFcn = @bend2gev;
AO.BEND.Monitor.Physics2HWFcn = @gev2bend;
AO.BEND.Monitor.Units        = 'Hardware';
AO.BEND.Monitor.HWUnits      = 'Ampere';
AO.BEND.Monitor.PhysicsUnits = 'GeV';
AO.BEND.Setpoint.MemberOf = {'MachineConfig';};
AO.BEND.Setpoint.Mode = 'Simulator';
AO.BEND.Setpoint.DataType = 'Scalar';
AO.BEND.Setpoint.ChannelNames = lnls1_getname('BEND', 'Setpoint', AO.BEND.DeviceList);
AO.BEND.Setpoint.HW2PhysicsFcn = @bend2gev;
AO.BEND.Setpoint.Physics2HWFcn = @gev2bend;
AO.BEND.Setpoint.Units        = 'Hardware';
AO.BEND.Setpoint.HWUnits      = 'Ampere';
AO.BEND.Setpoint.PhysicsUnits = 'GeV';
AO.BEND.Setpoint.Range        = [0 300];
AO.BEND.Setpoint.Tolerance    = .1;
AO.BEND.Setpoint.DeltaRespMat = .2;



%%%%%%%%%%%%%%%
% Quadrupoles %
%%%%%%%%%%%%%%%

AO.S2QD01.FamilyName             = 'S2QD01';
AO.S2QD01.MemberOf               = {'PlotFamily'; 'S2QD01'; 'QD'; 'QUAD'; 'Magnet';  'Tune Corrector'};
AO.S2QD01.DeviceList             = [1 1; 2 1];
AO.S2QD01.ElementList            = (1:size(AO.S2QD01.DeviceList,1))';
AO.S2QD01.Status                 = ones(size(AO.S2QD01.DeviceList,1),1); 
AO.S2QD01.CommonNames            = ['SQD01B'; 'SQD01A';];
AO.S2QD01.ExcitationCurves       = lnls1_getexcdata(AO.S2QD01.CommonNames, 1);
AO.S2QD01.Monitor.MemberOf       = {};
AO.S2QD01.Monitor.Mode           = 'Simulator';
AO.S2QD01.Monitor.DataType       = 'Scalar';
AO.S2QD01.Monitor.ChannelNames   = lnls1_getname(AO.S2QD01.FamilyName, 'Monitor');
AO.S2QD01.Monitor.HW2PhysicsFcn  = @lnls1_hw2ph;
AO.S2QD01.Monitor.Physics2HWFcn  = @lnls1_ph2hw;
AO.S2QD01.Monitor.Units          = 'Hardware';
AO.S2QD01.Monitor.HWUnits        = 'Ampere';
AO.S2QD01.Monitor.PhysicsUnits   = 'meter^-2';
AO.S2QD01.Setpoint.MemberOf      = {'MachineConfig'};
AO.S2QD01.Setpoint.Mode          = 'Simulator';
AO.S2QD01.Setpoint.DataType      = 'Scalar';
AO.S2QD01.Setpoint.ChannelNames  = lnls1_getname(AO.S2QD01.FamilyName, 'Setpoint');
AO.S2QD01.Setpoint.HW2PhysicsFcn = @lnls1_hw2ph;
AO.S2QD01.Setpoint.Physics2HWFcn = @lnls1_ph2hw;
AO.S2QD01.Setpoint.Units         = 'Hardware';
AO.S2QD01.Setpoint.HWUnits       = 'Ampere';
AO.S2QD01.Setpoint.PhysicsUnits  = 'meter^-2';
AO.S2QD01.Setpoint.Range         = [0 225];
AO.S2QD01.Setpoint.Tolerance     = 0.1;
AO.S2QD01.Setpoint.DeltaRespMat  = 0.5; 

AO.S2QD07.FamilyName             = 'S2QD07';
AO.S2QD07.MemberOf               = {'PlotFamily'; 'S2QD07'; 'QD'; 'QUAD'; 'Magnet';  'Tune Corrector'};
AO.S2QD07.DeviceList             = [1 1; 2 1];
AO.S2QD07.ElementList            = (1:size(AO.S2QD07.DeviceList,1))';
AO.S2QD07.Status                 = ones(size(AO.S2QD07.DeviceList,1),1); 
AO.S2QD07.CommonNames            = ['SQD07B'; 'SQD07A';];
AO.S2QD07.ExcitationCurves       = lnls1_getexcdata(AO.S2QD07.CommonNames, 1);
AO.S2QD07.Monitor.MemberOf       = {};
AO.S2QD07.Monitor.Mode           = 'Simulator';
AO.S2QD07.Monitor.DataType       = 'Scalar';
AO.S2QD07.Monitor.ChannelNames   = lnls1_getname(AO.S2QD07.FamilyName, 'Monitor');
AO.S2QD07.Monitor.HW2PhysicsFcn  = @lnls1_hw2ph;
AO.S2QD07.Monitor.Physics2HWFcn  = @lnls1_ph2hw;
AO.S2QD07.Monitor.Units          = 'Hardware';
AO.S2QD07.Monitor.HWUnits        = 'Ampere';
AO.S2QD07.Monitor.PhysicsUnits   = 'meter^-2';
AO.S2QD07.Setpoint.MemberOf      = {'MachineConfig'};
AO.S2QD07.Setpoint.Mode          = 'Simulator';
AO.S2QD07.Setpoint.DataType      = 'Scalar';
AO.S2QD07.Setpoint.ChannelNames  = lnls1_getname(AO.S2QD07.FamilyName, 'Setpoint');
AO.S2QD07.Setpoint.HW2PhysicsFcn = @lnls1_hw2ph;
AO.S2QD07.Setpoint.Physics2HWFcn = @lnls1_ph2hw;
AO.S2QD07.Setpoint.Units         = 'Hardware';
AO.S2QD07.Setpoint.HWUnits       = 'Ampere';
AO.S2QD07.Setpoint.PhysicsUnits  = 'meter^-2';
AO.S2QD07.Setpoint.Range         = [0 225];
AO.S2QD07.Setpoint.Tolerance     = 0.1;
AO.S2QD07.Setpoint.DeltaRespMat  = 0.5; 

AO.S2QF01.FamilyName             = 'S2QF01';
AO.S2QF01.MemberOf               = {'PlotFamily'; 'S2QF01'; 'QF'; 'QUAD'; 'Magnet';  'Tune Corrector'};
AO.S2QF01.DeviceList             = [1 1; 2 1];
AO.S2QF01.ElementList            = (1:size(AO.S2QF01.DeviceList,1))';
AO.S2QF01.Status                 = ones(size(AO.S2QF01.DeviceList,1),1); 
AO.S2QF01.CommonNames            = ['SQF01B'; 'SQF01A';];
AO.S2QF01.ExcitationCurves       = lnls1_getexcdata(AO.S2QF01.CommonNames, 1);
AO.S2QF01.Monitor.MemberOf       = {};
AO.S2QF01.Monitor.Mode           = 'Simulator';
AO.S2QF01.Monitor.DataType       = 'Scalar';
AO.S2QF01.Monitor.ChannelNames   = lnls1_getname(AO.S2QF01.FamilyName, 'Monitor');
AO.S2QF01.Monitor.HW2PhysicsFcn  = @lnls1_hw2ph;
AO.S2QF01.Monitor.Physics2HWFcn  = @lnls1_ph2hw;
AO.S2QF01.Monitor.Units          = 'Hardware';
AO.S2QF01.Monitor.HWUnits        = 'Ampere';
AO.S2QF01.Monitor.PhysicsUnits   = 'meter^-2';
AO.S2QF01.Setpoint.MemberOf      = {'MachineConfig'};
AO.S2QF01.Setpoint.Mode          = 'Simulator';
AO.S2QF01.Setpoint.DataType      = 'Scalar';
AO.S2QF01.Setpoint.ChannelNames  = lnls1_getname(AO.S2QF01.FamilyName, 'Setpoint');
AO.S2QF01.Setpoint.HW2PhysicsFcn = @lnls1_hw2ph;
AO.S2QF01.Setpoint.Physics2HWFcn = @lnls1_ph2hw;
AO.S2QF01.Setpoint.Units         = 'Hardware';
AO.S2QF01.Setpoint.HWUnits       = 'Ampere';
AO.S2QF01.Setpoint.PhysicsUnits  = 'meter^-2';
AO.S2QF01.Setpoint.Range         = [0 225];
AO.S2QF01.Setpoint.Tolerance     = 0.1;
AO.S2QF01.Setpoint.DeltaRespMat  = 0.5; 

AO.S2QF02.FamilyName             = 'S2QF02';
AO.S2QF02.MemberOf               = {'PlotFamily'; 'S2QF02'; 'QFC'; 'QUAD'; 'Magnet';};
AO.S2QF02.DeviceList             = [1 1; 1 2];
AO.S2QF02.ElementList            = (1:size(AO.S2QF02.DeviceList,1))';
AO.S2QF02.Status                 = ones(size(AO.S2QF02.DeviceList,1),1); 
AO.S2QF02.CommonNames            = ['SQF02'; 'SQF05';];
AO.S2QF02.ExcitationCurves       = lnls1_getexcdata(AO.S2QF02.CommonNames, 1);
AO.S2QF02.Monitor.MemberOf       = {};
AO.S2QF02.Monitor.Mode           = 'Simulator';
AO.S2QF02.Monitor.DataType       = 'Scalar';
AO.S2QF02.Monitor.ChannelNames   = lnls1_getname(AO.S2QF02.FamilyName, 'Monitor');
AO.S2QF02.Monitor.HW2PhysicsFcn  = @lnls1_hw2ph;
AO.S2QF02.Monitor.Physics2HWFcn  = @lnls1_ph2hw;
AO.S2QF02.Monitor.Units          = 'Hardware';
AO.S2QF02.Monitor.HWUnits        = 'Ampere';
AO.S2QF02.Monitor.PhysicsUnits   = 'meter^-2';
AO.S2QF02.Setpoint.MemberOf      = {'MachineConfig'};
AO.S2QF02.Setpoint.Mode          = 'Simulator';
AO.S2QF02.Setpoint.DataType      = 'Scalar';
AO.S2QF02.Setpoint.ChannelNames  = lnls1_getname(AO.S2QF02.FamilyName, 'Setpoint');
AO.S2QF02.Setpoint.HW2PhysicsFcn = @lnls1_hw2ph;
AO.S2QF02.Setpoint.Physics2HWFcn = @lnls1_ph2hw;
AO.S2QF02.Setpoint.Units         = 'Hardware';
AO.S2QF02.Setpoint.HWUnits       = 'Ampere';
AO.S2QF02.Setpoint.PhysicsUnits  = 'meter^-2';
AO.S2QF02.Setpoint.Range         = [0 225];
AO.S2QF02.Setpoint.Tolerance     = 0.1;
AO.S2QF02.Setpoint.DeltaRespMat  = 0.5; 

AO.S2QF03.FamilyName             = 'S2QF03';
AO.S2QF03.MemberOf               = {'PlotFamily'; 'S2QF03'; 'QFC'; 'QUAD'; 'Magnet';};
AO.S2QF03.DeviceList             = [1 1; 1 2];
AO.S2QF03.ElementList            = (1:size(AO.S2QF03.DeviceList,1))';
AO.S2QF03.Status                 = ones(size(AO.S2QF03.DeviceList,1),1); 
AO.S2QF03.CommonNames            = ['SQF03'; 'SQF05';];
AO.S2QF03.ExcitationCurves       = lnls1_getexcdata(AO.S2QF03.CommonNames, 1);
AO.S2QF03.Monitor.MemberOf       = {};
AO.S2QF03.Monitor.Mode           = 'Simulator';
AO.S2QF03.Monitor.DataType       = 'Scalar';
AO.S2QF03.Monitor.ChannelNames   = lnls1_getname(AO.S2QF03.FamilyName, 'Monitor');
AO.S2QF03.Monitor.HW2PhysicsFcn  = @lnls1_hw2ph;
AO.S2QF03.Monitor.Physics2HWFcn  = @lnls1_ph2hw;
AO.S2QF03.Monitor.Units          = 'Hardware';
AO.S2QF03.Monitor.HWUnits        = 'Ampere';
AO.S2QF03.Monitor.PhysicsUnits   = 'meter^-2';
AO.S2QF03.Setpoint.MemberOf      = {'MachineConfig'};
AO.S2QF03.Setpoint.Mode          = 'Simulator';
AO.S2QF03.Setpoint.DataType      = 'Scalar';
AO.S2QF03.Setpoint.ChannelNames  = lnls1_getname(AO.S2QF03.FamilyName, 'Setpoint');
AO.S2QF03.Setpoint.HW2PhysicsFcn = @lnls1_hw2ph;
AO.S2QF03.Setpoint.Physics2HWFcn = @lnls1_ph2hw;
AO.S2QF03.Setpoint.Units         = 'Hardware';
AO.S2QF03.Setpoint.HWUnits       = 'Ampere';
AO.S2QF03.Setpoint.PhysicsUnits  = 'meter^-2';
AO.S2QF03.Setpoint.Range         = [0 225];
AO.S2QF03.Setpoint.Tolerance     = 0.1;
AO.S2QF03.Setpoint.DeltaRespMat  = 0.5; 

AO.S2QF04.FamilyName             = 'S2QF04';
AO.S2QF04.MemberOf               = {'PlotFamily'; 'S2QF04'; 'QFC'; 'QUAD'; 'Magnet';};
AO.S2QF04.DeviceList             = [1 1; 2 1];
AO.S2QF04.ElementList            = (1:size(AO.S2QF04.DeviceList,1))';
AO.S2QF04.Status                 = ones(size(AO.S2QF04.DeviceList,1),1); 
AO.S2QF04.CommonNames            = ['SQF04'; 'SQF10';];
AO.S2QF04.ExcitationCurves       = lnls1_getexcdata(AO.S2QF04.CommonNames, 1);
AO.S2QF04.Monitor.MemberOf       = {};
AO.S2QF04.Monitor.Mode           = 'Simulator';
AO.S2QF04.Monitor.DataType       = 'Scalar';
AO.S2QF04.Monitor.ChannelNames   = lnls1_getname(AO.S2QF04.FamilyName, 'Monitor');
AO.S2QF04.Monitor.HW2PhysicsFcn  = @lnls1_hw2ph;
AO.S2QF04.Monitor.Physics2HWFcn  = @lnls1_ph2hw;
AO.S2QF04.Monitor.Units          = 'Hardware';
AO.S2QF04.Monitor.HWUnits        = 'Ampere';
AO.S2QF04.Monitor.PhysicsUnits   = 'meter^-2';
AO.S2QF04.Setpoint.MemberOf      = {'MachineConfig'};
AO.S2QF04.Setpoint.Mode          = 'Simulator';
AO.S2QF04.Setpoint.DataType      = 'Scalar';
AO.S2QF04.Setpoint.ChannelNames  = lnls1_getname(AO.S2QF04.FamilyName, 'Setpoint');
AO.S2QF04.Setpoint.HW2PhysicsFcn = @lnls1_hw2ph;
AO.S2QF04.Setpoint.Physics2HWFcn = @lnls1_ph2hw;
AO.S2QF04.Setpoint.Units         = 'Hardware';
AO.S2QF04.Setpoint.HWUnits       = 'Ampere';
AO.S2QF04.Setpoint.PhysicsUnits  = 'meter^-2';
AO.S2QF04.Setpoint.Range         = [0 225];
AO.S2QF04.Setpoint.Tolerance     = 0.1;
AO.S2QF04.Setpoint.DeltaRespMat  = 0.5; 

AO.S2QF07.FamilyName             = 'S2QF07';
AO.S2QF07.MemberOf               = {'PlotFamily'; 'S2QF07'; 'QF'; 'QUAD'; 'Magnet';};
AO.S2QF07.DeviceList             = [2 1; 2 2];
AO.S2QF07.ElementList            = (1:size(AO.S2QF07.DeviceList,1))';
AO.S2QF07.Status                 = ones(size(AO.S2QF07.DeviceList,1),1); 
AO.S2QF07.CommonNames            = ['SQF07A'; 'SQF07B';];
AO.S2QF07.ExcitationCurves       = lnls1_getexcdata(AO.S2QF07.CommonNames, 1);
AO.S2QF07.Monitor.MemberOf       = {};
AO.S2QF07.Monitor.Mode           = 'Simulator';
AO.S2QF07.Monitor.DataType       = 'Scalar';
AO.S2QF07.Monitor.ChannelNames   = lnls1_getname(AO.S2QF07.FamilyName, 'Monitor');
AO.S2QF07.Monitor.HW2PhysicsFcn  = @lnls1_hw2ph;
AO.S2QF07.Monitor.Physics2HWFcn  = @lnls1_ph2hw;
AO.S2QF07.Monitor.Units          = 'Hardware';
AO.S2QF07.Monitor.HWUnits        = 'Ampere';
AO.S2QF07.Monitor.PhysicsUnits   = 'meter^-2';
AO.S2QF07.Setpoint.MemberOf      = {'MachineConfig'};
AO.S2QF07.Setpoint.Mode          = 'Simulator';
AO.S2QF07.Setpoint.DataType      = 'Scalar';
AO.S2QF07.Setpoint.ChannelNames  = lnls1_getname(AO.S2QF07.FamilyName, 'Setpoint');
AO.S2QF07.Setpoint.HW2PhysicsFcn = @lnls1_hw2ph;
AO.S2QF07.Setpoint.Physics2HWFcn = @lnls1_ph2hw;
AO.S2QF07.Setpoint.Units         = 'Hardware';
AO.S2QF07.Setpoint.HWUnits       = 'Ampere';
AO.S2QF07.Setpoint.PhysicsUnits  = 'meter^-2';
AO.S2QF07.Setpoint.Range         = [0 225];
AO.S2QF07.Setpoint.Tolerance     = 0.1;
AO.S2QF07.Setpoint.DeltaRespMat  = 0.5;

AO.S2QF08.FamilyName             = 'S2QF08';
AO.S2QF08.MemberOf               = {'PlotFamily'; 'S2QF08'; 'QFC'; 'QUAD'; 'Magnet';};
AO.S2QF08.DeviceList             = [2 1; 2 2];
AO.S2QF08.ElementList            = (1:size(AO.S2QF08.DeviceList,1))';
AO.S2QF08.Status                 = ones(size(AO.S2QF08.DeviceList,1),1); 
AO.S2QF08.CommonNames            = ['SQF08'; 'SQF12';];
AO.S2QF08.ExcitationCurves       = lnls1_getexcdata(AO.S2QF08.CommonNames, 1);
AO.S2QF08.Monitor.MemberOf       = {};
AO.S2QF08.Monitor.Mode           = 'Simulator';
AO.S2QF08.Monitor.DataType       = 'Scalar';
AO.S2QF08.Monitor.ChannelNames   = lnls1_getname(AO.S2QF08.FamilyName, 'Monitor');
AO.S2QF08.Monitor.HW2PhysicsFcn  = @lnls1_hw2ph;
AO.S2QF08.Monitor.Physics2HWFcn  = @lnls1_ph2hw;
AO.S2QF08.Monitor.Units          = 'Hardware';
AO.S2QF08.Monitor.HWUnits        = 'Ampere';
AO.S2QF08.Monitor.PhysicsUnits   = 'meter^-2';
AO.S2QF08.Setpoint.MemberOf      = {'MachineConfig'};
AO.S2QF08.Setpoint.Mode          = 'Simulator';
AO.S2QF08.Setpoint.DataType      = 'Scalar';
AO.S2QF08.Setpoint.ChannelNames  = lnls1_getname(AO.S2QF08.FamilyName, 'Setpoint');
AO.S2QF08.Setpoint.HW2PhysicsFcn = @lnls1_hw2ph;
AO.S2QF08.Setpoint.Physics2HWFcn = @lnls1_ph2hw;
AO.S2QF08.Setpoint.Units         = 'Hardware';
AO.S2QF08.Setpoint.HWUnits       = 'Ampere';
AO.S2QF08.Setpoint.PhysicsUnits  = 'meter^-2';
AO.S2QF08.Setpoint.Range         = [0 225];
AO.S2QF08.Setpoint.Tolerance     = 0.1;
AO.S2QF08.Setpoint.DeltaRespMat  = 0.5; 

AO.S2QF09.FamilyName             = 'S2QF09';
AO.S2QF09.MemberOf               = {'PlotFamily'; 'S2QF09'; 'QFC'; 'QUAD'; 'Magnet';};
AO.S2QF09.DeviceList             = [2 1; 2 2];
AO.S2QF09.ElementList            = (1:size(AO.S2QF09.DeviceList,1))';
AO.S2QF09.Status                 = ones(size(AO.S2QF09.DeviceList,1),1); 
AO.S2QF09.CommonNames            = ['SQF09'; 'SQF11';];
AO.S2QF09.ExcitationCurves       = lnls1_getexcdata(AO.S2QF09.CommonNames, 1);
AO.S2QF09.Monitor.MemberOf       = {};
AO.S2QF09.Monitor.Mode           = 'Simulator';
AO.S2QF09.Monitor.DataType       = 'Scalar';
AO.S2QF09.Monitor.ChannelNames   = lnls1_getname(AO.S2QF09.FamilyName, 'Monitor');
AO.S2QF09.Monitor.HW2PhysicsFcn  = @lnls1_hw2ph;
AO.S2QF09.Monitor.Physics2HWFcn  = @lnls1_ph2hw;
AO.S2QF09.Monitor.Units          = 'Hardware';
AO.S2QF09.Monitor.HWUnits        = 'Ampere';
AO.S2QF09.Monitor.PhysicsUnits   = 'meter^-2';
AO.S2QF09.Setpoint.MemberOf      = {'MachineConfig'};
AO.S2QF09.Setpoint.Mode          = 'Simulator';
AO.S2QF09.Setpoint.DataType      = 'Scalar';
AO.S2QF09.Setpoint.ChannelNames  = lnls1_getname(AO.S2QF09.FamilyName, 'Setpoint');
AO.S2QF09.Setpoint.HW2PhysicsFcn = @lnls1_hw2ph;
AO.S2QF09.Setpoint.Physics2HWFcn = @lnls1_ph2hw;
AO.S2QF09.Setpoint.Units         = 'Hardware';
AO.S2QF09.Setpoint.HWUnits       = 'Ampere';
AO.S2QF09.Setpoint.PhysicsUnits  = 'meter^-2';
AO.S2QF09.Setpoint.Range         = [0 225];
AO.S2QF09.Setpoint.Tolerance     = 0.1;
AO.S2QF09.Setpoint.DeltaRespMat  = 0.5; 



%%%%%%%%%%%%%%
% Sextupoles %
%%%%%%%%%%%%%%


AO.S4SF.FamilyName             = 'S4SF';
AO.S4SF.MemberOf               = {'PlotFamily'; 'S4SF'; 'SEXT'; 'SF'; 'Magnet'; 'Chromaticity Corrector'};
AO.S4SF.DeviceList             = TwoPerSector;
AO.S4SF.ElementList            = [1 1; 1 2; 2 1; 2 2];
AO.S4SF.Status                 = ones(size(AO.S4SF.DeviceList,1),1);
AO.S4SF.CommonNames            = ['SSF04A'; 'SSF04B'; 'SSF10A'; 'SSF10B';]; 
AO.S4SF.ExcitationCurves       = lnls1_getexcdata(AO.S4SF.CommonNames, 1);
AO.S4SF.Monitor.MemberOf       = {};
AO.S4SF.Monitor.Mode           = 'Simulator';
AO.S4SF.Monitor.DataType       = 'Scalar';
AO.S4SF.Monitor.ChannelNames   = lnls1_getname(AO.S4SF.FamilyName, 'Monitor', AO.S4SF.DeviceList);
AO.S4SF.Monitor.HW2PhysicsFcn  = @lnls1_hw2ph;
AO.S4SF.Monitor.Physics2HWFcn  = @lnls1_ph2hw;
AO.S4SF.Monitor.Units          = 'Hardware';
AO.S4SF.Monitor.HWUnits        = 'Ampere';
AO.S4SF.Monitor.PhysicsUnits   = 'meter^-3';
AO.S4SF.Setpoint.MemberOf      = {'MachineConfig';};
AO.S4SF.Setpoint.Mode          = 'Simulator';
AO.S4SF.Setpoint.DataType      = 'Scalar';
AO.S4SF.Setpoint.ChannelNames  = lnls1_getname(AO.S4SF.FamilyName, 'Setpoint', AO.S4SF.DeviceList);
AO.S4SF.Setpoint.HW2PhysicsFcn = @lnls1_hw2ph;
AO.S4SF.Setpoint.Physics2HWFcn = @lnls1_ph2hw;
AO.S4SF.Setpoint.Units         = 'Hardware';
AO.S4SF.Setpoint.HWUnits       = 'Ampere';
AO.S4SF.Setpoint.PhysicsUnits  = 'meter^-3';
AO.S4SF.Setpoint.Range         = [0 220];
AO.S4SF.Setpoint.Tolerance     = .1;
AO.S4SF.Setpoint.DeltaRespMat  = .1;

AO.S4SD.FamilyName             = 'S4SD';
AO.S4SD.MemberOf               = {'PlotFamily'; 'S4SD'; 'SEXT'; 'SF'; 'Magnet'; 'Chromaticity Corrector'};
AO.S4SD.DeviceList             = TwoPerSector;
AO.S4SD.ElementList            = [1 1; 1 2; 2 1; 2 2];
AO.S4SD.Status                 = ones(size(AO.S4SD.DeviceList,1),1);
AO.S4SD.CommonNames            = ['SSD03'; 'SSD05'; 'SSD09'; 'SSD11';]; 
AO.S4SD.ExcitationCurves       = lnls1_getexcdata(AO.S4SD.CommonNames, 1);
AO.S4SD.Monitor.MemberOf       = {};
AO.S4SD.Monitor.Mode           = 'Simulator';
AO.S4SD.Monitor.DataType       = 'Scalar';
AO.S4SD.Monitor.ChannelNames   = lnls1_getname(AO.S4SD.FamilyName, 'Monitor', AO.S4SD.DeviceList);
AO.S4SD.Monitor.HW2PhysicsFcn  = @lnls1_hw2ph;
AO.S4SD.Monitor.Physics2HWFcn  = @lnls1_ph2hw;
AO.S4SD.Monitor.Units          = 'Hardware';
AO.S4SD.Monitor.HWUnits        = 'Ampere';
AO.S4SD.Monitor.PhysicsUnits   = 'meter^-3';
AO.S4SD.Setpoint.MemberOf      = {'MachineConfig';};
AO.S4SD.Setpoint.Mode          = 'Simulator';
AO.S4SD.Setpoint.DataType      = 'Scalar';
AO.S4SD.Setpoint.ChannelNames  = lnls1_getname(AO.S4SD.FamilyName, 'Setpoint', AO.S4SD.DeviceList);
AO.S4SD.Setpoint.HW2PhysicsFcn = @lnls1_hw2ph;
AO.S4SD.Setpoint.Physics2HWFcn = @lnls1_ph2hw;
AO.S4SD.Setpoint.Units         = 'Hardware';
AO.S4SD.Setpoint.HWUnits       = 'Ampere';
AO.S4SD.Setpoint.PhysicsUnits  = 'meter^-3';
AO.S4SD.Setpoint.Range         = [0 220];
AO.S4SD.Setpoint.Tolerance     = .1;
AO.S4SD.Setpoint.DeltaRespMat  = .1;


%%%%%%%%%%%%%%%%%%%
% Skew Quadrupole %
%%%%%%%%%%%%%%%%%%%

AO.SKEWQUAD.FamilyName  = 'SKEWQUAD';
AO.SKEWQUAD.MemberOf    = {'PlotFamily'; 'SKEWQUAD'; 'Magnet'; 'Coupling Corrector'};
AO.SKEWQUAD.DeviceList  = [1 1;2 1;];
AO.SKEWQUAD.ElementList = (1:size(AO.SKEWQUAD.DeviceList,1))';
AO.SKEWQUAD.Status      = ones(size(AO.SKEWQUAD.DeviceList,1),1);
AO.SKEWQUAD.Position    = [];
AO.SKEWQUAD.CommonNames = ['SQS07A'; 'SQS07B'];
AO.SKEWQUAD.ExcitationCurves = lnls1_getexcdata(AO.SKEWQUAD.CommonNames, 1);

AO.SKEWQUAD.Monitor.MemberOf = {};
AO.SKEWQUAD.Monitor.Mode = 'Simulator';
AO.SKEWQUAD.Monitor.DataType = 'Scalar';
AO.SKEWQUAD.Monitor.ChannelNames = lnls1_getname(AO.SKEWQUAD.FamilyName, 'Monitor', AO.SKEWQUAD.DeviceList);
AO.SKEWQUAD.Monitor.HW2PhysicsFcn = @lnls1_hw2ph;
AO.SKEWQUAD.Monitor.Physics2HWFcn = @lnls1_ph2hw;
AO.SKEWQUAD.Monitor.Units        = 'Hardware';
AO.SKEWQUAD.Monitor.HWUnits      = 'Ampere';
AO.SKEWQUAD.Monitor.PhysicsUnits = 'meter^-2';

AO.SKEWQUAD.Setpoint.MemberOf = {'MachineConfig';};
AO.SKEWQUAD.Setpoint.Mode = 'Simulator';
AO.SKEWQUAD.Setpoint.DataType = 'Scalar';
AO.SKEWQUAD.Setpoint.ChannelNames = lnls1_getname(AO.SKEWQUAD.FamilyName, 'Setpoint', AO.SKEWQUAD.DeviceList);
AO.SKEWQUAD.Setpoint.HW2PhysicsFcn = @lnls1_hw2ph;
AO.SKEWQUAD.Setpoint.Physics2HWFcn = @lnls1_ph2hw;
AO.SKEWQUAD.Setpoint.Units        = 'Hardware';
AO.SKEWQUAD.Setpoint.HWUnits      = 'Ampere';
AO.SKEWQUAD.Setpoint.PhysicsUnits = 'meter^-2';
AO.SKEWQUAD.Setpoint.Range        = [-10 10];
AO.SKEWQUAD.Setpoint.Tolerance    = .1;
AO.SKEWQUAD.Setpoint.DeltaRespMat = .05;


%%%%%%%%%%%%%%%%%%%%%
% Corrector Magnets %
%%%%%%%%%%%%%%%%%%%%%

% HCM
AO.HCM.FamilyName  = 'HCM';
AO.HCM.MemberOf    = {'PlotFamily'; 'COR'; 'HCM'; 'Magnet'};
AO.HCM.DeviceList  = [1 1; 1 2; 1 3; 1 4; 2 1; 2 2; 2 3; 2 4; 2 5; 2 6];
AO.HCM.ElementList = (1:size(AO.HCM.DeviceList,1))';
AO.HCM.Status      = ones(size(AO.HCM.DeviceList,1),1);
AO.HCM.Position    = [];
AO.HCM.CommonNames = [ ...
    'SCH02'; 'SCH04'; 'SCH05'; 'SCH06'; 
    'SCH07'; 'SCH08'; 'SCH09'; 'SCH10'; 'SCH12'; 'SCH01' ...
];
AO.HCM.ExcitationCurves = lnls1_getexcdata(AO.HCM.CommonNames, 1);

AO.HCM.Monitor.MemberOf = {'Horizontal'; 'COR'; 'HCM'; 'Magnet';};
AO.HCM.Monitor.Mode = 'Simulator';
AO.HCM.Monitor.DataType = 'Scalar';
AO.HCM.Monitor.ChannelNames = lnls1_getname(AO.HCM.FamilyName, 'Monitor', AO.HCM.DeviceList);
AO.HCM.Monitor.HW2PhysicsFcn = @lnls1_hw2ph;
AO.HCM.Monitor.Physics2HWFcn = @lnls1_ph2hw;
AO.HCM.Monitor.Units        = 'Hardware';
AO.HCM.Monitor.HWUnits      = 'Ampere';
AO.HCM.Monitor.PhysicsUnits = 'Radian';

AO.HCM.Setpoint.MemberOf = {'MachineConfig'; 'Horizontal'; 'COR'; 'HCM'; 'Magnet'; 'Setpoint'; 'measbpmresp';};
AO.HCM.Setpoint.Mode = 'Simulator';
AO.HCM.Setpoint.DataType = 'Scalar';
AO.HCM.Setpoint.ChannelNames = lnls1_getname(AO.HCM.FamilyName, 'Setpoint', AO.HCM.DeviceList);
AO.HCM.Setpoint.HW2PhysicsFcn = @lnls1_hw2ph;
AO.HCM.Setpoint.Physics2HWFcn = @lnls1_ph2hw;
AO.HCM.Setpoint.Units        = 'Hardware';
AO.HCM.Setpoint.HWUnits      = 'Ampere';
AO.HCM.Setpoint.PhysicsUnits = 'Radian';
AO.HCM.Setpoint.Range        = [-10 10];
AO.HCM.Setpoint.Tolerance    = .1;
AO.HCM.Setpoint.DeltaRespMat = 0.651; % @1.37Gev: 0.651 Amp -> 0.1 mrad -> DeltaXMax ~ 1mm
 
% VCM
AO.VCM.FamilyName  = 'VCM';
AO.VCM.MemberOf    = {'PlotFamily'; 'COR'; 'VCM'; 'Magnet'};
AO.VCM.DeviceList  = ThreePerSector;
AO.VCM.ElementList = (1:size(AO.VCM.DeviceList,1))';
AO.VCM.Status      = ones(size(AO.VCM.DeviceList,1),1);
AO.VCM.Position    = [];
AO.VCM.CommonNames = [ ...
    'SCV01'; 'SCV03'; 'SCV05'; ...
    'SCV07'; 'SCV09'; 'SCV11'; ...
];
AO.VCM.ExcitationCurves = lnls1_getexcdata(AO.VCM.CommonNames, 1);


AO.VCM.Monitor.MemberOf = {'Vertical'; 'COR'; 'ACV'; 'VCM'; 'Magnet';};
AO.VCM.Monitor.Mode = 'Simulator';
AO.VCM.Monitor.DataType = 'Scalar';
AO.VCM.Monitor.ChannelNames = lnls1_getname(AO.VCM.FamilyName, 'Monitor', AO.VCM.DeviceList);
AO.VCM.Monitor.HW2PhysicsFcn = @lnls1_hw2ph;
AO.VCM.Monitor.Physics2HWFcn = @lnls1_ph2hw;
AO.VCM.Monitor.Units        = 'Hardware';
AO.VCM.Monitor.HWUnits      = 'Ampere';
AO.VCM.Monitor.PhysicsUnits = 'Radian';

AO.VCM.Setpoint.MemberOf = {'MachineConfig'; 'Vertical'; 'COR'; 'VCM'; 'Magnet'; 'Setpoint'; 'measbpmresp';};
AO.VCM.Setpoint.Mode = 'Simulator';
AO.VCM.Setpoint.DataType = 'Scalar';
AO.VCM.Setpoint.ChannelNames = lnls1_getname(AO.VCM.FamilyName, 'Setpoint', AO.VCM.DeviceList);
AO.VCM.Setpoint.HW2PhysicsFcn = @lnls1_hw2ph;
AO.VCM.Setpoint.Physics2HWFcn = @lnls1_ph2hw;
AO.VCM.Setpoint.Units        = 'Hardware';
AO.VCM.Setpoint.HWUnits      = 'Ampere';
AO.VCM.Setpoint.PhysicsUnits = 'Radian';
AO.VCM.Setpoint.Range        = [-10 10];
AO.VCM.Setpoint.Tolerance    = .1;
AO.VCM.Setpoint.DeltaRespMat = 1.0;






% BPMx
AO.BPMx.FamilyName  = 'BPMx';
AO.BPMx.MemberOf    = {'PlotFamily'; 'BPM'; 'BPMx'; 'Diagnostics'};
AO.BPMx.DeviceList = [1 1; 1 2; 1 3; 1 4; 1 5; 1 6; 2 1; 2 2; 2 3; 2 4; 2 5; 2 6];
AO.BPMx.ElementList = (1:size(AO.BPMx.DeviceList,1))';
AO.BPMx.Status      = ones(size(AO.BPMx.DeviceList,1),1);
AO.BPMx.Position    = [];
AO.BPMx.CommonNames = [ ...
    'SMP01';'SMP02';'SMP03';'SMP04';'SMP05';'SMP06'; ...
    'SMP07';'SMP08';'SMP09';'SMP10';'SMP11';'SMP12'; ...
];

AO.BPMx.Monitor.MemberOf = {'BPMx'; 'Monitor';};
AO.BPMx.Monitor.Mode = 'Simulator';
AO.BPMx.Monitor.DataType = 'Scalar';
AO.BPMx.Monitor.ChannelNames = lnls1_getname(AO.BPMx.FamilyName, 'Monitor', AO.BPMx.DeviceList);
AO.BPMx.Monitor.HW2PhysicsParams = 1e-3;  % HW [mm], Simulator [Meters]
AO.BPMx.Monitor.Physics2HWParams = 1000;
AO.BPMx.Monitor.Units        = 'Hardware';
AO.BPMx.Monitor.HWUnits      = 'mm';
AO.BPMx.Monitor.PhysicsUnits = 'meter';
AO.BPMx.Monitor.SpecialFunctionGet = @getbpmlnls;


% BPMy
AO.BPMy.FamilyName  = 'BPMy';
AO.BPMy.MemberOf    = {'PlotFamily'; 'BPM'; 'BPMy'; 'Diagnostics'};
AO.BPMy.DeviceList  = AO.BPMx.DeviceList;
AO.BPMy.ElementList = (1:size(AO.BPMy.DeviceList,1))';
AO.BPMy.Status      = ones(size(AO.BPMy.DeviceList,1),1);
AO.BPMy.Position    = [];
AO.BPMy.CommonNames = AO.BPMx.CommonNames;

AO.BPMy.Monitor.MemberOf = {'BPMy'; 'Monitor';};
AO.BPMy.Monitor.Mode = 'Simulator';
AO.BPMy.Monitor.DataType = 'Scalar';
AO.BPMy.Monitor.ChannelNames = lnls1_getname(AO.BPMy.FamilyName, 'Monitor', AO.BPMy.DeviceList);
AO.BPMy.Monitor.HW2PhysicsParams = 1e-3;  % HW [mm], Simulator [Meters]
AO.BPMy.Monitor.Physics2HWParams = 1000;
AO.BPMy.Monitor.Units        = 'Hardware';
AO.BPMy.Monitor.HWUnits      = 'mm';
AO.BPMy.Monitor.PhysicsUnits = 'meter';
AO.BPMy.Monitor.SpecialFunctionGet = @getbpmlnls;



%%%%%%%%%%%
% Kickers %
%%%%%%%%%%%

AO.KICKER.FamilyName  = 'KICKER';
AO.KICKER.MemberOf    = {'PlotFamily'; 'Injection'; };
AO.KICKER.DeviceList  = [1 1; 2 1;];
AO.KICKER.ElementList = (1:size(AO.KICKER.DeviceList,1))';
AO.KICKER.Status      = ones(size(AO.KICKER.DeviceList,1),1);
AO.KICKER.Position    = [];
AO.KICKER.CommonNames = ['SKC02'; 'SKC12';];
AO.KICKER.ExcitationCurves = lnls1_getexcdata(AO.KICKER.CommonNames, 1);

AO.KICKER.Setpoint.MemberOf = {'MachineConfig'; 'KICKER'; 'Setpoint';};
AO.KICKER.Setpoint.Mode     = 'Simulator';
AO.KICKER.Setpoint.DataType      = 'Scalar';
AO.KICKER.Setpoint.ChannelNames  = lnls1_getname(AO.KICKER.FamilyName, 'Setpoint', AO.KICKER.DeviceList);
AO.KICKER.Setpoint.HW2PhysicsFcn = @lnls1_hw2ph;
AO.KICKER.Setpoint.Physics2HWFcn = @lnls1_ph2hw;
AO.KICKER.Setpoint.Units        = 'Hardware';
AO.KICKER.Setpoint.HWUnits      = 'KiloVolt';
AO.KICKER.Setpoint.PhysicsUnits = 'Radian';
AO.KICKER.Setpoint.Range        = [0 25];
AO.KICKER.Setpoint.Tolerance    = .1;

AO.KICKER.Monitor.MemberOf = {'KICKER'; 'Setpoint';};
AO.KICKER.Monitor.Mode     = 'Simulator';
AO.KICKER.Monitor.DataType      = 'Scalar';
AO.KICKER.Monitor.ChannelNames  = lnls1_getname(AO.KICKER.FamilyName, 'Monitor', AO.KICKER.DeviceList);
AO.KICKER.Monitor.HW2PhysicsFcn = @lnls1_hw2ph;
AO.KICKER.Monitor.Physics2HWFcn = @lnls1_ph2hw;
AO.KICKER.Monitor.Units        = 'Hardware';
AO.KICKER.Monitor.HWUnits      = 'KiloVolt';
AO.KICKER.Monitor.PhysicsUnits = 'Radian';



%%%%%%%%
% Tune %
%%%%%%%%
AO.TUNE.FamilyName = 'TUNE';
AO.TUNE.MemberOf = {'TUNE';};
AO.TUNE.DeviceList = [1 1;1 2;1 3];
AO.TUNE.ElementList = [1;2;3];
AO.TUNE.Status = [1; 1; 0];
AO.TUNE.CommonNames = ['TuneX'; 'TuneY'; 'TuneS'];

AO.TUNE.Monitor.MemberOf   = {'TUNE', 'Monitor'};
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
AO.RF.Monitor.ChannelNames      = lnls1_getname('RF', 'Monitor');
AO.RF.Monitor.HW2PhysicsParams  = 1e+6;
AO.RF.Monitor.Physics2HWParams  = 1e-6;
AO.RF.Monitor.Units             = 'Hardware';
AO.RF.Monitor.HWUnits           = 'MHz';
AO.RF.Monitor.PhysicsUnits      = 'Hz';

AO.RF.Setpoint.MemberOf         = {'MachineConfig';};
AO.RF.Setpoint.Mode             = 'Simulator';
AO.RF.Setpoint.DataType         = 'Scalar';
AO.RF.Setpoint.ChannelNames     = lnls1_getname('RF', 'Setpoint');
AO.RF.Setpoint.HW2PhysicsParams = 1e+6;
AO.RF.Setpoint.Physics2HWParams = 1e-6;
AO.RF.Setpoint.Units            = 'Hardware';
AO.RF.Setpoint.HWUnits          = 'MHz';
AO.RF.Setpoint.PhysicsUnits     = 'Hz';
AO.RF.Setpoint.Range            = [476.062 476.068];
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
setoperationalmode(OperationalMode);





% Convert the response matrix delta to hardware units (if it's not already)
% 'NoEnergyScaling' is needed so that the BEND is not read to get the energy (this is a setup file)  

%AO = getao;
%AO.HCM.Setpoint.DeltaRespMat  = physics2hw('HCM', 'Setpoint', AO.HCM.Setpoint.DeltaRespMat, AO.HCM.DeviceList, 'NoEnergyScaling');
%AO.VCM.Setpoint.DeltaRespMat  = physics2hw('VCM', 'Setpoint', AO.VCM.Setpoint.DeltaRespMat, AO.VCM.DeviceList, 'NoEnergyScaling');
%AO.QF.Setpoint.DeltaRespMat   = physics2hw('QF',  'Setpoint', AO.QF.Setpoint.DeltaRespMat,  AO.QF.DeviceList,  'NoEnergyScaling');
%AO.QD.Setpoint.DeltaRespMat   = physics2hw('QD',  'Setpoint', AO.QD.Setpoint.DeltaRespMat,  AO.QD.DeviceList,  'NoEnergyScaling');
%AO.QFC.Setpoint.DeltaRespMat  = physics2hw('QFC', 'Setpoint', AO.QFC.Setpoint.DeltaRespMat, AO.QFC.DeviceList, 'NoEnergyScaling');
%AO.SF.Setpoint.DeltaRespMat   = physics2hw('SF',  'Setpoint', AO.SF.Setpoint.DeltaRespMat,  AO.SF.DeviceList,  'NoEnergyScaling');
%AO.SD.Setpoint.DeltaRespMat   = physics2hw('SD',  'Setpoint', AO.SD.Setpoint.DeltaRespMat,  AO.SD.DeviceList,  'NoEnergyScaling');
%setao(AO);

lnls1_comm_connect_inputdlg;

 
function [OnePerSector, TwoPerSector, ThreePerSector, FourPerSector, FivePerSector, SixPerSector] = buildthedevicelists

NSector = 2;

OnePerSector=[];
TwoPerSector=[];
ThreePerSector=[];
FourPerSector=[];
FivePerSector=[];
SixPerSector=[];
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
end
