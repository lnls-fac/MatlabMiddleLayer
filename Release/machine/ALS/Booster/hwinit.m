function hwinit(varargin)
%HWINIT - Hardware initialization script for the Booster


DisplayFlag = 1;
for i = length(varargin):-1:1
    if strcmpi(varargin{i},'Display')
        DisplayFlag = 1;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'NoDisplay')
        DisplayFlag = 0;
        varargin(i) = [];
    end
end


fprintf('   Initializing Booster parameters (hwinit)\n')



% Set all UDF fields
% if islabca
%     fprintf('   1. UDF fields not set!!! \n');
%     fprintf('      sca or MCA must be used to set the .UDF field. \n');
%     fprintf('      >> setpathals sca\n');
%     fprintf('      to change.\n');
% else
    try
        fprintf('   1. Setting the UDF fields for all families to 0 ... ');
        resetudferrors;
        fprintf('Done\n');
    catch
        fprintf('\n   Error setting the UDF for all families\n');
    end
% end


% Set corrector magnets
try
    fprintf('   2. Setting Booster magnets HCM, VCM, QF, QD, SF, SD, and BEND to a 10 Hz scan rate on the monitors ... ');
    setpv(family2channel('HCM',  'Monitor'), 'SCAN', 9);
    setpv(family2channel('VCM',  'Monitor'), 'SCAN', 9);
    setpv(family2channel('QF',   'Monitor'), 'SCAN', 9);
    setpv(family2channel('QD',   'Monitor'), 'SCAN', 9);
    setpv(family2channel('SF',   'Monitor'), 'SCAN', 9);
    setpv(family2channel('SD',   'Monitor'), 'SCAN', 9);
    setpv(family2channel('BEND', 'Monitor'), 'SCAN', 9);
    fprintf('Done\n');
catch
    fprintf('\n   Error setting .SCAN field of BTS corrector magnets HCM and VCM.\n');
end


% Set BPMs
try
    fprintf('   3. Setting Booster BPMs to a 10 Hz scan rate ... ');
    setpv(family2channel('BPMx'),'SCAN', 9);
    setpv(family2channel('BPMy'),'SCAN', 9);
    fprintf('Done\n');
catch
    fprintf('\n   Error setting .SCAN field of BTS BPMs.\n');
end


% % Set SF & SD on
% try
%     fprintf('   4. Turning SF & SD on (if necessary) ... ');
%     OnFlag = getpv('SF', 'On');
%     if any(OnFlag==0)
%         setpv('SF', 'EnableRamp', 0);  % Disable the ramp before turning on or it could glitch
%         pause(1);
%         setpv('SF', 'Setpoint',  0);
%         setpv('SF', 'OnControl', 1);
%     end
%     OnFlag = getpv('SD', 'On');
%     if any(OnFlag==0)
%         setpv('SD', 'EnableRamp', 0);  % Disable the ramp before turning on or it could glitch
%         pause(1);
%         setpv('SD', 'Setpoint',  0);
%         setpv('SD', 'OnControl', 1);
%     end
%     fprintf('Done\n');
% catch
%     fprintf('\n   Error: trouble turning on SF or SD.\n');
% end


% % Set SF, SD, & RF ramp tables
% try
%     fprintf('   5. Loading the booster SF ramp tables ... ');
%     setboosterrampsf;
%     fprintf('Done\n');
% catch
%     fprintf('\n   Error setting the booster SD ramp table.\n');
% end
% try
%     fprintf('   6. Loading the booster SD ramp tables ... ');
%     setboosterrampsd;
%     fprintf('Done\n');
% catch
%     fprintf('\n   Error setting the booster SF ramp table.\n');
% end
% 

% try
%     fprintf('   7. Loading the booster RF ramp tables ... ');
%     setboosterramprf;
%     fprintf('Done\n');
% catch
%     fprintf('\n   Error setting the booster RF ramp table.\n');
% end


% % UDF
% try
%     fprintf('   8. Setting the UDF fields for all families to 0 ... ');
%     resetudferrors;
%     fprintf('Done\n');
% catch
%     fprintf('\n   Error setting the UDF for all families.\n');
% end


fprintf('\n');


