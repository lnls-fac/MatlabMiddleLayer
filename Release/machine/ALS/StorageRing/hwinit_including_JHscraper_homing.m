function hwinit(varargin)
%HWINIT - This function initializes the storage ring parameters the user operation


CMRampRate = 5;
DisplayFlag = 1;


% for i = length(varargin):-1:1
%     if strcmpi(varargin{i},'Display')
%         DisplayFlag = 1;
%         varargin(i) = [];
%     elseif strcmpi(varargin{i},'NoDisplay')
%         DisplayFlag = 0;
%         varargin(i) = [];
%     end
% end


fprintf('   Initializing storage ring parameters (srinit)\n')


% Set the BPM averaging/timeconstant
try
    BPMFreshDataSamplingPeriod = .5;  % seconds
    fprintf('   1. BPM averaging/timeconstant set for fresh data every %.2f seconds ... ', BPMFreshDataSamplingPeriod);
    setbpmaverages(BPMFreshDataSamplingPeriod);
    fprintf('Done\n');
catch
    fprintf('\n      Error setting BPM averaging/timeconstant.\n\n');
end


% FADs off
try
    fprintf('   2. Setting BPM FADs off ... ');
    setfad(0);
    fprintf('Done\n');
catch
    fprintf('\n      Error BPM FADs off.\n\n');
end


% Set corrector magnets to slow mode
try
    fprintf('   3. Setting storage ring corrector magnets HCM and VCM to %.1f amps/sec\n', CMRampRate);
    fprintf('      And time constants to zero ... ');
    setpv('HCM', 'RampRate', CMRampRate, [], 0);
    setpv('VCM', 'RampRate', CMRampRate, [], 0);

    setpv('HCM', 'TimeConstant', 0, [], 0);
    setpv('VCM', 'TimeConstant', 0, [], 0);

    fprintf('Done\n');
catch
    fprintf('\n      Error setting storage ring corrector magnets HCM and VCM ramp rates.\n\n');
end

% Set the chicanes magnet trim coils ramp rate
try
    %fprintf('   4. Chicanes magnet trim coils set to slow mode (1 Amp/Sec) ... ');
    %setpv('SR04U___HCM2___AC20',0);
    %setpv('SR04U___HCM2___AC30',1);
    %setpv('SR04U___VCM2___AC20',0);
    %setpv('SR04U___VCM2___AC30',1);
    %
    %setpv('SR06U___HCM2___AC20',0);
    %setpv('SR06U___HCM2___AC30',1);
    %setpv('SR06U___VCM2___AC20',0);
    %setpv('SR06U___VCM2___AC30',1);
    %
    %setpv('SR11U___HCM2___AC20',0);
    %setpv('SR11U___HCM2___AC30',1);
    %setpv('SR11U___VCM2___AC20',0);
    %setpv('SR11U___VCM2___AC30',1);
    %fprintf('Done\n');

    % This is a temporary solution since orbit feedback does not have a trim channel for these magnets yet 
    fprintf('   4. Chicanes magnet trim coils set to fast mode (1000 Amp/Sec) ... ');
    setpv('SR04U___HCM2___AC20',0);
    setpv('SR04U___HCM2___AC30',1000);
    setpv('SR04U___VCM2___AC20',0);
    setpv('SR04U___VCM2___AC30',1000);
    
    setpv('SR06U___HCM2___AC20',0);
    setpv('SR06U___HCM2___AC30',1000);
    setpv('SR06U___VCM2___AC20',0);
    setpv('SR06U___VCM2___AC30',1000);
    
    setpv('SR11U___HCM2___AC20',0);
    setpv('SR11U___HCM2___AC30',1000);
    setpv('SR11U___VCM2___AC20',0);
    setpv('SR11U___VCM2___AC30',1000);
    fprintf('Done\n');

catch
    fprintf('\n      Error setting chicanes magnet trim coils in to fast mode.\n\n');
end


