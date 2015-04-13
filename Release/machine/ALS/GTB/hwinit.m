function hwinit(varargin)
%HWINIT - Hardware initialization script for the GTB


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


fprintf('   Initializing GTB parameters (hwinit)\n')



% Set corrector magnets
try
    fprintf('   1. Setting GTB magnets HCM, VCM, Q, and BEND to a 10 Hz scan rate on the monitors ... ');
    setpv(family2channel('HCM',  'Monitor'), 'SCAN', 9);
    setpv(family2channel('VCM',  'Monitor'), 'SCAN', 9);
    setpv(family2channel('Q',    'Monitor'), 'SCAN', 9);
    setpv(family2channel('BEND', 'Monitor'), 'SCAN', 9);
    fprintf('Done\n');
catch
    fprintf('\n   Error setting .SCAN field of one of the GTB magnet families (BEND, Q, HCM, or VCM).\n');
end


% Set BPMs
try
    fprintf('   2. Setting GTB BPMs to a 10 Hz scan rate ... ');
    setpv(family2channel('BPMx'),'SCAN', 9);
    setpv(family2channel('BPMy'),'SCAN', 9);
    fprintf('Done\n');
catch
    fprintf('\n   Error setting .SCAN field of BTS BPMs.\n');
end


% Set all UDF fields
% if islabca
%     fprintf('  14. UDF fields not set!!! \n');
%     fprintf('      sca or MCA must be used to set the .UDF field. \n');
%     fprintf('      >> setpathals sca\n');
%     fprintf('      to change.\n');
% else
    try
        fprintf('   3. Setting the UDF fields for all families to 0 ... ');
        resetudferrors;
        fprintf('Done\n');
    catch
        fprintf('\n   Error setting the UDF for all families\n');
    end
% end


fprintf('\n');


