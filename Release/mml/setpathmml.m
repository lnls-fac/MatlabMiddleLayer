function [MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathmml(varargin)
%SETPATHMML -  Initialize the Matlab MiddleLayer (MML) path
%  [MachineName, SubMachineName, OnlineLinkMethod, MMLROOT]  = setpathmml(MachineName, SubMachineName, MachineType, OnlineLinkMethod, MMLROOT)
%
%  INPUTS
%  1. MachineName -
%  2. SubMachineName -
%  3. MachineType - 'StorageRing' {Default}, 'Booster', 'Linac', or 'Transport'
%  4. OnlineLinkMethod - 'LabCA', 'SCA', 'MCA', 'Tango', 'SLC', 'UCODE', ... {Default: 'LabCA'}
%  5. MMLROOT - Directory path to the MML root directory

%  Written by Greg Portmann
%  Updated by Igor Pinayev


% Inputs:  MachineName, SubMachineName, MachineType, LinkFlag, MMLROOT


% First strip-out the link method
LinkFlag = '';
for i = length(varargin):-1:1
    if ~ischar(varargin{i})
        % Ignor input
    elseif strcmpi(varargin{i},'LabCA')
        LinkFlag = 'LabCA';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'MCA')
        LinkFlag = 'MCA';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'SCA')
        LinkFlag = 'SCA';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'TLS_CTL')
        LinkFlag = 'TLS_CTL';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'OPC')
        LinkFlag = 'OPC';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'SLC')
        LinkFlag = 'SLC';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Tango')
        LinkFlag = 'Tango';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'lnls1_link')
        LinkFlag = 'lnls1_link';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'sirius_link')
        LinkFlag = 'sirius_link';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'UCODE')
        LinkFlag = 'UCODE';
        varargin(i) = [];
    end
end


% Get the machine name
if length(varargin) >= 1
    MachineName = varargin{1};
else
    MachineName = '';
end

if isempty(MachineName)
    [MachineListCell, SubMachineListCell] = getmachinelist;
    [i, iok] = listdlg('Name','SETPATHMML', 'ListString',MachineListCell, 'Name','MML Init', 'PromptString',{'Select a facility:'}, 'SelectionMode','Single');
    %[MachineNameCell, i] = editlist(MachineListCell,'',zeros(size(MachineListCell,1),1));
    drawnow;
    if iok
        MachineName = MachineListCell{i};
    else
        fprintf('   No path change.\n');
        MachineName=''; SubMachineName=''; LinkFlag=''; MMLROOT='';
        return;
    end
else
    SubMachineListCell = {};
end


% Get the submachine name
if length(varargin) >= 2
    SubMachineName = varargin{2};
else
    SubMachineName = '';
end
if isempty(SubMachineName)
    if isempty(SubMachineListCell)
        [MachineListCell, SubMachineListCell] = getmachinelist;
    end
    i = strmatch(MachineName, MachineListCell, 'exact');
    SubMachineListCell = SubMachineListCell{i}(:);
    
    if length(SubMachineListCell) == 1
        SubMachineName = SubMachineListCell{1};
    else
        [i, iok] = listdlg('Name','SETPATHMML', 'ListString',SubMachineListCell, 'Name','MML Init', 'PromptString',{'Select an accelerator:'}, 'SelectionMode','Single');
        drawnow;
        if iok
            SubMachineName = SubMachineListCell{i};
        else
            fprintf('   No path change.\n');
            MachineName=''; SubMachineName=''; LinkFlag=''; MMLROOT='';
            return;
        end
    end
end


% Find the machine type
if length(varargin) >= 3
    MachineType = varargin{3};
else
    MachineType = '';
