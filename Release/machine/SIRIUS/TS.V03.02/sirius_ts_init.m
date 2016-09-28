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

AO.thinejesept.FamilyName  = 'thinejesept';
AO.thinejesept.MemberOf    = {'PlotFamily'; 'thinejesept'; 'SEPTUM'; 'Magnet';};
AO.thinejesept.DeviceList  = getDeviceList(1,1);
AO.thinejesept.ElementList = (1:size(AO.thinejesept.DeviceList,1))';
AO.thinejesept.Status      = ones(size(AO.thinejesept.DeviceList,1),1);
AO.thinejesept.Position    = [];
AO.thinejesept.ExcitationCurves = sirius_getexcdata(repmat('tspm-sep', size(AO.thinejesept.DeviceList,1), 1)); 
AO.thinejesept.Monitor.MemberOf = {};
AO.thinejesept.Monitor.Mode = 'Simulator';
AO.thinejesept.Monitor.DataType = 'Scalar';
AO.thinejesept.Monitor.ChannelNames  = sirius_ts_getname(AO.thinejesept.FamilyName, 'Monitor', AO.thinejesept.DeviceList);
AO.thinejesept.Monitor.HW2PhysicsFcn = @sirius_hw2ph;
AO.thinejesept.Monitor.Physics2HWFcn = @sirius_ph2hw;
AO.thinejesept.Monitor.Units         = 'Hardware';
AO.thinejesept.Monitor.HWUnits       = 'Ampere';
AO.thinejesept.Monitor.PhysicsUnits  = 'Radian';
AO.thinejesept.Setpoint.MemberOf = {'MachineConfig';};
AO.thinejesept.Setpoint.Mode = 'Simulator';
AO.thinejesept.Setpoint.DataType = 'Scalar';
AO.thinejesept.Setpoint.ChannelNames  = sirius_ts_getname(AO.thinejesept.FamilyName, 'Setpoint', AO.thinejesept.DeviceList);
AO.thinejesept.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.thinejesept.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.thinejesept.Setpoint.Units         = 'Hardware';
AO.thinejesept.Setpoint.HWUnits       = 'Ampere';
AO.thinejesept.Setpoint.PhysicsUnits  = 'Radian';
AO.thinejesept.Setpoint.Range         = [0 300];
AO.thinejesept.Setpoint.Tolerance     = .1;
AO.thinejesept.Setpoint.DeltaRespMat  = .01;

AO.thickejesept.FamilyName  = 'thickejesept';
AO.thickejesept.MemberOf    = {'PlotFamily'; 'thickejesept'; 'SEPTUM'; 'Magnet';};
AO.thickejesept.DeviceList  = getDeviceList(1,1);
AO.thickejesept.ElementList = (1:size(AO.thickejesept.DeviceList,1))';
AO.thickejesept.Status      = ones(size(AO.thickejesept.DeviceList,1),1);
AO.thickejesept.Position    = [];
AO.thickejesept.ExcitationCurves = sirius_getexcdata(repmat('tspm-sep', size(AO.thickejesept.DeviceList,1), 1)); 
AO.thickejesept.Monitor.MemberOf = {};
AO.thickejesept.Monitor.Mode = 'Simulator';
AO.thickejesept.Monitor.DataType = 'Scalar';
AO.thickejesept.Monitor.ChannelNames  = sirius_ts_getname(AO.thickejesept.FamilyName, 'Monitor', AO.thickejesept.DeviceList);
AO.thickejesept.Monitor.HW2PhysicsFcn = @sirius_hw2ph;
AO.thickejesept.Monitor.Physics2HWFcn = @sirius_ph2hw;
AO.thickejesept.Monitor.Units         = 'Hardware';
AO.thickejesept.Monitor.HWUnits       = 'Ampere';
AO.thickejesept.Monitor.PhysicsUnits  = 'Radian';
AO.thickejesept.Setpoint.MemberOf = {'MachineConfig';};
AO.thickejesept.Setpoint.Mode = 'Simulator';
AO.thickejesept.Setpoint.DataType = 'Scalar';
AO.thickejesept.Setpoint.ChannelNames  = sirius_ts_getname(AO.thickejesept.FamilyName, 'Setpoint', AO.thickejesept.DeviceList);
AO.thickejesept.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.thickejesept.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.thickejesept.Setpoint.Units         = 'Hardware';
AO.thickejesept.Setpoint.HWUnits       = 'Ampere';
AO.thickejesept.Setpoint.PhysicsUnits  = 'Radian';
AO.thickejesept.Setpoint.Range         = [0 300];
AO.thickejesept.Setpoint.Tolerance     = .1;
AO.thickejesept.Setpoint.DeltaRespMat  = .01;

