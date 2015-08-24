function sirius_init(OperationalMode)
%LNLSINIT - MML initialization file for the VUV ring at sirius3
%  lnlsinit(OperationalMode)
%
%  See also setoperationalmode

% 2012-07-10 Modificado para sirius3_lattice_e025 - Afonso




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

% Add additional directories with SIRIUS_V03 specific stuff.
MMLROOT = getmmlroot('IgnoreTheAD');
%addpath(fullfile(MMLROOT,'machine','SIRIUS_V03','StorageRing','scripts'), '-begin');

% Get the device lists (local function)
%[OnePerSector, TwoPerSector, ThreePerSector, FourPerSector, FivePerSector, SixPerSector, EightPerSector, TenPerSector, TwelvePerSector, FifteenPerSector, SixteenPerSector, EighteenPerSector, TwentyFourPerSector] = buildthedevicelists;


%% dipoles

AO.b1.FamilyName  = 'b1';
AO.b1.MemberOf    = {'PlotFamily'; 'b1'; 'BEND'; 'Magnet';};
AO.b1.DeviceList  = getDeviceList(10,4);
AO.b1.ElementList = (1:size(AO.b1.DeviceList,1))';
AO.b1.Status      = ones(size(AO.b1.DeviceList,1),1);
AO.b1.Position    = [];

AO.b1.Monitor.MemberOf = {};
AO.b1.Monitor.Mode = 'Simulator';
AO.b1.Monitor.DataType = 'Scalar';
AO.b1.Monitor.ChannelNames = sirius_getname(AO.b1.FamilyName, 'Monitor', AO.b1.DeviceList);
AO.b1.Monitor.HW2PhysicsParams = 1;
AO.b1.Monitor.Physics2HWParams = 1;
AO.b1.Monitor.Units        = 'Hardware';
AO.b1.Monitor.HWUnits      = 'Ampere';
AO.b1.Monitor.PhysicsUnits = 'GeV';

AO.b1.Setpoint.MemberOf = {'MachineConfig';};
AO.b1.Setpoint.Mode = 'Simulator';
AO.b1.Setpoint.DataType = 'Scalar';
AO.b1.Setpoint.ChannelNames = sirius_getname(AO.b1.FamilyName, 'Setpoint', AO.b1.DeviceList);
AO.b1.Setpoint.HW2PhysicsParams = 1;
AO.b1.Setpoint.Physics2HWParams = 1;
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

AO.b2.Monitor.MemberOf = {};
AO.b2.Monitor.Mode = 'Simulator';
AO.b2.Monitor.DataType = 'Scalar';
AO.b2.Monitor.ChannelNames = sirius_getname(AO.b2.FamilyName, 'Monitor', AO.b2.DeviceList);
AO.b2.Monitor.HW2PhysicsParams = 1;
AO.b2.Monitor.Physics2HWParams = 1;
AO.b2.Monitor.Units        = 'Hardware';
AO.b2.Monitor.HWUnits      = 'Ampere';
AO.b2.Monitor.PhysicsUnits = 'GeV';

AO.b2.Setpoint.MemberOf = {'MachineConfig';};
AO.b2.Setpoint.Mode = 'Simulator';
AO.b2.Setpoint.DataType = 'Scalar';
AO.b2.Setpoint.ChannelNames = sirius_getname(AO.b2.FamilyName, 'Setpoint', AO.b2.DeviceList);
AO.b2.Setpoint.HW2PhysicsParams = 1;
AO.b2.Setpoint.Physics2HWParams = 1;
AO.b2.Setpoint.Units        = 'Hardware';
AO.b2.Setpoint.HWUnits      = 'Ampere';
AO.b2.Setpoint.PhysicsUnits = 'GeV';
AO.b2.Setpoint.Range        = [0 300];
AO.b2.Setpoint.Tolerance    = .1;
AO.b2.Setpoint.DeltaRespMat = .01;


AO.bc_lf.FamilyName  = 'bc_lf';
AO.bc_lf.MemberOf    = {'PlotFamily'; 'bc_lf'; 'BEND'; 'Magnet';};
AO.bc_lf.DeviceList  = getDeviceList(10,4);
AO.bc_lf.ElementList = (1:size(AO.bc_lf.DeviceList,1))';
AO.bc_lf.Status      = ones(size(AO.bc_lf.DeviceList,1),1);
AO.bc_lf.Position    = [];

AO.bc_lf.Monitor.MemberOf = {};
AO.bc_lf.Monitor.Mode = 'Simulator';
AO.bc_lf.Monitor.DataType = 'Scalar';
AO.bc_lf.Monitor.ChannelNames = sirius_getname(AO.bc_lf.FamilyName, 'Monitor', AO.bc_lf.DeviceList);
AO.bc_lf.Monitor.HW2PhysicsParams = 1;
AO.bc_lf.Monitor.Physics2HWParams = 1;
AO.bc_lf.Monitor.Units        = 'Hardware';
AO.bc_lf.Monitor.HWUnits      = 'Ampere';
AO.bc_lf.Monitor.PhysicsUnits = 'GeV';

AO.bc_lf.Setpoint.MemberOf = {'MachineConfig';};
AO.bc_lf.Setpoint.Mode = 'Simulator';
AO.bc_lf.Setpoint.DataType = 'Scalar';
AO.bc_lf.Setpoint.ChannelNames = sirius_getname(AO.bc_lf.FamilyName, 'Setpoint', AO.bc_lf.DeviceList);
AO.bc_lf.Setpoint.HW2PhysicsParams = 1;
AO.bc_lf.Setpoint.Physics2HWParams = 1;
AO.bc_lf.Setpoint.Units        = 'Hardware';
AO.bc_lf.Setpoint.HWUnits      = 'Ampere';
AO.bc_lf.Setpoint.PhysicsUnits = 'GeV';
AO.bc_lf.Setpoint.Range        = [0 300];
AO.bc_lf.Setpoint.Tolerance    = .1;
AO.bc_lf.Setpoint.DeltaRespMat = .01;


