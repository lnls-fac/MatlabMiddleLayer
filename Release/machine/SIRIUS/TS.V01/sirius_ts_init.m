function sirius_ts_init(OperationalMode)
%SIRIUS_TS_INIT - MML initialization file for the TS at sirius
%  lnlsinit(OperationalMode)
%
%  See also setoperationalmode

% 2013-12-02 Inicio (Ximenes)


setao([]);
setad([]);


% Base on the location of this file
[SIRIUS_ROOT, ~, ~] = fileparts(mfilename('fullpath'));

AD.Directory.ExcDataDir  = '/home/fac_files/siriusdb/excitation_curves';

%AD.Directory.ExcDataDir = [SIRIUS_ROOT, filesep, 'excitation_curves'];

setad(AD);


% BENDS

AO.bend.FamilyName  = 'bend';
AO.bend.MemberOf    = {'PlotFamily'; 'bend'; 'BEND'; 'Magnet';};
AO.bend.DeviceList  = getDeviceList(1,3);
AO.bend.ElementList = (1:size(AO.bend.DeviceList,1))';
AO.bend.Status      = ones(size(AO.bend.DeviceList,1),1);
AO.bend.Position    = [];
AO.bend.ExcitationCurves = sirius_getexcdata(repmat('tsma-bend', size(AO.bend.DeviceList,1), 1)); 

AO.bend.Monitor.MemberOf = {};
AO.bend.Monitor.Mode = 'Simulator';
AO.bend.Monitor.DataType = 'Scalar';
AO.bend.Monitor.ChannelNames = sirius_ts_getname(AO.bend.FamilyName, 'Monitor', AO.bend.DeviceList);
AO.bend.Monitor.HW2PhysicsFcn = @bend2gev;
AO.bend.Monitor.Physics2HWFcn = @gev2bend;
AO.bend.Monitor.Units        = 'Hardware';
AO.bend.Monitor.HWUnits      = 'Ampere';
AO.bend.Monitor.PhysicsUnits = 'GeV';

AO.bend.Setpoint.MemberOf = {'MachineConfig';};
AO.bend.Setpoint.Mode = 'Simulator';
AO.bend.Setpoint.DataType = 'Scalar';
AO.bend.Setpoint.ChannelNames = sirius_ts_getname(AO.bend.FamilyName, 'Setpoint', AO.bend.DeviceList);
AO.bend.Setpoint.HW2PhysicsFcn = @bend2gev;
AO.bend.Setpoint.Physics2HWFcn = @gev2bend;
AO.bend.Setpoint.Units        = 'Hardware';
AO.bend.Setpoint.HWUnits      = 'Ampere';
AO.bend.Setpoint.PhysicsUnits = 'GeV';
AO.bend.Setpoint.Range        = [0 300];
AO.bend.Setpoint.Tolerance    = .1;
AO.bend.Setpoint.DeltaRespMat = .01;

% Septa

AO.septex.FamilyName  = 'septex';
AO.septex.MemberOf    = {'PlotFamily'; 'septex'; 'SEPTUM'; 'Magnet';};
AO.septex.DeviceList  = getDeviceList(1,1);
AO.septex.ElementList = (1:size(AO.septex.DeviceList,1))';
AO.septex.Status      = ones(size(AO.septex.DeviceList,1),1);
AO.septex.Position    = [];
AO.septex.ExcitationCurves = sirius_getexcdata(repmat('tspm-septex', size(AO.septex.DeviceList,1), 1)); 

AO.septex.Monitor.MemberOf = {};
AO.septex.Monitor.Mode = 'Simulator';
AO.septex.Monitor.DataType = 'Scalar';
AO.septex.Monitor.ChannelNames  = sirius_ts_getname(AO.septex.FamilyName, 'Monitor', AO.septex.DeviceList);
AO.septex.Monitor.HW2PhysicsFcn = @sirius_hw2ph;
AO.septex.Monitor.Physics2HWFcn = @sirius_ph2hw;
AO.septex.Monitor.Units         = 'Hardware';
AO.septex.Monitor.HWUnits       = 'Ampere';
AO.septex.Monitor.PhysicsUnits  = 'Radian';

