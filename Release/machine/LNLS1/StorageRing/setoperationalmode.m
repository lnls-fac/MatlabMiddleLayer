function setoperationalmode(ModeNumber)
%SETOPERATIONALMODE - Switches between the various operational modes
%  setoperationalmode(ModeNumber)
%
%  ModeNumber = 1.  1.37 GeV, User Mode {Default}
%               2.  0.49 GeV, Injection Mode
%               3.  1.37 GeV, BEDI
%               4.  1.37 GeV, Low Alpha
%               5.  1.37 GeV - No IDs
%               6.  1.37 GeV - AWS07
%               7.  1.37 GeV - Low-Alpha
%
% History
%
% 2014-04-26 Low-Alpha cleanup
% 2011-04-27 Cleaned up code (Ximenes)




% Check if the AO exists
checkforao;

% MODES
ModeCell = { ...
    '1: 1.37 GeV - User Mode', ...
    '2: 0.49 GeV - Injection', ...
    '3: 1.37 GeV - BEDI', ...
    '4: 1.37 GeV - No IDs', ...
    '5: 1.37 GeV - AWS07', ...
    '6: 1.37 GeV - Low-Alpha', ...
};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Accelerator Dependent Modes %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin < 1
    [ModeNumber, OKFlag] = listdlg('Name','LNLS1','PromptString','Select the Operational Mode:', 'SelectionMode','single', 'ListString', ModeCell);
    if OKFlag ~= 1
        fprintf('   Operational mode not changed\n');
        return
    end
end

if ModeNumber == 1
    disp('   setoperationmode: USERMODE(1)')
    set_operationalmode_usermode;
elseif ModeNumber == 2
    disp('   setoperationmode: INJECTIONMODE(2)')
    set_operationalmode_injectionmode;
elseif ModeNumber == 3
    disp('   setoperationmode: BEDI(3)')
    set_operationalmode_BEDI;
elseif ModeNumber == 4
    disp('   setoperationmode: NOIDS(4)')
    set_operationalmode_noIDs;
elseif ModeNumber == 5
    disp('   setoperationmode: AWS07(5)')
    set_operationalmode_AWS07;
elseif ModeNumber == 6
    disp('   setoperationmode: LOWALPHA(6)')
    set_operationalmode_LowAlpha;
else
    error('Operational mode unknown');
end

% Set the AD directory path
AD = getad;
setmmldirectories(AD.Machine, AD.SubMachine, AD.ModeName, AD.OpsFileExtension);
% Updates the AT indices in the MiddleLayer with the present AT lattice
updateatindex;
% Set the model energy
setenergymodel(AD.Energy);
% Cavity and radiation
setcavity on;
setradiation on;
fprintf('   Radiation and cavities are on. Use setradiation / setcavity to modify.\n');


if ModeNumber == 1
    lnls1_simulation_mode_user_1p37GeV;    
elseif ModeNumber == 2
    lnls1_simulation_mode_injection_500MeV;
elseif ModeNumber == 3
    lnls1_simulation_mode_BEDI_1p37GeV;
elseif ModeNumber == 4
    lnls1_simulation_mode_IDsOFF_1p37GeV;
elseif ModeNumber == 5
    lnls1_simulation_mode_AWS07_1p37GeV;
elseif ModeNumber == 6
    lnls1_simulation_mode_low_alpha;
else
    error('Operational mode unknown');
end
% Updates the AT indices in the MiddleLayer with the present AT lattice
updateatindex;


%%%%%%%%%%%%%%%%%%%%%%
% Final mode changes %
%%%%%%%%%%%%%%%%%%%%%%
if ModeNumber == 1
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Add LOCO Parameters to AO and AT-Model %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  'Nominal'    - Sets nominal gains (1) / rolls (0) to the model.
    %  'SetGains'   - Set gains/coupling from a LOCO file.
    %  'SetModel'   - Set the model from a LOCO file.  But it only changes
    %                 the part of the model that does not get corrected
    %                 in 'Symmetrize' (also does a SetGains).
    %  'LOCO2Model' - Set the model from a LOCO file (also does a SetGains).
    %                 This uses the LOCO AT model!!! And sets all lattice 
    %                 machines fit in the LOCO run to the model.
    %
    %   Basically, use 'SetGains' or 'SetModel' if the LOCO run was applied to the accelerator
    %              use 'LOCO2Model' if the LOCO run was made after the final setup.  Of couse,
    %              setlocodata must be written properly for all this to work correctly.
    try
        % I typically place to store the calibration LOCO file in the StorageRingOpsData directory
        %LOCOFile = [getfamilydata('Directory','OpsData'),'LOCO_User'];
        setlocodata('Nominal');
        %setlocodata('SetGains',   LOCOFile);
        %setlocodata('SetModel',   LOCOFile);
        %setlocodata('LOCO2Model', LOCOFile);
    catch
        fprintf('   Problem with setting the LOCO calibration.\n');
    end
elseif ModeNumber == 3
    setlocodata('SetGains', '/home/fac_files/code/MatlabMiddleLayer/Release/machine/LNLS1/StorageRingData/BEDI/LOCO/Golden/LOCO - quadfams.mat');