AO.bc_hf.FamilyName  = 'bc_hf';
AO.bc_hf.MemberOf    = {'PlotFamily'; 'bc_hf'; 'BEND'; 'Magnet';};
AO.bc_hf.DeviceList  = getDeviceList(10,2);
AO.bc_hf.ElementList = (1:size(AO.bc_hf.DeviceList,1))';
AO.bc_hf.Status      = ones(size(AO.bc_hf.DeviceList,1),1);
AO.bc_hf.Position    = [];

AO.bc_hf.Monitor.MemberOf = {};
AO.bc_hf.Monitor.Mode = 'Simulator';
AO.bc_hf.Monitor.DataType = 'Scalar';
AO.bc_hf.Monitor.ChannelNames = sirius_getname(AO.bc_hf.FamilyName, 'Monitor', AO.bc_hf.DeviceList);
AO.bc_hf.Monitor.HW2PhysicsParams = 1;
AO.bc_hf.Monitor.Physics2HWParams = 1;
AO.bc_hf.Monitor.Units        = 'Hardware';
AO.bc_hf.Monitor.HWUnits      = 'Ampere';
AO.bc_hf.Monitor.PhysicsUnits = 'GeV';

AO.bc_hf.Setpoint.MemberOf = {'MachineConfig';};
AO.bc_hf.Setpoint.Mode = 'Simulator';
AO.bc_hf.Setpoint.DataType = 'Scalar';
AO.bc_hf.Setpoint.ChannelNames = sirius_getname(AO.bc_hf.FamilyName, 'Setpoint', AO.bc_hf.DeviceList);
AO.bc_hf.Setpoint.HW2PhysicsParams = 1;
AO.bc_hf.Setpoint.Physics2HWParams = 1;
AO.bc_hf.Setpoint.Units        = 'Hardware';
AO.bc_hf.Setpoint.HWUnits      = 'Ampere';
AO.bc_hf.Setpoint.PhysicsUnits = 'GeV';
AO.bc_hf.Setpoint.Range        = [0 300];
AO.bc_hf.Setpoint.Tolerance    = .1;
AO.bc_hf.Setpoint.DeltaRespMat = .01;

%% quadrupoles 

AO.qfa.FamilyName = 'qfa';
AO.qfa.MemberOf    = {'PlotFamily'; 'qfa'; 'QUAD'; 'Magnet';'q20';};
AO.qfa.DeviceList  = getDeviceList(10,2);
AO.qfa.ElementList = (1:size(AO.qfa.DeviceList,1))';
AO.qfa.Status      = ones(size(AO.qfa.DeviceList,1),1);
AO.qfa.Position    = [];
AO.qfa.Monitor.MemberOf = {};
AO.qfa.Monitor.Mode = 'Simulator';
AO.qfa.Monitor.DataType = 'Scalar';
AO.qfa.Monitor.Units        = 'Hardware';
AO.qfa.Monitor.HWUnits      = 'Ampere';
AO.qfa.Monitor.PhysicsUnits = 'meter^-2';
AO.qfa.Setpoint.MemberOf      = {'MachineConfig'};
AO.qfa.Setpoint.Mode          = 'Simulator';
AO.qfa.Setpoint.DataType      = 'Scalar';
AO.qfa.Setpoint.Units         = 'Hardware';
AO.qfa.Setpoint.HWUnits       = 'Ampere';
AO.qfa.Setpoint.PhysicsUnits  = 'meter^-2';
AO.qfa.Setpoint.Range         = [0 225];
AO.qfa.Setpoint.Tolerance     = 0.2;
AO.qfa.Setpoint.DeltaRespMat  = 0.5; 

AO.qdb2.FamilyName = 'qdb2';
AO.qdb2.MemberOf    = {'PlotFamily'; 'qdb2'; 'QUAD'; 'Magnet';'q14';};
AO.qdb2.DeviceList  = getDeviceList(10,2);
AO.qdb2.ElementList = (1:size(AO.qdb2.DeviceList,1))';
AO.qdb2.Status      = ones(size(AO.qdb2.DeviceList,1),1);
AO.qdb2.Position    = [];
AO.qdb2.Monitor.MemberOf = {};
AO.qdb2.Monitor.Mode = 'Simulator';
AO.qdb2.Monitor.DataType = 'Scalar';
AO.qdb2.Monitor.Units        = 'Hardware';
AO.qdb2.Monitor.HWUnits      = 'Ampere';
AO.qdb2.Monitor.PhysicsUnits = 'meter^-2';
AO.qdb2.Setpoint.MemberOf      = {'MachineConfig'};
AO.qdb2.Setpoint.Mode          = 'Simulator';
AO.qdb2.Setpoint.DataType      = 'Scalar';
AO.qdb2.Setpoint.Units         = 'Hardware';
AO.qdb2.Setpoint.HWUnits       = 'Ampere';
AO.qdb2.Setpoint.PhysicsUnits  = 'meter^-2';
AO.qdb2.Setpoint.Range         = [0 225];
AO.qdb2.Setpoint.Tolerance     = 0.2;
AO.qdb2.Setpoint.DeltaRespMat  = 0.5; 

AO.qfb.FamilyName = 'qfb';
AO.qfb.MemberOf    = {'PlotFamily'; 'qfb'; 'QUAD'; 'Magnet';'q30';};
AO.qfb.DeviceList  = getDeviceList(10,2);
AO.qfb.ElementList = (1:size(AO.qfb.DeviceList,1))';
AO.qfb.Status      = ones(size(AO.qfb.DeviceList,1),1);
AO.qfb.Position    = [];
AO.qfb.Monitor.MemberOf = {};
AO.qfb.Monitor.Mode = 'Simulator';
AO.qfb.Monitor.DataType = 'Scalar';
AO.qfb.Monitor.Units        = 'Hardware';
AO.qfb.Monitor.HWUnits      = 'Ampere';
AO.qfb.Monitor.PhysicsUnits = 'meter^-2';
AO.qfb.Setpoint.MemberOf      = {'MachineConfig'};
AO.qfb.Setpoint.Mode          = 'Simulator';
AO.qfb.Setpoint.DataType      = 'Scalar';
AO.qfb.Setpoint.Units         = 'Hardware';
AO.qfb.Setpoint.HWUnits       = 'Ampere';
AO.qfb.Setpoint.PhysicsUnits  = 'meter^-2';
AO.qfb.Setpoint.Range         = [0 225];
AO.qfb.Setpoint.Tolerance     = 0.2;
AO.qfb.Setpoint.DeltaRespMat  = 0.5; 