AO.thickinjsept.FamilyName  = 'thickinjsept';
AO.thickinjsept.MemberOf    = {'PlotFamily'; 'thickinjsept'; 'SEPTUM'; 'Magnet';};
AO.thickinjsept.DeviceList  = getDeviceList(1,2);
AO.thickinjsept.ElementList = (1:size(AO.thickinjsept.DeviceList,1))';
AO.thickinjsept.Status      = ones(size(AO.thickinjsept.DeviceList,1),1);
AO.thickinjsept.Position    = [];
AO.thickinjsept.ExcitationCurves = sirius_getexcdata(repmat('tspm-sep', size(AO.thickinjsept.DeviceList,1), 1)); 
AO.thickinjsept.Monitor.MemberOf = {};
AO.thickinjsept.Monitor.Mode = 'Simulator';
AO.thickinjsept.Monitor.DataType = 'Scalar';
AO.thickinjsept.Monitor.ChannelNames  = sirius_ts_getname(AO.thickinjsept.FamilyName, 'Monitor', AO.thickinjsept.DeviceList);
AO.thickinjsept.Monitor.HW2PhysicsFcn = @sirius_hw2ph;
AO.thickinjsept.Monitor.Physics2HWFcn = @sirius_ph2hw;
AO.thickinjsept.Monitor.Units         = 'Hardware';
AO.thickinjsept.Monitor.HWUnits       = 'Ampere';
AO.thickinjsept.Monitor.PhysicsUnits  = 'Radian';
AO.thickinjsept.Setpoint.MemberOf = {'MachineConfig';};
AO.thickinjsept.Setpoint.Mode = 'Simulator';
AO.thickinjsept.Setpoint.DataType = 'Scalar';
AO.thickinjsept.Setpoint.ChannelNames  = sirius_ts_getname(AO.thickinjsept.FamilyName, 'Setpoint', AO.thickinjsept.DeviceList);
AO.thickinjsept.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.thickinjsept.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.thickinjsept.Setpoint.Units         = 'Hardware';
AO.thickinjsept.Setpoint.HWUnits       = 'Ampere';
AO.thickinjsept.Setpoint.PhysicsUnits  = 'Radian';
AO.thickinjsept.Setpoint.Range         = [0 300];
AO.thickinjsept.Setpoint.Tolerance     = .1;
AO.thickinjsept.Setpoint.DeltaRespMat  = .01;