elseif ModeNumber == 101
    setlocodata('Nominal');
    setfamilydata(0,'BPMx','Offset');
    setfamilydata(0,'BPMy','Offset');
    setfamilydata(0,'BPMx','Golden');
    setfamilydata(0,'BPMy','Golden');
    %setsp('HCM', 0, 'Simulator', 'Physics');
    %setsp('VCM', 0, 'Simulator', 'Physics');
    setfamilydata(0,'TuneDelay');
else
    setlocodata('Nominal');
end


fprintf('   Middlelayer setup for operational mode: %s\n', AD.OperationalMode);
atsummary;

function set_operationalmode_usermode

global THERING;

AD = getad;
AD.Machine             = 'LNLS1';           % Will already be defined if setpathmml was used
AD.SubMachine          = 'StorageRing';     % Will already be defined if setpathmml was used
AD.OperationalMode     = 'User Mode (1.37 GeV)';
AD.Energy              = 1.37;
AD.InjectionEnergy     = 0.49;
AD.ModeName            = 'User';
AD.OpsFileExtension    = '';

THERING = lnls1_lattice(AD.Energy);

AD.Circumference       = findspos(THERING,length(THERING)+1);
AD.HarmonicNumber      = 148;
AD.LNLS1Params         = lnls1_params;
AD.DeltaRFDisp         = 2000e-6;
%AD.DeltaRFChro         = [-4000 -2000 -1000 0 1000 2000 4000] * 1e-6;
%AD.DeltaRFChro         = [-2000 -1000 0 1000 2000] * 1e-6;
AD.DeltaRFChro         = 1e-6 * linspace(-3000,3000,11);

AD.BeamCurrent         = 0.25; % [A]
AD.NrBunches           = AD.HarmonicNumber;
AD.Coupling            = 0.0035;


AD.TuneDelay           = 3.0;  
AD.ATModel             = 'lnls1_lattice';
AD.Chromaticity.Golden = [1; 1];
AD.MCF                 = getmcf('Model');

AD.OpsData.PrsProfFile = 'lnls1_pressure_profile.txt';
AD.AveragePressure     = 1.333e-9; % [mbar]

setad(AD);
switch2sim;
switch2hw; 


function set_operationalmode_noIDs

global THERING;

AD = getad;
AD.Machine             = 'LNLS1';           % Will already be defined if setpathmml was used
AD.SubMachine          = 'StorageRing';  % Will already be defined if setpathmml was used
AD.OperationalMode     = 'All IDs Off (1.37 GeV)';
AD.Energy              = 1.37;
AD.InjectionEnergy     = 0.49;
AD.ModeName            = 'User';
AD.OpsFileExtension    = '';

THERING = lnls1_lattice(AD.Energy);


AD.Circumference       = findspos(THERING,length(THERING)+1);
AD.HarmonicNumber      = 148;
AD.LNLS1Params         = lnls1_params;
AD.DeltaRFDisp         = 2000e-6;
%AD.DeltaRFChro         = [-4000 -2000 -1000 0 1000 2000 4000] * 1e-6;
%AD.DeltaRFChro         = [-2000 -1000 0 1000 2000] * 1e-6;
AD.DeltaRFChro         = 1e-6 * linspace(-3000,3000,11);

AD.BeamCurrent         = 0.25; % [A]
AD.NrBunches           = AD.HarmonicNumber;
AD.Coupling            = 0.0035;

AD.TuneDelay           = 3.0;  
AD.ATModel             = 'lnls1_lattice';
AD.Chromaticity.Golden = [1; 1];
AD.MCF                 = getmcf('Model');

AD.OpsData.PrsProfFile = 'lnls1_pressure_profile.txt';
AD.AveragePressure     = 1.333e-9; % [mbar]

setad(AD);
switch2sim;
switch2hw; 

function set_operationalmode_AWS07

global THERING;

AD = getad;
AD.Machine             = 'LNLS1';           % Will already be defined if setpathmml was used
AD.SubMachine          = 'StorageRing';  % Will already be defined if setpathmml was used
AD.OperationalMode     = 'With AWS07 (1.37 GeV)';
AD.Energy              = 1.37;
AD.InjectionEnergy     = 0.49;
AD.ModeName            = 'User';
AD.OpsFileExtension    = '';

THERING = lnls1_lattice(AD.Energy);

AD.Circumference       = findspos(THERING,length(THERING)+1);
AD.HarmonicNumber      = 148;
AD.LNLS1Params         = lnls1_params;
AD.DeltaRFDisp         = 2000e-6;
%AD.DeltaRFChro         = [-4000 -2000 -1000 0 1000 2000 4000] * 1e-6;
%AD.DeltaRFChro         = [-2000 -1000 0 1000 2000] * 1e-6;
AD.DeltaRFChro         = 1e-6 * linspace(-3000,3000,11);

AD.BeamCurrent         = 0.25; % [A]
AD.NrBunches           = AD.HarmonicNumber;
AD.Coupling            = 0.0035;


