function [reltunes_setpoint, tunes] = fcexpscript_respmsweeptune

deltarf = 1e-3; % MHz
reltunes = linspace(0.98,1.02,7)';
tunematrixfile = 'TuneRespMat_online_2010-06-19_21-47-43.mat';

reltunes1 = ones(length(reltunes),1);
reltunes_setpoint = [reltunes reltunes1; reltunes1 reltunes];

switch2online;

% Store initial betatron tunes
tunes0 = gettune;
tunes = zeros(size(reltunes_setpoint,1), 2);

tunematrix = gettuneresp('FileName', fullfile('C:\Arq\fac_files\code\MatlabMiddleLayer\Release\machine\LNLS1\StorageRingData\User\Response\Tune', tunematrixfile));

lnls1_fast_orbcorr_enable_excitation;

for i=1:length(reltunes_setpoint)
    % Betatron tunes adjustment
    for j=1:5
        settune(tunes0.*(reltunes_setpoint(i,:)'),0,tunematrix);
        pause(0.2);
    end

    % Store measured betatron tunes
    tunes(i,:) = gettune;

    % Response matrix measurement
    uvxcorrectorbit;
    fcexprespmsin(100+i);
    fcwaitbuffer;

    % Response matrix measurement using the sine method
    uvxcorrectorbit;
    fcexprespm(200+i);
    fcwaitbuffer;
    
    % Dispersion orbit measurement (steps on RF frequency)
    uvxcorrectorbit;
    fcexpmarker(300+i);
    uvxrfresp;
    fcexpmarker(400+i);
end

% Restore original betatron tunes
for j=1:5
    settune(tunes0,0,tunematrix);
    pause(0.2);
end

lnls1_fast_orbcorr_disable_excitation;