AO.thininjsept.FamilyName  = 'thininjsept';
AO.thininjsept.MemberOf    = {'PlotFamily'; 'thininjsept'; 'SEPTUM'; 'Magnet';};
AO.thininjsept.DeviceList  = getDeviceList(1,1);
AO.thininjsept.ElementList = (1:size(AO.thininjsept.DeviceList,1))';
AO.thininjsept.Status      = ones(size(AO.thininjsept.DeviceList,1),1);
AO.thininjsept.Position    = [];
AO.thininjsept.ExcitationCurves = sirius_getexcdata(repmat('tspm-sep', size(AO.thininjsept.DeviceList,1), 1)); 
AO.thininjsept.Monitor.MemberOf = {};
AO.thininjsept.Monitor.Mode = 'Simulator';
AO.thininjsept.Monitor.DataType = 'Scalar';
AO.thininjsept.Monitor.ChannelNames  = sirius_ts_getname(AO.thininjsept.FamilyName, 'Monitor', AO.thininjsept.DeviceList);
AO.thininjsept.Monitor.HW2PhysicsFcn = @sirius_hw2ph;
AO.thininjsept.Monitor.Physics2HWFcn = @sirius_ph2hw;
AO.thininjsept.Monitor.Units         = 'Hardware';
AO.thininjsept.Monitor.HWUnits       = 'Ampere';
AO.thininjsept.Monitor.PhysicsUnits  = 'Radian';
AO.thininjsept.Setpoint.MemberOf = {'MachineConfig';};
AO.thininjsept.Setpoint.Mode = 'Simulator';
AO.thininjsept.Setpoint.DataType = 'Scalar';
AO.thininjsept.Setpoint.ChannelNames  = sirius_ts_getname(AO.thininjsept.FamilyName, 'Setpoint', AO.thininjsept.DeviceList);
AO.thininjsept.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.thininjsept.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.thininjsept.Setpoint.Units         = 'Hardware';
AO.thininjsept.Setpoint.HWUnits       = 'Ampere';
AO.thininjsept.Setpoint.PhysicsUnits  = 'Radian';
AO.thininjsept.Setpoint.Range         = [0 300];
AO.thininjsept.Setpoint.Tolerance     = .1;
AO.thininjsept.Setpoint.DeltaRespMat  = .01;

% Quadrupoles

AO.qf1ah.FamilyName  = 'qf1ah';
AO.qf1ah.MemberOf    = {'PlotFamily'; 'qf1ah'; 'QUAD'; 'Magnet';};
AO.qf1ah.DeviceList  = getDeviceList(1,1);
AO.qf1ah.ElementList = (1:size(AO.qf1ah.DeviceList,1))';
AO.qf1ah.Status      = ones(size(AO.qf1ah.DeviceList,1),1);
AO.qf1ah.Position    = [];
AO.qf1ah.ExcitationCurves = sirius_getexcdata(repmat('tsma-q', size(AO.qf1ah.DeviceList,1), 1));
AO.qf1ah.Monitor.MemberOf = {};
AO.qf1ah.Monitor.Mode = 'Simulator';
AO.qf1ah.Monitor.DataType = 'Scalar';
AO.qf1ah.Monitor.ChannelNames = sirius_ts_getname(AO.qf1ah.FamilyName, 'Monitor', AO.qf1ah.DeviceList);
AO.qf1ah.Monitor.HW2PhysicsFcn  = @sirius_hw2ph;
AO.qf1ah.Monitor.Physics2HWFcn  = @sirius_ph2hw;
AO.qf1ah.Monitor.Units        = 'Hardware';
AO.qf1ah.Monitor.HWUnits      = 'Ampere';
AO.qf1ah.Monitor.PhysicsUnits = 'meter^-2';
AO.qf1ah.Setpoint.MemberOf      = {'MachineConfig'};
AO.qf1ah.Setpoint.Mode          = 'Simulator';
AO.qf1ah.Setpoint.DataType      = 'Scalar';
AO.qf1ah.Setpoint.ChannelNames = sirius_ts_getname(AO.qf1ah.FamilyName, 'Setpoint', AO.qf1ah.DeviceList);
AO.qf1ah.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.qf1ah.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.qf1ah.Setpoint.Units         = 'Hardware';
AO.qf1ah.Setpoint.HWUnits       = 'Ampere';
AO.qf1ah.Setpoint.PhysicsUnits  = 'meter^-2';
AO.qf1ah.Setpoint.Range         = [0 225];
AO.qf1ah.Setpoint.Tolerance     = 0.2;
AO.qf1ah.Setpoint.DeltaRespMat  = 0.5; 