AD.TuneDelay           = 3.0;  
AD.ATModel             = 'lnls1_lattice';
AD.Chromaticity.Golden = [1; 1];
AD.MCF                 = getmcf('Model');

AD.OpsData.PrsProfFile = 'lnls1_pressure_profile.txt';
AD.AveragePressure     = 1.333e-9; % [mbar]

setad(AD);
switch2sim;
switch2hw; 

function set_operationalmode_injectionmode

global THERING;

AD = getad;
AD.Machine             = 'LNLS1';           % Will already be defined if setpathmml was used
AD.SubMachine          = 'StorageRing';  % Will already be defined if setpathmml was used
AD.OperationalMode     = 'Injection Mode (0.49 GeV)';
AD.Energy              = 0.49;
AD.InjectionEnergy     = 0.49;
AD.ModeName            = 'Injection';
AD.OpsFileExtension    = '';

THERING = lnls1_lattice(AD.Energy);

AD.Circumference       = findspos(THERING,length(THERING)+1);
AD.HarmonicNumber      = 148;
AD.LNLS1Params         = lnls1_params;
AD.DeltaRFDisp         = 2000e-6;
AD.DeltaRFChro         = [-2000 -1000 0 1000 2000] * 1e-6;

AD.BeamCurrent         = 0.25; % [A]
AD.NrBunches           = AD.HarmonicNumber;
AD.Coupling            = 0.0035;

AD.TuneDelay           = 3.0;  
AD.ATModel             = 'lnls1_lattice';
AD.Chromaticity.Golden = [1; 1];
AD.MCF                 = getmcf('Model');

AD.OpsData.PrsProfFile = 'lnls1_pressure_profile.txt';
AD.AveragePressure     = 1.333e-9; % [mbar]

setad(AD);
switch2sim;
switch2hw; 

function set_operationalmode_BEDI

global THERING;

AD = getad;
AD.Machine             = 'LNLS1';           % Will already be defined if setpathmml was used
AD.SubMachine          = 'StorageRing';  % Will already be defined if setpathmml was used
AD.OperationalMode     = 'User Mode (1.37 GeV) BEDI';
AD.Energy              = 1.37;
AD.InjectionEnergy     = 0.49;
AD.ModeName            = 'BEDI';
AD.OpsFileExtension    = '';

THERING = lnls1_lattice_BEDI(AD.Energy);


AD.Circumference       = findspos(THERING,length(THERING)+1);
AD.HarmonicNumber      = 148;
AD.LNLS1Params         = lnls1_params;
AD.DeltaRFDisp         = 2000e-6;
%AD.DeltaRFChro         = [-4000 -2000 -1000 0 1000 2000 4000] * 1e-6;
%AD.DeltaRFChro         = [-2000 -1000 0 1000 2000] * 1e-6;
AD.DeltaRFChro         = 1e-6 * linspace(-3000,3000,11);

AD.BeamCurrent         = 0.25; % [A]
AD.NrBunches           = AD.HarmonicNumber;
AD.Coupling            = 0.0035;

AD.TuneDelay           = 3.0;  
AD.ATModel             = 'lnls1_lattice_BEDI';
AD.Chromaticity.Golden = [1; 1];
AD.MCF                 = getmcf('Model');

AD.OpsData.PrsProfFile = 'lnls1_pressure_profile.txt';
AD.AveragePressure     = 1.333e-9; % [mbar]

setad(AD);
switch2sim;
switch2hw; 


function set_operationalmode_LowAlpha

global THERING;

AD = getad;
AD.Machine             = 'LNLS1';           % Will already be defined if setpathmml was used
AD.SubMachine          = 'StorageRing';     % Will already be defined if setpathmml was used
AD.OperationalMode     = 'Low Alpha (1.37 GeV)';
AD.Energy              = 1.37;
AD.InjectionEnergy     = 0.49;
AD.ModeName            = 'LowAlpha';
AD.OpsFileExtension    = '';

THERING = lnls1_lattice_low_alpha(AD.Energy);

AD.Circumference       = findspos(THERING,length(THERING)+1);
AD.HarmonicNumber      = 148;
AD.LNLS1Params         = lnls1_params;
AD.DeltaRFDisp         = 50e-6;
%AD.DeltaRFChro         = [-4000 -2000 -1000 0 1000 2000 4000] * 1e-6;
%AD.DeltaRFChro         = [-2000 -1000 0 1000 2000] * 1e-6;
AD.DeltaRFChro         = 1e-6 * linspace(-3000,3000,11);

AD.BeamCurrent         = 0.25; % [A]
AD.NrBunches           = AD.HarmonicNumber;
AD.Coupling            = 0.0035;

AD.TuneDelay           = 3.0;  
AD.ATModel             = 'lnls1_lattice_low_alpha';
AD.Chromaticity.Golden = [1; 1];
AD.MCF                 = getmcf('Model');

AD.OpsData.PrsProfFile = 'lnls1_pressure_profile.txt';
AD.AveragePressure     = 1.333e-9; % [mbar]

setad(AD);
switch2sim;
switch2hw;