AO.septex.Setpoint.MemberOf = {'MachineConfig';};
AO.septex.Setpoint.Mode = 'Simulator';
AO.septex.Setpoint.DataType = 'Scalar';
AO.septex.Setpoint.ChannelNames  = sirius_ts_getname(AO.septex.FamilyName, 'Setpoint', AO.septex.DeviceList);
AO.septex.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.septex.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.septex.Setpoint.Units         = 'Hardware';
AO.septex.Setpoint.HWUnits       = 'Ampere';
AO.septex.Setpoint.PhysicsUnits  = 'Radian';
AO.septex.Setpoint.Range         = [0 300];
AO.septex.Setpoint.Tolerance     = .1;
AO.septex.Setpoint.DeltaRespMat  = .01;


AO.septing.FamilyName  = 'septing';
AO.septing.MemberOf    = {'PlotFamily'; 'septing'; 'SEPTUM'; 'Magnet';};
AO.septing.DeviceList  = getDeviceList(1,1);
AO.septing.ElementList = (1:size(AO.septing.DeviceList,1))';
AO.septing.Status      = ones(size(AO.septing.DeviceList,1),1);
AO.septing.Position    = [];
AO.septing.ExcitationCurves = sirius_getexcdata(repmat('tspm-septin', size(AO.septing.DeviceList,1), 1)); 

AO.septing.Monitor.MemberOf = {};
AO.septing.Monitor.Mode = 'Simulator';
AO.septing.Monitor.DataType = 'Scalar';
AO.septing.Monitor.ChannelNames  = sirius_ts_getname(AO.septing.FamilyName, 'Monitor', AO.septing.DeviceList);
AO.septing.Monitor.HW2PhysicsFcn = @sirius_hw2ph;
AO.septing.Monitor.Physics2HWFcn = @sirius_ph2hw;
AO.septing.Monitor.Units         = 'Hardware';
AO.septing.Monitor.HWUnits       = 'Ampere';
AO.septing.Monitor.PhysicsUnits  = 'Radian';

AO.septing.Setpoint.MemberOf = {'MachineConfig';};
AO.septing.Setpoint.Mode = 'Simulator';
AO.septing.Setpoint.DataType = 'Scalar';
AO.septing.Setpoint.ChannelNames  = sirius_ts_getname(AO.septing.FamilyName, 'Setpoint', AO.septing.DeviceList);
AO.septing.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.septing.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.septing.Setpoint.Units         = 'Hardware';
AO.septing.Setpoint.HWUnits       = 'Ampere';
AO.septing.Setpoint.PhysicsUnits  = 'Radian';
AO.septing.Setpoint.Range         = [0 300];
AO.septing.Setpoint.Tolerance     = .1;
AO.septing.Setpoint.DeltaRespMat  = .01;


AO.septinf.FamilyName  = 'septinf';
AO.septinf.MemberOf    = {'PlotFamily'; 'septinf'; 'SEPTUM'; 'Magnet';};
AO.septinf.DeviceList  = getDeviceList(1,1);
AO.septinf.ElementList = (1:size(AO.septinf.DeviceList,1))';
AO.septinf.Status      = ones(size(AO.septinf.DeviceList,1),1);
AO.septinf.Position    = [];
AO.septinf.ExcitationCurves = sirius_getexcdata(repmat('tspm-septin', size(AO.septinf.DeviceList,1), 1)); 

AO.septinf.Monitor.MemberOf = {};
AO.septinf.Monitor.Mode = 'Simulator';
AO.septinf.Monitor.DataType = 'Scalar';
AO.septinf.Monitor.ChannelNames  = sirius_ts_getname(AO.septinf.FamilyName, 'Monitor', AO.septinf.DeviceList);
AO.septinf.Monitor.HW2PhysicsFcn = @sirius_hw2ph;
AO.septinf.Monitor.Physics2HWFcn = @sirius_ph2hw;
AO.septinf.Monitor.Units         = 'Hardware';
AO.septinf.Monitor.HWUnits       = 'Ampere';
AO.septinf.Monitor.PhysicsUnits  = 'Radian';