AO.qdb1.FamilyName = 'qdb1';
AO.qdb1.MemberOf    = {'PlotFamily'; 'qdb1'; 'QUAD'; 'Magnet';'q14';};
AO.qdb1.DeviceList  = getDeviceList(10,2);
AO.qdb1.ElementList = (1:size(AO.qdb1.DeviceList,1))';
AO.qdb1.Status      = ones(size(AO.qdb1.DeviceList,1),1);
AO.qdb1.Position    = [];
AO.qdb1.Monitor.MemberOf = {};
AO.qdb1.Monitor.Mode = 'Simulator';
AO.qdb1.Monitor.DataType = 'Scalar';
AO.qdb1.Monitor.Units        = 'Hardware';
AO.qdb1.Monitor.HWUnits      = 'Ampere';
AO.qdb1.Monitor.PhysicsUnits = 'meter^-2';
AO.qdb1.Setpoint.MemberOf      = {'MachineConfig'};
AO.qdb1.Setpoint.Mode          = 'Simulator';
AO.qdb1.Setpoint.DataType      = 'Scalar';
AO.qdb1.Setpoint.Units         = 'Hardware';
AO.qdb1.Setpoint.HWUnits       = 'Ampere';
AO.qdb1.Setpoint.PhysicsUnits  = 'meter^-2';
AO.qdb1.Setpoint.Range         = [0 225];
AO.qdb1.Setpoint.Tolerance     = 0.2;
AO.qdb1.Setpoint.DeltaRespMat  = 0.5; 

AO.qda.FamilyName = 'qda';
AO.qda.MemberOf    = {'PlotFamily'; 'qda'; 'QUAD'; 'Magnet';'q14';};
AO.qda.DeviceList  = getDeviceList(10,2);
AO.qda.ElementList = (1:size(AO.qda.DeviceList,1))';
AO.qda.Status      = ones(size(AO.qda.DeviceList,1),1);
AO.qda.Position    = [];
AO.qda.Monitor.MemberOf = {};
AO.qda.Monitor.Mode = 'Simulator';
AO.qda.Monitor.DataType = 'Scalar';
AO.qda.Monitor.Units        = 'Hardware';
AO.qda.Monitor.HWUnits      = 'Ampere';
AO.qda.Monitor.PhysicsUnits = 'meter^-2';
AO.qda.Setpoint.MemberOf      = {'MachineConfig'};
AO.qda.Setpoint.Mode          = 'Simulator';
AO.qda.Setpoint.DataType      = 'Scalar';
AO.qda.Setpoint.Units         = 'Hardware';
AO.qda.Setpoint.HWUnits       = 'Ampere';
AO.qda.Setpoint.PhysicsUnits  = 'meter^-2';
AO.qda.Setpoint.Range         = [0 225];
AO.qda.Setpoint.Tolerance     = 0.2;
AO.qda.Setpoint.DeltaRespMat  = 0.5;


AO.qf1.FamilyName = 'qf1';
AO.qf1.MemberOf    = {'PlotFamily'; 'qf1'; 'QUAD'; 'Magnet';'q20';};
AO.qf1.DeviceList  = getDeviceList(10,4);
AO.qf1.ElementList = (1:size(AO.qf1.DeviceList,1))';
AO.qf1.Status      = ones(size(AO.qf1.DeviceList,1),1);
AO.qf1.Position    = [];
AO.qf1.Monitor.MemberOf = {};
AO.qf1.Monitor.Mode = 'Simulator';
AO.qf1.Monitor.DataType = 'Scalar';
AO.qf1.Monitor.Units        = 'Hardware';
AO.qf1.Monitor.HWUnits      = 'Ampere';
AO.qf1.Monitor.PhysicsUnits = 'meter^-2';
AO.qf1.Setpoint.MemberOf      = {'MachineConfig'};
AO.qf1.Setpoint.Mode          = 'Simulator';
AO.qf1.Setpoint.DataType      = 'Scalar';
AO.qf1.Setpoint.Units         = 'Hardware';
AO.qf1.Setpoint.HWUnits       = 'Ampere';
AO.qf1.Setpoint.PhysicsUnits  = 'meter^-2';
AO.qf1.Setpoint.Range         = [0 225];
AO.qf1.Setpoint.Tolerance     = 0.2;
AO.qf1.Setpoint.DeltaRespMat  = 0.5;

AO.qf2.FamilyName = 'qf2';
AO.qf2.MemberOf    = {'PlotFamily'; 'qf2'; 'QUAD'; 'Magnet';'q20';};
AO.qf2.DeviceList  = getDeviceList(10,4);
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
AO.qf2.Setpoint.Units         = 'Hardware';
AO.qf2.Setpoint.HWUnits       = 'Ampere';
AO.qf2.Setpoint.PhysicsUnits  = 'meter^-2';
AO.qf2.Setpoint.Range         = [0 225];
AO.qf2.Setpoint.Tolerance     = 0.2;
AO.qf2.Setpoint.DeltaRespMat  = 0.5;

AO.qf3.FamilyName = 'qf3';
AO.qf3.MemberOf    = {'PlotFamily'; 'qf3'; 'QUAD'; 'Magnet';'q20';};
AO.qf3.DeviceList  = getDeviceList(10,4);
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
AO.qf3.Setpoint.Units         = 'Hardware';
AO.qf3.Setpoint.HWUnits       = 'Ampere';
AO.qf3.Setpoint.PhysicsUnits  = 'meter^-2';
AO.qf3.Setpoint.Range         = [0 225];
AO.qf3.Setpoint.Tolerance     = 0.2;
AO.qf3.Setpoint.DeltaRespMat  = 0.5;

AO.qf4.FamilyName = 'qf4';
AO.qf4.MemberOf    = {'PlotFamily'; 'qf4'; 'QUAD'; 'Magnet';'q20';};
AO.qf4.DeviceList  = getDeviceList(10,4);
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
AO.qf4.Setpoint.Units         = 'Hardware';
AO.qf4.Setpoint.HWUnits       = 'Ampere';
AO.qf4.Setpoint.PhysicsUnits  = 'meter^-2';
AO.qf4.Setpoint.Range         = [0 225];
AO.qf4.Setpoint.Tolerance     = 0.2;
AO.qf4.Setpoint.DeltaRespMat  = 0.5;