AO.qf1bh.FamilyName  = 'qf1bh';
AO.qf1bh.MemberOf    = {'PlotFamily'; 'qf1bh'; 'QUAD'; 'Magnet';};
AO.qf1bh.DeviceList  = getDeviceList(1,1);
AO.qf1bh.ElementList = (1:size(AO.qf1bh.DeviceList,1))';
AO.qf1bh.Status      = ones(size(AO.qf1bh.DeviceList,1),1);
AO.qf1bh.Position    = [];
AO.qf1bh.ExcitationCurves = sirius_getexcdata(repmat('tsma-q', size(AO.qf1bh.DeviceList,1), 1));
AO.qf1bh.Monitor.MemberOf = {};
AO.qf1bh.Monitor.Mode = 'Simulator';
AO.qf1bh.Monitor.DataType = 'Scalar';
AO.qf1bh.Monitor.ChannelNames = sirius_ts_getname(AO.qf1bh.FamilyName, 'Monitor', AO.qf1bh.DeviceList);
AO.qf1bh.Monitor.HW2PhysicsFcn  = @sirius_hw2ph;
AO.qf1bh.Monitor.Physics2HWFcn  = @sirius_ph2hw;
AO.qf1bh.Monitor.Units        = 'Hardware';
AO.qf1bh.Monitor.HWUnits      = 'Ampere';
AO.qf1bh.Monitor.PhysicsUnits = 'meter^-2';
AO.qf1bh.Setpoint.MemberOf      = {'MachineConfig'};
AO.qf1bh.Setpoint.Mode          = 'Simulator';
AO.qf1bh.Setpoint.DataType      = 'Scalar';
AO.qf1bh.Setpoint.ChannelNames = sirius_ts_getname(AO.qf1bh.FamilyName, 'Setpoint', AO.qf1bh.DeviceList);
AO.qf1bh.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.qf1bh.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.qf1bh.Setpoint.Units         = 'Hardware';
AO.qf1bh.Setpoint.HWUnits       = 'Ampere';
AO.qf1bh.Setpoint.PhysicsUnits  = 'meter^-2';
AO.qf1bh.Setpoint.Range         = [0 225];
AO.qf1bh.Setpoint.Tolerance     = 0.2;
AO.qf1bh.Setpoint.DeltaRespMat  = 0.5; 


AO.qd2h.FamilyName  = 'qd2h';
AO.qd2h.MemberOf    = {'PlotFamily'; 'qd2h'; 'QUAD'; 'Magnet';};
AO.qd2h.DeviceList  = getDeviceList(1,1);
AO.qd2h.ElementList = (1:size(AO.qd2h.DeviceList,1))';
AO.qd2h.Status      = ones(size(AO.qd2h.DeviceList,1),1);
AO.qd2h.Position    = [];
AO.qd2h.ExcitationCurves = sirius_getexcdata(repmat('tsma-q', size(AO.qd2h.DeviceList,1), 1));
AO.qd2h.Monitor.MemberOf = {};
AO.qd2h.Monitor.Mode = 'Simulator';
AO.qd2h.Monitor.DataType = 'Scalar';
AO.qd2h.Monitor.ChannelNames = sirius_ts_getname(AO.qd2h.FamilyName, 'Monitor', AO.qd2h.DeviceList);
AO.qd2h.Monitor.HW2PhysicsFcn = @sirius_hw2ph;
AO.qd2h.Monitor.Physics2HWFcn = @sirius_ph2hw;
AO.qd2h.Monitor.Units        = 'Hardware';
AO.qd2h.Monitor.HWUnits      = 'Ampere';
AO.qd2h.Monitor.PhysicsUnits = 'meter^-2';
AO.qd2h.Setpoint.MemberOf      = {'MachineConfig'};
AO.qd2h.Setpoint.Mode          = 'Simulator';
AO.qd2h.Setpoint.DataType      = 'Scalar';
AO.qd2h.Setpoint.ChannelNames = sirius_ts_getname(AO.qd2h.FamilyName, 'Setpoint', AO.qd2h.DeviceList);
AO.qd2h.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.qd2h.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.qd2h.Setpoint.Units         = 'Hardware';
AO.qd2h.Setpoint.HWUnits       = 'Ampere';
AO.qd2h.Setpoint.PhysicsUnits  = 'meter^-2';
AO.qd2h.Setpoint.Range         = [0 225];
AO.qd2h.Setpoint.Tolerance     = 0.2;
AO.qd2h.Setpoint.DeltaRespMat  = 0.5; 