AO.septinf.Setpoint.MemberOf = {'MachineConfig';};
AO.septinf.Setpoint.Mode = 'Simulator';
AO.septinf.Setpoint.DataType = 'Scalar';
AO.septinf.Setpoint.ChannelNames  = sirius_ts_getname(AO.septinf.FamilyName, 'Setpoint', AO.septinf.DeviceList);
AO.septinf.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.septinf.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.septinf.Setpoint.Units         = 'Hardware';
AO.septinf.Setpoint.HWUnits       = 'Ampere';
AO.septinf.Setpoint.PhysicsUnits  = 'Radian';
AO.septinf.Setpoint.Range         = [0 300];
AO.septinf.Setpoint.Tolerance     = .1;
AO.septinf.Setpoint.DeltaRespMat  = .01;



% Quadrupoles

AO.qf1a.FamilyName  = 'qf1a';
AO.qf1a.MemberOf    = {'PlotFamily'; 'qf1a'; 'QUAD'; 'Magnet';};
AO.qf1a.DeviceList  = getDeviceList(1,1);
AO.qf1a.ElementList = (1:size(AO.qf1a.DeviceList,1))';
AO.qf1a.Status      = ones(size(AO.qf1a.DeviceList,1),1);
AO.qf1a.Position    = [];
AO.qf1a.ExcitationCurves = sirius_getexcdata(repmat('tsma-q', size(AO.qf1a.DeviceList,1), 1));
AO.qf1a.Monitor.MemberOf = {};
AO.qf1a.Monitor.Mode = 'Simulator';
AO.qf1a.Monitor.DataType = 'Scalar';
AO.qf1a.Monitor.ChannelNames = sirius_ts_getname(AO.qf1a.FamilyName, 'Monitor', AO.qf1a.DeviceList);
AO.qf1a.Monitor.HW2PhysicsFcn  = @sirius_hw2ph;
AO.qf1a.Monitor.Physics2HWFcn  = @sirius_ph2hw;
AO.qf1a.Monitor.Units        = 'Hardware';
AO.qf1a.Monitor.HWUnits      = 'Ampere';
AO.qf1a.Monitor.PhysicsUnits = 'meter^-2';
AO.qf1a.Setpoint.MemberOf      = {'MachineConfig'};
AO.qf1a.Setpoint.Mode          = 'Simulator';
AO.qf1a.Setpoint.DataType      = 'Scalar';
AO.qf1a.Setpoint.ChannelNames = sirius_ts_getname(AO.qf1a.FamilyName, 'Setpoint', AO.qf1a.DeviceList);
AO.qf1a.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.qf1a.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.qf1a.Setpoint.Units         = 'Hardware';
AO.qf1a.Setpoint.HWUnits       = 'Ampere';
AO.qf1a.Setpoint.PhysicsUnits  = 'meter^-2';
AO.qf1a.Setpoint.Range         = [0 225];
AO.qf1a.Setpoint.Tolerance     = 0.2;
AO.qf1a.Setpoint.DeltaRespMat  = 0.5; 


