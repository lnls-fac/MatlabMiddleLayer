function [frequency amplitude phase] = calcnaff(Y, varargin)
% [nu amp phase] = calcnaff(Y,is_real, Win, nfreq)
%
%  INPUTS
%  1. Y  - vector (complex) to apply the transformation
%  2. is_real - flag indicating if the function shall betreated
%               as real by the algorithm {Default: false}
%  3. WindowType  - Window type - 0 {Default} no windowing
%                                 1 Window of Hann
%                                 2 etc
%  4. nfreq - Maximum number of fundamental frequencies to search for
%             10 {Default}
%  5. debug - 1 means debug flag turned on
%              0 {Default}
%
%  Optional Flags
%  'IsReal'  - if the function must be treated as a real function
%  'Debug'   - turn on deubbing flag
%  'NoDebug' - turn off deubbing flag
%  'Display' - print out results
%'NoDisplay' - do not print out results
%  'Hanning' - select Window of Hann, WindowType = 1
%  'Raw' or 'NoWindow' - select Window of Hann, WindowType = 0
%
%  OUTPUTS
%  1. frequency - frequency vector with sorted amplitude
%                 by default the algorithm tries to compute the 10 first fundamental
%                 frequencies of the system.
%  2. amplitude - amplitudes associated with fundamental frequencies
%  3. phase - phases assocaited with fundamental frequencies
%
%  NOTES
%  1. Mimimum number of turn is 67
%  2. Number of turn has to be a just above a multiple of 6 for internal optimization
%  reason. Example: n = 1027. (n-1) / 6 = 171.
%
%  Examples
%  NT = 9997; % (NT-1) divided by 6
%  simple quasiperiodic (even period) motion
%  y =2+0.1*cos(pi*(0:NT-1))+0.00125*cos(pi/3*(0:NT-1));
%  yp=2+0.1*sin(pi*(0:NT-1))+0.00125*sin(pi/3*(0:NT-1));
%
%  [nu ampl phase] = calcnaff(y + 1i*yp,false,1); % with windowing


% Written by Laurent S. Nadolski
% April 6th, 2007
% Modification September 2009:
%  test if constant data or nan data


is_real = false;
DebugFlag  = 0;
WindowType = 1;
nfreq = 10;
DisplayFlag = 0;

for ik = length(varargin):-1:1
    if strcmpi(varargin{ik},'Debug')
        DebugFlag = 1;
        varargin(ik) = [];
    elseif strcmpi(varargin{ik},'NoDebug')
        DebugFlag = 0;
        varargin(ik) = [];
    elseif strcmpi(varargin{ik},'Display')
        DisplayFlag = 1;
        varargin(ik) = [];
    elseif strcmpi(varargin{ik},'NoDisplay')
        DisplayFlag = O;
        varargin(ik) = [];
    elseif strcmpi(varargin{ik},'Hanning')
        WindowType = 1;
        varargin(ik) = [];
    elseif strcmpi(varargin{ik},'IsReal')
        is_real = true;
        varargin(ik) = [];
    elseif strcmpi(varargin{ik},'NoWindow') || strcmpi(varargin{ik},'Raw')
        WindowType = 0;
        varargin(ik) = [];
    end
end

% If the function is real:
if length(varargin) >= 1
    is_real = varargin{1};
end

if length(varargin) >= 2
    WindowType = varargin{2};
end

if length(varargin) >= 3
    nfreq = varargin{3};
end

if length(varargin) >= 4
    DebugFlag = varargin{4};
end

if length(varargin) >= 5
    error('Too many argument');
end

if mod(length(Y)-1,6)
    error('Number of data minus 1 is not a multiple of 6.');
end

if any(isnan(Y(1,:)))
    fprintf('Warning Y contains NaNs\n');
    frequency =NaN; amplitude = NaN;  phase = NaN;
elseif (std(Y) == 0)
    fprintf('Warning data are constant\n');
    frequency = 0; amplitude = 0;  phase = 0;
else
    RY = real(Y);
    IY = imag(Y);
    [frequency amplitude phase] = nafflib(RY, IY, is_real, WindowType, nfreq, DebugFlag);
    if DisplayFlag
        fprintf('*** Naff run on %s\n', datestr(clock))
        for k = 1:length(frequency)
            fprintf('nu(%d) =% .15f amplitude = % .15f phase = % .15f \n', ...
                k, frequency(k), amplitude(k), phase(k));
        end
    end
end