end
if isempty(MachineType)
    switch upper(SubMachineName)
        case {'LTB', 'LB', 'BTS', 'BS', 'LT1', 'LT2', 'INJECTOR', 'LINAC', 'GUN', 'PTB'}
            MachineType = 'Transport';
        case {'BOOSTER', 'BOOSTER RING', 'BR'}
            MachineType = 'Booster';
        case {'SR', 'STORAGERING', 'STORAGE RING', 'HER', 'LER', '800MEV'}
            MachineType = 'StorageRing';
        otherwise
            MachineType = 'StorageRing';
    end
end


%if all(strcmpi(MachineType, {'StorageRing','Booster','Linac','Transport'}) == 0)
%    error('MachineType must be storagering, booster, linac, or transport.');
%end

MatlabVersion = ver('Matlab');
MatlabVersion = str2num(MatlabVersion.Version);

% LinkFlag if empty
if isempty(LinkFlag)
    switch upper(MachineName)
        case 'ALS'
            if strncmp(computer,'PC',2)
                LinkFlag = 'LABCA';
                %LinkFlag = 'MCA';
            elseif isunix
                if strncmp(computer,'GLNX',4) || MatlabVersion >= 7.4
                    LinkFlag = 'LABCA';
                    %LinkFlag = 'SCA';
                else
                    % Solaris 2006b or eariler
                    %LinkFlag = 'LABCA';
                    LinkFlag = 'SCA';
                end
            else
                LinkFlag = 'LABCA';
            end
        case {'ASP','TPS','SPEAR','SPEAR3','SSRF', 'SESAME'}
            LinkFlag = 'LABCA';
        case {''}
            LinkFlag = 'LABCA';
        case {'PLS'}
            LinkFlag = 'MCA';
        case 'TLS'
            LinkFlag = 'TLS_CTL';
        case 'BFACTORY'
            LinkFlag = 'SLC';
        case 'LCLS'
            LinkFlag = 'LABCA';
        case 'LNLS1'
            LinkFlag = 'lnls1_link';
        case 'SIRIUS'
            LinkFlag = 'sirius_link';
        case {'NSRC','SPS'}
            LinkFlag = 'OPC';
        case {'VUV','XRAY'}
            LinkFlag = 'UCODE';
        case {'ALBA','SOLEIL', 'ELETTRA'}
            LinkFlag = 'Tango';
        otherwise
            % Other
            LinkFlag = 'LABCA';
            %if strncmp(computer,'PC',2)
            %    LinkFlag = 'LABCA';
            %elseif isunix
            %    LinkFlag = 'LABCA';
            %else
            %    LinkFlag = 'LABCA';
            %end
    end
end


% Find the MML root directory
if length(varargin) >= 4
    MMLROOT = varargin{4};
else
    MMLROOT = '';
end
if isempty(MMLROOT)
    MMLROOT = getmmlroot('IgnoreTheAD');
end