AO.qf1b.FamilyName  = 'qf1b';
AO.qf1b.MemberOf    = {'PlotFamily'; 'qf1b'; 'QUAD'; 'Magnet';};
AO.qf1b.DeviceList  = getDeviceList(1,1);
AO.qf1b.ElementList = (1:size(AO.qf1b.DeviceList,1))';
AO.qf1b.Status      = ones(size(AO.qf1b.DeviceList,1),1);
AO.qf1b.Position    = [];
AO.qf1b.ExcitationCurves = sirius_getexcdata(repmat('tsma-q', size(AO.qf1b.DeviceList,1), 1));
AO.qf1b.Monitor.MemberOf = {};
AO.qf1b.Monitor.Mode = 'Simulator';
AO.qf1b.Monitor.DataType = 'Scalar';
AO.qf1b.Monitor.ChannelNames = sirius_ts_getname(AO.qf1b.FamilyName, 'Monitor', AO.qf1b.DeviceList);
AO.qf1b.Monitor.HW2PhysicsFcn  = @sirius_hw2ph;
AO.qf1b.Monitor.Physics2HWFcn  = @sirius_ph2hw;
AO.qf1b.Monitor.Units        = 'Hardware';
AO.qf1b.Monitor.HWUnits      = 'Ampere';
AO.qf1b.Monitor.PhysicsUnits = 'meter^-2';
AO.qf1b.Setpoint.MemberOf      = {'MachineConfig'};
AO.qf1b.Setpoint.Mode          = 'Simulator';
AO.qf1b.Setpoint.DataType      = 'Scalar';
AO.qf1b.Setpoint.ChannelNames = sirius_ts_getname(AO.qf1b.FamilyName, 'Setpoint', AO.qf1b.DeviceList);
AO.qf1b.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.qf1b.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.qf1b.Setpoint.Units         = 'Hardware';
AO.qf1b.Setpoint.HWUnits       = 'Ampere';
AO.qf1b.Setpoint.PhysicsUnits  = 'meter^-2';
AO.qf1b.Setpoint.Range         = [0 225];
AO.qf1b.Setpoint.Tolerance     = 0.2;
AO.qf1b.Setpoint.DeltaRespMat  = 0.5; 


AO.qd2.FamilyName  = 'qd2';
AO.qd2.MemberOf    = {'PlotFamily'; 'qd2'; 'QUAD'; 'Magnet';};
AO.qd2.DeviceList  = getDeviceList(1,1);
AO.qd2.ElementList = (1:size(AO.qd2.DeviceList,1))';
AO.qd2.Status      = ones(size(AO.qd2.DeviceList,1),1);
AO.qd2.Position    = [];
AO.qd2.ExcitationCurves = sirius_getexcdata(repmat('tsma-q', size(AO.qd2.DeviceList,1), 1));
AO.qd2.Monitor.MemberOf = {};
AO.qd2.Monitor.Mode = 'Simulator';
AO.qd2.Monitor.DataType = 'Scalar';
AO.qd2.Monitor.ChannelNames = sirius_ts_getname(AO.qd2.FamilyName, 'Monitor', AO.qd2.DeviceList);
AO.qd2.Monitor.HW2PhysicsFcn = @sirius_hw2ph;
AO.qd2.Monitor.Physics2HWFcn = @sirius_ph2hw;
AO.qd2.Monitor.Units        = 'Hardware';
AO.qd2.Monitor.HWUnits      = 'Ampere';
AO.qd2.Monitor.PhysicsUnits = 'meter^-2';
AO.qd2.Setpoint.MemberOf      = {'MachineConfig'};
AO.qd2.Setpoint.Mode          = 'Simulator';
AO.qd2.Setpoint.DataType      = 'Scalar';
AO.qd2.Setpoint.ChannelNames = sirius_ts_getname(AO.qd2.FamilyName, 'Setpoint', AO.qd2.DeviceList);
AO.qd2.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.qd2.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.qd2.Setpoint.Units         = 'Hardware';
AO.qd2.Setpoint.HWUnits       = 'Ampere';
AO.qd2.Setpoint.PhysicsUnits  = 'meter^-2';
AO.qd2.Setpoint.Range         = [0 225];
AO.qd2.Setpoint.Tolerance     = 0.2;
AO.qd2.Setpoint.DeltaRespMat  = 0.5; 


