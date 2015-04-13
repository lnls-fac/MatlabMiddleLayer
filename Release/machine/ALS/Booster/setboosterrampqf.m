function setboosterrampqf(T, Waveform, TableName, egul, eguf, IOCName)
%SETBOOSTERRAMPQF - Set the booster QF magnet ramp table (miniIOC)
%  setboosterrampqf(T, Waveform, TableName, egul, eguf, IOCName)
%  setboosterrampqf('Zero') -> Zero the BEND table
%  
%  INPUTS
%  1. T         - Time period for the Waveform [seconds]
%                 The maximum period for a 10,000 point table is
%                 2^15*10000*10e-9 = 3.2768 seconds
%  2. Waveform  - BEND waveform relative to egul, eguf
%  3. TableName - Optional input to specify a table name [string] 
%  4. egul      - Lower voltage minimum {Default:-10}
%  5. eguf      - Upper voltage maximum {Default: 10}
%  6. IOCName   - Optional override of 'BE0101-1.als.lbl.gov'
%
%  NOTES
%  1. Calls rampgentableload.c which in turn call the subroutine 
%     rampgenTableLoad.  mex rampgentableload.c will recompile both.
%
%  See also setboosterrampsf, setboosterrampsd

%  Written by Greg Portmann


if nargin < 1
    % Time period of the ramp [seconds]
    T =  .8;  % 1 second ramp period
    %T = 1.6;  % 2 second ramp period
end


% String commands
if ischar(T)
%     if any(strcmpi(T, {'Zero','Zeros','Stop'}))
%         setboosterrampbend(.8, zeros(1,10000), 'Zero table set by Matlab', -10, 10);
%     elseif strcmpi(T, 'Off')
%         setpv('BE0101-1:ENABLE_RAMP', 0);
%         fprintf('   Ramping for BEND disabled (BE0101-1:ENABLE_RAMP=0).\n');
%     elseif strcmpi(T, 'On')
%         setpv('BE0101-1:ENABLE_RAMP', 1);
%         fprintf('   Ramping for BEND enabled (BE0101-1:ENABLE_RAMP=1).\n');
%     else
        error('Unknown command');
%     end
%     return;
end


if nargin < 2
    Npts = 10000;
else
    Npts = length(Waveform);
end

if nargin < 3
    TableName = sprintf('QF Table from Matlab (%s)', computer);
end

if nargin < 4
    egul = -10;
end

if nargin < 5
    eguf = 10;
end

if nargin < 6
    IOCName = 'be0101-1.als.lbl.gov';
end
Channel = 1;


% Sample period = Ndelay*10 nanosecond
% Ndalay must be an integer < 2^15
Ndelay = T / Npts / 10e-9;

if abs(round(Ndelay) - Ndelay) > 1e-10
    % Only warn on small issues, not really small issues.
    fprintf('   Rounding the number of 10 nsec delay steps to an integer.\n');
end
Ndelay = round(Ndelay);

if Ndelay > (2^15 - 500)   % The 500 is just some margin
    error('The number of delay counts between table points is too large, %d, (greater than 2^15)', Ndelay);
end
    

% Make a table
t = linspace(0, T, Npts);


% For testing
if nargin < 2
    Amp = 9; 
    Waveform = Amp * triang(Npts) + 0.05;
end

% Plot
plot(t, Waveform);
xlabel('Time [Seconds]');
ylabel('[Volts]');
title(sprintf('QF Waveform, %d Points in Table,  %d Delay Counts', Npts, Ndelay));


% Last chance to say no
% tmp = questdlg('Change the booster QF ramp table?','setboosterrampqf','Yes','No','No');
% if ~strcmpi(tmp,'Yes')
%     fprintf('   No change made to booster QF ramp table.\n');
%     return
% end


%%%%%%%%%%%%%%
% Initialize %
%%%%%%%%%%%%%%

% Disable the ramp so that the number of points can be changed and the DAC can be enabled
setpv('BE0101-1:ENABLE_RAMP', 0);
%pause(.25);

% Enable the DAC 
setpv('BR1_____QFIE_REBC01', 1);

% Set the gain
Gain = 0.2;  
% setpv('BR1_____QFIE_GNAC01', Gain);

% The the number of points and number of delay steps between points
% Don't change the Npts without the ramp disabled
setpv('BE0101-1:SET_TABLE_LEN',   Npts);
setpv('BE0101-1:SET_TABLE_DELAY', Ndelay);

% Enable the ramping
setpv('BE0101-1:ENABLE_RAMP', 1);


%%%%%%%%%%%%%%%%%%%%%%%%% 
% Set the QF ramp table %
%%%%%%%%%%%%%%%%%%%%%%%%%
% If egul = 10 & eguf= -10, the waveform is in volts
rampgentableload(Waveform, IOCName, Channel, TableName, egul, eguf)


% Swap the tables
%pause(.25);
setpv('BE0101-1:SWAP_TABLE', 1);
%pause(.25);



% Check the final states
fprintf('   BR1_____QFIE_REBC01   = %d\n', getpv('BR1_____QFIE_REBC01'));
fprintf('   BR1_____QFIE_GNAC01   = %d\n', getpv('BR1_____QFIE_GNAC01'));
fprintf('   BE0101-1:ENABLE_RAMP     = %d\n', getpv('BE0101-1:ENABLE_RAMP'));
fprintf('   BE0101-1:SET_TABLE_LEN   = %d\n', getpv('BE0101-1:SET_TABLE_LEN'));
fprintf('   BE0101-1:SET_TABLE_DELAY = %d\n', getpv('BE0101-1:SET_TABLE_DELAY'));
fprintf('   BE0101-1:SWAP_TABLE      = %d\n', getpv('BE0101-1:SWAP_TABLE'));


