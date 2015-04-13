function setoperationalmode(ModeNumber)
%SETOPERATIONALMODE - Switches between the various operational modes
%
%  See also aoinit, updateatindex

global THERING

% Check if the AO exists
checkforao;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Accelerator Dependent Modes %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ModeCell = {'NSLS-II Model', 'NSLS-II Operations' };

if nargin < 1    
    [ModeNumber, OKFlag] = listdlg('Name','NSLS-II','PromptString','Select the Operational Mode:', 'SelectionMode','single', 'ListString', ModeCell, 'ListSize', [450 200]);
    if OKFlag ~= 1
       fprintf('   Operational mode not changed\n');
       return
    end
end


    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Accelerator Data Structure %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
AD = getad;
AD.Machine = 'NSLS2';              % Will already be defined if setpathmml was used
AD.SubMachine = 'StorageRing';    % Will already be defined if setpathmml was used
AD.OperationalMode = '';          % Gets filled in later
AD.Energy = 3.0;      % make sure this is the same as bend2gev at the production lattice!
AD.InjectionEnergy = 3.0;
AD.HarmonicNumber = 1320;


% RF Defaults for disperion and chromaticity measurements
% (must be in Hardware units)
AD.DeltaRFDisp = 1000e-6;
AD.DeltaRFChro = [-2000 -1000 0 1000 2000] * 1e-6;


% Tune processor delay: delay required to wait to have a fresh tune  
% measurement after changing a variable like the RF frequency.
AD.TuneDelay = 0.0;


% SP-AM Error level
% AD.ErrorWarningLevel = 0 -> SP-AM errors are Matlab errors {Default}
%                       -1 -> SP-AM errors are Matlab warnings
%                       -2 -> SP-AM errors prompt a dialog box
%                       -3 -> SP-AM errors are ignored (ErrorFlag=-1 is returned)
AD.ErrorWarningLevel = 0;

setad(AD);

%%%%%%%%%%%%%%%%%%%%%
% Operational Modes %
%%%%%%%%%%%%%%%%%%%%%

% Mode setup variables (mostly path and file names)
% AD.OperationalMode - String used in titles
% MachineName - String used to build directory structure off DataRoot
% ModeName - String used for mode directory name off DataRoot/MachineName
% OpsFileExtension - string add to default file names

switch ModeNumber
    case 1
        % User mode
        AD.OperationalMode = '3.0 GeV';
        ModeName = 'User';
        OpsFileExtension = '';

        % AT lattice
        %AD.ATModel = 'NSLS2lattice';
        %NSLS2lattice;
        %nsls2_tracy_aug2007
        AD.ATModel = 'nsls2_tracy_june2008';
        nsls2_tracy_june2008

        % Golden TUNE
        AO = getao;
        AO.TUNE.Golden = [
            0.360
            0.280
            NaN];
        setao(AO);

        % Golden chromaticity is in the AD (must be in Physics units!)
        AD.Chromaticity.Golden = [1.0; 1.0];
    otherwise
        error('Unknown operational mode ');
end

% Using physics units for now. Use hardware units 
% once the amp2k, k2amp are working.
switch2physics;
%switch2hw;

switch2sim;

% Set the AD directory path
setad(AD);
MMLROOT = setmmldirectories(AD.Machine, AD.SubMachine, ModeName, OpsFileExtension);
AD = getad;


% Circumference
AD.Circumference = findspos(THERING,length(THERING)+1);


% Updates the AT indices in the MiddleLayer with the present AT lattice
updateatindex;


% Set the model energy
setenergymodel(AD.Energy);


% Cavity and radiation
setcavity off;  
setradiation off;
fprintf('   Radiation and cavities are off. Use setradiation / setcavity to modify.\n'); 


% Momentum compaction factor
MCF = getmcf('Model');
if isnan(MCF)
    AD.MCF = 0.000363;
    fprintf('   Model alpha calculation failed, middlelayer alpha set to  %f\n', AD.MCF);
else
    AD.MCF = MCF;
    fprintf('   Middlelayer alpha set to %f (AT model).\n', AD.MCF);
end
setad(AD);




fprintf('   Middlelayer setup for operational mode: %s\n', AD.OperationalMode);