%% sextupoles

AO.sda.FamilyName = 'sda';
AO.sda.MemberOf    = {'PlotFamily'; 'sda'; 'SEXT'; 'Magnet';};
AO.sda.DeviceList  = getDeviceList(10,2);
AO.sda.ElementList = (1:size(AO.sda.DeviceList,1))';
AO.sda.Status      = ones(size(AO.sda.DeviceList,1),1);
AO.sda.Position    = [];
AO.sda.Monitor.MemberOf = {};
AO.sda.Monitor.Mode = 'Simulator';
AO.sda.Monitor.DataType = 'Scalar';
AO.sda.Monitor.Units        = 'Hardware';
AO.sda.Monitor.HWUnits      = 'Ampere';
AO.sda.Monitor.PhysicsUnits = 'meter^-3';
AO.sda.Setpoint.MemberOf      = {'MachineConfig'};
AO.sda.Setpoint.Mode          = 'Simulator';
AO.sda.Setpoint.DataType      = 'Scalar';
AO.sda.Setpoint.Units         = 'Hardware';
AO.sda.Setpoint.HWUnits       = 'Ampere';
AO.sda.Setpoint.PhysicsUnits  = 'meter^-3';
AO.sda.Setpoint.Range         = [0 225];
AO.sda.Setpoint.Tolerance     = 0.2;
AO.sda.Setpoint.DeltaRespMat  = 0.5; 

AO.sfa.FamilyName = 'sfa';
AO.sfa.MemberOf    = {'PlotFamily'; 'sfa'; 'SEXT'; 'Magnet';};
AO.sfa.DeviceList  = getDeviceList(10,2);
AO.sfa.ElementList = (1:size(AO.sfa.DeviceList,1))';
AO.sfa.Status      = ones(size(AO.sfa.DeviceList,1),1);
AO.sfa.Position    = [];
AO.sfa.Monitor.MemberOf = {};
AO.sfa.Monitor.Mode = 'Simulator';
AO.sfa.Monitor.DataType = 'Scalar';
AO.sfa.Monitor.Units        = 'Hardware';
AO.sfa.Monitor.HWUnits      = 'Ampere';
AO.sfa.Monitor.PhysicsUnits = 'meter^-3';
AO.sfa.Setpoint.MemberOf      = {'MachineConfig'};
AO.sfa.Setpoint.Mode          = 'Simulator';
AO.sfa.Setpoint.DataType      = 'Scalar';
AO.sfa.Setpoint.Units         = 'Hardware';
AO.sfa.Setpoint.HWUnits       = 'Ampere';
AO.sfa.Setpoint.PhysicsUnits  = 'meter^-3';
AO.sfa.Setpoint.Range         = [0 225];
AO.sfa.Setpoint.Tolerance     = 0.2;
AO.sfa.Setpoint.DeltaRespMat  = 0.5; 

AO.sd1j.FamilyName = 'sd1j';
AO.sd1j.MemberOf    = {'PlotFamily'; 'sd1j'; 'SEXT'; 'Magnet';};
AO.sd1j.DeviceList  = getDeviceList(10,2);
AO.sd1j.ElementList = (1:size(AO.sd1j.DeviceList,1))';
AO.sd1j.Status      = ones(size(AO.sd1j.DeviceList,1),1);
AO.sd1j.Position    = [];
AO.sd1j.Monitor.MemberOf = {};
AO.sd1j.Monitor.Mode = 'Simulator';
AO.sd1j.Monitor.DataType = 'Scalar';
AO.sd1j.Monitor.Units        = 'Hardware';
AO.sd1j.Monitor.HWUnits      = 'Ampere';
AO.sd1j.Monitor.PhysicsUnits = 'meter^-3';
AO.sd1j.Setpoint.MemberOf      = {'MachineConfig'};
AO.sd1j.Setpoint.Mode          = 'Simulator';
AO.sd1j.Setpoint.DataType      = 'Scalar';
AO.sd1j.Setpoint.Units         = 'Hardware';
AO.sd1j.Setpoint.HWUnits       = 'Ampere';
AO.sd1j.Setpoint.PhysicsUnits  = 'meter^-3';
AO.sd1j.Setpoint.Range         = [0 225];
AO.sd1j.Setpoint.Tolerance     = 0.2;
AO.sd1j.Setpoint.DeltaRespMat  = 0.5;

AO.sf1j.FamilyName = 'sf1j';
AO.sf1j.MemberOf    = {'PlotFamily'; 'sf1j'; 'SEXT'; 'Magnet';};
AO.sf1j.DeviceList  = getDeviceList(10,2);
AO.sf1j.ElementList = (1:size(AO.sf1j.DeviceList,1))';
AO.sf1j.Status      = ones(size(AO.sf1j.DeviceList,1),1);
AO.sf1j.Position    = [];
AO.sf1j.Monitor.MemberOf = {};
AO.sf1j.Monitor.Mode = 'Simulator';
AO.sf1j.Monitor.DataType = 'Scalar';
AO.sf1j.Monitor.Units        = 'Hardware';
AO.sf1j.Monitor.HWUnits      = 'Ampere';
AO.sf1j.Monitor.PhysicsUnits = 'meter^-3';
AO.sf1j.Setpoint.MemberOf      = {'MachineConfig'};
AO.sf1j.Setpoint.Mode          = 'Simulator';
AO.sf1j.Setpoint.DataType      = 'Scalar';
AO.sf1j.Setpoint.Units         = 'Hardware';
AO.sf1j.Setpoint.HWUnits       = 'Ampere';
AO.sf1j.Setpoint.PhysicsUnits  = 'meter^-3';
AO.sf1j.Setpoint.Range         = [0 225];
AO.sf1j.Setpoint.Tolerance     = 0.2;
AO.sf1j.Setpoint.DeltaRespMat  = 0.5; 