AO.qf2h.FamilyName  = 'qf2h';
AO.qf2h.MemberOf    = {'PlotFamily'; 'qf2h'; 'QUAD'; 'Magnet';};
AO.qf2h.DeviceList  = getDeviceList(1,1);
AO.qf2h.ElementList = (1:size(AO.qf2h.DeviceList,1))';
AO.qf2h.Status      = ones(size(AO.qf2h.DeviceList,1),1);
AO.qf2h.Position    = [];
AO.qf2h.ExcitationCurves = sirius_getexcdata(repmat('tsma-q', size(AO.qf2h.DeviceList,1), 1));
AO.qf2h.Monitor.MemberOf = {};
AO.qf2h.Monitor.Mode = 'Simulator';
AO.qf2h.Monitor.DataType = 'Scalar';
AO.qf2h.Monitor.ChannelNames = sirius_ts_getname(AO.qf2h.FamilyName, 'Monitor', AO.qf2h.DeviceList);
AO.qf2h.Monitor.HW2PhysicsFcn = @sirius_hw2ph;
AO.qf2h.Monitor.Physics2HWFcn = @sirius_ph2hw;
AO.qf2h.Monitor.Units        = 'Hardware';
AO.qf2h.Monitor.HWUnits      = 'Ampere';
AO.qf2h.Monitor.PhysicsUnits = 'meter^-2';
AO.qf2h.Setpoint.MemberOf      = {'MachineConfig'};
AO.qf2h.Setpoint.Mode          = 'Simulator';
AO.qf2h.Setpoint.DataType      = 'Scalar';
AO.qf2h.Setpoint.ChannelNames = sirius_ts_getname(AO.qf2h.FamilyName, 'Setpoint', AO.qf2h.DeviceList);
AO.qf2h.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.qf2h.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.qf2h.Setpoint.Units         = 'Hardware';
AO.qf2h.Setpoint.HWUnits       = 'Ampere';
AO.qf2h.Setpoint.PhysicsUnits  = 'meter^-2';
AO.qf2h.Setpoint.Range         = [0 225];
AO.qf2h.Setpoint.Tolerance     = 0.2;
AO.qf2h.Setpoint.DeltaRespMat  = 0.5; 


AO.qf3h.FamilyName  = 'qf3h';
AO.qf3h.MemberOf    = {'PlotFamily'; 'qf3h'; 'QUAD'; 'Magnet';};
AO.qf3h.DeviceList  = getDeviceList(1,1);
AO.qf3h.ElementList = (1:size(AO.qf3h.DeviceList,1))';
AO.qf3h.Status      = ones(size(AO.qf3h.DeviceList,1),1);
AO.qf3h.Position    = [];
AO.qf3h.ExcitationCurves = sirius_getexcdata(repmat('tsma-q', size(AO.qf3h.DeviceList,1), 1));
AO.qf3h.Monitor.MemberOf = {};
AO.qf3h.Monitor.Mode = 'Simulator';
AO.qf3h.Monitor.DataType = 'Scalar';
AO.qf3h.Monitor.ChannelNames = sirius_ts_getname(AO.qf3h.FamilyName, 'Monitor', AO.qf3h.DeviceList);
AO.qf3h.Monitor.HW2PhysicsFcn = @sirius_hw2ph;
AO.qf3h.MOnitor.Physics2HWFcn = @sirius_ph2hw;
AO.qf3h.Monitor.Units        = 'Hardware';
AO.qf3h.Monitor.HWUnits      = 'Ampere';
AO.qf3h.Monitor.PhysicsUnits = 'meter^-2';
AO.qf3h.Setpoint.MemberOf      = {'MachineConfig'};
AO.qf3h.Setpoint.Mode          = 'Simulator';
AO.qf3h.Setpoint.DataType      = 'Scalar';
AO.qf3h.Setpoint.ChannelNames = sirius_ts_getname(AO.qf3h.FamilyName, 'Setpoint', AO.qf3h.DeviceList);
AO.qf3h.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.qf3h.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.qf3h.Setpoint.Units         = 'Hardware';
AO.qf3h.Setpoint.HWUnits       = 'Ampere';
AO.qf3h.Setpoint.PhysicsUnits  = 'meter^-2';
AO.qf3h.Setpoint.Range         = [0 225];
AO.qf3h.Setpoint.Tolerance     = 0.2;
AO.qf3h.Setpoint.DeltaRespMat  = 0.5; 