AO.qf2.FamilyName  = 'qf2';
AO.qf2.MemberOf    = {'PlotFamily'; 'qf2'; 'QUAD'; 'Magnet';};
AO.qf2.DeviceList  = getDeviceList(1,1);
AO.qf2.ElementList = (1:size(AO.qf2.DeviceList,1))';
AO.qf2.Status      = ones(size(AO.qf2.DeviceList,1),1);
AO.qf2.Position    = [];
AO.qf2.ExcitationCurves = sirius_getexcdata(repmat('tsma-q', size(AO.qf2.DeviceList,1), 1));
AO.qf2.Monitor.MemberOf = {};
AO.qf2.Monitor.Mode = 'Simulator';
AO.qf2.Monitor.DataType = 'Scalar';
AO.qf2.Monitor.ChannelNames = sirius_ts_getname(AO.qf2.FamilyName, 'Monitor', AO.qf2.DeviceList);
AO.qf2.Monitor.HW2PhysicsFcn = @sirius_hw2ph;
AO.qf2.Monitor.Physics2HWFcn = @sirius_ph2hw;
AO.qf2.Monitor.Units        = 'Hardware';
AO.qf2.Monitor.HWUnits      = 'Ampere';
AO.qf2.Monitor.PhysicsUnits = 'meter^-2';
AO.qf2.Setpoint.MemberOf      = {'MachineConfig'};
AO.qf2.Setpoint.Mode          = 'Simulator';
AO.qf2.Setpoint.DataType      = 'Scalar';
AO.qf2.Setpoint.ChannelNames = sirius_ts_getname(AO.qf2.FamilyName, 'Setpoint', AO.qf2.DeviceList);
AO.qf2.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.qf2.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.qf2.Setpoint.Units         = 'Hardware';
AO.qf2.Setpoint.HWUnits       = 'Ampere';
AO.qf2.Setpoint.PhysicsUnits  = 'meter^-2';
AO.qf2.Setpoint.Range         = [0 225];
AO.qf2.Setpoint.Tolerance     = 0.2;
AO.qf2.Setpoint.DeltaRespMat  = 0.5; 


AO.qf3.FamilyName  = 'qf3';
AO.qf3.MemberOf    = {'PlotFamily'; 'qf3'; 'QUAD'; 'Magnet';};
AO.qf3.DeviceList  = getDeviceList(1,1);
AO.qf3.ElementList = (1:size(AO.qf3.DeviceList,1))';
AO.qf3.Status      = ones(size(AO.qf3.DeviceList,1),1);
AO.qf3.Position    = [];
AO.qf3.ExcitationCurves = sirius_getexcdata(repmat('tsma-q', size(AO.qf3.DeviceList,1), 1));
AO.qf3.Monitor.MemberOf = {};
AO.qf3.Monitor.Mode = 'Simulator';
AO.qf3.Monitor.DataType = 'Scalar';
AO.qf3.Monitor.ChannelNames = sirius_ts_getname(AO.qf3.FamilyName, 'Monitor', AO.qf3.DeviceList);
AO.qf3.Monitor.HW2PhysicsFcn = @sirius_hw2ph;
AO.qf3.MOnitor.Physics2HWFcn = @sirius_ph2hw;
AO.qf3.Monitor.Units        = 'Hardware';
AO.qf3.Monitor.HWUnits      = 'Ampere';
AO.qf3.Monitor.PhysicsUnits = 'meter^-2';
AO.qf3.Setpoint.MemberOf      = {'MachineConfig'};
AO.qf3.Setpoint.Mode          = 'Simulator';
AO.qf3.Setpoint.DataType      = 'Scalar';
AO.qf3.Setpoint.ChannelNames = sirius_ts_getname(AO.qf3.FamilyName, 'Setpoint', AO.qf3.DeviceList);
AO.qf3.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.qf3.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.qf3.Setpoint.Units         = 'Hardware';
AO.qf3.Setpoint.HWUnits       = 'Ampere';
AO.qf3.Setpoint.PhysicsUnits  = 'meter^-2';
AO.qf3.Setpoint.Range         = [0 225];
AO.qf3.Setpoint.Tolerance     = 0.2;
AO.qf3.Setpoint.DeltaRespMat  = 0.5; 


