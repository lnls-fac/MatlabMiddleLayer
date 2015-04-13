function aoinit(SubMachineName)
%AOINIT - Initialization function for the Matlab Middle Layer (MML)


% Just for debug
%system('path')


% The path should not be modified in standalone mode
if ~isdeployed_local
    
    % Regular Matlab Session
    MMLROOT = getmmlroot('IgnoreTheAD');

    % Add users directories
    %CommonDirectory = fullfile(MMLROOT,'users','portmann','commands');
    %if exist(CommonDirectory) == 7
    %    addpath(CommonDirectory, '-begin');
    %end
    %CommonDirectory = fullfile(MMLROOT,'users','chris','commands');
    %if exist(CommonDirectory) == 7
    %    addpath(CommonDirectory, '-begin');
    %end
    
    % Add ALS/BTS
    %addpath(fullfile(MMLROOT, 'machine', 'ALS', 'BTS'),'-begin');


    % Add ALS/Booster
    %addpath(fullfile(MMLROOT, 'machine', 'ALS', 'Booster'),'-begin');

    % LFB
    addpath(fullfile(MMLROOT, 'machine', 'ALS', 'StorageRing', 'LFB', 'iGpTools'),'-begin');
    
    % ALS FAD
    addpath(fullfile(MMLROOT, 'machine', 'ALS', 'StorageRing', 'FAD'),'-begin');

    % Add LegacyFiles then put ALS first on the path
    addpath(fullfile(MMLROOT, 'machine', 'ALS', 'StorageRing', 'LegacyFiles'),'-begin');
    addpath(fullfile(MMLROOT, 'machine', 'ALS', 'StorageRing'),'-begin');
end


% Initialize the MML
alsinit;



function RunTimeFlag = isdeployed_local
% isdeployed is not in matlab 6.5
V = version;
if str2num(V(1,1)) < 7
    RunTimeFlag = 0;
else
    RunTimeFlag = isdeployed;
end