% Set power supply ramprates and time constants
try
    fprintf('   5. Setting time constant and ramp rates set for BEND, QF, QD, QFA, QDA, SF, SD, and CHICANE magnets ... ');

    setpv('BEND', 'RampRate', 10.5, [1 1], 0);  % Just the normal bend power supply
    setpv('QFA',  'RampRate',  5.9, [], 0);
    setpv('QDA',  'RampRate',  1.0, [], 0);
    setpv('QF',   'RampRate',  1.0, [], 0);
    setpv('QD',   'RampRate',  1.0, [], 0);
    setpv('SF',   'RampRate',  4.3, [], 0);
    setpv('SD',   'RampRate',  3.0, [], 0);
    setpv('HCMCHICANE', 'RampRate', 2.0, [4 1;4 3;6 1], 0);   % [S 2] set as part of the HCM family
    %setpv('VCMCHICANE', 'RampRate', 2.0, [4 1;4 3;6 1], 0);   % no longer a family, use VCM

    setpv('BEND', 'TimeConstant', 0, [], 0);
    setpv('QDA',  'TimeConstant', 0, [], 0);
    setpv('QFA',  'TimeConstant', 0, [], 0);
    setpv('QDA',  'TimeConstant', 0, [], 0);
    setpv('QF',   'TimeConstant', 0, [], 0);
    setpv('QD',   'TimeConstant', 0, [], 0);
    setpv('SF',   'TimeConstant', 0, [], 0);
    setpv('SD',   'TimeConstant', 0, [], 0);
    setpv('HCMCHICANE', 'TimeConstant', 0, [4 1;4 3;6 1], 0);   % [S 2] set as part of the HCM family
    %setpv('VCMCHICANE', 'TimeConstant', 0, [4 1;4 3;6 1], 0);  % no longer a family, use VCM
    fprintf('Done\n');
catch
    fprintf('\n      Error setting time constant and ramp rates set for BEND, QF, QD, QFA, QDA, SF, SD, and CHICANE magnets.\n\n');
end


% Set Superbend maximum current and ramprate
% Added by Christoph Steier, 2001-09-02
try
    fprintf('   6. Setting superbend magnet ramp rates (0.4 A/s) and limits (302 A) ... ');
    setpv('BEND', 'RampRate', 0.4, [4 2; 8 2; 12 2], 0);
    
    %setpv('BSC', 'Limit', 302, [4 2; 8 2; 12 2], 0);  % BSC family may disappear in the future   
    setpv('SR04C___BSC_P__AC02', 302);
    setpv('SR08C___BSC_P__AC02', 302);
    setpv('SR12C___BSC_P__AC02', 302);

    fprintf('Done\n');
catch
    fprintf('\n      Error setting ramp rate (0.4 A/s) and Limit (302 A) set for Superbend magnets.\n\n');
end


% QFA shunts off
try
    fprintf('   7. Switching QFA shunts off ... ');
    setqfashunt(1, 0, [], 0);
    setqfashunt(2, 0, [], 0);
    fprintf('Done\n');
catch
    fprintf('\n      Error switching QFA shunts off.\n\n');
end


% Set extra PS sum channels to zero
try
    fprintf('   8. Setting feed forward magnet sum channels to zero (HCM, VCM, QF, QD) ... ');
    setpv('HCM', 'FF1', 0);
    setpv('HCM', 'FF2', 0);
    setpv('VCM', 'FF1', 0);
    setpv('VCM', 'FF2', 0);

    % EPU Skew Quad Trim Coils
    setpv('SQEPU', 0);
    setpv('SQEPU', 'RampRate', 100); % set ramprate to fast
    setpv('SR04U___Q1FF___AC00', 0);
    setpv('SR04U___Q1M____AC00', 1);
    setpv('SR04U___Q2FF___AC00', 0);
    setpv('SR04U___Q2M____AC00', 0);
    setpv('SR11U___Q1FF___AC00', 0);
    setpv('SR11U___Q1M____AC01', 1);
    setpv('SR11U___Q2FF___AC00', 0);
    setpv('SR11U___Q2M____AC01', 1);

    setpv('QF', 'FF', 0);
    setpv('QD', 'FF', 0);
    fprintf('Done\n');