AO.qd4a.FamilyName  = 'qd4a';
AO.qd4a.MemberOf    = {'PlotFamily'; 'qd4a'; 'QUAD'; 'Magnet';};
AO.qd4a.DeviceList  = getDeviceList(1,1);
AO.qd4a.ElementList = (1:size(AO.qd4a.DeviceList,1))';
AO.qd4a.Status      = ones(size(AO.qd4a.DeviceList,1),1);
AO.qd4a.Position    = [];
AO.qd4a.ExcitationCurves = sirius_getexcdata(repmat('tsma-q', size(AO.qd4a.DeviceList,1), 1));
AO.qd4a.Monitor.MemberOf = {};
AO.qd4a.Monitor.Mode = 'Simulator';
AO.qd4a.Monitor.DataType = 'Scalar';
AO.qd4a.Monitor.ChannelNames = sirius_ts_getname(AO.qd4a.FamilyName, 'Monitor', AO.qd4a.DeviceList);
AO.qd4a.Monitor.HW2PhysicsFcn = @sirius_hw2ph;
AO.qd4a.Monitor.Physics2HWFcn = @sirius_ph2hw;
AO.qd4a.Monitor.Units        = 'Hardware';
AO.qd4a.Monitor.HWUnits      = 'Ampere';
AO.qd4a.Monitor.PhysicsUnits = 'meter^-2';
AO.qd4a.Setpoint.MemberOf      = {'MachineConfig'};
AO.qd4a.Setpoint.Mode          = 'Simulator';
AO.qd4a.Setpoint.DataType      = 'Scalar';
AO.qd4a.Setpoint.ChannelNames = sirius_ts_getname(AO.qd4a.FamilyName, 'Setpoint', AO.qd4a.DeviceList);
AO.qd4a.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.qd4a.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.qd4a.Setpoint.Units         = 'Hardware';
AO.qd4a.Setpoint.HWUnits       = 'Ampere';
AO.qd4a.Setpoint.PhysicsUnits  = 'meter^-2';
AO.qd4a.Setpoint.Range         = [0 225];
AO.qd4a.Setpoint.Tolerance     = 0.2;
AO.qd4a.Setpoint.DeltaRespMat  = 0.5; 


AO.qf4.FamilyName  = 'qf4';
AO.qf4.MemberOf    = {'PlotFamily'; 'qf4'; 'QUAD'; 'Magnet';};
AO.qf4.DeviceList  = getDeviceList(1,1);
AO.qf4.ElementList = (1:size(AO.qf4.DeviceList,1))';
AO.qf4.Status      = ones(size(AO.qf4.DeviceList,1),1);
AO.qf4.Position    = [];
AO.qf4.ExcitationCurves = sirius_getexcdata(repmat('tsma-q', size(AO.qf4.DeviceList,1), 1));
AO.qf4.Monitor.MemberOf = {};
AO.qf4.Monitor.Mode = 'Simulator';
AO.qf4.Monitor.DataType = 'Scalar';
AO.qf4.Monitor.ChannelNames = sirius_ts_getname(AO.qf4.FamilyName, 'Monitor', AO.qf4.DeviceList);
AO.qf4.Monitor.HW2PhysicsFcn = @sirius_hw2ph;
AO.qf4.Monitor.Physics2HWFcn = @sirius_ph2hw;
AO.qf4.Monitor.Units        = 'Hardware';
AO.qf4.Monitor.HWUnits      = 'Ampere';
AO.qf4.Monitor.PhysicsUnits = 'meter^-2';
AO.qf4.Setpoint.MemberOf      = {'MachineConfig'};
AO.qf4.Setpoint.Mode          = 'Simulator';
AO.qf4.Setpoint.DataType      = 'Scalar';
AO.qf4.Setpoint.ChannelNames = sirius_ts_getname(AO.qf4.FamilyName, 'Setpoint', AO.qf4.DeviceList);
AO.qf4.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.qf4.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.qf4.Setpoint.Units         = 'Hardware';
AO.qf4.Setpoint.HWUnits       = 'Ampere';
AO.qf4.Setpoint.PhysicsUnits  = 'meter^-2';
AO.qf4.Setpoint.Range         = [0 225];
AO.qf4.Setpoint.Tolerance     = 0.2;
AO.qf4.Setpoint.DeltaRespMat  = 0.5; 