% The path does not needs to be set in Standalone mode
if ~isdeployed_local
    
    % Jeff's orbit GUI
    if any(strcmpi(MachineName,{'Spear3','cls','diamond','asp','alba','camd'}))
        %addpath(fullfile(MMLROOT, 'applications', 'orbit'), '-begin');
        addpath(fullfile(MMLROOT, 'applications', 'orbit', 'lib'), '-begin');
        addpath(fullfile(MMLROOT, 'applications', 'orbit', lower(MachineName)), '-begin');
    end
    
    
    % LNLS general scripts (files not distributed with MML)
    Directory = fullfile(MMLROOT, 'applications', 'lnls');
    if exist(Directory, 'dir')
        addpath(genpath(fullfile(MMLROOT, 'applications', 'lnls')), '-begin');
    end
    
    
    % N A F F (files not distributed with MML)
    Directory = fullfile(MMLROOT, 'applications', 'naff');
    if exist(Directory, 'dir')
        addpath(fullfile(MMLROOT, 'applications', 'naff'), '-begin');
        addpath(fullfile(MMLROOT, 'applications', 'naff', 'naffutils'), '-begin');
        addpath(fullfile(MMLROOT, 'applications', 'naff', 'naffutils', 'touscheklifetime'), '-begin');
        addpath(fullfile(MMLROOT, 'applications', 'naff', 'nafflib'), '-begin');
    end
    
    % m2html generation program
    addpath(fullfile(MMLROOT, 'applications', 'm2html'), '-end');

    % MySQL
    %addpath(fullfile(MMLROOT, 'applications', 'database', 'mysql'), '-end');
    addpath(fullfile(MMLROOT, 'applications', 'database', 'mym'), '-end');

    % XML
    addpath(fullfile(MMLROOT, 'applications', 'xml', 'geodise'), '-end');
    %addpath(fullfile(MMLROOT, 'applications', 'xml', 'xmltree'), '-end');

    if strcmpi(LinkFlag,'LABCA')
        % EPICS uses might want to use the EDM conversion functions
        addpath(fullfile(MMLROOT, 'applications', 'EDM'), '-begin');
    end
    
    % AT root
    setpathat(fullfile(MMLROOT,'at'));

    % Connection MML to simulator
    addpath(fullfile(MMLROOT, 'mml', 'at'), '-begin');

    % LOCO
    addpath(fullfile(MMLROOT, 'applications', 'loco'), '-begin');

    % Link method
    switch upper(LinkFlag)
        case 'MCA'
            % R3.14.4 and Andrei's MCA
            fprintf('   Appending MATLAB path control using MCA and EPICS R3.13.4\n');
            addpath(fullfile(MMLROOT, 'links', 'mca'),'-begin');
            addpath(fullfile(MMLROOT, 'mml', 'links', 'mca'), '-begin');

        case 'MCA_ASP'
            % R3.14.4 and Australian MCA
            fprintf('   Appending MATLAB path control using MCA (Australian)\n');
            addpath(fullfile(MMLROOT, 'links', 'mca_asp'),'-begin');
            addpath(fullfile(MMLROOT, 'mml', 'links', 'mca_asp'), '-begin');
            
        case 'LABCA'
            fprintf('   Appending MATLAB path control using LabCA \n');
            switch computer
                case 'PCWIN'
                    addpath(fullfile(MMLROOT,'links','labca', 'bin','win32-x86','labca'), '-begin');
                    %addpath(fullfile(MMLROOT,'links','labca', 'bin','win32-x86_3_0','labca'), '-begin');
                case 'SOL2'
                    addpath(fullfile(MMLROOT,'links','labca', 'bin','solaris-sparc','labca'), '-begin');
                case 'SOL64'
                    addpath(fullfile(MMLROOT,'links','labca', 'bin','solaris-sparc64','labca'), '-begin');
                case 'GLNX86'
                    addpath(fullfile(MMLROOT,'links','labca', 'bin','linux-x86','labca'), '-begin');
                case 'GLNXA64'
                    addpath(fullfile(MMLROOT,'links','labca', 'bin','linux-x86_64','labca'), '-begin');
                otherwise
                    fprintf('Computer not recognized for LabCA path.\n');
            end

            addpath(fullfile(MMLROOT,'mml', 'links', 'labca'), '-begin');

        case 'SCA'
            fprintf('   Appending MATLAB path control using Simple-CA Version 3\n');
            switch computer
                case 'PCWIN'
                    fprintf('\n   WARNING:  SCAIII is not working with PC''s yet\n\n');
                    addpath(fullfile(MMLROOT,'links','sca', 'bin','win32-x86','sca'), '-begin');
                case 'SOL2'
                    addpath(fullfile(MMLROOT,'links','sca', 'bin','solaris-sparc','sca'), '-begin');
                case 'SOL64'
                    addpath(fullfile(MMLROOT,'links','sca', 'bin','solaris-sparc64','sca'), '-begin');
                case 'GLNX86'
                    addpath(fullfile(MMLROOT,'links','sca', 'bin','linux-x86','sca'), '-begin');
                case 'GLNXA64'
                    addpath(fullfile(MMLROOT,'links','sca', 'bin','linux-x86_64','sca'), '-begin');
                otherwise
                    fprintf('Computer not recognized for SCA path.\n');
            end
            addpath(fullfile(MMLROOT, 'mml', 'links', 'sca'), '-begin');

        case 'TANGO'

            fprintf('   Appending MATLAB path control using Tango\n');
            addpath(fullfile(MMLROOT,'links','tango'), '-begin');
            addpath(fullfile(MMLROOT, 'mml', 'links', 'tango'), '-begin');

        case 'TLS_CTL'

            fprintf('   Appending MATLAB path for TLS control\n');
            %addpath(fullfile(MMLROOT,'links','tls_ctl'), '-begin');
            addpath(fullfile(MMLROOT, 'mml', 'links', 'tls_ctl'), '-begin');
        
        case 'UCODE'
            fprintf('   Appending MATLAB path control using UCODE \n');
            %addpath(fullfile(MMLROOT,'links','ucode'), '-begin');
            addpath(fullfile(MMLROOT,'mml','links','ucode'), '-begin');

        case 'SLC'
            fprintf('   Appending MATLAB path for SLC control \n');
            addpath(fullfile(MMLROOT,'links','slc'), '-begin');
            addpath(fullfile(MMLROOT,'mml', 'links', 'slc'), '-begin');

        case 'LNLS1_LINK'
            fprintf('   Appending MATLAB path for lnls1_link control \n');
            addpath(fullfile(MMLROOT,'links','lnls_link','lnls1_link'), '-begin');
            addpath(fullfile(MMLROOT,'mml', 'links', 'lnls_link','lnls1_link'), '-begin');
            
         case 'SIRIUS_LINK'
            fprintf('   Appending MATLAB path for sirius_link control \n');
            addpath(fullfile(MMLROOT,'links','lnls_link','sirius_link'), '-begin');
            addpath(fullfile(MMLROOT,'mml', 'links', 'lnls_link','sirius_link'), '-begin');

        case 'OPC'
            fprintf('   Appending MATLAB path for OPC control \n');
            addpath(fullfile(MMLROOT,'links','opc'), '-begin');
            addpath(fullfile(MMLROOT,'mml', 'links', 'opc'), '-begin');

        otherwise
            fprintf('   Unknown type for the Online connection method.  Only simulator mode will work.\n');
    end


    % Common files
    addpath(fullfile(MMLROOT, 'applications', 'common'), '-begin');

    % MML path
    addpath(fullfile(MMLROOT, 'mml'), '-begin');

    % LNLS updated version of MML and AT files
    %Directory = fullfile(MMLROOT, 'lnls', 'at-mml_modified_scripts');
    %if exist(Directory, 'dir')
    %    addpath(Directory, '-begin');
    %end
    
    % Machine directory
    if ~isempty(MachineName) && ~isempty(SubMachineName)
        % Sometimes there is a common directory that all submachines share
        Directory = fullfile(MMLROOT, 'machine', MachineName, 'common');
        if exist(Directory, 'dir')
            addpath(Directory, '-begin');
        end
        Directory = fullfile(MMLROOT, 'machine', MachineName, 'Common');
        if exist(Directory, 'dir')
            addpath(Directory, '-begin');
        end
        
        % New MML path
        addpath(fullfile(MMLROOT, 'machine', MachineName, SubMachineName), '-begin');
    end
   
end


% Start the AD with machine and submachine
setad([]);
AD.Machine = MachineName;
AD.SubMachine = SubMachineName;
AD.MachineType = MachineType;
AD.OperationalMode = '';    % Gets filled in later
setad(AD);


% Initialize the AO & AD
aoinit(SubMachineName);


function RunTimeFlag = isdeployed_local
% isdeployed is not in matlab 6.5
V = version;
if str2num(V(1,1)) < 7
    RunTimeFlag = 0;
else
    RunTimeFlag = isdeployed;
end