AO.sd2j.FamilyName = 'sd2j';
AO.sd2j.MemberOf    = {'PlotFamily'; 'sd2j'; 'SEXT'; 'Magnet';};
AO.sd2j.DeviceList  = getDeviceList(10,2);
AO.sd2j.ElementList = (1:size(AO.sd2j.DeviceList,1))';
AO.sd2j.Status      = ones(size(AO.sd2j.DeviceList,1),1);
AO.sd2j.Position    = [];
AO.sd2j.Monitor.MemberOf = {};
AO.sd2j.Monitor.Mode = 'Simulator';
AO.sd2j.Monitor.DataType = 'Scalar';
AO.sd2j.Monitor.Units        = 'Hardware';
AO.sd2j.Monitor.HWUnits      = 'Ampere';
AO.sd2j.Monitor.PhysicsUnits = 'meter^-3';
AO.sd2j.Setpoint.MemberOf      = {'MachineConfig'};
AO.sd2j.Setpoint.Mode          = 'Simulator';
AO.sd2j.Setpoint.DataType      = 'Scalar';
AO.sd2j.Setpoint.Units         = 'Hardware';
AO.sd2j.Setpoint.HWUnits       = 'Ampere';
AO.sd2j.Setpoint.PhysicsUnits  = 'meter^-3';
AO.sd2j.Setpoint.Range         = [0 225];
AO.sd2j.Setpoint.Tolerance     = 0.2;
AO.sd2j.Setpoint.DeltaRespMat  = 0.5; 

AO.sd3j.FamilyName = 'sd3j';
AO.sd3j.MemberOf    = {'PlotFamily'; 'sd3j'; 'SEXT'; 'Magnet';};
AO.sd3j.DeviceList  = getDeviceList(10,2);
AO.sd3j.ElementList = (1:size(AO.sd3j.DeviceList,1))';
AO.sd3j.Status      = ones(size(AO.sd3j.DeviceList,1),1);
AO.sd3j.Position    = [];
AO.sd3j.Monitor.MemberOf = {};
AO.sd3j.Monitor.Mode = 'Simulator';
AO.sd3j.Monitor.DataType = 'Scalar';
AO.sd3j.Monitor.Units        = 'Hardware';
AO.sd3j.Monitor.HWUnits      = 'Ampere';
AO.sd3j.Monitor.PhysicsUnits = 'meter^-3';
AO.sd3j.Setpoint.MemberOf      = {'MachineConfig'};
AO.sd3j.Setpoint.Mode          = 'Simulator';
AO.sd3j.Setpoint.DataType      = 'Scalar';
AO.sd3j.Setpoint.Units         = 'Hardware';
AO.sd3j.Setpoint.HWUnits       = 'Ampere';
AO.sd3j.Setpoint.PhysicsUnits  = 'meter^-3';
AO.sd3j.Setpoint.Range         = [0 225];
AO.sd3j.Setpoint.Tolerance     = 0.2;
AO.sd3j.Setpoint.DeltaRespMat  = 0.5; 

AO.sf2j.FamilyName = 'sf2j';
AO.sf2j.MemberOf    = {'PlotFamily'; 'sf2j'; 'SEXT'; 'Magnet';};
AO.sf2j.DeviceList  = getDeviceList(10,2);
AO.sf2j.ElementList = (1:size(AO.sf2j.DeviceList,1))';
AO.sf2j.Status      = ones(size(AO.sf2j.DeviceList,1),1);
AO.sf2j.Position    = [];
AO.sf2j.Monitor.MemberOf = {};
AO.sf2j.Monitor.Mode = 'Simulator';
AO.sf2j.Monitor.DataType = 'Scalar';
AO.sf2j.Monitor.Units        = 'Hardware';
AO.sf2j.Monitor.HWUnits      = 'Ampere';
AO.sf2j.Monitor.PhysicsUnits = 'meter^-3';
AO.sf2j.Setpoint.MemberOf      = {'MachineConfig'};
AO.sf2j.Setpoint.Mode          = 'Simulator';
AO.sf2j.Setpoint.DataType      = 'Scalar';
AO.sf2j.Setpoint.Units         = 'Hardware';
AO.sf2j.Setpoint.HWUnits       = 'Ampere';
AO.sf2j.Setpoint.PhysicsUnits  = 'meter^-3';
AO.sf2j.Setpoint.Range         = [0 225];
AO.sf2j.Setpoint.Tolerance     = 0.2;
AO.sf2j.Setpoint.DeltaRespMat  = 0.5; 

AO.sd1k.FamilyName = 'sd1k';
AO.sd1k.MemberOf    = {'PlotFamily'; 'sd1k'; 'SEXT'; 'Magnet';};
AO.sd1k.DeviceList  = getDeviceList(10,2);
AO.sd1k.ElementList = (1:size(AO.sd1k.DeviceList,1))';
AO.sd1k.Status      = ones(size(AO.sd1k.DeviceList,1),1);
AO.sd1k.Position    = [];
AO.sd1k.Monitor.MemberOf = {};
AO.sd1k.Monitor.Mode = 'Simulator';
AO.sd1k.Monitor.DataType = 'Scalar';
AO.sd1k.Monitor.Units        = 'Hardware';
AO.sd1k.Monitor.HWUnits      = 'Ampere';
AO.sd1k.Monitor.PhysicsUnits = 'meter^-3';
AO.sd1k.Setpoint.MemberOf      = {'MachineConfig'};
AO.sd1k.Setpoint.Mode          = 'Simulator';
AO.sd1k.Setpoint.DataType      = 'Scalar';
AO.sd1k.Setpoint.Units         = 'Hardware';
AO.sd1k.Setpoint.HWUnits       = 'Ampere';
AO.sd1k.Setpoint.PhysicsUnits  = 'meter^-3';
AO.sd1k.Setpoint.Range         = [0 225];
AO.sd1k.Setpoint.Tolerance     = 0.2;
AO.sd1k.Setpoint.DeltaRespMat  = 0.5;