AO.qd4b.FamilyName  = 'qd4b';
AO.qd4b.MemberOf    = {'PlotFamily'; 'qd4b'; 'QUAD'; 'Magnet';};
AO.qd4b.DeviceList  = getDeviceList(1,1);
AO.qd4b.ElementList = (1:size(AO.qd4b.DeviceList,1))';
AO.qd4b.Status      = ones(size(AO.qd4b.DeviceList,1),1);
AO.qd4b.Position    = [];
AO.qd4b.ExcitationCurves = sirius_getexcdata(repmat('tsma-q', size(AO.qd4b.DeviceList,1), 1));
AO.qd4b.Monitor.MemberOf = {};
AO.qd4b.Monitor.Mode = 'Simulator';
AO.qd4b.Monitor.DataType = 'Scalar';
AO.qd4b.Monitor.ChannelNames = sirius_ts_getname(AO.qd4b.FamilyName, 'Monitor', AO.qd4b.DeviceList);
AO.qd4b.Monitor.HW2PhysicsFcn = @sirius_hw2ph;
AO.qd4b.Monitor.Physics2HWFcn = @sirius_ph2hw;
AO.qd4b.Monitor.Units        = 'Hardware';
AO.qd4b.Monitor.HWUnits      = 'Ampere';
AO.qd4b.Monitor.PhysicsUnits = 'meter^-2';
AO.qd4b.Setpoint.MemberOf      = {'MachineConfig'};
AO.qd4b.Setpoint.Mode          = 'Simulator';
AO.qd4b.Setpoint.DataType      = 'Scalar';
AO.qd4b.Setpoint.ChannelNames = sirius_ts_getname(AO.qd4b.FamilyName, 'Setpoint', AO.qd4b.DeviceList);
AO.qd4b.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.qd4b.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.qd4b.Setpoint.Units         = 'Hardware';
AO.qd4b.Setpoint.HWUnits       = 'Ampere';
AO.qd4b.Setpoint.PhysicsUnits  = 'meter^-2';
AO.qd4b.Setpoint.Range         = [0 225];
AO.qd4b.Setpoint.Tolerance     = 0.2;
AO.qd4b.Setpoint.DeltaRespMat  = 0.5;  


%%%%%%%%%%%%%%%%%%%%%
% Corrector Magnets %
%%%%%%%%%%%%%%%%%%%%%

% hcm
AO.hcm.FamilyName  = 'hcm';
AO.hcm.MemberOf    = {'PlotFamily'; 'COR'; 'hcm'; 'Magnet'};
AO.hcm.DeviceList  = getDeviceList(1,4);
AO.hcm.ElementList = (1:size(AO.hcm.DeviceList,1))';
AO.hcm.Status      = ones(size(AO.hcm.DeviceList,1),1);
AO.hcm.Position    = [];
AO.hcm.ExcitationCurves = sirius_getexcdata(repmat('tsma-ch', size(AO.hcm.DeviceList,1), 1));
AO.hcm.Monitor.MemberOf = {'Horizontal'; 'COR'; 'hcm'; 'Magnet';};
AO.hcm.Monitor.Mode = 'Simulator';
AO.hcm.Monitor.DataType = 'Scalar';
AO.hcm.Monitor.ChannelNames  = sirius_ts_getname(AO.hcm.FamilyName, 'Monitor', AO.hcm.DeviceList);
AO.hcm.Monitor.HW2PhysicsFcn = @sirius_hw2ph;
AO.hcm.Monitor.Physics2HWFcn = @sirius_ph2hw;
AO.hcm.Monitor.Units         = 'Physics';
AO.hcm.Monitor.HWUnits       = 'Ampere';
AO.hcm.Monitor.PhysicsUnits  = 'Radian';
AO.hcm.Setpoint.MemberOf = {'MachineConfig'; 'Horizontal'; 'COR'; 'hcm'; 'Magnet'; 'Setpoint'; 'measbpmresp';};
AO.hcm.Setpoint.Mode = 'Simulator';
AO.hcm.Setpoint.DataType = 'Scalar';
AO.hcm.Setpoint.ChannelNames = sirius_ts_getname(AO.hcm.FamilyName, 'Setpoint', AO.hcm.DeviceList);
AO.hcm.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.hcm.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.hcm.Setpoint.Units        = 'Physics';
AO.hcm.Setpoint.HWUnits      = 'Ampere';
AO.hcm.Setpoint.PhysicsUnits = 'Radian';
AO.hcm.Setpoint.Range        = [-10 10];
AO.hcm.Setpoint.Tolerance    = 0.00001;
AO.hcm.Setpoint.DeltaRespMat = 0.0005; 