catch
    fprintf('\n      Error setting feed forward corrector magnet channels to zero.\n\n');
end


% Set corrector magnet trim channels to zero
% Added by Tom Scarvie, 2002-04-29
try
    fprintf('   9. Set corrector magnet trim channels to zero ... ');
    setpv('HCM', 'Trim', 0, [], 0);
    setpv('VCM', 'Trim', 0, [], 0);
    fprintf('Done\n');
catch
    fprintf('\n      Error setting corrector magnet trim channels to zero.\n\n');
end


% Set the maximum horizontal speed for the EPU in sector 4 with velocity profile on to 16.7 mm/s
% Added by Christoph Steier, 2000-11-14
% Updated from 3 to 16.7 mm/s on 2008-04-07
try
    fprintf('  10. Setting EPU 4.1, horizontal velocity profile restricted to 16.7 mm/s ... ');
    setpv('sr04u:Hor_profile_max_vel', 16.7);
    %setpv('sr11u1:Hor_profile_max_vel', 3.0);
    fprintf('Done\n');
catch
    fprintf('\n      Error setting EPU 4.1, horizontal velocity profile to 16.7 mm/s\n\n');
end


% Open the scrapers (BTS horizontal scrapers, JH scrapers, SR03 normal scrapers) 
try
    fprintf('  11. Setting the BTS and SR03 scrapers to 0 mm (full open)\n');
    fprintf('      Not changing the Jackson Hole scrapers ... ');
    setpv('BTS_____SCRAP1LAC01.VAL', 0);
    setpv('BTS_____SCRAP1RAC01.VAL', 0);
    setpv('BTS_____SCRAP2LAC01.VAL', 0);
    setpv('BTS_____SCRAP2RAC01.VAL', 0);
    %setpv('SR01C___SCRAP1BAC01.VAL', 0);
    %setpv('SR01C___SCRAP1TAC01.VAL', 0);
    %setpv('SR02C___SCRAP1BAC01.VAL', 0);
    %setpv('SR02C___SCRAP1TAC01.VAL', 0);
    %setpv('SR02C___SCRAP6TAC01.VAL', 0);
    setpv('SR03S___SCRAPT_AC01.VAL', 0);
    setpv('SR03S___SCRAPB_AC02.VAL', 0);
    setpv('SR03S___SCRAPH_AC00.VAL', 0);
    %setpv('SR12C___SCRAP6TAC01.VAL', 0);
    fprintf('Done\n');
catch
    fprintf('\n      Error setting the scrapers to 0 (open)\n\n');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% careful here - don't start homing until they're done moving from above %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Home the JH scrapers then reset to prior setting
try
    fprintf('  12. Homing the Jackson Hole scrapers\n');
    setpv('BTS_____SCRAP1LAC01.VAL', 0);
    setpv('BTS_____SCRAP1RAC01.VAL', 0);
    setpv('BTS_____SCRAP2LAC01.VAL', 0);
    setpv('BTS_____SCRAP2RAC01.VAL', 0);
    %setpv('SR01C___SCRAP1BAC01.VAL', 0);
    %setpv('SR01C___SCRAP1TAC01.VAL', 0);
    %setpv('SR02C___SCRAP1BAC01.VAL', 0);
    %setpv('SR02C___SCRAP1TAC01.VAL', 0);
    %setpv('SR02C___SCRAP6TAC01.VAL', 0);
    setpv('SR03S___SCRAPT_AC01.VAL', 0);
    setpv('SR03S___SCRAPB_AC02.VAL', 0);
    setpv('SR03S___SCRAPH_AC00.VAL', 0);
    %setpv('SR12C___SCRAP6TAC01.VAL', 0);
    fprintf('Done\n');
catch
    fprintf('\n      Error setting the scrapers to 0 (open)\n\n');
end