AO.sf1k.FamilyName = 'sf1k';
AO.sf1k.MemberOf    = {'PlotFamily'; 'sf1k'; 'SEXT'; 'Magnet';};
AO.sf1k.DeviceList  = getDeviceList(10,2);
AO.sf1k.ElementList = (1:size(AO.sf1k.DeviceList,1))';
AO.sf1k.Status      = ones(size(AO.sf1k.DeviceList,1),1);
AO.sf1k.Position    = [];
AO.sf1k.Monitor.MemberOf = {};
AO.sf1k.Monitor.Mode = 'Simulator';
AO.sf1k.Monitor.DataType = 'Scalar';
AO.sf1k.Monitor.Units        = 'Hardware';
AO.sf1k.Monitor.HWUnits      = 'Ampere';
AO.sf1k.Monitor.PhysicsUnits = 'meter^-3';
AO.sf1k.Setpoint.MemberOf      = {'MachineConfig'};
AO.sf1k.Setpoint.Mode          = 'Simulator';
AO.sf1k.Setpoint.DataType      = 'Scalar';
AO.sf1k.Setpoint.Units         = 'Hardware';
AO.sf1k.Setpoint.HWUnits       = 'Ampere';
AO.sf1k.Setpoint.PhysicsUnits  = 'meter^-3';
AO.sf1k.Setpoint.Range         = [0 225];
AO.sf1k.Setpoint.Tolerance     = 0.2;
AO.sf1k.Setpoint.DeltaRespMat  = 0.5; 

AO.sd2k.FamilyName = 'sd2k';
AO.sd2k.MemberOf    = {'PlotFamily'; 'sd2k'; 'SEXT'; 'Magnet';};
AO.sd2k.DeviceList  = getDeviceList(10,2);
AO.sd2k.ElementList = (1:size(AO.sd2k.DeviceList,1))';
AO.sd2k.Status      = ones(size(AO.sd2k.DeviceList,1),1);
AO.sd2k.Position    = [];
AO.sd2k.Monitor.MemberOf = {};
AO.sd2k.Monitor.Mode = 'Simulator';
AO.sd2k.Monitor.DataType = 'Scalar';
AO.sd2k.Monitor.Units        = 'Hardware';
AO.sd2k.Monitor.HWUnits      = 'Ampere';
AO.sd2k.Monitor.PhysicsUnits = 'meter^-3';
AO.sd2k.Setpoint.MemberOf      = {'MachineConfig'};
AO.sd2k.Setpoint.Mode          = 'Simulator';
AO.sd2k.Setpoint.DataType      = 'Scalar';
AO.sd2k.Setpoint.Units         = 'Hardware';
AO.sd2k.Setpoint.HWUnits       = 'Ampere';
AO.sd2k.Setpoint.PhysicsUnits  = 'meter^-3';
AO.sd2k.Setpoint.Range         = [0 225];
AO.sd2k.Setpoint.Tolerance     = 0.2;
AO.sd2k.Setpoint.DeltaRespMat  = 0.5; 

AO.sd3k.FamilyName = 'sd3k';
AO.sd3k.MemberOf    = {'PlotFamily'; 'sd3k'; 'SEXT'; 'Magnet';};
AO.sd3k.DeviceList  = getDeviceList(10,2);
AO.sd3k.ElementList = (1:size(AO.sd3k.DeviceList,1))';
AO.sd3k.Status      = ones(size(AO.sd3k.DeviceList,1),1);
AO.sd3k.Position    = [];
AO.sd3k.Monitor.MemberOf = {};
AO.sd3k.Monitor.Mode = 'Simulator';
AO.sd3k.Monitor.DataType = 'Scalar';
AO.sd3k.Monitor.Units        = 'Hardware';
AO.sd3k.Monitor.HWUnits      = 'Ampere';
AO.sd3k.Monitor.PhysicsUnits = 'meter^-3';
AO.sd3k.Setpoint.MemberOf      = {'MachineConfig'};
AO.sd3k.Setpoint.Mode          = 'Simulator';
AO.sd3k.Setpoint.DataType      = 'Scalar';
AO.sd3k.Setpoint.Units         = 'Hardware';
AO.sd3k.Setpoint.HWUnits       = 'Ampere';
AO.sd3k.Setpoint.PhysicsUnits  = 'meter^-3';
AO.sd3k.Setpoint.Range         = [0 225];
AO.sd3k.Setpoint.Tolerance     = 0.2;
AO.sd3k.Setpoint.DeltaRespMat  = 0.5; 

AO.sf2k.FamilyName = 'sf2k';
AO.sf2k.MemberOf    = {'PlotFamily'; 'sf2k'; 'SEXT'; 'Magnet';};
AO.sf2k.DeviceList  = getDeviceList(10,2);
AO.sf2k.ElementList = (1:size(AO.sf2k.DeviceList,1))';
AO.sf2k.Status      = ones(size(AO.sf2k.DeviceList,1),1);
AO.sf2k.Position    = [];
AO.sf2k.Monitor.MemberOf = {};
AO.sf2k.Monitor.Mode = 'Simulator';
AO.sf2k.Monitor.DataType = 'Scalar';
AO.sf2k.Monitor.Units        = 'Hardware';
AO.sf2k.Monitor.HWUnits      = 'Ampere';
AO.sf2k.Monitor.PhysicsUnits = 'meter^-3';
AO.sf2k.Setpoint.MemberOf      = {'MachineConfig'};
AO.sf2k.Setpoint.Mode          = 'Simulator';
AO.sf2k.Setpoint.DataType      = 'Scalar';
AO.sf2k.Setpoint.Units         = 'Hardware';
AO.sf2k.Setpoint.HWUnits       = 'Ampere';
AO.sf2k.Setpoint.PhysicsUnits  = 'meter^-3';
AO.sf2k.Setpoint.Range         = [0 225];
AO.sf2k.Setpoint.Tolerance     = 0.2;
AO.sf2k.Setpoint.DeltaRespMat  = 0.5; 

AO.sfb.FamilyName = 'sfb';
AO.sfb.MemberOf    = {'PlotFamily'; 'sfb'; 'SEXT'; 'Magnet';};
AO.sfb.DeviceList  = getDeviceList(10,2);
AO.sfb.ElementList = (1:size(AO.sfb.DeviceList,1))';
AO.sfb.Status      = ones(size(AO.sfb.DeviceList,1),1);
AO.sfb.Position    = [];
AO.sfb.Monitor.MemberOf = {};
AO.sfb.Monitor.Mode = 'Simulator';
AO.sfb.Monitor.DataType = 'Scalar';
AO.sfb.Monitor.Units        = 'Hardware';
AO.sfb.Monitor.HWUnits      = 'Ampere';
AO.sfb.Monitor.PhysicsUnits = 'meter^-3';
AO.sfb.Setpoint.MemberOf      = {'MachineConfig'};
AO.sfb.Setpoint.Mode          = 'Simulator';
AO.sfb.Setpoint.DataType      = 'Scalar';
AO.sfb.Setpoint.Units         = 'Hardware';
AO.sfb.Setpoint.HWUnits       = 'Ampere';
AO.sfb.Setpoint.PhysicsUnits  = 'meter^-3';
AO.sfb.Setpoint.Range         = [0 225];
AO.sfb.Setpoint.Tolerance     = 0.2;
AO.sfb.Setpoint.DeltaRespMat  = 0.5; 

