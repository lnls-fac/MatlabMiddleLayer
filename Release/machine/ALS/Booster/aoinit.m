function aoinit(SubMachineName)
%AOINIT - Initialization function for the Matlab Middle Layer (MML)


% The path should not be modified in standalone mode
if ~isdeployed

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


    % Include the MML paths for the storage rings as well
    %addpath(fullfile(MMLROOT, 'mml', 'storagering'),'-begin');


    % ALS FAD
    addpath(fullfile(MMLROOT, 'machine', 'ALS', 'StorageRing', 'FAD'),'-begin');
    
    
    % Put the BTS directory there as well
    addpath(fullfile(MMLROOT, 'machine', 'ALS', 'BTS'),'-begin');

    
    % Put the storage ring directory there as well
    addpath(fullfile(MMLROOT, 'machine', 'ALS', 'StorageRing', 'LegacyFiles'),'-begin');
    addpath(fullfile(MMLROOT, 'machine', 'ALS', 'StorageRing'),'-begin');


    % Make sure mml is high on the path
    %addpath(fullfile(MMLROOT, 'mml', 'transport'),'-begin');
    addpath(fullfile(MMLROOT, 'mml'),'-begin');

    
    % Make ALS/Booster first
    addpath(fullfile(MMLROOT, 'machine', 'ALS', 'Booster'),'-begin');

 end
 
 boosterinit;