AO.qd4ah.FamilyName  = 'qd4ah';
AO.qd4ah.MemberOf    = {'PlotFamily'; 'qd4ah'; 'QUAD'; 'Magnet';};
AO.qd4ah.DeviceList  = getDeviceList(1,1);
AO.qd4ah.ElementList = (1:size(AO.qd4ah.DeviceList,1))';
AO.qd4ah.Status      = ones(size(AO.qd4ah.DeviceList,1),1);
AO.qd4ah.Position    = [];
AO.qd4ah.ExcitationCurves = sirius_getexcdata(repmat('tsma-q', size(AO.qd4ah.DeviceList,1), 1));
AO.qd4ah.Monitor.MemberOf = {};
AO.qd4ah.Monitor.Mode = 'Simulator';
AO.qd4ah.Monitor.DataType = 'Scalar';
AO.qd4ah.Monitor.ChannelNames = sirius_ts_getname(AO.qd4ah.FamilyName, 'Monitor', AO.qd4ah.DeviceList);
AO.qd4ah.Monitor.HW2PhysicsFcn = @sirius_hw2ph;
AO.qd4ah.Monitor.Physics2HWFcn = @sirius_ph2hw;
AO.qd4ah.Monitor.Units        = 'Hardware';
AO.qd4ah.Monitor.HWUnits      = 'Ampere';
AO.qd4ah.Monitor.PhysicsUnits = 'meter^-2';
AO.qd4ah.Setpoint.MemberOf      = {'MachineConfig'};
AO.qd4ah.Setpoint.Mode          = 'Simulator';
AO.qd4ah.Setpoint.DataType      = 'Scalar';
AO.qd4ah.Setpoint.ChannelNames = sirius_ts_getname(AO.qd4ah.FamilyName, 'Setpoint', AO.qd4ah.DeviceList);
AO.qd4ah.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.qd4ah.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.qd4ah.Setpoint.Units         = 'Hardware';
AO.qd4ah.Setpoint.HWUnits       = 'Ampere';
AO.qd4ah.Setpoint.PhysicsUnits  = 'meter^-2';
AO.qd4ah.Setpoint.Range         = [0 225];
AO.qd4ah.Setpoint.Tolerance     = 0.2;
AO.qd4ah.Setpoint.DeltaRespMat  = 0.5; 


AO.qf4h.FamilyName  = 'qf4h';
AO.qf4h.MemberOf    = {'PlotFamily'; 'qf4h'; 'QUAD'; 'Magnet';};
AO.qf4h.DeviceList  = getDeviceList(1,1);
AO.qf4h.ElementList = (1:size(AO.qf4h.DeviceList,1))';
AO.qf4h.Status      = ones(size(AO.qf4h.DeviceList,1),1);
AO.qf4h.Position    = [];
AO.qf4h.ExcitationCurves = sirius_getexcdata(repmat('tsma-q', size(AO.qf4h.DeviceList,1), 1));
AO.qf4h.Monitor.MemberOf = {};
AO.qf4h.Monitor.Mode = 'Simulator';
AO.qf4h.Monitor.DataType = 'Scalar';
AO.qf4h.Monitor.ChannelNames = sirius_ts_getname(AO.qf4h.FamilyName, 'Monitor', AO.qf4h.DeviceList);
AO.qf4h.Monitor.HW2PhysicsFcn = @sirius_hw2ph;
AO.qf4h.Monitor.Physics2HWFcn = @sirius_ph2hw;
AO.qf4h.Monitor.Units        = 'Hardware';
AO.qf4h.Monitor.HWUnits      = 'Ampere';
AO.qf4h.Monitor.PhysicsUnits = 'meter^-2';
AO.qf4h.Setpoint.MemberOf      = {'MachineConfig'};
AO.qf4h.Setpoint.Mode          = 'Simulator';
AO.qf4h.Setpoint.DataType      = 'Scalar';
AO.qf4h.Setpoint.ChannelNames = sirius_ts_getname(AO.qf4h.FamilyName, 'Setpoint', AO.qf4h.DeviceList);
AO.qf4h.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.qf4h.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.qf4h.Setpoint.Units         = 'Hardware';
AO.qf4h.Setpoint.HWUnits       = 'Ampere';
AO.qf4h.Setpoint.PhysicsUnits  = 'meter^-2';
AO.qf4h.Setpoint.Range         = [0 225];
AO.qf4h.Setpoint.Tolerance     = 0.2;
AO.qf4h.Setpoint.DeltaRespMat  = 0.5; 

