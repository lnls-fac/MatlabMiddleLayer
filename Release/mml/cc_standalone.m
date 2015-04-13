function cc_standalone(ApplicationName)
%CC_STANDALONE - Compile a standalone MML/AT application 


if nargin == 0
    ApplicationName = 'plotfamily';
end

fprintf('   Compiling:  %s\n', ApplicationName);

% Add files in StorageRing (*.txt), AT, MML (wave files)
eval(['mcc -mv -a Tada.wav -a Chord.wav -a UtopiaQuestion.wav -a UtopiaError.wav -a rampmastup.txt -a rampmastdown.txt -a beamisoff.txt -a SOFBwarningmessageHCM.txt -a SOFBwarningmessageVCM.txt -a SOFBstoppedmessage.txt -a SOFBstaleRFmessage.txt -a AperturePass -a BndMPoleSymplectic4Pass -a BndMPoleSymplectic4RadPass -a CavityPass -a CorrectorPass -a DriftPass -a EAperturePass -a IdentityPass -a Matrix66Pass -a QuadLinearPass -a SolenoidLinearPass -a StrMPoleSymplectic4Pass -a StrMPoleSymplectic4RadPass -a ThinMPolePass -a findmpoleraddiffmatrix ',ApplicationName]);

eval(['delete ',ApplicationName,'_main.c']);
eval(['delete ',ApplicationName,'_mcc_component_data.c']);
%eval('delete mccExcludedFiles.log');


fprintf('\n   %s compile complete.\n\n\n\n\n', ApplicationName);



% Add files in AT directories
%eval(['mcc -mv -a AperturePass -a BndMPoleSymplectic4Pass -a BndMPoleSymplectic4RadPass -a CavityPass -a CorrectorPass -a DriftPass -a EAperturePass -a IdentityPass -a Matrix66Pass -a QuadLinearPass -a SolenoidLinearPass -a StrMPoleSymplectic4Pass -a StrMPoleSymplectic4RadPass -a ThinMPolePass -a findmpoleraddiffmatrix ',ApplicationName]);


% % Make sure labca is above sca
% [DirectoryName, FileName, ExtentionName] = fileparts(which('getpvonline'));
% if findstr('sca', DirectoryName)
%     fprintf('\n   Switching to LabCA since the compiled version seems to have trouble in SCAIII\n\n');
%     setpathals labca
% end



% switch computer
% 
% case 'SOL2'
%    %PLATFORMOPTION = ['LDFLAGS=''-shared -W1,-M/home/als/alsbase/matlab_runtime/compile/mexFunctionSOL2.map''',' '];
%     PLATFORMOPTION = ['LDFLAGS=''-shared -M/home/als/alsbase/matlab_runtime/compile/mexFunctionSOL2.map''',' '];
% 
% case 'GLNX86'
% 
%     PLATFORMOPTION = ['LDFLAGS=''-pthread -shared -m32 -Wl,--version-script,/home/als/alsbase/matlab_runtime/compile/mexFunctionGLNX86.map''',' '];
%     
% end
% 
% 
% %eval(['mcc -mv /home/als/alsbase/matlab_runtime/compile/mexFunctionSOL2.map -a AperturePass -a BndMPoleSymplectic4Pass -a BndMPoleSymplectic4RadPass -a CavityPass -a CorrectorPass -a DriftPass -a EAperturePass -a IdentityPass -a Matrix66Pass -a QuadLinearPass -a SolenoidLinearPass -a StrMPoleSymplectic4Pass -a StrMPoleSymplectic4RadPass -a ThinMPolePass -a findmpoleraddiffmatrix ',ApplicationName]);
% 
% eval(['mcc -mv LDFLAGS=''-shared -M/home/als/alsbase/matlab_runtime/compile/mexFunctionSOL2.map'' -a AperturePass -a BndMPoleSymplectic4Pass -a BndMPoleSymplectic4RadPass -a CavityPass -a CorrectorPass -a DriftPass -a EAperturePass -a IdentityPass -a Matrix66Pass -a QuadLinearPass -a SolenoidLinearPass -a StrMPoleSymplectic4Pass -a StrMPoleSymplectic4RadPass -a ThinMPolePass -a findmpoleraddiffmatrix ',ApplicationName]);




% To compile stand alone with graphics
%mcc -mv -B sgl plotfamily

% To compile stand alone with graphics, online only (no AT funcitons)
%mcc -mv -B sgl -I /home/als/alsbase/matlab_runtime/compile/ModelOffFunctions plotfamily
