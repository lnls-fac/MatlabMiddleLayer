function setoperationalmode(ModeNumber)
%SETOPERATIONALMODE - Switches between the various operational modes
%  setoperationalmode(ModeNumber)
%
%  ModeNumber = 1. 1.37 GeV, User Mode {Default}
%               2. 1.37 GeV, Model


global THERING


% Check if the AO exists
checkforao;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Accelerator Dependent Modes %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin < 1
    ModeCell = {'0.5 GeV Top Energy Mode', '0.5 GeV, Model'};
    [ModeNumber, OKFlag] = listdlg('Name','LNLS1','PromptString','Select the Operational Mode:', 'SelectionMode','single', 'ListString', ModeCell);
    if OKFlag ~= 1
        fprintf('   Operational mode not changed\n');
        return
    end
    if ModeNumber == 2
        ModeNumber = 2;  % Model
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Accelerator Data Structure %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
AD = getad;
AD.Machine = 'LNLS1';            % Will already be defined if setpathmml was used
AD.SubMachine = 'Booster';  % Will already be defined if setpathmml was used
AD.OperationalMode = '';        % Gets filled in later
AD.Energy = 0.5;
AD.InjectionEnergy = 0.1;
AD.HarmonicNumber = 54;

% LNLS1Params
AD.LNLS1Params = lnls1_params;




% Defaults RF for disperion and chromaticity measurements (must be in Hardware units)
AD.DeltaRFDisp = 2000e-6;
AD.DeltaRFChro = [-2000 -1000 0 1000 2000] * 1e-6;


% Tune processor delay: delay required to wait
% to have a fresh tune measurement after changing
% a variable like the RF frequency.
AD.TuneDelay = 3.0;  


%%%%%%%%%%%%%%%%%%%%%
% Operational Modes %
%%%%%%%%%%%%%%%%%%%%%

% Mode setup variables (mostly path and file names)
% AD.OperationalMode - String used in titles
% ModeName - string used for mode directory name off DataRoot/MachineName
% OpsFileExtension - string add to default file names
if ModeNumber == 1
    % User mode - High Tune
    AD.OperationalMode = '0.5 GeV, top-energy-mode';
    ModeName = 'top-energy-mode';
    OpsFileExtension = '';

    % AT lattice
    AD.ATModel = 'lnls1_lattice';
    lnls1_lattice;

    % Golden TUNE is with the TUNE family
    AO = getao;
    AO.TUNE.Monitor.Golden = [
        0.27
        0.17
        NaN];
    setao(AO);

    % Golden chromaticity is in the AD (Physics units)
    AD.Chromaticity.Golden = [1; 1];

    % This is a bit of a cluge to know if the user is on the MLS filer
    % If so, then the MML user probably wants to be online
    MMLROOT = getmmlroot;
    if isempty(findstr(lower(MMLROOT),'SomeDirectoryAtMLS'))
        switch2sim;
    else
        switch2online;
        
        % Change defaults for LabCA if using it
        try
            if exist('lcaSetSeverityWarnLevel','file')
                % Retry count
                RetryCountNew = 200;  % 599-old labca, 149-labca_2_1_beta
                RetryCount = lcaGetRetryCount;
                lcaSetRetryCount(RetryCountNew);
                if RetryCount ~= RetryCountNew
                    fprintf('   Setting LabCA retry count to %d (was %d) (LabCA)\n', RetryCountNew, RetryCount);
                end

                % Timeout
                Timeout = lcaGetTimeout;
                TimeoutNew = .1;  % was .005  Default: .05-old labca, .1-labca_2_1_beta
                lcaSetTimeout(TimeoutNew);
                if abs(Timeout - TimeoutNew) > 1e-5
                    fprintf('   Setting LabCA TimeOut to %f (was %f) (LabCA)\n', TimeoutNew, Timeout);
                end
                %fprintf('   LabCA TimeOut = %f\n', Timeout);

                % To avoid UDF errors, set the WarnLevel to 4 (Default is 3)
                lcaSetSeverityWarnLevel(4);
                fprintf('   Setting lcaSetSeverityWarnLevel to 4 to avoid annoying UDF errors (LabCA).\n');
            end
        catch
            fprintf('   Error setting lcaSetSeverityWarnLevel (LabCA).\n');
        end
    end
    
    switch2hw;

elseif ModeNumber == 2
    % Model mode
    AD.OperationalMode = '0.1 GeV, Model';
    ModeName = 'Model';
    OpsFileExtension = '_Model';

    % AT lattice
    AD.ATModel = 'lnls1_lattice';
    lnls1_lattice;

    % Golden TUNE is with the TUNE family
    AO = getao;
    AO.TUNE.Monitor.Golden = [
        0.269979
        0.168541
        NaN];
    setao(AO);

    % Golden chromaticity is in the AD (Physics units)
    AD.Chromaticity.Golden = [1; 1];

    AD.TuneDelay = 0.0;
    switch2hw;
    switch2sim;

else
    error('Operational mode unknown');
end


% Set the AD directory path
setad(AD);
setmmldirectories(AD.Machine, AD.SubMachine, ModeName, OpsFileExtension);
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
    AD.MCF = 0.008309130984159;
    fprintf('   Model alpha calculation failed, middlelayer alpha set to  %f\n', AD.MCF);
else
    AD.MCF = MCF;
    fprintf('   Middlelayer alpha set to %f (AT model).\n', AD.MCF);
end
setad(AD);


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