AO.sdb.FamilyName = 'sdb';
AO.sdb.MemberOf    = {'PlotFamily'; 'sdb'; 'SEXT'; 'Magnet';};
AO.sdb.DeviceList  = getDeviceList(10,2);
AO.sdb.ElementList = (1:size(AO.sdb.DeviceList,1))';
AO.sdb.Status      = ones(size(AO.sdb.DeviceList,1),1);
AO.sdb.Position    = [];
AO.sdb.Monitor.MemberOf = {};
AO.sdb.Monitor.Mode = 'Simulator';
AO.sdb.Monitor.DataType = 'Scalar';
AO.sdb.Monitor.Units        = 'Hardware';
AO.sdb.Monitor.HWUnits      = 'Ampere';
AO.sdb.Monitor.PhysicsUnits = 'meter^-3';
AO.sdb.Setpoint.MemberOf      = {'MachineConfig'};
AO.sdb.Setpoint.Mode          = 'Simulator';
AO.sdb.Setpoint.DataType      = 'Scalar';
AO.sdb.Setpoint.Units         = 'Hardware';
AO.sdb.Setpoint.HWUnits       = 'Ampere';
AO.sdb.Setpoint.PhysicsUnits  = 'meter^-3';
AO.sdb.Setpoint.Range         = [0 225];
AO.sdb.Setpoint.Tolerance     = 0.2;
AO.sdb.Setpoint.DeltaRespMat  = 0.5; 


%% correctors

% chs
AO.chs.FamilyName  = 'chs';
AO.chs.MemberOf    = {'PlotFamily'; 'COR'; 'chs'; 'Magnet';'hcm';'hcm_slow';};
AO.chs.DeviceList  = getDeviceList(10,12);
AO.chs.ElementList = (1:size(AO.chs.DeviceList,1))';
AO.chs.Status      = ones(size(AO.chs.DeviceList,1),1);
AO.chs.Position    = [];
AO.chs.Monitor.MemberOf = {'Horizontal'; 'COR'; 'chs'; 'Magnet';};
AO.chs.Monitor.Mode     = 'Simulator';
AO.chs.Monitor.DataType = 'Scalar';
AO.chs.Monitor.Units        = 'Physics';
AO.chs.Monitor.HWUnits      = 'Ampere';
AO.chs.Monitor.PhysicsUnits = 'Radian';
AO.chs.Setpoint.MemberOf = {'MachineConfig'; 'Horizontal'; 'COR'; 'hcm'; 'Magnet'; 'Setpoint'; 'measbpmresp';};
AO.chs.Setpoint.Mode = 'Simulator';
AO.chs.Setpoint.DataType = 'Scalar';
AO.chs.Setpoint.Units        = 'Physics';
AO.chs.Setpoint.HWUnits      = 'Ampere';
AO.chs.Setpoint.PhysicsUnits = 'Radian';
AO.chs.Setpoint.Range        = [-10 10];
AO.chs.Setpoint.Tolerance    = 0.00001;
AO.chs.Setpoint.DeltaRespMat = 50e-6; 

% cvs
AO.cvs.FamilyName  = 'cvs';
AO.cvs.MemberOf    = {'PlotFamily'; 'COR'; 'cvs'; 'Magnet';'vcm';'vcm_slow';};
AO.cvs.DeviceList  = getDeviceList(10,12);
AO.cvs.ElementList = (1:size(AO.cvs.DeviceList,1))';
AO.cvs.Status      = ones(size(AO.cvs.DeviceList,1),1);
AO.cvs.Position    = [];
AO.cvs.Monitor.MemberOf = {'Horizontal'; 'COR'; 'cvs'; 'Magnet';};
AO.cvs.Monitor.Mode     = 'Simulator';
AO.cvs.Monitor.DataType = 'Scalar';
AO.cvs.Monitor.Units        = 'Physics';
AO.cvs.Monitor.HWUnits      = 'Ampere';
AO.cvs.Monitor.PhysicsUnits = 'Radian';
AO.cvs.Setpoint.MemberOf = {'MachineConfig'; 'Horizontal'; 'COR'; 'vcm'; 'Magnet'; 'Setpoint'; 'measbpmresp';};
AO.cvs.Setpoint.Mode = 'Simulator';
AO.cvs.Setpoint.DataType = 'Scalar';
AO.cvs.Setpoint.Units        = 'Physics';
AO.cvs.Setpoint.HWUnits      = 'Ampere';
AO.cvs.Setpoint.PhysicsUnits = 'Radian';
AO.cvs.Setpoint.Range        = [-10 10];
AO.cvs.Setpoint.Tolerance    = 0.00001;
AO.cvs.Setpoint.DeltaRespMat = 50e-6; 

% chf
AO.chf.FamilyName  = 'chf';
AO.chf.MemberOf    = {'PlotFamily'; 'COR'; 'chf'; 'Magnet';'hcm';'hcm_fast';};
AO.chf.DeviceList  = getDeviceList(10,8);
AO.chf.ElementList = (1:size(AO.chf.DeviceList,1))';
AO.chf.Status      = ones(size(AO.chf.DeviceList,1),1);
AO.chf.Position    = [];
AO.chf.Monitor.MemberOf = {'Horizontal'; 'COR'; 'chf'; 'Magnet';};
AO.chf.Monitor.Mode     = 'Simulator';
AO.chf.Monitor.DataType = 'Scalar';
AO.chf.Monitor.Units        = 'Physics';
AO.chf.Monitor.HWUnits      = 'Ampere';
AO.chf.Monitor.PhysicsUnits = 'Radian';
AO.chf.Setpoint.MemberOf = {'MachineConfig'; 'Horizontal'; 'COR'; 'hcm'; 'Magnet'; 'Setpoint'; 'measbpmresp';};
AO.chf.Setpoint.Mode = 'Simulator';
AO.chf.Setpoint.DataType = 'Scalar';
AO.chf.Setpoint.Units        = 'Physics';
AO.chf.Setpoint.HWUnits      = 'Ampere';
AO.chf.Setpoint.PhysicsUnits = 'Radian';
AO.chf.Setpoint.Range        = [-10 10];
AO.chf.Setpoint.Tolerance    = 0.00001;
AO.chf.Setpoint.DeltaRespMat = 0.0005; 

