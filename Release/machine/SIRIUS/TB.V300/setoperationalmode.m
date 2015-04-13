function setoperationalmode(ModeNumber)

% Check if the AO exists
checkforao;

% MODES
ModeCell = { ...
    '150 MeV - M0', ...
    '150 MeV - M1', ...
    '150 MeV - M2', ...
};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Accelerator Dependent Modes %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin < 1
    [ModeNumber, OKFlag] = listdlg('Name','SIRIUS','PromptString','Select the Operational Mode:', 'SelectionMode','single', 'ListString', ModeCell);
    if OKFlag ~= 1
        fprintf('   Operational mode not changed\n');
        return
    end
end

if (ModeNumber == 1)
    set_operationalmode_mode1;
elseif (ModeNumber == 2)
    set_operationalmode_mode2;
elseif (ModeNumber == 3)
    set_operationalmode_mode3;
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
setcavity off;
setradiation off;
fprintf('   Radiation and cavities are off. Use setradiation / setcavity to modify.\n');




%%%%%%%%%%%%%%%%%%%%%%
% Final mode changes %
%%%%%%%%%%%%%%%%%%%%%%
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


fprintf('   Middlelayer setup for operational mode: %s\n', AD.OperationalMode);
%atsummary;

function set_operationalmode_mode1

global THERING;

AD = getad;
AD.Machine             = 'SIRIUS';  % Will already be defined if setpathmml was used
AD.SubMachine          = 'TB.V300';  % Will already be defined if setpathmml was used
AD.OperationalMode     = 'M0';
AD.Energy              = 0.150;
AD.InjectionEnergy     = 0.150;
AD.ModeName            = 'M0';
AD.OpsFileExtension    = '';

THERING = sirius_tb_lattice(AD.Energy, AD.ModeName);

AD.DeltaRFDisp         = 2000e-6;
AD.ATModel             = 'sirius_tb_lattice';
AD.BeamCurrent         = 0.500; % [A]
AD.Coupling            = 0.010;
%AD.OpsData.PrsProfFile = 'sirius_V500_pressure_profile.txt';

setad(AD);
switch2sim;
switch2hw;

function set_operationalmode_mode2

global THERING;

AD = getad;
AD.Machine             = 'SIRIUS';  % Will already be defined if setpathmml was used
AD.SubMachine          = 'TB.V300';  % Will already be defined if setpathmml was used
AD.OperationalMode     = 'M1';
AD.Energy              = 0.150;
AD.InjectionEnergy     = 0.150;
AD.ModeName            = 'M1';
AD.OpsFileExtension    = '';

THERING = sirius_tb_lattice(AD.Energy, AD.ModeName);

AD.DeltaRFDisp         = 2000e-6;
AD.ATModel             = 'sirius_tb_lattice';
AD.BeamCurrent         = 0.500; % [A]
AD.Coupling            = 0.010;
%AD.OpsData.PrsProfFile = 'sirius_V500_pressure_profile.txt';

setad(AD);
switch2sim;
switch2hw;

function set_operationalmode_mode3

global THERING;

AD = getad;
AD.Machine             = 'SIRIUS';  % Will already be defined if setpathmml was used
AD.SubMachine          = 'TB.V300';  % Will already be defined if setpathmml was used
AD.OperationalMode     = 'M2';
AD.Energy              = 0.150;
AD.InjectionEnergy     = 0.150;
AD.ModeName            = 'M2';
AD.OpsFileExtension    = '';

THERING = sirius_tb_lattice(AD.Energy, AD.ModeName);

AD.DeltaRFDisp         = 2000e-6;
AD.ATModel             = 'sirius_tb_lattice';
AD.BeamCurrent         = 0.500; % [A]
AD.Coupling            = 0.010;
%AD.OpsData.PrsProfFile = 'sirius_V500_pressure_profile.txt';

setad(AD);
switch2sim;
switch2hw;