% vcm
AO.vcm.FamilyName  = 'vcm';
AO.vcm.MemberOf    = {'PlotFamily'; 'COR'; 'vcm'; 'Magnet'};
AO.vcm.DeviceList  = getDeviceList(1,6);
AO.vcm.ElementList = (1:size(AO.vcm.DeviceList,1))';
AO.vcm.Status      = ones(size(AO.vcm.DeviceList,1),1);
AO.vcm.Position    = [];
AO.vcm.ExcitationCurves = sirius_getexcdata(repmat('tsma-cv', size(AO.vcm.DeviceList,1), 1));
AO.vcm.Monitor.MemberOf = {'Vertical'; 'COR'; 'vcm'; 'Magnet';};
AO.vcm.Monitor.Mode = 'Simulator';
AO.vcm.Monitor.DataType = 'Scalar';
AO.vcm.Monitor.ChannelNames = sirius_ts_getname(AO.vcm.FamilyName, 'Monitor', AO.vcm.DeviceList);
AO.vcm.Monitor.HW2PhysicsFcn = @sirius_hw2ph;
AO.vcm.Monitor.Physics2HWFcn = @sirius_ph2hw;
AO.vcm.Monitor.Units        = 'Physics';
AO.vcm.Monitor.HWUnits      = 'Ampere';
AO.vcm.Monitor.PhysicsUnits = 'Radian';
AO.vcm.Setpoint.MemberOf = {'MachineConfig'; 'Horizontal'; 'COR'; 'vcm'; 'Magnet'; 'Setpoint'; 'measbpmresp';};
AO.vcm.Setpoint.Mode = 'Simulator';
AO.vcm.Setpoint.DataType = 'Scalar';
AO.vcm.Setpoint.ChannelNames = sirius_ts_getname(AO.vcm.FamilyName, 'Setpoint', AO.vcm.DeviceList);
AO.vcm.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.vcm.Setpoint.Physics2HWFcn = @sirius_ph2hw;
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
AO.bpmx.Monitor.ChannelNames = sirius_ts_getname(AO.bpmx.FamilyName, 'Monitor', AO.bpmx.DeviceList);
AO.bpmx.Monitor.HW2PhysicsParams = 1e-6;  % HW [um], Simulator [Meters]
AO.bpmx.Monitor.Physics2HWParams =  1e6;
AO.bpmx.Monitor.Units        = 'Hardware';
AO.bpmx.Monitor.HWUnits      = 'um';
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
AO.bpmy.Monitor.ChannelNames = sirius_ts_getname(AO.bpmy.FamilyName, 'Monitor', AO.bpmy.DeviceList);
AO.bpmy.Monitor.HW2PhysicsParams = 1e-6;  % HW [um], Simulator [Meters]
AO.bpmy.Monitor.Physics2HWParams =  1e6;
AO.bpmy.Monitor.Units        = 'Hardware';
AO.bpmy.Monitor.HWUnits      = 'um';
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