% cvf
AO.cvf.FamilyName  = 'cvf';
AO.cvf.MemberOf    = {'PlotFamily'; 'COR'; 'cvf'; 'Magnet';'vcm';'vcm_fast';};
AO.cvf.DeviceList  = getDeviceList(10,8);
AO.cvf.ElementList = (1:size(AO.cvf.DeviceList,1))';
AO.cvf.Status      = ones(size(AO.cvf.DeviceList,1),1);
AO.cvf.Position    = [];
AO.cvf.Monitor.MemberOf = {'Horizontal'; 'COR'; 'cvf'; 'Magnet';};
AO.cvf.Monitor.Mode     = 'Simulator';
AO.cvf.Monitor.DataType = 'Scalar';
AO.cvf.Monitor.Units        = 'Physics';
AO.cvf.Monitor.HWUnits      = 'Ampere';
AO.cvf.Monitor.PhysicsUnits = 'Radian';
AO.cvf.Setpoint.MemberOf = {'MachineConfig'; 'Horizontal'; 'COR'; 'vcm'; 'Magnet'; 'Setpoint'; 'measbpmresp';};
AO.cvf.Setpoint.Mode = 'Simulator';
AO.cvf.Setpoint.DataType = 'Scalar';
AO.cvf.Setpoint.Units        = 'Physics';
AO.cvf.Setpoint.HWUnits      = 'Ampere';
AO.cvf.Setpoint.PhysicsUnits = 'Radian';
AO.cvf.Setpoint.Range        = [-10 10];
AO.cvf.Setpoint.Tolerance    = 0.00001;
AO.cvf.Setpoint.DeltaRespMat = 0.0005; 

% qs
AO.qs.FamilyName  = 'qs';
AO.qs.MemberOf    = {'PlotFamily'; 'COR'; 'qs'; 'Magnet';};
AO.qs.DeviceList  = getDeviceList(10,8);
AO.qs.ElementList = (1:size(AO.qs.DeviceList,1))';
AO.qs.Status      = ones(size(AO.qs.DeviceList,1),1);
AO.qs.Position    = [];
AO.qs.Monitor.MemberOf = {'Horizontal'; 'COR'; 'qs'; 'Magnet';};
AO.qs.Monitor.Mode     = 'Simulator';
AO.qs.Monitor.DataType = 'Scalar';
AO.qs.Monitor.Units        = 'Physics';
AO.qs.Monitor.HWUnits      = 'Ampere';
AO.qs.Monitor.PhysicsUnits = 'Radian';
AO.qs.Setpoint.MemberOf = {'MachineConfig'; 'Horizontal'; 'COR'; 'Magnet'; 'Setpoint'; 'measbpmresp';};
AO.qs.Setpoint.Mode = 'Simulator';
AO.qs.Setpoint.DataType = 'Scalar';
AO.qs.Setpoint.Units        = 'Physics';
AO.qs.Setpoint.HWUnits      = 'Ampere';
AO.qs.Setpoint.PhysicsUnits = 'Radian';
AO.qs.Setpoint.Range        = [-10 10];
AO.qs.Setpoint.Tolerance    = 0.00001;
AO.qs.Setpoint.DeltaRespMat = 0.0005; 


% skewcm

AO.skewcm.FamilyName  = 'skewcm';
AO.skewcm.MemberOf    = {'PlotFamily'; 'COR'; 'skewcm'; 'Magnet'};
AO.skewcm.DeviceList  = getDeviceList(10,28);
AO.skewcm.ElementList = (1:size(AO.skewcm.DeviceList,1))';
AO.skewcm.Status      = ones(size(AO.skewcm.DeviceList,1),1);

AO.skewcm.Position    = [];

AO.skewcm.Monitor.MemberOf = {'COR'; 'skewcm'; 'Magnet';};
AO.skewcm.Monitor.Mode = 'Simulator';
AO.skewcm.Monitor.DataType = 'Scalar';
AO.skewcm.Monitor.Units        = 'Physics';
AO.skewcm.Monitor.HWUnits      = 'Ampere';
AO.skewcm.Monitor.PhysicsUnits = 'Radian';

AO.skewcm.Setpoint.MemberOf = {'MachineConfig'; 'COR'; 'skewcm'; 'Magnet'; 'Setpoint';};
AO.skewcm.Setpoint.Mode = 'Simulator';
AO.skewcm.Setpoint.DataType = 'Scalar';
AO.skewcm.Setpoint.Units        = 'Physics';
AO.skewcm.Setpoint.HWUnits      = 'Ampere';
AO.skewcm.Setpoint.PhysicsUnits = 'm^-2';
AO.skewcm.Setpoint.Range        = [-10 10];
AO.skewcm.Setpoint.Tolerance    = 0.00001;


% bpmx
AO.bpmx.FamilyName  = 'bpmx';
AO.bpmx.MemberOf    = {'PlotFamily'; 'bpm'; 'bpmx'; 'Diagnostics'};
AO.bpmx.DeviceList  = getDeviceList(10,18);
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
AO.bpmy.MemberOf    = {'PlotFamily'; 'bpm'; 'bpmy'; 'Diagnostics'};
AO.bpmy.DeviceList  = getDeviceList(10,18);
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
AO.DCCT.DeviceList               = [13,1; 14, 1];
AO.DCCT.ElementList              = [1, 2];
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


% The operational mode sets the path, filenames, and other important parameters
% Run setoperationalmode after most of the AO is built so that the Units and Mode fields
% can be set in setoperationalmode
setao(AO);
%setoperationalmode(OperationalMode);




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