AO.qd4bh.FamilyName  = 'qd4bh';
AO.qd4bh.MemberOf    = {'PlotFamily'; 'qd4bh'; 'QUAD'; 'Magnet';};
AO.qd4bh.DeviceList  = getDeviceList(1,1);
AO.qd4bh.ElementList = (1:size(AO.qd4bh.DeviceList,1))';
AO.qd4bh.Status      = ones(size(AO.qd4bh.DeviceList,1),1);
AO.qd4bh.Position    = [];
AO.qd4bh.ExcitationCurves = sirius_getexcdata(repmat('tsma-q', size(AO.qd4bh.DeviceList,1), 1));
AO.qd4bh.Monitor.MemberOf = {};
AO.qd4bh.Monitor.Mode = 'Simulator';
AO.qd4bh.Monitor.DataType = 'Scalar';
AO.qd4bh.Monitor.ChannelNames = sirius_ts_getname(AO.qd4bh.FamilyName, 'Monitor', AO.qd4bh.DeviceList);
AO.qd4bh.Monitor.HW2PhysicsFcn = @sirius_hw2ph;
AO.qd4bh.Monitor.Physics2HWFcn = @sirius_ph2hw;
AO.qd4bh.Monitor.Units        = 'Hardware';
AO.qd4bh.Monitor.HWUnits      = 'Ampere';
AO.qd4bh.Monitor.PhysicsUnits = 'meter^-2';
AO.qd4bh.Setpoint.MemberOf      = {'MachineConfig'};
AO.qd4bh.Setpoint.Mode          = 'Simulator';
AO.qd4bh.Setpoint.DataType      = 'Scalar';
AO.qd4bh.Setpoint.ChannelNames = sirius_ts_getname(AO.qd4bh.FamilyName, 'Setpoint', AO.qd4bh.DeviceList);
AO.qd4bh.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.qd4bh.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.qd4bh.Setpoint.Units         = 'Hardware';
AO.qd4bh.Setpoint.HWUnits       = 'Ampere';
AO.qd4bh.Setpoint.PhysicsUnits  = 'meter^-2';
AO.qd4bh.Setpoint.Range         = [0 225];
AO.qd4bh.Setpoint.Tolerance     = 0.2;
AO.qd4bh.Setpoint.DeltaRespMat  = 0.5;  


%%%%%%%%%%%%%%%%%%%%%
% Corrector Magnets %
%%%%%%%%%%%%%%%%%%%%%

