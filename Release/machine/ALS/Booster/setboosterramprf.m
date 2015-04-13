function setboosterramprf(T, Waveform, TableName, egul, eguf, IOCName)
%SETBOOSTERRAMPRF - Set the booster RF ramp table
%  setboosterramprf(T, Waveform, TableName, egul, eguf, IOCName)
%  setboosterramprf('Zero') -> Zero the RF table
%  
%  INPUTS
%  1. T         - Time period for the Waveform [seconds]
%                 The maximum period for a 10,000 point table is
%                 2^15*10000*10e-9 = 3.2768 seconds
%  2. Waveform  - RF waveform relative to egul, eguf
%  3. TableName - Optional input to specify a table name [string] 
%  4. egul      - Lower voltage minimum {Default:-10}
%  5. eguf      - Upper voltage maximum {Default: 10}
%  6. IOCName   - Optional override of 'li14-40.als.lbl.gov'
%
%  NOTES
%  1. Calls rampgentableload.c which in turn call the subroutine 
%     rampgenTableLoad.  mex rampgentableload.c will recompile both.
%
%  See also setboosterrampsf, setboosterrampsd
%
%  Written by Greg Portmann


if nargin < 1
    % Time period of the ramp [seconds]
    T =  .8;  % 1 second ramp period
    %T = 1.6;  % 2 second ramp period
end


% String commands
if ischar(T)
    if any(strcmpi(T, {'Zero','Zeros','Stop'}))
        setboosterramprf(.8, zeros(1,10000), 'Zero table set by Matlab', -10, 10);
    elseif strcmpi(T, 'Off')
        setpv('li14-40:ENABLE_RAMP', 0);
        fprintf('   Ramping for RF disabled (li14-40:ENABLE_RAMP=0).\n');
    elseif strcmpi(T, 'On')
        setpv('li14-40:ENABLE_RAMP', 1);
        fprintf('   Ramping for RF enabled (li14-40:ENABLE_RAMP=1).\n');
    else
        error('Unknown command');
    end
    return;
end


if nargin < 2
    Npts = 10000;
else
    Npts = length(Waveform);
end

if nargin < 3
    TableName = sprintf('RF Table from Matlab (%s)', computer);
end

if nargin < 4
    egul = -10;
end

if nargin < 5
    eguf = 10;
end

if nargin < 6
    % b0101-1.als.lbl.gov for HCM1-2
    % b0101-3.als.lbl.gov for VCM1-2
    % b0102-3.als.lbl.gov for HCM2-3
    % b0102-5.als.lbl.gov for VCM2-3
    % li14-40.als.lbl.gov for RF
    IOCName = 'li14-40.als.lbl.gov';
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
    %Amp = 1;    % Amplitude/2 in volts
    %Waveform = Amp - Amp * chirp(t, 8/T/10, 1, 8/T);

    Amp = 5.2;  % 10 KWatts
    Waveform = Amp * triang(Npts);

    Waveform = 2.2 * triang(Npts) + 3;
end


% Force the last point in the table to zero.
%Waveform(end) = 0;


% Plot
plot(t, Waveform);
xlabel('Time [Seconds]');
ylabel('[Volts]');
title(sprintf('RF Waveform, %d Points in Table,  %d Delay Counts', Npts, Ndelay));


% Last chance to say no
tmp = questdlg('Change the booster RF ramp table?','setboosterramprf','Yes','No','No');
if ~strcmpi(tmp,'Yes')
    fprintf('   No change made to booster RF ramp table.\n');
    return
end


% Clear UDF errors
setpv('BR4_____XMIT___REBC01.UDF', 0);
setpv('BR4_____XMIT___GNAC01.UDF', 0);
setpv('li14-40:ENABLE_RAMP.UDF', 0);
setpv('li14-40:SET_TABLE_LEN.UDF', 0);
setpv('li14-40:SET_TABLE_DELAY.UDF', 0);
setpv('li14-40:SWAP_TABLE.UDF', 0);


%%%%%%%%%%%%%%
% Initialize %
%%%%%%%%%%%%%%

% Disable the ramp so that the number of points can be changed and the DAC can be enabled
%setpv('li14-40:ENABLE_RAMP', 0);
%pause(.25);

% Enable the DAC 
setpv('BR4_____XMIT___REBC01', 1);

% Set the gain
Gain = .6;  % Normally 1, but set it to .6 (.66 is max) for RF window protection
setpv('BR4_____XMIT___GNAC01', Gain);

% The the number of points and number of delay steps between points
% Don't change the Npts without the ramp disabled
setpv('li14-40:SET_TABLE_LEN',   Npts);
setpv('li14-40:SET_TABLE_DELAY', Ndelay);

% Enable the ramping
setpv('li14-40:ENABLE_RAMP', 1);


%%%%%%%%%%%%%%%%%%%%%%%%% 
% Set the RF ramp table %
%%%%%%%%%%%%%%%%%%%%%%%%%
% If egul = 10 & eguf= -10, the waveform is in volts
rampgentableload(Waveform/Gain, IOCName, Channel, TableName, egul, eguf)


% Swap the tables
pause(.25);
setpv('li14-40:SWAP_TABLE', 1);
pause(.25);


% Check the final states
fprintf('   BR4_____XMIT___REBC01   = %d\n', getpv('BR4_____XMIT___REBC01'));
fprintf('   BR4_____XMIT___GNAC01   = %d\n', getpv('BR4_____XMIT___GNAC01'));
fprintf('   li14-40:ENABLE_RAMP     = %d\n', getpv('li14-40:ENABLE_RAMP'));
fprintf('   li14-40:SET_TABLE_LEN   = %d\n', getpv('li14-40:SET_TABLE_LEN'));
fprintf('   li14-40:SET_TABLE_DELAY = %d\n', getpv('li14-40:SET_TABLE_DELAY'));
fprintf('   li14-40:SWAP_TABLE      = %d\n', getpv('li14-40:SWAP_TABLE'));


