function setpathat(ROOTDir)
%SETPATHAT - Sets the AT Toolbox path
%  setpathat

if nargin == 0
    if isempty(getenv('ATROOT'))
        [DirectoryName, FileName, ExtentionName] = fileparts(which('getsp'));
        i = findstr(DirectoryName,filesep);
        ROOTDir = [DirectoryName(1:i(end)), 'at'];
        
        if ~isdir(ROOTDir)
            warning('   AT path has not been set.');
            return;
        end
    else
        ROOTDir = getenv('ATROOT');
    end
end


olddir = pwd;
cd(ROOTDir);
atpath(ROOTDir);
cd(olddir);

    
% if nargin == 0
%     [DirectoryName, FileName, ExtentionName] = fileparts(which('getsp'));
%     i = findstr(DirectoryName,filesep);
%     if isempty(i)
%         ROOTDir = DirectoryName; 
%     else
%         ROOTDir = DirectoryName(1:i(end)); 
%     end
% end
% 
% addpath(fullfile(ROOTDir,'at','atdemos'),'-begin');
% addpath(fullfile(ROOTDir,'at','atphysics'),'-begin');
% addpath(fullfile(ROOTDir,'at','atgui'),'-begin');
% addpath(fullfile(ROOTDir,'at','simulator','element'),'-begin');
% addpath(fullfile(ROOTDir,'at','simulator','track'),'-begin');
% addpath(fullfile(ROOTDir,'at','lattice'),'-begin');
% addpath(fullfile(ROOTDir,'at','dev'),'-begin');
