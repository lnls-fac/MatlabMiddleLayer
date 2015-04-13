function aoinit(SubMachineName)
%AOINIT - Initialization function for the Matlab Middle Layer (MML)

% LNLS updated version of MML and AT files
MMLROOT = getmmlroot('IgnoreTheAD');
Directory = fullfile(MMLROOT, 'lnls', 'at-mml_modified_scripts');
if exist(Directory, 'dir')
    addpath(Directory, '-begin');
end
    

OperationalMode = 1;

lnls1_init;
setoperationalmode(OperationalMode);
%lnls1_comm_connect_inputdlg;