% ch
AO.ch.FamilyName  = 'ch';
AO.ch.MemberOf    = {'PlotFamily'; 'COR'; 'ch'; 'Magnet'; 'HCM'};
AO.ch.DeviceList  = getDeviceList(1,5);
AO.ch.ElementList = (1:size(AO.ch.DeviceList,1))';
AO.ch.Status      = ones(size(AO.ch.DeviceList,1),1);
AO.ch.Position    = [];
AO.ch.ExcitationCurves = sirius_getexcdata(repmat('tsma-ch', size(AO.ch.DeviceList,1), 1));
AO.ch.Monitor.MemberOf = {'Horizontal'; 'COR'; 'ch'; 'Magnet';};
AO.ch.Monitor.Mode = 'Simulator';
AO.ch.Monitor.DataType = 'Scalar';
AO.ch.Monitor.ChannelNames  = sirius_ts_getname(AO.ch.FamilyName, 'Monitor', AO.ch.DeviceList);
AO.ch.Monitor.HW2PhysicsFcn = @sirius_hw2ph;
AO.ch.Monitor.Physics2HWFcn = @sirius_ph2hw;
AO.ch.Monitor.Units         = 'Physics';
AO.ch.Monitor.HWUnits       = 'Ampere';
AO.ch.Monitor.PhysicsUnits  = 'Radian';
AO.ch.Setpoint.MemberOf = {'MachineConfig'; 'Horizontal'; 'COR'; 'ch'; 'Magnet'; 'Setpoint'; 'measbpmresp';};
AO.ch.Setpoint.Mode = 'Simulator';
AO.ch.Setpoint.DataType = 'Scalar';
AO.ch.Setpoint.ChannelNames = sirius_ts_getname(AO.ch.FamilyName, 'Setpoint', AO.ch.DeviceList);
AO.ch.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.ch.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.ch.Setpoint.Units        = 'Physics';
AO.ch.Setpoint.HWUnits      = 'Ampere';
AO.ch.Setpoint.PhysicsUnits = 'Radian';
AO.ch.Setpoint.Range        = [-10 10];
AO.ch.Setpoint.Tolerance    = 0.00001;
AO.ch.Setpoint.DeltaRespMat = 0.0005; 

% cv
AO.cv.FamilyName  = 'cv';
AO.cv.MemberOf    = {'PlotFamily'; 'COR'; 'cv'; 'Magnet'; 'VCM'};
AO.cv.DeviceList  = getDeviceList(1,5);
AO.cv.ElementList = (1:size(AO.cv.DeviceList,1))';
AO.cv.Status      = ones(size(AO.cv.DeviceList,1),1);
AO.cv.Position    = [];
AO.cv.ExcitationCurves = sirius_getexcdata(repmat('tsma-cv', size(AO.cv.DeviceList,1), 1));
AO.cv.Monitor.MemberOf = {'Vertical'; 'COR'; 'cv'; 'Magnet';};
AO.cv.Monitor.Mode = 'Simulator';
AO.cv.Monitor.DataType = 'Scalar';
AO.cv.Monitor.ChannelNames = sirius_ts_getname(AO.cv.FamilyName, 'Monitor', AO.cv.DeviceList);
AO.cv.Monitor.HW2PhysicsFcn = @sirius_hw2ph;
AO.cv.Monitor.Physics2HWFcn = @sirius_ph2hw;
AO.cv.Monitor.Units        = 'Physics';
AO.cv.Monitor.HWUnits      = 'Ampere';
AO.cv.Monitor.PhysicsUnits = 'Radian';
AO.cv.Setpoint.MemberOf = {'MachineConfig'; 'Horizontal'; 'COR'; 'cv'; 'Magnet'; 'Setpoint'; 'measbpmresp';};
AO.cv.Setpoint.Mode = 'Simulator';
AO.cv.Setpoint.DataType = 'Scalar';
AO.cv.Setpoint.ChannelNames = sirius_ts_getname(AO.cv.FamilyName, 'Setpoint', AO.cv.DeviceList);
AO.cv.Setpoint.HW2PhysicsFcn = @sirius_hw2ph;
AO.cv.Setpoint.Physics2HWFcn = @sirius_ph2hw;
AO.cv.Setpoint.Units        = 'Physics';
AO.cv.Setpoint.HWUnits      = 'Ampere';
AO.cv.Setpoint.PhysicsUnits = 'Radian';
AO.cv.Setpoint.Range        = [-10 10];
AO.cv.Setpoint.Tolerance    = 0.00001;
AO.cv.Setpoint.DeltaRespMat = 0.0005; 


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