% Set all UDF fields
% if islabca
%     fprintf('  13. UDF fields not set!!! \n');
%     fprintf('      sca or MCA must be used to set the .UDF field. \n');
%     fprintf('      >> setpathals sca\n');
%     fprintf('      to change.\n');
% else
    try
        fprintf('  13. run "resetudferrors" to clear all the UDF errora. It will not be run here!!!\n');
        %fprintf('  13. Setting the UDF fields for all families to 0 ... ');
        %resetudferrors;
        %fprintf('Done\n');
    catch
        fprintf('\n      Error setting the UDF for all families\n\n');
    end
% end

% Quad FF multipliers
try
    fprintf('  14. Setting the FF multipliers for the QF  & QD  families to 1 ... ');
    setpv('QF', 'FFMultiplier', 1);
    setpv('QD', 'FFMultiplier', 1);
    fprintf('Done\n');
catch
    fprintf('\n      Error setting the FF multipliers for the QF & QD families\n\n');
end

% Corrector FF multipliers
try
    fprintf('  15. Setting the FF multipliers for the HCM & VCM families to 1 ... ');
    %setpv('HCM', 'FFMultiplier', 1);
    %setpv('VCM', 'FFMultiplier', 1);
    
    %EPU 4-1 and 4-2
    setpv('SR03C___HCM4M__AC00', 1);
    setpv('SR04U___HCM2M__AC00', 1);
    setpv('SR04C___HCM1M__AC00', 1);

    setpv('SR03C___VCM4M__AC00', 1);
    setpv('SR04U___VCM2M__AC00', 1);
    setpv('SR04C___VCM1M__AC00', 1);

    %SR06 IVID
    setpv('SR05C___HCM4M__AC00', 1);
    setpv('SR06U___HCM2M__AC00', 1);

    setpv('SR05C___VCM4M__AC00', 1);
    setpv('SR06U___VCM2M__AC00', 1);

    %EPU 11-1 and 11-2
    setpv('SR10C___HCM4M__AC00', 1);
    setpv('SR11U___HCM2M__AC00', 1);
    setpv('SR11C___HCM1M__AC00', 1);

    setpv('SR10C___VCM4M__AC00', 1);
    setpv('SR11U___VCM2M__AC00', 1);
    setpv('SR11C___VCM1M__AC00', 1);
    fprintf('Done\n');
catch
    fprintf('\n      Error setting the FF multipliers for the HCM & VCM families\n\n');
end

% setup FOFB parameters
FOFBFreq = 1000;
% PIDs below are known good values for user ops as of 8-1-05
HorP = 2;
HorI = 300;
HorD = 0.002;
VertP = 1;
VertI = 100;
VertD = 0.0015;
try
    setsp('SR01____FFBFREQAC00', FOFBFreq); % set freq
    fprintf('  16. Fast orbit feedback frequency is set to %.0f Hz.\n', getpv('SR01____FFBFREQAM00'));
    write_pid_ffb2_patch(HorP, HorI, HorD, VertP, VertI, VertD); % set PIDs
    fprintf('  17. Setting FFB gains to Horizontal P=%.2f, I=%.1f, D=%.4f;  Vertical P=%.2f, I=%.1f, D=%.4f\n', HorP, HorI, HorD, VertP, VertI, VertD);
catch
    disp('   Trouble setting Fast Orbit Feedback parameters!');
end

% Setup Third Harmonic Cavity defaults
fprintf('  18. Setting Third Harmonic Cavity defaults.\n');
setpv('SR02C___C1MPOS_AC00', 7.422);
setpv('SR02C___C1MERR_AC00', 1.265);
setpv('SR02C___C2MPOS_AC00', 6.860);
setpv('SR02C___C2MERR_AC00', 1.095);
setpv('SR02C___C3MPOS_AC00', 6.773);
setpv('SR02C___C3MERR_AC00', 1.195);


% DCCT2 Setup?


fprintf('\n');
fprintf('  SRINIT is done restoring machine defaults.\n');
fprintf('\n');


